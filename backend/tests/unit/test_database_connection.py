from unittest.mock import MagicMock

import psycopg
import pytest
from fastapi import Depends, FastAPI
from fastapi.testclient import TestClient

from app.config.settings import Settings, get_settings
from app.dependencies.container import get_database_connection
from app.infrastructure.database import connection as database


@pytest.fixture
def connect(monkeypatch):
    connect = MagicMock()
    connect.return_value.__enter__.return_value = connect.return_value
    monkeypatch.setattr(database.psycopg, "connect", connect)
    return connect


def test_connection_context_is_released_on_success(connect):
    settings = Settings(database_url="postgresql://localhost/test")
    with database.database_connection(settings) as connection:
        assert connection is connect.return_value.__enter__.return_value
    connect.assert_called_once_with(settings.database_url, connect_timeout=3)
    connect.return_value.__exit__.assert_called_once_with(None, None, None)
    connect.return_value.close.assert_called_once()


def test_connection_context_receives_failure_for_rollback(connect):
    error = RuntimeError("operation failed")
    with pytest.raises(RuntimeError, match="operation failed"):
        with database.database_connection(Settings(database_url="postgresql://localhost/test")):
            raise error
    args = connect.return_value.__exit__.call_args.args
    assert args[:2] == (RuntimeError, error)
    connect.return_value.close.assert_called_once()


def test_connection_is_closed_when_commit_fails(connect):
    connection = connect.return_value
    connection.commit.side_effect = psycopg.OperationalError("commit failed")
    connection.__exit__.side_effect = lambda *_: connection.commit()

    with pytest.raises(psycopg.OperationalError, match="commit failed"):
        with database.database_connection(Settings(database_url="postgresql://localhost/test")):
            pass

    connection.commit.assert_called_once()
    connection.close.assert_called_once()


def test_connection_failure_propagates(connect):
    connect.side_effect = psycopg.OperationalError("unavailable")
    with pytest.raises(psycopg.OperationalError):
        with database.database_connection(Settings(database_url="postgresql://localhost/test")):
            pytest.fail("No connection should be yielded")


@pytest.mark.parametrize("result, expected", [((1,), True), ((0,), False), (None, False)])
def test_database_probe_uses_shared_connection(connect, result, expected, monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "postgresql://localhost/test")
    connection = connect.return_value.__enter__.return_value
    cursor = connection.cursor.return_value.__enter__.return_value
    cursor.fetchone.return_value = result
    assert database.check_database_connection() is expected
    cursor.execute.assert_called_once_with("SELECT 1")
    connection.cursor.return_value.__exit__.assert_called_once_with(None, None, None)
    connect.return_value.__exit__.assert_called_once_with(None, None, None)
    connect.return_value.close.assert_called_once()


@pytest.mark.parametrize("fail", [False, True])
def test_injected_connection_cleanup(connect, fail):
    app = FastAPI()
    settings = Settings(database_url="postgresql://localhost/test")
    app.dependency_overrides[get_settings] = lambda: settings

    @app.get("/probe")
    def probe(connection=Depends(get_database_connection)):
        assert connection is connect.return_value
        if fail:
            raise RuntimeError("request failed")
        return {"ok": True}

    with TestClient(app, raise_server_exceptions=False) as client:
        response = client.get("/probe")
    assert response.status_code == (500 if fail else 200)
    connect.assert_called_once_with(settings.database_url, connect_timeout=3)
    connect.return_value.__exit__.assert_not_called()
    connect.return_value.close.assert_called_once()

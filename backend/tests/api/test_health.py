from unittest.mock import Mock

import psycopg
import pytest
from fastapi.testclient import TestClient

from app.dependencies import container
from app.main import app

client = TestClient(app)


def test_health_endpoint_does_not_access_database(monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    connect = Mock(side_effect=AssertionError("Liveness must not connect to PostgreSQL"))
    monkeypatch.setattr(psycopg, "connect", connect)
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
    connect.assert_not_called()


@pytest.mark.parametrize("available", [True, False])
def test_readiness_endpoint(monkeypatch, available):
    check = Mock(return_value=available)
    monkeypatch.setattr(container, "check_database_connection", check)
    response = client.get("/health/ready")
    assert response.status_code == (200 if available else 503)
    assert response.json() == (
        {"status": "ready", "database": "ok"} if available
        else {"status": "not_ready", "database": "unavailable"}
    )
    check.assert_called_once()


def test_readiness_database_error(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "postgresql://localhost/test")
    monkeypatch.setattr(psycopg, "connect", Mock(side_effect=psycopg.OperationalError("private detail")))
    response = client.get("/health/ready")
    assert response.status_code == 503
    assert response.json() == {"status": "not_ready", "database": "unavailable"}


def test_readiness_without_database_configuration(monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    connect = Mock(side_effect=AssertionError("Missing configuration must fail before connecting"))
    monkeypatch.setattr(psycopg, "connect", connect)
    response = client.get("/health/ready")
    assert response.status_code == 503
    assert response.json() == {"status": "not_ready", "database": "unavailable"}
    connect.assert_not_called()


@pytest.mark.parametrize("path", ["/api/v1/health", "/api/v1/health/ready"])
def test_health_is_not_versioned(path):
    assert client.get(path).status_code == 404

import pytest

from app.config.settings import ConfigurationError, Settings, get_settings


def test_settings_read_current_environment(monkeypatch):
    monkeypatch.delenv("DATABASE_URL", raising=False)
    assert get_settings().database_url is None
    url = "postgresql://localhost/test"
    monkeypatch.setenv("DATABASE_URL", url)
    assert get_settings().require_database_url() == url
    assert url not in repr(get_settings())


@pytest.mark.parametrize("url", [None, "", "   "])
def test_database_operations_require_configuration(url):
    with pytest.raises(ConfigurationError, match="DATABASE_URL must be set"):
        Settings(database_url=url).require_database_url()

"""Configuration issue de l'environnement, validée lors d'une opération en base."""

import os
from dataclasses import dataclass, field


class ConfigurationError(RuntimeError):
    """Un paramètre requis pour le backend est absent."""


@dataclass(frozen=True)
class Settings:
    database_url: str | None = field(default=None, repr=False)

    def require_database_url(self) -> str:
        if not self.database_url or not self.database_url.strip():
            raise ConfigurationError("DATABASE_URL must be set for database operations")
        return self.database_url


def get_settings() -> Settings:
    return Settings(database_url=os.getenv("DATABASE_URL"))

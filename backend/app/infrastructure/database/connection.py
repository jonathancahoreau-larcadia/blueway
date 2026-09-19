from collections.abc import Iterator
from contextlib import closing, contextmanager

import psycopg

from app.config.settings import Settings, get_settings


@contextmanager
def database_connection(
    settings: Settings | None = None, *, transactional: bool = True,
) -> Iterator[psycopg.Connection]:
    """Ferme toujours la connexion ; utilise le contexte transactionnel si demandé."""
    settings = settings if settings is not None else get_settings()
    with closing(psycopg.connect(
        settings.require_database_url(), connect_timeout=3,
    )) as connection:
        if transactional:
            with connection:
                yield connection
        else:
            yield connection


def check_database_connection(settings: Settings | None = None) -> bool:
    """Vérifie la réponse de PostgreSQL avec le cycle de connexion commun."""
    with database_connection(settings) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()

    return result == (1,)

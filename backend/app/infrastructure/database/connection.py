import os

import psycopg


def check_database_connection() -> bool:
    """Check that the PostgreSQL database is reachable."""

    database_url = os.environ["DATABASE_URL"]

    with psycopg.connect(
        database_url,
        connect_timeout=3,
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()

    return result == (1,)

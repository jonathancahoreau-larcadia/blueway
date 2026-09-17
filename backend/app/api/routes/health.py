from fastapi import APIRouter, HTTPException
from psycopg import Error as PsycopgError

from app.infrastructure.database.connection import check_database_connection


router = APIRouter()


@router.get("/health")
def health_check():
    try:
        database_ok = check_database_connection()

    except (PsycopgError, KeyError) as exc:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable",
        ) from exc

    if not database_ok:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable",
        )

    return {
        "status": "ok",
        "database": "ok",
    }

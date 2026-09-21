from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.infrastructure.adapters.firebase_auth_adapter import FirebaseAuthAdapter


bearer_scheme = HTTPBearer(auto_error=False)


def get_current_identity(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
) -> dict:
    if credentials is None:
        raise HTTPException(
            status_code=401,
            detail="Authentication required",
        )

    adapter = FirebaseAuthAdapter()

    try:
        identity = adapter.verify_token(credentials.credentials)
    except Exception:
        raise HTTPException(
            status_code=401,
            detail="Invalid authentication token",
        )

    return identity

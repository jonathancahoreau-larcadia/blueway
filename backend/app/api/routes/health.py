from fastapi import APIRouter

router = APIRouter()


@router.get("/health")
# Verify that the API is running
def health_check():
    return {
        "status": "ok"
    }

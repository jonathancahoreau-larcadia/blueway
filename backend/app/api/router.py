from fastapi import APIRouter

from app.api.routes.users import router as users_router


router = APIRouter(prefix="/api/v1")

router.include_router(users_router)

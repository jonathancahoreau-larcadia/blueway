from fastapi import FastAPI
from app.api.router import router as api_router
from app.api.routes.health import router as health_router
from app.domain.errors import ReportNotFoundError
from app.api.errors.handlers import report_not_found_handler


app = FastAPI()

app.include_router(health_router)
app.include_router(api_router)
app.add_exception_handler(ReportNotFoundError, report_not_found_handler)

from fastapi.responses import JSONResponse
from app.domain.errors import ReportNotFoundError


def report_not_found_handler(request, exc):
    return JSONResponse(
        status_code=404,
        content={
            "error": {
                "code": "REPORT_NOT_FOUND",
                "message": str(exc),
                "details": None
            }
        }
    )

from fastapi.responses import JSONResponse

from app.domain.errors import (
    EmailNotVerifiedError,
    ReportNotFoundError,
    UserAlreadyExistsError,
    UserNotFoundError,
    UsernameAlreadyExistsError,
)


def report_not_found_handler(request, exc: ReportNotFoundError):
    return JSONResponse(
        status_code=404,
        content={
            "error": {
                "code": "REPORT_NOT_FOUND",
                "message": str(exc),
                "details": None,
            }
        },
    )


def email_not_verified_handler(request, exc: EmailNotVerifiedError):
    return JSONResponse(
        status_code=403,
        content={
            "error": {
                "code": "EMAIL_NOT_VERIFIED",
                "message": str(exc),
                "details": None,
            }
        },
    )


def user_already_exists_handler(request, exc: UserAlreadyExistsError):
    return JSONResponse(
        status_code=409,
        content={
            "error": {
                "code": "USER_ALREADY_EXISTS",
                "message": str(exc),
                "details": None,
            }
        },
    )


def username_already_exists_handler(request, exc: UsernameAlreadyExistsError):
    return JSONResponse(
        status_code=409,
        content={
            "error": {
                "code": "USERNAME_ALREADY_EXISTS",
                "message": str(exc),
                "details": None,
            }
        },
    )


def user_not_found_handler(request, exc: UserNotFoundError):
    return JSONResponse(
        status_code=404,
        content={
            "error": {
                "code": "USER_NOT_FOUND",
                "message": str(exc),
                "details": None,
            }
        },
    )

from fastapi import FastAPI

from app.api.errors.handlers import (
    email_not_verified_handler,
    inactive_user_handler,
    report_client_id_conflict_handler,
    report_not_found_handler,
    report_validation_handler,
    user_already_exists_handler,
    user_not_found_handler,
    username_already_exists_handler,
)
from app.api.router import router as api_router
from app.api.routes.health import router as health_router
from app.domain.errors import (
    EmailNotVerifiedError,
    InactiveUserError,
    InvalidObservedAtError,
    InvalidReportCategoryError,
    InvalidReportDescriptionError,
    InvalidReportPositionError,
    ReportClientIdConflictError,
    ReportNotFoundError,
    UserAlreadyExistsError,
    UserNotFoundError,
    UsernameAlreadyExistsError,
)


app = FastAPI()

app.include_router(health_router)
app.include_router(api_router)

app.add_exception_handler(
    ReportNotFoundError,
    report_not_found_handler,
)

app.add_exception_handler(
    InvalidReportCategoryError,
    report_validation_handler,
)

app.add_exception_handler(
    InvalidReportDescriptionError,
    report_validation_handler,
)

app.add_exception_handler(
    InvalidReportPositionError,
    report_validation_handler,
)

app.add_exception_handler(
    InvalidObservedAtError,
    report_validation_handler,
)

app.add_exception_handler(
    ReportClientIdConflictError,
    report_client_id_conflict_handler,
)

app.add_exception_handler(
    InactiveUserError,
    inactive_user_handler,
)

app.add_exception_handler(
    EmailNotVerifiedError,
    email_not_verified_handler,
)

app.add_exception_handler(
    UserAlreadyExistsError,
    user_already_exists_handler,
)

app.add_exception_handler(
    UsernameAlreadyExistsError,
    username_already_exists_handler,
)

app.add_exception_handler(
    UserNotFoundError,
    user_not_found_handler,
)

from fastapi import APIRouter, Depends, Response, status

from app.api.dependencies.auth import get_current_identity
from app.api.schemas.report import (
    GeoJSONPoint,
    ReportCreateRequest,
    ReportResponse,
)
from app.application.services.create_report import CreateReport
from app.infrastructure.repositories.postgresql_report_repository import (
    PostgreSQLReportRepository,
)
from app.infrastructure.repositories.postgresql_user_repository import (
    PostgreSQLUserRepository,
)


router = APIRouter(
    prefix="/reports",
    tags=["reports"],
)


@router.post(
    "",
    response_model=ReportResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_report(
    request: ReportCreateRequest,
    response: Response,
    identity: dict = Depends(get_current_identity),
):
    user_repository = PostgreSQLUserRepository()
    report_repository = PostgreSQLReportRepository()

    create_report_service = CreateReport(
        user_repository=user_repository,
        report_repository=report_repository,
    )

    longitude = request.final_position.coordinates[0]
    latitude = request.final_position.coordinates[1]

    result = create_report_service.execute(
        firebase_uid=identity["uid"],
        client_report_id=request.client_report_id,
        category=request.category,
        longitude=longitude,
        latitude=latitude,
        observed_at=request.observed_at,
        description=request.description,
    )

    if not result.created:
        response.status_code = status.HTTP_200_OK

    report = result.report

    return ReportResponse(
        id=report.id,
        author_id=report.author_id,
        client_report_id=report.client_report_id,
        category=report.category,
        positioning_mode=report.positioning_mode,
        description=report.description,
        final_position=GeoJSONPoint(
            type="Point",
            coordinates=[
                report.longitude,
                report.latitude,
            ],
        ),
        observed_at=report.observed_at,
        expires_at=report.expires_at,
        status=report.status,
        version=report.version,
        created_at=report.created_at,
        updated_at=report.updated_at,
    )

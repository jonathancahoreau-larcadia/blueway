from dataclasses import dataclass
from datetime import datetime
from uuid import UUID

from app.application.ports.report_repository import ReportRepository
from app.application.ports.user_repository import UserRepository
from app.domain.errors import (
    InactiveUserError,
    ReportClientIdConflictError,
    UserNotFoundError,
)
from app.domain.report import Report, ReportCategory
from app.domain.user import UserStatus


@dataclass
class CreateReportResult:
    report: Report
    created: bool


class CreateReport:
    def __init__(
        self,
        user_repository: UserRepository,
        report_repository: ReportRepository,
    ):
        self.user_repository = user_repository
        self.report_repository = report_repository

    def execute(
        self,
        firebase_uid: str,
        client_report_id: UUID,
        category: ReportCategory,
        longitude: float,
        latitude: float,
        observed_at: datetime,
        description: str | None = None,
    ) -> CreateReportResult:
        user = self.user_repository.get_by_firebase_uid(
            firebase_uid
        )

        if user is None:
            raise UserNotFoundError(
                "BlueWay user not found"
            )

        if user.status != UserStatus.ACTIVE:
            raise InactiveUserError(
                "user is not active"
            )

        existing_report = (
            self.report_repository.get_by_client_report_id(
                author_id=user.id,
                client_report_id=client_report_id,
            )
        )

        if existing_report is not None:
            if not existing_report.matches_manual_creation(
                category=category,
                longitude=longitude,
                latitude=latitude,
                observed_at=observed_at,
                description=description,
            ):
                raise ReportClientIdConflictError(
                    "client_report_id already used with different data"
                )

            return CreateReportResult(
                report=existing_report,
                created=False,
            )

        report = Report.create_manual(
            author_id=user.id,
            client_report_id=client_report_id,
            category=category,
            longitude=longitude,
            latitude=latitude,
            observed_at=observed_at,
            description=description,
        )

        saved_report = self.report_repository.save(
            report
        )

        return CreateReportResult(
            report=saved_report,
            created=True,
        )

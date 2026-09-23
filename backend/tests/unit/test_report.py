from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

from app.domain.report import (
    Report,
    ReportCategory,
    ReportPositioningMode,
    ReportStatus,
)


def test_create_manual_report():
    author_id = uuid4()
    client_report_id = uuid4()
    observed_at = datetime.now(UTC) - timedelta(minutes=5)

    report = Report.create_manual(
        author_id=author_id,
        client_report_id=client_report_id,
        category=ReportCategory.POLLUTION,
        longitude=5.37,
        latitude=43.29,
        observed_at=observed_at,
        description="Pollution de surface visible",
    )

    assert isinstance(report.id, UUID)

    assert report.author_id == author_id
    assert report.client_report_id == client_report_id

    assert report.category == ReportCategory.POLLUTION
    assert report.description == "Pollution de surface visible"

    assert report.longitude == 5.37
    assert report.latitude == 43.29

    assert report.observed_at == observed_at
    assert report.expires_at == observed_at + timedelta(hours=24)

    assert report.positioning_mode == ReportPositioningMode.MANUAL
    assert report.status == ReportStatus.ACTIVE
    assert report.version == 1

    assert isinstance(report.created_at, datetime)
    assert isinstance(report.updated_at, datetime)

    assert report.removed_at is None

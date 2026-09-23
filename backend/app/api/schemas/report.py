from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from app.domain.report import (
    ReportCategory,
    ReportPositioningMode,
    ReportStatus,
)


class GeoJSONPoint(BaseModel):
    model_config = ConfigDict(extra="forbid")

    type: Literal["Point"]
    coordinates: list[float] = Field(
        min_length=2,
        max_length=2,
    )


class ReportCreateRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    client_report_id: UUID
    category: ReportCategory
    description: str | None = Field(
        default=None,
        max_length=250,
    )
    final_position: GeoJSONPoint
    observed_at: datetime


class ReportResponse(BaseModel):
    id: UUID
    author_id: UUID | None
    client_report_id: UUID
    category: ReportCategory
    positioning_mode: ReportPositioningMode
    description: str | None
    final_position: GeoJSONPoint
    observed_at: datetime
    expires_at: datetime
    status: ReportStatus
    version: int
    created_at: datetime
    updated_at: datetime

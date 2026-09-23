from abc import ABC, abstractmethod
from uuid import UUID

from app.domain.report import Report


class ReportRepository(ABC):
    @abstractmethod
    def get_by_client_report_id(
        self,
        author_id: UUID,
        client_report_id: UUID,
    ) -> Report | None:
        pass

    @abstractmethod
    def save(self, report: Report) -> Report:
        pass

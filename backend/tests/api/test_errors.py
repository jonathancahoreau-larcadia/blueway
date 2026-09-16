from fastapi.testclient import TestClient

from app.main import app
from app.domain.errors import ReportNotFoundError


client = TestClient(app)


@app.get("/test-report-not-found")
def trigger_report_not_found():
    raise ReportNotFoundError("Report not found")


def test_report_not_found_handler():
    response = client.get("/test-report-not-found")

    assert response.status_code == 404
    assert response.json()["error"]["code"] == "REPORT_NOT_FOUND"
    assert response.json()["error"]["message"] == "Report not found"
    assert response.json()["error"]["details"] is None

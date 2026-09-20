from app.api.router import router


def test_api_router_is_prepared_without_business_routes():
    assert router.prefix == "/api/v1"
    assert router.routes == []

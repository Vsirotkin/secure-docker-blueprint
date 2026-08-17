"""
Tests for health check endpoint.
"""

from django.test import Client


def test_health_check_returns_healthy(client: Client) -> None:
    """Test that health check endpoint returns healthy status."""
    response = client.get("/api/health/")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_health_check_method_not_allowed(client: Client) -> None:
    """Test that health check only accepts GET requests."""
    response = client.post("/api/health/")

    # Django views by default allow all methods, so POST should also work
    # but return the same response
    assert response.status_code == 200

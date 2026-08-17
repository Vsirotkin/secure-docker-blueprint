"""
Tests for API root endpoint.
"""

from django.test import Client


def test_api_root_returns_welcome_message(client: Client) -> None:
    """Test that API root returns welcome message with correct structure."""
    response = client.get("/api/")

    assert response.status_code == 200

    data = response.json()
    assert "message" in data
    assert data["message"] == "Welcome to Secure Django API"

    assert "version" in data
    assert data["version"] == "0.1.0"

    assert "endpoints" in data
    assert "health" in data["endpoints"]
    assert "admin" in data["endpoints"]

    assert data["endpoints"]["health"] == "/api/health/"
    assert data["endpoints"]["admin"] == "/admin/"


def test_api_root_response_structure(client: Client) -> None:
    """Test that API root response has all required fields."""
    response = client.get("/api/")
    data = response.json()

    required_fields = ["message", "version", "endpoints"]
    for field in required_fields:
        assert field in data, f"Missing required field: {field}"

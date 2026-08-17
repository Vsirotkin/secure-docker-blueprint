"""
Pytest fixtures for Django tests.
"""

import pytest
from django.test import Client


@pytest.fixture
def client() -> Client:
    """Django test client for making HTTP requests."""
    return Client()

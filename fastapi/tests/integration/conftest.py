"""Integration tests conftest - uses real Supabase."""

import os
import pytest
from dotenv import load_dotenv

# Load real .env for integration tests FIRST
load_dotenv(override=True)


@pytest.fixture(autouse=True)
def clear_settings_for_integration():
    """Clear settings cache and use real .env for integration tests."""
    from app.core.config import clear_settings_cache
    clear_settings_cache()
    yield
    clear_settings_cache()

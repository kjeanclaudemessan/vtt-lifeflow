"""VTT FastAPI Template - Test configuration."""

import os
import sys
import time

import pytest
from fastapi.testclient import TestClient
from unittest.mock import MagicMock, patch

# Force test environment variables BEFORE any import
# These override .env file
_TEST_ENV = {
    "APP_NAME": "VTT FastAPI Template Test",
    "APP_ENV": "development",
    "DEBUG": "true",
    "API_V1_PREFIX": "/api/v1",
    "SUPABASE_URL": "https://test.supabase.co",
    "SUPABASE_ANON_KEY": "test-anon-key-for-testing",
    "SUPABASE_SERVICE_ROLE_KEY": "test-service-role-key-for-testing",
    "JWT_SECRET": "test-jwt-secret-key-for-testing-purposes-only-minimum-32-chars",
    "JWT_ALGORITHM": "HS256",
    "MONEROO_WEBHOOK_SECRET": "test-moneroo-secret",
    # Enable AI Agent module for testing
    "AI_AGENT_ENABLED": "true",
}


@pytest.fixture(autouse=True)
def setup_test_env(request, monkeypatch):
    """Set test environment for each test (except integration tests)."""
    # Skip for integration tests - they use real .env
    if "integration" in str(request.fspath):
        return
    
    for key, value in _TEST_ENV.items():
        monkeypatch.setenv(key, value)
    
    # Clear settings cache to force reload with test env
    from app.core.config import clear_settings_cache
    clear_settings_cache()


@pytest.fixture(scope="session")
def test_settings():
    """Get settings for testing."""
    # Apply test env
    os.environ.update(_TEST_ENV)
    from app.core.config import Settings
    return Settings()


@pytest.fixture
def mock_supabase():
    """Mock Supabase client."""
    mock_client = MagicMock()
    mock_admin = MagicMock()
    
    # Import the module first to ensure it's loaded
    import app.db.supabase as supabase_module
    
    with patch.object(supabase_module, "_supabase_client", mock_client), \
         patch.object(supabase_module, "_supabase_admin_client", mock_admin), \
         patch.object(supabase_module, "get_supabase", return_value=mock_client), \
         patch.object(supabase_module, "get_supabase_admin", return_value=mock_admin), \
         patch.object(supabase_module, "init_supabase"), \
         patch.object(supabase_module, "close_supabase"):
        yield mock_client, mock_admin


@pytest.fixture
def client(mock_supabase):
    """Test client with mocked dependencies."""
    from app.main import create_app
    
    app = create_app()
    
    with TestClient(app) as test_client:
        yield test_client


@pytest.fixture
def auth_headers():
    """Generate valid auth headers with a test JWT."""
    from jose import jwt
    
    payload = {
        "sub": "123e4567-e89b-12d3-a456-426614174000",
        "email": "test@example.com",
        "role": "user",
        "exp": int(time.time()) + 3600,
        "iat": int(time.time()),
    }
    
    token = jwt.encode(
        payload,
        "test-jwt-secret-key-for-testing-purposes-only-minimum-32-chars",
        algorithm="HS256",
    )
    
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def admin_auth_headers():
    """Generate valid auth headers for admin user."""
    from jose import jwt
    
    payload = {
        "sub": "123e4567-e89b-12d3-a456-426614174001",
        "email": "admin@example.com",
        "role": "admin",
        "exp": int(time.time()) + 3600,
        "iat": int(time.time()),
    }
    
    token = jwt.encode(
        payload,
        "test-jwt-secret-key-for-testing-purposes-only-minimum-32-chars",
        algorithm="HS256",
    )
    
    return {"Authorization": f"Bearer {token}"}

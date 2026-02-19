"""Tests for profile module."""

from unittest.mock import MagicMock, patch
from datetime import datetime, timezone
from uuid import UUID


def test_get_profile_unauthorized(client):
    """Test /profile without token returns 401."""
    response = client.get("/api/v1/profile")
    assert response.status_code == 401


def test_get_profile_with_token(client, auth_headers):
    """Test /profile with valid token."""
    mock_profile = {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "first_name": "John",
        "last_name": "Doe",
        "display_name": "johndoe",
        "avatar_url": None,
        "locale": "fr",
        "timezone": "Europe/Paris",
        "role": "user",
        "organization_id": None,
        "metadata": {},
        "preferences": {},
        "created_at": datetime.now(timezone.utc).isoformat(),
        "updated_at": datetime.now(timezone.utc).isoformat(),
        "deleted_at": None,
    }
    
    with patch("app.modules.profile.repository.ProfileRepository.get_by_id") as mock_get:
        from app.modules.profile.schemas import ProfileRead
        mock_get.return_value = ProfileRead(**mock_profile)
        
        response = client.get("/api/v1/profile", headers=auth_headers)
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert data["data"]["first_name"] == "John"


def test_update_profile(client, auth_headers):
    """Test PATCH /profile."""
    mock_profile = {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "first_name": "Jane",
        "last_name": "Doe",
        "display_name": "janedoe",
        "avatar_url": None,
        "locale": "fr",
        "timezone": "Europe/Paris",
        "role": "user",
        "organization_id": None,
        "metadata": {},
        "preferences": {},
        "created_at": datetime.now(timezone.utc).isoformat(),
        "updated_at": datetime.now(timezone.utc).isoformat(),
        "deleted_at": None,
    }
    
    with patch("app.modules.profile.repository.ProfileRepository.get_by_id") as mock_get, \
         patch("app.modules.profile.repository.ProfileRepository.update") as mock_update:
        from app.modules.profile.schemas import ProfileRead
        mock_get.return_value = ProfileRead(**mock_profile)
        mock_update.return_value = ProfileRead(**mock_profile)
        
        response = client.patch(
            "/api/v1/profile",
            headers=auth_headers,
            json={"first_name": "Jane", "display_name": "janedoe"},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["success"] is True
        assert "updated" in data["message"].lower()

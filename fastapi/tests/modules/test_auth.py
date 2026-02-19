"""Tests for auth module."""

import pytest


def test_get_me_unauthorized(client):
    """Test /auth/me without token returns 401."""
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401


def test_get_me_with_token(client, auth_headers):
    """Test /auth/me with valid token."""
    response = client.get("/api/v1/auth/me", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert data["data"]["email"] == "test@example.com"


def test_verify_token_valid(client, auth_headers):
    """Test token verification with valid token."""
    token = auth_headers["Authorization"].replace("Bearer ", "")
    response = client.post(
        "/api/v1/auth/verify",
        json={"token": token},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["valid"] is True
    assert data["user_id"] is not None


def test_verify_token_invalid(client):
    """Test token verification with invalid token."""
    response = client.post(
        "/api/v1/auth/verify",
        json={"token": "invalid-token"},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["valid"] is False


def test_logout(client, auth_headers):
    """Test logout endpoint."""
    response = client.post("/api/v1/auth/logout", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True
    assert "Logged out" in data["message"]

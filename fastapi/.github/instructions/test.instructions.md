# Test Instructions

## File Pattern

Tests mirror the module structure under `tests/`.

## Structure

```python
"""Tests for [module]."""

import pytest
from uuid import uuid4


class TestGetProfile:
    """Tests for GET /api/v1/profile/me."""

    def test_returns_profile(self, client, auth_headers, mock_supabase):
        """Should return the current user's profile."""
        mock_supabase.table.return_value.select.return_value\
            .eq.return_value.single.return_value\
            .execute.return_value.data = {"id": str(uuid4()), "first_name": "Test"}

        response = client.get("/api/v1/profile/me", headers=auth_headers)

        assert response.status_code == 200
        assert response.json()["success"] is True

    def test_requires_auth(self, client):
        """Should return 401 without auth."""
        response = client.get("/api/v1/profile/me")
        assert response.status_code == 401
```

## Rules

1. Use **class-based** test organization: `TestEndpointName`
2. Each test method has a docstring explaining the expected behavior
3. Use fixtures from `conftest.py`: `client`, `mock_supabase`, `auth_headers`
4. Always test: happy path, auth required (401), not found (404), validation (422)
5. Use `monkeypatch` for env vars — never real `.env`
6. Call `clear_settings_cache()` in fixtures to reset config
7. Integration tests go in `tests/integration/` and use real Supabase
8. Use `pytest.mark.asyncio` for async tests (auto mode enabled)

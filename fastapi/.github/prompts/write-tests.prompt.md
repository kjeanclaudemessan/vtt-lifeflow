# Write FastAPI Tests

Write tests for a FastAPI module.

## Test Target

- **Module**: ${{input:Module name (e.g., profile, auth, orders)}}
- **What to test**: ${{input:Specific endpoint or service to test}}

## Requirements

1. **Test file**: `fastapi/tests/modules/test_<module>.py`
2. **Class-based**: One `Test*` class per endpoint
3. **Cover**: happy path, 401 unauthorized, 404 not found, 422 validation, edge cases
4. **Use fixtures**: `client`, `auth_headers`, `mock_supabase` from `conftest.py`
5. **Mock Supabase**: Chain mock calls matching the query builder pattern
6. **Assert**: status code, `success` field, response data structure

## Example

```python
class TestCreateOrder:
    def test_creates_order(self, client, auth_headers, mock_supabase):
        mock_supabase.table.return_value.insert.return_value.execute.return_value.data = [{"id": "..."}]
        response = client.post("/api/v1/orders", json={...}, headers=auth_headers)
        assert response.status_code == 201
        assert response.json()["success"] is True

    def test_requires_auth(self, client):
        response = client.post("/api/v1/orders", json={...})
        assert response.status_code == 401
```

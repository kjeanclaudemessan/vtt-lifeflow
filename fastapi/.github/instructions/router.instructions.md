# Router Instructions

## File Pattern

Every module has a `router.py` file.

## Structure

```python
"""Module description."""

from fastapi import APIRouter, Depends
from app.modules.auth.dependencies import get_current_user, CurrentUser
from app.schemas import SuccessResponse, MessageResponse

from .service import ModuleService
from .schemas import ModuleResponse, ModuleCreateRequest

router = APIRouter(prefix="/module-name", tags=["Module Name"])


@router.get("/", response_model=SuccessResponse[list[ModuleResponse]])
async def list_items(current_user: CurrentUser = Depends(get_current_user)):
    """List all items for the current user."""
    service = ModuleService()
    items = await service.list_for_user(current_user.id)
    return SuccessResponse(data=items, message="Items retrieved")


@router.post("/", response_model=SuccessResponse[ModuleResponse], status_code=201)
async def create_item(
    data: ModuleCreateRequest,
    current_user: CurrentUser = Depends(get_current_user),
):
    """Create a new item."""
    service = ModuleService()
    item = await service.create(user_id=current_user.id, data=data)
    return SuccessResponse(data=item, message="Item created")
```

## Rules

1. Router prefix uses **kebab-case**: `/ai-agent`, `/chat-platform`
2. Tags use **Title Case**: `["AI Agent"]`, `["Chat Platform"]`
3. Every endpoint has a `response_model` type annotation
4. Every endpoint has a docstring (shown in Swagger)
5. Services are instantiated inline in handlers — not injected globally
6. Use `Depends(get_current_user)` for authenticated endpoints
7. Use `Depends(get_optional_user)` for optionally authenticated endpoints
8. Return typed response wrappers: `SuccessResponse`, `MessageResponse`, `PaginatedResponse`
9. POST endpoints return `status_code=201`
10. DELETE endpoints return `MessageResponse`

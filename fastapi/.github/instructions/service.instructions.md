# Service Instructions

## File Pattern

Every module has a `service.py` file containing business logic.

## Structure

```python
"""Service for [module] operations."""

from uuid import UUID
from app.core.exceptions import NotFoundException, BadRequestException

from .repository import ModuleRepository
from .schemas import ModuleResponse, ModuleCreateRequest


class ModuleService:
    """Handles [module] business logic."""

    def __init__(self, repository: ModuleRepository | None = None):
        self.repository = repository or ModuleRepository()

    async def get_by_id(self, item_id: UUID) -> ModuleResponse:
        """Get a single item by ID."""
        item = await self.repository.get_by_id(item_id)
        if not item:
            raise NotFoundException(resource="Item")
        return item

    async def create(self, user_id: UUID, data: ModuleCreateRequest) -> ModuleResponse:
        """Create a new item."""
        return await self.repository.create(user_id=user_id, data=data)
```

## Rules

1. Services contain **business logic** — no HTTP concerns (no Request/Response objects)
2. Services receive a **repository** via constructor (default to new instance)
3. All methods are `async def`
4. Raise `AppException` subclasses for errors — never return error dicts
5. Return **Pydantic models** — never raw dicts
6. Services do NOT access `request` or `response` objects
7. Services can call other services if needed
8. For simple modules (like auth), repository is optional — service can call Supabase directly

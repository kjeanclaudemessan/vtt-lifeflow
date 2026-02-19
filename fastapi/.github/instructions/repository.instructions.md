# Repository Instructions

## File Pattern

Optional `repository.py` file — only for modules with complex data access.

## Structure

```python
"""Repository for [module] data access."""

from uuid import UUID
from app.db.supabase import supabase_admin
from .schemas import ModuleResponse, ModuleCreateRequest


class ModuleRepository:
    """Data access layer for [module]."""

    TABLE = "table_name"

    async def get_by_id(self, item_id: UUID) -> ModuleResponse | None:
        """Get a single item by ID."""
        result = await supabase_admin.table(self.TABLE)\
            .select("*")\
            .eq("id", str(item_id))\
            .single()\
            .execute()
        return ModuleResponse(**result.data) if result.data else None

    async def list_for_user(self, user_id: UUID) -> list[ModuleResponse]:
        """List all items for a user."""
        result = await supabase_admin.table(self.TABLE)\
            .select("*")\
            .eq("user_id", str(user_id))\
            .order("created_at", desc=True)\
            .execute()
        return [ModuleResponse(**item) for item in result.data]

    async def create(self, user_id: UUID, data: ModuleCreateRequest) -> ModuleResponse:
        """Create a new item."""
        payload = {**data.model_dump(exclude_none=True), "user_id": str(user_id)}
        result = await supabase_admin.table(self.TABLE)\
            .insert(payload)\
            .execute()
        return ModuleResponse(**result.data[0])
```

## Rules

1. Use `supabase_admin` (service role) for server-side operations — bypasses RLS
2. Cast `UUID` to `str()` for Supabase queries
3. Use `TABLE` class attribute for the table name
4. Return **Pydantic models** — never raw dicts
5. All methods are `async def`
6. Return `None` for missing records — let the service raise `NotFoundException`
7. Use `model_dump(exclude_none=True)` for partial updates

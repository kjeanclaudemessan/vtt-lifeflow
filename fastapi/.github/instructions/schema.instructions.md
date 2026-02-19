# Schema Instructions

## File Pattern

Every module has a `schemas.py` file containing Pydantic models.

## Structure

```python
"""Schemas for [module]."""

from datetime import datetime
from uuid import UUID
from pydantic import Field
from app.schemas.base import BaseSchema, TimestampMixin


# ═══════════════════════════════════════════════════════════════
# Base
# ═══════════════════════════════════════════════════════════════

class ItemBase(BaseSchema):
    """Shared fields for Item."""
    name: str
    description: str | None = None


# ═══════════════════════════════════════════════════════════════
# Requests
# ═══════════════════════════════════════════════════════════════

class ItemCreateRequest(ItemBase):
    """Create a new item."""
    pass


class ItemUpdateRequest(BaseSchema):
    """Update an item — all fields optional for PATCH."""
    name: str | None = None
    description: str | None = None


# ═══════════════════════════════════════════════════════════════
# Responses
# ═══════════════════════════════════════════════════════════════

class ItemResponse(ItemBase, TimestampMixin):
    """Item response with metadata."""
    id: UUID
    user_id: UUID
```

## Rules

1. All schemas extend `BaseSchema` (which uses `model_config = ConfigDict(from_attributes=True)`)
2. Use **section banners** (`# ═══`) to visually separate Base / Requests / Responses
3. Use Python 3.10+ union syntax: `str | None = None` (not `Optional[str]`)
4. Use `UUID` for ID fields
5. Request schemas: `*CreateRequest`, `*UpdateRequest`
6. Response schemas: `*Response`
7. Base schemas: `*Base` — shared fields inherited by both requests and responses
8. Update schemas: all fields optional (for PATCH operations)
9. Use `TimestampMixin` for responses that include `created_at`, `updated_at`
10. Use `Field()` for validation constraints: `Field(min_length=1, max_length=255)`

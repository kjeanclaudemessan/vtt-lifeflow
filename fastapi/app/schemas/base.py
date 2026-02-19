"""VTT FastAPI Template - Base schemas."""

from datetime import datetime
from typing import Any, Generic, TypeVar

from pydantic import BaseModel, ConfigDict

T = TypeVar("T")


class BaseSchema(BaseModel):
    """Base schema with common configuration."""

    model_config = ConfigDict(
        from_attributes=True,
        populate_by_name=True,
        use_enum_values=True,
    )


# ══════════════════════════════════════════════════════════════════════════════
# RESPONSE SCHEMAS
# ══════════════════════════════════════════════════════════════════════════════


class SuccessResponse(BaseModel, Generic[T]):
    """Standard success response wrapper."""

    success: bool = True
    data: T
    message: str | None = None


class ErrorResponse(BaseModel):
    """Standard error response."""

    success: bool = False
    error: str
    detail: str | None = None
    code: str | None = None


class MessageResponse(BaseModel):
    """Simple message response."""

    success: bool = True
    message: str


# ══════════════════════════════════════════════════════════════════════════════
# MIXINS
# ══════════════════════════════════════════════════════════════════════════════


class TimestampMixin(BaseModel):
    """Mixin for created_at/updated_at fields."""

    created_at: datetime
    updated_at: datetime


class SoftDeleteMixin(BaseModel):
    """Mixin for soft delete field."""

    deleted_at: datetime | None = None


class MetadataMixin(BaseModel):
    """Mixin for metadata JSONB field."""

    metadata: dict[str, Any] = {}


class PreferencesMixin(BaseModel):
    """Mixin for preferences JSONB field."""

    preferences: dict[str, Any] = {}

"""VTT FastAPI Template - Common schemas."""

from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


# ══════════════════════════════════════════════════════════════════════════════
# ID SCHEMAS
# ══════════════════════════════════════════════════════════════════════════════


class IDSchema(BaseModel):
    """Schema with just an ID."""

    id: UUID


class IDsSchema(BaseModel):
    """Schema with list of IDs."""

    ids: list[UUID]


# ══════════════════════════════════════════════════════════════════════════════
# USER REFERENCE
# ══════════════════════════════════════════════════════════════════════════════


class UserReference(BaseModel):
    """Minimal user reference for embedding in other responses."""

    id: UUID
    display_name: str | None = None
    avatar_url: str | None = None


# ══════════════════════════════════════════════════════════════════════════════
# HEALTH CHECK
# ══════════════════════════════════════════════════════════════════════════════


class HealthCheckResponse(BaseModel):
    """Health check response."""

    status: str = "healthy"
    version: str = "1.0.0"
    environment: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)
    services: dict[str, str] = {}


# ══════════════════════════════════════════════════════════════════════════════
# WEBHOOK
# ══════════════════════════════════════════════════════════════════════════════


class WebhookResponse(BaseModel):
    """Standard webhook response."""

    received: bool = True
    message: str = "Webhook processed"


# ══════════════════════════════════════════════════════════════════════════════
# POLYMORPHIC REFERENCES (for comments, attachments, etc.)
# ══════════════════════════════════════════════════════════════════════════════


class PolymorphicReference(BaseModel):
    """Reference to a polymorphic resource (e.g., commentable, attachable)."""

    type: str = Field(..., description="Resource type (e.g., 'post', 'task')")
    id: UUID = Field(..., description="Resource ID")


# ══════════════════════════════════════════════════════════════════════════════
# FILTERS
# ══════════════════════════════════════════════════════════════════════════════


class DateRangeFilter(BaseModel):
    """Date range filter."""

    start_date: datetime | None = None
    end_date: datetime | None = None


class SearchFilter(BaseModel):
    """Text search filter."""

    query: str = Field(..., min_length=1, max_length=255)
    fields: list[str] | None = None

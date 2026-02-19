"""VTT FastAPI Template - Profile module schemas."""

from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import BaseModel, Field

from app.schemas.base import BaseSchema, MetadataMixin, PreferencesMixin, TimestampMixin


# ══════════════════════════════════════════════════════════════════════════════
# PROFILE SCHEMAS (matches Supabase profiles table)
# ══════════════════════════════════════════════════════════════════════════════


class ProfileBase(BaseSchema):
    """Base profile schema."""

    first_name: str | None = None
    last_name: str | None = None
    display_name: str | None = None
    avatar_url: str | None = None
    locale: str = "fr"
    timezone: str = "Europe/Paris"


class ProfileRead(ProfileBase, TimestampMixin, MetadataMixin, PreferencesMixin):
    """Profile read schema (response)."""

    id: UUID
    role: str = "user"
    organization_id: UUID | None = None
    deleted_at: datetime | None = None


class ProfileUpdate(BaseModel):
    """Profile update schema (request)."""

    first_name: str | None = None
    last_name: str | None = None
    display_name: str | None = None
    avatar_url: str | None = None
    locale: str | None = None
    timezone: str | None = None


class ProfileMetadataUpdate(BaseModel):
    """Update profile metadata (JSONB merge)."""

    metadata: dict[str, Any] = Field(default_factory=dict)


class ProfilePreferencesUpdate(BaseModel):
    """Update profile preferences (JSONB merge)."""

    preferences: dict[str, Any] = Field(default_factory=dict)


# ══════════════════════════════════════════════════════════════════════════════
# PREFERENCES SCHEMA (typed structure)
# ══════════════════════════════════════════════════════════════════════════════


class NotificationPreferences(BaseModel):
    """Notification preferences structure."""

    email: bool = True
    push: bool = True
    sms: bool = False
    marketing: bool = False


class UserPreferences(BaseModel):
    """Full user preferences structure."""

    theme: str = "system"  # 'light', 'dark', 'system'
    notifications: NotificationPreferences = Field(default_factory=NotificationPreferences)
    sidebar_collapsed: bool = False
    items_per_page: int = 20

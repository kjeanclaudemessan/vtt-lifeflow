"""VTT FastAPI Template - Webhooks module schemas."""

from typing import Any

from pydantic import BaseModel, Field


class WebhookEvent(BaseModel):
    """Generic webhook event."""

    event_type: str
    payload: dict[str, Any] = Field(default_factory=dict)


class MonerooWebhookEvent(BaseModel):
    """Moneroo webhook event structure."""

    event: str
    data: dict[str, Any] = Field(default_factory=dict)


class StripeWebhookEvent(BaseModel):
    """Stripe webhook event structure."""

    id: str
    type: str
    data: dict[str, Any] = Field(default_factory=dict)

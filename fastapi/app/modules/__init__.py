"""VTT FastAPI Template - Modules."""

from app.modules import auth, health, profile, webhooks

__all__ = [
    "auth",
    "health",
    "profile",
    "webhooks",
]

# AI Agent module is imported conditionally in api/v1/router.py
# based on the ai_agent_enabled setting

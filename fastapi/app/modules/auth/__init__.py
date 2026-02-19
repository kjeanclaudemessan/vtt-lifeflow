"""VTT FastAPI Template - Auth module."""

from app.modules.auth.dependencies import (
    get_current_active_user,
    get_current_user,
    get_optional_user,
    require_admin,
    require_role,
    require_user,
)
from app.modules.auth.router import router
from app.modules.auth.schemas import CurrentUser, TokenPayload, TokenResponse
from app.modules.auth.service import AuthService

__all__ = [
    # Router
    "router",
    # Dependencies
    "get_current_user",
    "get_current_active_user",
    "get_optional_user",
    "require_role",
    "require_admin",
    "require_user",
    # Schemas
    "CurrentUser",
    "TokenPayload",
    "TokenResponse",
    # Service
    "AuthService",
]

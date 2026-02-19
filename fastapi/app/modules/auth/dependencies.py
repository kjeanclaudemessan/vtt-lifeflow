"""VTT FastAPI Template - Auth module dependencies."""

from fastapi import Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.exceptions import ForbiddenException, UnauthorizedException
from app.core.security import decode_jwt
from app.modules.auth.schemas import CurrentUser

# HTTP Bearer security scheme
security = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
) -> CurrentUser:
    """
    Dependency to get the current authenticated user from JWT.
    
    Extracts and validates the JWT token from the Authorization header.
    Returns a CurrentUser object with the user's information.
    
    Raises:
        UnauthorizedException: If token is missing or invalid
    """
    if credentials is None:
        raise UnauthorizedException(detail="Missing authentication token")
    
    token = credentials.credentials
    payload = decode_jwt(token)
    
    if payload is None:
        raise UnauthorizedException(detail="Invalid or expired token")
    
    # Extract user info from JWT payload
    user_id = payload.get("sub")
    if not user_id:
        raise UnauthorizedException(detail="Invalid token payload")
    
    return CurrentUser(
        id=user_id,
        email=payload.get("email"),
        role=payload.get("role"),
        email_confirmed=payload.get("email_confirmed_at") is not None,
        phone=payload.get("phone"),
        phone_confirmed=payload.get("phone_confirmed_at") is not None,
    )


async def get_current_active_user(
    current_user: CurrentUser = Depends(get_current_user),
) -> CurrentUser:
    """
    Dependency to get the current active user.
    
    Use this when you need to ensure the user account is active.
    Can be extended to check additional conditions.
    """
    # Add additional checks here if needed
    # e.g., check if user is banned, email verified, etc.
    return current_user


async def get_optional_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
) -> CurrentUser | None:
    """
    Dependency to optionally get the current user.
    
    Returns None if no token is provided or token is invalid.
    Use this for endpoints that work with or without authentication.
    """
    if credentials is None:
        return None
    
    token = credentials.credentials
    payload = decode_jwt(token)
    
    if payload is None:
        return None
    
    user_id = payload.get("sub")
    if not user_id:
        return None
    
    return CurrentUser(
        id=user_id,
        email=payload.get("email"),
        role=payload.get("role"),
        email_confirmed=payload.get("email_confirmed_at") is not None,
        phone=payload.get("phone"),
        phone_confirmed=payload.get("phone_confirmed_at") is not None,
    )


# ══════════════════════════════════════════════════════════════════════════════
# ROLE-BASED ACCESS
# ══════════════════════════════════════════════════════════════════════════════


def require_role(*allowed_roles: str):
    """
    Dependency factory for role-based access control.
    
    Usage:
        @router.get("/admin", dependencies=[Depends(require_role("admin"))])
        async def admin_endpoint():
            ...
    """
    async def role_checker(
        current_user: CurrentUser = Depends(get_current_user),
    ) -> CurrentUser:
        if current_user.role not in allowed_roles:
            raise ForbiddenException(
                detail=f"Role '{current_user.role}' not allowed. Required: {allowed_roles}"
            )
        return current_user
    
    return role_checker


# Convenience dependencies for common roles
require_admin = require_role("admin")
require_user = require_role("user", "admin")

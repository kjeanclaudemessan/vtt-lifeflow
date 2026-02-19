"""VTT FastAPI Template - Auth module schemas."""

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


# ══════════════════════════════════════════════════════════════════════════════
# TOKEN SCHEMAS
# ══════════════════════════════════════════════════════════════════════════════


class TokenPayload(BaseModel):
    """JWT token payload."""

    sub: str  # User ID
    email: str | None = None
    exp: datetime
    iat: datetime
    aud: str | None = None
    role: str | None = None


class TokenResponse(BaseModel):
    """Token response (for custom token generation if needed)."""

    access_token: str
    token_type: str = "bearer"
    expires_in: int


# ══════════════════════════════════════════════════════════════════════════════
# CURRENT USER
# ══════════════════════════════════════════════════════════════════════════════


class CurrentUser(BaseModel):
    """Current authenticated user info extracted from JWT."""

    id: UUID
    email: str | None = None
    role: str | None = None
    
    # Additional fields from Supabase user metadata
    email_confirmed: bool = False
    phone: str | None = None
    phone_confirmed: bool = False


# ══════════════════════════════════════════════════════════════════════════════
# VERIFICATION
# ══════════════════════════════════════════════════════════════════════════════


class VerifyTokenRequest(BaseModel):
    """Request to verify a token."""

    token: str


class VerifyTokenResponse(BaseModel):
    """Token verification response."""

    valid: bool
    user_id: str | None = None
    expires_at: datetime | None = None

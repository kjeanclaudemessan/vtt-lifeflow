"""VTT FastAPI Template - Auth module service."""

from datetime import datetime, timezone

from app.core.security import decode_jwt
from app.modules.auth.schemas import CurrentUser, TokenPayload


class AuthService:
    """
    Authentication service.
    
    Note: Supabase handles most auth operations (login, register, etc.).
    This service is for JWT verification and auth-related helpers.
    """

    @staticmethod
    def verify_token(token: str) -> CurrentUser | None:
        """
        Verify a JWT token and return user info.
        
        Returns None if token is invalid or expired.
        """
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

    @staticmethod
    def get_token_payload(token: str) -> TokenPayload | None:
        """
        Get the full token payload.
        
        Returns None if token is invalid.
        """
        payload = decode_jwt(token)
        
        if payload is None:
            return None
        
        return TokenPayload(
            sub=payload.get("sub", ""),
            email=payload.get("email"),
            exp=datetime.fromtimestamp(payload.get("exp", 0), tz=timezone.utc),
            iat=datetime.fromtimestamp(payload.get("iat", 0), tz=timezone.utc),
            aud=payload.get("aud"),
            role=payload.get("role"),
        )

    @staticmethod
    def is_token_expired(token: str) -> bool:
        """Check if a token is expired."""
        payload = decode_jwt(token)
        
        if payload is None:
            return True
        
        exp = payload.get("exp")
        if not exp:
            return True
        
        return datetime.fromtimestamp(exp, tz=timezone.utc) < datetime.now(tz=timezone.utc)

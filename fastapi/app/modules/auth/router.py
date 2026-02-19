"""VTT FastAPI Template - Auth module router."""

from fastapi import APIRouter, Depends

from app.modules.auth.dependencies import get_current_user
from app.modules.auth.schemas import CurrentUser, VerifyTokenRequest, VerifyTokenResponse
from app.modules.auth.service import AuthService
from app.schemas import MessageResponse, SuccessResponse

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.get(
    "/me",
    response_model=SuccessResponse[CurrentUser],
    summary="Get current user",
    description="Get the current authenticated user's information from JWT.",
)
async def get_me(
    current_user: CurrentUser = Depends(get_current_user),
) -> SuccessResponse[CurrentUser]:
    """Get current authenticated user."""
    return SuccessResponse(data=current_user)


@router.post(
    "/verify",
    response_model=VerifyTokenResponse,
    summary="Verify token",
    description="Verify if a JWT token is valid and not expired.",
)
async def verify_token(request: VerifyTokenRequest) -> VerifyTokenResponse:
    """Verify a JWT token."""
    service = AuthService()
    payload = service.get_token_payload(request.token)
    
    if payload is None:
        return VerifyTokenResponse(valid=False)
    
    return VerifyTokenResponse(
        valid=True,
        user_id=payload.sub,
        expires_at=payload.exp,
    )


@router.post(
    "/logout",
    response_model=MessageResponse,
    summary="Logout",
    description="Logout the current user. Note: With JWT, this is mostly client-side.",
)
async def logout(
    current_user: CurrentUser = Depends(get_current_user),
) -> MessageResponse:
    """
    Logout endpoint.
    
    Note: With Supabase JWT auth, logout is primarily handled client-side
    by removing the token. This endpoint can be used to:
    - Log the logout event
    - Invalidate refresh tokens (if implemented)
    - Clear server-side sessions (if any)
    """
    # TODO: Add any server-side logout logic here
    # e.g., invalidate refresh token, clear cache, log event
    
    return MessageResponse(message="Logged out successfully")

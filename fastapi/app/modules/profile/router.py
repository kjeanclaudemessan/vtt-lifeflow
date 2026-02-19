"""VTT FastAPI Template - Profile module router."""

from fastapi import APIRouter, Depends

from app.modules.auth.dependencies import get_current_user
from app.modules.auth.schemas import CurrentUser
from app.modules.profile.schemas import (
    ProfileMetadataUpdate,
    ProfilePreferencesUpdate,
    ProfileRead,
    ProfileUpdate,
)
from app.modules.profile.service import ProfileService
from app.schemas import MessageResponse, SuccessResponse

router = APIRouter(prefix="/profile", tags=["Profile"])


def get_profile_service() -> ProfileService:
    """Dependency to get profile service."""
    return ProfileService()


@router.get(
    "",
    response_model=SuccessResponse[ProfileRead],
    summary="Get my profile",
    description="Get the current user's profile.",
)
async def get_my_profile(
    current_user: CurrentUser = Depends(get_current_user),
    service: ProfileService = Depends(get_profile_service),
) -> SuccessResponse[ProfileRead]:
    """Get current user's profile."""
    profile = await service.get_profile(current_user.id)
    return SuccessResponse(data=profile)


@router.patch(
    "",
    response_model=SuccessResponse[ProfileRead],
    summary="Update my profile",
    description="Update the current user's profile fields.",
)
async def update_my_profile(
    data: ProfileUpdate,
    current_user: CurrentUser = Depends(get_current_user),
    service: ProfileService = Depends(get_profile_service),
) -> SuccessResponse[ProfileRead]:
    """Update current user's profile."""
    profile = await service.update_profile(current_user.id, data)
    return SuccessResponse(data=profile, message="Profile updated successfully")


@router.patch(
    "/metadata",
    response_model=SuccessResponse[ProfileRead],
    summary="Update profile metadata",
    description="Merge new metadata with existing profile metadata.",
)
async def update_my_metadata(
    data: ProfileMetadataUpdate,
    current_user: CurrentUser = Depends(get_current_user),
    service: ProfileService = Depends(get_profile_service),
) -> SuccessResponse[ProfileRead]:
    """Update current user's metadata."""
    profile = await service.update_metadata(current_user.id, data.metadata)
    return SuccessResponse(data=profile, message="Metadata updated successfully")


@router.patch(
    "/preferences",
    response_model=SuccessResponse[ProfileRead],
    summary="Update profile preferences",
    description="Merge new preferences with existing profile preferences.",
)
async def update_my_preferences(
    data: ProfilePreferencesUpdate,
    current_user: CurrentUser = Depends(get_current_user),
    service: ProfileService = Depends(get_profile_service),
) -> SuccessResponse[ProfileRead]:
    """Update current user's preferences."""
    profile = await service.update_preferences(current_user.id, data.preferences)
    return SuccessResponse(data=profile, message="Preferences updated successfully")


@router.delete(
    "",
    response_model=MessageResponse,
    summary="Delete my profile",
    description="Soft delete the current user's profile.",
)
async def delete_my_profile(
    current_user: CurrentUser = Depends(get_current_user),
    service: ProfileService = Depends(get_profile_service),
) -> MessageResponse:
    """Soft delete current user's profile."""
    await service.delete_profile(current_user.id)
    return MessageResponse(message="Profile deleted successfully")

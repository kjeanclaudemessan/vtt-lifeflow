"""VTT FastAPI Template - Profile module service."""

from typing import Any
from uuid import UUID

from app.core.exceptions import NotFoundException
from app.modules.profile.repository import ProfileRepository
from app.modules.profile.schemas import (
    ProfileRead,
    ProfileUpdate,
)


class ProfileService:
    """Service for profile business logic."""

    def __init__(self, repository: ProfileRepository | None = None):
        self.repository = repository or ProfileRepository()

    async def get_profile(self, user_id: UUID) -> ProfileRead:
        """
        Get a user's profile.
        
        Raises:
            NotFoundException: If profile not found
        """
        profile = await self.repository.get_by_id(user_id)
        
        if not profile:
            raise NotFoundException(resource="Profile")
        
        return profile

    async def update_profile(
        self,
        user_id: UUID,
        data: ProfileUpdate,
    ) -> ProfileRead:
        """
        Update a user's profile.
        
        Only updates fields that are provided (not None).
        """
        # Filter out None values
        update_data = data.model_dump(exclude_unset=True, exclude_none=True)
        
        if not update_data:
            # Nothing to update, return current profile
            return await self.get_profile(user_id)
        
        profile = await self.repository.update(user_id, update_data)
        
        if not profile:
            raise NotFoundException(resource="Profile")
        
        return profile

    async def update_metadata(
        self,
        user_id: UUID,
        metadata: dict[str, Any],
    ) -> ProfileRead:
        """
        Update profile metadata (merge).
        
        Existing keys are overwritten, new keys are added.
        """
        profile = await self.repository.update_metadata(user_id, metadata)
        
        if not profile:
            raise NotFoundException(resource="Profile")
        
        return profile

    async def update_preferences(
        self,
        user_id: UUID,
        preferences: dict[str, Any],
    ) -> ProfileRead:
        """
        Update profile preferences (merge).
        """
        profile = await self.repository.update_preferences(user_id, preferences)
        
        if not profile:
            raise NotFoundException(resource="Profile")
        
        return profile

    async def delete_profile(self, user_id: UUID) -> bool:
        """
        Soft delete a user's profile.
        """
        return await self.repository.soft_delete(user_id)

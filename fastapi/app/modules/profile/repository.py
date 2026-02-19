"""VTT FastAPI Template - Profile module repository."""

from typing import Any
from uuid import UUID

from app.db.supabase import get_supabase_admin
from app.modules.profile.schemas import ProfileRead


class ProfileRepository:
    """Repository for profile data access."""

    TABLE = "profiles"

    async def get_by_id(self, user_id: UUID) -> ProfileRead | None:
        """Get a profile by user ID."""
        client = get_supabase_admin()
        
        response = (
            client.table(self.TABLE)
            .select("*")
            .eq("id", str(user_id))
            .is_("deleted_at", "null")
            .single()
            .execute()
        )
        
        if response.data:
            return ProfileRead(**response.data)
        return None

    async def update(
        self,
        user_id: UUID,
        data: dict[str, Any],
    ) -> ProfileRead | None:
        """Update a profile."""
        client = get_supabase_admin()
        
        response = (
            client.table(self.TABLE)
            .update(data)
            .eq("id", str(user_id))
            .is_("deleted_at", "null")
            .execute()
        )
        
        if response.data:
            return ProfileRead(**response.data[0])
        return None

    async def update_metadata(
        self,
        user_id: UUID,
        metadata: dict[str, Any],
    ) -> ProfileRead | None:
        """
        Merge metadata with existing metadata.
        
        Uses Supabase's JSONB concatenation.
        """
        client = get_supabase_admin()
        
        # Get current metadata
        current = await self.get_by_id(user_id)
        if not current:
            return None
        
        # Merge metadata
        merged_metadata = {**current.metadata, **metadata}
        
        return await self.update(user_id, {"metadata": merged_metadata})

    async def update_preferences(
        self,
        user_id: UUID,
        preferences: dict[str, Any],
    ) -> ProfileRead | None:
        """
        Merge preferences with existing preferences.
        """
        client = get_supabase_admin()
        
        # Get current preferences
        current = await self.get_by_id(user_id)
        if not current:
            return None
        
        # Merge preferences
        merged_preferences = {**current.preferences, **preferences}
        
        return await self.update(user_id, {"preferences": merged_preferences})

    async def soft_delete(self, user_id: UUID) -> bool:
        """Soft delete a profile."""
        client = get_supabase_admin()
        
        from datetime import datetime, timezone
        
        response = (
            client.table(self.TABLE)
            .update({"deleted_at": datetime.now(timezone.utc).isoformat()})
            .eq("id", str(user_id))
            .execute()
        )
        
        return len(response.data) > 0

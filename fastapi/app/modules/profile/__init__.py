"""VTT FastAPI Template - Profile module."""

from app.modules.profile.repository import ProfileRepository
from app.modules.profile.router import router
from app.modules.profile.schemas import (
    ProfileMetadataUpdate,
    ProfilePreferencesUpdate,
    ProfileRead,
    ProfileUpdate,
    UserPreferences,
)
from app.modules.profile.service import ProfileService

__all__ = [
    # Router
    "router",
    # Schemas
    "ProfileRead",
    "ProfileUpdate",
    "ProfileMetadataUpdate",
    "ProfilePreferencesUpdate",
    "UserPreferences",
    # Service & Repository
    "ProfileService",
    "ProfileRepository",
]

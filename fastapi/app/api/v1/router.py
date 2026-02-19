"""VTT FastAPI Template - API v1 router."""

from fastapi import APIRouter

from app.core.config import get_settings
from app.modules.auth import router as auth_router
from app.modules.health import router as health_router
from app.modules.profile import router as profile_router
from app.modules.webhooks import router as webhooks_router

# Create main API router
api_router = APIRouter()

# Include module routers
api_router.include_router(health_router)
api_router.include_router(auth_router)
api_router.include_router(profile_router)
api_router.include_router(webhooks_router)


    )

# Playground module for testing widgets and AI
from app.modules.playground import router as playground_router

api_router.include_router(
    playground_router,
    prefix="/playground",
    tags=["Playground"],
)

# Optional modules can be included conditionally:
# if settings.enable_organizations:
#     from app.modules.optional.organizations import router as org_router
#     api_router.include_router(org_router)

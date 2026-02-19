"""VTT FastAPI Template - Health module router."""

from datetime import datetime, timezone

from fastapi import APIRouter

from app.core.config import get_settings
from app.schemas.common import HealthCheckResponse

router = APIRouter(tags=["Health"])


@router.get(
    "/health",
    response_model=HealthCheckResponse,
    summary="Health check",
    description="Check if the API is running and healthy.",
)
async def health_check() -> HealthCheckResponse:
    """Health check endpoint."""
    settings = get_settings()
    
    services = {
        "api": "healthy",
    }
    
    # Check Supabase connection
    try:
        from app.db.supabase import get_supabase
        client = get_supabase()
        if client:
            # Simple query to test connection
            client.table("profiles").select("id").limit(1).execute()
            services["supabase"] = "connected"
        else:
            services["supabase"] = "not_initialized"
    except Exception as e:
        services["supabase"] = f"error: {str(e)[:50]}"
    
    # Check Redis connection (if configured)
    if settings.redis_url:
        try:
            from app.db.redis import get_redis
            redis = get_redis()
            if redis:
                await redis.ping()
                services["redis"] = "connected"
            else:
                services["redis"] = "not_configured"
        except Exception:
            services["redis"] = "error"
    
    # Determine overall status
    healthy_statuses = {"healthy", "connected"}
    is_healthy = all(
        v in healthy_statuses or v == "not_configured"
        for v in services.values()
    )
    
    return HealthCheckResponse(
        status="healthy" if is_healthy else "degraded",
        version="1.0.0",
        environment=settings.app_env,
        timestamp=datetime.now(timezone.utc),
        services=services,
    )


@router.get(
    "/",
    summary="Root",
    description="API root endpoint.",
)
async def root() -> dict:
    """Root endpoint."""
    settings = get_settings()
    return {
        "name": settings.app_name,
        "version": "1.0.0",
        "docs": f"{settings.api_v1_prefix}/docs",
    }

"""VTT FastAPI Template - Application lifespan management."""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

import structlog
from fastapi import FastAPI

from app.core.config import get_settings

logger = structlog.get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """
    Application lifespan context manager.
    
    Handles startup and shutdown events.
    """
    # Import here to avoid circular imports
    from app.db.supabase import close_supabase, init_supabase
    
    settings = get_settings()
    
    # ══════════════════════════════════════════════════════════════════════════
    # STARTUP
    # ══════════════════════════════════════════════════════════════════════════
    await logger.ainfo(
        "application_starting",
        app_name=settings.app_name,
        environment=settings.app_env,
    )
    
    # Initialize Supabase
    await init_supabase()
    await logger.ainfo("supabase_initialized")
    
    # Initialize Redis (if configured)
    if settings.redis_url:
        # TODO: Initialize Redis connection
        await logger.ainfo("redis_initialized")
    
    await logger.ainfo(
        "application_started",
        app_name=settings.app_name,
        api_prefix=settings.api_v1_prefix,
    )
    
    yield
    
    # ══════════════════════════════════════════════════════════════════════════
    # SHUTDOWN
    # ══════════════════════════════════════════════════════════════════════════
    await logger.ainfo("application_shutting_down")
    
    # Close Supabase
    await close_supabase()
    
    # Close Redis (if initialized)
    if settings.redis_url:
        # TODO: Close Redis connection
        pass
    
    await logger.ainfo("application_shutdown_complete")

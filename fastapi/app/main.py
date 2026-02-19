"""VTT FastAPI Template - Application entry point."""

from fastapi import FastAPI
from fastapi.responses import ORJSONResponse


def create_app() -> FastAPI:
    """
    Application factory.
    
    Creates and configures the FastAPI application.
    """
    from app.api.v1 import api_router
    from app.core import get_settings, lifespan, setup_middleware
    
    settings = get_settings()

    app = FastAPI(
        title=settings.app_name,
        description="VTT FastAPI Template - Clean Architecture with Supabase",
        version="1.0.0",
        openapi_url=f"{settings.api_v1_prefix}/openapi.json",
        docs_url=f"{settings.api_v1_prefix}/docs",
        redoc_url=f"{settings.api_v1_prefix}/redoc",
        default_response_class=ORJSONResponse,
        lifespan=lifespan,
    )

    # Setup middleware
    setup_middleware(app)

    # Include API router
    app.include_router(api_router, prefix=settings.api_v1_prefix)

    return app


def get_app() -> FastAPI:
    """Get or create app instance (lazy singleton)."""
    global _app
    if _app is None:
        _app = create_app()
    return _app


_app: FastAPI | None = None


if __name__ == "__main__":
    import uvicorn
    
    from app.core import get_settings
    
    app = create_app()
    settings = get_settings()
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8000,
        reload=settings.is_development,
    )

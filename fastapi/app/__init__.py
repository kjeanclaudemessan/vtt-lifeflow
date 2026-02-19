"""VTT FastAPI Template."""

# Don't import app at module level to allow proper mocking in tests
# Use: from app.main import create_app, app

__all__ = ["create_app"]


def create_app():
    """Lazy import to avoid settings validation at import time."""
    from app.main import create_app as _create_app
    return _create_app()

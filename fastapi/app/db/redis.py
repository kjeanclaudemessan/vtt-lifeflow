"""VTT FastAPI Template - Redis client (optional)."""

from typing import Any

import structlog

logger = structlog.get_logger()

# Redis client instance
_redis_client: Any | None = None


async def init_redis(redis_url: str) -> None:
    """Initialize Redis client."""
    global _redis_client
    
    try:
        import redis.asyncio as redis
        
        _redis_client = redis.from_url(
            redis_url,
            encoding="utf-8",
            decode_responses=True,
        )
        
        # Test connection
        await _redis_client.ping()
        await logger.ainfo("redis_connected", url=redis_url.split("@")[-1])
        
    except ImportError:
        await logger.awarning("redis_not_installed", message="Install with: pip install redis")
    except Exception as e:
        await logger.aerror("redis_connection_failed", error=str(e))
        _redis_client = None


async def close_redis() -> None:
    """Close Redis client."""
    global _redis_client
    
    if _redis_client:
        await _redis_client.close()
        _redis_client = None
        await logger.ainfo("redis_disconnected")


def get_redis() -> Any | None:
    """Get Redis client (or None if not configured)."""
    return _redis_client


# ══════════════════════════════════════════════════════════════════════════════
# CACHE HELPERS
# ══════════════════════════════════════════════════════════════════════════════


async def cache_get(key: str) -> str | None:
    """Get a value from cache."""
    if _redis_client is None:
        return None
    return await _redis_client.get(key)


async def cache_set(key: str, value: str, ttl_seconds: int = 3600) -> bool:
    """Set a value in cache with TTL."""
    if _redis_client is None:
        return False
    await _redis_client.setex(key, ttl_seconds, value)
    return True


async def cache_delete(key: str) -> bool:
    """Delete a value from cache."""
    if _redis_client is None:
        return False
    await _redis_client.delete(key)
    return True


async def cache_exists(key: str) -> bool:
    """Check if key exists in cache."""
    if _redis_client is None:
        return False
    return await _redis_client.exists(key) > 0

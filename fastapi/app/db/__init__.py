"""VTT FastAPI Template - Database module."""

from app.db.redis import (
    cache_delete,
    cache_exists,
    cache_get,
    cache_set,
    close_redis,
    get_redis,
    init_redis,
)
from app.db.supabase import (
    close_supabase,
    execute_rpc,
    get_supabase,
    get_supabase_admin,
    init_supabase,
)

__all__ = [
    # Supabase
    "init_supabase",
    "close_supabase",
    "get_supabase",
    "get_supabase_admin",
    "execute_rpc",
    # Redis
    "init_redis",
    "close_redis",
    "get_redis",
    "cache_get",
    "cache_set",
    "cache_delete",
    "cache_exists",
]

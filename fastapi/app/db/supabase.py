"""VTT FastAPI Template - Supabase client with async wrapper."""

import asyncio
from functools import wraps
from typing import Any, Callable, TypeVar
from supabase import Client, create_client

from app.core.config import get_settings

# Type for generic return
T = TypeVar("T")

# Global client instance
_supabase_client: Client | None = None
_supabase_admin_client: Client | None = None


# ══════════════════════════════════════════════════════════════════════════════
# ASYNC WRAPPER
# ══════════════════════════════════════════════════════════════════════════════


class AsyncSupabaseClient:
    """
    Async wrapper around the synchronous Supabase client.
    
    Uses asyncio.to_thread() to run sync operations without blocking
    the event loop. This is the recommended approach for FastAPI until
    supabase-py has a stable async client.
    
    Usage:
        client = get_async_supabase()
        result = await client.table("users").select("*").execute()
    """
    
    def __init__(self, sync_client: Client):
        self._sync_client = sync_client
    
    def table(self, table_name: str) -> "AsyncTableQuery":
        """Get an async table query builder."""
        return AsyncTableQuery(self._sync_client.table(table_name))
    
    async def rpc(self, function_name: str, params: dict | None = None) -> Any:
        """Execute an RPC function asynchronously."""
        def _sync_call():
            return self._sync_client.rpc(function_name, params or {}).execute()
        return await asyncio.to_thread(_sync_call)
    
    @property
    def auth(self):
        """Access auth client (sync, use for simple operations)."""
        return self._sync_client.auth
    
    @property
    def storage(self):
        """Access storage client (sync)."""
        return self._sync_client.storage


class AsyncTableQuery:
    """
    Async wrapper for Supabase table queries.
    
    Supports method chaining and executes the final query asynchronously.
    """
    
    def __init__(self, query):
        self._query = query
    
    def select(self, columns: str = "*", **kwargs) -> "AsyncTableQuery":
        self._query = self._query.select(columns, **kwargs)
        return self
    
    def insert(self, data: dict | list, **kwargs) -> "AsyncTableQuery":
        self._query = self._query.insert(data, **kwargs)
        return self
    
    def update(self, data: dict, **kwargs) -> "AsyncTableQuery":
        self._query = self._query.update(data, **kwargs)
        return self
    
    def upsert(self, data: dict | list, **kwargs) -> "AsyncTableQuery":
        self._query = self._query.upsert(data, **kwargs)
        return self
    
    def delete(self, **kwargs) -> "AsyncTableQuery":
        self._query = self._query.delete(**kwargs)
        return self
    
    def eq(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.eq(column, value)
        return self
    
    def neq(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.neq(column, value)
        return self
    
    def gt(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.gt(column, value)
        return self
    
    def gte(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.gte(column, value)
        return self
    
    def lt(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.lt(column, value)
        return self
    
    def lte(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.lte(column, value)
        return self
    
    def like(self, column: str, pattern: str) -> "AsyncTableQuery":
        self._query = self._query.like(column, pattern)
        return self
    
    def ilike(self, column: str, pattern: str) -> "AsyncTableQuery":
        self._query = self._query.ilike(column, pattern)
        return self
    
    def is_(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.is_(column, value)
        return self
    
    def in_(self, column: str, values: list) -> "AsyncTableQuery":
        self._query = self._query.in_(column, values)
        return self
    
    def contains(self, column: str, value: Any) -> "AsyncTableQuery":
        self._query = self._query.contains(column, value)
        return self
    
    def order(self, column: str, *, desc: bool = False, **kwargs) -> "AsyncTableQuery":
        self._query = self._query.order(column, desc=desc, **kwargs)
        return self
    
    def limit(self, count: int) -> "AsyncTableQuery":
        self._query = self._query.limit(count)
        return self
    
    def range(self, start: int, end: int) -> "AsyncTableQuery":
        self._query = self._query.range(start, end)
        return self
    
    def single(self) -> "AsyncTableQuery":
        self._query = self._query.single()
        return self
    
    def maybe_single(self) -> "AsyncTableQuery":
        self._query = self._query.maybe_single()
        return self
    
    async def execute(self):
        """Execute the query asynchronously."""
        return await asyncio.to_thread(self._query.execute)


# ══════════════════════════════════════════════════════════════════════════════
# CLIENT INITIALIZATION
# ══════════════════════════════════════════════════════════════════════════════


async def init_supabase() -> None:
    """Initialize Supabase clients."""
    global _supabase_client, _supabase_admin_client
    
    settings = get_settings()
    
    # Public client (uses anon key, respects RLS)
    _supabase_client = create_client(
        settings.supabase_url,
        settings.supabase_anon_key,
    )
    
    # Admin client (uses service role key, bypasses RLS)
    _supabase_admin_client = create_client(
        settings.supabase_url,
        settings.supabase_service_role_key,
    )


async def close_supabase() -> None:
    """Close Supabase clients."""
    global _supabase_client, _supabase_admin_client
    _supabase_client = None
    _supabase_admin_client = None


def get_supabase() -> Client:
    """
    Get the public Supabase client.
    
    This client uses the anon key and respects Row Level Security (RLS).
    Use for operations that should respect user permissions.
    """
    if _supabase_client is None:
        raise RuntimeError("Supabase client not initialized. Call init_supabase() first.")
    return _supabase_client


def get_supabase_admin() -> Client:
    """
    Get the admin Supabase client.
    
    This client uses the service role key and BYPASSES Row Level Security (RLS).
    Use for admin operations, webhooks, or background tasks.
    
    ⚠️ WARNING: Use with caution! This bypasses all security policies.
    """
    if _supabase_admin_client is None:
        raise RuntimeError("Supabase admin client not initialized. Call init_supabase() first.")
    return _supabase_admin_client


def get_async_supabase() -> AsyncSupabaseClient:
    """
    Get an async wrapper around the public Supabase client.
    
    This is the recommended way to use Supabase in FastAPI async endpoints.
    Uses asyncio.to_thread() to avoid blocking the event loop.
    
    Usage:
        client = get_async_supabase()
        result = await client.table("users").select("*").execute()
    """
    return AsyncSupabaseClient(get_supabase())


def get_async_supabase_admin() -> AsyncSupabaseClient:
    """
    Get an async wrapper around the admin Supabase client.
    
    ⚠️ WARNING: This bypasses all RLS security policies.
    Use only for admin operations, webhooks, or background tasks.
    """
    return AsyncSupabaseClient(get_supabase_admin())


# ══════════════════════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ══════════════════════════════════════════════════════════════════════════════


async def execute_rpc(
    function_name: str,
    params: dict | None = None,
    *,
    use_admin: bool = False,
) -> dict:
    """
    Execute a Supabase RPC function.
    
    Args:
        function_name: Name of the RPC function
        params: Parameters to pass to the function
        use_admin: Whether to use admin client (bypasses RLS)
    
    Returns:
        The RPC response data
    """
    client = get_supabase_admin() if use_admin else get_supabase()
    
    response = client.rpc(function_name, params or {}).execute()
    return response.data

"""
Rate Limiter Service

In-memory rate limiting with sliding window algorithm.
For production, replace with Redis-based implementation.
"""

import time
from collections import defaultdict
from dataclasses import dataclass, field
from threading import Lock
from typing import Optional

import structlog

logger = structlog.get_logger()


@dataclass
class RateLimitResult:
    """Result of a rate limit check."""
    allowed: bool
    remaining: int
    reset_at: float
    limit: int
    
    @property
    def retry_after(self) -> int:
        """Seconds until rate limit resets."""
        return max(0, int(self.reset_at - time.time()))


@dataclass
class RateLimitBucket:
    """Sliding window rate limit bucket."""
    requests: list[float] = field(default_factory=list)
    lock: Lock = field(default_factory=Lock)


class RateLimiter:
    """
    In-memory rate limiter using sliding window algorithm.
    
    Thread-safe implementation suitable for single-instance deployment.
    For multi-instance deployment, use Redis-based implementation.
    """
    
    def __init__(self, default_limit: int = 60, window_seconds: int = 60):
        """
        Initialize rate limiter.
        
        Args:
            default_limit: Default requests per window
            window_seconds: Time window in seconds
        """
        self._buckets: dict[str, RateLimitBucket] = defaultdict(RateLimitBucket)
        self._default_limit = default_limit
        self._window_seconds = window_seconds
        self._global_lock = Lock()
    
    def check(
        self,
        key: str,
        limit: Optional[int] = None,
        cost: int = 1,
    ) -> RateLimitResult:
        """
        Check if request is allowed under rate limit.
        
        Args:
            key: Unique identifier (e.g., API key, IP address)
            limit: Custom limit for this key (uses default if None)
            cost: Cost of this request (default 1)
            
        Returns:
            RateLimitResult with allowed status and metadata
        """
        limit = limit or self._default_limit
        now = time.time()
        window_start = now - self._window_seconds
        
        # Get or create bucket
        with self._global_lock:
            if key not in self._buckets:
                self._buckets[key] = RateLimitBucket()
            bucket = self._buckets[key]
        
        with bucket.lock:
            # Remove expired requests (outside window)
            bucket.requests = [ts for ts in bucket.requests if ts > window_start]
            
            current_count = len(bucket.requests)
            remaining = max(0, limit - current_count - cost)
            
            # Calculate reset time (when oldest request expires)
            if bucket.requests:
                reset_at = bucket.requests[0] + self._window_seconds
            else:
                reset_at = now + self._window_seconds
            
            # Check if allowed
            if current_count + cost <= limit:
                # Add request timestamps
                for _ in range(cost):
                    bucket.requests.append(now)
                
                return RateLimitResult(
                    allowed=True,
                    remaining=remaining,
                    reset_at=reset_at,
                    limit=limit,
                )
            else:
                return RateLimitResult(
                    allowed=False,
                    remaining=0,
                    reset_at=reset_at,
                    limit=limit,
                )
    
    def reset(self, key: str) -> None:
        """Reset rate limit for a specific key."""
        with self._global_lock:
            if key in self._buckets:
                with self._buckets[key].lock:
                    self._buckets[key].requests.clear()
    
    def reset_all(self) -> None:
        """Reset all rate limits."""
        with self._global_lock:
            self._buckets.clear()
    
    def get_usage(self, key: str) -> tuple[int, int]:
        """
        Get current usage for a key.
        
        Returns:
            Tuple of (current_count, default_limit)
        """
        now = time.time()
        window_start = now - self._window_seconds
        
        with self._global_lock:
            if key not in self._buckets:
                return (0, self._default_limit)
            bucket = self._buckets[key]
        
        with bucket.lock:
            current_count = len([ts for ts in bucket.requests if ts > window_start])
            return (current_count, self._default_limit)


# Global rate limiter instance
_rate_limiter: Optional[RateLimiter] = None


def get_rate_limiter() -> RateLimiter:
    """Get the global rate limiter instance."""
    global _rate_limiter
    if _rate_limiter is None:
        _rate_limiter = RateLimiter()
    return _rate_limiter


def init_rate_limiter(default_limit: int = 60, window_seconds: int = 60) -> RateLimiter:
    """Initialize the global rate limiter with custom settings."""
    global _rate_limiter
    _rate_limiter = RateLimiter(default_limit=default_limit, window_seconds=window_seconds)
    return _rate_limiter

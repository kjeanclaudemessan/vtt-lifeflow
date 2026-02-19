"""
Tests for Rate Limiter Service

Tests the in-memory rate limiter with sliding window algorithm.
"""

import time
from unittest.mock import patch

import pytest

from app.core.rate_limiter import (
    RateLimiter,
    RateLimitBucket,
    RateLimitResult,
    get_rate_limiter,
    init_rate_limiter,
)


class TestRateLimitResult:
    """Tests for RateLimitResult dataclass."""

    def test_retry_after_positive(self):
        """retry_after returns positive value when reset is in future."""
        future_time = time.time() + 30
        result = RateLimitResult(
            allowed=False,
            remaining=0,
            reset_at=future_time,
            limit=60,
        )
        # Should be approximately 30 seconds
        assert 28 <= result.retry_after <= 32

    def test_retry_after_zero_when_past(self):
        """retry_after returns 0 when reset time is in past."""
        past_time = time.time() - 10
        result = RateLimitResult(
            allowed=True,
            remaining=50,
            reset_at=past_time,
            limit=60,
        )
        assert result.retry_after == 0


class TestRateLimiter:
    """Tests for RateLimiter class."""

    def test_initialization(self):
        """Test rate limiter initialization."""
        limiter = RateLimiter(default_limit=100, window_seconds=30)
        assert limiter._default_limit == 100
        assert limiter._window_seconds == 30

    def test_first_request_allowed(self):
        """First request should always be allowed."""
        limiter = RateLimiter(default_limit=10)
        result = limiter.check("test_key")
        
        assert result.allowed is True
        assert result.remaining == 9
        assert result.limit == 10

    def test_requests_within_limit(self):
        """Multiple requests within limit should be allowed."""
        limiter = RateLimiter(default_limit=10)
        
        for i in range(10):
            result = limiter.check("test_key")
            assert result.allowed is True
            assert result.remaining == 10 - i - 1

    def test_requests_exceed_limit(self):
        """Requests exceeding limit should be denied."""
        limiter = RateLimiter(default_limit=5)
        
        # Use up the limit
        for _ in range(5):
            result = limiter.check("test_key")
            assert result.allowed is True
        
        # Next request should be denied
        result = limiter.check("test_key")
        assert result.allowed is False
        assert result.remaining == 0

    def test_custom_limit_per_key(self):
        """Custom limit can be specified per key."""
        limiter = RateLimiter(default_limit=10)
        
        # Key with custom limit of 3
        for _ in range(3):
            result = limiter.check("custom_key", limit=3)
            assert result.allowed is True
        
        # Should be denied now
        result = limiter.check("custom_key", limit=3)
        assert result.allowed is False

    def test_request_cost(self):
        """Request cost parameter should consume multiple slots."""
        limiter = RateLimiter(default_limit=10)
        
        # First request costs 5
        result = limiter.check("cost_key", cost=5)
        assert result.allowed is True
        assert result.remaining == 5
        
        # Second request costs 5
        result = limiter.check("cost_key", cost=5)
        assert result.allowed is True
        assert result.remaining == 0
        
        # Third request (even cost=1) should be denied
        result = limiter.check("cost_key", cost=1)
        assert result.allowed is False

    def test_cost_exceeds_remaining(self):
        """High cost request should be denied if it exceeds remaining."""
        limiter = RateLimiter(default_limit=10)
        
        # Use 8 requests
        for _ in range(8):
            limiter.check("partial_key")
        
        # Cost of 3 exceeds remaining 2
        result = limiter.check("partial_key", cost=3)
        assert result.allowed is False

    def test_different_keys_independent(self):
        """Different keys should have independent limits."""
        limiter = RateLimiter(default_limit=3)
        
        # Exhaust key1
        for _ in range(3):
            limiter.check("key1")
        result = limiter.check("key1")
        assert result.allowed is False
        
        # key2 should still have full limit
        result = limiter.check("key2")
        assert result.allowed is True
        assert result.remaining == 2

    def test_sliding_window_expiry(self):
        """Old requests should expire after window."""
        # Use 1 second window for fast testing
        limiter = RateLimiter(default_limit=2, window_seconds=1)
        
        # Use up the limit
        limiter.check("expire_key")
        limiter.check("expire_key")
        
        result = limiter.check("expire_key")
        assert result.allowed is False
        
        # Wait for window to expire
        time.sleep(1.1)
        
        # Should be allowed again
        result = limiter.check("expire_key")
        assert result.allowed is True

    def test_reset_specific_key(self):
        """Reset should clear requests for specific key."""
        limiter = RateLimiter(default_limit=3)
        
        # Use some quota
        limiter.check("reset_key")
        limiter.check("reset_key")
        limiter.check("other_key")
        
        # Reset reset_key
        limiter.reset("reset_key")
        
        # reset_key should have full limit
        result = limiter.check("reset_key")
        assert result.remaining == 2
        
        # other_key still has used quota
        current, _ = limiter.get_usage("other_key")
        assert current == 1

    def test_reset_all(self):
        """Reset all should clear all keys."""
        limiter = RateLimiter(default_limit=5)
        
        limiter.check("key1")
        limiter.check("key2")
        limiter.check("key3")
        
        limiter.reset_all()
        
        for key in ["key1", "key2", "key3"]:
            current, _ = limiter.get_usage(key)
            assert current == 0

    def test_get_usage(self):
        """get_usage should return current count and limit."""
        limiter = RateLimiter(default_limit=10)
        
        # Fresh key
        current, limit = limiter.get_usage("usage_key")
        assert current == 0
        assert limit == 10
        
        # After some requests
        limiter.check("usage_key")
        limiter.check("usage_key")
        limiter.check("usage_key")
        
        current, limit = limiter.get_usage("usage_key")
        assert current == 3
        assert limit == 10

    def test_reset_time_calculation(self):
        """Reset time should be when oldest request expires."""
        limiter = RateLimiter(default_limit=10, window_seconds=60)
        
        result = limiter.check("reset_time_key")
        # Reset time should be approximately 60 seconds from now
        expected_reset = time.time() + 60
        assert abs(result.reset_at - expected_reset) < 2

    def test_thread_safety_basic(self):
        """Basic thread safety test."""
        import threading
        
        limiter = RateLimiter(default_limit=1000, window_seconds=60)
        results = []
        
        def make_request():
            for _ in range(10):
                result = limiter.check("thread_key")
                results.append(result.allowed)
        
        threads = [threading.Thread(target=make_request) for _ in range(10)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        
        # All 100 requests should be allowed (limit is 1000)
        assert all(results)
        
        current, _ = limiter.get_usage("thread_key")
        assert current == 100


class TestGlobalRateLimiter:
    """Tests for global rate limiter functions."""

    def test_get_rate_limiter_singleton(self):
        """get_rate_limiter should return same instance."""
        # Reset global state
        import app.core.rate_limiter as rl_module
        rl_module._rate_limiter = None
        
        limiter1 = get_rate_limiter()
        limiter2 = get_rate_limiter()
        
        assert limiter1 is limiter2

    def test_init_rate_limiter(self):
        """init_rate_limiter should create with custom settings."""
        import app.core.rate_limiter as rl_module
        rl_module._rate_limiter = None
        
        limiter = init_rate_limiter(default_limit=500, window_seconds=120)
        
        assert limiter._default_limit == 500
        assert limiter._window_seconds == 120
        
        # Cleanup
        rl_module._rate_limiter = None

"""VTT FastAPI Template - Webhook verification utilities."""

import hashlib
import hmac

from app.core.config import get_settings


def verify_moneroo_signature(payload: bytes, signature: str) -> bool:
    """
    Verify Moneroo webhook signature.
    
    Args:
        payload: Raw request body
        signature: X-Moneroo-Signature header value
    
    Returns:
        True if signature is valid
    """
    settings = get_settings()
    
    if not settings.moneroo_webhook_secret:
        return False
    
    expected = hmac.new(
        settings.moneroo_webhook_secret.encode(),
        payload,
        hashlib.sha256,
    ).hexdigest()
    
    return hmac.compare_digest(expected, signature)


def verify_stripe_signature(payload: bytes, signature: str) -> bool:
    """
    Verify Stripe webhook signature.
    
    Note: For production, use stripe.Webhook.construct_event()
    
    Args:
        payload: Raw request body
        signature: Stripe-Signature header value
    
    Returns:
        True if signature is valid
    """
    settings = get_settings()
    
    if not settings.stripe_webhook_secret:
        return False
    
    # Stripe signature format: t=timestamp,v1=signature
    # For simplicity, this is a basic implementation
    # Use stripe library for production
    
    try:
        parts = dict(item.split("=") for item in signature.split(","))
        timestamp = parts.get("t", "")
        sig = parts.get("v1", "")
        
        signed_payload = f"{timestamp}.{payload.decode()}"
        expected = hmac.new(
            settings.stripe_webhook_secret.encode(),
            signed_payload.encode(),
            hashlib.sha256,
        ).hexdigest()
        
        return hmac.compare_digest(expected, sig)
    except Exception:
        return False

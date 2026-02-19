"""Tests for webhooks module."""

import hmac
import hashlib
import json


def test_moneroo_webhook_success(client):
    """Test Moneroo webhook with valid payload."""
    payload = {
        "event": "payment.success",
        "data": {
            "id": "txn_123",
            "amount": 1000,
            "currency": "XOF",
        },
    }
    
    body = json.dumps(payload)
    signature = hmac.new(
        b"test-moneroo-secret",
        body.encode(),
        hashlib.sha256,
    ).hexdigest()
    
    response = client.post(
        "/api/v1/webhooks/moneroo",
        content=body,
        headers={
            "Content-Type": "application/json",
            "X-Moneroo-Signature": signature,
        },
    )
    
    assert response.status_code == 200
    data = response.json()
    assert data["received"] is True


def test_moneroo_webhook_invalid_signature(client):
    """Test Moneroo webhook with invalid signature."""
    payload = {"event": "payment.success", "data": {}}
    
    response = client.post(
        "/api/v1/webhooks/moneroo",
        json=payload,
        headers={"X-Moneroo-Signature": "invalid-signature"},
    )
    
    assert response.status_code == 401


def test_moneroo_webhook_no_signature(client):
    """Test Moneroo webhook without signature (allowed in dev)."""
    payload = {
        "event": "payment.pending",
        "data": {"id": "txn_456"},
    }
    
    response = client.post(
        "/api/v1/webhooks/moneroo",
        json=payload,
    )
    
    # Should succeed without signature in dev mode
    assert response.status_code == 200


def test_stripe_webhook(client):
    """Test Stripe webhook endpoint exists."""
    response = client.post(
        "/api/v1/webhooks/stripe",
        json={"type": "payment_intent.succeeded", "data": {}},
    )
    
    assert response.status_code == 200

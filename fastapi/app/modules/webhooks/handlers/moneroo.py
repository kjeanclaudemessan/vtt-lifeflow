"""VTT FastAPI Template - Moneroo webhook handler."""

import structlog

from app.modules.webhooks.schemas import MonerooWebhookEvent

logger = structlog.get_logger()


async def handle_moneroo_event(event: MonerooWebhookEvent) -> None:
    """
    Handle Moneroo webhook events.
    
    Events:
    - payment.success
    - payment.failed
    - payment.pending
    """
    event_type = event.event
    data = event.data
    
    await logger.ainfo(
        "moneroo_webhook_received",
        event_type=event_type,
        transaction_id=data.get("id"),
    )
    
    match event_type:
        case "payment.success":
            await _handle_payment_success(data)
        case "payment.failed":
            await _handle_payment_failed(data)
        case "payment.pending":
            await _handle_payment_pending(data)
        case _:
            await logger.awarning("moneroo_unknown_event", event_type=event_type)


async def _handle_payment_success(data: dict) -> None:
    """Handle successful payment."""
    transaction_id = data.get("id")
    amount = data.get("amount")
    currency = data.get("currency")
    
    await logger.ainfo(
        "payment_success",
        transaction_id=transaction_id,
        amount=amount,
        currency=currency,
    )
    
    # TODO: Update payment status in database
    # TODO: Trigger any post-payment actions (activate subscription, send email, etc.)


async def _handle_payment_failed(data: dict) -> None:
    """Handle failed payment."""
    transaction_id = data.get("id")
    error = data.get("error", {})
    
    await logger.awarning(
        "payment_failed",
        transaction_id=transaction_id,
        error=error,
    )
    
    # TODO: Update payment status in database
    # TODO: Notify user of failed payment


async def _handle_payment_pending(data: dict) -> None:
    """Handle pending payment."""
    transaction_id = data.get("id")
    
    await logger.ainfo(
        "payment_pending",
        transaction_id=transaction_id,
    )
    
    # TODO: Update payment status in database

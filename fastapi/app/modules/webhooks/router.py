"""VTT FastAPI Template - Webhooks module router."""

from fastapi import APIRouter, Header, HTTPException, Request
import structlog

from app.modules.webhooks.handlers import handle_moneroo_event
from app.modules.webhooks.schemas import MonerooWebhookEvent
from app.modules.webhooks.verification import verify_moneroo_signature
from app.schemas import WebhookResponse

logger = structlog.get_logger()

router = APIRouter(prefix="/webhooks", tags=["Webhooks"])


@router.post(
    "/moneroo",
    response_model=WebhookResponse,
    summary="Moneroo webhook",
    description="Handle Moneroo payment webhook events.",
)
async def moneroo_webhook(
    request: Request,
    x_moneroo_signature: str | None = Header(default=None),
) -> WebhookResponse:
    """Handle Moneroo webhook."""
    # Get raw body for signature verification
    body = await request.body()
    
    # Verify signature (skip in development if no secret configured)
    if x_moneroo_signature:
        if not verify_moneroo_signature(body, x_moneroo_signature):
            await logger.awarning("moneroo_invalid_signature")
            raise HTTPException(status_code=401, detail="Invalid signature")
    
    # Parse event
    try:
        import orjson
        data = orjson.loads(body)
        event = MonerooWebhookEvent(**data)
    except Exception as e:
        await logger.aerror("moneroo_parse_error", error=str(e))
        raise HTTPException(status_code=400, detail="Invalid payload")
    
    # Handle event
    await handle_moneroo_event(event)
    
    return WebhookResponse(message="Moneroo webhook processed")


@router.post(
    "/stripe",
    response_model=WebhookResponse,
    summary="Stripe webhook",
    description="Handle Stripe payment webhook events.",
)
async def stripe_webhook(
    request: Request,
    stripe_signature: str | None = Header(default=None),
) -> WebhookResponse:
    """Handle Stripe webhook."""
    # Get raw body
    body = await request.body()
    
    await logger.ainfo("stripe_webhook_received")
    
    # TODO: Implement Stripe webhook handling
    # Use stripe.Webhook.construct_event() for signature verification
    
    return WebhookResponse(message="Stripe webhook processed")

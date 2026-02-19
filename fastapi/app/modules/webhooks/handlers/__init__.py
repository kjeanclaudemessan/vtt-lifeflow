"""VTT FastAPI Template - Webhook handlers."""

from app.modules.webhooks.handlers.moneroo import handle_moneroo_event

__all__ = ["handle_moneroo_event"]

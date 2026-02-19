"""
Playground Router - Web interface for testing widgets and AI

Provides endpoints for the widget playground demo.
"""

from typing import Optional

from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel

from app.services.ai_service import get_ai_service, AIService

router = APIRouter()


class ChatRequest(BaseModel):
    """Chat request payload."""
    message: str
    history: Optional[list[dict]] = None
    use_widgets: bool = False


class ChatResponse(BaseModel):
    """Chat response payload."""
    text: str
    widgets: list[dict] = []


# Available widgets for AI to use
AVAILABLE_WIDGETS = [
    "text",
    "text_markdown", 
    "image",
    "button",
    "buttons",
    "quick_replies",
    "list",
    "carousel",
    "product_card",
]


@router.get("")
async def playground_ui():
    """Serve the playground HTML interface."""
    import os
    static_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.dirname(__file__))),
        "static",
        "playground.html"
    )
    return FileResponse(static_path, media_type="text/html")


@router.post("/chat", response_model=ChatResponse)
async def chat_with_ai(request: ChatRequest):
    """
    Chat with AI assistant.
    
    Can optionally use widgets for rich responses.
    """
    try:
        ai_service = get_ai_service()
    except ValueError as e:
        raise HTTPException(
            status_code=500,
            detail="OpenAI API key not configured"
        )
    
    try:
        if request.use_widgets:
            # Generate response with potential widgets
            result = await ai_service.generate_widget_response(
                user_message=request.message,
                available_widgets=AVAILABLE_WIDGETS,
            )
            return ChatResponse(
                text=result.get("text", ""),
                widgets=result.get("widgets", []),
            )
        else:
            # Simple text response
            text = await ai_service.generate_response(
                user_message=request.message,
                conversation_history=request.history,
            )
            return ChatResponse(text=text, widgets=[])
            
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"AI service error: {str(e)}"
        )


@router.get("/widgets")
async def list_available_widgets():
    """List all widgets available for the AI to use."""
    return {
        "widgets": AVAILABLE_WIDGETS,
        "examples": {
            "text": {"type": "text", "data": {"content": "Hello!"}},
            "buttons": {
                "type": "buttons",
                "data": {
                    "buttons": [
                        {"label": "Yes", "action": "postback", "value": "yes", "style": "primary"},
                        {"label": "No", "action": "postback", "value": "no", "style": "secondary"},
                    ]
                }
            },
            "quick_replies": {
                "type": "quick_replies",
                "data": {
                    "replies": [
                        {"label": "👍 Yes", "value": "yes"},
                        {"label": "👎 No", "value": "no"},
                    ]
                }
            },
        }
    }

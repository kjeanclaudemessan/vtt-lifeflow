"""VTT FastAPI Template - Core module."""

from app.core.config import Settings, get_settings
from app.core.exceptions import (
    AppException,
    BadRequestException,
    ConflictException,
    ExternalServiceException,
    ForbiddenException,
    NotFoundException,
    ServiceUnavailableException,
    UnauthorizedException,
    ValidationException,
)
from app.core.lifespan import lifespan
from app.core.middleware import setup_middleware
from app.core.security import (
    decode_jwt,
    get_user_id_from_token,
    hash_password,
    verify_password,
)

__all__ = [
    # Config
    "Settings",
    "get_settings",
    # Security
    "decode_jwt",
    "get_user_id_from_token",
    "hash_password",
    "verify_password",
    # Exceptions
    "AppException",
    "BadRequestException",
    "ConflictException",
    "ExternalServiceException",
    "ForbiddenException",
    "NotFoundException",
    "ServiceUnavailableException",
    "UnauthorizedException",
    "ValidationException",
    # Middleware
    "setup_middleware",
    # Lifespan
    "lifespan",
]

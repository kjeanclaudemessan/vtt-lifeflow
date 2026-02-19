"""VTT FastAPI Template - Schemas module."""

from app.schemas.base import (
    BaseSchema,
    ErrorResponse,
    MessageResponse,
    MetadataMixin,
    PreferencesMixin,
    SoftDeleteMixin,
    SuccessResponse,
    TimestampMixin,
)
from app.schemas.common import (
    DateRangeFilter,
    HealthCheckResponse,
    IDSchema,
    IDsSchema,
    PolymorphicReference,
    SearchFilter,
    UserReference,
    WebhookResponse,
)
from app.schemas.pagination import (
    CursorPaginatedResponse,
    CursorPaginationParams,
    PaginatedResponse,
    PaginationParams,
)

__all__ = [
    # Base
    "BaseSchema",
    "SuccessResponse",
    "ErrorResponse",
    "MessageResponse",
    "TimestampMixin",
    "SoftDeleteMixin",
    "MetadataMixin",
    "PreferencesMixin",
    # Pagination
    "PaginationParams",
    "PaginatedResponse",
    "CursorPaginationParams",
    "CursorPaginatedResponse",
    # Common
    "IDSchema",
    "IDsSchema",
    "UserReference",
    "HealthCheckResponse",
    "WebhookResponse",
    "PolymorphicReference",
    "DateRangeFilter",
    "SearchFilter",
]

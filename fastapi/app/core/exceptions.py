"""VTT FastAPI Template - Custom exceptions."""

from typing import Any

from fastapi import HTTPException, status


class AppException(HTTPException):
    """Base application exception."""

    def __init__(
        self,
        status_code: int,
        error: str,
        detail: str | None = None,
        code: str | None = None,
        headers: dict[str, str] | None = None,
    ):
        super().__init__(
            status_code=status_code,
            detail={
                "success": False,
                "error": error,
                "detail": detail,
                "code": code,
            },
            headers=headers,
        )


# ══════════════════════════════════════════════════════════════════════════════
# AUTH EXCEPTIONS
# ══════════════════════════════════════════════════════════════════════════════


class UnauthorizedException(AppException):
    """401 Unauthorized."""

    def __init__(
        self,
        error: str = "Unauthorized",
        detail: str | None = "Invalid or missing authentication token",
        code: str = "UNAUTHORIZED",
    ):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            error=error,
            detail=detail,
            code=code,
            headers={"WWW-Authenticate": "Bearer"},
        )


class ForbiddenException(AppException):
    """403 Forbidden."""

    def __init__(
        self,
        error: str = "Forbidden",
        detail: str | None = "You don't have permission to access this resource",
        code: str = "FORBIDDEN",
    ):
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            error=error,
            detail=detail,
            code=code,
        )


# ══════════════════════════════════════════════════════════════════════════════
# RESOURCE EXCEPTIONS
# ══════════════════════════════════════════════════════════════════════════════


class NotFoundException(AppException):
    """404 Not Found."""

    def __init__(
        self,
        resource: str = "Resource",
        detail: str | None = None,
        code: str = "NOT_FOUND",
    ):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            error=f"{resource} not found",
            detail=detail or f"The requested {resource.lower()} does not exist",
            code=code,
        )


class ConflictException(AppException):
    """409 Conflict."""

    def __init__(
        self,
        error: str = "Conflict",
        detail: str | None = "Resource already exists",
        code: str = "CONFLICT",
    ):
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            error=error,
            detail=detail,
            code=code,
        )


# ══════════════════════════════════════════════════════════════════════════════
# VALIDATION EXCEPTIONS
# ══════════════════════════════════════════════════════════════════════════════


class BadRequestException(AppException):
    """400 Bad Request."""

    def __init__(
        self,
        error: str = "Bad Request",
        detail: str | None = "Invalid request data",
        code: str = "BAD_REQUEST",
    ):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            error=error,
            detail=detail,
            code=code,
        )


class ValidationException(AppException):
    """422 Validation Error."""

    def __init__(
        self,
        error: str = "Validation Error",
        detail: str | None = None,
        errors: list[dict[str, Any]] | None = None,
        code: str = "VALIDATION_ERROR",
    ):
        super().__init__(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            error=error,
            detail=detail or str(errors),
            code=code,
        )


# ══════════════════════════════════════════════════════════════════════════════
# EXTERNAL SERVICE EXCEPTIONS
# ══════════════════════════════════════════════════════════════════════════════


class ExternalServiceException(AppException):
    """502 Bad Gateway - External service error."""

    def __init__(
        self,
        service: str,
        detail: str | None = None,
        code: str = "EXTERNAL_SERVICE_ERROR",
    ):
        super().__init__(
            status_code=status.HTTP_502_BAD_GATEWAY,
            error=f"{service} service error",
            detail=detail or f"Error communicating with {service}",
            code=code,
        )


class ServiceUnavailableException(AppException):
    """503 Service Unavailable."""

    def __init__(
        self,
        error: str = "Service Unavailable",
        detail: str | None = "Service is temporarily unavailable",
        code: str = "SERVICE_UNAVAILABLE",
    ):
        super().__init__(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            error=error,
            detail=detail,
            code=code,
        )

"""lifeflow - Core Configuration."""

from typing import Literal

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # ══════════════════════════════════════════════════════════════════════════
    # APP
    # ══════════════════════════════════════════════════════════════════════════
    app_name: str = "LifeFlow"
    app_env: Literal["development", "staging", "production"] = "development"
    debug: bool = False
    api_v1_prefix: str = "/api/v1"

    # ══════════════════════════════════════════════════════════════════════════
    # SUPABASE
    # ══════════════════════════════════════════════════════════════════════════
    supabase_url: str = Field(..., description="Supabase project URL")
    supabase_anon_key: str = Field(..., description="Supabase anon/public key")
    supabase_service_role_key: str = Field(
        ..., description="Supabase service role key (server-side only)"
    )

    # ══════════════════════════════════════════════════════════════════════════
    # JWT (Supabase JWT verification)
    # ══════════════════════════════════════════════════════════════════════════
    jwt_secret: str = Field(..., description="Supabase JWT secret")
    jwt_algorithm: str = "HS256"

    # ══════════════════════════════════════════════════════════════════════════
    # REDIS (optional)
    # ══════════════════════════════════════════════════════════════════════════
    redis_url: str | None = None

    # ══════════════════════════════════════════════════════════════════════════
    # EMAIL (optional)
    # ══════════════════════════════════════════════════════════════════════════
    resend_api_key: str | None = None
    email_from: str = "noreply@example.com"

    # ══════════════════════════════════════════════════════════════════════════
    # SMS (optional)
    # ══════════════════════════════════════════════════════════════════════════
    twilio_account_sid: str | None = None
    twilio_auth_token: str | None = None
    twilio_phone_number: str | None = None

    # ══════════════════════════════════════════════════════════════════════════
    # PUSH NOTIFICATIONS (optional)
    # ══════════════════════════════════════════════════════════════════════════
    firebase_project_id: str | None = None
    firebase_credentials_path: str | None = None

    # ══════════════════════════════════════════════════════════════════════════
    # PAYMENTS (optional)
    # ══════════════════════════════════════════════════════════════════════════
    moneroo_api_key: str | None = None
    moneroo_webhook_secret: str | None = None
    stripe_api_key: str | None = None
    stripe_webhook_secret: str | None = None

    # ══════════════════════════════════════════════════════════════════════════
    # AI (optional)
    # ══════════════════════════════════════════════════════════════════════════
    openai_api_key: str | None = None
    anthropic_api_key: str | None = None
    mistral_api_key: str | None = None
    groq_api_key: str | None = None

    # ══════════════════════════════════════════════════════════════════════════

    # ══════════════════════════════════════════════════════════════════════════

    # ══════════════════════════════════════════════════════════════════════════
    # CORS
    # ══════════════════════════════════════════════════════════════════════════
    cors_origins: list[str] = ["http://localhost:3000"]

    @field_validator("cors_origins", mode="before")
    @classmethod
    def parse_cors_origins(cls, v: str | list[str]) -> list[str]:
        """Parse CORS origins from comma-separated string or list."""
        if isinstance(v, str):
            return [origin.strip() for origin in v.split(",") if origin.strip()]
        return v

    # ══════════════════════════════════════════════════════════════════════════
    # COMPUTED PROPERTIES
    # ══════════════════════════════════════════════════════════════════════════
    @property
    def is_development(self) -> bool:
        return self.app_env == "development"

    @property
    def is_staging(self) -> bool:
        return self.app_env == "staging"

    @property
    def is_production(self) -> bool:
        return self.app_env == "production"

    @property
    def is_debug(self) -> bool:
        return self.is_development or self.is_staging


# Settings cache
_settings: Settings | None = None


def get_settings() -> Settings:
    """Get cached settings instance."""
    global _settings
    if _settings is None:
        _settings = Settings()
    return _settings


def clear_settings_cache() -> None:
    """Clear settings cache (for testing)."""
    global _settings
    _settings = None

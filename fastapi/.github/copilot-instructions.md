# FastAPI — Copilot Instructions

> **FastAPI layer** of the VTT monorepo template.
> Stack: FastAPI 0.128+, Python 3.13+, Pydantic v2, httpx async, supabase-py, structlog.

---

## Architecture: Clean Architecture with Modular Design

### Layer Dependency Rules

```
✅ Core      → No dependencies
✅ DB        → Core
✅ Services  → Core, DB
✅ Modules   → Services, Core
✅ API       → Modules, Core
```

### Folder Structure (`app/`)

```
app/
├── main.py                           # Application factory (create_app)
├── core/                             # Foundations
│   ├── config.py                     # Settings (pydantic-settings, env-based)
│   ├── security.py                   # JWT decode, password hashing (bcrypt)
│   ├── exceptions.py                 # AppException hierarchy
│   ├── middleware.py                 # CORS, request logging
│   ├── lifespan.py                   # Startup/shutdown (Supabase init)
│   ├── rate_limiter.py               # Rate limiting
│   └── __init__.py                   # Barrel exports
├── db/                               # Database clients
│   ├── supabase.py                   # Supabase client (sync + async wrapper)
│   └── redis.py                      # Redis client (optional)
├── schemas/                          # Shared Pydantic schemas
│   ├── base.py                       # BaseSchema, SuccessResponse[T], ErrorResponse, MessageResponse
│   ├── pagination.py                 # PaginationParams, PaginatedResponse
│   └── common.py                     # Shared schemas
├── modules/                          # Feature modules (mirror Flutter)
│   ├── auth/                         # JWT verification, get_current_user
│   ├── profile/                      # GET/PATCH current user profile
│   ├── health/                       # Health check endpoint
│   ├── webhooks/                     # Webhook handlers
│   ├── playground/                   # Testing/dev endpoints
│   ├── ai_agent/                     # AI Agent (conditional)
│   └── chat_platform/                # Chat Platform (conditional)
├── services/                         # External service wrappers
│   ├── email/                        # Resend, SendGrid
│   ├── sms/                          # Twilio
│   ├── storage/                      # Supabase Storage
│   └── push/                         # FCM
├── features/                         # Project-specific features (empty in template)
└── api/
    └── v1/
        ├── router.py                 # Main API router (includes all module routers)
        └── __init__.py               # Exports api_router
```

---

## Key Patterns

### Application Factory

```python
def create_app() -> FastAPI:
    from app.api.v1 import api_router
    from app.core import get_settings, lifespan, setup_middleware

    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        default_response_class=ORJSONResponse,
        lifespan=lifespan,
    )
    setup_middleware(app)
    app.include_router(api_router, prefix=settings.api_v1_prefix)
    return app
```

### Settings (pydantic-settings)

```python
class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    app_name: str = "VTT App"
    app_env: str = "development"
    supabase_url: str
    supabase_anon_key: str
    supabase_service_role_key: str
    jwt_secret: str

    # Feature flags
    ai_agent_enabled: bool = False
    chat_platform_enabled: bool = False

    @property
    def is_development(self) -> bool:
        return self.app_env == "development"

# Singleton with cache
_settings: Settings | None = None
def get_settings() -> Settings: ...
def clear_settings_cache(): ...  # For tests
```

### Dependency Injection (FastAPI Depends)

```python
from fastapi import Depends
from app.modules.auth.dependencies import get_current_user

@router.get("/me")
async def get_me(current_user: CurrentUser = Depends(get_current_user)):
    return SuccessResponse(data=current_user)
```

### Auth Dependencies Hierarchy

```python
get_current_user           # Required auth — raises 401 if missing/invalid
get_current_active_user    # Required auth + active check
get_optional_user          # Optional auth — returns None if no token
require_role("admin")      # Role-based access control (dependency factory)
require_admin              # Shortcut for admin role
```

### Exception Hierarchy

```python
AppException(HTTPException)
├── UnauthorizedException   # 401 (+ WWW-Authenticate header)
├── ForbiddenException      # 403
├── NotFoundException       # 404 (takes resource param)
├── BadRequestException     # 400
├── ConflictException       # 409
├── ValidationException     # 422
├── ExternalServiceException  # 502 (takes service_name param)
└── ServiceUnavailableException  # 503
```

### Standard Responses

```python
# Success with data
SuccessResponse[T](success=True, data=..., message="...")

# Simple message
MessageResponse(success=True, message="Done")

# Error (via exceptions — auto-formatted)
{"success": False, "error": "...", "detail": "...", "code": "..."}

# Paginated list
PaginatedResponse[T](items=[...], total=100, page=1, page_size=20, pages=5)
```

### Pydantic Schema Conventions

```python
from app.schemas.base import BaseSchema, TimestampMixin, SoftDeleteMixin, MetadataMixin

class ProfileBase(BaseSchema):
    first_name: str
    last_name: str

class ProfileResponse(ProfileBase, TimestampMixin):
    id: UUID

class ProfileUpdate(BaseSchema):
    first_name: str | None = None   # All optional for PATCH
    last_name: str | None = None
```

### Supabase Client

```python
from app.db.supabase import get_supabase

# Two clients:
# - supabase_client (anon key, respects RLS)
# - supabase_admin  (service role, bypasses RLS)

# Async wrapper: AsyncSupabaseClient wraps sync client via run_in_executor
# Query builder mirrors all Supabase methods: select, insert, update, delete, eq, neq, etc.
# Accessors: .table(), .auth, .storage, .functions
# Helper: call_rpc() — async RPC shortcut
```

---

## Module Structure

```
modules/<name>/
├── __init__.py          # Re-exports: router, schemas, service, dependencies
├── router.py            # APIRouter with endpoints
├── service.py           # Business logic class (async methods)
├── schemas.py           # Pydantic request/response models
├── dependencies.py      # FastAPI Depends functions (optional)
└── repository.py        # Data access layer (optional, for complex modules)
```

### Router Pattern

```python
router = APIRouter(prefix="/profile", tags=["Profile"])

@router.get("/me", response_model=SuccessResponse[ProfileResponse])
async def get_my_profile(current_user: CurrentUser = Depends(get_current_user)):
    """Get current user profile."""
    service = ProfileService()
    profile = await service.get_profile(current_user.id)
    return SuccessResponse(data=profile, message="Profile retrieved")
```

### Repository Pattern (optional)

```python
class ProfileRepository:
    TABLE = "profiles"

    async def get_by_id(self, user_id: UUID) -> ProfileResponse | None:
        result = await supabase_admin.table(self.TABLE).select("*").eq("id", str(user_id)).single().execute()
        return ProfileResponse(**result.data) if result.data else None
```

### Service Pattern

```python
class ProfileService:
    def __init__(self, repository: ProfileRepository | None = None):
        self.repository = repository or ProfileRepository()

    async def get_profile(self, user_id: UUID) -> ProfileResponse:
        profile = await self.repository.get_by_id(user_id)
        if not profile:
            raise NotFoundException(resource="Profile")
        return profile
```

### Main Router (`api/v1/router.py`)

```python
api_router = APIRouter()

# Core (always included)
api_router.include_router(auth_router)
api_router.include_router(profile_router)
api_router.include_router(health_router)
api_router.include_router(webhook_router)

# Conditional (settings flags)
if settings.ai_agent_enabled:
    from app.modules.ai_agent import router as ai_agent_router
    api_router.include_router(ai_agent_router, prefix="/ai-agent")
```

---

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case` | `user_service.py`, `config.py` |
| Classes | `PascalCase` | `UserService`, `CurrentUser` |
| Functions | `snake_case` | `get_current_user`, `verify_token` |
| Variables | `snake_case` | `user_id`, `access_token` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRIES` |
| Routes | kebab-case | `/api/v1/users/me` |
| Pydantic schemas | `PascalCase` | `TokenPayload`, `VerifyTokenRequest` |
| Router files | `router.py` | Always `router.py` inside module |
| Service files | `service.py` | Always `service.py` inside module |
| Schema files | `schemas.py` | Always `schemas.py` inside module |
| Dependency files | `dependencies.py` | Always `dependencies.py` inside module |

---

## Import Conventions

```python
# Standard library
from datetime import datetime
from typing import Any
from uuid import UUID

# Third-party
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

# App core
from app.core import get_settings, UnauthorizedException
from app.core.security import decode_jwt

# App DB
from app.db.supabase import get_supabase, supabase_admin

# App schemas
from app.schemas import SuccessResponse, MessageResponse

# App modules
from app.modules.auth import get_current_user, CurrentUser
```

**Section banners:** Use `# ═══════════════════` separators for visual grouping in longer files.

**Type hints:** Use Python 3.10+ union syntax (`str | None`) instead of `Optional[str]`.

**Async:** All router handlers and service/repository methods are `async def`.

---

## Testing Patterns

```
tests/
├── conftest.py              # Fixtures: client, mock_supabase, auth_headers
├── core/                    # Config, security tests
├── modules/                 # Module-level tests
├── services/                # Service tests
└── integration/             # Real Supabase integration tests
```

### Fixtures

```python
# conftest.py provides:
@pytest.fixture
def mock_supabase():         # Mocked Supabase client pair (client, admin)

@pytest.fixture
def client(mock_supabase):   # TestClient with mocked Supabase

@pytest.fixture
def auth_headers():          # Valid JWT Bearer headers for test user

# Usage:
def test_get_me(client, auth_headers):
    response = client.get("/api/v1/auth/me", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["success"] is True
```

### Config

- `asyncio_mode = "auto"` in pytest config
- Tests use monkeypatched env vars (not real `.env`)
- `clear_settings_cache()` called per test
- Integration tests in `tests/integration/` use real Supabase

---

## Tooling

| Tool | Config |
|------|--------|
| Linting | `ruff` — line-length 88, rules: E/W/F/I/B/C4/UP, isort with `known-first-party = ["app"]` |
| Type checking | `mypy` — Python 3.13 target |
| Testing | `pytest` + `pytest-asyncio` + `pytest-cov` |
| HTTP client | `httpx` for async HTTP calls |
| Logging | `structlog` for structured logging |

---

## Key Rules

1. **FastAPI does NOT create DB tables** — all schema lives in Supabase migrations.
2. **FastAPI only verifies JWT** — Supabase handles auth operations (login, register, refresh).
3. **All methods are `async def`** — use `await` for all I/O operations.
4. **Use typed responses** — `SuccessResponse[T]`, `MessageResponse`, `PaginatedResponse[T]`.
5. **Raise exceptions, don't return errors** — use the `AppException` hierarchy.
6. **Modules are self-contained** — each module has its own router, service, schemas.
7. **`__init__.py` re-exports** — modules expose their public API via `__init__.py`.
8. **Services are instantiated in route handlers** — not globally registered.
9. **Repository layer is optional** — only for modules with complex data access patterns.
10. **Feature flags** — conditional modules use `settings.xxx_enabled` flags.

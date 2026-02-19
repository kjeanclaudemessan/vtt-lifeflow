# Create FastAPI Module

Create a new module in the FastAPI backend.

## Module Details

- **Module Name**: ${{input:Module name in snake_case (e.g., orders, products)}}
- **Description**: ${{input:What does this module do?}}
- **Needs Repository?**: ${{input:Does it need a repository layer? (yes/no)}}

## Requirements

Generate the following files under `fastapi/app/modules/<module_name>/`:

### 1. `__init__.py`
Re-export the router and key schemas.

### 2. `router.py`
- APIRouter with proper prefix (kebab-case) and tags
- CRUD endpoints: GET list, GET by ID, POST create, PATCH update, DELETE
- All endpoints use `Depends(get_current_user)`
- All endpoints have `response_model` and docstrings

### 3. `schemas.py`
- `*Base` — shared fields
- `*CreateRequest` — for POST
- `*UpdateRequest` — all fields optional for PATCH
- `*Response` — with ID and TimestampMixin

### 4. `service.py`
- Business logic class with repository injection
- Async methods matching router endpoints
- Raise `NotFoundException`, `BadRequestException` etc. for errors

### 5. `repository.py` (if needed)
- Data access via `supabase_admin`
- TABLE class attribute
- Return Pydantic models, not raw dicts

## After Generation

1. Add router import in `fastapi/app/api/v1/router.py`
2. Add corresponding Supabase migration in `supabase/migrations/`
3. Register in `modules.yaml` if it's a template module

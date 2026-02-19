# Python Code Instructions

## General

- Python 3.13+ — use modern syntax (union types `X | None`, match/case, etc.)
- All functions that do I/O must be `async def`
- Use type hints on all function signatures and return types
- Use `from __future__ import annotations` only if needed for forward refs
- Line length: 88 characters max (ruff)
- Use `snake_case` for variables, functions, modules
- Use `PascalCase` for classes
- Use `UPPER_SNAKE_CASE` for constants

## Import Order (enforced by ruff isort)

1. Standard library (`from datetime import datetime`)
2. Third-party (`from fastapi import ...`)
3. App-level (`from app.core import ...`)
4. Relative imports (avoid when possible — prefer absolute)

## Docstrings

- Module-level docstring at top of every file
- Class docstring explaining purpose
- Method docstrings for public methods
- Use triple-quoted strings

## Type Hints

```python
# Prefer union syntax
def get_user(user_id: UUID) -> UserResponse | None: ...

# Use Generic for response wrappers
SuccessResponse[ProfileResponse]

# Use TypeAlias for complex types
type UserDict = dict[str, Any]
```

## Error Handling

- Never use bare `except:`
- Catch specific exceptions
- Use `AppException` hierarchy for HTTP errors
- Let unexpected exceptions propagate (global handler catches them)

## Logging

- Use `structlog` for all logging
- Include context: `log.info("profile_updated", user_id=str(user_id))`
- Never log sensitive data (passwords, tokens, keys)

# Generate Commit Message

Generate a conventional commit message for the current changes.

## Changes

- **Type of Change**: ${{input:Type: feat, fix, docs, style, refactor, test, chore, perf, ci}}
- **Scope**: ${{input:Scope: auth, user, order, ui, config, etc. (optional)}}
- **Summary**: ${{input:Brief description of what changed}}

## Conventional Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

## Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add biometric login` |
| `fix` | Bug fix | `fix(cart): correct total calculation` |
| `docs` | Documentation | `docs(readme): update setup instructions` |
| `style` | Formatting, no code change | `style: format with dart format` |
| `refactor` | Code refactor, no behavior change | `refactor(user): extract validation logic` |
| `test` | Adding/fixing tests | `test(auth): add login viewmodel tests` |
| `chore` | Maintenance tasks | `chore: update dependencies` |
| `perf` | Performance improvement | `perf(list): add pagination` |
| `ci` | CI/CD changes | `ci: add flutter analyze step` |

## Rules

1. **Type** is required
2. **Scope** is optional but recommended
3. **Description** should be:
   - Lowercase
   - No period at end
   - Imperative mood ("add" not "added")
   - Max 72 characters

4. **Body** (optional):
   - Blank line after description
   - Explain what and why, not how
   - Wrap at 72 characters

5. **Footer** (optional):
   - Breaking changes: `BREAKING CHANGE: description`
   - Issue references: `Closes #123`, `Fixes #456`

## Examples

### Simple Feature
```
feat(profile): add avatar upload
```

### Bug Fix with Body
```
fix(auth): handle token refresh race condition

The previous implementation could result in multiple simultaneous
refresh token requests. Added a lock mechanism to ensure only one
refresh happens at a time.

Fixes #234
```

### Breaking Change
```
feat(api)!: change response format for orders endpoint

BREAKING CHANGE: The orders endpoint now returns paginated results.
Clients must update to handle the new response structure with `data`
and `meta` fields.
```

### Documentation
```
docs(architecture): add sequence diagrams for auth flow
```

### Refactor
```
refactor(order): extract price calculation to dedicated service
```

### Multiple Scopes
```
feat(auth,user): implement SSO with profile sync
```

## Bad Examples ❌

```
# Too vague
fix: bug fix
update code
changes

# Not imperative
feat: added new feature
fix: fixed the bug

# Too long
feat(auth): add a new feature that allows users to login with their email and password and also supports social login with Google and Facebook

# Wrong type
feat: fix login bug  # Should be 'fix'
```

## Good Examples ✅

```
feat(auth): add Google OAuth login
fix(cart): prevent negative quantities
refactor(user): move validation to entity
test(order): add integration tests for checkout
chore(deps): bump stacked to 3.4.0
docs(api): document rate limiting behavior
style(widgets): apply consistent spacing
perf(images): implement lazy loading
```

## Scopes for This Project

Common scopes based on architecture:
- `auth` - Authentication
- `user` - User profile
- `core` - Core utilities
- `ui` - UI components
- `design` - Design system
- `api` - API client
- `config` - Configuration
- `i18n` - Internationalization
- `deps` - Dependencies
- `ci` - CI/CD pipelines

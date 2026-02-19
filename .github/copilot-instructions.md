# VTT Template — Copilot Instructions

> **Monorepo template** for fullstack projects: **Flutter + FastAPI + Supabase**.
> Initialized via `vtt.yaml` + `init.ps1` which removes disabled modules and renames the project.

---

## Project Overview

This is a modular fullstack project template with three layers:

| Layer | Path | Tech | Own `.github/` |
|-------|------|------|----------------|
| **Flutter** | `flutter/` | Flutter 3.x, Stacked MVVM, GetIt DI | `flutter/.github/` |
| **FastAPI** | `fastapi/` | FastAPI, Pydantic v2, httpx async | `fastapi/.github/` |
| **Supabase** | `supabase/` | Auth, DB (Postgres), Storage, Realtime | `supabase/.github/` |

The three layers share the same modular structure — module names match across Flutter, FastAPI, and Supabase migrations (e.g., `auth`, `profile`, `organizations`).

> **Stack-specific instructions** live in each layer's own `.github/copilot-instructions.md`.
> This root file covers **monorepo-level** concerns only.

---

## Template Initialization

| File | Purpose |
|------|---------|
| `vtt.yaml` | Project config — name, bundle ID, enabled modules, optional preset |
| `modules.yaml` | Module registry — maps each module to its files across all layers |
| `init.ps1` | PowerShell script — reads both files, removes disabled modules, renames project, cleans imports |

### Workflow

```
1. Copy monorepo to new folder
2. Edit vtt.yaml (project name, toggle modules, optional preset)
3. Run: .\init.ps1          (or .\init.ps1 -DryRun for preview)
4. Result: clean project with only enabled modules
```

### Presets (vtt.yaml)

| Preset | Enables |
|--------|---------|
| `minimal` | Nothing optional — Flutter + Supabase core only |
| `saas` | organizations, invitations, subscriptions, payments, activities |
| `social` | tags, comments, favorites, activities, attachments |
| `marketplace` | organizations, payments, tags, favorites, comments, attachments |
| `chat_app` | chat_platform, push_notifications, activities |
| `full` | Everything enabled |

---

## Monorepo Structure

```
vtt_templates/
├── vtt.yaml                    # Project configuration
├── modules.yaml                # Module to files registry
├── init.ps1                    # Initialization script
├── .github/
│   ├── copilot-instructions.md # THIS FILE (monorepo-level)
│   └── prompts/                # Cross-stack prompts
│       ├── create-api-endpoint.prompt.md
│       └── generate-commit.prompt.md
├── flutter/                    # Flutter app
│   ├── .github/                # Flutter-specific Copilot config
│   │   ├── copilot-instructions.md
│   │   ├── instructions/       # 13 file-pattern instructions
│   │   ├── prompts/            # 10 task prompts
│   │   ├── agents/             # 4 specialized agents
│   │   └── workflows/          # CI/CD workflows
│   ├── lib/
│   ├── test/
│   └── pubspec.yaml
├── fastapi/                    # FastAPI backend
│   ├── .github/                # FastAPI-specific Copilot config
│   │   ├── copilot-instructions.md
│   │   ├── instructions/       # Python-specific instructions
│   │   └── prompts/            # Backend task prompts
│   ├── app/
│   ├── tests/
│   └── pyproject.toml
└── supabase/                   # Supabase (DB, Auth, Storage)
    ├── .github/                # Supabase-specific Copilot config
    │   └── copilot-instructions.md
    ├── config.toml
    └── migrations/
```

---

## Module System

### Module Categories

| Category | Modules | Layers |
|----------|---------|--------|
| **Core** (always present) | auth, profile, splash, onboarding, settings, notifications | Flutter + FastAPI + Supabase |
| **Business** (toggle in vtt.yaml) | organizations, invitations, payments, subscriptions, tags, attachments, comments, favorites, activities | Flutter + Supabase (no FastAPI) |
| **Advanced services** (toggle in vtt.yaml) | ai_agent, chat_platform | FastAPI + Supabase (no Flutter UI) |
| **Flutter services** (toggle in vtt.yaml) | push_notifications, analytics, error_reporting, moneroo, biometric, deep_link, share, offline, permission | Flutter only |

### Module Dependencies

```
invitations    -> requires organizations
subscriptions  -> requires payments
rbac           -> requires organizations
chat_platform  -> widget_templates, scheduled_messages (auto-included)
```

### Adding a New Module

1. Add files to the appropriate layer(s) (Flutter, FastAPI, Supabase)
2. Register all files in `modules.yaml` under a new module key
3. Add toggle in `vtt.yaml` (under `modules:` or `services:`)
4. For Flutter: add `# MODULE:xxx` / `# END:xxx` markers in `app/app.dart`
5. For FastAPI: add `# MODULE:xxx` markers in `api/v1/router.py` + settings flag
6. For Supabase: add migration file(s)

---

## Cross-Layer Communication

### Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Flutter    │ <-----> │  Supabase   │ <-----> │   FastAPI   │
│   (Client)   │  direct │  (BaaS)     │  client │  (Backend)  │
└─────────────┘         └─────────────┘         └─────────────┘
       │                                               │
       └───────── HTTP REST (heavy logic only) ────────┘
```

- **Flutter to Supabase**: Direct communication via `supabase_flutter` SDK for auth, CRUD, storage, realtime.
- **Flutter to FastAPI**: Only for complex/heavy business logic (AI processing, external integrations, batch operations).
- **FastAPI to Supabase**: Server-side operations via `supabase-py` with service role key.

### Auth Flow

- **Supabase** handles user registration, login, OAuth, token refresh, password reset.
- **Flutter** uses `supabase_flutter` for auth operations and stores JWT.
- **FastAPI** only **verifies** JWT tokens — it does not issue them.

---

## Naming Conventions (Cross-Layer)

| Element | Convention | Example |
|---------|-----------|---------|
| Module names | `snake_case`, consistent across layers | `organizations`, `ai_agent` |
| Migration files | `YYYYMMDDHHMMSS_description.sql` | `20260122000000_create_profiles.sql` |
| Table names | `snake_case`, plural | `profiles`, `organization_members` |
| Column names | `snake_case` | `first_name`, `created_at`, `avatar_url` |
| API routes | kebab-case | `/api/v1/users/me` |

> Stack-specific naming conventions are in each layer's `.github/copilot-instructions.md`.

---

## Key Rules

1. **Module names match across layers** — `organizations` in Flutter = `organizations` in Supabase migrations.
2. **FastAPI does NOT create DB tables** — all schema lives in Supabase migrations.
3. **FastAPI only verifies JWT** — Supabase handles auth operations.
4. **Flutter talks directly to Supabase** for most operations — FastAPI is for heavy logic only.
5. **Modules are self-contained** — a module should not import from another module directly.
6. **Optional modules are toggled** via `vtt.yaml` and removed by `init.ps1`.
7. **Migration timestamps must be ordered** — new migrations get the next timestamp.
8. **Each layer has its own `.github/`** — use stack-specific instructions for code patterns.
9. **`modules.yaml` is the source of truth** — every module file must be registered there.
10. **Presets override individual toggles** — if `preset:` is set in `vtt.yaml`, it takes precedence.

---

## SpecKit Workflow (MANDATORY)

> **Every feature MUST follow the SpecKit pipeline.** No implementation without specs.
> The `.specify/memory/constitution.md` is the supreme law of this project — it overrides all other guidance.

### Pipeline

```
speckit.specify → speckit.plan → speckit.tasks → speckit.implement
```

| Step | Command | Produces | Required Before |
|------|---------|----------|-----------------|
| 1. Specify | `/speckit.specify` | `spec.md` — user stories, acceptance criteria, wireframes | Any design work |
| 2. Plan | `/speckit.plan` | `research.md`, `data-model.md`, `quickstart.md`, `plan.md`, `contracts/` | Any implementation |
| 3. Tasks | `/speckit.tasks` | `tasks.md` — ordered, dependency-aware task breakdown | Any coding |
| 4. Implement | `/speckit.implement` | Working code following tasks.md phase by phase | — |

### Feature Directory Convention

```
specs/<branch-name>/          # Branch MUST match ^[0-9]{3}-<name>
├── spec.md                   # The WHAT — user stories, acceptance, wireframes
├── research.md               # The DECISIONS — tech choices, alternatives
├── data-model.md             # The ENTITIES — tables, fields, relationships
├── plan.md                   # The HOW — stack, structure, constitution check
├── quickstart.md             # The TESTS — end-to-end validation scenarios
├── wireframes.md             # The SCREENS — ASCII wireframes (optional, can be in spec.md)
├── tasks.md                  # The ACTION PLAN — ordered tasks with dependencies
├── contracts/                # The API — OpenAPI specs (when FastAPI involved)
└── checklists/               # The GATES — UX, security, a11y checklists
```

### Prerequisites Script

```powershell
# Must pass before implementation
.specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
```

### Rules

1. **No coding without `tasks.md`** — run `/speckit.tasks` first.
2. **`check-prerequisites.ps1` MUST pass** — it validates branch name, feature dir, and required docs.
3. **Constitution check in `plan.md`** — every principle must PASS before implementation.
4. **Mark tasks as complete** — update `tasks.md` checkboxes as work progresses.
5. **Architecture is NON-NEGOTIABLE** — follow `flutter/.github/`, `fastapi/.github/`, `supabase/.github/` patterns exactly.
6. **Design system is MANDATORY** — no hardcoded colors, spacing, or typography in Flutter. Use `AppColors`, `AppSpacing`, `AppTextStyles`, `AppGaps`, and design system widgets (`AppButton`, `AppCard`, `AppTextField`, `AppListTile`, `AppBadge`, `AppProgress`, `AppEmptyState`, `AppChip`, `AppBottomNav`).
7. **Entity/Model separation is MANDATORY** — pure entities in `domain/`, `@JsonSerializable` models in `data/`. No exceptions.

### Constitution

The project constitution lives at `.specify/memory/constitution.md`. It defines:
- Inviolable architectural principles (per stack)
- Naming conventions (cross-stack)
- Coding workflow (Supabase → Domain → Data → Features)
- Quality gates (RLS, Either, Equatable, i18n, design tokens)
- Governance (priority order of conflicting instructions)

**Priority order**: Constitution > This file > Stack-specific `.github/` > Feature-specific `plan.md`

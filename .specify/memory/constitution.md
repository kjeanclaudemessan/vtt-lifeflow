# LifeFlow Constitution

> **Supreme law of the LifeFlow project.** Overrides ALL other guidance when conflicting.
> Multi-stack: Supabase + Flutter + FastAPI. Updated per phase.

---

## I. Universal Principles (ALL STACKS)

### A. Supabase-First Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Flutter    │ ◄─────► │  Supabase   │ ◄─────► │   FastAPI   │
│  (Client)    │  direct │  (BaaS)     │  svc key│  (Backend)  │
└─────────────┘         └─────────────┘         └─────────────┘
       │                                               │
       └──────── HTTP REST (heavy logic ONLY) ─────────┘
```

- Flutter talks **DIRECTLY** to Supabase for all CRUD (auth, queries, storage, realtime)
- FastAPI is **ONLY** for heavy logic (AI Level 2, webhooks, batch processing)
- **Supabase owns the schema** — neither Flutter nor FastAPI create tables
- Every table has **RLS policies** enforcing `auth.uid()`

### B. Feature Independence

- Features do NOT import from other features — ever
- Shared data flows through `domain/` entities and `services/`
- Each feature owns its views, viewmodels, and widgets
- Module names match across ALL layers (`habits` in Flutter = `habits` in Supabase)

### C. IA Passive-Informative

The AI **OBSERVES** and **INFORMS**. The user **DECIDES**. Never coach, never auto-act.

- Level 1 (local, Flutter): simple calculations (averages, streaks, deltas)
- Level 2 (cloud, FastAPI + GPT-4o): complex analysis, receives aggregated data only

### D. Progressive Disclosure

- **Surface** = simple daily use (habits, routines, tasks, inbox)
- **Depth** = available on demand (OKR, budget temps, stats, insights)
- Never force complexity on the user

---

## II. Supabase Rules

> Detailed patterns: `supabase/.github/copilot-instructions.md`

1. **Migrations = SCHEMA ONLY** — `CREATE TABLE`, `ALTER`, indexes, RLS, triggers. NEVER `INSERT` data.
2. **Seeds = DATA ONLY** — Default data, seed data, data-generating functions go in `supabase/seeds/`.
3. **`supabase db reset` is a GATE** — must pass with zero errors after any migration/seed change, BEFORE any downstream code.
4. **RLS on every table** — `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` + per-user policies.
5. **UUIDs** — `gen_random_uuid()` for PKs, never `uuid_generate_v4()`.
6. **TIMESTAMPTZ** — never bare `TIMESTAMP`. Always timezone-aware.
7. **Naming** — tables `snake_case` plural, columns `snake_case`, indexes `idx_<table>_<column>`, policies as English sentences.
8. **Migration format** — `YYYYMMDDHHMMSS_description.sql` with `═══` section banners.
9. **Soft delete** — `is_archived BOOLEAN` or `deleted_at TIMESTAMPTZ`, never hard delete on user-facing data.

---

## III. Flutter Rules

> Detailed patterns: `flutter/.github/copilot-instructions.md` + `flutter/.github/instructions/*.instructions.md`

### Architecture: Stacked MVVM + Clean Architecture (NON-NEGOTIABLE)

```
Domain (pure Dart) → Data (Supabase impl) → Services (technical) → Presentation (Views/VMs)
```

1. **Domain layer has ZERO external deps** — only `equatable`, `dartz`. Pure Dart.
2. **Repositories return `Either<Failure, T>`** — never throw in business logic. Use `FutureResult<T>` typedef.
3. **Views contain NO business logic** — all logic in ViewModels.
4. **Services wrap external deps** — registered via `@StackedApp` in `app/app.dart`.
5. **`modules/`** = generic reusable (auth, profile, settings, splash, onboarding, notifications).
6. **`features/`** = project-specific (all LifeFlow features: habits, routines, tasks, inbox, today, domains).

### Entity / Model Separation (NON-NEGOTIABLE)

- **Entity** (`domain/entities/`): Pure Dart, Equatable, no JSON, no Supabase. Business logic + computed props + `copyWith` + `empty()` + `mock()`.
- **Model** (`data/models/`): `@JsonSerializable()`, mirrors Supabase table. `@JsonKey(name: 'snake_case')`. Methods: `toEntity()`, `fromEntity()`, `fromJson()`, `toJson()`.
- Conversion happens **ONLY** in repository implementations.

### Design System (NON-NEGOTIABLE)

- **NO hardcoded values** — colors, spacing, typography, radius, shadows must use design tokens.
- **Use design system widgets** — `AppButton`, `AppCard`, `AppTextField`, `AppListTile`, `AppBadge`, `AppProgress`, `AppEmptyState`, `AppChip`, `AppBottomNav`, `AppDropdown`.
- **Tokens**: `AppColors`, `AppSpacing` (xs/sm/md/lg), `AppGaps` (h8/w16/etc), `AppTextStyles`, `AppRadius`, `AppShadows`.
- **Theme access**: `context.colorScheme.surface`, `context.colorScheme.primary`.

### i18n (NON-NEGOTIABLE)

- Every user-facing string uses `context.l10n.xxx` — never hardcoded text.
- ARB files in `lib/l10n/arb/` — English (template) + French (minimum).

---

## IV. FastAPI Rules (When Active)

> Detailed patterns: `fastapi/.github/copilot-instructions.md`

1. **FastAPI does NOT create DB tables** — all schema in Supabase migrations.
2. **FastAPI only VERIFIES JWT** — Supabase handles auth operations (login, register, refresh).
3. **All methods are `async def`** — use `await` for all I/O.
4. **Pydantic v2** — `BaseModel` with `model_config`, union syntax (`str | None`).
5. **Exception hierarchy** — `AppException` → `UnauthorizedException`, `NotFoundException`, etc.
6. **Typed responses** — `SuccessResponse[T]`, `MessageResponse`, `PaginatedResponse[T]`.
7. **Module structure** — `router.py`, `service.py`, `schemas.py`, `dependencies.py` per module.

---

## V. SpecKit Workflow (MANDATORY)

### Pipeline

```
speckit.specify → speckit.plan → speckit.tasks → speckit.implement
```

1. **Every feature has a branch** — named `###-feature-name` (e.g., `001-phase1-daily-foundations`).
2. **Every feature has a `specs/<branch>/` directory** with: `spec.md`, `plan.md`, `research.md`, `data-model.md`, `quickstart.md`, `tasks.md`.
3. **`check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks` MUST pass** before any implementation.
4. **Tasks are marked complete** in `tasks.md` as work progresses.
5. **Constitution check** in `plan.md` must PASS for every principle before coding starts.

### Coding Workflow

1. **Supabase first** — migrations + seeds BEFORE any Flutter/FastAPI code
2. **GATE: `supabase db reset`** — must pass with zero errors. Blocks ALL downstream work.
3. **Domain layer** — Entity → Repository contract
4. **Data layer** — Model → Repository implementation
5. **DI registration** — `app.dart` → `build_runner`
6. **Feature layer** — Views, ViewModels, widgets
7. **Verify** — `dart format .` + `dart analyze` = zero errors/warnings

> **Rule**: Never proceed to the next step if the current one has errors.

---

## VI. Naming Conventions (Cross-Stack)

| Element | Convention | Example |
|---------|-----------|---------|
| Feature folder | `snake_case` | `features/habits/` |
| View / ViewModel | `*_view.dart` / `*_viewmodel.dart` | `habits_view.dart` |
| Entity / Model | `*_entity.dart` / `*_model.dart` | `habit_entity.dart` |
| Repo contract / impl | `i_*_repository.dart` / `*_repository_impl.dart` | `i_habit_repository.dart` |
| Supabase table | `snake_case`, plural | `habits`, `habit_logs` |
| Migration | `YYYYMMDDHHMMSS_desc.sql` | `20260220000001_create_domains.sql` |
| Seed | `NNN_description.sql` | `001_default_domains.sql` |
| FastAPI module | `snake_case/` | `modules/ai_agent/` |
| API routes | kebab-case | `/api/v1/users/me` |

---

## VII. Quality Gates

### Supabase
- [ ] Every table has RLS with `auth.uid()` policies
- [ ] `supabase db reset` passes with zero errors
- [ ] Migrations = schema only, seeds = data only

### Flutter
- [ ] Every repo method returns `Either<Failure, T>`
- [ ] Every entity uses Equatable with `props`
- [ ] Every model has `toEntity()`, `fromEntity()`, `fromJson()`, `toJson()`
- [ ] Every view uses design system tokens only (no hardcoded values)
- [ ] Every user string uses i18n (`context.l10n.xxx`)
- [ ] `dart format .` + `dart analyze` = zero errors before commit
- [ ] After `app.dart` changes: `dart run build_runner build --delete-conflicting-outputs`

### Integration Tests (NON-NEGOTIABLE)
- [ ] Tests use **REAL ViewModels** — no mocked ViewModels, no mocked repositories
- [ ] Tests connect to **REAL local Supabase** (`supabase start`) — no fake DB, no in-memory DB
- [ ] Each user story from `spec.md` has a corresponding integration test
- [ ] Test chain: REAL ViewModel → REAL Repository → REAL SupabaseService → REAL local DB
- [ ] Test users created/cleaned via admin API (service_role key)
- [ ] Tests validate both ViewModel state AND DB state (query after action)
- [ ] When a test fails, the **code is fixed** (not the test) — tests are the source of truth

### FastAPI (when active)
- [ ] All methods `async def`
- [ ] Typed responses (`SuccessResponse[T]`)
- [ ] JWT verification only (no auth operations)

---

## VIII. Product Rules (Design Authority)

> The `.specify/memory/` files define the **QUOI and POURQUOI** — product design decisions.
> The `.github/instructions/` files define the **COMMENT** — code implementation patterns.
> These two layers are complementary and MUST NOT overlap.

### Product Rule Files

| File | Authority | Scope |
|------|-----------|-------|
| `product-soul.md` | Product identity, JTBD, tiebreakers, moat, analytics, privacy | What the product IS and believes |
| `experience-architecture.md` | Session arc, critical moments, retention loops, error recovery, app profiles | How the experience FEELS |
| `wireframe-rules.md` | Screen structure decisions, restraint principle, platform UX | How screens are STRUCTURED |
| `content-rules.md` | Voice/ton, textes par contexte, voice profiles, notifications, seed data | What the product SAYS |

### Two-Layer Architecture

```
.specify/memory/          → QUOI / POURQUOI  (product decisions, IA reads for factory)
flutter/.github/instructions/ → COMMENT      (code patterns, Copilot auto-applies via applyTo)
```

### Rule: No Duplication Across Layers

- Product rule files contain **ZERO Dart code** (except rare conceptual enums)
- Product rule files **do not specify token values, widget names, or layout code**
- Each product rule file ends with a **cross-ref table** pointing to relevant `.github/instructions/` files
- If content belongs in both layers, it lives in `.github/instructions/` and the product rule file references it

---

## IX. Governance

This constitution **supersedes** all conflicting guidance. Priority order:

1. **This constitution** (`.specify/memory/constitution.md`)
2. **Product rules** (`.specify/memory/*.md` — product-soul, experience-architecture, wireframe-rules, content-rules)
3. **Root `.github/copilot-instructions.md`** (SpecKit workflow, cross-layer rules)
4. **Stack `.github/copilot-instructions.md`** (Flutter / FastAPI / Supabase patterns)
5. **Stack `.github/instructions/*.instructions.md`** (file-pattern specific)
6. **Feature `specs/<branch>/plan.md`** (feature-specific decisions)

**Version**: 3.0.0 | **Ratified**: 2026-03-17 | **Scope**: Multi-stack

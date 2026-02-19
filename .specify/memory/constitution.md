# LifeFlow Constitution

## Core Principles

### I. Stacked MVVM + Clean Architecture (NON-NEGOTIABLE)

```
Domain (pure Dart) -> Data (Supabase impl) -> Services (technical) -> Presentation (Views/VMs)
```

- Domain layer has ZERO external dependencies (only `equatable`, `dartz`)
- Repositories return `Either<Failure, T>` -- never throw in business logic
- Views contain NO business logic -- all logic in ViewModels
- Services wrap external deps, registered via `@StackedApp` in `app/app.dart`
- `modules/` = generic reusable (auth, profile, settings, splash, onboarding, notifications)
- `features/` = project-specific (all LifeFlow features)

### II. Supabase-First

- Flutter talks DIRECTLY to Supabase for all CRUD
- FastAPI is ONLY for heavy logic (AI Level 2, webhooks)
- All schema lives in `supabase/migrations/` -- FastAPI never creates tables
- Every table has RLS policies enforcing `auth.uid()`

### III. Entity / Model Separation

- **Entity** (`domain/entities/`): Pure Dart, no JSON, no Supabase. Business logic + computed props.
- **Model** (`data/models/`): `@JsonSerializable()`, mirrors Supabase table. `toEntity()` + `fromEntity()`.
- Conversion happens ONLY in repository implementations.

### IV. IA Passive-Informative

The AI OBSERVES and INFORMS. The user DECIDES. Never coach, never auto-act.

- Level 1 (local, Flutter): simple calculations (averages, streaks, deltas)
- Level 2 (cloud, FastAPI + GPT-4o): complex analysis, receives aggregated data only

### V. Feature Independence

- Features do NOT import from other features
- Shared data flows through `domain/` entities and `services/`
- Each feature owns its views, viewmodels, and widgets

### VI. Progressive Disclosure

- Surface = simple daily use (habits, routines, tasks, inbox)
- Depth = available on demand (OKR, budget temps, stats, insights)
- Never force complexity on the user

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Feature folder | `snake_case` | `features/habits/` |
| View / ViewModel | `*_view.dart` / `*_viewmodel.dart` | `habits_view.dart` |
| Entity / Model | `*_entity.dart` / `*_model.dart` | `habit_entity.dart` |
| Repo contract / impl | `i_*_repository.dart` / `*_repository_impl.dart` | `i_habit_repository.dart` |
| Supabase table | `snake_case`, plural | `habits`, `habit_logs` |
| Migration | `YYYYMMDDHHMMSS_desc.sql` | `20260220000001_create_domains.sql` |

## Coding Workflow

1. **Supabase first**: Write migrations/seeds BEFORE Flutter code
2. **Validate DB immediately**: After ANY new migration or seed → run `supabase db reset` and confirm it succeeds before writing any Flutter code
3. **Domain layer next**: Entity → Repository contract → Model → Repository impl
4. **Feature last**: Views, ViewModels, widgets
5. **Code gen**: After touching `app.dart` → `dart run build_runner build --delete-conflicting-outputs`
6. **Verify**: `dart format` + `dart analyze` before considering a phase done

> **Rule**: Never proceed to the next step if the current one has errors. A failing `supabase db reset` blocks ALL downstream work.

## Quality Gates

- Every repo method returns `Either<Failure, T>`
- Every Supabase table has RLS with `auth.uid()`
- Every entity uses Equatable with `props`
- Every model has `toEntity()`, `fromEntity()`, `fromJson()`, `toJson()`
- Every view uses design system tokens only (no hardcoded values)
- Every user string uses i18n (`context.l10n.xxx`)
- After ANY migration/seed change: `supabase db reset` MUST pass
- Clean `dart format` + `dart analyze` before commit
- After `app.dart` changes: `dart run build_runner build --delete-conflicting-outputs`

## Governance

This constitution supersedes conflicting guidance. Priority order:
1. This constitution
2. `flutter/.github/copilot-instructions.md`
3. `flutter/.github/instructions/*.instructions.md`
4. `docs/IMPLEMENTATION.md`

**Version**: 1.0.0 | **Ratified**: 2026-02-19

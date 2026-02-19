# Research: Phase 1 — Daily Foundations

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19
**Input**: Technical Context from plan.md — resolve all NEEDS CLARIFICATION

## Decision Log

### D-001: State Management — Stacked MVVM

- **Decision**: Use Stacked framework for MVVM + DI (GetIt)
- **Rationale**: Already established in the project template. Stacked provides `BaseViewModel`, `ReactiveViewModel`, code generation for routes/DI, and tight integration with `GetIt`. No reason to switch.
- **Alternatives considered**:
  - Riverpod: More flexible but would require rewriting all existing modules (auth, profile, splash, onboarding, settings).
  - BLoC: Over-engineered for this scope. Stacked's `runBusyFuture` + `setBusy` pattern is simpler for CRUD features.

### D-002: Data Layer — Direct Supabase (No FastAPI)

- **Decision**: Flutter talks directly to Supabase for all Phase 1 CRUD. No FastAPI backend needed.
- **Rationale**: Phase 1 is pure CRUD with RLS. No complex business logic requiring server-side processing. `supabase_flutter` SDK provides typed queries, realtime, and auth out of the box.
- **Alternatives considered**:
  - FastAPI intermediary: Adds latency, deployment complexity, and maintenance for no gain in Phase 1. Reserved for Phase 3+ (AI features).

### D-003: Error Handling — Either<Failure, T> via dartz

- **Decision**: All repository methods return `Either<Failure, T>` using dartz. `FutureResult<T>` typedef already defined in `core/typedefs/typedefs.dart`.
- **Rationale**: Established pattern in the codebase (`IAuthRepository` already uses it). Prevents uncaught exceptions in business logic. Failures are Equatable for testability.
- **Alternatives considered**:
  - Exceptions: Dart native, but lose compile-time safety. Callers may forget to catch.
  - Result type (custom): Reinventing the wheel when dartz `Either` is already a dependency.

### D-004: Entity/Model Separation

- **Decision**: Pure `Equatable` entities in `domain/entities/` (no external dependencies). `@JsonSerializable` models in `data/models/` with `toEntity()`, `fromEntity()`, `fromJson()`, `toJson()`.
- **Rationale**: Enforced by constitution (Principle III). Keeps domain layer testable without JSON serialization overhead. Models handle snake_case ↔ camelCase mapping via `@JsonKey`.
- **Alternatives considered**:
  - Single model class: Violates Clean Architecture. Domain layer would depend on `json_annotation`.
  - Freezed: Adds heavy code generation. Equatable + manual `copyWith` is sufficient for Phase 1 entity count (8 entities).

### D-005: Streak Calculation — Client-Side

- **Decision**: Calculate habit streaks client-side by querying `habit_logs` ordered by `log_date DESC` and counting consecutive days.
- **Rationale**: Simple logic, small dataset per user (max ~365 logs/year per habit). No need for server-side stored procedure in Phase 1. Can be optimized with Postgres function in Phase 2 if needed.
- **Alternatives considered**:
  - Postgres function: Over-engineering for Phase 1. Would need migration and RPC call.
  - Cached streak column on `habits` table: Risks stale data, adds trigger complexity.

### D-006: Routine Timer — ViewModel State

- **Decision**: Routine runner timer managed entirely in `RoutineRunnerViewModel` using Dart `Timer.periodic`. No background service.
- **Rationale**: Phase 1 is online-only, no background persistence needed. The timer ticks every second, ViewModel holds current step index and elapsed time. If user leaves, timer stops and routine is logged as `abandoned`.
- **Alternatives considered**:
  - Flutter local notifications + background isolate: Phase 1 scope is too small. Background timer adds complexity (platform channels, wake locks).
  - Saving timer state to Supabase: Unnecessary round-trips for a local UI concern.

### D-007: Inbox Triage — Bottom Sheet Flow

- **Decision**: Triage uses a `BottomSheet` with 3 actions: "Create Task", "Create Habit", "Discard". Selecting task/habit opens the respective form pre-filled with `rawText`.
- **Rationale**: Bottom sheets are the established UX pattern in the design system (`NoticeSheet` already exists). Pre-filling reduces friction — the user's captured thought becomes the title/name.
- **Alternatives considered**:
  - Inline triage (swipe actions): Limited space for 3 actions. Bottom sheet provides clearer choices.
  - Separate triage screen: Over-navigating. Bottom sheet keeps context visible.

### D-008: Today View — Aggregation ViewModel

- **Decision**: `TodayViewModel` loads data from all 5 repositories in `initialise()`. No realtime subscriptions in Phase 1 — manual pull-to-refresh.
- **Rationale**: Phase 1 is single-device, online-only. Loading 5 queries on view init is fast enough (< 2s target). Realtime adds complexity (subscriptions, disposal, reconnection).
- **Alternatives considered**:
  - Realtime subscriptions: Reserved for Phase 4 (multi-device sync).
  - Shared reactive state: Stacked's `ReactiveViewModel` could listen to service changes, but adds coupling between features. Simpler to reload on `onViewReady`.

### D-009: Time Range Grouping for Habits

- **Decision**: Habits with `start_time`/`end_time` are grouped in Today view by time ranges: Morning (before 12:00), Afternoon (12:00-18:00), Evening (after 18:00). Habits without time range go to "Anytime".
- **Rationale**: Simple grouping that matches daily rhythm. The spec mentions "groupées par plage horaire" — this provides the grouping without complex scheduling.
- **Alternatives considered**:
  - Custom time slots defined by user: Phase 2+ feature, too complex for MVP.
  - No grouping (flat list): Loses the time-based structure that differentiates LifeFlow.

### D-010: Default Domains — Seed Strategy

- **Decision**: Default domains (Santé, Travail, Relations, Finances, Développement personnel) are seeded via `supabase/seeds/001_default_domains.sql`. NOT in migrations — data belongs in seeds.
- **Rationale**: Constitution rule — migrations are for schema, seeds are for data. The `supabase db reset` command applies seeds after migrations. For production, a trigger on `auth.users` INSERT or an edge function handles new user defaults.
- **Alternatives considered**:
  - Trigger in migration: User explicitly rejected this 3 times. Data ≠ schema.
  - Client-side seeding: Would require checking on every app launch. Server-side is authoritative.

## Technology Constraints

| Constraint | Impact | Mitigation |
|-----------|--------|------------|
| Online-only (Phase 1) | No offline support, actions fail without network | Clear error messages via `NetworkFailure`, retry buttons |
| Single device | No realtime sync between devices | Manual refresh, Today view reloads on `onViewReady` |
| Supabase RLS | Every query scoped to `auth.uid()` | All tables have proper policies. Test with multiple users |
| Design system tokens only | No hardcoded colors, spacing, typography | Use `AppColors`, `AppSpacing`, `AppTextStyles` exclusively |
| Max 1 active routine | UI must prevent concurrent routines | Check for active routine before launching, confirm abandon dialog |

## Performance Benchmarks

| Operation | Target | Approach |
|-----------|--------|----------|
| Today view load | < 2s | 5 parallel queries via `Future.wait` |
| Inbox capture | < 3s | Single INSERT, no validation beyond non-empty |
| Habit check/uncheck | < 500ms | Single UPSERT/DELETE on `habit_logs` |
| Routine step transition | < 200ms | Local state change, no DB call until completion |
| Streak calculation | < 100ms | Query last 30 logs, count consecutive from today |

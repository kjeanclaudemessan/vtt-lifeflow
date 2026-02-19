# Research: Phase 1 — Le Cockpit Quotidien

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Revised**: 2026-02-19
**Input**: Technical Context from plan.md — decisions techniques pour P1 (6 features)

## Decision Log

### D-001: State Management — Stacked MVVM

- **Decision**: Use Stacked framework for MVVM + DI (GetIt).
- **Rationale**: Established in the project template. `BaseViewModel`, `ReactiveViewModel`, code generation for routes/DI. All existing modules (auth, profile, splash, onboarding, settings) use it.
- **Alternatives rejected**:
  - Riverpod — Requires rewriting all existing modules.
  - BLoC — Over-engineered for CRUD features. Stacked's `runBusyFuture` + `setBusy` is simpler.

### D-002: Data Layer — Direct Supabase (No FastAPI)

- **Decision**: Flutter talks directly to Supabase for all Phase 1 CRUD. No FastAPI.
- **Rationale**: Phase 1 is pure CRUD with RLS. No complex business logic. `supabase_flutter` SDK suffices. FastAPI reserved for P2+ (IA features).
- **Alternatives rejected**:
  - FastAPI intermediary — Adds latency, deployment complexity for no gain.

### D-003: Error Handling — Either<Failure, T> via dartz

- **Decision**: All repository methods return `Either<Failure, T>`. `FutureResult<T>` typedef in `core/typedefs/typedefs.dart`.
- **Rationale**: Established pattern (`IAuthRepository` uses it). Compile-time safety. Failures are `Equatable` for testability.
- **Alternatives rejected**:
  - Exceptions — Callers may forget to catch.
  - Custom Result type — Reinventing the wheel.

### D-004: Entity/Model Separation

- **Decision**: Pure `Equatable` entities in `domain/entities/` (no external deps). `@JsonSerializable` models in `data/models/` with `toEntity()`, `fromEntity()`, `fromJson()`, `toJson()`.
- **Rationale**: Constitution Principle III. Domain layer testable without JSON overhead. Models handle `snake_case ↔ camelCase` via `@JsonKey`.
- **Alternatives rejected**:
  - Single model class — Violates Clean Architecture.
  - Freezed — Heavy code gen. Equatable + manual `copyWith` is sufficient for 3 entities.

### D-005: Streak Calculation — Client-Side with Freeze Support

- **Decision**: Calculate streaks client-side by querying `habit_logs` ordered by `log_date DESC`, counting consecutive days, with 1-day freeze per 7-day rolling window.
- **Rationale**: Simple logic, small dataset (~365 logs/year max per habit). Freeze logic is a simple gap tolerance in the streak count loop.
- **Algorithm**:
  ```
  streak = 0, freezeAvailable = true
  for each day going backwards from today:
    if log exists and completed:
      streak++
    elif freezeAvailable and within 7-day window:
      streak++ (freeze used), freezeAvailable = false
    else:
      break
  ```
- **Alternatives rejected**:
  - Postgres function — Over-engineering for P1.
  - Cached streak column — Stale data risk, trigger complexity.

### D-006: Time Counter — Calculation Strategy

- **Decision**: Time per domain calculated client-side from `habit_logs` × `habits.estimated_duration_minutes`. Logic:
  - Binary habit checked → add `estimated_duration_minutes` to domain
  - Quantitative habit with `unit = 'min'` → add actual `value` from log
  - Quantitative habit with other unit → add `estimated_duration_minutes`
- **Rationale**: The counter is the killer feature (score 23/25). It must be responsive (update instantly when habit is checked). Client-side calculation avoids round-trips. Data per week is small (max ~50 habits × 7 days = 350 logs).
- **Formula**:
  ```
  domain_time_week = SUM(
    for each completed habit_log in week:
      if habit.type == quantitative AND habit.unit == 'min':
        log.value
      else:
        habit.estimated_duration_minutes
  )
  ```
- **Alternatives rejected**:
  - Postgres materialized view — Adds migration complexity, stale until refresh.
  - Edge function — Latency on every check.
  - Dedicated `time_entries` table — Redundant with habit_logs.

### D-007: Bilan Hebdo — Generation & Share

- **Decision**: Bilan is a Flutter-only calculation (no new table). Data sourced from `habit_logs` + `habits` + `domains` for the past 7 days. Sharing uses `screenshot` package or `RepaintBoundary` → `toImage()` → `Share.shareXFiles()`.
- **Rationale**: No server-side generation needed. All data is already in Supabase, queried client-side. The bilan is a read-only computation — no state to persist. Past bilans are recalculated on demand (no caching in P1).
- **Components**:
  - `BilanService` — Pure calculation service (not a ViewModel). Takes logs + habits + domains → returns `BilanEntity`.
  - `BilanEntity` — Domain hours map, top habit, longest streak, completion rate, deltas.
  - `BilanView` — Display + share button.
  - `BilanShareWidget` — Styled widget designed for screenshot (DS tokens, not screen widget).
- **Alternatives rejected**:
  - `bilans` table — Premature persistence. P1 has max 4-12 weeks of data.
  - Server-side image generation — Over-engineering.

### D-008: TodayView — Contextual Modes

- **Decision**: TodayView changes based on `DateTime.now().hour`:
  - **Matin** (5h-12h): Greeting, habits by time slot, mini counter, encouragement.
  - **Progression** (12h-18h): X/Y done, progress bar, remaining habits, updated counter.
  - **Bilan** (18h-5h): Day summary, time per domain today, encouragement for tomorrow.
- **Rationale**: This is the "intelligence" of P1 — no AI, just a smart `if/else` that makes the experience feel alive. The mode change is purely visual (same data, different emphasis).
- **Implementation**: Single `TodayViewModel` with a `TodayMode` enum. The View renders different section ordering based on mode. All data loaded once via 2 repositories (habits + domains).
- **Alternatives rejected**:
  - Always-same view — Generic, no personality.
  - User-configurable layout — Phase 2+ complexity.

### D-009: Time Range Grouping for Habits

- **Decision**: Habits grouped in TodayView by time ranges: Matin (<12:00), Après-midi (12:00-18:00), Soir (>18:00). Habits without `start_time` → "Sans horaire".
- **Rationale**: Simple grouping matching daily rhythm. The `start_time` determines the slot.
- **Alternatives rejected**:
  - Custom time slots — Too complex for MVP.
  - Flat list — Loses time-based structure.

### D-010: Default Domains — Seed Strategy

- **Decision**: Default domains seeded via `supabase/seeds/001_default_domains.sql`. NOT in migrations.
- **Rationale**: Constitution rule — migrations = schema, seeds = data. `supabase db reset` applies seeds after migrations. For production: trigger on `auth.users` INSERT or edge function.
- **Alternatives rejected**:
  - Trigger in migration — Data ≠ schema (vetoed 3 times).
  - Client-side seeding — Server-side is authoritative.

### D-011: Navigation Structure — 3 Tabs

- **Decision**: Bottom navigation with 3 tabs: TodayView (🏠), Habitudes (🔄), Compteur (⏱️). Settings via gear icon in AppBar. Domains management inside Settings.
- **Rationale**: P1 has 3 features needing tabs. 3 tabs = zero cognitive overload. The center tab is NOT a FAB (unlike the old 5-tab layout with Routines/Tasks). Bilan accessible from Compteur tab.
- **Alternatives rejected**:
  - 5 tabs (old layout) — No routines/tasks/inbox in P1. 5 tabs with 3 empty = bad UX.
  - 2 tabs (TodayView + Compteur only) — Habit management buried too deep.

### D-012: `estimated_duration_minutes` — Schema Addition

- **Decision**: Add `estimated_duration_minutes INTEGER NOT NULL DEFAULT 15` to the `habits` table. Modify existing migration `20260220000002_create_habits.sql` (dev-only, never deployed).
- **Rationale**: The time counter requires knowing how much time each checked habit represents. `start_time`/`end_time` are for TodayView grouping, not duration. 15 min is a sensible default (most habits: meditation, reading, exercise are 10-60 min).
- **Alternatives rejected**:
  - Derive from `end_time - start_time` — Semantically wrong (window ≠ duration).
  - No duration field — Counter can't work.
  - New ALTER migration — Unnecessary complexity in dev (db reset drops everything).

## Technology Constraints

| Constraint | Impact | Mitigation |
|-----------|--------|------------|
| Online-only (Phase 1) | No offline support | Clear error messages via `NetworkFailure`, retry buttons |
| Single device | No realtime sync | Manual refresh, TodayView reloads on `onViewReady` |
| Supabase RLS | Every query scoped to `auth.uid()` | All tables have RLS policies. Test multi-user |
| Design system tokens only | No hardcoded colors, spacing, typography | `AppColors`, `AppSpacing`, `AppTextStyles` exclusively |
| 3 DS duplicate files | Import ambiguity risk | Cleanup task before implementation (T001 in tasks.md) |

## Performance Benchmarks

| Operation | Target | Approach |
|-----------|--------|----------|
| TodayView load | < 2s | 2 parallel queries (`habits` + `habit_logs`) via `Future.wait` |
| Habit check/uncheck | < 500ms | Single UPSERT/DELETE on `habit_logs` + local counter update |
| Compteur load | < 2s | Query `habit_logs` for 7 days + join `habits` for durations |
| Bilan generation | < 3s | Same query as compteur + streak calculation |
| Streak calculation | < 100ms | Query last 30 logs per habit, count consecutive |
| Share image generation | < 2s | `RepaintBoundary.toImage()` + `Share.shareXFiles()` |

# Implementation Plan: Phase 1 — Daily Foundations

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-phase1-daily-foundations/spec.md`

## Summary

Phase 1 delivers the MVP of LifeFlow: users can track daily habits (binary/quantitative with time ranges), execute step-by-step routines with a timer, manage tasks, capture raw thoughts via a GTD inbox, and see everything assembled in a "Today" view. Domains provide cross-cutting categorization. All data lives in Supabase with RLS. Flutter implements Stacked MVVM + Clean Architecture with the existing design system.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: Stacked (MVVM + DI), supabase_flutter, dartz (Either), equatable, json_annotation, flutter_screenutil
**Storage**: Supabase (PostgreSQL 17 with RLS), local state via Stacked ViewModels
**Testing**: Flutter test + Mockito (mocks via @GenerateMocks)
**Target Platform**: Web (Chrome for dev), iOS 15+, Android 6+
**Project Type**: Mobile + BaaS (Supabase direct, no API for Phase 1)
**Performance Goals**: < 2s page load, < 3s inbox capture, 60 fps UI
**Constraints**: Online-only (Phase 1), RLS enforced on every table, design system tokens only (no hardcoded values)
**Scale/Scope**: Single user, ~10 screens, 7 Supabase tables, 6 features

## Constitution Check

*GATE: Must pass before implementation.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Stacked MVVM + Clean Architecture | ✅ PASS | Entity → Model → Repo → Feature structure followed |
| II. Supabase-First | ✅ PASS | All CRUD via supabase_flutter, no FastAPI in Phase 1 |
| III. Entity/Model Separation | ✅ PASS | Pure entities in domain/, @JsonSerializable models in data/ |
| IV. IA Passive-Informative | ✅ N/A | No AI in Phase 1 |
| V. Feature Independence | ✅ PASS | Each feature owns its views/viewmodels/widgets, shared via domain/ |
| VI. Progressive Disclosure | ✅ PASS | Surface = habits/routines/tasks/inbox, depth = later phases |
| Coding Workflow | ✅ PASS | Supabase migrations first → `db reset` → domain → data → features |
| Quality Gates | ✅ PASS | Either<Failure,T>, RLS, Equatable, i18n, design system tokens |

## Project Structure

### Documentation (this feature)

```text
.specify/specs/001-phase1-daily-foundations/
├── spec.md              # Feature specification (done)
├── plan.md              # This file
├── data-model.md        # Entity/table definitions
└── tasks.md             # Implementation task breakdown
```

### Source Code

```text
supabase/migrations/
├── 20260122000000_create_profiles.sql          # Existing
├── 20260123000005_create_payments.sql           # Existing
├── 20260220000001_create_domains.sql            # NEW
├── 20260220000002_create_habits.sql             # NEW
├── 20260220000003_create_routines.sql           # NEW
├── 20260220000004_create_tasks.sql              # NEW
├── 20260220000005_create_inbox_items.sql        # NEW
├── 20260220000006_seed_default_domains.sql      # NEW (seed via migration)
└── 20260220000007_create_domain_functions.sql   # NEW (RPC helpers)

flutter/lib/
├── core/enums/
│   └── lifeflow_enums.dart                      # NEW — HabitType, TaskPriority, InboxItemStatus, etc.
├── domain/entities/
│   ├── domain_entity.dart                       # NEW
│   ├── habit_entity.dart                        # NEW
│   ├── habit_log_entity.dart                    # NEW
│   ├── routine_entity.dart                      # NEW
│   ├── routine_step_entity.dart                 # NEW
│   ├── routine_log_entity.dart                  # NEW
│   ├── task_entity.dart                         # NEW
│   └── inbox_item_entity.dart                   # NEW
├── domain/repositories/
│   ├── i_domain_repository.dart                 # NEW
│   ├── i_habit_repository.dart                  # NEW
│   ├── i_routine_repository.dart                # NEW
│   ├── i_task_repository.dart                   # NEW
│   └── i_inbox_repository.dart                  # NEW
├── data/models/
│   ├── domain_model.dart                        # NEW
│   ├── habit_model.dart                         # NEW
│   ├── habit_log_model.dart                     # NEW
│   ├── routine_model.dart                       # NEW
│   ├── routine_step_model.dart                  # NEW
│   ├── routine_log_model.dart                   # NEW
│   ├── task_model.dart                          # NEW
│   └── inbox_item_model.dart                    # NEW
├── data/repositories/
│   ├── domain_repository_impl.dart              # NEW
│   ├── habit_repository_impl.dart               # NEW
│   ├── routine_repository_impl.dart             # NEW
│   ├── task_repository_impl.dart                # NEW
│   └── inbox_repository_impl.dart               # NEW
├── features/
│   ├── domains/
│   │   ├── views/domains_view.dart              # Domain management (settings)
│   │   ├── viewmodels/domains_viewmodel.dart
│   │   └── widgets/
│   │       ├── domain_picker_sheet.dart          # Reusable bottom sheet
│   │       └── domain_tile.dart
│   ├── habits/
│   │   ├── views/
│   │   │   ├── habits_view.dart                 # Habits list
│   │   │   └── habit_form_view.dart             # Create/edit habit
│   │   ├── viewmodels/
│   │   │   ├── habits_viewmodel.dart
│   │   │   └── habit_form_viewmodel.dart
│   │   └── widgets/
│   │       ├── habit_check_tile.dart            # Checkable habit for today view
│   │       └── habit_streak_badge.dart
│   ├── routines/
│   │   ├── views/
│   │   │   ├── routines_view.dart               # Routines list
│   │   │   ├── routine_form_view.dart           # Create/edit routine
│   │   │   └── routine_runner_view.dart         # Step-by-step timer
│   │   ├── viewmodels/
│   │   │   ├── routines_viewmodel.dart
│   │   │   ├── routine_form_viewmodel.dart
│   │   │   └── routine_runner_viewmodel.dart
│   │   └── widgets/
│   │       ├── routine_tile.dart
│   │       └── routine_step_tile.dart
│   ├── tasks/
│   │   ├── views/
│   │   │   ├── tasks_view.dart                  # Tasks list
│   │   │   └── task_form_view.dart              # Create/edit task
│   │   ├── viewmodels/
│   │   │   ├── tasks_viewmodel.dart
│   │   │   └── task_form_viewmodel.dart
│   │   └── widgets/
│   │       └── task_tile.dart
│   ├── inbox/
│   │   ├── views/inbox_view.dart                # Capture + list
│   │   ├── viewmodels/inbox_viewmodel.dart
│   │   └── widgets/
│   │       ├── inbox_capture_field.dart
│   │       └── inbox_triage_sheet.dart          # Bottom sheet: → task/habit/discard
│   └── today/
│       ├── views/today_view.dart                # The "Vue Aujourd'hui"
│       ├── viewmodels/today_viewmodel.dart
│       └── widgets/
│           ├── today_habits_section.dart
│           ├── today_routine_card.dart
│           ├── today_tasks_section.dart
│           └── today_inbox_badge.dart
└── l10n/arb/
    ├── app_en.arb                               # UPDATE — add Phase 1 keys
    └── app_fr.arb                               # UPDATE — add Phase 1 keys
```

**Structure Decision**: Mobile + BaaS (Option 3 variant). Flutter talks directly to Supabase — no FastAPI backend in Phase 1. Features live in `flutter/lib/features/` per constitution. Shared entities in `domain/`, models in `data/`.

## Complexity Tracking

No constitution violations. All patterns follow established conventions.

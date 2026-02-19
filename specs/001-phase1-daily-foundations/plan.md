# Implementation Plan: Phase 1 — Le Cockpit Quotidien

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Revised**: 2026-02-19
**Spec**: [spec.md](spec.md) | **Data Model**: [data-model.md](data-model.md) | **Research**: [research.md](research.md)

## Summary

Phase 1 delivers 6 features answering one question: **"Où va mon temps ?"**. Users track daily habits linked to life domains, see a real-time time counter per domain, navigate a contextual TodayView, benefit from automatic streak freeze, and receive a shareable weekly summary. All data lives in Supabase with RLS. Flutter implements Stacked MVVM + Clean Architecture with the design system.

**What Phase 1 IS NOT**: no tasks, no routines, no inbox, no OKR, no AI.

## Technical Context

| Aspect | Value |
|--------|-------|
| **Language** | Dart 3.x / Flutter 3.x |
| **Dependencies** | Stacked (MVVM + DI), supabase_flutter, dartz (Either), equatable, json_annotation, flutter_screenutil |
| **Storage** | Supabase PostgreSQL 17 with RLS. Local state via Stacked ViewModels |
| **Testing** | Flutter test + Mockito |
| **Platform** | Web (Chrome dev), iOS 15+, Android 6+ |
| **Architecture** | Mobile + BaaS (Supabase direct, no FastAPI) |
| **Performance** | < 2s page load, < 500ms habit check, 60 fps |
| **Constraints** | Online-only, RLS enforced, DS tokens only, no hardcoded values |
| **Scale** | Single user, 6 features, 3 entities, ~8 screens |

## Constitution Check

*GATE: Must pass before implementation.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Stacked MVVM + Clean Architecture | ✅ PASS | Entity → Model → Repo → Feature structure |
| II. Supabase-First | ✅ PASS | All CRUD via supabase_flutter, no FastAPI |
| III. Entity/Model Separation | ✅ PASS | Pure entities in domain/, @JsonSerializable models in data/ |
| IV. IA Passive-Informative | ✅ N/A | Zero IA in Phase 1 — l'intelligence est structurelle |
| V. Feature Independence | ✅ PASS | Each feature owns views/viewmodels/widgets, shared via domain/ |
| VI. Progressive Disclosure | ✅ PASS | Surface = habits + counter, depth = later phases |
| Coding Workflow | ✅ PASS | Migration → `db reset` → domain → data → features |
| Quality Gates | ✅ PASS | Either<Failure,T>, RLS, Equatable, i18n, DS tokens |
| DS Mandatory | ✅ PASS | All views use AppCard, AppButton, AppBadge, etc. Zero hardcoded values |

## Project Structure

### Specs (this feature)

```text
specs/001-phase1-daily-foundations/
├── spec.md              # User stories + requirements (6 US)
├── research.md          # Technical decisions (D-001 to D-012)
├── data-model.md        # 3 entities (Domain, Habit, HabitLog) + 2 computed
├── plan.md              # This file
├── wireframes.md        # ASCII wireframes (~8 screens)
├── quickstart.md        # E2E validation scenarios
└── tasks.md             # Implementation task breakdown (~45 tasks)
```

### Source Code

```text
supabase/
├── migrations/
│   ├── 20260220000001_create_domains.sql        # Existant (inchangé)
│   ├── 20260220000002_create_habits.sql         # ⚠️ MODIFIER (+ estimated_duration_minutes)
│   ├── 20260220000003_create_routines.sql       # Existant (P2 — non implémenté Flutter)
│   ├── 20260220000004_create_tasks.sql          # Existant (P2 — non implémenté Flutter)
│   └── 20260220000005_create_inbox_items.sql    # Existant (P2 — non implémenté Flutter)
└── seeds/
    └── 001_default_domains.sql                  # Existant (5 domaines)

flutter/lib/
├── core/
│   └── enums/
│       └── lifeflow_enums.dart                  # Existant (HabitType, HabitFrequency, etc.)
├── domain/
│   ├── entities/
│   │   ├── domain_entity.dart                   # NEW
│   │   ├── habit_entity.dart                    # NEW
│   │   └── habit_log_entity.dart                # NEW
│   └── repositories/
│       ├── i_domain_repository.dart             # NEW
│       └── i_habit_repository.dart              # NEW
├── data/
│   ├── models/
│   │   ├── domain_model.dart                    # NEW
│   │   ├── habit_model.dart                     # NEW
│   │   └── habit_log_model.dart                 # NEW
│   └── repositories/
│       ├── domain_repository_impl.dart          # NEW
│       └── habit_repository_impl.dart           # NEW
├── services/
│   ├── time_counter_service.dart                # NEW — calcul temps/domaine
│   └── bilan_service.dart                       # NEW — génération bilan hebdo
├── features/
│   ├── domains/
│   │   ├── views/domains_view.dart
│   │   ├── viewmodels/domains_viewmodel.dart
│   │   └── widgets/
│   │       ├── domain_picker_sheet.dart         # Reusable bottom sheet
│   │       └── domain_tile.dart
│   ├── habits/
│   │   ├── views/
│   │   │   ├── habits_view.dart                 # Liste habitudes
│   │   │   └── habit_form_view.dart             # Créer/éditer habitude
│   │   ├── viewmodels/
│   │   │   ├── habits_viewmodel.dart
│   │   │   └── habit_form_viewmodel.dart
│   │   └── widgets/
│   │       ├── habit_check_tile.dart            # Checkable habit pour TodayView
│   │       └── habit_streak_badge.dart          # Badge streak 🔥/❄️
│   ├── counter/
│   │   ├── views/counter_view.dart              # Compteur temps détaillé
│   │   ├── viewmodels/counter_viewmodel.dart
│   │   └── widgets/
│   │       ├── domain_time_bar.dart             # Barre temps par domaine
│   │       └── domain_time_detail.dart          # Détail: quelles habitudes
│   ├── today/
│   │   ├── views/today_view.dart                # TodayView contextuel
│   │   ├── viewmodels/today_viewmodel.dart
│   │   └── widgets/
│   │       ├── today_habits_section.dart        # Habitudes groupées par plage
│   │       ├── today_counter_summary.dart       # Mini compteur inline
│   │       └── today_bilan_card.dart            # Carte "Bilan prêt" (dimanche)
│   └── bilan/
│       ├── views/bilan_view.dart                # Bilan hebdo complet
│       ├── viewmodels/bilan_viewmodel.dart
│       └── widgets/
│           ├── bilan_domain_chart.dart          # Barres horizontales par domaine
│           ├── bilan_highlights.dart            # Top habit, streak, completion rate
│           └── bilan_share_widget.dart          # Widget optimisé pour screenshot
└── l10n/arb/
    ├── app_en.arb                               # UPDATE — add P1 keys
    └── app_fr.arb                               # UPDATE — add P1 keys
```

## Complexity Tracking

| Item | Complexité | Notes |
|------|-----------|-------|
| `estimated_duration_minutes` addition | Faible | Modifier 1 migration existante |
| Streak calculation with freeze | Moyenne | Algorithme client-side, voir D-005 |
| Time counter calculation | Moyenne | Join habits × habit_logs, voir D-006 |
| TodayView contextuel (3 modes) | Moyenne | Même données, rendu différent selon l'heure |
| Bilan share (image generation) | Moyenne | `RepaintBoundary.toImage()`, widget dédié |
| DS cleanup (3 doublons) | Faible | Supprimer fichiers morts, 2 imports à corriger |

**Aucune violation constitutionnelle. Tous les patterns suivent les conventions établies.**

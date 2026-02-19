# Tasks: Phase 1 — Le Cockpit Quotidien

**Input**: Design documents from `/specs/001-phase1-daily-foundations/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)
**Tests**: Not included (separate pass).
**Total**: 47 tasks across 8 phases.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story (US1-US6) or shared (SETUP, FOUND, POLISH)

## Path Conventions

- **Supabase**: `supabase/migrations/`, `supabase/seeds/`
- **Flutter domain**: `flutter/lib/domain/`
- **Flutter data**: `flutter/lib/data/`
- **Flutter features**: `flutter/lib/features/`
- **Flutter core**: `flutter/lib/core/`
- **Flutter services**: `flutter/lib/services/`
- **Flutter l10n**: `flutter/lib/l10n/arb/`

---

## Phase 1: Setup (Cleanup & Shared Infrastructure)

**Purpose**: Clean DS duplicates, update enums, add i18n keys.

- [ ] T001 [P] [SETUP] **DS Cleanup** — Delete `flutter/lib/design_system/colors/app_colors.dart` (dead duplicate). Delete `flutter/lib/design_system/radius/app_radius.dart` (dead duplicate). Delete `flutter/lib/design_system/typography/app_typography.dart` (dead duplicate). Update `flutter/lib/ui/bottom_sheets/notice/notice_sheet.dart` and `flutter/lib/ui/dialogs/info_alert/info_alert_dialog.dart` to import from `design_system/tokens/app_colors.dart` instead of `ui/common/app_colors.dart`. Verify barrel file `design_system/design_system.dart` already exports from `tokens/` (it does).
- [ ] T002 [P] [SETUP] **Update enums** in `flutter/lib/core/enums/lifeflow_enums.dart` — Add `TimeSlot` enum (morning, afternoon, evening, anytime) with `fromHour(int hour)` factory. Verify existing enums (HabitType, HabitFrequency) still valid.
- [ ] T003 [P] [SETUP] Add Phase 1 English i18n keys in `flutter/lib/l10n/arb/app_en.arb` — domains, habits, counter, today, bilan, streak labels. Include contextual messages for TodayView modes.
- [ ] T004 [P] [SETUP] Add Phase 1 French i18n keys in `flutter/lib/l10n/arb/app_fr.arb` — matching French translations.

---

## Phase 2: Foundation (Blocking Prerequisites)

**Purpose**: Migration update + domain entities + repository contracts. MUST complete before any feature UI.

**⚠️ CRITICAL**: No feature work can begin until this phase completes and `supabase db reset` passes.

### Migration Update

- [ ] T005 [FOUND] **Modify `supabase/migrations/20260220000002_create_habits.sql`** — Add `estimated_duration_minutes INTEGER NOT NULL DEFAULT 15` between `unit` and `start_time` columns. This is the ONLY migration change needed for P1.
- [ ] T006 [FOUND] **GATE: Run `supabase db reset`** — Must pass with zero errors. Validates all 5 P1 migrations + seeds.

### Domain Layer — Entities

- [ ] T007 [P] [FOUND] Create `flutter/lib/domain/entities/domain_entity.dart` — DomainEntity (Equatable): id, userId, name, icon, color, sortOrder, isArchived, createdAt, updatedAt. Computed: `isDefault` (name matches defaults), `displayColor` (Color from hex). Factory: `empty()`, `mock()`.
- [ ] T008 [P] [FOUND] Create `flutter/lib/domain/entities/habit_entity.dart` — HabitEntity (Equatable): id, userId, domainId, name, description, type (HabitType), targetValue, unit, estimatedDurationMinutes, startTime (TimeOfDay?), endTime (TimeOfDay?), frequency, frequencyDays, isArchived, createdAt, updatedAt. Computed: `isQuantitative`, `timeRangeLabel`, `timeSlot` (TimeSlot enum from startTime), `effectiveDuration(double? logValue)` (if quantitative+unit=min → logValue, else → estimatedDurationMinutes). Factory: `empty()`, `mock()`.
- [ ] T009 [P] [FOUND] Create `flutter/lib/domain/entities/habit_log_entity.dart` — HabitLogEntity (Equatable): id, habitId, logDate, completed, value, createdAt. Computed: `completionPercentage(double targetValue)`, `contributedMinutes(HabitEntity habit)` (calls habit.effectiveDuration). Factory: `empty()`, `mock()`.

### Domain Layer — Repository Contracts

- [ ] T010 [P] [FOUND] Create `flutter/lib/domain/repositories/i_domain_repository.dart` — IDomainRepository: getDomains(), getDomainById(id), createDomain(entity), updateDomain(entity), reorderDomains(orderedIds), archiveDomain(id), unarchiveDomain(id). All return `FutureResult<T>`.
- [ ] T011 [P] [FOUND] Create `flutter/lib/domain/repositories/i_habit_repository.dart` — IHabitRepository: getHabits({domainId?, isArchived?}), getHabitById(id), createHabit(entity), updateHabit(entity), archiveHabit(id), getLogsForDateRange(startDate, endDate), logHabit(habitId, date, completed, value?), removeLog(habitId, date), getStreakInfo(habitId, {freezeEnabled}). All return `FutureResult<T>`.

### Data Layer — Models

- [ ] T012 [P] [FOUND] Create `flutter/lib/data/models/domain_model.dart` — @JsonSerializable DomainModel: mirrors domains table with @JsonKey(name: 'snake_case'). Methods: toEntity(), fromEntity(DomainEntity), fromJson(Map), toJson(). All fields mapped.
- [ ] T013 [P] [FOUND] Create `flutter/lib/data/models/habit_model.dart` — @JsonSerializable HabitModel: mirrors habits table including `estimated_duration_minutes`. @JsonKey for snake_case mapping. Methods: toEntity(), fromEntity(HabitEntity), fromJson(Map), toJson().
- [ ] T014 [P] [FOUND] Create `flutter/lib/data/models/habit_log_model.dart` — @JsonSerializable HabitLogModel: mirrors habit_logs table. Methods: toEntity(), fromEntity(HabitLogEntity), fromJson(Map), toJson().

### Data Layer — Repository Implementations

- [ ] T015 [P] [FOUND] Create `flutter/lib/data/repositories/domain_repository_impl.dart` — DomainRepositoryImpl implements IDomainRepository. Uses `locator<SupabaseService>().client.from('domains')`. Each method wraps in try/catch → Left(Failure). Reorder uses batch update of sort_order.
- [ ] T016 [P] [FOUND] Create `flutter/lib/data/repositories/habit_repository_impl.dart` — HabitRepositoryImpl implements IHabitRepository. Uses `from('habits')` and `from('habit_logs')`. `getStreakInfo` queries logs ordered by date DESC, counts consecutive with freeze tolerance. `logHabit` uses UPSERT (unique on habit_id + log_date).

### Services

- [ ] T017 [P] [FOUND] Create `flutter/lib/services/time_counter_service.dart` — TimeCounterService: `getWeeklyCounters(habits, logs, domains) → List<TimeCounter>`. Pure calculation (no Supabase). Logic per D-006: binary → estimated_duration, quantitative+min → value, other → estimated_duration. Also `getDailyTotal(habits, logs, date) → Map<domainId, minutes>`.
- [ ] T018 [P] [FOUND] Create `flutter/lib/services/bilan_service.dart` — BilanService: `generateBilan(habits, logsThisWeek, logsLastWeek, domains) → WeeklyBilan`. Pure calculation. Computes domain times, completion rate, top habit, longest streak, deltas. Returns `WeeklyBilan` entity.

### DI Registration

- [ ] T019 [FOUND] Register repositories + services in `flutter/lib/app/app.dart` — LazySingleton: DomainRepositoryImpl→IDomainRepository, HabitRepositoryImpl→IHabitRepository, TimeCounterService, BilanService.
- [ ] T020 [FOUND] Run `dart run build_runner build --delete-conflicting-outputs` — Regenerate app.locator.dart, app.router.dart, JSON serialization.

**⛳ Checkpoint**: Foundation ready — migration passes, entities/models/repos compile, DI registered.

---

## Phase 3: US1 — Domaines de vie (Priority: P1)

**Goal**: User can select domains at onboarding, manage them in settings.

- [ ] T021 [US1] Create `flutter/lib/features/domains/viewmodels/domains_viewmodel.dart` — DomainsViewModel: loads domains (active + archived), reorder, add, edit, archive, unarchive. Validates min 1 active domain.
- [ ] T022 [US1] Create `flutter/lib/features/domains/views/domains_view.dart` — DomainsView: ReorderableListView of DomainTiles, archived section (collapsed), FAB to add. Uses AppListTile, AppCard.
- [ ] T023 [P] [US1] Create `flutter/lib/features/domains/widgets/domain_tile.dart` — DomainTile: emoji icon, name, habit count, drag handle, swipe-to-archive. Uses AppListTile.
- [ ] T024 [P] [US1] Create `flutter/lib/features/domains/widgets/domain_picker_sheet.dart` — DomainPickerSheet (AppBottomSheet): list of active domains, tappable, returns selected DomainEntity. "+ Nouveau domaine" button for inline creation.
- [ ] T025 [US1] Update onboarding flow — Add domain selection step (step 2/4) using checkbox list of defaults + "Ajouter" button. Wire to DomainRepositoryImpl.createDomain.
- [ ] T026 [US1] Register domains route in `flutter/lib/app/app.dart` + run build_runner.

**⛳ Checkpoint**: US1 — Domains management + onboarding step functional.

---

## Phase 4: US2 — Habitudes quotidiennes (Priority: P1) 🎯 MVP

**Goal**: User can create binary/quantitative habits with estimated duration, check them daily, see streaks.

- [ ] T027 [US2] Create `flutter/lib/features/habits/viewmodels/habits_viewmodel.dart` — HabitsViewModel: loads habits, filters by domain/archived, groups by timeSlot. Uses IDomainRepository + IHabitRepository.
- [ ] T028 [US2] Create `flutter/lib/features/habits/views/habits_view.dart` — HabitsView (StackedView): AppBar with search, domain filter chips, list of habit cards, FAB to create. Empty state via AppEmptyState.
- [ ] T029 [US2] Create `flutter/lib/features/habits/viewmodels/habit_form_viewmodel.dart` — HabitFormViewModel: create/edit mode, form validation, domain picker trigger, **estimated_duration_minutes field** (stepper/slider: 5-120min, default 15), type toggle, frequency days. Save via IHabitRepository.
- [ ] T030 [US2] Create `flutter/lib/features/habits/views/habit_form_view.dart` — HabitFormView: AppTextField (name, desc), domain picker button, type toggle (AppChip), conditional quantitative fields, **estimated_duration slider** with helper text "Ce temps sera compté dans ton compteur", time range pickers, frequency toggle + day selector.
- [ ] T031 [P] [US2] Create `flutter/lib/features/habits/widgets/habit_check_tile.dart` — HabitCheckTile: checkbox (binary) or input (quantitative), domain chip with color, streak badge, estimated_duration label. On check: calls logHabit + emits counter update. Uses AppCard, AppChip.
- [ ] T032 [P] [US2] Create `flutter/lib/features/habits/widgets/habit_streak_badge.dart` — HabitStreakBadge: displays 🔥 Xj (normal) or ❄️ Xj (freeze active). Tappable → opens streak detail bottom sheet. Uses AppBadge.
- [ ] T033 [US2] Register habits routes in `flutter/lib/app/app.dart` — MaterialRoute for HabitsView, HabitFormView. Run build_runner.

**⛳ Checkpoint**: US2 — Habits CRUD + check/uncheck + streak + duration fully functional.

---

## Phase 5: US3 — Compteur temps/domaine (Priority: P1) 🎯 KILLER FEATURE

**Goal**: User sees time per domain per week, with deltas and habit breakdown.

- [ ] T034 [US3] Create `flutter/lib/features/counter/viewmodels/counter_viewmodel.dart` — CounterViewModel: loads habits + logs for this week + last week. Uses TimeCounterService to compute counters. Week navigation (prev/next). Expand/collapse domain detail. Uses IHabitRepository + IDomainRepository + TimeCounterService.
- [ ] T035 [US3] Create `flutter/lib/features/counter/views/counter_view.dart` — CounterView: week selector, total with delta, list of DomainTimeBars. Tap domain → expand detail. Bottom: bilan card if available. Empty state.
- [ ] T036 [P] [US3] Create `flutter/lib/features/counter/widgets/domain_time_bar.dart` — DomainTimeBar: domain icon+name, horizontal progress bar (domain color), hours label, delta badge. Uses AppProgress, AppBadge.
- [ ] T037 [P] [US3] Create `flutter/lib/features/counter/widgets/domain_time_detail.dart` — DomainTimeDetail: expandable section showing each habit's contribution (name: Xmin (Ymin × Zdays)). Uses AppListTile.
- [ ] T038 [US3] Register counter route in `flutter/lib/app/app.dart` + run build_runner.

**⛳ Checkpoint**: US3 — Time counter fully functional. THE metric works.

---

## Phase 6: US4 — TodayView contextuel (Priority: P1)

**Goal**: Smart home screen that adapts to morning/afternoon/evening.

- [ ] T039 [US4] Create `flutter/lib/features/today/viewmodels/today_viewmodel.dart` — TodayViewModel: loads habits + logs for today + domains. Computes TodayMode (morning/progress/bilan based on hour). Groups habits by TimeSlot. Computes today's time per domain (via TimeCounterService). Handles check/uncheck (delegates to IHabitRepository). Detects if bilan card should show (Sunday/Monday). Uses IHabitRepository + IDomainRepository + TimeCounterService.
- [ ] T040 [US4] Create `flutter/lib/features/today/views/today_view.dart` — TodayView: renders different layouts based on TodayMode. Morning=greeting+habits by slot+mini counter. Progress=done/remaining+progress bar. Bilan=day summary+time recap. Uses all today_* widgets. Empty state.
- [ ] T041 [P] [US4] Create `flutter/lib/features/today/widgets/today_habits_section.dart` — TodayHabitsSection: groups habits by TimeSlot (Matin/Après-midi/Soir/Sans horaire), renders HabitCheckTile for each. Section headers with time range.
- [ ] T042 [P] [US4] Create `flutter/lib/features/today/widgets/today_counter_summary.dart` — TodayCounterSummary: AppCard showing "Cette semaine: Xh" + AppProgress + mini domain chips. Tappable → navigates to CounterView.
- [ ] T043 [P] [US4] Create `flutter/lib/features/today/widgets/today_bilan_card.dart` — TodayBilanCard: AppCard accent, "📊 Ton bilan est prêt !", tappable → navigates to BilanView. Visible only on dimanche soir / lundi matin.
- [ ] T044 [US4] Register today route in `flutter/lib/app/app.dart` + run build_runner.

**⛳ Checkpoint**: US4 — TodayView 3 modes functional, habits checkable, counter updates.

---

## Phase 7: US5 + US6 — Streak Freeze & Bilan Hebdo (Priority: P1)

**Goal**: Streak freeze works automatically. Bilan generates and is shareable.

### US5 — Streak Freeze

- [ ] T045 [US5] **Integrate freeze in streak calculation** — Update `habit_repository_impl.dart` `getStreakInfo` to accept `freezeEnabled` param (default true). Implement algorithm from D-005: 1 gap tolerated per 7-day rolling window. Return `StreakInfo` (count, bestCount, freezeUsedDates, isFreezeActive).
- [ ] T046 [US5] Add streak freeze toggle in Settings — Global toggle `streak_freeze_enabled` stored in SharedPreferences. When disabled, streaks recalculated without freeze.

### US6 — Bilan Hebdo

- [ ] T047 [US6] Create `flutter/lib/features/bilan/viewmodels/bilan_viewmodel.dart` — BilanViewModel: loads data for selected week, uses BilanService to generate WeeklyBilan. Week navigation. Share action (generates image).
- [ ] T048 [US6] Create `flutter/lib/features/bilan/views/bilan_view.dart` — BilanView: week header, total + delta, domain chart (BilanDomainChart), highlights (BilanHighlights), first-week message if applicable, share button (AppButton.primary full width).
- [ ] T049 [P] [US6] Create `flutter/lib/features/bilan/widgets/bilan_domain_chart.dart` — BilanDomainChart: list of horizontal bars per domain (color, hours, percentage of total). Uses AppProgress with domain color.
- [ ] T050 [P] [US6] Create `flutter/lib/features/bilan/widgets/bilan_highlights.dart` — BilanHighlights: AppCard with 🏆 top habit, 🔥 longest streak, 📈 completion rate.
- [ ] T051 [US6] Create `flutter/lib/features/bilan/widgets/bilan_share_widget.dart` — BilanShareWidget: Styled widget for screenshot only (not displayed on screen). Uses `RepaintBoundary` key. Contains: LifeFlow logo, week date, total hours, domain bars (simplified), highlights, URL "lifeflow.app". DS tokens for colors/typography.
- [ ] T052 [US6] **Implement share logic** in BilanViewModel — `share()` method: render BilanShareWidget offscreen via `RepaintBoundary.toImage()`, convert to PNG bytes, write to temp file, call `Share.shareXFiles()`.
- [ ] T053 [US6] Register bilan route in `flutter/lib/app/app.dart` + run build_runner.

**⛳ Checkpoint**: US5+US6 — Freeze preserves streaks, bilan generates and shares.

---

## Phase 8: Polish & Integration

**Purpose**: Navigation, onboarding, final validation.

- [ ] T054 [POLISH] Wire bottom navigation in HomeView — 3 tabs: TodayView, HabitsView, CounterView. Uses AppBottomNav with 3 items. Set TodayView as initial tab.
- [ ] T055 [POLISH] Update SplashView/StartupView — Change initial route to proper app flow (splash → auth check → onboarding if new / home if returning). Remove any designShowcaseView references.
- [ ] T056 [POLISH] **Full onboarding flow** — Wire: Welcome (step 1) → Domain selection (step 2, from T025) → First habit creation suggestion (step 3) → Done (step 4 → TodayView). Each step uses DS widgets.
- [ ] T057 [POLISH] Final `supabase db reset` validation — Confirm all migrations + seeds pass.
- [ ] T058 [POLISH] Run `dart format .` + `dart analyze` — zero errors, zero warnings.
- [ ] T059 [POLISH] Run `flutter run -d chrome` — verify: app launches, 3 tabs visible, all features accessible, empty states work.

---

## Dependencies & Execution Order

```
Phase 1 (Setup: T001-T004)     — No deps, all parallel
        ↓
Phase 2 (Foundation: T005-T020) — T005→T006 gate, then T007-T018 parallel, T019→T020 last
        ↓
Phase 3 (US1 Domains: T021-T026)   ─┐
Phase 4 (US2 Habits: T027-T033)     ├── Sequential (each depends on foundation)
Phase 5 (US3 Counter: T034-T038)    │   BUT US1→US2 (habits need domain picker)
Phase 6 (US4 Today: T039-T044)      │   US3+US4 need US2 (they display habits)
Phase 7 (US5+6 Freeze+Bilan: T045-T053)  US5+US6 need US2+US3
        ↓
Phase 8 (Polish: T054-T059) — Depends on ALL user stories
```

### Optimal Solo Dev Order

```
T001-T004 (setup, parallel)
→ T005-T006 (migration + gate)
→ T007-T018 (entities/models/repos/services, parallel)
→ T019-T020 (DI + build_runner)
→ T021-T026 (US1 Domains) → VALIDATE: domain picker works
→ T027-T033 (US2 Habits) → VALIDATE: habits CRUD + check + streak
→ T034-T038 (US3 Counter) → VALIDATE: time counter shows correct data
→ T039-T044 (US4 Today) → VALIDATE: 3 modes, habits checkable
→ T045-T053 (US5+US6 Freeze + Bilan) → VALIDATE: freeze preserves streak, bilan shareable
→ T054-T059 (Polish) → VALIDATE: full app flow end-to-end
```

**Total: 59 tasks** (was 89 in the old spec — 34% reduction with Routines, Tasks, Inbox removed).

### Parallel Opportunities

- T001-T004 (setup): All parallel
- T007-T018 (entities + models + repos + services): All parallel
- T023-T024, T031-T032, T036-T037, T041-T043, T049-T050: Widgets parallel within each story

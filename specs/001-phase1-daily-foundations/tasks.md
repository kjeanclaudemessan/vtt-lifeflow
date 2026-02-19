# Tasks: Phase 1 — Daily Foundations

**Input**: Design documents from `/specs/001-phase1-daily-foundations/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Tests**: Not included in Phase 1 tasks (will be added in a separate pass).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Supabase**: `supabase/migrations/`
- **Flutter domain**: `flutter/lib/domain/`
- **Flutter data**: `flutter/lib/data/`
- **Flutter features**: `flutter/lib/features/`
- **Flutter core**: `flutter/lib/core/`
- **Flutter l10n**: `flutter/lib/l10n/arb/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Enums, shared types, and i18n keys needed by all features

- [x] T001 [P] Create LifeFlow enums in `flutter/lib/core/enums/lifeflow_enums.dart` — HabitType (binary/quantitative), HabitFrequency (daily/weekly/custom), TaskPriority (low/medium/high), InboxItemStatus (pending/processed/discarded), RoutineLogStatus (completed/abandoned)
- [ ] T002 [P] Add Phase 1 English i18n keys in `flutter/lib/l10n/arb/app_en.arb` — domains, habits, routines, tasks, inbox, today view labels
- [ ] T003 [P] Add Phase 1 French i18n keys in `flutter/lib/l10n/arb/app_fr.arb` — matching French translations

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Supabase migrations + domain entities + repository contracts. MUST complete before any feature UI.

**⚠️ CRITICAL**: No feature work can begin until this phase is complete and `supabase db reset` passes.

### Supabase Migrations

- [x] T004 Create `supabase/migrations/20260220000001_create_domains.sql` — domains table (id UUID PK, user_id UUID FK auth.users, name TEXT, icon TEXT, color TEXT, sort_order INT, is_archived BOOL, created_at, updated_at) + RLS policies + indexes
- [x] T005 Create `supabase/migrations/20260220000002_create_habits.sql` — habits table (id, user_id, domain_id FK, name, description, type enum binary/quantitative, target_value NUMERIC, unit TEXT, start_time TIME, end_time TIME, frequency, is_archived, created_at, updated_at) + habit_logs table (id, habit_id FK, log_date DATE, completed BOOL, value NUMERIC, created_at) + RLS + indexes + unique constraint (habit_id, log_date)
- [x] T006 Create `supabase/migrations/20260220000003_create_routines.sql` — routines table (id, user_id, domain_id FK, name, description, is_archived, created_at, updated_at) + routine_steps table (id, routine_id FK, name, description, estimated_duration INT seconds, sort_order INT, created_at) + routine_logs table (id, routine_id FK, user_id, started_at, completed_at, total_duration INT, status enum completed/abandoned, steps_completed INT, created_at) + RLS + indexes
- [x] T007 Create `supabase/migrations/20260220000004_create_tasks.sql` — tasks table (id, user_id, domain_id FK, title, description, priority enum low/medium/high, due_date DATE, completed_at TIMESTAMPTZ, is_archived, created_at, updated_at) + RLS + indexes
- [x] T008 Create `supabase/migrations/20260220000005_create_inbox_items.sql` — inbox_items table (id, user_id, raw_text TEXT, status enum pending/processed/discarded, processed_as TEXT nullable, linked_task_id UUID nullable FK, linked_habit_id UUID nullable FK, created_at, updated_at) + RLS + indexes
- [x] T009 Create `supabase/seeds/001_default_domains.sql` — function to seed 5 default domains on new user signup (Santé/Health, Travail/Work, Relations/Relationships, Finances, Développement personnel/Personal Growth) with icons and colors, triggered via auth.users insert trigger
- [x] T010 **GATE: Run `supabase db reset`** — must pass with zero errors before proceeding

### Domain Layer — Entities

- [ ] T011 [P] Create `flutter/lib/domain/entities/domain_entity.dart` — DomainEntity (Equatable): id, userId, name, icon, color, sortOrder, isArchived, createdAt, updatedAt. Computed: `isDefault` (based on name matching defaults). Factory: `empty()`, `mock()`.
- [ ] T012 [P] Create `flutter/lib/domain/entities/habit_entity.dart` — HabitEntity (Equatable): id, userId, domainId, name, description, type (HabitType), targetValue, unit, startTime (TimeOfDay), endTime (TimeOfDay), frequency, isArchived, createdAt, updatedAt. Computed: `isQuantitative`, `timeRangeLabel`. Factory: `empty()`, `mock()`.
- [ ] T013 [P] Create `flutter/lib/domain/entities/habit_log_entity.dart` — HabitLogEntity (Equatable): id, habitId, logDate, completed, value, createdAt. Computed: `completionPercentage` (for quantitative: value/target).
- [ ] T014 [P] Create `flutter/lib/domain/entities/routine_entity.dart` — RoutineEntity (Equatable): id, userId, domainId, name, description, steps (List<RoutineStepEntity>), isArchived, createdAt, updatedAt. Computed: `totalEstimatedDuration`, `stepCount`.
- [ ] T015 [P] Create `flutter/lib/domain/entities/routine_step_entity.dart` — RoutineStepEntity (Equatable): id, routineId, name, description, estimatedDuration (Duration), sortOrder, createdAt.
- [ ] T016 [P] Create `flutter/lib/domain/entities/routine_log_entity.dart` — RoutineLogEntity (Equatable): id, routineId, userId, startedAt, completedAt, totalDuration (Duration), status (RoutineLogStatus), stepsCompleted, createdAt.
- [ ] T017 [P] Create `flutter/lib/domain/entities/task_entity.dart` — TaskEntity (Equatable): id, userId, domainId, title, description, priority (TaskPriority), dueDate, completedAt, isArchived, createdAt, updatedAt. Computed: `isCompleted`, `isOverdue`, `isDueToday`.
- [ ] T018 [P] Create `flutter/lib/domain/entities/inbox_item_entity.dart` — InboxItemEntity (Equatable): id, userId, rawText, status (InboxItemStatus), processedAs, linkedTaskId, linkedHabitId, createdAt, updatedAt. Computed: `isPending`, `isProcessed`.

### Domain Layer — Repository Contracts

- [ ] T019 [P] Create `flutter/lib/domain/repositories/i_domain_repository.dart` — IDomainRepository: getDomains(), getDomainById(id), createDomain(entity), updateDomain(entity), reorderDomains(ids), archiveDomain(id). All return `FutureResult<T>`.
- [ ] T020 [P] Create `flutter/lib/domain/repositories/i_habit_repository.dart` — IHabitRepository: getHabits(filters), getHabitById(id), createHabit(entity), updateHabit(entity), archiveHabit(id), getLogsForDate(date), getLogsForRange(start, end), logHabit(habitId, date, completed, value?), removeLog(habitId, date), getStreak(habitId). All return `FutureResult<T>`.
- [ ] T021 [P] Create `flutter/lib/domain/repositories/i_routine_repository.dart` — IRoutineRepository: getRoutines(), getRoutineById(id), createRoutine(entity, steps), updateRoutine(entity, steps), archiveRoutine(id), logRoutineExecution(log). All return `FutureResult<T>`.
- [ ] T022 [P] Create `flutter/lib/domain/repositories/i_task_repository.dart` — ITaskRepository: getTasks(filters), getTaskById(id), createTask(entity), updateTask(entity), completeTask(id), uncompleteTask(id), archiveTask(id), getTasksDueOn(date). All return `FutureResult<T>`.
- [ ] T023 [P] Create `flutter/lib/domain/repositories/i_inbox_repository.dart` — IInboxRepository: getInboxItems(status?), createItem(rawText), processAsTask(itemId, taskEntity), processAsHabit(itemId, habitEntity), discardItem(itemId), getPendingCount(). All return `FutureResult<T>`.

### Data Layer — Models

- [ ] T024 [P] Create `flutter/lib/data/models/domain_model.dart` — @JsonSerializable DomainModel: mirrors domains table with @JsonKey(name: 'snake_case'). Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T025 [P] Create `flutter/lib/data/models/habit_model.dart` — @JsonSerializable HabitModel: mirrors habits table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T026 [P] Create `flutter/lib/data/models/habit_log_model.dart` — @JsonSerializable HabitLogModel: mirrors habit_logs table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T027 [P] Create `flutter/lib/data/models/routine_model.dart` — @JsonSerializable RoutineModel: mirrors routines table. Methods: toEntity(steps), fromEntity(), fromJson(), toJson().
- [ ] T028 [P] Create `flutter/lib/data/models/routine_step_model.dart` — @JsonSerializable RoutineStepModel: mirrors routine_steps table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T029 [P] Create `flutter/lib/data/models/routine_log_model.dart` — @JsonSerializable RoutineLogModel: mirrors routine_logs table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T030 [P] Create `flutter/lib/data/models/task_model.dart` — @JsonSerializable TaskModel: mirrors tasks table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T031 [P] Create `flutter/lib/data/models/inbox_item_model.dart` — @JsonSerializable InboxItemModel: mirrors inbox_items table. Methods: toEntity(), fromEntity(), fromJson(), toJson().

### Data Layer — Repository Implementations

- [ ] T032 [P] Create `flutter/lib/data/repositories/domain_repository_impl.dart` — DomainRepositoryImpl implements IDomainRepository. Uses `locator<SupabaseService>().client.from('domains')`. Each method wraps in try/catch → Left(Failure).
- [ ] T033 [P] Create `flutter/lib/data/repositories/habit_repository_impl.dart` — HabitRepositoryImpl implements IHabitRepository. Uses `from('habits')` and `from('habit_logs')`. Streak calculated via ordered query on habit_logs.
- [ ] T034 [P] Create `flutter/lib/data/repositories/routine_repository_impl.dart` — RoutineRepositoryImpl implements IRoutineRepository. Uses `from('routines')`, `from('routine_steps')`, `from('routine_logs')`.
- [ ] T035 [P] Create `flutter/lib/data/repositories/task_repository_impl.dart` — TaskRepositoryImpl implements ITaskRepository. Uses `from('tasks')`.
- [ ] T036 [P] Create `flutter/lib/data/repositories/inbox_repository_impl.dart` — InboxRepositoryImpl implements IInboxRepository. Uses `from('inbox_items')`. processAsTask creates task + updates inbox_item in transaction.

### DI Registration

- [ ] T037 Register all 5 repositories in `flutter/lib/app/app.dart` — add imports + LazySingleton entries for DomainRepositoryImpl→IDomainRepository, HabitRepositoryImpl→IHabitRepository, RoutineRepositoryImpl→IRoutineRepository, TaskRepositoryImpl→ITaskRepository, InboxRepositoryImpl→IInboxRepository
- [ ] T038 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate app.locator.dart, app.router.dart

**Checkpoint**: Foundation ready — all migrations pass, all entities/models/repos compile, DI registered. Feature implementation can begin.

---

## Phase 3: User Story 1 — Create and Track Daily Habits (Priority: P1) 🎯 MVP

**Goal**: User can create binary/quantitative habits with time ranges, check them daily, and see streaks.

**Independent Test**: Create a habit, see it in the list, check it today, verify streak = 1.

### Implementation for User Story 1

- [ ] T039 [US1] Create `flutter/lib/features/habits/viewmodels/habits_viewmodel.dart` — HabitsViewModel: loads habits list, filters by domain/archived, groups by time range. Uses locator<IHabitRepository>(), locator<IDomainRepository>().
- [ ] T040 [US1] Create `flutter/lib/features/habits/views/habits_view.dart` — HabitsView (StackedView<HabitsViewModel>): AppBar with filter, list of habits using AppCard/AppListTile from design system, FAB to create, empty state via AppEmptyState.
- [ ] T041 [US1] Create `flutter/lib/features/habits/viewmodels/habit_form_viewmodel.dart` — HabitFormViewModel: create/edit mode, form validation, domain picker trigger, save via repository.
- [ ] T042 [US1] Create `flutter/lib/features/habits/views/habit_form_view.dart` — HabitFormView: AppTextField for name/description, AppDropdown for type, AppSlider for target, time range pickers, domain picker button. Uses design system widgets.
- [ ] T043 [P] [US1] Create `flutter/lib/features/habits/widgets/habit_check_tile.dart` — HabitCheckTile widget: shows habit name, domain color, time range, checkbox (binary) or progress bar (quantitative), streak badge. Uses AppCard, AppBadge, AppProgress from design system.
- [ ] T044 [P] [US1] Create `flutter/lib/features/habits/widgets/habit_streak_badge.dart` — HabitStreakBadge widget: displays current streak with fire emoji, uses AppBadge from design system.
- [ ] T045 [US1] Register habits routes in `flutter/lib/app/app.dart` — add MaterialRoute for HabitsView, HabitFormView
- [ ] T046 [US1] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 1 — habits CRUD + check + streak fully functional.

---

## Phase 4: User Story 2 — Launch and Complete a Routine (Priority: P1) 🎯 MVP

**Goal**: User can create routines with ordered steps, launch a step-by-step timer, and log completion.

**Independent Test**: Create a routine with 3 steps, launch it, complete all steps, verify log exists.

### Implementation for User Story 2

- [ ] T047 [US2] Create `flutter/lib/features/routines/viewmodels/routines_viewmodel.dart` — RoutinesViewModel: loads routines list, filter by domain/archived.
- [ ] T048 [US2] Create `flutter/lib/features/routines/views/routines_view.dart` — RoutinesView: list of routines with AppCard, total duration, step count, launch button, FAB to create.
- [ ] T049 [US2] Create `flutter/lib/features/routines/viewmodels/routine_form_viewmodel.dart` — RoutineFormViewModel: create/edit, manage ordered steps list (add/remove/reorder), save routine + steps.
- [ ] T050 [US2] Create `flutter/lib/features/routines/views/routine_form_view.dart` — RoutineFormView: name/description fields, ReorderableListView for steps, each step has name + duration, domain picker.
- [ ] T051 [US2] Create `flutter/lib/features/routines/viewmodels/routine_runner_viewmodel.dart` — RoutineRunnerViewModel: manages current step index, countdown timer (Stopwatch/Timer), next/skip/abandon actions, logs result on completion.
- [ ] T052 [US2] Create `flutter/lib/features/routines/views/routine_runner_view.dart` — RoutineRunnerView: full-screen runner with current step name, circular countdown timer (AppProgress), step progress indicator, next/abandon buttons.
- [ ] T053 [P] [US2] Create `flutter/lib/features/routines/widgets/routine_tile.dart` — RoutineTile: routine name, domain color, step count, estimated duration, launch button. Uses AppCard.
- [ ] T054 [P] [US2] Create `flutter/lib/features/routines/widgets/routine_step_tile.dart` — RoutineStepTile: step name, duration, drag handle for reorder. Uses AppListTile.
- [ ] T055 [US2] Register routine routes in `flutter/lib/app/app.dart` — add MaterialRoute for RoutinesView, RoutineFormView, RoutineRunnerView
- [ ] T056 [US2] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 2 — routines CRUD + runner fully functional.

---

## Phase 5: User Story 3 — Capture and Triage via GTD Inbox (Priority: P1) 🎯 MVP

**Goal**: User can quickly capture raw text, then triage items into tasks/habits or discard.

**Independent Test**: Capture 3 items, triage one as task, one as habit, discard one. Verify inbox empty.

### Implementation for User Story 3

- [ ] T057 [US3] Create `flutter/lib/features/inbox/viewmodels/inbox_viewmodel.dart` — InboxViewModel: loads pending items, capture new item, triage actions (→ task, → habit, → discard), pending count.
- [ ] T058 [US3] Create `flutter/lib/features/inbox/views/inbox_view.dart` — InboxView: capture field at top (AppTextField with send icon), list of pending items below, swipe or tap to triage, empty state.
- [ ] T059 [P] [US3] Create `flutter/lib/features/inbox/widgets/inbox_capture_field.dart` — InboxCaptureField: focused AppTextField with submit on enter, auto-clear, minimal UI for speed.
- [ ] T060 [P] [US3] Create `flutter/lib/features/inbox/widgets/inbox_triage_sheet.dart` — InboxTriageSheet (bottom sheet): shows item text, 3 actions (Create Task → opens task form pre-filled, Create Habit → opens habit form pre-filled, Discard).
- [ ] T061 [US3] Register inbox route in `flutter/lib/app/app.dart` — add MaterialRoute for InboxView
- [ ] T062 [US3] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 3 — inbox capture + triage fully functional.

---

## Phase 6: User Story 4 — Manage Life Domains (Priority: P2)

**Goal**: User can customize domains (add/rename/reorder/archive) and select them during onboarding.

**Independent Test**: Reorder domains, add a new one, verify it appears in the domain picker.

### Implementation for User Story 4

- [ ] T063 [US4] Create `flutter/lib/features/domains/viewmodels/domains_viewmodel.dart` — DomainsViewModel: loads domains, reorder, add, edit, archive.
- [ ] T064 [US4] Create `flutter/lib/features/domains/views/domains_view.dart` — DomainsView: ReorderableListView of domain tiles, FAB to add, swipe to archive. Uses design system.
- [ ] T065 [P] [US4] Create `flutter/lib/features/domains/widgets/domain_tile.dart` — DomainTile: icon, name, color indicator, drag handle, edit/archive actions. Uses AppListTile, AppChip.
- [ ] T066 [P] [US4] Create `flutter/lib/features/domains/widgets/domain_picker_sheet.dart` — DomainPickerSheet (bottom sheet): list of active domains for selection, returns selected DomainEntity. Used by habit/task/routine forms.
- [ ] T067 [US4] Register domains route in `flutter/lib/app/app.dart` — add MaterialRoute for DomainsView
- [ ] T068 [US4] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 4 — domains CRUD + picker fully functional.

---

## Phase 7: User Story 5 — Manage Simple Tasks (Priority: P2)

**Goal**: User can create tasks with priority/date/domain, mark them done, filter by domain.

**Independent Test**: Create a task due today, see it in the list, mark done, verify it moves to completed.

### Implementation for User Story 5

- [ ] T069 [US5] Create `flutter/lib/features/tasks/viewmodels/tasks_viewmodel.dart` — TasksViewModel: loads tasks, filters (domain, status, date), mark done/undone.
- [ ] T070 [US5] Create `flutter/lib/features/tasks/views/tasks_view.dart` — TasksView: segmented control (Active/Completed), filterable list, FAB to create. Uses AppChip for filters, AppCard for tasks.
- [ ] T071 [US5] Create `flutter/lib/features/tasks/viewmodels/task_form_viewmodel.dart` — TaskFormViewModel: create/edit mode, validation, domain picker, date picker, priority selector.
- [ ] T072 [US5] Create `flutter/lib/features/tasks/views/task_form_view.dart` — TaskFormView: title/description fields, priority chips, date picker, domain picker. Uses design system.
- [ ] T073 [P] [US5] Create `flutter/lib/features/tasks/widgets/task_tile.dart` — TaskTile: checkbox, title, priority indicator, due date, domain color. Uses AppListTile, AppBadge.
- [ ] T074 [US5] Register tasks routes in `flutter/lib/app/app.dart` — add MaterialRoute for TasksView, TaskFormView
- [ ] T075 [US5] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 5 — tasks CRUD + complete/uncomplete fully functional.

---

## Phase 8: User Story 6 — Today View (Priority: P2)

**Goal**: User opens app and sees their entire day: habits by time range, active routine, tasks due today, inbox count.

**Independent Test**: With 2 habits, 1 routine, 3 tasks today, 2 inbox items — verify Today view shows all.

### Implementation for User Story 6

- [ ] T076 [US6] Create `flutter/lib/features/today/viewmodels/today_viewmodel.dart` — TodayViewModel: loads today's habits (with logs), routines, tasks due today + overdue, inbox pending count. Groups habits by time range. Uses all 5 repositories.
- [ ] T077 [US6] Create `flutter/lib/features/today/views/today_view.dart` — TodayView: scrollable page with sections (habits, routine, tasks, inbox). Uses design system spacing, cards, sections.
- [ ] T078 [P] [US6] Create `flutter/lib/features/today/widgets/today_habits_section.dart` — TodayHabitsSection: groups habits by time range (morning/afternoon/evening), each rendered as HabitCheckTile.
- [ ] T079 [P] [US6] Create `flutter/lib/features/today/widgets/today_routine_card.dart` — TodayRoutineCard: shows next/active routine with launch button, duration, step count. Uses AppCard.
- [ ] T080 [P] [US6] Create `flutter/lib/features/today/widgets/today_tasks_section.dart` — TodayTasksSection: lists tasks due today + overdue, each as TaskTile with checkbox.
- [ ] T081 [P] [US6] Create `flutter/lib/features/today/widgets/today_inbox_badge.dart` — TodayInboxBadge: inbox icon with count badge, tappable to navigate to inbox. Uses AppBadge.
- [ ] T082 [US6] Update HomeView to use TodayView as main content — replace existing HomeView body with TodayView or integrate via bottom navigation.
- [ ] T083 [US6] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 6 — Today view assembles all features into a single daily dashboard.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Integration, navigation, final validation.

- [ ] T084 Wire bottom navigation in HomeView — tabs for Today, Habits, Routines, Tasks, Inbox. Uses AppBottomNav from design system.
- [ ] T085 Update onboarding flow — add domain selection step (step 2) using domain picker with pre-selected defaults.
- [ ] T086 Update SplashView/StartupView — change initial route from designShowcaseView to proper app flow (splash → auth → onboarding/home).
- [ ] T087 Final `supabase db reset` validation — confirm all migrations + seed pass.
- [ ] T088 Run `dart format .` + `dart analyze` — zero errors, zero warnings.
- [ ] T089 Run `flutter run -d chrome` — verify app launches and all features are accessible.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — **BLOCKS all features**
- **User Stories (Phases 3-8)**: All depend on Foundational completion
  - US1 (Habits) + US2 (Routines) + US3 (Inbox): Can proceed in priority order P1 → P1 → P1
  - US4 (Domains) + US5 (Tasks): P2 — after P1 stories, or in parallel if capacity allows
  - US6 (Today): P2 — depends on US1 + US2 + US3 + US5 existing (it aggregates them)
- **Polish (Phase 9)**: Depends on all user stories being complete

### Within Each User Story

- ViewModels before Views (VM contains the logic Views depend on)
- Widgets can be created in parallel with VMs (they're stateless UI)
- Route registration + build_runner after views are created
- Story complete before moving to next priority

### Parallel Opportunities

- T001-T003 (setup): All parallel
- T004-T009 (migrations): Sequential (ordered timestamps)
- T011-T023 (entities + contracts): All parallel (independent files)
- T024-T036 (models + repo impls): All parallel
- T043-T044, T053-T054, T059-T060, T065-T066, T073, T078-T081: Widgets in parallel within each story

---

## Implementation Strategy

### Sequential Solo Developer

1. Complete Phase 1 (Setup) → 3 tasks
2. Complete Phase 2 (Foundational) → 35 tasks, ending with `supabase db reset` gate
3. Complete Phase 3 (US1 Habits) → 8 tasks → **VALIDATE: habits work end-to-end**
4. Complete Phase 4 (US2 Routines) → 10 tasks → **VALIDATE: runner works**
5. Complete Phase 5 (US3 Inbox) → 6 tasks → **VALIDATE: capture + triage works**
6. Complete Phase 6 (US4 Domains) → 6 tasks → **VALIDATE: domain management works**
7. Complete Phase 7 (US5 Tasks) → 7 tasks → **VALIDATE: tasks work**
8. Complete Phase 8 (US6 Today) → 8 tasks → **VALIDATE: today assembles everything**
9. Complete Phase 9 (Polish) → 6 tasks → **VALIDATE: full app flow**

Total: 89 tasks

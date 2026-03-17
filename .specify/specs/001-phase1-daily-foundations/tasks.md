# Tasks: Phase 1 — Daily Foundations

**Input**: Design documents from `/specs/001-phase1-daily-foundations/`
**Prerequisites**: plan.md (required), spec.md (required for user stories)
**Last updated**: 2026-03-17 — synchronized with actual codebase state

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

- [x] T001 [P] Create LifeFlow enums in `flutter/lib/core/enums/lifeflow_enums.dart` — HabitType (binary/quantitative), HabitFrequency (daily/weekly/custom), TaskPriority (low/medium/high), InboxItemStatus (pending/processed/discarded), RoutineLogStatus (completed/abandoned), TimeSlot (morning/afternoon/evening/anytime), TodayMode (morning/progress/bilan)
- [ ] T002 [P] Add Phase 1 English i18n keys in `flutter/lib/l10n/arb/app_en.arb` — habits (creation, check, streak, form, filters), routines (creation, runner, steps, timer), tasks (creation, completion, filters, priority), inbox (capture, triage, discard), today view (sections, empty states, bilan trigger), counter (weekly total, delta, domain bars), bilan (weekly summary, highlights, share). **Currently partial**: domain keys + basic app keys exist, missing feature-specific UI keys.
- [ ] T003 [P] Add Phase 1 French i18n keys in `flutter/lib/l10n/arb/app_fr.arb` — matching French translations for all keys in T002. **Currently partial**: same gaps as EN.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Supabase migrations + domain entities + repository contracts. MUST complete before any feature UI.

**⚠️ CRITICAL**: No feature work can begin until this phase is complete and `supabase db reset` passes.

### Supabase Migrations

- [x] T004 Create `supabase/migrations/20260220000001_create_domains.sql` — domains table (id UUID PK, user_id UUID FK auth.users, name TEXT, icon TEXT, color TEXT, sort_order INT, is_archived BOOL, created_at, updated_at) + RLS policies + indexes + trigger to auto-insert 5 default domains on signup
- [x] T005 Create `supabase/migrations/20260220000002_create_habits.sql` — habits table (id, user_id, domain_id FK, name, description, type enum binary/quantitative, target_value NUMERIC, unit TEXT, estimated_duration_minutes INT, start_time TIME, end_time TIME, frequency, frequency_days INT[], is_archived, created_at, updated_at) + habit_logs table (id, habit_id FK, log_date DATE, completed BOOL, value NUMERIC, created_at) + RLS + indexes + unique constraint (habit_id, log_date)
- [x] T006 Create `supabase/migrations/20260220000003_create_routines.sql` — routines table (id, user_id, domain_id FK, name, description, is_archived, created_at, updated_at) + routine_steps table (id, routine_id FK, name, description, estimated_duration INT seconds, sort_order INT, created_at) + routine_logs table (id, routine_id FK, user_id, started_at, completed_at, total_duration INT, status enum completed/abandoned, steps_completed INT, created_at) + RLS + indexes
- [x] T007 Create `supabase/migrations/20260220000004_create_tasks.sql` — tasks table (id, user_id, domain_id FK, title, description, priority enum low/medium/high, due_date DATE, completed_at TIMESTAMPTZ, is_archived, created_at, updated_at) + RLS + indexes
- [x] T008 Create `supabase/migrations/20260220000005_create_inbox_items.sql` — inbox_items table (id, user_id, raw_text TEXT, status enum pending/processed/discarded, processed_as TEXT nullable, linked_task_id UUID nullable FK, linked_habit_id UUID nullable FK, created_at, updated_at) + RLS + indexes
- [x] T008b Create `supabase/migrations/20260220000006_create_notifications.sql` — notifications table (id, user_id, type enum general/reminder/alert/success/streak/bilan, channel enum reminders/streaks/bilan/general, title, body, is_read, action_url, metadata JSONB, created_at) + RLS + trigger: welcome notification on profile creation
- [x] T008c Create `supabase/migrations/20260220000007_create_device_tokens.sql` — device_tokens table (user_id, token, platform enum android/ios/web, device_name, created_at, updated_at) + unique constraint (user_id, token) + RLS
- [x] T008d Create `supabase/migrations/20260305000001_enhance_habits_and_logs.sql` — adds notifications_enabled BOOL + reminder_offset_minutes INT to habits; adds actual_start_time TIME + actual_end_time TIME to habit_logs for time adherence tracking
- [x] T009 Create `supabase/seeds/001_default_domains.sql` — inserts 5 default domains for existing users (Santé 💪 #4CAF50, Travail 💼 #2196F3, Relations ❤️ #E91E63, Finances 💰 #FF9800, Développement personnel 🌱 #9C27B0) with ON CONFLICT skip
- [x] T010 **GATE: Run `supabase db reset`** — must pass with zero errors before proceeding

### Supabase Edge Functions

- [x] T010b Create `supabase/functions/daily-streak-check/index.ts` — Cron (01:00 UTC daily): resets streaks for uncompleted habits, inserts "streak broken" notifications
- [x] T010c Create `supabase/functions/push-notification/index.ts` — Webhook (on notification INSERT): sends FCM push via user device tokens
- [x] T010d Create `supabase/functions/weekly-bilan-reminder/index.ts` — Cron (Sunday 19:00 UTC): creates weekly bilan notifications for users with active habits
- [x] T010e Create `supabase/functions/_shared/` — cors.ts, response.ts, supabase-admin.ts shared utilities

### Domain Layer — Entities

- [x] T011 [P] Create `flutter/lib/domain/entities/domain_entity.dart` — DomainEntity (Equatable): id, userId, name, icon, color, description, sortOrder, isArchived, createdAt, updatedAt. Computed: `displayColor` (Color from hex), `isDefault`. Factory: `empty()`.
- [x] T012 [P] Create `flutter/lib/domain/entities/habit_entity.dart` — HabitEntity (Equatable): id, userId, domainId (nullable), name, description, type (HabitType), targetValue, unit, estimatedDurationMinutes, startTime (TimeOfDay), endTime (TimeOfDay), frequency, frequencyDays (List<int>), notificationsEnabled, reminderOffsetMinutes, isArchived, createdAt, updatedAt. Computed: `isQuantitative`, `timeSlot`, `timeRangeLabel`, `effectiveDuration(value?)`, `isScheduledForToday`.
- [x] T013 [P] Create `flutter/lib/domain/entities/habit_log_entity.dart` — HabitLogEntity (Equatable): id, habitId, logDate, completed, value, actualStartTime, actualEndTime, createdAt. Computed: `completionPercentage(target)`, `contributedMinutes(habit)`, `timeAdherence(habit)`, `adherenceLabel(habit)`.
- [ ] T014 [P] Create `flutter/lib/domain/entities/routine_entity.dart` — RoutineEntity (Equatable): id, userId, domainId, name, description, steps (List<RoutineStepEntity>), isArchived, createdAt, updatedAt. Computed: `totalEstimatedDuration`, `stepCount`.
- [ ] T015 [P] Create `flutter/lib/domain/entities/routine_step_entity.dart` — RoutineStepEntity (Equatable): id, routineId, name, description, estimatedDuration (Duration), sortOrder, createdAt.
- [ ] T016 [P] Create `flutter/lib/domain/entities/routine_log_entity.dart` — RoutineLogEntity (Equatable): id, routineId, userId, startedAt, completedAt, totalDuration (Duration), status (RoutineLogStatus), stepsCompleted, createdAt.
- [ ] T017 [P] Create `flutter/lib/domain/entities/task_entity.dart` — TaskEntity (Equatable): id, userId, domainId, title, description, priority (TaskPriority), dueDate, completedAt, isArchived, createdAt, updatedAt. Computed: `isCompleted`, `isOverdue`, `isDueToday`.
- [ ] T018 [P] Create `flutter/lib/domain/entities/inbox_item_entity.dart` — InboxItemEntity (Equatable): id, userId, rawText, status (InboxItemStatus), processedAs, linkedTaskId, linkedHabitId, createdAt, updatedAt. Computed: `isPending`, `isProcessed`.
- [x] T018b [P] Create `flutter/lib/domain/entities/streak_info.dart` — StreakInfo: currentStreak, bestStreak, freezeUsedDates (List<DateTime>), isFreezeActive (1 freeze per 7-day window).
- [x] T018c [P] Create `flutter/lib/domain/entities/weekly_bilan.dart` — WeeklyBilan: weekStartDate, domainTimes (List<TimeCounter>), totalMinutes, totalMinutesLastWeek, completionRate, topHabit, longestStreak, isFirstWeek.
- [x] T018d [P] Create `flutter/lib/domain/entities/time_counter.dart` — TimeCounter: domainId, domainName, domainColor, domainIcon, totalMinutesThisWeek, totalMinutesLastWeek, habitBreakdown. Computed: `deltaMinutes`, `formattedTotal()`, `formattedDelta()`.
- [x] T018e [P] Create `flutter/lib/domain/entities/notification_entity.dart` — NotificationEntity: id, userId, type, channel, title, body, isRead, actionUrl, metadata, createdAt.

### Domain Layer — Repository Contracts

- [x] T019 [P] Create `flutter/lib/domain/repositories/i_domain_repository.dart` — IDomainRepository: getDomains(), getDomainById(id), createDomain(entity), updateDomain(entity), reorderDomains(ids), archiveDomain(id), unarchiveDomain(id). All return `FutureResult<T>`.
- [x] T020 [P] Create `flutter/lib/domain/repositories/i_habit_repository.dart` — IHabitRepository: getHabits(filters), getHabitById(id), createHabit(entity), updateHabit(entity), archiveHabit(id), getLogsForDate(date), getLogsForDateRange(start, end), logHabit(habitId, date, completed, value?), removeLog(habitId, date), getStreakInfo(habitId). All return `FutureResult<T>`.
- [ ] T021 [P] Create `flutter/lib/domain/repositories/i_routine_repository.dart` — IRoutineRepository: getRoutines(), getRoutineById(id), createRoutine(entity, steps), updateRoutine(entity, steps), archiveRoutine(id), logRoutineExecution(log). All return `FutureResult<T>`.
- [ ] T022 [P] Create `flutter/lib/domain/repositories/i_task_repository.dart` — ITaskRepository: getTasks(filters), getTaskById(id), createTask(entity), updateTask(entity), completeTask(id), uncompleteTask(id), archiveTask(id), getTasksDueOn(date). All return `FutureResult<T>`.
- [ ] T023 [P] Create `flutter/lib/domain/repositories/i_inbox_repository.dart` — IInboxRepository: getInboxItems(status?), createItem(rawText), processAsTask(itemId, taskEntity), processAsHabit(itemId, habitEntity), discardItem(itemId), getPendingCount(). All return `FutureResult<T>`.
- [x] T023b [P] Create `flutter/lib/domain/repositories/i_notification_repository.dart` — INotificationRepository: getNotifications(), markAsRead(id), deleteNotification(id), getUnreadCount(). All return `FutureResult<T>`.

### Data Layer — Models

- [x] T024 [P] Create `flutter/lib/data/models/domain_model.dart` — @JsonSerializable DomainModel: mirrors domains table. Methods: toEntity(), fromEntity(), fromJson(), toJson(), toInsertJson(), toUpdateJson().
- [x] T025 [P] Create `flutter/lib/data/models/habit_model.dart` — @JsonSerializable HabitModel: mirrors habits table with enhanced fields (estimated_duration_minutes, frequency_days, notifications_enabled, reminder_offset_minutes). Methods: toEntity(), fromEntity(), fromJson(), toJson(), toInsertJson(), toUpdateJson().
- [x] T026 [P] Create `flutter/lib/data/models/habit_log_model.dart` — @JsonSerializable HabitLogModel: mirrors habit_logs table with enhanced fields (actual_start_time, actual_end_time). Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T027 [P] Create `flutter/lib/data/models/routine_model.dart` — @JsonSerializable RoutineModel: mirrors routines table. Methods: toEntity(steps), fromEntity(), fromJson(), toJson().
- [ ] T028 [P] Create `flutter/lib/data/models/routine_step_model.dart` — @JsonSerializable RoutineStepModel: mirrors routine_steps table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T029 [P] Create `flutter/lib/data/models/routine_log_model.dart` — @JsonSerializable RoutineLogModel: mirrors routine_logs table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T030 [P] Create `flutter/lib/data/models/task_model.dart` — @JsonSerializable TaskModel: mirrors tasks table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [ ] T031 [P] Create `flutter/lib/data/models/inbox_item_model.dart` — @JsonSerializable InboxItemModel: mirrors inbox_items table. Methods: toEntity(), fromEntity(), fromJson(), toJson().
- [x] T031b [P] Create `flutter/lib/data/models/notification_model.dart` — @JsonSerializable NotificationModel: mirrors notifications table. Methods: toEntity(), fromEntity(), fromJson(), toJson().

### Data Layer — Repository Implementations

- [x] T032 [P] Create `flutter/lib/data/repositories/domain_repository_impl.dart` — DomainRepositoryImpl implements IDomainRepository. Uses `SupabaseService.client.from('domains')`. Each method wraps in try/catch → Left(Failure) via ErrorHandler.
- [x] T033 [P] Create `flutter/lib/data/repositories/habit_repository_impl.dart` — HabitRepositoryImpl implements IHabitRepository. Uses `from('habits')` and `from('habit_logs')`. Streak calculated via ordered query. UPSERT for logs (unique constraint: habitId × logDate).
- [ ] T034 [P] Create `flutter/lib/data/repositories/routine_repository_impl.dart` — RoutineRepositoryImpl implements IRoutineRepository. Uses `from('routines')`, `from('routine_steps')`, `from('routine_logs')`.
- [ ] T035 [P] Create `flutter/lib/data/repositories/task_repository_impl.dart` — TaskRepositoryImpl implements ITaskRepository. Uses `from('tasks')`.
- [ ] T036 [P] Create `flutter/lib/data/repositories/inbox_repository_impl.dart` — InboxRepositoryImpl implements IInboxRepository. Uses `from('inbox_items')`. processAsTask creates task + updates inbox_item in transaction.
- [x] T036b [P] Create `flutter/lib/data/repositories/notification_repository_impl.dart` — NotificationRepositoryImpl implements INotificationRepository. Uses `from('notifications')`.

### Domain Services

- [x] T036c Create `flutter/lib/services/time_counter_service.dart` — Pure calculation service: `getWeeklyCounters()` returns TimeCounter per domain from habit logs, `getDailyTotal()` for single day. No Supabase dependency.
- [x] T036d Create `flutter/lib/services/bilan_service.dart` — Pure calculation service: `generateBilan()` returns WeeklyBilan from raw data (habits + logs + domains). Computes completion rate, top habit, longest streak.
- [x] T036e Create `flutter/lib/services/habit_event_service.dart` — Lightweight event bus: `notifyHabitChanged()` triggers VM reloads across TodayViewModel, HabitsViewModel, CounterViewModel.
- [x] T036f Create `flutter/lib/services/habit_toggle_service.dart` — Shared toggle logic: `toggleHabit()` (check/uncheck + analytics + haptics), `logHabitValue()` (quantitative input), `editHabitTime()` (actual start/end time recording).

### DI Registration

- [x] T037 Register repositories + services in `flutter/lib/app/app.dart` — DomainRepositoryImpl→IDomainRepository, HabitRepositoryImpl→IHabitRepository, NotificationRepositoryImpl→INotificationRepository + TimeCounterService, BilanService, HabitEventService, HabitToggleService. **Remaining**: RoutineRepositoryImpl, TaskRepositoryImpl, InboxRepositoryImpl (after those are implemented).
- [x] T038 Run `dart run build_runner build --delete-conflicting-outputs` — app.locator.dart, app.router.dart regenerated with current 19 routes, 30+ dependencies.

**Checkpoint**: Foundation partially ready — all migrations pass, habits/domains entities + models + repos compile and registered. **BLOCKING**: Routine/Task/Inbox entities, models, repos, and DI still needed before Phase 4, 5, 7.

---

## Phase 3: User Story 1 — Create and Track Daily Habits (Priority: P1) 🎯 MVP ✅ COMPLETE

**Goal**: User can create binary/quantitative habits with time ranges, check them daily, and see streaks.

**Independent Test**: Create a habit, see it in the list, check it today, verify streak = 1.

### Implementation for User Story 1

- [x] T039 [US1] Create `flutter/lib/features/habits/viewmodels/habits_viewmodel.dart` — HabitsViewModel: loads habits list, filters by domain/archived/search, groups by time slot. Uses locator<IHabitRepository>(), locator<IDomainRepository>(). Listens to HabitEventService for cross-screen reactivity.
- [x] T040 [US1] Create `flutter/lib/features/habits/views/habits_view.dart` — HabitsView (StackedView<HabitsViewModel>): AppBar with domain filter toggle + search, list of habits using HabitCheckTile, FAB to create, empty state via AppEmptyState.
- [x] T041 [US1] Create `flutter/lib/features/habits/viewmodels/habit_form_viewmodel.dart` — HabitFormViewModel: create/edit mode, form validation, domain picker trigger, save via repository.
- [x] T042 [US1] Create `flutter/lib/features/habits/views/habit_form_view.dart` — HabitFormView: AppTextField for name/description, type selector, target/unit for quantitative, time range pickers, frequency selector, notification settings, domain picker.
- [x] T043 [P] [US1] Create `flutter/lib/features/habits/widgets/habit_check_tile.dart` — HabitCheckTile widget: SwipeToAction to check/uncheck, shows habit name, domain color, time range, streak badge. Progress bar for quantitative habits.
- [x] T044 [P] [US1] Create `flutter/lib/features/habits/widgets/habit_streak_badge.dart` — HabitStreakBadge widget: displays current streak with fire emoji, uses AppBadge.
- [x] T045 [US1] Register habits routes in `flutter/lib/app/app.dart` — MaterialRoute for HabitsView, HabitFormView.
- [x] T046 [US1] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 1 — habits CRUD + check + streak fully functional. ✅

---

## Phase 4: User Story 2 — Launch and Complete a Routine (Priority: P1) 🎯 MVP

**Goal**: User can create routines with ordered steps, launch a step-by-step timer, and log completion.

**Independent Test**: Create a routine with 3 steps, launch it, complete all steps, verify log exists.

**Prerequisites**: T014, T015, T016 (entities) + T027, T028, T029 (models) + T034 (repo) must be completed first.

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

**Prerequisites**: T018 (inbox entity) + T031 (inbox model) + T036 (inbox repo) must be completed first. Task triage also requires T017 + T030 + T035 (task entity/model/repo).

### Implementation for User Story 3

- [ ] T057 [US3] Create `flutter/lib/features/inbox/viewmodels/inbox_viewmodel.dart` — InboxViewModel: loads pending items, capture new item, triage actions (→ task, → habit, → discard), pending count.
- [ ] T058 [US3] Create `flutter/lib/features/inbox/views/inbox_view.dart` — InboxView: capture field at top (AppTextField with send icon), list of pending items below, swipe or tap to triage, empty state.
- [ ] T059 [P] [US3] Create `flutter/lib/features/inbox/widgets/inbox_capture_field.dart` — InboxCaptureField: focused AppTextField with submit on enter, auto-clear, minimal UI for speed.
- [ ] T060 [P] [US3] Create `flutter/lib/features/inbox/widgets/inbox_triage_sheet.dart` — InboxTriageSheet (bottom sheet): shows item text, 3 actions (Create Task → opens task form pre-filled, Create Habit → opens habit form pre-filled, Discard).
- [ ] T061 [US3] Register inbox route in `flutter/lib/app/app.dart` — add MaterialRoute for InboxView
- [ ] T062 [US3] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 3 — inbox capture + triage fully functional.

---

## Phase 6: User Story 4 — Manage Life Domains (Priority: P2) ✅ COMPLETE

**Goal**: User can customize domains (add/rename/reorder/archive) and select them during onboarding.

**Independent Test**: Reorder domains, add a new one, verify it appears in the domain picker.

### Implementation for User Story 4

- [x] T063 [US4] Create `flutter/lib/features/domains/viewmodels/domains_viewmodel.dart` — DomainsViewModel: loads domains (active + archived), habit count per domain, reorder, add, edit, archive/unarchive.
- [x] T064 [US4] Create `flutter/lib/features/domains/views/domains_view.dart` — DomainsView: list of active domains with habit counts, create new domain button, toggle to show archived, archive/unarchive buttons (cannot archive last domain).
- [x] T065 [P] [US4] Create `flutter/lib/features/domains/widgets/domain_tile.dart` — DomainTile: icon, name, color indicator, habit count, edit/archive actions.
- [x] T066 [P] [US4] Create `flutter/lib/features/domains/widgets/domain_picker_sheet.dart` — DomainPickerSheet (bottom sheet): list of active domains for selection, returns selected DomainEntity. Used by habit/task/routine forms.
- [x] T067 [US4] Register domains route in `flutter/lib/app/app.dart` — MaterialRoute for DomainsView.
- [x] T068 [US4] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: User Story 4 — domains CRUD + picker fully functional. ✅

---

## Phase 7: User Story 5 — Manage Simple Tasks (Priority: P2)

**Goal**: User can create tasks with priority/date/domain, mark them done, filter by domain.

**Independent Test**: Create a task due today, see it in the list, mark done, verify it moves to completed.

**Prerequisites**: T017 (task entity) + T030 (task model) + T035 (task repo) must be completed first.

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

## Phase 8: User Story 6 — Today View + Counter + Bilan (Priority: P2) — PARTIALLY COMPLETE

**Goal**: User opens app and sees their entire day: habits by time range, active routine, tasks due today, inbox count. Plus weekly time tracking (Counter) and weekly summary (Bilan).

**Independent Test**: With 2 habits, 1 routine, 3 tasks today, 2 inbox items — verify Today view shows all.

### Today View (partially implemented — habits section done, routines/tasks/inbox pending)

- [x] T076 [US6] Create `flutter/lib/features/today/viewmodels/today_viewmodel.dart` — TodayViewModel: loads today's habits + logs + streaks, groups by TimeSlot, tracks completedHabits/remainingHabits/completionRate, calculates today's minutes per domain. Listens to HabitEventService. **Currently**: habits-only. **TODO**: add routines, tasks due today, inbox pending count integration.
- [x] T077 [US6] Create `flutter/lib/features/today/views/today_view.dart` — TodayView: contextual UI by TodayMode (morning 5h-12h: greeting + habits + mini counter; progress 12h-18h: completed/remaining + progress bar; bilan 18h-5h: day summary + time recap). Celebration overlay on 100%. Notification badge.
- [x] T078 [P] [US6] Create `flutter/lib/features/today/widgets/today_habits_section.dart` — TodayHabitsSection: habits grouped by time slot, swipe-to-toggle via HabitCheckTile.
- [ ] T079 [P] [US6] Create `flutter/lib/features/today/widgets/today_routine_card.dart` — TodayRoutineCard: shows next/active routine with launch button, duration, step count. **Blocked by**: Phase 4 (Routines).
- [ ] T080 [P] [US6] Create `flutter/lib/features/today/widgets/today_tasks_section.dart` — TodayTasksSection: lists tasks due today + overdue, each as TaskTile with checkbox. **Blocked by**: Phase 7 (Tasks).
- [ ] T081 [P] [US6] Create `flutter/lib/features/today/widgets/today_inbox_badge.dart` — TodayInboxBadge: inbox icon with count badge, tappable to navigate to inbox. **Blocked by**: Phase 5 (Inbox).
- [x] T081b [P] [US6] Create `flutter/lib/features/today/widgets/today_counter_summary.dart` — Mini weekly time counter + domain bars widget, shown in TodayView.
- [x] T081c [P] [US6] Create `flutter/lib/features/today/widgets/today_bilan_card.dart` — Trigger card for full weekly bilan (shown Sunday evening/Monday morning).
- [x] T081d [P] [US6] Create `flutter/lib/features/today/widgets/habit_value_sheet.dart` — Bottom sheet for quantitative habit value input.
- [x] T081e [P] [US6] Create `flutter/lib/features/today/widgets/habit_time_edit_sheet.dart` — Bottom sheet to edit actual start/end time for time adherence.

### Counter Feature (fully implemented)

- [x] T082 [US6] Create `flutter/lib/features/counter/viewmodels/counter_viewmodel.dart` — CounterViewModel: loads all habits + logs (current week + last week), calculates TimeCounter per domain via TimeCounterService, tracks weekStart, allows prev/next/current week navigation.
- [x] T082b [US6] Create `flutter/lib/features/counter/views/counter_view.dart` — CounterView: weekly total (hours formatted), delta vs last week, domain bars with expandable detail (habit breakdown), week navigator, bilan card link.
- [x] T082c [P] [US6] Create `flutter/lib/features/counter/widgets/domain_time_bar.dart` — Animated bar showing minutes per domain, expandable to show habit breakdown.

### Bilan Feature (fully implemented)

- [x] T082d [US6] Create `flutter/lib/features/bilan/viewmodels/bilan_viewmodel.dart` — BilanViewModel: loads week data + generates WeeklyBilan via BilanService, week navigation, share functionality (capture widget as PNG).
- [x] T082e [US6] Create `flutter/lib/features/bilan/views/bilan_view.dart` — BilanView: weekly summary card (total hours, completion %, week-over-week delta, top habit, longest streak), domain time breakdown, share button.
- [x] T082f [P] [US6] Create `flutter/lib/features/bilan/widgets/bilan_domain_chart.dart` — Domain time distribution chart.
- [x] T082g [P] [US6] Create `flutter/lib/features/bilan/widgets/bilan_highlights.dart` — Key stats display (completion rate, top habit, streak).
- [x] T082h [P] [US6] Create `flutter/lib/features/bilan/widgets/bilan_share_widget.dart` — RepaintBoundary for shareable image capture.

### HomeView + Navigation

- [x] T083 [US6] Create `flutter/lib/ui/views/home/home_view.dart` — HomeView with 3-tab bottom navigation: Today, Habits, Counter. Uses IndexedStack. HomeViewModel tracks current tab.
- [x] T083b [US6] Run `dart run build_runner build --delete-conflicting-outputs`

**Checkpoint**: US6 partially done — **habits + counter + bilan = complete. Missing: routine card, tasks section, inbox badge in Today View (blocked by Phases 4, 5, 7).** Bottom nav has 3 tabs; needs 5 after all features are built.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Integration, navigation, final validation.

- [ ] T084 Update bottom navigation in HomeView — expand from 3 tabs (Today, Habits, Counter) to 5 tabs (Today, Habits, Routines, Tasks, Counter). Inbox accessible via FAB or badge in Today View. Uses AppBottomNav from design system.
- [ ] T085 Update onboarding flow — add domain selection step (step 2) using domain picker with pre-selected defaults.
- [ ] T086 Update SplashView/StartupView — verify initial route flow is correct (splash → auth → onboarding/home), not designShowcaseView.
- [ ] T087 Final `supabase db reset` validation — confirm all migrations + seed pass.
- [ ] T088 Run `dart format .` + `dart analyze` — zero errors, zero warnings.
- [ ] T089 Run `flutter run -d chrome` — verify app launches and all features are accessible.
- [ ] T090 Integrate TodayViewModel with routines, tasks, inbox repos — update TodayViewModel to load routines (active), tasks due today, inbox pending count. Wire T079, T080, T081.

---

## Progress Summary

| Phase | Total | Done | Remaining | Status |
|-------|-------|------|-----------|--------|
| Phase 1 (Setup) | 3 | 1 | 2 (i18n) | 🟡 Partial |
| Phase 2 (Foundation) | 48 | 37 | 11 (routine/task/inbox entity+model+repo) | 🟡 Partial |
| Phase 3 (US1 Habits) | 8 | 8 | 0 | ✅ Complete |
| Phase 4 (US2 Routines) | 10 | 0 | 10 | ❌ Not started |
| Phase 5 (US3 Inbox) | 6 | 0 | 6 | ❌ Not started |
| Phase 6 (US4 Domains) | 6 | 6 | 0 | ✅ Complete |
| Phase 7 (US5 Tasks) | 7 | 0 | 7 | ❌ Not started |
| Phase 8 (US6 Today+Counter+Bilan) | 22 | 18 | 4 (blocked by Phases 4,5,7) | 🟡 Partial |
| Phase 9 (Polish) | 7 | 0 | 7 | ❌ Not started |
| **TOTAL** | **117** | **70** | **47** | **60% complete** |

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — **BLOCKS feature work**
  - Habits/Domains foundation: ✅ COMPLETE
  - Routines foundation (T014-T016, T027-T029, T034): BLOCKS Phase 4
  - Tasks foundation (T017, T030, T035): BLOCKS Phase 5 (inbox triage to task) and Phase 7
  - Inbox foundation (T018, T031, T036): BLOCKS Phase 5
- **User Stories (Phases 3-8)**: Depend on their respective foundational tasks
  - US1 (Habits): ✅ COMPLETE
  - US4 (Domains): ✅ COMPLETE
  - US2 (Routines): Needs foundation first
  - US5 (Tasks): Needs foundation first
  - US3 (Inbox): Needs foundation + tasks foundation
  - US6 (Today): Habits part done; routine/task/inbox integration blocked
- **Polish (Phase 9)**: Depends on all user stories being complete

### Recommended Next Steps (Priority Order)

1. **T002-T003**: Complete i18n keys (unblocks proper UI text in all features)
2. **T014-T016, T027-T029, T034**: Routine entities + models + repo (unblocks Phase 4)
3. **T017, T030, T035**: Task entity + model + repo (unblocks Phase 7 and Phase 5 triage)
4. **T018, T031, T036**: Inbox entity + model + repo (unblocks Phase 5)
5. **Phase 4 (T047-T056)**: Implement routines feature
6. **Phase 7 (T069-T075)**: Implement tasks feature
7. **Phase 5 (T057-T062)**: Implement inbox feature
8. **T079-T081, T090**: Wire remaining Today View sections
9. **Phase 9 (T084-T089)**: Final polish and validation

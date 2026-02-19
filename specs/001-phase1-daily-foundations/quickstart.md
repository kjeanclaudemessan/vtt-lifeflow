# Quickstart: Phase 1 — Daily Foundations

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19
**Purpose**: Integration scenarios to validate end-to-end flows after implementation.

## Prerequisites

1. Supabase running locally (`supabase start`)
2. `supabase db reset` passes with zero errors
3. Flutter app compiles (`dart analyze` = 0 errors)
4. Authenticated user session exists

## Scenario 1: Habit Creation → Today View → Check

**Tests**: US1 (Habits) + US6 (Today View)

```text
1. Open app → navigate to Habits tab
2. Tap FAB (+) → HabitFormView opens
3. Fill form:
   - Name: "Méditer"
   - Type: Binary
   - Domain: Santé (from picker)
   - Start time: 06:00
   - End time: 08:00
   - Frequency: Daily
4. Save → redirects to HabitsView, new habit visible
5. Navigate to Today tab
6. Verify "Méditer" appears in Morning section (06:00-08:00)
7. Tap checkbox → habit checked, streak badge shows "🔥 1"
8. Navigate away and back → habit still checked, streak persists
```

**Expected DB state**:
- `habits` table: 1 row with `type = 'binary'`, `domain_id` pointing to "Santé"
- `habit_logs` table: 1 row with `log_date = today`, `completed = true`

## Scenario 2: Quantitative Habit

**Tests**: US1 (Habits — quantitative variant)

```text
1. Create habit:
   - Name: "Boire de l'eau"
   - Type: Quantitative
   - Target: 2000
   - Unit: ml
   - Domain: Santé
2. On Today view, tap the habit
3. Enter value: 1500
4. Verify progress shows 75%
5. Enter value: 2000
6. Verify progress shows 100%, habit marked as complete
```

## Scenario 3: Routine Runner

**Tests**: US2 (Routines)

```text
1. Create routine "Matin" with 3 steps:
   - Réveil (5 min / 300s)
   - Douche (10 min / 600s)
   - Méditer (15 min / 900s)
2. Verify routine shows "30 min" total estimated duration
3. Tap "Lancer" → RoutineRunnerView opens
4. Step 1: "Réveil" with countdown timer from 5:00
5. Tap "Suivant" → Step 2: "Douche" with timer from 10:00
6. Tap "Suivant" → Step 3: "Méditer" with timer from 15:00
7. Tap "Terminer" → routine complete
8. Verify routine_log created with status = 'completed', steps_completed = 3
```

## Scenario 4: Routine Abandon

**Tests**: US2 (Routines — abandon flow)

```text
1. Launch routine "Matin" (3 steps)
2. Complete step 1
3. On step 2, tap "Abandonner"
4. Confirm dialog appears
5. Confirm → routine_log created with status = 'abandoned', steps_completed = 1
```

## Scenario 5: Inbox Capture → Triage → Task

**Tests**: US3 (Inbox) + US5 (Tasks)

```text
1. Open Inbox tab
2. Type "Appeler dentiste" in capture field → Submit
3. Type "Acheter du lait" → Submit
4. Type "Vieille idée" → Submit
5. Verify 3 pending items in list
6. Tap "Appeler dentiste" → InboxTriageSheet opens
7. Select "Créer une tâche"
8. TaskFormView opens pre-filled with "Appeler dentiste"
9. Set domain: Santé, priority: High, due date: today
10. Save → task created
11. Verify inbox item status = 'processed', linked_task_id set
12. Back to inbox → tap "Vieille idée" → "Supprimer"
13. Verify inbox item status = 'discarded'
14. Inbox shows only "Acheter du lait" (1 pending)
```

## Scenario 6: Domain Management

**Tests**: US4 (Domains)

```text
1. Open Settings → Domains
2. Verify 5 default domains: Santé, Travail, Relations, Finances, Développement personnel
3. Drag "Relations" above "Travail" → sort_order updated
4. Tap FAB → add domain "Spiritualité" with 🧘 icon, purple color
5. Open habit form → domain picker shows 6 domains including "Spiritualité"
6. Archive "Finances" → domain hidden from picker
7. Open habit form → domain picker shows 5 domains (no "Finances")
8. Existing habits linked to "Finances" still display the domain name
```

## Scenario 7: Today View Assembly

**Tests**: US6 (Today View — full integration)

```text
Prerequisites:
- 2 habits: "Méditer" (06:00-08:00), "Lire" (20:00-22:00)
- 1 routine: "Matin" (3 steps)
- 3 tasks: 1 due today, 1 overdue, 1 due tomorrow
- 2 pending inbox items

Steps:
1. Open Today tab
2. Verify Morning section shows "Méditer" with checkbox
3. Verify Evening section shows "Lire" with checkbox
4. Verify Routine section shows "Matin" with "Lancer" button and "30 min"
5. Verify Tasks section shows 2 tasks (today + overdue in red), NOT the tomorrow task
6. Verify Inbox badge shows "2"
7. Check "Méditer" → streak badge appears
8. Tap inbox badge → navigates to InboxView
```

## Scenario 8: Bottom Navigation

**Tests**: US6 (Polish — navigation)

```text
1. App opens on Today tab (default)
2. Bottom nav shows 5 tabs: Today, Habits, Routines, Tasks, Inbox
3. Tap each tab → correct view loads
4. Inbox tab shows badge with pending count
5. Navigate between tabs → state preserved (checked habits stay checked)
```

## Error Scenarios

| Scenario | Expected Behavior |
|----------|-------------------|
| Create habit with empty name | Validation error, form not submitted |
| Create quantitative habit without target | Validation error on target field |
| Network lost during habit check | `NetworkFailure` displayed, checkbox reverts |
| Launch routine while one is active | Confirm dialog: "Abandon current routine?" |
| Capture inbox item with empty text | Submit button disabled |
| Backdate habit > 7 days | Action blocked, snackbar explains limit |

## Testing Strategy (NON-NEGOTIABLE)

### Principle

All integration tests use **REAL ViewModels** connected to the **REAL local Supabase DB**.
No mocked repositories, no fake data layers. The test chain is:

```
Test → REAL ViewModel → REAL Repository → REAL SupabaseService → REAL local Supabase (port 54421)
```

### Why

- Mocking hides real bugs (serialization errors, RLS denials, constraint violations)
- If the ViewModel works against the real DB in tests, it works in production
- Tests become the **executable acceptance criteria** from `spec.md`
- When a test fails, the **code is fixed** — tests are the source of truth

### Structure

| File | User Story | What it validates |
|------|-----------|------------------|
| `us1_habits_integration_test.dart` | US1 | Create habit, check, streak, quantitative progress |
| `us2_routines_integration_test.dart` | US2 | Create routine, runner flow, abandon, logs |
| `us3_inbox_integration_test.dart` | US3 | Capture, triage to task/habit, discard |
| `us4_domains_integration_test.dart` | US4 | CRUD, reorder, archive, picker filtering |
| `us5_tasks_integration_test.dart` | US5 | Create, complete, filter, overdue detection |
| `us6_today_integration_test.dart` | US6 | Aggregation, time grouping, badge counts |

### Existing infrastructure

- `supabase_test_config.dart` — URL + keys for local Supabase (port 54421)
- `supabase_test_helper.dart` — Admin client, user CRUD, cleanup
- `viewmodel_test_helper.dart` — GetIt bootstrap with REAL services, TestNavigationService, TestDialogService

### Rules

1. Each test file maps 1:1 to a user story
2. Each acceptance scenario from `spec.md` becomes a `test()` block
3. Tests create a fresh user via admin API at `setUp`, delete at `tearDown`
4. Tests assert BOTH ViewModel state (`.isBusy`, `.hasError`, computed props) AND DB state (Supabase queries)
5. Tests run with: `dart test test/integration/us*_integration_test.dart`
6. `supabase start` must be running — tests are NOT offline-capable

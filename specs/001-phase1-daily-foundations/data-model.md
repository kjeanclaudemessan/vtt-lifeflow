# Data Model: Phase 1 — Daily Foundations

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19
**Input**: spec.md (Key Entities), Supabase migrations

## Entity Relationship Diagram (Textual)

```
auth.users (Supabase managed)
  │
  ├── 1:N ──► profiles        (existing — 20260122000000)
  ├── 1:N ──► domains          ◄── categorizes ──► habits, routines, tasks
  ├── 1:N ──► habits           ──► 1:N ──► habit_logs
  ├── 1:N ──► routines         ──► 1:N ──► routine_steps
  │                             ──► 1:N ──► routine_logs
  ├── 1:N ──► tasks
  └── 1:N ──► inbox_items      ──► 0..1 ──► tasks (linked_task_id)
                                ──► 0..1 ──► habits (linked_habit_id)
```

## Entities

### Domain

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| name | TEXT | NO | — | — |
| icon | TEXT | NO | `'🎯'` | Emoji string |
| color | TEXT | NO | `'#6200EE'` | Hex color string |
| sort_order | INTEGER | NO | `0` | For drag-and-drop reorder |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete — archived domains hidden from pickers |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.domains`
**Migration**: `20260220000001_create_domains.sql`
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id, sort_order) WHERE NOT is_archived`

**Business rules**:
- Domains are never hard-deleted, only archived (`is_archived = true`)
- Archived domains remain linked to existing habits/routines/tasks
- 5 defaults seeded: Santé, Travail, Relations, Finances, Développement personnel

**Flutter entity computed properties**:
- `isDefault` — name matches one of the 5 default domain names

---

### Habit

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| domain_id | UUID | YES | — | FK → domains, ON DELETE SET NULL |
| name | TEXT | NO | — | — |
| description | TEXT | YES | — | — |
| type | TEXT | NO | `'binary'` | CHECK IN ('binary', 'quantitative') |
| target_value | NUMERIC | YES | — | Required when type = 'quantitative' |
| unit | TEXT | YES | — | e.g. 'ml', 'min', 'pages' |
| start_time | TIME | YES | — | Start of time window |
| end_time | TIME | YES | — | End of time window |
| frequency | TEXT | NO | `'daily'` | CHECK IN ('daily', 'weekly', 'custom') |
| frequency_days | INTEGER[] | YES | `'{}'` | Days of week (0=Sun, 6=Sat) for weekly/custom |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.habits`
**Migration**: `20260220000002_create_habits.sql`
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id) WHERE NOT is_archived`, `(domain_id) WHERE NOT NULL`

**Business rules**:
- If `type = 'quantitative'`, `target_value` and `unit` should be set
- `start_time`/`end_time` define the daily time window (used for Today view grouping)
- Habits without time range are grouped under "Anytime"

**Flutter entity computed properties**:
- `isQuantitative` — `type == HabitType.quantitative`
- `timeRangeLabel` — formatted string from `startTime`/`endTime`

---

### HabitLog

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| habit_id | UUID | NO | — | FK → habits, ON DELETE CASCADE |
| log_date | DATE | NO | — | — |
| completed | BOOLEAN | NO | `FALSE` | — |
| value | NUMERIC | YES | — | For quantitative habits |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |

**Supabase table**: `public.habit_logs`
**Migration**: `20260220000002_create_habits.sql` (same file)
**RLS**: Via habit ownership — `EXISTS (SELECT 1 FROM habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid())`
**Unique constraint**: `(habit_id, log_date)` — one log per habit per day
**Indexes**: `(habit_id)`, `(log_date)`, `(habit_id, log_date)`

**Business rules**:
- Maximum one log per habit per day (UNIQUE constraint)
- Backdating allowed up to 7 days in the past (enforced client-side)
- For binary habits: `completed = true/false`, `value` is null
- For quantitative habits: `value` holds the tracked amount, `completed` is derived (`value >= target_value`)

**Flutter entity computed properties**:
- `completionPercentage` — for quantitative: `value / target * 100`

---

### Routine

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| domain_id | UUID | YES | — | FK → domains, ON DELETE SET NULL |
| name | TEXT | NO | — | — |
| description | TEXT | YES | — | — |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.routines`
**Migration**: `20260220000003_create_routines.sql`
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id) WHERE NOT is_archived`, `(domain_id) WHERE NOT NULL`

**Flutter entity computed properties**:
- `totalEstimatedDuration` — sum of all steps' `estimatedDuration`
- `stepCount` — `steps.length`

---

### RoutineStep

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| routine_id | UUID | NO | — | FK → routines, ON DELETE CASCADE |
| name | TEXT | NO | — | — |
| description | TEXT | YES | — | — |
| estimated_duration | INTEGER | NO | `300` | In seconds (default = 5 minutes) |
| sort_order | INTEGER | NO | `0` | Position in routine sequence |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |

**Supabase table**: `public.routine_steps`
**Migration**: `20260220000003_create_routines.sql` (same file)
**RLS**: Via routine ownership — `EXISTS (SELECT 1 FROM routines WHERE routines.id = routine_steps.routine_id AND routines.user_id = auth.uid())`
**Indexes**: `(routine_id, sort_order)`

**Business rules**:
- Steps are ordered by `sort_order` (drag-and-drop reorder)
- `estimated_duration` is in seconds (Flutter converts to `Duration`)

---

### RoutineLog

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| routine_id | UUID | NO | — | FK → routines, ON DELETE CASCADE |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| started_at | TIMESTAMPTZ | NO | `NOW()` | When the runner was launched |
| completed_at | TIMESTAMPTZ | YES | — | When the runner finished (null if abandoned mid-way) |
| total_duration | INTEGER | YES | — | In seconds |
| status | TEXT | NO | `'completed'` | CHECK IN ('completed', 'abandoned') |
| steps_completed | INTEGER | NO | `0` | How many steps were completed |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |

**Supabase table**: `public.routine_logs`
**Migration**: `20260220000003_create_routines.sql` (same file)
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(routine_id)`, `(user_id)`

**Business rules**:
- Only ONE active routine at a time (enforced client-side)
- `status = 'abandoned'` when user quits before completing all steps
- `total_duration` is actual elapsed time, not estimated

---

### Task

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| domain_id | UUID | YES | — | FK → domains, ON DELETE SET NULL |
| title | TEXT | NO | — | — |
| description | TEXT | YES | — | — |
| priority | TEXT | NO | `'medium'` | CHECK IN ('low', 'medium', 'high') |
| due_date | DATE | YES | — | — |
| completed_at | TIMESTAMPTZ | YES | — | Set when task is marked done |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.tasks`
**Migration**: `20260220000004_create_tasks.sql`
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id) WHERE NOT archived AND NOT completed`, `(domain_id) WHERE NOT NULL`, `(due_date) WHERE NOT NULL AND NOT completed`

**Flutter entity computed properties**:
- `isCompleted` — `completedAt != null`
- `isOverdue` — `dueDate != null && dueDate.isBefore(today) && !isCompleted`
- `isDueToday` — `dueDate != null && dueDate == today`

---

### InboxItem

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| raw_text | TEXT | NO | — | The captured thought |
| status | TEXT | NO | `'pending'` | CHECK IN ('pending', 'processed', 'discarded') |
| processed_as | TEXT | YES | — | CHECK IN ('task', 'habit', NULL) |
| linked_task_id | UUID | YES | — | FK → tasks, ON DELETE SET NULL |
| linked_habit_id | UUID | YES | — | FK → habits, ON DELETE SET NULL |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.inbox_items`
**Migration**: `20260220000005_create_inbox_items.sql`
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id) WHERE status = 'pending'`

**Business rules**:
- When triaged as task: create task → set `processed_as = 'task'`, `linked_task_id`, `status = 'processed'`
- When triaged as habit: create habit → set `processed_as = 'habit'`, `linked_habit_id`, `status = 'processed'`
- When discarded: set `status = 'discarded'`
- If the linked entity is deleted, FK is SET NULL but inbox item remains processed

**Flutter entity computed properties**:
- `isPending` — `status == InboxItemStatus.pending`
- `isProcessed` — `status == InboxItemStatus.processed`

---

## Validation Rules (Client-Side)

| Entity | Field | Rule |
|--------|-------|------|
| Habit | name | Required, min 1 char, max 100 chars |
| Habit | target_value | Required if type = quantitative, must be > 0 |
| Habit | unit | Required if type = quantitative, min 1 char |
| Routine | name | Required, min 1 char, max 100 chars |
| RoutineStep | name | Required, min 1 char, max 100 chars |
| RoutineStep | estimated_duration | Required, min 1 second |
| Task | title | Required, min 1 char, max 200 chars |
| InboxItem | raw_text | Required, min 1 char, max 500 chars |
| Domain | name | Required, min 1 char, max 50 chars |

## State Transitions

### InboxItem Lifecycle

```
[Created] ──► pending ──► processed (with linked entity)
                     └──► discarded
```

### RoutineLog Lifecycle

```
[Runner Started] ──► in-progress (local state) ──► completed (all steps done)
                                                └──► abandoned (user quit)
```

### Task Lifecycle

```
[Created] ──► active (completed_at = null) ──► completed (completed_at set)
                                           └──► archived (is_archived = true)
completed ──► active (uncomplete — clear completed_at)
```

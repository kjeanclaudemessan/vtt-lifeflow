# Data Model: Phase 1 — Le Cockpit Quotidien

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Revised**: 2026-02-19
**Input**: spec.md (Key Entities), Supabase migrations existantes
**Scope**: 2 tables actives (domains, habits + habit_logs). Les migrations P2 (routines, tasks, inbox_items) existent mais ne sont pas implémentées côté Flutter en P1.

## Entity Relationship Diagram

```
auth.users (Supabase managed)
  │
  ├── 1:N ──► profiles           (existing — 20260122000000)
  │
  ├── 1:N ──► domains            (P1 — catégorise les habitudes)
  │             │
  │             └── 1:N ──► habits      (P1 — comportements à tracker)
  │                           │
  │                           └── 1:N ──► habit_logs  (P1 — logs quotidiens)
  │
  ├── 1:N ──► routines           (P2 — migration existe, pas d'UI Flutter)
  ├── 1:N ──► tasks              (P2 — migration existe, pas d'UI Flutter)
  └── 1:N ──► inbox_items        (P2 — migration existe, pas d'UI Flutter)
```

**Seules les 3 entités P1 (Domain, Habit, HabitLog) ont des entities/models/repos Flutter.**
Les 4 autres tables existent en SQL pour faciliter la transition P2, mais sont ignorées côté app.

---

## Entities

### Domain

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| user_id | UUID | NO | — | FK → auth.users, ON DELETE CASCADE |
| name | TEXT | NO | — | — |
| icon | TEXT | NO | `'🎯'` | Emoji string |
| color | TEXT | NO | `'#6200EE'` | Hex color string |
| sort_order | INTEGER | NO | `0` | Pour drag-and-drop |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete — archivé = caché des pickers |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.domains`
**Migration**: `20260220000001_create_domains.sql` (existante, inchangée)
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id, sort_order) WHERE NOT is_archived`
**Seeds**: `seeds/001_default_domains.sql` — 5 domaines (Santé, Travail, Relations, Finances, Dev perso)

**Business rules**:
- Jamais de hard delete, uniquement archivage (`is_archived = true`)
- Les habitudes gardent le lien vers un domaine archivé
- Minimum 1 domaine actif (enforced côté Flutter)

**Flutter entity computed properties**:
- `isDefault` → name matches one of the 5 default names
- `displayColor` → `Color` parsée depuis hex string

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
| unit | TEXT | YES | — | ex: 'ml', 'min', 'pages' |
| **estimated_duration_minutes** | **INTEGER** | **NO** | **`15`** | **⚡ NOUVEAU — temps que l'habitude représente pour le compteur** |
| start_time | TIME | YES | — | Début de la plage horaire (grouping TodayView) |
| end_time | TIME | YES | — | Fin de la plage horaire |
| frequency | TEXT | NO | `'daily'` | CHECK IN ('daily', 'weekly', 'custom') |
| frequency_days | INTEGER[] | YES | `'{}'` | Jours de semaine (0=Sun, 6=Sat) |
| is_archived | BOOLEAN | NO | `FALSE` | Soft delete |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |
| updated_at | TIMESTAMPTZ | NO | `NOW()` | Auto-updated via trigger |

**Supabase table**: `public.habits`
**Migration**: `20260220000002_create_habits.sql` — **⚠️ À MODIFIER : ajouter `estimated_duration_minutes`** (tâche T004 dans tasks.md)
**RLS**: All CRUD scoped to `auth.uid() = user_id`
**Indexes**: `(user_id)`, `(user_id) WHERE NOT is_archived`, `(domain_id) WHERE NOT NULL`

**Business rules**:
- Si `type = 'quantitative'`, `target_value` et `unit` doivent être renseignés
- `start_time`/`end_time` = plage horaire "quand faire l'habitude" (pour grouping TodayView)
- `estimated_duration_minutes` = "combien de temps ça prend" (pour le compteur temps)
- Habits sans plage horaire → groupées dans "Sans horaire" dans le TodayView

**Flutter entity computed properties**:
- `isQuantitative` → `type == HabitType.quantitative`
- `timeRangeLabel` → formatted string from `startTime`/`endTime` (ex: "6h – 8h")
- `timeSlot` → `TimeSlot.morning` / `.afternoon` / `.evening` / `.anytime` (basé sur `startTime`)
- `effectiveDuration(logValue)` → si quantitative + unit='min' → `logValue`, sinon → `estimatedDurationMinutes`

---

### HabitLog

| Field | Type | Nullable | Default | Constraints |
|-------|------|----------|---------|-------------|
| id | UUID | NO | `gen_random_uuid()` | PK |
| habit_id | UUID | NO | — | FK → habits, ON DELETE CASCADE |
| log_date | DATE | NO | — | — |
| completed | BOOLEAN | NO | `FALSE` | — |
| value | NUMERIC | YES | — | Pour habitudes quantitatives |
| created_at | TIMESTAMPTZ | NO | `NOW()` | — |

**Supabase table**: `public.habit_logs`
**Migration**: `20260220000002_create_habits.sql` (même fichier que habits)
**RLS**: Via habit ownership — `EXISTS (SELECT 1 FROM habits WHERE habits.id = habit_logs.habit_id AND habits.user_id = auth.uid())`
**Indexes**: `(habit_id)`, `(log_date)`, `(habit_id, log_date)` UNIQUE

**Business rules**:
- Max 1 log par habitude par jour (UNIQUE constraint)
- Backdating autorisé jusqu'à 7 jours en arrière (enforced côté Flutter)
- Pour les habitudes binaires : `completed = true`, `value = NULL`
- Pour les habitudes quantitatives : `completed = (value >= target_value)`, `value = saisie`

**Flutter entity computed properties**:
- `completionPercentage(targetValue)` → `value / targetValue` pour quantitatives, 1.0 ou 0.0 pour binaires
- `contributedMinutes(habit)` → temps comptabilisé pour le compteur (voir D-006 dans research.md)

---

## Computed Entities (pas de table — calculées côté Flutter)

### TimeCounter

Pas de table Supabase. Calculé à partir de `habit_logs` × `habits`.

| Field | Type | Description |
|-------|------|-------------|
| domainId | UUID | Le domaine |
| domainName | String | Nom du domaine |
| domainColor | Color | Couleur du domaine |
| totalMinutesThisWeek | int | Minutes accumulées cette semaine |
| totalMinutesLastWeek | int | Minutes semaine dernière |
| deltaMinutes | int | Différence (this - last) |
| habitBreakdown | Map<HabitEntity, int> | Minutes par habitude (pour le détail) |

**Calcul** : voir `research.md` D-006.

### WeeklyBilan

Pas de table Supabase. Calculé à partir de `habit_logs` × `habits` × `domains`.

| Field | Type | Description |
|-------|------|-------------|
| weekStartDate | DateTime | Lundi de la semaine |
| domainTimes | List<TimeCounter> | Temps par domaine |
| totalMinutes | int | Total toutes domaines |
| completionRate | double | Habitudes complétées / total prévu (%) |
| topHabit | HabitEntity? | Habitude la plus régulière (meilleur taux) |
| longestStreak | StreakInfo? | Plus long streak actif |
| isFirstWeek | bool | Pas de semaine précédente = pas de delta |

**Calcul** : voir `research.md` D-007.

---

## Migrations Status

| Fichier | Table(s) | Statut | P1 Flutter? |
|---------|----------|--------|-------------|
| `20260122000000_create_profiles.sql` | profiles | ✅ Existant | Existant (template) |
| `20260123000005_create_payments.sql` | payments | ✅ Existant | Non (P2+) |
| `20260220000001_create_domains.sql` | domains | ✅ Existant | **OUI** |
| `20260220000002_create_habits.sql` | habits, habit_logs | ⚠️ **À modifier** (ajouter `estimated_duration_minutes`) | **OUI** |
| `20260220000003_create_routines.sql` | routines, routine_steps, routine_logs | ✅ Existant | Non (P2) |
| `20260220000004_create_tasks.sql` | tasks | ✅ Existant | Non (P2) |
| `20260220000005_create_inbox_items.sql` | inbox_items | ✅ Existant | Non (P2) |
| `seeds/001_default_domains.sql` | — | ✅ Existant | **OUI** |

**⚠️ Seule modification migration requise** : ajouter `estimated_duration_minutes INTEGER NOT NULL DEFAULT 15` dans `create_habits.sql`, entre `unit` et `start_time`.

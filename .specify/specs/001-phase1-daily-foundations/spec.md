# Feature Specification: Phase 1 — Fondations Quotidiennes

**Feature Branch**: `001-phase1-daily-foundations`
**Created**: 2026-02-19
**Status**: Draft
**Input**: User description: "MVP — L'utilisateur peut structurer sa journée complète (habitudes, routines, tâches), capturer des idées (inbox GTD), et tout voir sur un écran unique (Vue Aujourd'hui). Les domaines de vie servent de catégorisation transversale."

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
-->

### User Story 1 - Créer et suivre une habitude quotidienne (Priority: P1)

L'utilisateur crée une habitude (ex: "Méditer 10 min"), la rattache au domaine "Santé", définit une plage horaire (6h-8h), choisit le type binaire. Chaque jour, il la coche depuis la Vue Aujourd'hui. L'app calcule son streak localement.

**Why this priority**: C'est le coeur de LifeFlow. Sans habits, l'app n'a aucune valeur. L'habitude est le concept le plus simple et le plus utilisé quotidiennement.

**Independent Test**: Créer une habitude, la voir dans la liste, la cocher aujourd'hui, vérifier le streak à 1. Revenir le lendemain, cocher, streak à 2.

**Acceptance Scenarios**:

1. **Given** un utilisateur authentifié sans habitudes, **When** il crée une habitude binaire "Méditer" dans le domaine "Santé" avec plage 6h-8h, **Then** l'habitude apparaît dans sa liste et dans la Vue Aujourd'hui dans la section de la plage horaire correspondante.
2. **Given** une habitude non cochée aujourd'hui, **When** l'utilisateur la coche, **Then** un `habit_log` est créé avec la date du jour et `completed = true`, le streak passe à 1.
3. **Given** une habitude cochée aujourd'hui, **When** l'utilisateur la décoche, **Then** le `habit_log` est supprimé, le streak recalculé.
4. **Given** une habitude quantitative "Boire 2L d'eau" (target: 2000, unité: ml), **When** l'utilisateur entre 1500ml, **Then** la progression affiche 75% et le log enregistre `value = 1500`.

---

### User Story 2 - Lancer et compléter une routine (Priority: P1)

L'utilisateur crée une routine "Matin" avec 4 étapes ordonnées (Réveil → Douche → Méditer → Petit-déj), chacune avec une durée estimée. Il lance la routine, un timer pas-à-pas le guide. À la fin, un `routine_log` enregistre le temps total.

**Why this priority**: Les routines sont le second pilier — l'utilisateur structure sa journée en routines (matin, midi, soir). C'est ce qui différencie LifeFlow d'un simple habit tracker.

**Independent Test**: Créer une routine avec 3 étapes, la lancer, compléter chaque étape en suivant le timer, vérifier que le log final existe avec le temps total.

**Acceptance Scenarios**:

1. **Given** un utilisateur sans routines, **When** il crée la routine "Matin" avec 3 étapes (Réveil 5min, Douche 10min, Méditer 15min), **Then** la routine apparaît dans sa liste avec durée totale estimée 30min.
2. **Given** une routine "Matin" existante, **When** l'utilisateur la lance, **Then** il entre en mode runner : étape 1 affichée avec timer dégressif, bouton "Suivant" pour passer à l'étape suivante.
3. **Given** le runner en cours sur l'étape 2/3, **When** l'utilisateur appuie "Suivant", **Then** on passe à l'étape 3/3 et le timer se réinitialise à la durée de l'étape 3.
4. **Given** le runner sur la dernière étape, **When** l'utilisateur la complète, **Then** un `routine_log` est créé avec `completed_at`, `total_duration`, et le statut `completed`.
5. **Given** le runner en cours, **When** l'utilisateur quitte sans finir, **Then** un `routine_log` est créé avec statut `abandoned` et les étapes complétées sont enregistrées.

---

### User Story 3 - Capturer et trier depuis l'Inbox GTD (Priority: P1)

L'utilisateur a une idée ("Appeler le dentiste"). Il ouvre l'Inbox, tape le texte brut, c'est capturé en 3 secondes. Plus tard, il trie : ça devient une tâche dans le domaine "Santé". Les items triés disparaissent de l'inbox.

**Why this priority**: La capture rapide est essentielle au workflow GTD. Sans inbox, l'utilisateur oublie ses idées ou doit décider immédiatement où les classer, ce qui crée de la friction.

**Independent Test**: Capturer 3 items bruts, en trier un en tâche, un en habitude, supprimer le dernier. Vérifier que l'inbox est vide et que la tâche/habitude existent.

**Acceptance Scenarios**:

1. **Given** un utilisateur sur n'importe quel écran, **When** il ouvre l'inbox (FAB ou tab), **Then** il voit le champ de capture en haut et la liste des items non triés en dessous.
2. **Given** l'inbox ouvert, **When** l'utilisateur tape "Appeler dentiste" et valide, **Then** un `inbox_item` est créé avec `raw_text = "Appeler dentiste"` et `status = pending`. Le champ se vide pour une capture suivante.
3. **Given** un inbox_item "Appeler dentiste", **When** l'utilisateur le trie en "Tâche", **Then** il choisit un domaine et une date optionnelle, une `task` est créée, l'`inbox_item` passe en `status = processed`.
4. **Given** un inbox_item, **When** l'utilisateur choisit "Supprimer", **Then** l'`inbox_item` passe en `status = discarded` et disparaît de la liste.

---

### User Story 4 - Gérer ses domaines de vie (Priority: P2)

L'utilisateur personnalise ses domaines (Santé, Travail, Relations, Finances, Dev perso). Il peut en ajouter, renommer, réordonner, archiver. Lors de l'onboarding, il sélectionne ses domaines initiaux parmi des suggestions.

**Why this priority**: Les domaines sont la fondation de la catégorisation mais l'utilisateur peut commencer sans les personnaliser (les défauts suffisent). D'où P2 — nécessaire mais pas le premier besoin.

**Independent Test**: Modifier l'ordre des domaines, en ajouter un nouveau "Spiritualité", vérifier qu'il apparaît dans le domain picker lors de la création d'habitude.

**Acceptance Scenarios**:

1. **Given** un nouvel utilisateur à l'onboarding étape 2, **When** il voit les domaines suggérés, **Then** 5 domaines par défaut sont pré-sélectionnés (Santé, Travail, Relations, Finances, Développement personnel) avec icône et couleur.
2. **Given** l'onboarding étape 2, **When** l'utilisateur désélectionne "Finances" et ajoute "Spiritualité", **Then** 5 domaines sont créés dans sa table `domains` (sans Finances, avec Spiritualité).
3. **Given** la page domaines dans settings, **When** l'utilisateur drag-and-drop pour réordonner, **Then** le `sort_order` est mis à jour pour tous les domaines concernés.
4. **Given** un domaine "Travail" utilisé par 3 habitudes, **When** l'utilisateur l'archive, **Then** le domaine passe `is_archived = true`, il n'apparaît plus dans le domain picker mais les habitudes existantes gardent leur lien.

---

### User Story 5 - Gérer ses tâches simples (Priority: P2)

L'utilisateur crée des tâches ponctuelles ("Acheter du lait", "Préparer réunion lundi"), les marque comme faites, les filtre par domaine ou par date.

**Why this priority**: Les tâches sont simples mais indispensables. P2 car la capture vient d'abord de l'inbox (P1), les tâches sont le résultat du triage.

**Independent Test**: Créer une tâche avec date, la voir dans "Aujourd'hui", la cocher comme done, vérifier qu'elle disparaît de la vue active.

**Acceptance Scenarios**:

1. **Given** un utilisateur, **When** il crée une tâche "Acheter lait" avec domaine "Santé" et date aujourd'hui et priorité haute, **Then** la tâche apparaît dans la liste tâches et dans la Vue Aujourd'hui.
2. **Given** une tâche active, **When** l'utilisateur la marque done, **Then** `completed_at` est renseigné, la tâche passe dans la section "Terminées".
3. **Given** 5 tâches dans 3 domaines, **When** l'utilisateur filtre par domaine "Travail", **Then** seules les tâches du domaine Travail s'affichent.

---

### User Story 6 - Vue Aujourd'hui (Priority: P2)

L'utilisateur ouvre l'app et voit sa journée complète : habitudes du jour (groupées par plage horaire), routine active/suivante, tâches due today, et le compteur inbox.

**Why this priority**: P2 car c'est une vue d'assemblage — elle n'existe que si les briques P1 (habits, routines, inbox) existent. Mais c'est l'écran le plus utilisé au quotidien.

**Independent Test**: Avec 2 habitudes, 1 routine, 3 tâches today et 2 inbox items — vérifier que la Vue Aujourd'hui affiche tout correctement.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 3 habitudes (plages 6h-8h, 12h-14h, 18h-20h), **When** il ouvre la Vue Aujourd'hui, **Then** les habitudes sont affichées groupées par plage horaire avec checkbox.
2. **Given** une routine "Matin" programmée, **When** l'utilisateur est sur la Vue Aujourd'hui, **Then** il voit un bouton "Lancer routine Matin" avec la durée estimée.
3. **Given** 2 tâches due today et 1 overdue, **When** il regarde la section tâches, **Then** les 3 apparaissent avec la tâche overdue en rouge.
4. **Given** 5 items non triés dans l'inbox, **When** il regarde la Vue Aujourd'hui, **Then** un badge "5" apparaît sur l'icône inbox.

---

### Edge Cases

- Que se passe-t-il si l'utilisateur crée une habitude sans domaine ? → Domaine "Général" par défaut (auto-créé si aucun domaine n'existe).
- Que se passe-t-il si l'utilisateur supprime un domaine qui a des habitudes ? → Impossible : on archive, on ne supprime pas. Les habitudes gardent le lien.
- Que se passe-t-il si le timer routine est en arrière-plan ? → Le timer continue, notification locale au changement d'étape.
- Que se passe-t-il si l'utilisateur coche une habitude pour une date passée ? → Autorisé pour les 7 derniers jours maximum (rattrapage).
- Que se passe-t-il si deux routines sont lancées en même temps ? → Impossible : une seule routine active à la fois. La nouvelle demande confirmation d'abandon de l'ancienne.
- Que se passe-t-il hors connexion ? → Les actions sont stockées localement et sync au retour. (Phase 1 : mode online-only, offline planifié plus tard.)
- Que se passe-t-il si un inbox_item est trié en habitude mais l'utilisateur annule la création ? → L'inbox_item reste `pending`.
- Que se passe-t-il si l'utilisateur a 0 habitudes et ouvre la Vue Aujourd'hui ? → Empty state avec CTA "Créer votre première habitude".

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow creating habits with type (binary/quantitative), domain, time range (start_time, end_time), and optional description.
- **FR-002**: System MUST record daily habit completions (`habit_logs`) with date, value (for quantitative), and completed flag.
- **FR-003**: System MUST calculate streaks locally (consecutive days completed) and display current/best streak.
- **FR-004**: System MUST allow creating routines with ordered steps, each step having a name, estimated duration, and optional description.
- **FR-005**: System MUST provide a routine runner with step-by-step timer, next/skip/abandon actions, and log the result.
- **FR-006**: System MUST allow quick capture of raw text items into the inbox (< 3 seconds per item).
- **FR-007**: System MUST allow triaging inbox items into: task, habit, or discard.
- **FR-008**: System MUST allow creating tasks with title, optional date, optional priority (low/medium/high), and domain.
- **FR-009**: System MUST provide a Vue Aujourd'hui aggregating: today's habits by time range, active/next routine, tasks due today + overdue, inbox count.
- **FR-010**: System MUST allow creating/editing/reordering/archiving domains with name, icon, color, and sort order.
- **FR-011**: System MUST provide 5 default domains at onboarding: Santé, Travail, Relations, Finances, Développement personnel.
- **FR-012**: System MUST enforce RLS so users only see their own data across ALL tables.
- **FR-013**: System MUST prevent deleting a domain — only archiving is allowed. Archived domains are hidden from pickers but existing links are preserved.
- **FR-014**: System MUST allow only ONE active routine runner at a time.
- **FR-015**: System MUST allow backdating habit check-ins up to 7 days in the past.

### Key Entities *(include if feature involves data)*

- **Domain**: A life area the user wants to track (name, icon, color, sort_order). Every habit/routine/task belongs to one domain.
- **Habit**: A recurring behavior to track daily. Has a type (binary or quantitative with target+unit), time range (start_time, end_time), and frequency.
- **HabitLog**: A daily record of habit completion. One per habit per day. Contains date, completed flag, and optional value for quantitative habits.
- **Routine**: An ordered sequence of steps to execute. Has a name, domain, and estimated total duration (sum of steps).
- **RoutineStep**: One step within a routine. Has name, order, estimated duration, and optional description.
- **RoutineLog**: A record of a routine execution. Contains start/end time, status (completed/abandoned), total duration, and which steps were completed.
- **Task**: A one-time actionable item. Has title, domain, optional due date, priority (low/medium/high), and completed_at timestamp.
- **InboxItem**: A raw captured thought. Has raw_text, status (pending/processed/discarded), and optional link to the created entity (task_id or habit_id).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Un utilisateur peut créer une habitude et la cocher en moins de 30 secondes.
- **SC-002**: La capture inbox prend moins de 3 secondes (ouvrir → taper → valider).
- **SC-003**: Le lancement d'une routine et la complétion de toutes les étapes fonctionne sans erreur dans 100% des cas.
- **SC-004**: La Vue Aujourd'hui charge en moins de 2 secondes avec 10 habitudes, 2 routines, 20 tâches.
- **SC-005**: `supabase db reset` passe sans erreur avec toutes les migrations Phase 1.
- **SC-006**: `dart analyze` retourne 0 erreur, 0 warning sur tout le code Phase 1.
- **SC-007**: Toutes les tables ont des RLS policies validées — un utilisateur ne peut JAMAIS voir les données d'un autre.
- **SC-008**: L'onboarding (3 écrans : welcome → domaines → première habitude) se complète en moins de 90 secondes.

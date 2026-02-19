# Feature Specification: Phase 2 — Profondeur & Sens

**Feature Branch**: `002-phase2-depth-and-meaning`
**Created**: 2026-02-19
**Status**: Draft
**Input**: User description: "L'utilisateur peut se fixer des objectifs (OKR), organiser ses tâches en projets, planifier sa journée en blocs de temps, faire des reviews régulières, et voir ses statistiques. Les thèmes temporels ajoutent un focus saisonnier."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Organiser ses tâches en projets (Priority: P1)

L'utilisateur crée un projet "Déménagement" dans le domaine "Vie quotidienne", y ajoute 8 tâches (trouver appart, contacter déménageur, cartons...). Il voit la progression du projet en pourcentage au fur et à mesure qu'il complète les tâches.

**Why this priority**: Les projets structurent les tâches existantes (Phase 1) — c'est l'extension naturelle. Sans projets, les tâches restent une liste plate sans contexte.

**Independent Test**: Créer un projet avec 4 tâches, en compléter 2, vérifier que la progression affiche 50%.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec des tâches, **When** il crée un projet "Déménagement" dans le domaine "Vie quotidienne", **Then** le projet apparaît dans la liste projets avec progression 0%.
2. **Given** un projet avec 4 tâches, **When** l'utilisateur complète 2 tâches, **Then** la progression affiche 50% et la barre de progression se met à jour.
3. **Given** un projet, **When** l'utilisateur ajoute une tâche existante (orpheline) au projet, **Then** la tâche est liée au projet et la progression est recalculée.
4. **Given** un projet avec toutes les tâches complétées, **When** l'utilisateur le consulte, **Then** le projet affiche 100% et propose de l'archiver.

---

### User Story 2 - Définir et suivre des OKR trimestriels (Priority: P1)

L'utilisateur crée un Objectif "Améliorer ma santé" pour Q1 2026, lié au domaine "Santé". Il ajoute 3 Key Results mesurables : "Courir 3x/semaine" (target 12/trimestre), "Perdre 3kg" (target 3), "Méditer 20min/jour" (target 90 jours). La progression est calculée automatiquement.

**Why this priority**: Les OKR donnent du SENS aux habitudes et tâches. C'est ce qui différencie LifeFlow d'un simple tracker — le lien habit → KR → Objective → Domain.

**Independent Test**: Créer un OKR avec 2 KRs, mettre à jour la valeur actuelle d'un KR, vérifier que la progression OKR globale se recalcule.

**Acceptance Scenarios**:

1. **Given** un utilisateur, **When** il crée l'objectif "Améliorer ma santé" pour Q1 2026 dans le domaine "Santé", **Then** l'OKR apparaît dans la liste avec progression 0%.
2. **Given** un OKR, **When** il ajoute un Key Result "Courir 3x/semaine" avec target 12 et unité "sessions", **Then** le KR apparaît sous l'OKR avec current_value = 0 et progression 0%.
3. **Given** un KR avec target 12 et current_value 6, **When** la valeur est mise à jour à 9, **Then** la progression du KR affiche 75% et la progression globale de l'OKR est recalculée (moyenne des KRs).
4. **Given** un OKR avec période Q1 2026, **When** on est en Q2, **Then** l'OKR passe en section "Passés" avec son score final.

---

### User Story 3 - Planifier sa journée en blocs de temps (Priority: P2)

L'utilisateur ouvre la vue timeline et crée des blocs de temps : 6h-7h30 Routine Matin, 8h-12h Travail profond, 12h-13h Pause, 13h-17h Réunions, 18h-19h Sport. Chaque bloc peut être lié à un domaine, une habitude, une tâche ou une routine.

**Why this priority**: Les blocs de temps visualisent la journée mais l'utilisateur peut fonctionner sans (les plages horaires des habitudes suffisent en Phase 1). C'est une couche de planification avancée.

**Independent Test**: Créer 3 blocs de temps sur une journée, vérifier qu'ils apparaissent sur la timeline sans chevauchement, lier un bloc à une habitude existante.

**Acceptance Scenarios**:

1. **Given** un utilisateur sur la vue timeline, **When** il crée un bloc "Travail profond" de 8h à 12h dans le domaine "Travail", **Then** le bloc apparaît sur la timeline avec la couleur du domaine.
2. **Given** un bloc existant 8h-12h, **When** l'utilisateur tente de créer un bloc 10h-14h, **Then** le système alerte du chevauchement et propose d'ajuster.
3. **Given** un bloc lié à la routine "Matin", **When** l'utilisateur tape sur le bloc, **Then** il peut lancer la routine directement depuis la timeline.

---

### User Story 4 - Faire une review quotidienne (Priority: P2)

Chaque soir, l'utilisateur ouvre la review du jour. Il voit : habitudes cochées/total, routines complétées, tâches done/total, temps passé par domaine. Il peut ajouter une note libre (humeur, réflexion). La review est sauvegardée.

**Why this priority**: Les reviews donnent du recul mais l'app fonctionne sans. C'est un outil de réflexion, pas d'action quotidienne.

**Independent Test**: Compléter quelques habitudes et tâches dans la journée, ouvrir la review du soir, vérifier que les stats sont correctes, ajouter une note.

**Acceptance Scenarios**:

1. **Given** une journée avec 5 habitudes (3 cochées) et 4 tâches (2 done), **When** l'utilisateur ouvre la review du jour, **Then** il voit "Habitudes: 3/5 (60%)", "Tâches: 2/4 (50%)".
2. **Given** la review ouverte, **When** l'utilisateur ajoute la note "Bonne journée, fatigué le soir", **Then** la note est sauvegardée dans le `review`.
3. **Given** une review hebdomadaire (dimanche), **When** l'utilisateur l'ouvre, **Then** il voit les stats agrégées de la semaine : taux habitudes par jour (graphe 7 jours), tâches complétées, routines, et top/flop domaines.

---

### User Story 5 - Activer un thème temporel (Priority: P3)

L'utilisateur crée un thème "Focus Santé Mars" du 1er au 31 mars, lié au domaine "Santé". Pendant cette période, les habitudes et tâches du domaine Santé sont mises en avant visuellement (badge, position prioritaire).

**Why this priority**: Les thèmes sont un bonus motivationnel. L'app fonctionne parfaitement sans. C'est du polish.

**Independent Test**: Créer un thème actif, vérifier que le domaine concerné est visuellement mis en avant dans la Vue Aujourd'hui.

**Acceptance Scenarios**:

1. **Given** un utilisateur, **When** il crée le thème "Focus Santé" du 1er au 31 mars lié au domaine "Santé", **Then** le thème apparaît comme actif dans la période.
2. **Given** un thème actif sur le domaine "Santé", **When** l'utilisateur ouvre la Vue Aujourd'hui, **Then** les habitudes du domaine Santé ont un badge/highlight visuel et sont affichées en premier.
3. **Given** un thème dont la date de fin est passée, **When** l'utilisateur consulte les thèmes, **Then** il passe automatiquement en section "Terminés" avec un résumé des stats du domaine pendant la période.

---

### User Story 6 - Consulter ses statistiques (Priority: P3)

L'utilisateur ouvre le dashboard stats et voit : taux de complétion par domaine (7/30 jours), streaks actuels et records, graphe d'évolution, répartition temps par domaine.

**Why this priority**: Les stats sont de la lecture — elles ne bloquent aucune fonctionnalité. Elles ajoutent de la valeur mais l'app tourne sans.

**Independent Test**: Après 7 jours d'utilisation avec des habitudes cochées, vérifier que le graphe 7 jours affiche les bonnes valeurs.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 7 jours de données, **When** il ouvre le dashboard stats, **Then** il voit un graphe de complétion sur 7 jours avec un point par jour.
2. **Given** des habitudes dans 3 domaines, **When** il consulte la répartition par domaine, **Then** chaque domaine affiche son taux de complétion moyen avec la couleur du domaine.
3. **Given** un streak record de 15 jours sur "Méditer", **When** le streak actuel est de 8, **Then** l'affichage montre "8 jours (record: 15)".

---

### Edge Cases

- Que se passe-t-il si un projet n'a aucune tâche ? → Progression 0%, message "Ajoutez des tâches à ce projet".
- Que se passe-t-il si un OKR a 0 Key Results ? → Progression 0%, message "Ajoutez des Key Results mesurables".
- Que se passe-t-il si deux blocs de temps se chevauchent ? → Alerte visuelle, l'utilisateur doit ajuster manuellement.
- Que se passe-t-il si l'utilisateur ouvre la review d'un jour sans aucune donnée ? → Empty state "Rien à reviewer aujourd'hui".
- Que se passe-t-il si deux thèmes sont actifs sur le même domaine ? → Autorisé, mais un seul badge affiché (le plus récent).
- Que se passe-t-il si un KR dépasse son target ? → Progression plafonnée à 100% visuellement, la vraie valeur est stockée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow creating projects with name, domain, description, and status (active/completed/archived).
- **FR-002**: System MUST link tasks to projects (optional `project_id` on tasks) and calculate project progression as % of completed tasks.
- **FR-003**: System MUST allow creating OKR with title, domain, period (quarter + year), and description.
- **FR-004**: System MUST allow adding Key Results to an OKR with title, target value, unit, and current value.
- **FR-005**: System MUST auto-calculate OKR progression as the average of its Key Results' progressions.
- **FR-006**: System MUST allow creating time blocks with start_time, end_time, title, domain, and optional link (habit_id, task_id, routine_id).
- **FR-007**: System MUST detect and warn about overlapping time blocks on the same day.
- **FR-008**: System MUST provide daily review showing: habits completion rate, tasks done, routines completed, with optional free-text note.
- **FR-009**: System MUST provide weekly review aggregating daily stats over 7 days with per-domain breakdown.
- **FR-010**: System MUST allow creating themes with name, domain, start_date, end_date. Active themes highlight their domain visually.
- **FR-011**: System MUST provide a stats dashboard with: completion rate by domain (7/30 days), streaks (current + record), evolution graph.
- **FR-012**: System MUST add `project_id` (nullable FK) to the existing `tasks` table from Phase 1.

### Key Entities *(include if feature involves data)*

- **Project**: Groups related tasks. Has name, domain, description, status. Progression = completed tasks / total tasks.
- **OKR (Objective)**: A quarterly goal. Has title, domain, period (Q1-Q4 + year), description. Progression = avg of KRs.
- **KeyResult**: A measurable sub-goal of an OKR. Has title, target_value, current_value, unit. Progression = current/target.
- **TimeBlock**: A planned time slot. Has date, start_time, end_time, title, domain, and optional link to habit/task/routine.
- **Review**: A reflection entry. Has date, type (daily/weekly/monthly), stats snapshot (JSON), and optional note.
- **Theme**: A temporary focus period. Has name, domain, start_date, end_date, is_active (computed from dates).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Un utilisateur peut créer un projet et y ajouter des tâches en moins de 60 secondes.
- **SC-002**: La progression OKR se recalcule automatiquement en moins de 1 seconde après mise à jour d'un KR.
- **SC-003**: La vue timeline affiche correctement 8 blocs de temps sans lag visible.
- **SC-004**: La review quotidienne charge les stats du jour en moins de 2 secondes.
- **SC-005**: `supabase db reset` passe sans erreur avec toutes les migrations Phase 1 + Phase 2.
- **SC-006**: `dart analyze` retourne 0 erreur, 0 warning sur tout le code Phase 1 + Phase 2.
- **SC-007**: Toutes les nouvelles tables ont des RLS policies — un utilisateur ne voit jamais les données d'un autre.

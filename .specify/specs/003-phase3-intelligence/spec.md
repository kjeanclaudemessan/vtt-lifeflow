# Feature Specification: Phase 3 — Intelligence

**Feature Branch**: `003-phase3-intelligence`
**Created**: 2026-02-19
**Status**: Draft
**Input**: User description: "L'app commence à comprendre l'utilisateur grâce à l'IA locale (Level 1). Elle détecte des patterns, génère des InsightCards (observations passives), et compare le temps réel passé par domaine au temps souhaité (budget temps)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Recevoir des InsightCards basées sur ses patterns (Priority: P1)

L'utilisateur utilise l'app depuis 3 semaines. L'IA locale détecte qu'il fait du sport le mardi et jeudi mais jamais le mercredi. Une InsightCard apparaît : "Tu fais du sport 2x/semaine (mardi, jeudi). Le mercredi est libre — ajouter une session ?". L'utilisateur peut accepter (créer l'habitude), snoozer (revoir dans 7 jours), ou dismiss (ne plus montrer).

**Why this priority**: Les InsightCards sont LE différenciateur de LifeFlow. C'est ce qui transforme un tracker passif en assistant intelligent. Sans ça, Phase 3 n'a pas de raison d'être.

**Independent Test**: Simuler 21 jours de données avec un pattern clair (sport mardi/jeudi), vérifier qu'une InsightCard de type "pattern_detected" est générée.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 21+ jours de données et un pattern détectable (habitude faite 80%+ les mardis et jeudis), **When** le service d'analyse locale tourne, **Then** une `insight_card` de type `pattern_detected` est créée avec le message approprié.
2. **Given** une InsightCard affichée, **When** l'utilisateur appuie "Accepter", **Then** l'action associée se déclenche (ex: pré-remplir la création d'habitude pour le mercredi) et la card passe en `status = accepted`.
3. **Given** une InsightCard affichée, **When** l'utilisateur appuie "Snooze 7j", **Then** la card disparaît et réapparaît dans 7 jours (`snoozed_until` renseigné).
4. **Given** une InsightCard affichée, **When** l'utilisateur appuie "Dismiss", **Then** la card passe en `status = dismissed` et ne réapparaît jamais.
5. **Given** un utilisateur avec moins de 14 jours de données, **When** le service d'analyse tourne, **Then** aucune InsightCard n'est générée (données insuffisantes).

---

### User Story 2 - Voir son budget temps par domaine (Priority: P1)

L'utilisateur définit son budget temps souhaité : 30% Travail, 20% Santé, 15% Relations, 15% Dev perso, 10% Finances, 10% Loisirs. L'app compare avec le temps réel (calculé depuis les blocs de temps et routine_logs) et affiche l'écart.

**Why this priority**: Le budget temps donne une vision macro — "est-ce que je vis selon mes priorités ?" C'est le pont entre les actions quotidiennes et le sens global.

**Independent Test**: Définir un budget 50% Travail / 50% Santé, simuler une semaine avec 80% Travail / 20% Santé, vérifier que l'écart est affiché correctement.

**Acceptance Scenarios**:

1. **Given** un utilisateur, **When** il ouvre la vue budget temps, **Then** il voit ses domaines avec un slider de répartition (total = 100%).
2. **Given** un budget défini (Travail 30%, Santé 20%), **When** la semaine écoulée montre Travail 45% et Santé 10%, **Then** l'affichage montre Travail "+15% au-dessus" (rouge) et Santé "-10% en dessous" (orange).
3. **Given** un budget équilibré (écart < 5% par domaine), **When** l'utilisateur consulte le budget, **Then** tous les domaines sont en vert avec un message "Bien équilibré cette semaine".

---

### User Story 3 - Feed d'insights avec historique (Priority: P2)

L'utilisateur ouvre le feed Insights et voit toutes ses InsightCards : les nouvelles en haut, les acceptées/dismissées dans l'historique. Il peut filtrer par type (pattern, streak, suggestion, alerte).

**Why this priority**: Le feed est l'interface des InsightCards. P2 car les cards peuvent aussi apparaître directement dans la Vue Aujourd'hui (P1 de cette phase).

**Independent Test**: Avec 5 InsightCards (2 nouvelles, 1 acceptée, 1 snoozée, 1 dismissée), vérifier que le feed affiche correctement les sections et les filtres.

**Acceptance Scenarios**:

1. **Given** 3 InsightCards nouvelles, **When** l'utilisateur ouvre le feed, **Then** les 3 apparaissent triées par date (plus récente en haut) avec actions accept/snooze/dismiss.
2. **Given** le feed ouvert, **When** l'utilisateur filtre par type "pattern_detected", **Then** seules les cards de ce type s'affichent.
3. **Given** des cards dans l'historique (acceptées/dismissées), **When** l'utilisateur scroll ou ouvre la section historique, **Then** il voit les anciennes cards avec leur statut final.

---

### User Story 4 - Détection de streak en danger (Priority: P2)

L'utilisateur a un streak de 15 jours sur "Méditer". Il est 20h et n'a pas encore coché. L'IA locale génère une InsightCard urgente : "Ton streak Méditer est à 15 jours — n'oublie pas avant minuit !".

**Why this priority**: C'est un type d'insight spécifique, dérivé du moteur général. Utile mais pas structurant.

**Independent Test**: Simuler un streak de 10 jours, ne pas cocher aujourd'hui, vérifier qu'après 18h une InsightCard "streak_at_risk" est créée.

**Acceptance Scenarios**:

1. **Given** une habitude avec streak ≥ 7 jours non cochée aujourd'hui, **When** il est après 18h, **Then** une InsightCard `streak_at_risk` est créée avec le message "Ton streak [habitude] est à [N] jours".
2. **Given** une InsightCard streak_at_risk, **When** l'utilisateur coche l'habitude, **Then** la card est automatiquement dismissée (le problème est résolu).
3. **Given** une habitude avec streak < 7 jours non cochée, **When** il est après 18h, **Then** aucune InsightCard n'est créée (streak trop court pour alerter).

---

### User Story 5 - Suggestion d'optimisation de routine (Priority: P3)

Après 10 exécutions d'une routine, l'IA compare les temps réels aux temps estimés. Si l'utilisateur fait systématiquement "Douche" en 5min au lieu de 10min estimées, une InsightCard suggère d'ajuster la durée.

**Why this priority**: Optimisation fine, l'app fonctionne parfaitement sans. C'est du polish intelligent.

**Independent Test**: Simuler 10 routine_logs où l'étape "Douche" prend toujours 5min (estimé 10min), vérifier qu'une InsightCard "routine_optimization" est générée.

**Acceptance Scenarios**:

1. **Given** 10+ routine_logs pour une routine, **When** une étape a un écart moyen > 30% entre estimé et réel, **Then** une InsightCard `routine_optimization` suggère d'ajuster la durée estimée.
2. **Given** l'InsightCard acceptée, **When** l'utilisateur confirme, **Then** la durée estimée de l'étape est mise à jour automatiquement.

---

### Edge Cases

- Que se passe-t-il si l'utilisateur a moins de 14 jours de données ? → Aucune InsightCard générée, message "Continue encore X jours pour des insights personnalisés".
- Que se passe-t-il si l'IA génère une card identique à une déjà dismissée ? → Vérification de déduplication : même type + même sujet + dismissé → pas de nouvelle card.
- Que se passe-t-il si le budget temps total ne fait pas 100% ? → Validation côté UI : les sliders sont contraints à totaliser 100%.
- Que se passe-t-il si aucun bloc de temps n'est utilisé ? → Le budget temps se base sur les habit_logs et routine_logs comme proxy.
- Que se passe-t-il si l'utilisateur snooze indéfiniment ? → Après 3 snoozes consécutifs sur la même card, elle est auto-dismissée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST run a local analysis service (Flutter) that processes habit_logs, routine_logs, and task completions to detect patterns.
- **FR-002**: System MUST generate InsightCards with types: `pattern_detected`, `streak_at_risk`, `domain_imbalance`, `routine_optimization`, `completion_trend`, `suggestion`.
- **FR-003**: System MUST support InsightCard actions: accept (trigger associated action), snooze (hide for N days), dismiss (permanent hide).
- **FR-004**: System MUST deduplicate insights — never generate a card identical to one already dismissed.
- **FR-005**: System MUST require minimum 14 days of data before generating any insights.
- **FR-006**: System MUST allow users to define a time budget per domain (percentages totaling 100%).
- **FR-007**: System MUST calculate actual time spent per domain from time_blocks (Phase 2) and routine_logs, and compare to budget.
- **FR-008**: System MUST provide a feed view for InsightCards with sections (new, snoozed, history) and filters by type.
- **FR-009**: System MUST auto-dismiss streak_at_risk cards when the habit is completed.
- **FR-010**: System MUST limit snooze to 3 times per card — auto-dismiss after 3rd snooze.

### Key Entities *(include if feature involves data)*

- **InsightCard**: An AI-generated observation. Has type (enum), title, message, associated_entity (habit/routine/domain), suggested_action (JSON), status (new/accepted/snoozed/dismissed), snoozed_until, snooze_count.
- **TimeBudget**: User's desired time allocation per domain. Has domain_id, percentage (0-100). All user's budgets must sum to 100.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Après 21 jours de données avec patterns clairs, au moins 2 InsightCards pertinentes sont générées.
- **SC-002**: L'action accept/snooze/dismiss sur une InsightCard prend moins de 1 seconde.
- **SC-003**: Le calcul du budget temps s'affiche en moins de 2 secondes pour 30 jours de données.
- **SC-004**: Zéro InsightCard dupliquée — la déduplication fonctionne à 100%.
- **SC-005**: `supabase db reset` passe sans erreur avec toutes les migrations Phase 1 + 2 + 3.
- **SC-006**: `dart analyze` retourne 0 erreur, 0 warning sur tout le code Phase 1 + 2 + 3.
- **SC-007**: Le service d'analyse locale ne bloque PAS l'UI — exécution asynchrone en background.

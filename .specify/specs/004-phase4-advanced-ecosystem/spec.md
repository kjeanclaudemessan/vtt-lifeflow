# Feature Specification: Phase 4 — IA Avancée & Écosystème

**Feature Branch**: `004-phase4-advanced-ecosystem`
**Created**: 2026-02-19
**Status**: Draft
**Input**: User description: "Produit complet avec IA cloud (GPT-4o via FastAPI), synchronisation calendrier (Google/Apple), notifications push, gamification légère, partage social, et monétisation via Moneroo."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Recevoir des insights complexes de l'IA cloud (Priority: P1)

L'utilisateur a 3 mois de données. L'IA Level 2 (FastAPI + GPT-4o) analyse les corrélations croisées : "Quand tu médites le matin, ton taux de complétion des tâches Travail augmente de 35%. Ta routine Matin semble être le facteur clé de ta productivité." Ce type d'analyse dépasse le calcul local.

**Why this priority**: L'IA Level 2 est le différenciateur premium. C'est ce qui justifie un abonnement payant — des insights impossibles à obtenir avec des calculs simples.

**Independent Test**: Envoyer 90 jours de données agrégées à l'endpoint FastAPI, vérifier qu'un insight de corrélation est retourné sous forme d'InsightCard.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 90+ jours de données, **When** le batch d'analyse cloud tourne (hebdomadaire), **Then** les données agrégées (pas les données brutes) sont envoyées à FastAPI.
2. **Given** FastAPI reçoit les données agrégées, **When** GPT-4o analyse les corrélations, **Then** 1-3 InsightCards de type `ai_correlation` sont créées et renvoyées à Flutter.
3. **Given** une InsightCard `ai_correlation`, **When** l'utilisateur la consulte, **Then** elle contient un titre, un message détaillé, et optionnellement un graphe de corrélation.
4. **Given** l'utilisateur n'a pas de connexion internet, **When** le batch cloud devrait tourner, **Then** il est reporté silencieusement au prochain cycle avec connexion.
5. **Given** l'API GPT-4o retourne une erreur, **When** FastAPI traite l'erreur, **Then** aucune InsightCard erronée n'est créée, l'erreur est loggée, et un retry est planifié.

---

### User Story 2 - Synchroniser son calendrier (Priority: P1)

L'utilisateur connecte son Google Calendar. Ses événements apparaissent dans la vue timeline (Phase 2) aux côtés de ses blocs de temps. Les créneaux occupés sont grisés. Il peut créer un bloc de temps LifeFlow autour de ses réunions.

**Why this priority**: Le calendrier est l'intégration la plus demandée dans les apps de productivité. Sans ça, l'utilisateur doit jongler entre 2 apps pour planifier sa journée.

**Independent Test**: Connecter un Google Calendar de test, vérifier que les événements du jour apparaissent sur la timeline LifeFlow.

**Acceptance Scenarios**:

1. **Given** un utilisateur dans les settings, **When** il connecte son Google Calendar via OAuth, **Then** un `calendar_sync` est créé avec le token et le sync initial démarre.
2. **Given** un calendrier connecté avec 3 événements aujourd'hui, **When** l'utilisateur ouvre la vue timeline, **Then** les 3 événements apparaissent en grisé (non éditables) aux côtés de ses blocs LifeFlow.
3. **Given** un événement Google "Réunion 14h-15h" visible, **When** l'utilisateur crée un bloc LifeFlow 15h-16h "Travail post-réunion", **Then** le bloc est créé sans conflit avec l'événement Google.
4. **Given** un calendrier connecté, **When** un nouvel événement est ajouté dans Google Calendar, **Then** il apparaît dans LifeFlow au prochain sync (intervalle configurable, défaut 15min).
5. **Given** l'utilisateur veut déconnecter son calendrier, **When** il supprime la sync dans settings, **Then** tous les événements Google disparaissent de la timeline, les blocs LifeFlow restent.

---

### User Story 3 - Recevoir des notifications push (Priority: P2)

L'utilisateur configure ses rappels : notification le matin pour lancer sa routine (7h), rappel habitudes non cochées à 20h, rappel review du soir à 21h. Les notifications arrivent même si l'app est fermée.

**Why this priority**: Les notifications augmentent l'engagement mais l'app fonctionne sans (l'utilisateur ouvre l'app de lui-même). C'est un booster de rétention.

**Independent Test**: Configurer un rappel à une heure précise, vérifier que la notification arrive, taper dessus et atterrir sur le bon écran.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec une routine "Matin" et rappel à 7h activé, **When** il est 7h, **Then** une notification push "Lance ta routine Matin (30 min)" apparaît.
2. **Given** 3 habitudes non cochées à 20h, **When** le rappel habitudes est activé, **Then** une notification "3 habitudes à compléter aujourd'hui" apparaît.
3. **Given** l'utilisateur tape sur la notification routine, **When** l'app s'ouvre, **Then** il arrive directement sur le routine runner prêt à lancer.
4. **Given** l'utilisateur dans settings, **When** il désactive les rappels habitudes, **Then** plus aucune notification habitude n'est envoyée.

---

### User Story 4 - Gagner des badges et milestones (Priority: P3)

L'utilisateur atteint un streak de 30 jours sur "Méditer". Un badge "30 jours consécutifs" est débloqué avec une animation. Il peut voir tous ses badges dans une galerie. Des milestones sont aussi déclenchés : "100 tâches complétées", "10 routines terminées".

**Why this priority**: La gamification est du polish motivationnel. L'app est complète sans. C'est un levier de rétention long terme.

**Independent Test**: Simuler un streak de 30 jours, vérifier que le badge est débloqué et visible dans la galerie.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec streak = 29 sur "Méditer", **When** il coche le jour 30, **Then** un badge "30 jours consécutifs" est créé avec animation de célébration.
2. **Given** un badge débloqué, **When** l'utilisateur ouvre la galerie badges, **Then** il voit le badge avec date d'obtention, les badges non encore obtenus sont grisés avec la condition affichée.
3. **Given** l'utilisateur a complété 99 tâches, **When** il complète la 100ème, **Then** un milestone "100 tâches accomplies" est déclenché.

---

### User Story 5 - Partager un streak ou une stat (Priority: P3)

L'utilisateur est fier de son streak de 45 jours. Il appuie "Partager", une image est générée (streak + habitude + logo LifeFlow) et il peut l'envoyer via WhatsApp, Instagram, etc.

**Why this priority**: Le partage est un levier d'acquisition organique mais n'a aucun impact fonctionnel. Pur marketing.

**Independent Test**: Générer une image de partage pour un streak, vérifier que l'image contient les bonnes données et que le share sheet s'ouvre.

**Acceptance Scenarios**:

1. **Given** un streak de 45 jours sur "Méditer", **When** l'utilisateur appuie "Partager", **Then** une image est générée avec le nom de l'habitude, le streak, un visuel attrayant, et le logo LifeFlow.
2. **Given** l'image générée, **When** le share sheet s'ouvre, **Then** l'utilisateur peut choisir WhatsApp, Instagram, Twitter, ou copier l'image.

---

### User Story 6 - Souscrire à un abonnement premium (Priority: P2)

L'utilisateur gratuit a accès aux fonctionnalités Phase 1-2. Pour l'IA cloud (Phase 3-4), le calendrier sync, et les insights avancés, il doit souscrire. Le paywall Moneroo propose : Mensuel 2000 XOF, Annuel 18000 XOF.

**Why this priority**: La monétisation est critique pour la viabilité mais ne bloque aucune fonctionnalité. Elle gate certaines features avancées.

**Independent Test**: Ouvrir le paywall, simuler un paiement Moneroo, vérifier que le statut premium est activé et que les features gated sont débloquées.

**Acceptance Scenarios**:

1. **Given** un utilisateur gratuit, **When** il tente d'accéder aux insights IA cloud, **Then** un paywall s'affiche avec les plans disponibles (mensuel/annuel).
2. **Given** le paywall affiché, **When** l'utilisateur choisit le plan mensuel et complète le paiement Moneroo, **Then** son statut passe à "premium", le paywall disparaît, les features sont débloquées.
3. **Given** un utilisateur premium, **When** son abonnement expire, **Then** il repasse en mode gratuit avec un message "Votre abonnement a expiré" et les features premium sont re-gated.
4. **Given** un paiement Moneroo échoué, **When** l'utilisateur revient, **Then** un message d'erreur clair est affiché avec option de réessayer.

---

### Edge Cases

- Que se passe-t-il si le token Google Calendar expire ? → Refresh automatique. Si le refresh échoue, notification à l'utilisateur de reconnecter.
- Que se passe-t-il si GPT-4o est hors service ? → Fallback : pas d'InsightCards Level 2, les InsightCards Level 1 continuent normalement. Retry au prochain cycle.
- Que se passe-t-il si l'utilisateur a désactivé les notifications au niveau OS ? → Message dans settings LifeFlow "Notifications désactivées — activez-les dans les réglages de votre téléphone".
- Que se passe-t-il si le paiement Moneroo est en attente (mobile money) ? → Statut "pending", l'utilisateur est informé, webhook Moneroo met à jour le statut quand confirmé.
- Que se passe-t-il si deux calendriers sont connectés ? → Les événements des deux apparaissent sur la timeline avec un code couleur par source.
- Que se passe-t-il si l'utilisateur downgrade de premium à gratuit ? → Ses données Phase 3-4 sont conservées (lecture seule) mais les nouvelles features premium ne fonctionnent plus.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a FastAPI endpoint that receives aggregated user data and returns AI-generated InsightCards via GPT-4o.
- **FR-002**: System MUST send ONLY aggregated data to FastAPI (never raw personal data) — averages, percentages, patterns, not individual logs.
- **FR-003**: System MUST support Google Calendar OAuth sync with automatic token refresh.
- **FR-004**: System MUST display external calendar events as read-only on the timeline alongside LifeFlow time blocks.
- **FR-005**: System MUST support Apple Calendar sync via platform-specific APIs (EventKit on iOS/macOS).
- **FR-006**: System MUST support configurable push notifications: routine reminders, habit reminders, review reminders.
- **FR-007**: System MUST deep-link notifications to the relevant screen (routine → runner, habit → check, review → review screen).
- **FR-008**: System MUST award badges based on predefined triggers (streak milestones, completion counts, consistency).
- **FR-009**: System MUST generate shareable images with habit/streak data and LifeFlow branding.
- **FR-010**: System MUST integrate Moneroo for payment processing with XOF currency, monthly and annual plans.
- **FR-011**: System MUST gate premium features (IA Level 2, calendar sync, advanced insights) behind subscription.
- **FR-012**: System MUST handle Moneroo webhooks for payment confirmation, failure, and subscription expiry.
- **FR-013**: System MUST gracefully degrade when external services (GPT-4o, Google, Moneroo) are unavailable.

### Key Entities *(include if feature involves data)*

- **CalendarSync**: A connected external calendar. Has provider (google/apple), auth_token, refresh_token, last_synced_at, sync_interval.
- **Achievement**: A badge earned by the user. Has type (streak_milestone/task_count/routine_count/etc.), title, description, icon, earned_at, trigger_value.
- **Milestone**: A predefined threshold. Has type, required_value, title, description. When user reaches required_value, an Achievement is created.
- **Subscription**: User's payment status. Has plan (monthly/annual), status (active/expired/pending), moneroo_transaction_id, started_at, expires_at.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: L'endpoint FastAPI répond en moins de 10 secondes pour une analyse IA (GPT-4o inclus).
- **SC-002**: Le sync calendrier affiche les événements en moins de 3 secondes après connexion initiale.
- **SC-003**: Les notifications push arrivent dans les 60 secondes de l'heure configurée.
- **SC-004**: Le flux de paiement Moneroo (clic paywall → confirmation) fonctionne en moins de 2 minutes.
- **SC-005**: Les badges se débloquent instantanément (< 1 seconde) après le trigger.
- **SC-006**: Le partage d'image génère un visuel en moins de 2 secondes.
- **SC-007**: `supabase db reset` passe sans erreur avec TOUTES les migrations (Phase 1 + 2 + 3 + 4).
- **SC-008**: `dart analyze` retourne 0 erreur, 0 warning sur TOUT le codebase.
- **SC-009**: Quand GPT-4o ou Google Calendar est hors service, l'app continue de fonctionner normalement pour toutes les autres fonctionnalités.

# Feature Specification: Phase 1 — Le Cockpit Quotidien

**Feature Branch**: `001-phase1-daily-foundations`
**Created**: 2026-02-19 | **Revised**: 2026-02-19
**Status**: Final
**Scope**: 6 features (F02, F03, F06, F01, F07, F09) — validé par `docs/feature-scoring.md`
**Question centrale**: *"Où va mon temps ?"*

## Contexte produit

LifeFlow n'est pas un habit tracker. C'est un **système de vie** qui rend visible l'invisible : la répartition du temps entre les domaines de vie. Phase 1 existe pour prouver **une seule hypothèse** (H1 du Business Model) :

> *"Les gens veulent voir où va leur temps — et cette visibilité change leur comportement."*

Les 6 features forment une boucle serrée :

```
Domaines (la structure) → Habitudes (l'action) → Compteur temps (la preuve)
     ↑                                                    ↓
Streak freeze (la sécurité) ← TodayView (le rituel) ← Bilan hebdo (le déclic)
```

**Ce que P1 n'est PAS** : pas de tâches, pas de routines, pas d'inbox, pas d'OKR, pas d'IA. Ces features sont P2+. Un habit tracker avec un compteur temps qui marche > un cockpit complet qui est moyen.

---

## User Scenarios & Testing

### User Story 1 — Choisir et gérer ses domaines de vie (Priority: P1)

L'utilisateur arrive dans LifeFlow et choisit ses domaines de vie. 5 sont pré-sélectionnés (Santé, Travail, Relations, Finances, Développement personnel). Il peut en ajouter, renommer, réordonner, archiver. Chaque domaine a un nom, une icône emoji, et une couleur.

**Why this priority**: Les domaines sont la fondation de TOUT. Sans domaines, pas de catégorisation, pas de compteur temps, pas de bilan. Score 22/25 — deuxième plus haut du scoring.

**Le parcours** : Onboarding étape 2 → l'utilisateur voit 5 domaines pré-cochés → il peut en décocher, en ajouter → valide → les domaines sont créés dans Supabase.

**Independent Test**: Modifier l'ordre des domaines, en ajouter un "Spiritualité", vérifier qu'il apparaît dans le domain picker lors de la création d'habitude.

**Acceptance Scenarios**:

1. **Given** un nouvel utilisateur à l'onboarding étape 2, **When** il voit les domaines suggérés, **Then** 5 domaines par défaut sont pré-sélectionnés avec icône et couleur (🏥 Santé vert, 💼 Travail bleu, 💙 Relations ambre, 💰 Finances violet, 🧠 Dev perso indigo).
2. **Given** l'onboarding étape 2, **When** l'utilisateur désélectionne "Finances" et ajoute "Spiritualité", **Then** 5 domaines sont créés (sans Finances, avec Spiritualité).
3. **Given** la page domaines dans settings, **When** l'utilisateur drag-and-drop pour réordonner, **Then** le `sort_order` est mis à jour pour tous les domaines concernés.
4. **Given** un domaine "Travail" utilisé par 3 habitudes, **When** l'utilisateur l'archive, **Then** le domaine passe `is_archived = true`, il n'apparaît plus dans le domain picker mais les habitudes existantes gardent leur lien.
5. **Given** 0 domaines actifs, **When** l'utilisateur tente d'archiver le dernier domaine, **Then** l'action est refusée avec un message "Tu dois garder au moins un domaine actif".

---

### User Story 2 — Créer et suivre des habitudes quotidiennes (Priority: P1)

L'utilisateur crée une habitude (ex: "Méditer 10 min"), la rattache au domaine "Santé", définit un temps estimé (10 min), et choisit une plage horaire (6h-8h). Chaque jour, il la coche depuis la TodayView. L'app calcule son streak et son temps accumulé par domaine.

**Why this priority**: Les habitudes sont l'unité de base du tracking. Chaque habitude cochée alimente le compteur temps. Sans habitudes, rien ne fonctionne. Score 20/25.

**Le parcours** : Tab Habitudes → FAB → formulaire → nom, type, domaine, durée estimée, plage horaire → sauvegarder → visible dans TodayView.

**Independent Test**: Créer une habitude binaire, la cocher aujourd'hui, vérifier que le streak passe à 1 et que le compteur temps du domaine augmente de `estimated_duration_minutes`.

**Acceptance Scenarios**:

1. **Given** un utilisateur authentifié sans habitudes, **When** il crée une habitude binaire "Méditer" dans le domaine "Santé" avec durée estimée 10 min et plage 6h-8h, **Then** l'habitude apparaît dans sa liste et dans la TodayView dans la section matin.
2. **Given** une habitude non cochée aujourd'hui, **When** l'utilisateur la coche, **Then** un `habit_log` est créé avec `completed = true`, le streak passe à 1, le compteur temps du domaine "Santé" augmente de 10 min.
3. **Given** une habitude cochée aujourd'hui, **When** l'utilisateur la décoche, **Then** le `habit_log` est supprimé, le streak recalculé, le compteur temps diminue de 10 min.
4. **Given** une habitude quantitative "Lire" (target: 30, unité: min, domaine: Dev perso), **When** l'utilisateur entre 25 min, **Then** la progression affiche 83%, le log enregistre `value = 25`, et le compteur temps du domaine augmente de 25 min (la valeur réelle, pas l'estimé).
5. **Given** une habitude quantitative "Boire 2L" (target: 2000, unité: ml, durée estimée: 5 min), **When** l'utilisateur entre 1500ml, **Then** la progression affiche 75%, et le compteur temps augmente de 5 min (durée estimée, car l'unité n'est pas 'min').
6. **Given** une habitude créée il y a 3 jours sans log pour hier, **When** l'utilisateur ouvre la TodayView, **Then** il peut cocher l'habitude d'hier (rattrapage jusqu'à 7 jours en arrière).

---

### User Story 3 — Voir le compteur temps par domaine (Priority: P1)

L'utilisateur ouvre le tab Compteur et voit combien d'heures il a consacrées à chaque domaine cette semaine. C'est LA killer feature — ce que personne d'autre ne fait. Le compteur se met à jour en temps réel quand une habitude est cochée.

**Why this priority**: C'est la raison d'exister de LifeFlow. Score 23/25 — le plus haut du scoring. Si les gens ne regardent pas leur compteur, le produit n'a pas de raison d'exister (H1 du BM).

**Le parcours** : Tab Compteur → vue semaine → barres par domaine → tap sur un domaine → détail (quelles habitudes contribuent) → retour.

**Independent Test**: Avec 3 habitudes dans 2 domaines, cocher toutes les habitudes de la semaine, vérifier que le compteur affiche les bons totaux.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 3 habitudes (Méditer 10min/Santé, Sport 60min/Santé, Lire 30min/Dev perso) toutes cochées lundi-vendredi, **When** il ouvre le Compteur, **Then** il voit : Santé = 5h50 (70min × 5j), Dev perso = 2h30 (30min × 5j).
2. **Given** le Compteur ouvert, **When** l'utilisateur tape sur le domaine "Santé", **Then** il voit le détail : Méditer → 50min (10min × 5j), Sport → 5h (60min × 5j).
3. **Given** des données pour la semaine en cours et la semaine précédente, **When** le Compteur s'affiche, **Then** chaque domaine montre un delta (ex: "Santé: 5h50 ▲ +1h20 vs semaine dernière").
4. **Given** une habitude cochée à l'instant sur la TodayView, **When** l'utilisateur navigue vers le Compteur, **Then** le total est déjà mis à jour (pas besoin de refresh manuel).
5. **Given** 0 habitudes, **When** l'utilisateur ouvre le Compteur, **Then** un empty state s'affiche : "Crée ta première habitude pour voir ton temps" avec un CTA.

---

### User Story 4 — Naviguer via le TodayView contextuel (Priority: P1)

L'utilisateur ouvre l'app et voit un écran adapté au moment de la journée. Le matin : ses habitudes à faire, un encouragement. L'après-midi : sa progression, ce qui reste. Le soir : son bilan du jour, son compteur temps. C'est le premier écran vu chaque jour — il doit être parfait.

**Why this priority**: C'est la porte d'entrée quotidienne. Le TodayView rend le tracking sans friction : ouvrir → cocher → voir le compteur bouger. Score 21/25. L'intelligence de P1 est ici : pas d'IA, juste un `if/else` sur l'heure qui change tout.

**Le parcours** : Ouvrir l'app → TodayView → cocher habitudes → voir compteur → navigation vers Habitudes ou Compteur.

**Independent Test**: Ouvrir l'app à 8h, voir le mode matin. Revenir à 14h, voir le mode progression. Revenir à 20h, voir le mode bilan.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec des habitudes, **When** il ouvre l'app entre 5h et 12h, **Then** le TodayView affiche le mode **Matin** : "Bonjour [prénom]", habitudes du jour groupées par plage horaire (matin d'abord), mini compteur temps de la semaine.
2. **Given** le même utilisateur, **When** il ouvre l'app entre 12h et 18h, **Then** le TodayView affiche le mode **Progression** : "X/Y habitudes faites", barre de progression de la journée, habitudes restantes, compteur temps mis à jour.
3. **Given** le même utilisateur, **When** il ouvre l'app entre 18h et 5h, **Then** le TodayView affiche le mode **Bilan** : "Tu as fait X habitudes aujourd'hui", résumé temps par domaine, encouragement pour demain.
4. **Given** un utilisateur avec 3 habitudes (plages 6h-8h, 12h-14h, 18h-20h), **When** le TodayView s'affiche, **Then** les habitudes sont groupées par plage : Matin (6h-8h), Après-midi (12h-14h), Soir (18h-20h), puis "Sans horaire" pour les habitudes sans plage.
5. **Given** un utilisateur sans habitudes, **When** il ouvre le TodayView, **Then** un empty state s'affiche : illustration + "Ta journée est vide. Crée ta première habitude !" avec un CTA.
6. **Given** un dimanche (ou lundi matin), **When** le TodayView s'affiche, **Then** une carte "Bilan de la semaine" apparaît en haut, tappable pour ouvrir le bilan hebdo complet.

---

### User Story 5 — Bénéficier du streak freeze automatique (Priority: P1)

L'utilisateur manque une habitude un jour. Au lieu de voir son streak cassé, le système utilise automatiquement un "jour de grâce" (1 par semaine glissante, par habitude). Le streak est préservé, l'utilisateur voit un indicateur visuel différent (❄️ au lieu de 🔥).

**Why this priority**: Semaine 3 = mur de la mort pour les habit trackers. Le streak cassé = abandon massif. Le streak freeze est une assurance anti-churn. Score 19/25.

**Le parcours** : L'utilisateur ne fait RIEN — le freeze est automatique. Il le découvre quand il revient après 1 jour manqué et que son streak est intact.

**Independent Test**: Créer une habitude, la cocher 5 jours consécutifs, ne pas la cocher le jour 6, la cocher le jour 7. Vérifier que le streak est à 7 (pas cassé).

**Acceptance Scenarios**:

1. **Given** une habitude avec un streak de 5 jours, **When** l'utilisateur ne la coche pas le jour 6 mais la coche le jour 7, **Then** le streak affiche 7 (le jour 6 est couvert par le freeze), avec un badge ❄️ sur le jour 6.
2. **Given** une habitude avec un freeze utilisé il y a 3 jours, **When** l'utilisateur manque un autre jour dans la même semaine, **Then** le streak est cassé (1 seul freeze par 7 jours glissants).
3. **Given** le streak freeze utilisé, **When** l'utilisateur regarde le détail de son streak, **Then** les jours avec freeze sont marqués ❄️ (bleu) au lieu de 🔥 (orange). Les jours manqués sans freeze sont ⬜ (gris).
4. **Given** un utilisateur dans les settings, **When** il désactive le streak freeze globalement, **Then** tous les streaks sont recalculés sans freeze. Les prochains jours manqués cassent le streak immédiatement.
5. **Given** une habitude avec fréquence "weekly" (3 jours/semaine), **When** l'utilisateur fait l'habitude 2 jours sur 3, **Then** le freeze couvre le 3ème jour manqué et le streak hebdomadaire est préservé.

---

### User Story 6 — Recevoir et partager le bilan hebdomadaire (Priority: P1)

Chaque dimanche soir (ou lundi matin), l'utilisateur reçoit un bilan auto-généré : heures par domaine, habitude la plus régulière, plus long streak, delta vs semaine précédente. Il peut le partager en un tap (screenshot optimisé stories/social).

**Why this priority**: C'est le "aha moment" du produit. Le premier bilan = prise de conscience ("28h Travail, 2h Santé"). C'est aussi le levier de viralité : un bilan partagé = une publicité gratuite. Score 21/25.

**Le parcours** : Dimanche soir → notification "Ton bilan est prêt" → ouvrir → voir les chiffres → réagir → partager.

**Independent Test**: Après 7 jours de tracking avec 3 habitudes dans 2 domaines, vérifier que le bilan affiche les bons totaux, le bon delta, et que le bouton partage génère une image.

**Acceptance Scenarios**:

1. **Given** un utilisateur avec 7 jours de données, **When** le bilan hebdo se génère, **Then** il affiche : heures par domaine (barre horizontale), top habit (la plus régulière), plus long streak actif, taux de complétion global (X%).
2. **Given** des données pour 2 semaines consécutives, **When** le bilan s'affiche, **Then** chaque domaine montre le delta vs semaine dernière (ex: "Santé: 5h ▲ +2h", "Travail: 25h ▼ -3h").
3. **Given** le bilan affiché, **When** l'utilisateur tape "Partager", **Then** un screenshot stylisé est généré (fond avec les couleurs du DS, logo LifeFlow, données anonymisées si souhaité) et la sheet de partage système s'ouvre.
4. **Given** un utilisateur en première semaine (pas de semaine précédente), **When** le bilan s'affiche, **Then** le delta est remplacé par "Première semaine !" et un message d'encouragement.
5. **Given** le TodayView le dimanche soir ou lundi matin, **When** le bilan est disponible, **Then** une carte cliquable "📊 Ton bilan de la semaine est prêt" apparaît en haut du TodayView.
6. **Given** le Compteur ouvert, **When** l'utilisateur fait défiler vers le bas, **Then** il voit les bilans des semaines précédentes (historique consultable).

---

## Edge Cases

| Cas | Comportement attendu |
|-----|---------------------|
| 0 habitudes, TodayView ouverte | Empty state avec CTA "Crée ta première habitude" |
| 0 habitudes, Compteur ouvert | Empty state avec CTA "Crée ta première habitude pour voir ton temps" |
| Habitude sans `estimated_duration_minutes` | Impossible — le champ a un défaut (15 min), modifiable dans le formulaire |
| Habitude quantitative unité=min, valeur > target | Le log enregistre la valeur réelle. Progression affiche > 100%. Temps comptabilisé = valeur réelle |
| Habitude quantitative unité≠min | Temps comptabilisé = `estimated_duration_minutes` (pas la valeur) |
| Cocher une habitude pour une date passée | Autorisé jusqu'à 7 jours en arrière. Le compteur et le bilan se recalculent |
| Archiver un domaine avec habitudes | Domaine archivé, habitudes gardent le lien. Compteur ne montre plus le domaine archivé. Habitudes restent trackables |
| Archiver le dernier domaine | Refusé — message d'erreur "Garde au moins 1 domaine" |
| Streak freeze + habitude weekly (3j/semaine) | Le freeze s'applique sur la granularité de la fréquence. 1 jour manqué sur les 3 requis = freeze utilisé |
| Pas de connexion internet | Phase 1 = online-only. Message d'erreur clair, bouton retry |
| Première semaine, bilan sans comparaison | Affiche les totaux + "Première semaine !" au lieu du delta |
| Utilisateur ne revient pas pendant 30 jours | Bilans calculés rétroactivement pour les semaines avec données. Message de retour bienveillant (pas de culpabilité) |

---

## Requirements

### Functional Requirements

| ID | Requirement | US |
|----|-------------|-----|
| FR-001 | System MUST allow creating habits with: name, type (binary/quantitative), domain, estimated_duration_minutes, time range (start_time, end_time), frequency (daily/weekly/custom) | US2 |
| FR-002 | System MUST record daily habit completions (`habit_logs`) with date, completed flag, and value (for quantitative) | US2 |
| FR-003 | System MUST calculate streaks (consecutive days/periods completed) with streak freeze support | US2, US5 |
| FR-004 | System MUST calculate time per domain per week by summing: `estimated_duration_minutes` for binary habits, `value` for quantitative habits with unit='min', `estimated_duration_minutes` for other quantitative habits | US3 |
| FR-005 | System MUST display a contextual TodayView that adapts to time of day (morning/afternoon/evening) | US4 |
| FR-006 | System MUST auto-generate a weekly summary (bilan) with hours per domain, top habit, longest streak, completion rate, and week-over-week delta | US6 |
| FR-007 | System MUST allow sharing the weekly summary as a styled screenshot image | US6 |
| FR-008 | System MUST provide 5 default domains at onboarding with name, icon, and color | US1 |
| FR-009 | System MUST allow creating/editing/reordering/archiving domains. Archiving hides from pickers but preserves existing links | US1 |
| FR-010 | System MUST enforce RLS so users only see their own data across ALL tables | ALL |
| FR-011 | System MUST allow backdating habit check-ins up to 7 days in the past | US2 |
| FR-012 | System MUST provide 1 automatic streak freeze per 7-day rolling window per habit | US5 |
| FR-013 | System MUST prevent archiving the last active domain | US1 |
| FR-014 | System MUST group habits in TodayView by time range: Matin (<12h), Après-midi (12h-18h), Soir (>18h), Sans horaire | US4 |
| FR-015 | System MUST show time counter update immediately after checking a habit (no page refresh needed) | US3, US4 |

### Key Entities

| Entity | Description | Fields clés |
|--------|-------------|-------------|
| **Domain** | Domaine de vie pour catégoriser les habitudes | name, icon, color, sort_order, is_archived |
| **Habit** | Comportement récurrent à tracker | name, type, domain_id, estimated_duration_minutes, start_time, end_time, frequency |
| **HabitLog** | Log quotidien d'une habitude | habit_id, log_date, completed, value |

---

## Success Criteria

| ID | Critère | Seuil |
|----|---------|-------|
| SC-001 | Créer une habitude (formulaire → sauvegarde) | < 30 secondes |
| SC-002 | Cocher/décocher une habitude | < 500 ms (feedback visuel immédiat) |
| SC-003 | TodayView charge avec 10 habitudes | < 2 secondes |
| SC-004 | Compteur temps s'affiche avec données complètes | < 2 secondes |
| SC-005 | Bilan hebdo se génère et s'affiche | < 3 secondes |
| SC-006 | Partage du bilan (génération image + sheet partage) | < 2 secondes |
| SC-007 | `supabase db reset` passe avec 0 erreur | Gate obligatoire |
| SC-008 | `dart analyze` retourne 0 erreur, 0 warning | Gate obligatoire |
| SC-009 | RLS validé — un utilisateur ne voit JAMAIS les données d'un autre | Test multi-user |
| SC-010 | Onboarding complet (3 écrans → première habitude) | < 90 secondes |

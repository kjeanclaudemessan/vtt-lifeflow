# LifeFlow — Phases Roadmap

**Updated**: 2026-02-20
**Status**: Active
**Source of truth**: `docs/feature-scoring.md` (scores) + `docs/business-model.md` §9.2 + §9.5 (IA strategy)

---

## Overview

3 phases + Backlog. Chaque phase est une spec autonome livrable.
L'ordre est strict : chaque phase dépend de la précédente.

```
Phase 1 — MVP (M1-M3)           Phase 2 — Système + IA (M4-M6)         Phase 3 — Intelligence (M7-M12)
6 features, 0 IA                 11 features, IA rôles 1+2               6 features, IA rôle 3
──────────────────               ───────────────────────────              ──────────────────────────────
F02 Domaines de vie              F04 Tâches                              F27 IA conseiller actionnable
F03 Habitudes + streaks          F05 Routines                            F15 Blocs de temps
F06 Compteur temps/domaine       F08 Micro-récompenses                   F20 Compensation mensuelle
F01 TodayView contextuel         F10 Inbox rapide                        F21 Projets
F07 Bilan hebdo simplifié        F11 Budget temps complet                F22 Monthly/Quarterly Review
F09 Streak freeze                F12 OKR + Key Results                   F14 Thèmes par domaine
                                 F13 Lien Habit→KR
                                 F16 Weekly Review guidée
                                 F18 IA interprète de données
                                 F19 IA patterns configurables
                                 F25 Partage de bilan
```

---

## Phase 1 — Le cockpit quotidien (MVP)

**Objectif** : Prouver que les gens utilisent le compteur temps/domaine et reviennent quotidiennement.
**IA** : Aucune. L'intelligence est structurelle (TodayView = `if/else` sur l'heure, compteur = arithmétique).
**Scope** : 6 features. Ultra-serré, focusé sur : voir ses domaines, tracker ses habitudes, voir où va son temps, ne pas décrocher.

| # | Feature | Tables Supabase | Écrans Flutter | Score |
|---|---------|----------------|----------------|-------|
| F02 | **Domaines de vie** | `domains` (5 par défaut via seeds) | Onboarding step, Domain picker, Settings domaines | 22/25 |
| F03 | **Habitudes** | `habits`, `habit_logs` | Liste habitudes, Détail, Création/édition, Check quotidien | 20/25 |
| F06 | **Compteur temps/domaine** | — (calcul depuis `habit_logs`) | Widget compteur semaine, détail par domaine | 23/25 |
| F01 | **TodayView contextuel** | — (agrège les autres) | Home : matin=plan, midi=progress, soir=bilan | 21/25 |
| F07 | **Bilan hebdo simplifié** | — (calcul depuis `habit_logs`) | Bilan auto dimanche : X h par domaine, partageable | 21/25 |
| F09 | **Streak freeze** | — (logique dans `habit_logs`) | Badge "jour de grâce" sur le streak, config dans settings | 19/25 |

**Ordre d'implémentation** :
```
F02 (Domaines) → F03 (Habitudes) → F09 (Streak freeze)
→ F06 (Compteur temps) → F01 (TodayView) → F07 (Bilan hebdo)
```

**Migrations existantes** : `create_domains.sql`, `create_habits.sql`
**Seeds** : `001_default_domains.sql` (5 domaines français)
**Dépendances** : Auth + Profile (existants dans le template)

**Critères de succès** :
- 500+ MAU
- Rétention D7 ≥ 20%
- 60%+ des actifs consultent le compteur ≥1x/semaine

**Gate → Phase 2** : Activation metric validé (3 habits × 7 jours → rétention D30) + compteur consulté

---

## Phase 2 — Le système connecté + IA interprète

**Objectif** : Transformer les utilisateurs retenus en Pro via budget temps complet, OKR, et IA qui interprète les données.
**IA** : Rôle 1 (interprète de données) + Rôle 2 (patterns configurables). Technique : requêtes SQL pré-construites → résultats formatés → API LLM (prompt structuré). Coût : ~0.01€/user/semaine.
**Scope** : 11 features. Complète le cockpit (tâches, routines, inbox), ajoute la profondeur (OKR, reviews), et introduit l'IA.

| # | Feature | Tables Supabase | Écrans Flutter | Score |
|---|---------|----------------|----------------|-------|
| F04 | **Tâches** | `tasks` (existante) | Liste tâches, Création rapide, Détail | 16/25 |
| F05 | **Routines** | `routines`, `routine_steps`, `routine_logs` (existantes) | Liste routines, Runner (timer), Création/édition | 17/25 |
| F08 | **Micro-récompenses** | — (logique locale) | Animations, haptic, messages de retour | 16/25 |
| F10 | **Inbox rapide** | `inbox_items` (existante) | Inbox capture + liste, Triage | 15/25 |
| F11 | **Budget temps complet** | `time_budgets` (nouvelle) | Objectifs heures/domaine, alertes, mode strict/flexible | 22/25 ⚠️ |
| F12 | **OKR + Key Results** | `okrs`, `key_results` (nouvelles) | Liste OKR, Détail + KRs, Création/édition | 17/25 |
| F13 | **Lien Habit → KR** | — (FK dans `habits`) | Auto-progression KR quand habit cochée | 17/25 |
| F16 | **Weekly Review guidée** | `reviews` (nouvelle) | Prompts structurés, suggestions basées sur F07 | 18/25 ⚠️ |
| F18 | **IA — Interprète** | `ai_insights` (nouvelle) | Bilans en langage naturel. "C'est la 3ème semaine où Santé est sous 3h" | 17/25 |
| F19 | **IA — Patterns** | `ai_patterns`, `user_pattern_configs` (nouvelles) | Bibliothèque patterns, activation/désactivation, résultats | 17/25 |
| F25 | **Partage de bilan** | — (Flutter share) | Screenshot optimisé stories/Twitter | 15/25 |

> ⚠️ F11 a un score de 22 mais est classé P2 volontairement : le compteur lecture seule (P1) doit frustrer avant de donner les commandes (P2 Pro → raison de payer).
> ⚠️ F16 a un score de 18 mais est classé P2 : le bilan auto F07 suffit pour le MVP.

**Migrations nouvelles** : `create_time_budgets.sql`, `create_okrs.sql`, `create_key_results.sql`, `create_reviews.sql`, `create_ai_insights.sql`, `create_ai_patterns.sql`

**IA — Rôle 1 : Interprète de données** :
- Requêtes SQL pré-construites (heures/domaine/semaine, tendances, comparaisons)
- Résultats formatés en JSON structuré
- Envoi à l'API LLM avec prompt template ("Tu es un data analyst. Voici les données d'un utilisateur...")
- LLM retourne des phrases actionnables affichées dans le bilan
- Exemples de sorties : "C'est la 3ème semaine où Santé est sous 3h. Les heures perdues vont dans Travail, surtout mardi/jeudi soir."

**IA — Rôle 2 : Patterns configurables** :
- Bibliothèque de 15-20 patterns pré-définis (corrélation A→B, meilleur/pire jour, heure optimale, effet weekend, tendance domaine, effet cascade, prédiction streak)
- L'utilisateur active les patterns qui l'intéressent
- Chaque pattern = 1 requête SQL + 1 template de prompt LLM
- Exécution hebdomadaire ou à la demande
- Exemples : "Quand je fais du sport le matin, je complète +23% d'habitudes."

**Critères de succès** :
- Conversion Free→Pro ≥ 3%
- MRR ≥ 3.000€
- ≥ 40% des Pro activent ≥3 patterns IA

**Gate → Phase 3** : Conversion Pro stable + churn Pro < 10%/mois + patterns IA consultés

---

## Phase 3 — L'intelligence actionnable

**Objectif** : IA conseiller (suggestions personnalisées), features de profondeur, viralité.
**IA** : Rôle 3 (conseiller actionnable). Passe de "voici ce qui se passe" à "voici ce que tu pourrais faire". Coût : ~0.03€/user/semaine.
**Scope** : 6 features. Profondeur du système + IA proactive.

| # | Feature | Tables Supabase | Écrans Flutter | Score |
|---|---------|----------------|----------------|-------|
| F27 | **IA — Conseiller** | `ai_recommendations` (nouvelle) | Suggestions contextuelles dans TodayView + bilan | 17/25 ⚠️ |
| F15 | **Blocs de temps** | `time_blocks` (nouvelle) | Vue timeline journée, deep work/shallow/perso | 15/25 |
| F20 | **Compensation mensuelle** | — (extension de `time_budgets`) | Rattrapage flexible du budget sur le mois | 14/25 |
| F21 | **Projets** | `projects` (nouvelle) | Groupes de tâches liés à OKR | 10/25 |
| F22 | **Monthly/Quarterly Review** | — (extension de `reviews`) | Bilan long terme, révision stratégique | 15/25 |
| F14 | **Thèmes par domaine** | `themes` (nouvelle) | Sous-catégories (Santé → Fitness, Nutrition, Sommeil) | 13/25 |

> ⚠️ F27 a un score P2 (17) mais est classé P3 : nécessite les patterns détectés + 6 mois de données.

**IA — Rôle 3 : Conseiller actionnable** :
- Même stack technique (SQL + LLM) que les rôles 1 et 2
- Ajoute une couche de recommandation : "Voici ce qui se passe" → "Voici ce que tu pourrais faire"
- Suggestions spécifiques et personnalisées, basées sur les patterns détectés + données individuelles
- Exemples : "Tu perds tes habitudes Santé le mercredi. Déplace ton sport du soir au matin ce jour-là — tu complètes 90% de tes habitudes matin vs 45% le soir."
- L'utilisateur peut accepter, snooze, ou rejeter chaque suggestion

**Critères de succès** :
- MRR ≥ 10.000€
- Viralité K-factor > 0.3
- 10.000+ MAU

---

## Backlog — Peut-être jamais

| # | Feature | Score | Pourquoi pas maintenant |
|---|---------|-------|------------------------|
| F23 | Deep links apps | 9/25 | Aucun impact sur le core. Gadget |
| F24 | Sync Google Calendar | 9/25 | Intégration lourde (OAuth), le calendrier coexiste |
| F26 | Multi-langue | 8/25 | Le marché francophone suffit pour valider |
| F17 | Calendrier unifié | 13/25 | Google Calendar coexiste, coût technique élevé |

---

## Stratégie IA — Résumé

> L'IA dans LifeFlow n'est PAS un chatbot, PAS un coach, PAS une mascotte.
> C'est un **data analyst personnel** qui a accès aux données de vie de l'utilisateur.
> Voir `docs/business-model.md` §9.5 pour la stratégie complète.

| Phase | Rôle IA | Technique | Coût/user/semaine |
|-------|---------|-----------|-------------------|
| P1 | **Zéro IA** | Dart + SQL (if/else, arithmétique) | 0€ |
| P2 | **Interprète + Patterns** | SQL pré-construites → LLM API (prompt structuré) | ~0.01€ |
| P3 | **Conseiller actionnable** | Même stack + logique de recommandation | ~0.03€ |

---

## Règle de progression

> **On ne commence PAS Phase N+1 tant que Phase N n'est pas :**
> 1. `supabase db reset` passe sans erreur
> 2. `dart analyze` passe sans erreur
> 3. Tous les écrans de la phase sont fonctionnels
> 4. Les critères de succès (métriques) montrent une traction suffisante
> 5. La gate de passage est validée

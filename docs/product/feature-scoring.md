# Feature Scoring — LifeFlow

> *Généré le 19 Février 2026 — basé sur le Business Model v3.0 et les Personas (Amadou, Camille)*

---

## Grille de scoring

| Axe | Question | 1 (faible) | 5 (fort) |
|-----|----------|------------|----------|
| **Impact** | Résout une douleur forte du persona primaire ? | Nice-to-have | Ne télécharge pas sans |
| **Rétention** | Donne une raison de revenir demain ? | Usage unique/rare | Usage quotidien |
| **Différenciation** | Nous distingue de la concurrence ? | 10 apps font ça | Personne ne fait ça |
| **Faisabilité** | Constructible correctement en 1-2 semaines ? | 2+ mois | 1 semaine |
| **Valeur croissante** | Meilleure avec le temps/les données ? | Aussi utile J1 que J100 | Exponentiellement meilleure |

| Phase | Score minimum |
|-------|--------------|
| **Phase 1 (MVP)** | ≥ 18/25 |
| **Phase 2** | ≥ 14/25 |
| **Phase 3** | ≥ 10/25 |
| **Backlog** | < 10/25 |

---

## Scoring détaillé

| # | Feature | Impact | Rétention | Différen. | Faisab. | Valeur+ | **TOTAL** | Phase | Justification clé |
|---|---------|--------|-----------|-----------|---------|---------|-----------|-------|--------------------|
| F01 | TodayView contextuel | 5 | 5 | 4 | 4 | 3 | **21** | P1 | C'est la première chose vue chaque jour. Matin/midi/soir = seul à faire ça |
| F02 | Domaines de vie | 5 | 4 | 5 | 5 | 3 | **22** | P1 | Fondation de TOUT. Sans domaines, pas de cascade, pas de compteur |
| F03 | Habitudes | 5 | 5 | 2 | 4 | 4 | **20** | P1 | Beaucoup d'apps font ça, mais usage quotidien #1 + valeur croissante (streaks) |
| F04 | Tâches | 4 | 4 | 1 | 5 | 2 | **16** | P2 | Todoist fait mieux. Mais nécessaire pour un cockpit complet. Repoussable en P2 |
| F05 | Routines | 4 | 4 | 3 | 3 | 3 | **17** | P2 | Complexe à construire (timer, étapes). Fabulous le fait. Pas vital pour le MVP |
| F06 | Compteur temps/domaine | 5 | 5 | 5 | 3 | 5 | **23** | P1 | **LA killer feature.** Personne ne fait ça. Valeur croissante max (données = irremplaçable) |
| F07 | Bilan hebdo simplifié | 5 | 4 | 4 | 4 | 4 | **21** | P1 | Le "aha moment" du persona. Premier bilan = prise de conscience. Partageable = viralité |
| F08 | Micro-récompenses | 3 | 4 | 2 | 5 | 2 | **16** | P2 | Impact modéré mais facile à faire. Renforce les 2 premières semaines |
| F09 | Streak freeze | 4 | 5 | 3 | 5 | 2 | **19** | P1 | Anti-churn critique. Semaine 3 = survie. Le streak cassé = mort du produit |
| F10 | Inbox rapide | 3 | 3 | 2 | 5 | 2 | **15** | P2 | Capture rapide utile mais pas la raison pour laquelle on télécharge |
| F11 | Budget temps complet | 5 | 5 | 5 | 2 | 5 | **22** | P2 | Raison de payer Pro. Mais complexe (objectifs, alertes, compensation) → P2 |
| F12 | OKR + Key Results | 3 | 3 | 4 | 3 | 4 | **17** | P2 | Puissant mais abstrait pour le persona. Nécessite que les domaines soient installés |
| F13 | Lien Habit → KR | 3 | 3 | 4 | 3 | 4 | **17** | P2 | Dépend de F12 (OKR). Connecte le quotidien au trimestriel |
| F14 | Thèmes par domaine | 2 | 2 | 3 | 4 | 2 | **13** | P3 | Enrichissement. Santé → Fitness/Nutrition/Sommeil. Pas vital |
| F15 | Blocs de temps | 3 | 3 | 3 | 3 | 3 | **15** | P2 | Utile mais Google Calendar existe. Pas notre différenciateur |
| F16 | Weekly Review guidée | 4 | 4 | 3 | 3 | 4 | **18** | P2 | ⚠️ Score 18 mais **repoussé P2** : le bilan auto (F07) suffit pour le MVP. La review guidée dépend de F07 et nécessite plus de données |
| F17 | Calendrier unifié | 3 | 3 | 2 | 2 | 3 | **13** | P3 | Lourd à construire. Google Calendar coexiste bien. Pas prioritaire |
| F18 | IA — Interprète de données | 3 | 3 | 4 | 3 | 4 | **17** | P2 | Requêtes SQL pré-construites → résultats formatés → LLM → bilans en phrases actionnables. Ex: "C'est la 3ème semaine où Santé est sous 3h." Coût ~0.01€/user/semaine |
| F19 | IA — Patterns configurables | 3 | 3 | 4 | 2 | 5 | **17** | P2 | Bibliothèque de 15-20 patterns pré-définis que l'user active (corrélation A→B, meilleur/pire jour, effet weekend, etc.). SQL queries → LLM interprète. Besoin de 3+ mois de données |
| F27 | IA — Conseiller actionnable | 3 | 3 | 5 | 1 | 5 | **17** | P3 | Passe de "voici ce qui se passe" à "voici ce que tu pourrais faire". Suggestions spécifiques basées sur les patterns détectés. ~0.03€/user/semaine |
| F20 | Compensation mensuelle | 2 | 2 | 4 | 3 | 3 | **14** | P2 | Extension du budget temps. Pas vital seul |
| F21 | Projets | 2 | 2 | 1 | 3 | 2 | **10** | P3 | Todoist fait mieux. Pas notre bataille |
| F22 | Monthly/Quarterly Review | 3 | 2 | 3 | 3 | 4 | **15** | P2 | Nécessite 1-3 mois de données. Impossible en MVP |
| F23 | Deep links apps | 1 | 1 | 2 | 4 | 1 | **9** | Backlog | Nice-to-have. Aucun impact sur la rétention |
| F24 | Sync calendrier | 2 | 2 | 1 | 2 | 2 | **9** | Backlog | Intégration lourde, valeur marginale. Le calendrier coexiste |
| F25 | Partage de bilan | 4 | 2 | 3 | 4 | 2 | **15** | P2 | Fort pour l'acquisition virale mais pas pour la rétention quotidienne |
| F26 | Multi-langue | 2 | 1 | 1 | 3 | 1 | **8** | Backlog | Expansion future. Le marché francophone suffit pour commencer |

---

## Classement par score

### 🟢 Phase 1 — MVP (score ≥ 18)

| Rang | Feature | Score | Raison d'être en Phase 1 |
|------|---------|-------|--------------------------|
| 1 | **F06 — Compteur temps/domaine** | **23** | LA raison d'exister. Aha moment. Lock-in par données. Personne ne le fait |
| 2 | **F02 — Domaines de vie** | **22** | Fondation architecturale. Tout le reste en dépend |
| 3 | **F01 — TodayView contextuel** | **21** | Premier écran quotidien. Différencie l'expérience matin/soir |
| 4 | **F07 — Bilan hebdo simplifié** | **21** | Aha moment du persona + artefact partageable (viralité) |
| 5 | **F03 — Habitudes** | **20** | Usage quotidien #1. Base du compteur temps |
| 6 | **F09 — Streak freeze** | **19** | Anti-churn semaine 3. Sans ça, on perd 50%+ des users |

**→ 6 features en Phase 1.** Scope ultra-serré : voir ses domaines, faire ses habitudes, voir où va son temps, ne pas décrocher.
> **F16 (Weekly Review, score 18)** repoussée en P2 : le bilan auto F07 suffit pour le MVP. La review guidée est une extension naturelle qui viendra enrichir P2.

### 🟡 Phase 2 — Le système connecté + IA interprète (score 14-18)

| Rang | Feature | Score | Raison d'être en Phase 2 |
|------|---------|-------|--------------------------|
| 7 | F16 — Weekly Review guidée | **18** | ⚠️ Score P1 mais repoussé : le bilan auto F07 suffit pour le MVP |
| 8 | F12 — OKR + Key Results | 17 | La couche "objectifs". Connecte le quotidien au trimestriel |
| 9 | F13 — Lien Habit→KR | 17 | Automatise la progression. Dépend de F12 |
| 10 | F18 — IA interprète de données | 17 | SQL → LLM → bilans en phrases. Raison de payer Pro (insights personnalisés) |
| 11 | F19 — IA patterns configurables | 17 | 15-20 patterns pré-définis, l'user choisit. Différenciateur puissant |
| 12 | F05 — Routines | 17 | Structure la journée. Timer + étapes = complexe |
| 13 | F04 — Tâches | 16 | Complète le cockpit. Todoist coexiste en attendant |
| 14 | F08 — Micro-récompenses | 16 | Renforce l'engagement initial |
| 15 | F15 — Blocs de temps | 15 | Deep work / shallow. Utile mais pas urgent |
| 16 | F25 — Partage de bilan | 15 | Viralité. Screenshot optimisé stories/Twitter |
| 17 | F22 — Monthly Review | 15 | Nécessite 1+ mois de données |
| 18 | F10 — Inbox rapide | 15 | Capture rapide. Renforce l'usage quotidien |
| 19 | F11 — Budget temps complet | **22** | ⚠️ **Exception : score 22 mais classé P2 car c'est la raison de payer Pro. Le compteur lecture seule (P1) doit frustrer avant de donner les commandes (P2)** |
| 20 | F20 — Compensation mensuelle | 14 | Extension du budget. Pas vital seul |

### 🔴 Phase 3 — L'intelligence actionnable (score 10-17)

| Rang | Feature | Score | Raison d'être en Phase 3 |
|------|---------|-------|--------------------------|
| 21 | F27 — IA conseiller actionnable | 17 | ⚠️ Score P2 mais classé P3 : nécessite patterns détectés + données longues. Passe de "voici ce qui se passe" → "voici ce que tu pourrais faire" |
| 22 | F14 — Thèmes par domaine | 13 | Enrichissement. Pas vital |
| 23 | F17 — Calendrier unifié | 13 | Google Calendar coexiste |
| 24 | F21 — Projets | 10 | Todoist fait mieux |

### ⚫ Backlog — Peut-être jamais (score < 10)

| Feature | Score | Pourquoi pas maintenant |
|---------|-------|------------------------|
| F23 — Deep links apps | 9 | Aucun impact sur le core. Gadget |
| F24 — Sync calendrier | 9 | Intégration lourde, Google Calendar coexiste |
| F26 — Multi-langue | 8 | Le marché francophone suffit pour valider le produit |

---

## Analyse croisée

### Features vitales (Impact ≥ 4 ET Rétention ≥ 4)

| Feature | Impact | Rétention | Phase |
|---------|--------|-----------|-------|
| F06 — Compteur temps | 5 | 5 | P1 ✅ |
| F01 — TodayView | 5 | 5 | P1 ✅ |
| F02 — Domaines | 5 | 4 | P1 ✅ |
| F03 — Habitudes | 5 | 5 | P1 ✅ |
| F07 — Bilan hebdo | 5 | 4 | P1 ✅ |
| F11 — Budget temps complet | 5 | 5 | P2 (stratégie monétisation) |

**→ Toutes les features vitales sont en P1 sauf le budget temps complet (volontairement en P2 pour la conversion Pro).**

### Features pièges (Impact ≤ 2 mais Faisabilité = 5)

Aucune identifiée. Les features faciles ont au moins un impact modéré. Bon signe.

### Features moonshot (Différenciation = 5 mais Faisabilité ≤ 2)

| Feature | Diff. | Faisab. | Stratégie |
|---------|-------|---------|-----------|
| F06 — Compteur temps | 5 | 3 | En P1 malgré la complexité technique. C'est le cœur |
| F11 — Budget temps complet | 5 | 2 | P2. Le compteur lecture seule (P1) est plus simple |

---

## Dépendances

```
F02 (Domaines) ← TOUT le reste en dépend

F03 (Habitudes) → nécessite → F02 (Domaines)
F06 (Compteur temps) → nécessite → F02 + F03 (+ F05 routines si incluses)
F07 (Bilan hebdo) → nécessite → F06 (Compteur)
F09 (Streak freeze) → nécessite → F03 (Habitudes)
F11 (Budget temps) → nécessite → F06 (Compteur)
F12 (OKR) → nécessite → F02 (Domaines)
F13 (Lien Habit→KR) → nécessite → F03 + F12
F16 (Weekly Review) → nécessite → F07 (Bilan hebdo)
F18 (IA interprète) → nécessite → F06 + 2 mois de données
F19 (IA patterns) → nécessite → F06 + 3 mois de données
F20 (Compensation) → nécessite → F11 (Budget temps)
F27 (IA conseiller) → nécessite → F19 (Patterns) + 6 mois de données
F14 (Thèmes) → nécessite → F02 (Domaines)
```

**Ordre d'implémentation P1** :
```
F02 (Domaines) → F03 (Habitudes) → F09 (Streak freeze) → F06 (Compteur temps)
→ F01 (TodayView) → F07 (Bilan hebdo)
```

---

## Décision finale du créateur

| Feature déplacée | De → Vers | Justification |
|-----------------|-----------|---------------|
| F04 — Tâches | P1 (BM) → **P2** | Le scoring montre que les tâches ne sont pas différenciantes. Amadou et Camille peuvent utiliser Apple Rappels/Todoist en parallèle le premier mois |
| F05 — Routines | P1 (BM) → **P2** | Score 17. Complexe à construire (timer, étapes). Les habits suffisent pour le MVP |
| F10 — Inbox rapide | P1 (BM) → **P2** | Utile mais pas vital. Capture rapide = créer une habit ou tâche directement |
| F08 — Micro-récompenses | P1 (BM) → **P2** | Animation simple en P1 (haptic quand on coche), le système complet en P2 |
| F11 — Budget temps | ⚠️ Score 22 → **Reste P2** | Stratégie monétisation : le compteur lecture seule (P1) frustre → budget complet (P2 Pro) convertit |
| F16 — Weekly Review | P1 (score 18) → **P2** | Le bilan auto (F07) suffit pour le MVP. La review guidée enrichira le bilan en P2 |

> **Note** : le BM original avait 10 features en Phase 1. Le scoring en garde **6**. C'est un MVP ultra-serré, focusé, et réaliste pour un solo dev.

---

## Résumé exécutif

- **6 features en Phase 1** — scope ultra-serré, atteignable en 2-3 mois solo
- **LA feature qui fait ou défait le produit** : F06 — Compteur temps/domaine (score 23/25). Si les gens ne regardent pas leur temps, le produit n'a pas de raison d'exister (hypothèse H1)
- **Feature la plus dure à scorer** : F04 — Tâches. Impact modéré (Todoist fait mieux) mais nécessaire pour le cockpit complet. Décision : repoussée en P2
- **Stratégie IA en 3 rôles** : P1 = zéro IA (intelligence structurelle). P2 = Interprète de données (SQL→LLM) + Patterns configurables (15-20 pré-définis). P3 = Conseiller actionnable (suggestions personnalisées). Coût estimé : 0.01-0.03€/user/semaine. Voir `business-model.md` §9.5 pour les détails complets
- **Trou identifié** : aucune feature ne couvre l'onboarding proprement dit. Il faut ajouter une micro-feature "Onboarding 3 taps" (sélection domaines + suggestions habits) comme prérequis technique de P1 — ce n'est pas une feature produit mais un flux d'initialisation critique

# LifeFlow — Phases Roadmap

**Created**: 2026-02-19
**Status**: Active

## Overview

4 phases progressives. Chaque phase est une spec autonome livrable.
L'ordre est strict : chaque phase dépend de la précédente.

```
Phase 1 (MVP)         Phase 2 (Profondeur)    Phase 3 (Intelligence)   Phase 4 (Avancé)
─────────────         ────────────────────     ──────────────────────   ─────────────────
Domaines              Projets                  IA Level 1               IA Level 2
Habitudes             OKR / Key Results        InsightCards             Calendrier sync
Routines              Reviews                  Suggestions patterns     Push notifications
Tâches                Thèmes temporels         Budget temps             Gamification
Inbox GTD             Blocs de temps                                    Partage / export
Vue Aujourd'hui       Stats de base                                     Monétisation
```

## Phase 1 — Fondations Quotidiennes (MVP)

**Objectif** : L'utilisateur peut structurer sa journée complète et capturer ses idées.

**Livrable** : Habitudes + Routines + Tâches + Inbox + Home — une journée entière gérable.

| Feature | Tables Supabase | Écrans Flutter |
|---------|----------------|----------------|
| Domaines | `domains` | Liste domaines (settings), Domain picker (bottom sheet), Onboarding step 2 |
| Habitudes | `habits`, `habit_logs` | Liste habitudes, Détail habitude, Création/édition, Check quotidien |
| Routines | `routines`, `routine_steps`, `routine_logs` | Liste routines, Détail routine, Création/édition, Runner (timer pas-à-pas) |
| Tâches | `tasks` | Liste tâches, Création rapide, Détail tâche |
| Inbox GTD | `inbox_items` | Inbox (capture + liste), Triage (→ habit/tâche/routine/supprimer) |
| Vue Aujourd'hui | — (agrège les autres) | Home : habitudes du jour, routine active, tâches due today, inbox count |

**Migrations** : ~7 fichiers SQL
**Dépendances** : Auth + Profile (déjà existants dans le template)

---

## Phase 2 — Profondeur & Sens

**Objectif** : L'utilisateur peut se fixer des objectifs, organiser en projets, et prendre du recul.

**Livrable** : OKR + Projets + Reviews + Blocs de temps + Stats — vision long terme.

**Prérequis** : Phase 1 complète.

| Feature | Tables Supabase | Écrans Flutter |
|---------|----------------|----------------|
| Projets | `projects` | Liste projets, Détail projet (tâches groupées), Création/édition |
| OKR | `okrs`, `key_results` | Liste OKR, Détail OKR + KRs, Création/édition |
| Reviews | `reviews` | Review quotidienne (soir), Review hebdo (dimanche), Review mensuelle |
| Thèmes | `themes` | Gestion thèmes, Thème actif (overlay sur domaines) |
| Blocs de temps | `time_blocks` | Vue timeline journée, Création/édition bloc, Lien vers habit/tâche/routine |
| Stats de base | — (calculs locaux) | Dashboard stats, Taux complétion par domaine, Graphes 7/30 jours, Streaks |

**Migrations** : ~5 fichiers SQL

---

## Phase 3 — Intelligence

**Objectif** : L'app commence à comprendre l'utilisateur et renvoie des observations utiles.

**Livrable** : IA locale + InsightCards + Suggestions — l'app devient intelligente.

**Prérequis** : Phase 2 complète (stats nécessaires pour alimenter l'IA).

| Feature | Tables Supabase | Écrans Flutter |
|---------|----------------|----------------|
| IA Level 1 | — (calculs locaux Flutter) | Service d'analyse locale : moyennes, tendances, détection patterns |
| InsightCards | `insight_cards` | Feed Insights, Card accept/snooze/dismiss |
| Suggestions | — (générées par IA L1) | Intégrées dans le feed InsightCards |
| Budget temps | `time_budgets` | Vue budget par domaine, Temps réel vs souhaité, Graphe écart |

**Migrations** : ~2 fichiers SQL

---

## Phase 4 — IA Avancée & Écosystème

**Objectif** : Produit complet avec IA cloud, intégrations externes, et monétisation.

**Livrable** : GPT-4o + Calendrier + Notifications + Gamification + Paiement.

**Prérequis** : Phase 3 complète (IA L1 fonctionnelle, InsightCards existantes).

| Feature | Tables Supabase | Composant principal |
|---------|----------------|---------------------|
| IA Level 2 | — (FastAPI + GPT-4o) | Endpoint FastAPI, analyse croisée, corrélations complexes |
| Calendrier | `calendar_syncs` | Sync Google/Apple Calendar, vue intégrée avec blocs de temps |
| Push notifications | — (Supabase Edge Functions) | Rappels habitudes, routine matin, review soir |
| Gamification | `achievements`, `milestones` | Badges, milestones, visualisation progression long terme |
| Partage | — (Flutter share) | Export image streak/habitude, partage social |
| Monétisation | `subscriptions` (existe déjà) | Paywall Moneroo, plans, gestion abonnement |

**Migrations** : ~3 fichiers SQL

---

## Règle de progression

> **On ne commence PAS Phase N+1 tant que Phase N n'est pas :**
> 1. `supabase db reset` passe sans erreur
> 2. `dart analyze` passe sans erreur
> 3. Tous les écrans de la phase sont fonctionnels
> 4. Les user stories P1 de la spec sont validées

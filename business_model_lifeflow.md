# 📅 LifeFlow - Document de Vision Produit

**Nom du Projet :** LifeFlow
**Tagline :** *"Vis selon tes valeurs. Chaque jour compte."*
**Version :** 2.0
**Date :** 3 Février 2026
**Stack :** Flutter + Supabase + OpenAI

---

## Table des Matières

1. [Résumé Exécutif](#1-résumé-exécutif)
2. [Le Problème](#2-le-problème)
3. [La Solution](#3-la-solution)
4. [Analyse Concurrentielle](#4-analyse-concurrentielle)
5. [Features Détaillées](#5-features-détaillées)
6. [Interfaces Utilisateur](#6-interfaces-utilisateur)
7. [Le Système de Vie](#7-le-système-de-vie)
8. [Budget Temps par Domaine](#8-budget-temps-par-domaine)
9. [L'IA Coach](#9-lia-coach)
10. [Intégrations Apps](#10-intégrations-apps)
11. [Architecture Technique](#11-architecture-technique)
12. [Modèle Économique](#12-modèle-économique)
13. [Projections de Marché](#13-projections-de-marché)
14. [Go-to-Market](#14-go-to-market)
15. [Risques et Mitigations](#15-risques-et-mitigations)
16. [Roadmap](#16-roadmap)

---

## 1. Résumé Exécutif

**LifeFlow** est un système de vie complet qui connecte ta vision à long terme à tes actions quotidiennes. Contrairement aux apps de productivité fragmentées, LifeFlow crée un **fil conducteur** entre tes valeurs, tes objectifs, tes habitudes et tes tâches, tout en mesurant le temps investi dans chaque domaine de vie.

### Le Problème
Les gens ont des dizaines d'apps : une pour les habits, une pour les tâches, une pour les objectifs. Rien n'est connecté. Résultat : on s'agite sans progresser vers ce qui compte vraiment, et on ignore combien de temps on consacre réellement à chaque aspect de sa vie.

### La Solution
Une app qui :
- **Part de tes valeurs** : Qu'est-ce qui compte vraiment pour toi ?
- **Structure par thèmes** : Domaines → Thèmes → Objectifs → Actions
- **Automatise ta journée** : Habits, routines, blocs de temps
- **Mesure tout** : Stats, temps par domaine, budget temps
- **T'accompagne** : IA qui détecte les patterns et suggère

### L'Opportunité
- **Marché mondial :** $9 milliards pour les apps de productivité en 2024
- **Gap technologique :** Aucune app ne connecte valeurs → objectifs → temps investi
- **Timing parfait :** Post-COVID, les gens cherchent l'intentionnalité

---

## 2. Le Problème

### 2.1 Pourquoi les Gens S'éparpillent

| Problème | Cause | Conséquence |
|---|---|---|
| **Trop d'apps** | Habits ici, tâches là, objectifs ailleurs | Fatigue de gestion |
| **Pas de "pourquoi"** | On coche sans savoir pourquoi | Perte de motivation |
| **Objectifs déconnectés** | OKR d'un côté, quotidien de l'autre | Impression de stagner |
| **Temps invisible** | On ignore où va notre temps | Déséquilibre de vie |
| **Culpabilité** | Streaks brisés, rouge partout | Abandon |

### 2.2 Le Profil Type : "Thomas l'Ambitieux"

> Thomas, 30 ans, entrepreneur. Il utilise Notion, Todoist, Habitica et un calendrier.
>
> **Son problème :** Il a des objectifs ambitieux mais il passe ses journées en mode réactif. Il coche des tâches mais ne sent pas qu'il avance. Il ne sait pas combien de temps il consacre réellement à sa famille vs son travail.
>
> **Ce dont il a besoin :** Un système unique où il voit "Cette tâche contribue à mon OKR, qui contribue à mon objectif annuel. Cette semaine j'ai passé 45h sur Travail mais seulement 2h sur Famille."

### 2.3 Les Apps Actuelles Échouent

| App | Ce qu'elle fait | Ce qu'elle ne fait PAS |
|---|---|---|
| **Todoist** | Gérer des tâches | Connecter aux objectifs, mesurer temps |
| **Habitica** | Gamifier les habits | Lier aux valeurs, budgets temps |
| **Notion** | Tout personnaliser | Mobile-first, simple, temps par domaine |
| **Fabulous** | Routines guidées | Objectifs, tâches, stats temps |
| **Toggl** | Tracker le temps | Lier aux objectifs et valeurs |

---

## 3. La Solution

### 3.1 Le Concept : "Le Système de Vie Intégré"

LifeFlow n'est pas une app de plus. C'est **le hub central** qui :
- Contient ta vision et tes valeurs
- Structure tes objectifs par domaines et thèmes
- Génère ton plan du jour avec blocs de temps
- Mesure le temps investi par domaine
- Connecte tes autres apps (SpiritFlow, IronFlow...)

### 3.2 Les 7 Niveaux de LifeFlow

| Niveau | Contenu | Fréquence |
|---|---|---|
| **1. Fondation** | Valeurs, Vision 10 ans, Domaines de vie | Annuel |
| **2. Thèmes** | Sous-catégories par domaine | Permanent |
| **3. Stratégie** | Objectifs annuels, OKR trimestriels | Trimestriel |
| **4. Système** | Habits liés aux KR, Routines, Blocs de temps | Permanent |
| **5. Exécution** | Plan du jour, Tâches dans blocs, Calendrier unifié | Quotidien |
| **6. Budget Temps** | Objectifs heures par domaine, compensation mensuelle | Hebdo/Mensuel |
| **7. Revue** | Daily, Weekly, Monthly, Quarterly | Récurrent |

---

## 4. Analyse Concurrentielle

### 4.1 Tableau Comparatif

| Feature | Todoist | Habitica | Notion | Fabulous | Toggl | **LifeFlow** |
|---|---|---|---|---|---|---|
| Tâches | ✅ | ⚠️ | ✅ | ❌ | ❌ | ✅ |
| Habits | ❌ | ✅ | ⚠️ | ✅ | ❌ | ✅ |
| Routines | ❌ | ❌ | ⚠️ | ✅ | ❌ | ✅ |
| OKR | ❌ | ❌ | ⚠️ | ❌ | ❌ | ✅ |
| **Thèmes par domaine** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Lien Habit→KR** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Blocs de temps** | ❌ | ❌ | ⚠️ | ⚠️ | ✅ | ✅ |
| **Tâches dans blocs** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Budget temps/domaine** | ❌ | ❌ | ❌ | ❌ | ⚠️ | ✅ |
| **Calendrier unifié** | ❌ | ❌ | ⚠️ | ❌ | ❌ | ✅ |
| Deep links apps | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| IA insights | ⚠️ | ❌ | ⚠️ | ❌ | ❌ | ✅ |

### 4.2 Positionnement

**LifeFlow = Notion × Todoist × Habitica × Toggl × Coach IA**

---

## 5. Features Détaillées

### 5.1 Module : Fondation

| # | Feature | Description | Priorité |
|---|---|---|---|
| 1.1 | Valeurs | Définir et prioriser ses valeurs | P0 |
| 1.2 | Vision 10 ans | Décrire sa vie idéale par domaine | P1 |
| 1.3 | Domaines de vie | 8 domaines avec score santé | P0 |
| 1.4 | **Thèmes par domaine** | Sous-catégories (ex: Spirituel → Consécration, Service) | P0 |
| 1.5 | Onboarding guidé | Questionnaire pour définir tout ça | P0 |

### 5.2 Module : Objectifs & OKR

| # | Feature | Description | Priorité |
|---|---|---|---|
| 2.1 | Objectifs annuels | Par domaine et thème | P0 |
| 2.2 | OKR trimestriels | Objectif + Key Results | P0 |
| 2.3 | **Lien OKR → Habits intelligent** | Habit contribue à un KR, calcul auto progression | P0 |
| 2.4 | Lien OKR → Projets | Projet contribue à un KR | P0 |
| 2.5 | **Alerte rythme KR** | "Tu es en retard sur ce KR" | P1 |
| 2.6 | Révision trimestrielle | Guidée pour ajuster | P1 |

### 5.3 Module : Habitudes

| # | Feature | Description | Priorité |
|---|---|---|---|
| 3.1 | Créer habit | Nom, fréquence, rappel, durée | P0 |
| 3.2 | **Domaine associé** | Chaque habit compte dans un domaine | P0 |
| 3.3 | **Lien KR** | Habit → Key Result avec progression auto | P0 |
| 3.4 | Tracker quotidien | Check / Uncheck | P0 |
| 3.5 | Streaks | Compteur de jours consécutifs | P0 |
| 3.6 | Lien app externe | Habit → Ouvre SpiritFlow | P1 |
| 3.7 | Stats détaillées | Taux par jour/semaine/mois | P1 |

### 5.4 Module : Routines

| # | Feature | Description | Priorité |
|---|---|---|---|
| 4.1 | Créer routine | Séquence d'étapes | P0 |
| 4.2 | Durée par étape | Timer pour chaque | P0 |
| 4.3 | **Tâches dans routine** | Associer tâches à une étape | P0 |
| 4.4 | Deep links | Étape ouvre une autre app | P1 |
| 4.5 | **Bilan routine** | Temps réel, étapes complétées | P1 |
| 4.6 | Stats completion | % par routine | P1 |

### 5.5 Module : Blocs de Temps

| # | Feature | Description | Priorité |
|---|---|---|---|
| 5.1 | Créer bloc | Deep work, Shallow, Meeting, Personal | P0 |
| 5.2 | **Domaine associé** | Bloc compte dans un domaine | P0 |
| 5.3 | **Tâches dans bloc** | Assigner tâches au bloc | P0 |
| 5.4 | **Tâches ajoutées pendant** | Marquer les imprévues | P1 |
| 5.5 | **Bilan de bloc** | Durée réelle, focus, tâches faites | P1 |
| 5.6 | Lien projet | Focus sur quel projet | P0 |

### 5.6 Module : Tâches & Projets

| # | Feature | Description | Priorité |
|---|---|---|---|
| 6.1 | Créer tâche | Titre, date, priorité, durée estimée | P0 |
| 6.2 | **Domaine associé** | Via projet ou direct | P0 |
| 6.3 | Priorités | P1, P2, P3 | P0 |
| 6.4 | Contextes | @travail, @maison, @courses | P0 |
| 6.5 | **Assignation bloc/routine** | Tâche dans un conteneur | P0 |
| 6.6 | Durée réelle | Chronométrage optionnel | P1 |
| 6.7 | Projets | Groupes de tâches liés à OKR | P0 |

### 5.7 Module : Calendrier Unifié

| # | Feature | Description | Priorité |
|---|---|---|---|
| 7.1 | Vue jour | Tout visible : routines, blocs, tâches, habits | P0 |
| 7.2 | Vue semaine | Aperçu de la semaine | P0 |
| 7.3 | Légende couleur | Par type d'élément | P0 |
| 7.4 | Drag & drop | Réorganiser | P1 |
| 7.5 | Sync calendrier externe | Google, iCal | P2 |

### 5.8 Module : Budget Temps

| # | Feature | Description | Priorité |
|---|---|---|---|
| 8.1 | **Objectif heures/domaine** | Ex: 7h/sem sur Spirituel | P0 |
| 8.2 | **Mode strict vs flexible** | Semaine fixe ou mois répartissable | P0 |
| 8.3 | **Tracking automatique** | Depuis habits, blocs, tâches, routines | P0 |
| 8.4 | **Vue semaine** | Heures par domaine cette semaine | P0 |
| 8.5 | **Vue mois avec compensation** | Rattrapage possible | P1 |
| 8.6 | **Alertes mi-mois** | "Tu es en retard sur X" | P1 |
| 8.7 | **Suggestions IA** | "Bloque 2h ce weekend pour rattraper" | P1 |

### 5.9 Module : Revue

| # | Feature | Description | Priorité |
|---|---|---|---|
| 9.1 | Daily Review | Bilan du soir (5 min) | P0 |
| 9.2 | Weekly Review | Bilan semaine + temps par domaine | P0 |
| 9.3 | Monthly Review | Bilan mois + OKR + budget temps | P1 |
| 9.4 | Quarterly Review | Révision stratégique | P1 |
| 9.5 | Prompts guidés | Questions pour réfléchir | P0 |

---

## 6. Interfaces Utilisateur

### 6.1 Dashboard Principal

```
┌─────────────────────────────────────────┐
│  ≡  LIFEFLOW                   👤 Thomas│
├─────────────────────────────────────────┤
│                                         │
│  ☀️ Bonjour Thomas !                    │
│  Lundi 3 Février | Semaine 5            │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ ⏱️ TEMPS AUJOURD'HUI            │    │
│  │ 💼 5h  ⛪ 1h  💪 1h  👨‍👩‍👧‍👦 0h      │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🎯 PRIORITÉ #1                  │    │
│  │ "Implémenter backlinks Bible"   │    │
│  │  📁 SpiritFlow | 🎯 OKR: MVP   │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🔄 HABITUDES         3/5 (60%) │    │
│  │ ☑ Temps avec Dieu    🔥 23j    │    │
│  │ ☑ Sport              🔥 12j    │    │
│  │ ◻ Deep Work 2h                 │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 📊 BUDGET TEMPS SEMAINE         │    │
│  │ ⛪ ████░░░ 5h/7h     ⚠️        │    │
│  │ 💪 ██████░ 6h/5h     ✅        │    │
│  │ 💼 ████████ 38h/40h  ✅        │    │
│  └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│  🏠     📅     ✅     📊     ⚙️        │
│ Home  Calendar Tasks  Stats  Settings  │
└─────────────────────────────────────────┘
```

### 6.2 Calendrier Unifié

```
┌─────────────────────────────────────────────────────────────────────┐
│  📅 LUNDI 3 FÉVRIER                                   Vue: Jour ▼  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  05:30 ┃ 🌅 ROUTINE MATIN (90 min)           ⛪ 30min 💪 45min     │
│        ┃ ├─ ☑ Réveil + Hydratation                                 │
│        ┃ ├─ ☑ Temps avec Dieu → SpiritFlow                        │
│        ┃ │   └─ 📝 "Méditer Jean 8" ✅                            │
│        ┃ └─ ◻ Sport → IronFlow                                     │
│  07:00 ┃─────────────────────────────────────────────────────────  │
│        ┃                                                            │
│  08:00 ┃ 🧠 DEEP WORK BLOC (3h)               💼 Travail           │
│        ┃ 📁 Focus: Projet SpiritFlow                               │
│        ┃ ├─ ◻ Backlinks Bible (2h)            🔴 P1               │
│        ┃ └─ ◻ Tests unitaires (1h)            🔴 P1               │
│  11:00 ┃─────────────────────────────────────────────────────────  │
│        ┃                                                            │
│  11:15 ┃ 📞 Appel client (30 min)             💼 Travail           │
│  11:45 ┃─────────────────────────────────────────────────────────  │
│        ┃                                                            │
│  13:30 ┃ 📧 SHALLOW WORK BLOC (2h)            💼 Travail           │
│        ┃ ├─ ◻ Répondre emails                  🟡 P2               │
│        ┃ └─ ◻ Review PR équipe                🟡 P2               │
│  15:30 ┃─────────────────────────────────────────────────────────  │
│        ┃                                                            │
│  15:30 ┃ 🔄 HABIT: Anglais 30min              🧠 Intellect         │
│  16:00 ┃─────────────────────────────────────────────────────────  │
│        ┃                                                            │
│  21:00 ┃ 🌙 ROUTINE SOIR (60 min)             🧠 30min             │
│        ┃ ├─ Lecture 30min → ReadFlow                              │
│        ┃ └─ Daily Review                                           │
│  22:00 ┃─────────────────────────────────────────────────────────  │
│                                                                     │
│  LÉGENDE: 🌅 Routine | 🧠 Bloc | ✅ Tâche | 🔄 Habit | 📅 Event   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.3 Vue Domaine avec Thèmes

```
┌─────────────────────────────────────────────────────────────────────┐
│  ⛪ DOMAINE : SPIRITUEL                           Score: 75%       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ⏱️ BUDGET TEMPS                                                    │
│  Cette semaine: 5h30 / 7h (79%)  │  Ce mois: 18h / 28h (64%) ⚠️   │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  📊 ÉQUILIBRE DES THÈMES                                           │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐                   │
│  │Consécra.│ │Croissanc│ │ Service │ │Communion│                   │
│  │  ████   │ │  ██░░   │ │  █░░░   │ │  ███░   │                   │
│  │  85%    │ │  50%    │ │  20%    │ │  65%    │                   │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘                   │
│                                                                     │
│  ⚠️ "Tu négliges le thème Service. Ajouter un objectif ?"         │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  🏷️ CONSÉCRATION                                                   │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 📖 Lire la Bible en entier              ████████░░ 78%      │   │
│  │    � Habit lié: "Temps avec Dieu" (30min/j)               │   │
│  │ 🍽️ Jeûner 4x cette année                ██░░░░░░░░ 25% (1/4)│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🏷️ CROISSANCE                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 💡 100 révélations intégrées            ██████░░░░ 62%      │   │
│  │    🔗 Sync: SpiritFlow (auto)                               │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🏷️ SERVICE                                    ⚠️ Négligé         │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ ⛪ Servir à l'église 2x/mois            █░░░░░░░░░ 10%      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.4 Bloc de Temps avec Tâches

```
┌─────────────────────────────────────────────────────────────────────┐
│  🧠 BLOC: DEEP WORK                         08:00 - 11:00 (3h)     │
│  📁 Projet: SpiritFlow | 💼 Domaine: Travail                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  TÂCHES PRÉVUES:                                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ ☑ Implémenter backlinks Bible     2h    🔴 P1    ✅ Fait   │   │
│  │ ☑ Écrire tests unitaires          1h    🔴 P1    ✅ Fait   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  TÂCHES AJOUTÉES PENDANT LE BLOC:                                  │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ ☑ Corriger bug découvert          20min  🟡 P2   ✅ Fait   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  📊 BILAN DU BLOC:                                                  │
│  • Durée réelle: 2h45 (prévu: 3h)                                  │
│  • Tâches: 3/3 complétées                                          │
│  • Focus: ████████░░ 85%                                           │
│  • Temps comptabilisé: 2h45 → 💼 Travail                           │
│                                                                     │
│  [+ Ajouter une tâche]                                             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.5 Budget Temps

```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 BUDGET TEMPS - Février 2026                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  OBJECTIF HEBDO          CETTE SEMAINE       CE MOIS (cumulé)      │
│                                                                     │
│  ⛪ Spirituel       Mode: Flexible                                 │
│  Objectif: 7h/sem        Fait: 5h30          18h / 28h (64%) ⚠️    │
│  ████████████████████████░░░░░░░░░░░░░                              │
│                          -1h30 cette sem     Besoin: 10h proch.sem │
│                                                                     │
│  💪 Santé           Mode: Strict                                   │
│  Objectif: 5h/sem        Fait: 6h            22h / 20h (110%) ✅   │
│  ████████████████████████████████░░░░░░                             │
│                          +1h cette sem       +2h sur le mois       │
│                                                                     │
│  💼 Travail         Mode: Strict                                   │
│  Objectif: 40h/sem       Fait: 38h           152h / 160h (95%) ✅  │
│  ████████████████████████████████░░░░░░                             │
│                          -2h cette sem       -8h sur le mois       │
│                                                                     │
│  👨‍👩‍👧‍👦 Famille        Mode: Flexible                                 │
│  Objectif: 10h/sem       Fait: 12h           45h / 40h (112%) ✅   │
│  ████████████████████████████████████░░                             │
│                          +2h cette sem       +5h sur le mois       │
│                                                                     │
│  🧠 Intellect       Mode: Flexible                                 │
│  Objectif: 5h/sem        Fait: 3h            14h / 20h (70%) ⚠️    │
│  ██████████████████░░░░░░░░░░░░░░░░░░░                              │
│                          -2h cette sem       Besoin: 6h proch.sem  │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  🤖 SUGGESTIONS:                                                    │
│  • "Bloque 1h samedi + 1h dimanche pour Spirituel"                 │
│  • "Tu peux découper 2h de Famille vers Intellect ce weekend"     │
│                                                                     │
│  [ Appliquer suggestion ] [ Voir détails ]                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.6 OKR avec Lien Habit

```
┌─────────────────────────────────────────────────────────────────────┐
│  🎯 OKR: Améliorer ma condition physique                     65%   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  KR1: 50 séances de sport ce trimestre                             │
│  ████████████████░░░░ 84% (42/50)                                  │
│                                                                     │
│  � HABIT LIÉ: "Sport matinal" (5x/sem)                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Contribution automatique: Chaque complétion = +1 séance    │   │
│  │                                                             │   │
│  │ Rythme actuel: 4.2 séances/sem                              │   │
│  │ Rythme nécessaire: 4 séances/sem                            │   │
│  │                                                             │   │
│  │ 🤖 "Tu es en avance ! Continue comme ça."                  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🔗 Sync: IronFlow (auto-count des séances)                        │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  KR2: Courir 10km sans pause                                       │
│  ████████░░░░░░░░░░░░ 40% (record: 4km)                            │
│                                                                     │
│  📈 Progression:                                                    │
│  Jan S1: 2km | S2: 2.5km | S3: 3km | S4: 4km                      │
│  Fév S1: 4km | ...                                                 │
│                                                                     │
│  🤖 "À ce rythme, tu atteindras 10km en 8 semaines. OK ?"         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.7 Weekly Review

```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 WEEKLY REVIEW - Semaine 5                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📈 RÉSUMÉ                                                          │
│                                                                     │
│  Habits:     32/35 (91%) 🏆 Record!                                │
│  Tâches:     18/24 (75%)                                           │
│  Routines:   6/7 jours                                             │
│                                                                     │
│  ⏱️ TEMPS PAR DOMAINE                                              │
│  💼 Travail    38h (obj: 40h)  -2h                                 │
│  👨‍👩‍👧‍👦 Famille    14h (obj: 10h)  +4h ✅                              │
│  ⛪ Spirituel   6h (obj: 7h)   -1h                                 │
│  💪 Santé       6h (obj: 5h)   +1h ✅                              │
│  🧠 Intellect   3h (obj: 5h)   -2h ⚠️                              │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│                                                                     │
│  🏆 3 WINS                                                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 1. [Backlinks Bible terminés                              ]│   │
│  │ 2. [PR développé couché 85kg                              ]│   │
│  │ 3. [Temps qualité avec famille                            ]│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ⚠️ CE QUI N'A PAS MARCHÉ                                          │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ • Pas assez de temps sur Intellect                         │   │
│  │ • Pas appelé parents                                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  🎯 FOCUS SEMAINE PROCHAINE                                        │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 1. [Rattraper 2h sur Spirituel                            ]│   │
│  │ 2. [Rattraper 2h sur Intellect                            ]│   │
│  │ 3. [Appeler parents dimanche                              ]│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│      [ ✅ Valider et planifier ]                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 7. Le Système de Vie

### 7.1 Architecture en Cascade

```
VALEURS (Pourquoi je vis)
    │
    └──► DOMAINES DE VIE (8 domaines)
            │
            └──► THÈMES (sous-catégories par domaine)
                    │
                    └──► OBJECTIFS ANNUELS
                            │
                            └──► OKR TRIMESTRIELS
                                    │
                                    ├──► KEY RESULTS
                                    │       │
                                    │       └──► Liés aux HABITS (auto-progression)
                                    │
                                    └──► PROJETS
                                            │
                                            └──► TÂCHES (dans BLOCS ou ROUTINES)
```

### 7.2 Thèmes Prédéfinis par Domaine

| Domaine | Thèmes Suggérés |
|---------|-----------------|
| ⛪ **Spirituel** | Consécration, Croissance, Service, Communion, Combat |
| 💪 **Santé** | Fitness, Nutrition, Sommeil, Santé mentale, Check-ups |
| 👨‍👩‍👧‍👦 **Famille** | Couple, Enfants, Parents, Fratrie, Famille élargie |
| 💼 **Travail** | Carrière, Compétences, Side-projects, Réseau, Revenus |
| 🧠 **Intellect** | Lecture, Langues, Tech, Culture, Créativité |
| 💰 **Finances** | Épargne, Investissement, Dettes, Budget, Générosité |
| 👥 **Social** | Amis proches, Communauté, Networking, Mentorat |
| 🎮 **Loisirs** | Hobbies, Voyage, Détente, Sport fun |

### 7.3 Connexions Automatiques

| Entité | Se connecte à | Résultat |
|--------|---------------|----------|
| Habit | KR | % KR augmente automatiquement |
| Habit | Domaine | Temps comptabilisé dans budget |
| Bloc | Domaine | Temps comptabilisé |
| Tâche | Bloc/Routine | Groupement logique |
| Tâche | Projet → OKR | Progression projet |
| Routine | Apps | Deep links |

---

## 8. Budget Temps par Domaine

### 8.1 Concept

Chaque domaine a un **objectif d'heures** (hebdo ou mensuel). Le temps est calculé automatiquement depuis les habits, blocs, routines et tâches.

### 8.2 Modes de Suivi

| Mode | Description | Exemple |
|------|-------------|---------|
| **Strict** | Objectif fixe chaque semaine | 5h/sem = 5h exactement |
| **Flexible** | Objectif mensuel répartissable | 20h/mois = peut varier par semaine |

### 8.3 Compensation Mensuelle

En mode flexible :
- Si une semaine est en déficit, on peut compenser la suivante
- L'app calcule le rythme nécessaire pour atteindre l'objectif mensuel
- Alertes précoces si rattrapage devient difficile

### 8.4 Sources de Temps

| Source | Calcul |
|--------|--------|
| Habit | Durée configurée × jours complétés |
| Bloc de temps | Durée réelle du bloc |
| Routine | Durée des étapes complétées |
| Tâche | Durée estimée ou chronométrée |
| App sync | Temps depuis IronFlow, SpiritFlow... |

---

## 9. L'IA Coach

### 9.1 Fonctionnalités

| Type | Description |
|------|-------------|
| **Lien Habit→KR** | Calcule si le rythme actuel mène au KR |
| **Budget temps** | Alerte et suggère pour équilibrer |
| **Patterns** | Détecte corrélations (sommeil vs productivité) |
| **Suggestions** | Propose de bloquer du temps, rappeler tâches |
| **Conflits** | Résout selon valeurs prioritaires |
| **Rattrapage** | Calcule heures nécessaires pour compensation |

### 9.2 Exemples

```
🤖 "Tu es à 64% sur Spirituel ce mois. Il te reste 2 semaines.
    Besoin: 10h au lieu de 7h/sem. Bloque 1h30 samedi + dimanche ?"

🤖 "Ton habit Sport contribue au KR '50 séances'. 
    Rythme actuel: 4.2/sem. Tu es en avance, bravo !"

🤖 "Tu fais 40% plus de deep work les matins où tu complètes 
    ta routine. Ne skip pas demain !"

🤖 "Domaine Intellect négligé depuis 3 semaines (14h/20h).
    Ajoute 30min de lecture ce soir ?"
```

---

## 10. Intégrations Apps

### 10.1 Deep Links Routines

Chaque étape de routine peut ouvrir une app externe :

```dart
// Routine Matin - Étape "Temps avec Dieu"
launchUrl(Uri.parse('spiritflow://open'));

// Routine Matin - Étape "Sport"
launchUrl(Uri.parse('ironflow://start-session'));
```

### 10.2 Sync Temps Automatique

| App | Données importées | Usage |
|-----|-------------------|-------|
| 🙏 SpiritFlow | Minutes de prière, révélations | → Domaine Spirituel |
| 🏋️ IronFlow | Séances, durée | → Domaine Santé + KR |
| 🌍 LingoFlow | Minutes d'étude | → Domaine Intellect |
| 📚 ReadFlow | Minutes de lecture | → Domaine Intellect |

### 10.3 API pour ChatFlow

```json
GET /api/v1/user/summary?period=week

{
  "app": "lifeflow",
  "user_email": "user@example.com",
  "period": "2026-W05",
  "metrics": {
    "habits_completed": 32,
    "habits_total": 35,
    "tasks_completed": 18,
    "routines_completed": 6
  },
  "time_by_domain": {
    "work": 38,
    "family": 14,
    "spiritual": 6,
    "health": 6,
    "intellect": 3
  },
  "budget_status": {
    "spiritual": {"target": 7, "actual": 6, "status": "behind"},
    "intellect": {"target": 5, "actual": 3, "status": "behind"}
  },
  "okr_progress": [
    {"objective": "Lancer SpiritFlow", "progress": 80},
    {"objective": "Condition physique", "progress": 65}
  ]
}
```

---

## 11. Architecture Technique

### 11.1 Stack

| Couche | Technologie |
|---|---|
| **App Mobile** | Flutter |
| **Backend** | Supabase |
| **IA** | OpenAI GPT-4o |
| **Notifications** | Firebase |

### 11.2 Modèle de Données

```sql
-- DOMAINES DE VIE
CREATE TABLE life_domains (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    name TEXT,
    icon TEXT,
    weekly_hours_target DECIMAL,
    monthly_hours_target DECIMAL,
    tracking_mode TEXT DEFAULT 'flexible', -- 'strict' ou 'flexible'
    score INTEGER DEFAULT 50
);

-- THÈMES
CREATE TABLE themes (
    id UUID PRIMARY KEY,
    domain_id UUID REFERENCES life_domains(id),
    name TEXT,
    icon TEXT,
    is_system BOOLEAN DEFAULT FALSE,
    progress INTEGER DEFAULT 0
);

-- OBJECTIFS ANNUELS
CREATE TABLE annual_goals (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    domain_id UUID REFERENCES life_domains(id),
    theme_id UUID REFERENCES themes(id),
    year INTEGER,
    title TEXT,
    progress INTEGER DEFAULT 0
);

-- OKR
CREATE TABLE okrs (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    annual_goal_id UUID REFERENCES annual_goals(id),
    quarter TEXT,
    objective TEXT,
    progress INTEGER DEFAULT 0
);

-- KEY RESULTS
CREATE TABLE key_results (
    id UUID PRIMARY KEY,
    okr_id UUID REFERENCES okrs(id),
    title TEXT,
    target_value DECIMAL,
    current_value DECIMAL DEFAULT 0,
    unit TEXT
);

-- HABITS
CREATE TABLE habits (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    domain_id UUID REFERENCES life_domains(id),
    key_result_id UUID REFERENCES key_results(id),
    name TEXT,
    frequency TEXT,
    duration_minutes INTEGER,
    app_link TEXT,
    streak INTEGER DEFAULT 0
);

-- BLOCS DE TEMPS
CREATE TABLE time_blocks (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    domain_id UUID REFERENCES life_domains(id),
    project_id UUID REFERENCES projects(id),
    date DATE,
    start_time TIME,
    end_time TIME,
    block_type TEXT,
    label TEXT,
    actual_duration_minutes INTEGER,
    focus_score INTEGER
);

-- TÂCHES
CREATE TABLE tasks (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    project_id UUID REFERENCES projects(id),
    domain_id UUID REFERENCES life_domains(id),
    time_block_id UUID REFERENCES time_blocks(id),
    routine_step_id UUID REFERENCES routine_steps(id),
    title TEXT,
    priority TEXT,
    scheduled_date DATE,
    estimated_minutes INTEGER,
    actual_minutes INTEGER,
    completed BOOLEAN DEFAULT FALSE,
    added_during_block BOOLEAN DEFAULT FALSE
);

-- ROUTINES
CREATE TABLE routines (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    name TEXT,
    time_of_day TEXT
);

-- ÉTAPES ROUTINE
CREATE TABLE routine_steps (
    id UUID PRIMARY KEY,
    routine_id UUID REFERENCES routines(id),
    domain_id UUID REFERENCES life_domains(id),
    habit_id UUID REFERENCES habits(id),
    title TEXT,
    duration_minutes INTEGER,
    order_index INTEGER,
    app_link TEXT
);

-- LOGS TEMPS PAR DOMAINE
CREATE TABLE domain_time_logs (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    domain_id UUID REFERENCES life_domains(id),
    date DATE,
    source_type TEXT, -- 'habit', 'block', 'routine', 'task', 'app_sync'
    source_id UUID,
    minutes INTEGER
);
```

---

## 12. Modèle Économique

### 12.1 Grille Tarifaire

| Offre | Prix/mois | Contenu |
|---|---|---|
| **Free** | 0€ | 5 habits, 1 routine, 20 tâches, stats 7 jours, 3 domaines |
| **Pro** | 6,99€ (~4.600 FCFA) | Illimité, OKR, IA, budget temps, intégrations |
| **Pro Annuel** | 49,99€/an (~33.000 FCFA) | Même que Pro, -40% |

### 12.2 Features par Tier

| Feature | Free | Pro |
|---|---|---|
| Habits | 5 max | Illimité |
| Routines | 1 | Illimité |
| Tâches actives | 20 | Illimité |
| Domaines | 3 | 8+ custom |
| **Thèmes** | ❌ | ✅ |
| **OKR + Lien Habit** | ❌ | ✅ |
| **Budget temps** | ❌ | ✅ |
| **Blocs de temps** | ❌ | ✅ |
| **Calendrier unifié** | Basique | Complet |
| **IA insights** | ❌ | ✅ |
| **Revues guidées** | Daily | Toutes |
| **Intégrations apps** | ❌ | ✅ |

---

## 13. Projections de Marché

### 13.1 TAM / SAM / SOM

| Métrique | Estimation |
|---|---|
| **TAM** | 500M utilisateurs apps productivité |
| **SAM** | 100M cherchant système complet |
| **SOM** | 500.000 utilisateurs en 3 ans |

### 13.2 Projection (24 mois)

| Période | Downloads | MAU | Payants (6%) | MRR | ARR |
|---|---|---|---|---|---|
| M6 | 30.000 | 12.000 | 720 | 5.000€ | 60.000€ |
| M12 | 120.000 | 50.000 | 3.000 | 21.000€ | 252.000€ |
| M18 | 300.000 | 120.000 | 7.200 | 50.000€ | 600.000€ |
| M24 | 600.000 | 250.000 | 15.000 | 105.000€ | 1.260.000€ |

---

## 14. Go-to-Market

### Phase 1 : MVP (M1-M3)
- App Android
- Habits + Tâches + Routine matin + Domaines
- Beta 200 utilisateurs

### Phase 2 : Lancement (M3-M6)
- iOS + Android
- OKR + Projets + Lien Habit→KR
- Thèmes par domaine
- 30.000 téléchargements

### Phase 3 : Croissance (M6-M12)
- Budget temps
- Blocs de temps + Calendrier unifié
- IA insights
- Intégrations SpiritFlow/IronFlow
- 120.000 téléchargements

### Phase 4 : Scale (M12-M24)
- Revues avancées
- Compensation mensuelle
- Multi-langue
- 600.000 téléchargements

---

## 15. Risques et Mitigations

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| **Complexité** | Haute | Élevé | Onboarding progressif, déverrouiller features |
| **Concurrence** | Haute | Moyen | Différenciation budget temps + intégrations |
| **Churn** | Moyenne | Élevé | Insights IA, gamification subtile |
| **Coûts IA** | Basse | Moyen | Limiter aux Pro |

---

## 16. Roadmap

### Trimestre 1 (M1-M3) : MVP

- [ ] App Flutter Android
- [ ] Domaines de vie (8)
- [ ] Habits avec domaine
- [ ] Tâches basiques
- [ ] Routine matin
- [ ] Dashboard simple
- [ ] Beta 200 utilisateurs

### Trimestre 2 (M4-M6) : Structure

- [ ] iOS
- [ ] Thèmes par domaine
- [ ] OKR + Key Results
- [ ] Lien Habit → KR intelligent
- [ ] Projets
- [ ] Daily/Weekly Review
- [ ] Paiement Stripe
- [ ] 30.000 téléchargements

### Trimestre 3 (M7-M9) : Temps

- [ ] Budget temps par domaine
- [ ] Mode strict vs flexible
- [ ] Blocs de temps
- [ ] Tâches dans blocs/routines
- [ ] Calendrier unifié
- [ ] IA patterns et suggestions
- [ ] 80.000 téléchargements

### Trimestre 4 (M10-M12) : Intégrations

- [ ] Compensation mensuelle
- [ ] Deep links apps
- [ ] Sync SpiritFlow/IronFlow
- [ ] API pour ChatFlow
- [ ] Monthly/Quarterly Review
- [ ] 120.000 téléchargements

---

*Document vivant - Dernière mise à jour : 3 Février 2026*

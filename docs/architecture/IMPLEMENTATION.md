# 📋 LifeFlow — Document d'Implémentation

**Version :** 1.0
**Date :** 19 Février 2026
**Stack :** Flutter (Stacked MVVM) + Supabase + FastAPI + GPT-4o
**Statut :** Phase de conception validée — prêt pour implémentation

---

## Table des Matières

1. [Pitch](#1-pitch)
2. [Concepts Fondamentaux](#2-concepts-fondamentaux)
3. [Modèle de Données](#3-modèle-de-données)
4. [Architecture IA](#4-architecture-ia)
5. [Interfaces ASCII](#5-interfaces-ascii)
6. [Features par Phase](#6-features-par-phase)
7. [Stack Technique](#7-stack-technique)
8. [Migrations Supabase](#8-migrations-supabase)

---

## 1. Pitch

> **LifeFlow connecte tes habitudes quotidiennes à tes objectifs de vie, pour que chaque action ait du sens.**

### Philosophie

- **Capture d'abord, structure ensuite** (GTD Inbox)
- **Progressive disclosure** : simple au début, profond quand tu veux
- **L'IA informe, l'utilisateur décide** : jamais de coach intrusif
- **Tout est connecté** : chaque habit/tâche → domaine → OKR → sens

### Le problème résolu

Les gens font des choses chaque jour sans savoir si ça les rapproche de leurs objectifs. LifeFlow rend visible le lien entre l'effort quotidien et la progression long terme.

---

## 2. Concepts Fondamentaux

### 8 concepts, pas plus

| # | Concept | Description | Exemples |
|---|---------|-------------|----------|
| 1 | **Inbox** | Zone de capture rapide GTD. Tout rentre ici. | "Appeler le dentiste", "Idée d'article", "Acheter protéines" |
| 2 | **Habit** | Action récurrente, binaire ou quantitative | Méditation (binaire), 500 pompes (quantitatif) |
| 3 | **Routine** | Séquence ordonnée d'étapes (habits, tâches, steps libres) | Routine Matin, Routine Soir, Routine Deep Work |
| 4 | **Tâche** | Action ponctuelle ou récurrente avec un état done/not done | "Envoyer le rapport", "Préparer la présentation" |
| 5 | **Projet** | Groupe de tâches liées à un même objectif | "Lancer le site web", "Déménagement" |
| 6 | **Bloc de temps** | Plage horaire réservée dans le calendrier | 09:00-11:00 Deep Work, 18:00-19:00 Sport |
| 7 | **Domaine** | Sphère de vie avec budget temps optionnel | Santé, Travail, Famille, Apprentissage, Créativité |
| 8 | **OKR / Key Result** | Objectif mesurable alimenté par habits et tâches | O: "Être en forme" → KR: "Courir 100km ce trimestre" |

+ **InsightCard** : observation générée par l'IA, liée à n'importe quelle entité.

---

### 2.1 Habit (détaillé)

**Deux types, définis à la création :**

#### Type Binaire — fait ou pas fait
```
Définition:
  Nom: Méditation
  Type: binaire
  Fréquence: tous les jours
  Créneau prévu: 06:00 — 06:30
  Domaine: Santé mentale
  KR lié: "Méditer 90 jours ce trimestre"

Complétion:
  → L'utilisateur appuie sur ✅
  → Optionnel: saisir la plage réelle (de 06:15 à 06:40)
  → Optionnel: ajouter une note
```

#### Type Quantitatif — valeur à saisir
```
Définition:
  Nom: Pompes
  Type: quantitatif
  Unité: pompes
  Cible: 500
  Fréquence: tous les jours
  Créneau prévu: 18:00 — 19:00
  Domaine: Santé physique
  KR lié: "Faire 15 000 pompes ce trimestre"

Complétion:
  → L'utilisateur entre la valeur: 520
  → Optionnel: saisir la plage réelle (de 07:15 à 07:40)
  → Optionnel: ajouter une note
  → L'app calcule: 520/500 = 104%, delta = +20
```

#### États visuels d'une Habit
```
✅    Fait, dans le créneau prévu, objectif atteint
✅+   Fait, dans le créneau, objectif DÉPASSÉ
⚠️✅  Fait, HORS créneau, objectif atteint
⚠️+   Fait, HORS créneau, objectif dépassé
📉    Fait mais SOUS l'objectif (ex: 420/500)
❌    Non fait
·     Jour pas encore passé / pas prévu
```

#### Log d'une Habit
```
HabitLog {
  date: 2026-02-19
  actual_value: 520              // null si binaire
  started_at: 07:15
  completed_at: 07:40
  duration: 25 min               // calculé
  in_planned_window: false       // 07:15 hors 18:00-19:00
  delta: +20                     // calculé (actual - target)
  status: exceeded               // exceeded | met | under | missed
  note: "Bonne séance, énergie haute"
}
```

---

### 2.2 Routine (détaillé)

Une routine est une **séquence ordonnée d'étapes**. Chaque étape est :
- Une **Habit** (existante)
- Une **Tâche** (existante)
- Un **Step libre** (texte simple, juste un checkbox)

```
Routine "Matin" {
  plage_prevue: 06:00 — 07:30
  domaine: Bien-être (ou multi-domaine)
  étapes: [
    { order: 1, type: habit,     ref: "Méditation" }
    { order: 2, type: habit,     ref: "Pompes" }
    { order: 3, type: habit,     ref: "Lecture 30min" }
    { order: 4, type: free_step, label: "Petit-déjeuner" }
    { order: 5, type: task,      ref: "Revoir inbox" }
  ]
}
```

#### Log d'une Routine
```
RoutineLog {
  date: 2026-02-19
  started_at: 06:15
  completed_at: 07:20
  duration: 65 min
  steps_completed: 4/5
  steps_detail: [
    { order: 1, completed: true }
    { order: 2, completed: true, value: 520 }
    { order: 3, completed: true }
    { order: 4, completed: true }
    { order: 5, completed: false }
  ]
}
```

**Pas de tolérance horaire sur la Routine.** On enregistre simplement quand elle est faite pour les stats.

---

### 2.3 Tâche & Projet

```
Tâche {
  titre, description
  domaine_id
  projet_id?          // optionnel
  key_result_id?      // optionnel — lien vers OKR
  due_date?
  priority: low | medium | high
  recurrence?         // daily, weekly, custom
  status: todo | done
}

Projet {
  titre, description
  domaine_id
  tâches[]            // liste de tâches
  status: active | completed | archived
  progress: 60%       // calculé (tâches done / total)
}
```

---

### 2.4 Bloc de Temps (Time-boxing)

```
BlocDeTemps {
  titre: "Deep Work - LifeFlow"
  plage: 09:00 — 11:00
  domaine_id: Travail
  date: 2026-02-19
  récurrence?: weekly (lun, mar, mer)
  
  // Ce qu'il contient (optionnel)
  contenu: {
    type: routine | project | tasks | free
    ref_id?: ...
  }
  
  // Log
  actual_start?: 09:10
  actual_end?: 11:05
  status: planned | in_progress | completed | skipped
}
```

Le calendrier intégré affiche les blocs de temps. Sync Google/Apple Calendar prévue en V3.

---

### 2.5 Domaine de Vie

```
Domaine {
  nom: "Santé"
  icône: 🏋️
  couleur: #4CAF50
  ordre: 1
  
  // Budget temps (optionnel)
  target_hours_per_week: 10
  
  // Calculé automatiquement
  actual_hours_this_week: 6.5   // depuis habit logs + bloc logs
  health_score: 65%             // actual / target
  
  // Contient
  habits[]
  tâches[]
  projets[]
  okrs[]
  blocs_de_temps[]
}
```

**Domaines flexibles** : l'utilisateur crée, renomme, réordonne, supprime. Suggestions au onboarding mais rien d'imposé.

---

### 2.6 OKR / Key Result

```
OKR {
  titre: "Être en excellente forme physique"
  domaine_id: Santé
  période: Q1 2026
  
  key_results: [
    {
      titre: "Faire 15 000 pompes"
      target: 15000
      current: 8400          // auto-calculé depuis HabitLogs
      unit: "pompes"
      progress: 56%
      fed_by: [habit:"Pompes"]  // lien automatique
    },
    {
      titre: "Courir 100km"
      target: 100
      current: 42
      unit: "km"
      progress: 42%
      fed_by: [habit:"Course"]
    },
    {
      titre: "Perdre 5kg"
      target: 5
      current: 2.1
      unit: "kg"
      progress: 42%
      fed_by: []              // saisie manuelle
    }
  ]
}
```

**Alimentation automatique** : quand un HabitLog est enregistré pour une habit liée à un KR, le `current` du KR est recalculé. L'utilisateur voit instantanément l'impact.

---

### 2.7 GTD Inbox

```
InboxItem {
  texte: "Appeler le dentiste"
  created_at: 2026-02-19T14:23:00
  
  // Traitement (quand l'utilisateur organise)
  processed_as: task | habit | project | someday | deleted
  processed_at: ...
  result_ref_id: ...    // ID de la tâche/habit/projet créé
}
```

**Flux** : Capturer → Plus tard, trier → Chaque item devient une tâche, habit, projet, "someday", ou poubelle.

---

### 2.8 InsightCard (IA)

```
InsightCard {
  id
  type: pattern | risk | encouragement | suggestion | correlation
  priority: high | medium | low
  source: local | ai       // Niveau 1 ou Niveau 2
  
  titre: "Tu dépasses tes pompes régulièrement"
  body: "4 fois cette semaine, +15% en moyenne. Passer à 600 ?"
  
  related_entity: { type: habit, id: xxx }
  
  suggested_action?: {
    label: "Passer à 600"
    type: update_habit_target
    payload: { habit_id, new_target: 600 }
  }
  
  status: pending | accepted | snoozed | dismissed
  snoozed_until?: DateTime
}
```

---

## 3. Modèle de Données

### Relations entre entités

```
         📥 Inbox
          │
    ┌─────┼───────┐
    ▼     ▼       ▼
  ✅Habit 📋Tâche 📁Projet──→📋Tâches[]
    │  ╲    │  ╱
    │   ╲   │ ╱
    │    ▼  ▼▼
    │   🔄 Routine
    │       │
    │   ┌───┘
    ▼   ▼
  ⏰ Bloc de temps ◄──── 📁Projet
    │                     📋Tâches
    │                     🔄Routine
    ▼
  📅 Calendrier (vue jour/semaine)
  
  ✅ Habit ──→ 🎯 KR ──→ 🎯 OKR
  📋 Tâche ──→ 🎯 KR         │
                               ▼
  Tout ─────────────────→ 🌐 Domaine
                               │
                          heures réelles
                          score santé
                               │
                               ▼
                         💡 InsightCard
```

### Schéma Supabase (tables)

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   profiles   │     │   domains    │     │    okrs      │
│──────────────│     │──────────────│     │──────────────│
│ id (PK, FK)  │     │ id           │     │ id           │
│ first_name   │     │ user_id (FK) │◄────│ domain_id    │
│ last_name    │     │ name         │     │ user_id      │
│ display_name │     │ icon         │     │ title        │
│ avatar_url   │     │ color        │     │ period       │
│ locale       │     │ sort_order   │     │ status       │
│ timezone     │     │ target_hours │     └──────┬───────┘
│ preferences  │     │ is_active    │            │
└──────────────┘     └──────┬───────┘     ┌──────▼───────┐
                            │             │  key_results  │
                     ┌──────┼──────┐      │──────────────│
                     │      │      │      │ id           │
              ┌──────▼──┐   │  ┌───▼────┐ │ okr_id (FK)  │
              │  habits  │   │  │ tasks  │ │ title        │
              │─────────│   │  │────────│ │ target_value │
              │ id      │   │  │ id     │ │ current_value│
              │ user_id │   │  │ user_id│ │ unit         │
              │ domain  │   │  │ domain │ └──────────────┘
              │ name    │   │  │ title  │
              │ type    │   │  │ project│        ▲
              │ target  │   │  │ kr_id──┼────────┘
              │ unit    │   │  │ status │
              │ freq    │   │  └───┬────┘
              │ planned │   │      │
              │ kr_id───┼───┼──────┼──────────────►KR
              └────┬────┘   │      │
                   │        │  ┌───▼────┐
              ┌────▼────┐   │  │projects│
              │habit_logs│  │  │────────│
              │─────────│   │  │ id     │
              │ id      │   │  │ user_id│
              │ habit_id│   │  │ domain │
              │ date    │   │  │ title  │
              │ value   │   │  │ status │
              │ start   │   │  └────────┘
              │ end     │   │
              │ status  │   │
              └─────────┘   │
                            │
                     ┌──────▼───────┐
                     │   routines   │
                     │──────────────│
                     │ id           │
                     │ user_id      │
                     │ name         │
                     │ planned_start│
                     │ planned_end  │
                     └──────┬───────┘
                            │
                     ┌──────▼───────┐     ┌──────────────┐
                     │routine_steps │     │routine_logs  │
                     │──────────────│     │──────────────│
                     │ id           │     │ id           │
                     │ routine_id   │     │ routine_id   │
                     │ step_order   │     │ date         │
                     │ step_type    │     │ started_at   │
                     │ habit_id?    │     │ completed_at │
                     │ task_id?     │     │ steps_done   │
                     │ free_label?  │     └──────────────┘
                     └──────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ time_blocks  │     │ inbox_items  │     │insight_cards │
│──────────────│     │──────────────│     │──────────────│
│ id           │     │ id           │     │ id           │
│ user_id      │     │ user_id      │     │ user_id      │
│ domain_id    │     │ text         │     │ type         │
│ title        │     │ processed_as │     │ priority     │
│ date         │     │ result_ref   │     │ source       │
│ planned_start│     │ created_at   │     │ title        │
│ planned_end  │     │ processed_at │     │ body         │
│ actual_start │     └──────────────┘     │ entity_type  │
│ actual_end   │                          │ entity_id    │
│ content_type │                          │ action_data  │
│ content_ref  │                          │ status       │
│ recurrence   │                          └──────────────┘
│ status       │
└──────────────┘
```

---

## 4. Architecture IA

### Philosophie : Observer → Informer → L'utilisateur décide

```
┌─────────────────────────────────────────────────┐
│              FLUX DE L'IA                        │
│                                                  │
│  📊 Données brutes                               │
│    │ (habits, tâches, temps, routines)           │
│    ▼                                             │
│  🔍 Moteur de patterns (Niveau 1 — local)        │
│    │ règles simples, moyennes, corrélations      │
│    ▼                                             │
│  🧠 GPT-4o (Niveau 2 — FastAPI)                  │
│    │ résumé naturel, corrélations croisées       │
│    ▼                                             │
│  💡 InsightCard                                  │
│    │ titre + explication + action suggérée       │
│    ▼                                             │
│  👤 Utilisateur                                  │
│    ├── ✅ Accepter (appliquer la suggestion)     │
│    ├── 💤 Plus tard (snooze)                     │
│    └── ❌ Ignorer (l'IA apprend)                │
└─────────────────────────────────────────────────┘
```

### Niveau 1 — Local (Flutter, pas de serveur)

Calculs simples exécutés sur le device :

| Pattern détecté | Logique | Insight généré |
|-----------------|---------|----------------|
| Décalage horaire | `avg(actual_start) != planned_start` sur 7j | "Tu fais tes pompes à 7h en moyenne, mais tu vises 18h. Déplacer ?" |
| Dépassement régulier | `avg(delta) > +10%` sur 7j | "Tu dépasses tes 500 pompes 4×/sem. Passer à 600 ?" |
| Streak en danger | `streak >= 5 && today not done && hour > 20:00` | "🔥 Série de 12 jours de méditation. N'oublie pas !" |
| Domaine négligé | `domain.actual_hours < 20% of target` sur 14j | "Rien dans Créativité depuis 14 jours." |
| Routine drift | `step_skip_rate > 70%` sur 14j | "Tu sautes Étirements 80% du temps. Retirer ?" |
| Inbox saturée | `inbox.count(unprocessed, age > 7d) > 10` | "23 items dans l'inbox depuis +7 jours. Tri ?" |
| Vélocité OKR | `kr.progress / days_elapsed < kr.target / total_days` | "KR à 30% — il reste 3 semaines. Rythme insuffisant." |
| Budget temps écart | `domain.actual < domain.target * 0.7` | "Santé: 5h budgétées, 2h réelles cette semaine." |
| Sous-performance | `habit.status == 'under'` fréquent | "Pompes: sous l'objectif 3×/sem. Réduire à 400 ?" |

### Niveau 2 — Cloud (FastAPI + GPT-4o)

Pour les analyses complexes. L'app envoie des **données agrégées** (jamais raw) :

| Analyse | Ce que GPT-4o reçoit | Ce qu'il retourne |
|---------|---------------------|-------------------|
| Corrélations croisées | Stats de 2+ habits sur 30j | "Les jours où tu médites → +40% de tâches complétées" |
| Résumé hebdomadaire | Domaines, streaks, OKR progress | Texte naturel : "Bonne semaine pour Santé, Travail en baisse..." |
| Prédiction de KR | Progression + jours restants | "À ce rythme, KR atteint le 15/03" |
| Détection surcharge | Toutes les heures/domaine | "Tu es à 110% de capacité cette semaine. Prioriser ?" |
| Reformulation OKR | OKR texte brut | "Cet OKR n'est pas mesurable. Suggestion : ..." |

### Patterns configurables par l'utilisateur

L'utilisateur peut dans les paramètres :

```
⚙️ Paramètres IA
├── 🔔 Notifications insights : Oui / Non
├── 📊 Fréquence analyse : Quotidien / Hebdo
├── 🎯 Patterns activés :
│   ├── ✅ Décalage horaire
│   ├── ✅ Dépassement objectif
│   ├── ✅ Streak en danger
│   ├── ✅ Domaine négligé
│   ├── ✅ Vélocité OKR
│   ├── ☐  Corrélations (nécessite cloud)
│   └── ☐  Résumé hebdo IA (nécessite cloud)
└── 🧠 Niveau IA : Local seul / Local + Cloud
```

---

## 5. Interfaces ASCII

### 5.1 Onboarding (3 écrans, 90 secondes)

#### Écran 1 — Bienvenue
```
┌─────────────────────────────────────┐
│                                     │
│          🌊 LifeFlow                │
│                                     │
│    Vis selon tes valeurs.           │
│    Chaque jour compte.             │
│                                     │
│                                     │
│                                     │
│    [   Commencer   ]               │
│                                     │
│    Déjà un compte ? Se connecter   │
│                                     │
└─────────────────────────────────────┘
```

#### Écran 2 — Choisis tes domaines de vie
```
┌─────────────────────────────────────┐
│  ← Retour                          │
│                                     │
│  Qu'est-ce qui compte pour toi ?   │
│  Choisis tes domaines de vie.      │
│  Tu pourras modifier plus tard.    │
│                                     │
│  ┌─────────┐  ┌─────────┐         │
│  │ 🏋️ Santé │  │ 💼 Travail│        │
│  │   ✅    │  │   ✅    │         │
│  └─────────┘  └─────────┘         │
│  ┌─────────┐  ┌─────────┐         │
│  │ 👨‍👩‍👧 Famille│ │ 📚 Apprendre│      │
│  │   ✅    │  │   ○     │         │
│  └─────────┘  └─────────┘         │
│  ┌─────────┐  ┌─────────┐         │
│  │ 🎨 Créa  │  │ 💰 Finance│       │
│  │   ○     │  │   ✅    │         │
│  └─────────┘  └─────────┘         │
│  ┌─────────┐  ┌─────────┐         │
│  │ 🙏 Spiri │  │ ➕ Custom │        │
│  │   ○     │  │         │         │
│  └─────────┘  └─────────┘         │
│                                     │
│  4 domaines sélectionnés           │
│                                     │
│  [     Continuer     ]             │
│                                     │
└─────────────────────────────────────┘
```

#### Écran 3 — Ta première routine
```
┌─────────────────────────────────────┐
│  ← Retour                          │
│                                     │
│  Comment commence ta journée ?     │
│                                     │
│  Choisis des habits pour ta        │
│  routine du matin :                │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ 🧘 Méditation     (10 min)│  │
│  │ ✅ 💪 Exercice       (30 min)│  │
│  │ ○  📖 Lecture        (20 min)│  │
│  │ ○  📝 Journaling     (10 min)│  │
│  │ ○  🚿 Routine hygiène       │   │
│  │ ○  🍳 Petit-déjeuner        │   │
│  │ ➕ Ajouter une habitude      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Routine matin ≈ 40 min           │
│  Créneau suggéré: 06:00 — 06:40   │
│                                     │
│  [   C'est parti ! 🚀  ]          │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.2 Écran Principal — Vue Aujourd'hui

#### Matin (routine non commencée)
```
┌─────────────────────────────────────┐
│  ☀️ Bonjour Koffi          🔔  👤  │
├─────────────────────────────────────┤
│                                     │
│  Mercredi 19 Février               │
│  3 habits · 2 tâches · 1 routine  │
│                                     │
│  ─── ☀️ ROUTINE MATIN ─────────── │
│  ┌─────────────────────────────┐   │
│  │  ○ 🧘 Méditation            │   │
│  │  ○ 💪 Pompes        🎯 500  │   │
│  │  ○ 📖 Lecture 30min         │   │
│  │  ○ 🍳 Petit-déjeuner       │   │
│  │                              │   │
│  │  [  Démarrer la routine  ]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 📋 TÂCHES ────────────────── │
│  ┌─────────────────────────────┐   │
│  │  ○ Envoyer rapport Q1  💼   │   │
│  │  ○ Appeler dentiste    🏋️   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 💡 INSIGHT ───────────────── │
│  ┌─────────────────────────────┐   │
│  │  🔥 Méditation: 12 jours !  │   │
│  │  Continue, c'est ta plus    │   │
│  │  longue série.    [Nice 👍] │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
│  Home  Inbox  Quick  Cal  Insights │
└─────────────────────────────────────┘
```

#### Routine en cours
```
┌─────────────────────────────────────┐
│  ☀️ Routine Matin      ⏱️ 23 min   │
├─────────────────────────────────────┤
│                                     │
│  Démarrée à 06:15                  │
│                                     │
│  ✅ 🧘 Méditation                   │
│  ✅ 💪 Pompes          520/500 ✅+  │
│  ▶️ 📖 Lecture 30min    ← en cours  │
│  ○  🍳 Petit-déjeuner              │
│                                     │
│  ████████████████░░░░░░  3/4       │
│                                     │
│  Pompes: 520/500 (+4%)             │
│  ████████████████████░  104%       │
│                                     │
│  [  Terminer la routine  ]         │
│  [  Passer l'étape  ]             │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

#### Journée avancée
```
┌─────────────────────────────────────┐
│  Mercredi 19 Fév           🔔  👤  │
├─────────────────────────────────────┤
│                                     │
│  ─── ☀️ ROUTINE MATIN ─── ✅ 4/4 ─│
│  ┌─────────────────────────────┐   │
│  │  ✅ Méditation  ✅ Pompes   │   │
│  │  ✅ Lecture     ✅ Pdej     │   │
│  │  06:15 → 07:20 (65 min)    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── ⏰ BLOCS DE TEMPS ────────── │
│  ┌─────────────────────────────┐   │
│  │ 09-11  💻 Deep Work LifeFlow│   │
│  │        ████████░░ en cours  │   │
│  │ 14-16  💼 Réunions client   │   │
│  │        ░░░░░░░░░░ à venir   │   │
│  │ 18-19  🏋️ Sport             │   │
│  │        ░░░░░░░░░░ à venir   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 📋 TÂCHES ────────────────── │
│  ┌─────────────────────────────┐   │
│  │ ✅ Envoyer rapport Q1  💼   │   │
│  │  ○ Appeler dentiste    🏋️   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 🌙 ROUTINE SOIR ─── 0/3 ─── │
│  ┌─────────────────────────────┐   │
│  │  ○ 📝 Journal               │   │
│  │  ○ 📱 Pas d'écran           │   │
│  │  ○ 🛏️ Couché avant 23h     │   │
│  │                              │   │
│  │  [ Démarrer ]               │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.3 Capture Rapide (bouton ➕)

```
┌─────────────────────────────────────┐
│                                     │
│           Capture rapide            │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Quoi ? ____________________│   │
│  └─────────────────────────────┘   │
│                                     │
│  Envoyer dans :                    │
│                                     │
│  [📥 Inbox]  [✅ Habit]  [📋 Tâche]│
│                                     │
│  ── Si Inbox : ─────────────────── │
│  C'est tout. Tu trieras plus tard. │
│  [  Capturer  ]                    │
│                                     │
│  ── Si Tâche : ─────────────────── │
│  Domaine: [ 💼 Travail     ▼ ]    │
│  Échéance: [ Aujourd'hui   ▼ ]    │
│  [  Créer la tâche  ]             │
│                                     │
│  ── Si Habit : ─────────────────── │
│  Type: [Binaire ▼] / [Quantitatif]│
│  Domaine: [ 🏋️ Santé       ▼ ]   │
│  [  Créer l'habitude  ]           │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.4 GTD Inbox

```
┌─────────────────────────────────────┐
│  ← Inbox                     12 📥 │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ "Appeler le dentiste"       │   │
│  │ il y a 3 jours              │   │
│  │                              │   │
│  │ [📋Tâche][✅Habit][📁Projet]│   │
│  │ [💤Someday]        [🗑️]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ "Idée: app de recettes"     │   │
│  │ il y a 5 jours              │   │
│  │                              │   │
│  │ [📋Tâche][✅Habit][📁Projet]│   │
│  │ [💤Someday]        [🗑️]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ "Faire 10 min de planche/j" │   │
│  │ il y a 1 jour               │   │
│  │                              │   │
│  │ [📋Tâche][✅Habit][📁Projet]│   │
│  │ [💤Someday]        [🗑️]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ... 9 autres items               │
│                                     │
│  💡 "23 items > 7 jours. Séance   │
│     de tri ?"         [Trier]      │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

#### Inbox → Transformation en Tâche
```
┌─────────────────────────────────────┐
│  ← Créer une tâche                 │
├─────────────────────────────────────┤
│                                     │
│  Depuis: "Appeler le dentiste"     │
│                                     │
│  Titre:                            │
│  ┌─────────────────────────────┐   │
│  │ Appeler le dentiste         │   │
│  └─────────────────────────────┘   │
│                                     │
│  Domaine:    [ 🏋️ Santé       ▼ ] │
│  Projet:     [ Aucun          ▼ ] │
│  Échéance:   [ Vendredi 21/02 ▼ ] │
│  Priorité:   [ Moyenne        ▼ ] │
│  Lié au KR:  [ Aucun          ▼ ] │
│                                     │
│  [     Créer la tâche     ]        │
│                                     │
└─────────────────────────────────────┘
```

#### Inbox → Transformation en Habit
```
┌─────────────────────────────────────┐
│  ← Créer une habitude              │
├─────────────────────────────────────┤
│                                     │
│  Depuis: "Faire 10 min planche/j"  │
│                                     │
│  Nom:                              │
│  ┌─────────────────────────────┐   │
│  │ Planche abdominale          │   │
│  └─────────────────────────────┘   │
│                                     │
│  Type:   (●) Binaire  ( ) Quantitatif│
│                                     │
│  Si quantitatif:                   │
│  Cible: [   ] Unité: [        ]    │
│                                     │
│  Fréquence:  [ Tous les jours  ▼ ] │
│  Domaine:    [ 🏋️ Santé       ▼ ] │
│  Créneau:    [ 18:00 ] à [ 18:30 ]│
│  Lié au KR:  [ Aucun          ▼ ] │
│                                     │
│  Dans une routine ?                │
│  [ ☀️ Routine Matin          ▼ ]  │
│  Position: [ Après "Pompes"   ▼ ] │
│                                     │
│  [    Créer l'habitude    ]        │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.5 Vue Calendrier (Blocs de temps)

#### Vue Jour
```
┌─────────────────────────────────────┐
│  ←  📅 Mer. 19 Février 2026   →   │
│      [Jour] [Semaine]              │
├─────────────────────────────────────┤
│                                     │
│  06:00 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄     │
│  06:15 ▐████████████████████▌      │
│        ▐ ☀️ Routine Matin    ▌     │
│        ▐ 4/4 ✅  (65 min)   ▌     │
│  07:20 ▐████████████████████▌      │
│  08:00 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄     │
│  09:00 ▐████████████████████▌      │
│        ▐ 💻 Deep Work        ▌     │
│        ▐ Projet LifeFlow     ▌     │
│  11:00 ▐████████████████████▌      │
│  11:00 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄     │
│  12:00 ▐██████████▌                │
│        ▐ 🍽️ Déjeuner▌              │
│  13:00 ▐██████████▌                │
│  14:00 ▐████████████████████▌      │
│        ▐ 💼 Réunions client  ▌     │
│  16:00 ▐████████████████████▌      │
│  16:00 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄     │
│  18:00 ▐████████████████████▌      │
│        ▐ 🏋️ Sport            ▌     │
│  19:00 ▐████████████████████▌      │
│  20:00 ▐██████████▌                │
│        ▐ 🌙 Routine Soir▌          │
│  21:00 ▐██████████▌                │
│                                     │
│       [➕ Nouveau bloc]            │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

#### Vue Semaine
```
┌──────────────────────────────────────────────────────────┐
│  ←  Semaine du 17 Février 2026  →     [Jour] [Semaine]  │
├──────────────────────────────────────────────────────────┤
│      │ Lun  │ Mar  │ Mer  │ Jeu  │ Ven  │ Sam  │ Dim  │
│──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────│
│ 06:00│ ☀️   │ ☀️   │ ☀️   │ ☀️   │ ☀️   │      │      │
│ 07:00│ ████ │ ████ │ ████ │ ████ │ ████ │      │      │
│ 08:00│      │      │      │      │      │      │      │
│ 09:00│ 💻   │ 💻   │ 💻   │ 💼   │ 💻   │      │      │
│ 10:00│ Deep │ Deep │ Deep │ Réun │ Deep │      │      │
│ 11:00│ Work │ Work │ Work │      │ Work │      │      │
│ 12:00│ 🍽️   │ 🍽️   │ 🍽️   │ 🍽️   │ 🍽️   │      │      │
│ 13:00│      │      │      │      │      │      │      │
│ 14:00│ 💼   │ 📚   │ 💼   │ 💻   │ 💼   │      │      │
│ 15:00│ Réun │ Appre│ Réun │ Deep │ Réun │      │      │
│ 16:00│      │      │      │ Work │      │      │      │
│ 17:00│      │      │      │      │      │      │      │
│ 18:00│ 🏋️   │ 🏋️   │ 🏋️   │ 🏋️   │ 🏋️   │ 🏋️   │      │
│ 19:00│ Sport│ Sport│ Sport│ Sport│ Sport│ Sport│      │
│ 20:00│ 🌙   │ 🌙   │ 🌙   │ 🌙   │ 🌙   │      │      │
│ 21:00│      │      │      │      │      │      │      │
└──────────────────────────────────────────────────────────┘
```

---

### 5.6 Détail d'une Habit

```
┌─────────────────────────────────────┐
│  ← 💪 Pompes                  ✏️   │
├─────────────────────────────────────┤
│                                     │
│  🎯 Objectif: 500 pompes / jour    │
│  🌐 Domaine: Santé physique        │
│  🕐 Créneau: 18:00 — 19:00        │
│  🔄 Fréquence: Tous les jours     │
│  🔗 KR: "15 000 pompes Q1"        │
│                                     │
│  ─── AUJOURD'HUI ─────────────── │
│  ┌─────────────────────────────┐   │
│  │  Statut: ⚠️+ Hors créneau,  │   │
│  │          objectif dépassé    │   │
│  │                              │   │
│  │  520/500 pompes (+4%)       │   │
│  │  ████████████████████░ 104% │   │
│  │                              │   │
│  │  Plage: 07:15 → 07:40      │   │
│  │  Durée: 25 min              │   │
│  │  Note: "Bonne énergie"     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── CETTE SEMAINE ────────────── │
│                                     │
│  L      M      M      J      V    │
│  ✅+    ⚠️✅   ✅     📉    ✅+   │
│  520    500    500    420    550   │
│  07h    07h    18h    22h    18h   │
│                                     │
│  Moy: 498  │  Taux: 100% (5/5)   │
│  Moy durée: 27 min               │
│                                     │
│  ─── IMPACT OKR ──────────────── │
│  ┌─────────────────────────────┐   │
│  │  🎯 "15 000 pompes Q1"      │   │
│  │  ████████████░░░░░░ 8400    │   │
│  │  56% — rythme: OK ✅        │   │
│  │                              │   │
│  │  Prédiction: atteint le     │   │
│  │  8 Mars (dans 17 jours)     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── HISTORIQUE ───────────────── │
│  Fév:  ██████████████████ 92%    │
│  Jan:  ████████████████░░ 85%    │
│                                     │
│  🔥 Streak actuel: 8 jours        │
│  🏆 Meilleur streak: 21 jours     │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.7 Complétion d'une Habit (binaire)

```
┌─────────────────────────────────────┐
│  ← 🧘 Méditation                   │
├─────────────────────────────────────┤
│                                     │
│        [ ✅ C'est fait ! ]         │
│                                     │
│  ── Précisions (optionnel) ─────── │
│                                     │
│  Plage horaire:                    │
│  De [ 06:15 ]  à  [ 06:40 ]       │
│                                     │
│  Note:                             │
│  ┌─────────────────────────────┐   │
│  │ Séance calme, bonne focus   │   │
│  └─────────────────────────────┘   │
│                                     │
│  [     Enregistrer     ]           │
│                                     │
└─────────────────────────────────────┘
```

### 5.8 Complétion d'une Habit (quantitative)

```
┌─────────────────────────────────────┐
│  ← 💪 Pompes              🎯 500   │
├─────────────────────────────────────┤
│                                     │
│  Combien ?                         │
│  ┌─────────────────────────────┐   │
│  │         [ 520 ]             │   │
│  │         pompes              │   │
│  └─────────────────────────────┘   │
│                                     │
│  520/500  ████████████████░  +4%   │
│                                     │
│  ── Précisions (optionnel) ─────── │
│                                     │
│  Plage horaire:                    │
│  De [ 07:15 ]  à  [ 07:40 ]       │
│                                     │
│  Note:                             │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  [     Enregistrer     ]           │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.9 Vue Domaines (Radar)

```
┌─────────────────────────────────────┐
│  ← 🌐 Mes Domaines                 │
├─────────────────────────────────────┤
│                                     │
│         Santé                       │
│          92%                        │
│           ╱╲                        │
│     Créa╱    ╲Travail              │
│      30%      78%                  │
│       ╱  ╲  ╱  ╲                   │
│      ╱    ╲╱    ╲                  │
│     ╱     ╱╲     ╲                 │
│    Finance   Famille               │
│     65%       45%                  │
│                                     │
│  Score global: 62%                 │
│                                     │
│  ─── DÉTAIL PAR DOMAINE ───────── │
│                                     │
│  🏋️ Santé               92%  ████▌│
│    10h / 10h cette semaine         │
│    3 habits actives · streak 12j   │
│                                     │
│  💼 Travail              78%  ███░▌│
│    35h / 40h cette semaine         │
│    2 projets actifs                │
│                                     │
│  💰 Finance              65%  ██░░▌│
│    3h / 5h cette semaine           │
│    1 OKR en cours                  │
│                                     │
│  👨‍👩‍👧 Famille             45%  █░░░▌│
│    4h / 10h cette semaine  ⚠️      │
│    "Sous le budget depuis 3 sem"   │
│                                     │
│  🎨 Créativité           30%  █░░░▌│
│    1h / 5h cette semaine   ⚠️      │
│    Aucune activité depuis 9j       │
│                                     │
│  [ ➕ Nouveau domaine ]            │
│  [ ⚙️ Gérer les domaines ]         │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.10 Vue OKR

```
┌─────────────────────────────────────┐
│  ← 🎯 Objectifs           Q1 2026 │
├─────────────────────────────────────┤
│                                     │
│  ─── 🏋️ SANTÉ ────────────────── │
│                                     │
│  🎯 Être en excellente forme      │
│  ┌─────────────────────────────┐   │
│  │ KR1: 15 000 pompes          │   │
│  │ ██████████░░░░░░░░ 8400     │   │
│  │ 56% · rythme OK ✅          │   │
│  │ Prévu: 8 Mars               │   │
│  │ Alimenté par: 💪 Pompes     │   │
│  │                              │   │
│  │ KR2: Courir 100km           │   │
│  │ █████████░░░░░░░░░ 42km     │   │
│  │ 42% · en retard ⚠️          │   │
│  │ Prévu: 25 Mars (tard)       │   │
│  │ Alimenté par: 🏃 Course     │   │
│  │                              │   │
│  │ KR3: Perdre 5kg             │   │
│  │ ████░░░░░░░░░░░░░░ 2.1kg   │   │
│  │ 42% · en retard ⚠️          │   │
│  │ Saisie manuelle             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 💼 TRAVAIL ──────────────── │
│                                     │
│  🎯 Lancer LifeFlow v1            │
│  ┌─────────────────────────────┐   │
│  │ KR1: MVP fonctionnel        │   │
│  │ ██████░░░░░░░░░░░░ 35%     │   │
│  │ Alimenté par: Projet "MVP"  │   │
│  │                              │   │
│  │ KR2: 100 beta users         │   │
│  │ ██░░░░░░░░░░░░░░░░ 12%     │   │
│  │ Saisie manuelle             │   │
│  └─────────────────────────────┘   │
│                                     │
│  [ ➕ Nouvel objectif ]            │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.11 Vue Insights (IA)

```
┌─────────────────────────────────────┐
│  ← 💡 Insights                🔔 5 │
├─────────────────────────────────────┤
│                                     │
│  ─── 🔴 HAUTE PRIORITÉ ────────── │
│  ┌─────────────────────────────┐   │
│  │ ⚡ Vélocité KR insuffisante  │   │
│  │                              │   │
│  │ "Courir 100km" à 42% —      │   │
│  │ deadline dans 3 semaines.    │   │
│  │ Tu dois courir 4.7km/jour.  │   │
│  │                              │   │
│  │ [Voir KR] [Planifier]  [✕] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 🟡 OBSERVATIONS ──────────── │
│  ┌─────────────────────────────┐   │
│  │ 💪 Objectif pompes dépassé   │   │
│  │                              │   │
│  │ 4×/sem à +15% en moyenne.   │   │
│  │ Passer de 500 à 600 ?       │   │
│  │                              │   │
│  │ [Oui, 600] [Non merci] [💤]│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🕐 Décalage horaire détecté  │   │
│  │                              │   │
│  │ Pompes prévues à 18h, faites│   │
│  │ à 7h en moy. (12/15 jours).│   │
│  │ Déplacer le créneau à 7h ?  │   │
│  │                              │   │
│  │ [Déplacer] [Garder 18h] [💤]│  │
│  └─────────────────────────────┘   │
│                                     │
│  ─── 🟢 ENCOURAGEMENTS ────────── │
│  ┌─────────────────────────────┐   │
│  │ 🔥 Méditation: 12 jours !   │   │
│  │                              │   │
│  │ Ta plus longue série !      │   │
│  │ Les jours où tu médites,    │   │
│  │ +40% de tâches complétées.  │   │
│  │                              │   │
│  │                      [Nice] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 Revue hebdo disponible   │   │
│  │                              │   │
│  │ 5 domaines, 2 en hausse,   │   │
│  │ 1 en baisse. 3 insights.   │   │
│  │                              │   │
│  │ [Voir la revue]             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👨‍👩‍👧 Famille négligée         │   │
│  │                              │   │
│  │ 4h/10h cette semaine.       │   │
│  │ Sous budget 3 semaines      │   │
│  │ consécutives.               │   │
│  │                              │   │
│  │ [Planifier bloc] [💤] [✕]  │   │
│  └─────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.12 Statistiques

```
┌─────────────────────────────────────┐
│  ← 📊 Statistiques    [7j][30j][Q] │
├─────────────────────────────────────┤
│                                     │
│  ─── VUE D'ENSEMBLE ────────────── │
│                                     │
│  Taux complétion habits: 87%       │
│  ████████████████░░░               │
│                                     │
│  Streak moyen: 8 jours            │
│  Meilleur streak: 21j (Méditation) │
│                                     │
│  Tâches complétées: 23/31          │
│  Routines complétées: 12/14       │
│                                     │
│  ─── HABITS ───────────────────── │
│                                     │
│  💪 Pompes         100%  ████████▌ │
│     Moy: 498/500 · Streak: 8j     │
│                                     │
│  🧘 Méditation      92%  ███████░▌ │
│     Streak: 12j (record!)          │
│                                     │
│  📖 Lecture          71%  █████░░░▌ │
│     Moy: 25min/30min              │
│                                     │
│  🏃 Course           57%  ████░░░░▌ │
│     Moy: 4.2km · sous objectif    │
│                                     │
│  ─── TEMPS PAR DOMAINE ───────── │
│  (cette semaine)                   │
│                                     │
│  💼 Travail    ████████████  35h   │
│  🏋️ Santé      ████         10h   │
│  👨‍👩‍👧 Famille    ██            4h   │
│  💰 Finance    █             3h   │
│  📚 Apprendre  █             2h   │
│  🎨 Créativité ░             1h   │
│                              ────  │
│                              55h   │
│                                     │
│  ─── TENDANCE (30 jours) ──────── │
│                                     │
│  Complétion habits:                │
│  100│                      ╱─     │
│   80│    ╱─╲    ╱──╲  ╱──╱       │
│   60│╱──╱   ╲╱─╱    ╲╱           │
│   40│                              │
│     └──────────────────────────── │
│      S1   S2   S3   S4   S5      │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.13 Paramètres IA

```
┌─────────────────────────────────────┐
│  ← ⚙️ Paramètres IA                │
├─────────────────────────────────────┤
│                                     │
│  ─── GÉNÉRAL ──────────────────── │
│                                     │
│  Insights activés        [██ ON ]  │
│  Notifications insights  [██ ON ]  │
│  Fréquence:  [Quotidien       ▼]  │
│                                     │
│  ─── PATTERNS SURVEILLÉS ──────── │
│                                     │
│  ✅ Décalage horaire               │
│     Détecte quand tu fais tes      │
│     habits hors du créneau prévu   │
│                                     │
│  ✅ Dépassement d'objectif         │
│     Suggère d'augmenter la cible   │
│     si tu dépasses régulièrement   │
│                                     │
│  ✅ Streak en danger               │
│     Rappel si une série risque     │
│     d'être brisée                  │
│                                     │
│  ✅ Domaine négligé                │
│     Alerte si un domaine n'a       │
│     aucune activité depuis longtemps│
│                                     │
│  ✅ Vélocité OKR                   │
│     Prévient si un KR ne sera      │
│     pas atteint au rythme actuel   │
│                                     │
│  ✅ Budget temps                   │
│     Écart entre heures prévues     │
│     et heures réelles > 30%        │
│                                     │
│  ✅ Routine drift                  │
│     Étapes régulièrement sautées   │
│                                     │
│  ✅ Inbox saturée                  │
│     Trop d'items non traités       │
│                                     │
│  ─── IA CLOUD (GPT-4o) ────────── │
│                                     │
│  Analyses cloud        [░░ OFF ]   │
│  (corrélations, résumé hebdo,      │
│   prédictions, reformulations)     │
│                                     │
│  ⚠️ Nécessite un envoi de données  │
│  agrégées vers nos serveurs.       │
│  [En savoir plus sur la vie privée]│
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.14 Gestion des Domaines

```
┌─────────────────────────────────────┐
│  ← ⚙️ Domaines de vie              │
├─────────────────────────────────────┤
│                                     │
│  Glisser pour réordonner           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ≡ 🏋️ Santé        10h/sem  │   │
│  │   3 habits · 1 OKR         │   │
│  │   Score: 92%        [✏️][🗑]│  │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ≡ 💼 Travail       40h/sem  │   │
│  │   2 projets · 1 OKR        │   │
│  │   Score: 78%        [✏️][🗑]│  │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ≡ 👨‍👩‍👧 Famille      10h/sem  │   │
│  │   1 habit · 0 OKR          │   │
│  │   Score: 45% ⚠️     [✏️][🗑]│  │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ≡ 💰 Finance        5h/sem  │   │
│  │   1 OKR                     │   │
│  │   Score: 65%        [✏️][🗑]│  │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ≡ 🎨 Créativité     5h/sem  │   │
│  │   0 habits · 0 OKR         │   │
│  │   Score: 30% ⚠️     [✏️][🗑]│  │
│  └─────────────────────────────┘   │
│                                     │
│  [ ➕ Ajouter un domaine ]         │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.15 Revue Hebdomadaire

```
┌─────────────────────────────────────┐
│  ← 📊 Revue de la semaine         │
│     Semaine du 10 au 16 Fév       │
├─────────────────────────────────────┤
│                                     │
│  ─── RÉSUMÉ IA ────────────────── │
│  ┌─────────────────────────────┐   │
│  │ "Bonne semaine pour Santé   │   │
│  │ (92%) et Travail (78%).     │   │
│  │ Famille en baisse pour la   │   │
│  │ 3e semaine — tu pourrais    │   │
│  │ bloquer un créneau ce       │   │
│  │ week-end. Méditation :      │   │
│  │ record de 12 jours !"      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─── DOMAINES ─────────────────── │
│                                     │
│  🏋️ Santé       92%  ▲ +5%        │
│  💼 Travail     78%  ▼ -3%        │
│  💰 Finance     65%  ═ stable     │
│  👨‍👩‍👧 Famille    45%  ▼ -10% ⚠️   │
│  🎨 Créativité  30%  ▼ -15% ⚠️   │
│                                     │
│  ─── HIGHLIGHTS ───────────────── │
│                                     │
│  🏆 Méditation: 12 jours (record) │
│  🏆 Pompes: 104% en moyenne       │
│  ⚠️ Course: 57% seulement         │
│  ⚠️ Famille: 4h/10h budgétées     │
│                                     │
│  ─── OKR PROGRESSION ──────────── │
│                                     │
│  "Être en forme"     ███░░ 56%    │
│  "Lancer LifeFlow"  ██░░░ 35%    │
│                                     │
│  ─── ACTIONS SUGGÉRÉES ─────────── │
│                                     │
│  1. Bloquer 3h Famille ce weekend │
│     [Créer un bloc]               │
│                                     │
│  2. Augmenter cible pompes → 600  │
│     [Appliquer]                    │
│                                     │
│  3. Planifier 2 sorties course    │
│     [Voir le KR]                   │
│                                     │
├─────────────────────────────────────┤
│  🏠     📥     ➕     📅    💡     │
└─────────────────────────────────────┘
```

---

### 5.16 Navigation (Bottom Bar)

```
┌─────────────────────────────────────┐
│  🏠       📥       ➕       📅       💡  │
│  Home    Inbox   Quick    Cal   Insights│
│                                     │
│  🏠 Home     = Vue Aujourd'hui      │
│  📥 Inbox    = GTD Inbox            │
│  ➕ Quick    = Capture rapide       │
│  📅 Cal      = Calendrier/Blocs     │
│  💡 Insights = Feed IA              │
│                                     │
│  Accès secondaire (depuis Home) :   │
│  📊 Stats    = Statistiques         │
│  🌐 Domaines = Radar + détail      │
│  🎯 OKR      = Objectifs           │
│  ⚙️ Settings = Paramètres           │
└─────────────────────────────────────┘
```

---

## 6. Features par Phase

### 🔴 Phase 1 — MVP (8 semaines)

> **Objectif** : une app utilisable au quotidien

| # | Feature | Écrans |
|---|---------|--------|
| 1 | Auth (Supabase) | Login, Register, Forgot Password |
| 2 | Onboarding (3 écrans) | Bienvenue, Domaines, Première routine |
| 3 | Habits (binaire + quantitatif) | Création, Complétion, Détail, Liste |
| 4 | Routines | Création, Exécution en cours, Historique |
| 5 | Vue Aujourd'hui | Dashboard quotidien |
| 6 | Domaines de vie | CRUD, Score de santé auto-calculé |
| 7 | GTD Inbox | Capture, Liste, Transformation |
| 8 | Tâches simples | CRUD, complétion |
| 9 | Capture rapide (➕) | Bottom sheet |

**Tables Supabase** : profiles, domains, habits, habit_logs, routines, routine_steps, routine_logs, tasks, inbox_items

### 🟡 Phase 2 — Profondeur (6 semaines)

> **Objectif** : rendre visible l'impact

| # | Feature | Écrans |
|---|---------|--------|
| 10 | OKR / Key Results | Création, Vue par domaine, Progression |
| 11 | Lien Habit → KR (auto) | Config dans habit, auto-calcul KR |
| 12 | Projets | CRUD, liste de tâches, progression |
| 13 | Blocs de temps | Création, Calendrier jour/semaine |
| 14 | Statistiques | Stats habits, temps/domaine, tendances |
| 15 | AI Insights (Niveau 1) | Feed, accept/snooze/dismiss |
| 16 | Budget temps par domaine | Config objectif h/sem, calcul auto |
| 17 | Radar des domaines | Visualisation graphique |

**Tables Supabase** : okrs, key_results, projects, time_blocks, insight_cards

### 🟢 Phase 3 — Intelligence (6 semaines)

> **Objectif** : l'IA qui rend l'app unique

| # | Feature | Écrans |
|---|---------|--------|
| 18 | AI Insights (Niveau 2, Cloud) | Corrélations, prédictions, résumé |
| 19 | Revue hebdomadaire | Résumé IA, actions suggérées |
| 20 | Nudges contextuels | Notifications intelligentes |
| 21 | Paramètres IA | Patterns on/off, cloud on/off |
| 22 | Focus Timer | Pomodoro intégré aux blocs |

### 🔵 Phase 4 — Écosystème (continu)

| # | Feature |
|---|---------|
| 23 | Sync Google/Apple Calendar |
| 24 | Widget mobile (habits du jour) |
| 25 | Offline-first (SQLite local → sync) |
| 26 | Templates de routines |
| 27 | Export de données |
| 28 | Push notifications (Firebase) |

---

## 7. Stack Technique

```
┌─────────────────────────────────────────────────────┐
│                    ARCHITECTURE                      │
│                                                      │
│  ┌──────────────┐     ┌──────────────┐              │
│  │   Flutter     │     │  Supabase    │              │
│  │   (Client)    │◄───►│  (BaaS)      │              │
│  │              │     │              │               │
│  │ Stacked MVVM │     │ Auth         │              │
│  │ GetIt DI     │     │ PostgreSQL   │              │
│  │ Dartz Either │     │ RLS          │              │
│  │ Dio HTTP     │     │ Realtime     │              │
│  └──────┬───────┘     │ Storage      │              │
│         │             └──────┬───────┘              │
│         │                    │                       │
│         │  HTTP (heavy only) │ supabase-py           │
│         │                    │                       │
│         ▼                    ▼                       │
│  ┌────────────────────────────────┐                  │
│  │          FastAPI               │                  │
│  │                                │                  │
│  │  /api/v1/insights/generate     │                  │
│  │  /api/v1/insights/weekly       │                  │
│  │  /api/v1/webhooks/moneroo      │                  │
│  │                                │                  │
│  │  GPT-4o (analyses complexes)   │                  │
│  └────────────────────────────────┘                  │
└─────────────────────────────────────────────────────┘
```

### Flutter — Structure de fichiers (Phase 1)

```
lib/
├── app/
│   ├── app.dart              # Routes
│   ├── app.locator.dart      # GetIt DI
│   └── app.router.dart       # Generated
├── core/
│   ├── config/               # App config, env
│   ├── errors/               # Failure types
│   └── utils/                # Helpers
├── domain/
│   ├── models/               # Entities
│   │   ├── habit.dart
│   │   ├── habit_log.dart
│   │   ├── routine.dart
│   │   ├── task.dart
│   │   ├── domain_life.dart
│   │   ├── inbox_item.dart
│   │   └── insight_card.dart
│   └── repositories/         # Interfaces
│       ├── i_habit_repository.dart
│       ├── i_routine_repository.dart
│       ├── i_task_repository.dart
│       └── i_inbox_repository.dart
├── data/
│   └── repositories/         # Supabase implementations
│       ├── habit_repository_impl.dart
│       ├── routine_repository_impl.dart
│       ├── task_repository_impl.dart
│       └── inbox_repository_impl.dart
├── features/
│   ├── home/                 # Vue Aujourd'hui
│   ├── habits/               # CRUD + complétion
│   ├── routines/             # CRUD + exécution
│   ├── tasks/                # CRUD
│   ├── inbox/                # GTD inbox
│   ├── domains/              # Gestion domaines
│   ├── calendar/             # Blocs de temps
│   ├── insights/             # Feed IA
│   ├── stats/                # Statistiques
│   ├── okr/                  # Objectifs
│   └── onboarding/           # 3 écrans
├── services/
│   ├── insight_engine.dart   # Niveau 1 (local)
│   └── ai_service.dart       # Niveau 2 (cloud)
└── design_system/
    ├── widgets/              # Composants réutilisables
    └── theme/                # Couleurs, typo
```

---

## 8. Migrations Supabase (ordre)

```
Existantes:
  20260122000000_create_profiles.sql        ✅
  20260123000005_create_payments.sql         ✅

À créer (Phase 1):
  20260220000001_create_domains.sql
  20260220000002_create_habits.sql
  20260220000003_create_habit_logs.sql
  20260220000004_create_routines.sql
  20260220000005_create_tasks.sql
  20260220000006_create_inbox_items.sql

À créer (Phase 2):
  20260220000010_create_okrs.sql
  20260220000011_create_key_results.sql
  20260220000012_create_projects.sql
  20260220000013_create_time_blocks.sql
  20260220000014_create_insight_cards.sql
```

Chaque migration inclut : table, indexes, RLS policies, triggers (updated_at), fonctions utilitaires.

---

## Annexe — Glossaire rapide

| Terme | Définition courte |
|-------|-------------------|
| **Habit binaire** | Fait ou pas fait. Ex: Méditation |
| **Habit quantitative** | Valeur saisie. Ex: 500 pompes |
| **Routine** | Séquence d'étapes à dérouler dans l'ordre |
| **Bloc de temps** | Plage horaire réservée dans le calendrier |
| **Domaine** | Sphère de vie (Santé, Travail...) avec budget temps optionnel |
| **OKR** | Objectif + Key Results mesurables |
| **KR auto-alimenté** | KR dont la valeur se calcule depuis les HabitLogs |
| **Inbox** | Zone de capture GTD — on trie plus tard |
| **InsightCard** | Observation de l'IA avec action suggérée |
| **Progressive disclosure** | Montrer le simple d'abord, la profondeur sur demande |

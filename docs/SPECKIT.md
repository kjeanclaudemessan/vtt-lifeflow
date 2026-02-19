# 🌱 Spec Kit — Guide d'utilisation LifeFlow

> **Spec-Driven Development** : on définit le *quoi* et le *pourquoi* avant le *comment*.
> Spec Kit structure le processus en étapes claires pour que l'IA génère du code prévisible et de qualité.

---

## Installation

```powershell
# Installer le CLI (une seule fois)
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# Mettre à jour
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# Lancer sans installer (one-shot)
uvx --from git+https://github.com/github/spec-kit.git specify <commande>
```

> ⚠️ Si `specify` n'est pas dans le PATH, utiliser `uvx --from git+https://github.com/github/spec-kit.git specify ...`
> ou ajouter le dossier `uv tool bin` au PATH avec `uv tool update-shell`.

---

## Structure générée

```
lifeflow/
├── .specify/
│   ├── memory/
│   │   └── constitution.md      # Principes du projet
│   ├── scripts/
│   │   └── powershell/          # Scripts utilitaires
│   └── templates/               # Templates pour chaque étape
│       ├── constitution-template.md
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── checklist-template.md
├── .github/
│   └── prompts/
│       ├── speckit.constitution.prompt.md
│       ├── speckit.specify.prompt.md
│       ├── speckit.plan.prompt.md
│       ├── speckit.tasks.prompt.md
│       ├── speckit.implement.prompt.md
│       ├── speckit.clarify.prompt.md
│       ├── speckit.analyze.prompt.md
│       └── speckit.checklist.prompt.md
└── features/                    # Créé automatiquement par feature
    └── 001-nom-feature/
        ├── spec.md
        ├── plan.md
        └── tasks.md
```

---

## Workflow — Les 6 étapes

### 1. `/speckit.constitution` — Définir les principes

Établit les règles fondamentales du projet (qualité, conventions, archi).
À faire **une seule fois** au début du projet.

```
/speckit.constitution Principes : Flutter + Stacked MVVM, FastAPI, Supabase.
Tests obligatoires. Code en anglais, commits conventionnels. Modules autonomes.
```

**Résultat** → `.specify/memory/constitution.md`

---

### 2. `/speckit.specify` — Décrire la feature

Décrit le *quoi* et le *pourquoi* sans mentionner la tech.
Se concentrer sur les scénarios utilisateur.

```
/speckit.specify Créer un système de budget temps par domaine de vie.
L'utilisateur définit des objectifs d'heures par domaine (Spirituel, Santé, Travail...).
Le temps est tracké automatiquement depuis les habits, blocs de temps et routines.
Vue semaine et mois avec alertes si en retard.
```

**Résultat** → `features/XXX-nom/spec.md`

---

### 3. `/speckit.plan` — Planifier l'implémentation

Définit le *comment* technique : stack, architecture, fichiers à créer/modifier.

```
/speckit.plan Stack : Flutter avec Stacked MVVM, Supabase pour la DB,
migrations SQL. Pas de FastAPI pour cette feature.
```

**Résultat** → `features/XXX-nom/plan.md`

---

### 4. `/speckit.tasks` — Générer les tâches

Découpe le plan en tâches actionnables et ordonnées.

```
/speckit.tasks
```

**Résultat** → `features/XXX-nom/tasks.md`

---

### 5. `/speckit.implement` — Exécuter

L'IA implémente toutes les tâches une par une.

```
/speckit.implement
```

---

### 6. Commandes optionnelles (qualité)

| Commande | Quand | Rôle |
|----------|-------|------|
| `/speckit.clarify` | Après `specify`, avant `plan` | Poser des questions pour lever les ambiguïtés |
| `/speckit.analyze` | Après `tasks`, avant `implement` | Vérifier la cohérence entre spec ↔ plan ↔ tâches |
| `/speckit.checklist` | Après `plan` | Générer une checklist qualité |

---

## Workflow recommandé pour LifeFlow

```
┌─────────────────────────────────────────────────────────┐
│  1. /speckit.constitution  (une seule fois)             │
│         ↓                                               │
│  Pour chaque feature :                                  │
│         ↓                                               │
│  2. /speckit.specify   → décrire la feature             │
│         ↓                                               │
│  3. /speckit.clarify   → (optionnel) lever les doutes   │
│         ↓                                               │
│  4. /speckit.plan      → choix techniques               │
│         ↓                                               │
│  5. /speckit.checklist → (optionnel) validation qualité │
│         ↓                                               │
│  6. /speckit.tasks     → découper en tâches             │
│         ↓                                               │
│  7. /speckit.analyze   → (optionnel) cohérence          │
│         ↓                                               │
│  8. /speckit.implement → coder !                        │
└─────────────────────────────────────────────────────────┘
```

---

## Bonnes pratiques

- **Une feature = une branche Git** → Spec Kit détecte la branche pour nommer le dossier feature
- **Spécifier en langage métier**, pas technique → la tech vient dans `/speckit.plan`
- **Itérer** → on peut relancer `specify` ou `plan` pour affiner
- **La constitution est partagée** → elle s'applique à toutes les features
- **Committer les fichiers `.specify/`** → c'est la documentation vivante du projet

---

## Liens utiles

- [GitHub Spec Kit](https://github.com/github/spec-kit)
- [Méthodologie complète](https://github.com/github/spec-kit/blob/main/spec-driven.md)
- [Vidéo démo](https://www.youtube.com/watch?v=a9eR1xsfvHg)

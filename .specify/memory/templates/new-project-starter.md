# Nouveau Projet — Starter Kit

> **Copie ce dossier à chaque nouveau projet.** C'est ta boîte à outils réutilisable.
> Rien ici n'est spécifique à un projet — tout est générique.

---

## Ce que tu copies

### Depuis `.specify/memory/templates/`

```
templates/
├── product-context-prompt.md         → Tu remplis en 5 min (input initial)
├── business-model-template.md        → L'IA rédige le BM complet
├── persona-template.md               → L'IA approfondit la cible
├── feature-scoring-template.md       → L'IA priorise les features
├── competitive-analysis-template.md  → L'IA analyse la concurrence
├── spec-quality-checklist.md         → Checklist avant de coder une spec
├── voice-and-tone-template.md        → L'IA définit la personnalité du produit
└── workflow.md                       → L'ordre de tout (ce fichier est le mode d'emploi)
```

### Depuis `.specify/memory/`

```
product-analysis-framework.md         → Grille d'audit produit (26 critères, 7 dimensions)
```

### Ton Design System Flutter (si projet Flutter)

```
flutter/lib/design_system/            → Tout le dossier. Tu changes seulement :
  └── tokens/app_colors.dart          → Palette du nouveau projet
  └── theme/app_theme.dart            → Ajustements thème si nécessaire
```

---

## Ce que tu NE copies PAS

| Fichier | Pourquoi |
|---------|----------|
| `constitution.md` | Spécifique à l'archi d'un projet (même si la structure se ressemble, les règles détaillées changent) |
| `phases-roadmap.md` | Spécifique aux features d'un projet |
| `business_model_[nom].md` (rempli) | C'est le BM d'un projet spécifique |
| `specs/*` | Specs d'un projet spécifique |
| Tout le code | Évident |

---

## L'ordre quand tu démarres un nouveau projet

```
1. Créer le repo / dossier
2. Copier le dossier templates/ dedans
3. Copier product-analysis-framework.md
4. Copier le Design System Flutter (si Flutter)
5. Ouvrir product-context-prompt.md → remplir (5 min)
6. Suivre workflow.md étape par étape
```

---

## Structure cible d'un nouveau projet

```
[nouveau-projet]/
├── .specify/
│   └── memory/
│       ├── templates/                ← Copié du starter kit (ne pas modifier)
│       │   ├── product-context-prompt.md
│       │   ├── business-model-template.md
│       │   ├── persona-template.md
│       │   ├── feature-scoring-template.md
│       │   ├── competitive-analysis-template.md
│       │   ├── spec-quality-checklist.md
│       │   ├── voice-and-tone-template.md
│       │   └── workflow.md
│       ├── product-analysis-framework.md  ← Copié du starter kit
│       └── constitution.md                ← À créer pour ce projet
├── docs/
│   ├── product-context-prompt.md     ← REMPLI pour ce projet
│   ├── business-model.md             ← REMPLI pour ce projet
│   ├── product-audit.md              ← REMPLI pour ce projet
│   ├── personas.md                   ← REMPLI pour ce projet
│   ├── competitive-analysis.md       ← REMPLI pour ce projet
│   ├── feature-scoring.md            ← REMPLI pour ce projet
│   └── voice-and-tone.md             ← REMPLI pour ce projet
├── specs/                            ← SpecKit, par feature
└── [code source]/                    ← Flutter, FastAPI, etc.
```

> **`templates/`** = les templates vides (jamais modifiés, toujours copiés tels quels)
> **`docs/`** = les documents remplis pour CE projet
> Les templates servent de modèle, les docs sont le résultat

---

## Checklist rapide — "Est-ce que j'ai tout ?"

- [ ] `templates/` copié avec les 8 fichiers
- [ ] `product-analysis-framework.md` copié
- [ ] Design System copié (si Flutter)
- [ ] `product-context-prompt.md` rempli dans `docs/`
- [ ] Prêt à suivre `workflow.md`

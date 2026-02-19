# Workflow — De l'idée au produit

> **Ce document est le mode d'emploi.** Il montre l'ordre exact de tout.
> Chaque étape référence le template à utiliser.
> Temps estimé pour un solo créateur assisté par IA.

---

## Vue d'ensemble

```
┌─────────────────────────────────────────────────────────────────┐
│                        AVANT (3-4h)                             │
│                                                                 │
│   Context Prompt ──→ Business Model ──→ 🔍 AUDIT PRODUIT       │
│      (5 min)          (IA: 1-2h)        (IA: 20 min)           │
│                                                                 │
│   Si audit < 7/10 → corriger le BM. Si < 8/10 désir. → STOP   │
│                          ↓ (score OK)                           │
│                       Personas                                  │
│                      (IA: 30 min)                               │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                   PENDANT — Cadrage (1.5-2.5h)                  │
│                                                                 │
│   Analyse concurrence ──→ Feature scoring ──→ Voice & Tone     │
│      (IA: 45 min)          (IA: 30 min)       (IA: 20 min)     │
│                                         ↓                       │
│                                  DS Config (10 min)             │
│                          (couleurs + config du projet)          │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                   PENDANT — Par feature (SpecKit)               │
│                                                                 │
│   Spec ──→ Plan ──→ Tasks ──→ Implement ──→ Checklist          │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                        APRÈS (continu)                          │
│                                                                 │
│   Mesurer ──→ Ajuster le BM ──→ Prochaine phase                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## AVANT — Cadrage produit

> Objectif : savoir EXACTEMENT quoi construire et pour qui.
> Tu fais ça UNE FOIS par projet, avant d'écrire une seule ligne de code.

### Étape 0 — Product Context Prompt `⏱ 5-10 min — TOI`

| | |
|---|---|
| **Template** | `templates/product-context-prompt.md` |
| **Qui fait quoi** | TOI remplis les 9 champs. C'est ton idée brute, tes contraintes, ta vision. |
| **Résultat** | Un document de cadrage que tu donnes à l'IA pour tout le reste. |
| **Règle** | Sois honnête. "10 000 utilisateurs" est un meilleur objectif que "1 million" si c'est ce que tu vises vraiment. |

### Étape 1 — Business Model `⏱ 1-2h — IA (tu relis et valides)`

| | |
|---|---|
| **Template** | `templates/business-model-template.md` |
| **Input** | Le context prompt rempli |
| **Qui fait quoi** | L'IA recherche le marché, les concurrents, les comportements. Elle rédige le BM complet (15 axes). TOI tu relis, corriges les hypothèses fausses, valides. |
| **Résultat** | Un BM de 600-1200 lignes, ancré dans le réel. |
| **Règle** | Ne valide PAS si les sections "Moment déclencheur" ou "Les 3 morts possibles" ne te convainquent pas. Ce sont les sections les plus critiques. |

### Étape 2 — Audit Produit (Quality Gate) `⏱ 20 min — IA (tu valides)`

| | |
|---|---|
| **Template** | `templates/product-analysis-framework.md` (dans `.specify/memory/`) |
| **Input** | Le BM rédigé |
| **Qui fait quoi** | L'IA évalue le BM sur 26 critères répartis en 7 dimensions (Désirabilité, Utilisabilité, Psychologie, Technique, Design, Business, Marché). Elle attribue un score /10 à chaque critère. TOI tu lis le verdict. |
| **Résultat** | Scorecard complète avec score global, forces, faiblesses, et recommandations. |
| **Seuils** | |

| Seuil | Signification | Action |
|-------|---------------|--------|
| **Désirabilité < 8/10** | Le produit ne répond pas à un vrai besoin | **STOP.** Retravailler le BM sections 5-6-7 avant de continuer |
| **Score global < 7/10** | La vision a des failles majeures | Corriger les critères < 6/10 dans le BM, puis re-auditer |
| **Score global ≥ 7/10** | La vision est solide | Continuer vers les Personas |
| **Score global ≥ 8.5/10** | Excellent | Foncer. |

> **C'est le checkpoint le plus important du workflow.** Si le produit ne passe pas cet audit, tout ce qui suit (personas, scoring, code) est construit sur du sable. Mieux vaut perdre 1h à corriger le BM que 3 mois à coder un produit que personne ne veut.

### Étape 3 — Personas `⏱ 30 min — IA (tu valides)`

| | |
|---|---|
| **Template** | `templates/persona-template.md` |
| **Input** | Le BM rédigé (validé par l'audit) |
| **Qui fait quoi** | L'IA approfondit 2-3 personas + 1 anti-persona. TOI tu vérifies que tu reconnais des vrais gens. |
| **Résultat** | Des personas avec journée type, historique de solutions, raisons de rester/partir. |
| **Règle** | Si le persona primaire ne ressemble à personne que tu connais, recommence. |

---

## PENDANT — Cadrage technique

> Objectif : prioriser et préparer l'exécution.
> Tu fais ça UNE FOIS par projet, après le cadrage produit.

### Étape 4 — Analyse concurrentielle `⏱ 45 min — IA (tu valides)`

| | |
|---|---|
| **Template** | `templates/competitive-analysis-template.md` |
| **Input** | Le BM rédigé |
| **Qui fait quoi** | L'IA analyse 5-8 concurrents en profondeur : avis réels, forces, faiblesses, trous du marché. TOI tu confirmes le positionnement. |
| **Résultat** | Carte du marché, matrice comparative, espace libre identifié. |
| **Règle** | Si "notre espace" n'est pas clair en 1 phrase, l'analyse n'est pas finie. |

### Étape 5 — Feature Scoring `⏱ 30 min — IA (tu ajustes)`

| | |
|---|---|
| **Template** | `templates/feature-scoring-template.md` |
| **Input** | Le BM (features) + Personas + Analyse concurrence |
| **Qui fait quoi** | L'IA score chaque feature sur 5 axes (Impact, Rétention, Différenciation, Faisabilité, Valeur croissante). TOI tu ajustes les scores si nécessaire. |
| **Résultat** | Features classées par priorité, réparties en phases, dépendances identifiées. |
| **Règle** | Phase 1 = score ≥ 18/25. Pas de négociation sentimentale. |

### Étape 6 — Voice & Tone `⏱ 20 min — IA (tu valides)`

| | |
|---|---|
| **Template** | `templates/voice-and-tone-template.md` |
| **Input** | Le BM + Personas |
| **Qui fait quoi** | L'IA définit la personnalité du produit, le vocabulaire, le ton par contexte. TOI tu valides que ça "sonne" juste. |
| **Résultat** | Guide de voix avec exemples concrets pour chaque contexte (succès, échec, demande, erreur). |
| **Règle** | Lis les exemples de notifications à voix haute. Si ça sonne faux, corrige. |

### Étape 7 — Design System Config `⏱ 10 min — TOI`

| | |
|---|---|
| **Input** | Voice & Tone + BM (section 4 — contexte culturel) |
| **Qui fait quoi** | TOI tu configures ton Design System partagé pour ce projet : palette de couleurs, variantes de thème, assets spécifiques (icône, splash). L'IA peut proposer une palette basée sur le Voice & Tone. |
| **Résultat** | `AppColors` configuré pour le projet. Thème light/dark validé. |
| **Ce que tu NE fais PAS** | Recréer le DS. Tu réutilises ton kit existant (widgets, tokens, spacing, typo). Tu changes uniquement les couleurs et les petites configs. |
| **Règle** | Si un composant manque dans le DS, note-le. Tu le créeras dans le DS partagé (pas dans le projet) quand tu en auras besoin. |

---

## PENDANT — Développement par feature (boucle)

> Objectif : construire feature par feature, dans l'ordre du scoring.
> Tu répètes cette boucle pour CHAQUE feature.

```
Pour chaque feature (dans l'ordre du scoring Phase 1 → 2 → 3) :

    ┌─ speckit.specify ──→ spec.md
    │       ↓
    ├─ speckit.plan ──→ plan.md + research.md + data-model.md + quickstart.md
    │       ↓
    ├─ speckit.tasks ──→ tasks.md
    │       ↓
    ├─ Checklist qualité ──→ PRÊTE / PAS PRÊTE
    │       ↓
    ├─ speckit.implement ──→ Code
    │       ↓
    └─ Tests ──→ Feature validée ──→ Feature suivante
```

### Étape 8 — Spec (par feature) `⏱ variable — IA + toi`

| | |
|---|---|
| **Outil** | SpecKit pipeline (`speckit.specify → speckit.plan → speckit.tasks`) |
| **Qui fait quoi** | L'IA rédige les specs en se basant sur le BM, les personas, le scoring. TOI tu valides. |
| **Checklist** | Passe la spec dans `templates/spec-quality-checklist.md` AVANT d'implémenter |
| **Règle** | Si la checklist dit "PAS PRÊTE" → corriger d'abord. Jamais coder une spec incomplète. |

### Étape 9 — Implémentation `⏱ variable`

| | |
|---|---|
| **Outil** | SpecKit (`speckit.implement`) |
| **Ordre** | Supabase (migrations + RLS) → Domain (entities) → Data (models + repos) → Features (UI) |
| **Règle** | Respecter la constitution. Respecter le design system. Respecter le voice & tone. |

### Étape 10 — Validation `⏱ 15-30 min`

| | |
|---|---|
| **Tests** | Les scénarios de quickstart.md sont passés |
| **Qualité** | Pas d'erreur de compilation, pas de warning |
| **UX** | Le persona primaire accomplit son objectif en < 30 secondes |

---

## APRÈS — Mesure et itération

> Objectif : vérifier que le produit est utilisé (pas juste construit).
> Commence dès que la Phase 1 est en production.

### Étape 11 — Mesurer

| Quoi | Comment | Fréquence |
|------|---------|-----------|
| Rétention J1, J7, J30 | Analytics (ou Supabase queries manuelles au début) | Hebdomadaire |
| Comportement d'adoption (défini dans le BM §9.4) | Event tracking sur le geste clé | Quotidien |
| Taux conversion Free → Pro | Supabase + store metrics | Mensuel |
| Feedback qualitatif | Avis stores + feedback in-app | Continu |

### Étape 12 — Ajuster

| Signal | Action |
|--------|--------|
| Rétention J7 < 20% | Revoir l'onboarding et le "aha moment" — relire le persona |
| Conversion < 2% | Revoir ce qui est gratuit vs payant — relire le BM §10.2 |
| Feature peu utilisée | Vérifier son score dans le feature scoring — peut-être la supprimer |
| Plainte récurrente | Ajouter au backlog en priorité — re-scorer |
| Activation metric non atteint | C'est une URGENCE — tout s'arrête jusqu'à ce que ce soit résolu |

### Étape 13 — Phase suivante

| Condition | Action |
|-----------|--------|
| Phase 1 stable + métriques OK | Passer aux features Phase 2 (reprendre à l'étape 6) |
| Phase 1 instable | Corriger Phase 1 d'abord. JAMAIS ajouter des features sur une base qui vacille |
| Hypothèse du BM invalidée | Mettre à jour le BM. Re-scorer les features. Peut-être pivoter Phase 2 |

---

## Récapitulatif — Checklist de démarrage

Avant d'écrire la première ligne de code d'un nouveau projet :

- [ ] Context Prompt rempli (`product-context-prompt.md`)
- [ ] Business Model rédigé et validé (`business-model-template.md`)
- [ ] **Audit produit passé ≥ 7/10 global ET ≥ 8/10 désirabilité** (`product-analysis-framework.md`)
- [ ] Personas rédigés et validés (`persona-template.md`)
- [ ] Analyse concurrentielle faite (`competitive-analysis-template.md`)
- [ ] Features scorées et Phase 1 définie (`feature-scoring-template.md`)
- [ ] Voice & Tone défini (`voice-and-tone-template.md`)
- [ ] Première feature Phase 1 spécifiée via SpecKit
- [ ] Spec passée dans la checklist qualité (`spec-quality-checklist.md`)

**Temps total avant la première ligne de code : ~5h** (dont 15 min de ton temps, le reste c'est l'IA).

---

## Structure de dossiers

```
[projet]/
├── docs/
│   ├── product-context-prompt.md     ← Ton input initial
│   ├── business-model.md             ← Le BM complet
│   ├── product-audit.md              ← Scorecard de l'audit (26 critères)
│   ├── personas.md                   ← Les personas
│   ├── competitive-analysis.md       ← Analyse concurrence
│   ├── feature-scoring.md            ← Scoring des features
│   └── voice-and-tone.md             ← Personnalité du produit
├── specs/
│   ├── [feature-1]/
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   └── ...
│   └── [feature-2]/
│       └── ...
└── [code source]
```

> Les templates vivent dans `.specify/memory/templates/`. Les documents REMPLIS vivent dans `docs/` du projet.

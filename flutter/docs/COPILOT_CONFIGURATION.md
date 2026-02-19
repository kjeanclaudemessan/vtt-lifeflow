# 🤖 Configuration GitHub Copilot - VTT Flutter Template

> **Status**: ✅ **COMPLETED** - All configuration files created.

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Fichiers Créés](#fichiers-créés)
3. [Utilisation](#utilisation)

---

## 🎯 Vue d'Ensemble

### Principe d'Abstraction

Nous utilisons une **hiérarchie d'instructions** :

```
┌─────────────────────────────────────────────────────────────┐
│           copilot-instructions.md (GLOBAL)                  │
│     Règles générales, architecture, conventions             │
├─────────────────────────────────────────────────────────────┤
│              *.instructions.md (PAR TYPE)                   │
│     Règles spécifiques héritant des règles globales         │
│     Ex: dart.instructions.md, test.instructions.md          │
├─────────────────────────────────────────────────────────────┤
│                *.prompt.md (TÂCHES)                         │
│     Prompts pour tâches spécifiques                         │
├─────────────────────────────────────────────────────────────┤
│               agents/*.md (AGENTS)                          │
│     Agents spécialisés avec expertise définie               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Fichiers Créés

### Structure Complète

```
.github/
├── copilot-instructions.md              ✅ Instructions globales
│
├── instructions/                         # 12 fichiers d'instructions
│   ├── dart.instructions.md             ✅ Tous les fichiers .dart
│   ├── view.instructions.md             ✅ *_view.dart
│   ├── viewmodel.instructions.md        ✅ *_viewmodel.dart
│   ├── service.instructions.md          ✅ *_service.dart
│   ├── repository.instructions.md       ✅ *_repository*.dart
│   ├── model.instructions.md            ✅ *_model.dart
│   ├── entity.instructions.md           ✅ *_entity.dart
│   ├── usecase.instructions.md          ✅ *_usecase.dart
│   ├── widget.instructions.md           ✅ ui/widgets/**/*.dart
│   ├── extension.instructions.md        ✅ *_extensions.dart
│   ├── test.instructions.md             ✅ test/**/*.dart
│   └── config.instructions.md           ✅ config/**/*.dart
│
├── prompts/                              # 11 prompts réutilisables
│   ├── create-feature.prompt.md         ✅ Créer une feature complète
│   ├── create-service.prompt.md         ✅ Créer un service
│   ├── create-repository.prompt.md      ✅ Créer repository + interface
│   ├── create-model.prompt.md           ✅ Créer model + entity
│   ├── create-widget.prompt.md          ✅ Créer un widget
│   ├── create-usecase.prompt.md         ✅ Créer un use case
│   ├── write-tests.prompt.md            ✅ Écrire des tests
│   ├── add-i18n.prompt.md               ✅ Ajouter des traductions
│   ├── create-api-endpoint.prompt.md    ✅ Intégrer un endpoint API
│   ├── fix-bug.prompt.md                ✅ Analyser et corriger un bug
│   ├── refactor.prompt.md               ✅ Refactoring guidé
│   └── generate-commit.prompt.md        ✅ Générer message de commit
│
└── agents/                               # 4 agents spécialisés
    ├── code-reviewer.md                 ✅ Code review expert
    ├── architecture-assistant.md        ✅ Aide architecturale
    ├── test-generator.md                ✅ Génération de tests
    └── doc-writer.md                    ✅ Écriture de documentation

.vscode/
├── settings.json                         ✅ Configuration VS Code + Copilot
└── extensions.json                       ✅ Extensions recommandées
```

---

## 📖 Utilisation

### Instructions Automatiques

Les instructions sont automatiquement appliquées selon le fichier en cours d'édition :

- Fichier `*_view.dart` → `view.instructions.md` + `dart.instructions.md`
- Fichier `*_test.dart` → `test.instructions.md` + `dart.instructions.md`
- etc.

### Prompts

Utilisez les prompts dans Copilot Chat pour générer du code structuré :

1. Ouvrez Copilot Chat
2. Tapez `/` pour voir les prompts disponibles
3. Sélectionnez le prompt souhaité
4. Remplissez les variables demandées

### Agents

Les agents sont disponibles pour des tâches spécialisées :

- **Code Reviewer** : Review approfondie avec checklist
- **Architecture Assistant** : Aide sur les décisions d'architecture
- **Test Generator** : Génération de tests complets
- **Doc Writer** : Écriture de documentation

### Personnalisation

Pour ajouter des règles spécifiques à un projet :

1. Créer `.github/instructions/project.instructions.md`
2. Ajouter le header `applyTo` approprié
3. Les règles seront appliquées en plus des règles génériques
   ],

// Instructions pour code review
"github.copilot.chat.reviewSelection.instructions": [
{
"file": ".github/instructions/code-review.instructions.md"
}
]
}

````

---

## 🔗 Références entre Fichiers

### Principe de DRY (Don't Repeat Yourself)

Chaque fichier d'instruction peut référencer d'autres fichiers :

```markdown
<!-- view.instructions.md -->
---
applyTo: "**/*_view.dart"
---

# Instructions pour les Views

## Règles générales
Appliquer toutes les règles de #file:.github/copilot-instructions.md

## Règles Dart
Suivre #file:.github/instructions/dart.instructions.md

## Règles spécifiques aux Views
...
````

### Hiérarchie des Instructions

```
copilot-instructions.md (BASE)
    │
    ├── dart.instructions.md (hérite de BASE)
    │       │
    │       ├── view.instructions.md (hérite de dart)
    │       ├── viewmodel.instructions.md (hérite de dart)
    │       ├── service.instructions.md (hérite de dart)
    │       └── ...
    │
    └── test.instructions.md (hérite de BASE + rules spécifiques)
```

---

## 📝 Checklist de Création

### Phase 1 : Instructions Globales

- [ ] `.github/copilot-instructions.md`

### Phase 2 : Instructions Dart de Base

- [ ] `.github/instructions/dart.instructions.md`

### Phase 3 : Instructions par Composant

- [ ] `.github/instructions/view.instructions.md`
- [ ] `.github/instructions/viewmodel.instructions.md`
- [ ] `.github/instructions/service.instructions.md`
- [ ] `.github/instructions/repository.instructions.md`
- [ ] `.github/instructions/model.instructions.md`
- [ ] `.github/instructions/entity.instructions.md`
- [ ] `.github/instructions/usecase.instructions.md`
- [ ] `.github/instructions/widget.instructions.md`
- [ ] `.github/instructions/extension.instructions.md`

### Phase 4 : Instructions Tests & Config

- [ ] `.github/instructions/test.instructions.md`
- [ ] `.github/instructions/config.instructions.md`

### Phase 5 : Prompts

- [ ] `.github/prompts/create-feature.prompt.md`
- [ ] `.github/prompts/create-view.prompt.md`
- [ ] `.github/prompts/create-service.prompt.md`
- [ ] `.github/prompts/create-repository.prompt.md`
- [ ] `.github/prompts/create-model.prompt.md`
- [ ] `.github/prompts/create-widget.prompt.md`
- [ ] `.github/prompts/create-usecase.prompt.md`
- [ ] `.github/prompts/add-tests.prompt.md`
- [ ] `.github/prompts/add-localization.prompt.md`
- [ ] `.github/prompts/code-review.prompt.md`
- [ ] `.github/prompts/refactor.prompt.md`

### Phase 6 : Agents

- [ ] `.github/agents/flutter-architect.agent.md`
- [ ] `.github/agents/flutter-developer.agent.md`
- [ ] `.github/agents/tester.agent.md`
- [ ] `.github/agents/reviewer.agent.md`

### Phase 7 : Configuration VS Code

- [ ] `.vscode/settings.json`
- [ ] `.vscode/extensions.json`

---

## ❓ Points de Discussion

### 1. Granularité des Instructions

**Option A : Fine (actuelle)**

- Un fichier par type de composant
- Plus précis mais plus de fichiers
- Maintenance plus complexe

**Option B : Groupée**

- Regrouper : `stacked.instructions.md` (view + viewmodel)
- Regrouper : `data.instructions.md` (model + entity + repository)
- Moins de fichiers, plus simple

**Recommandation** : Option A car les patterns sont vraiment différents

### 2. Prompts vs Stacked CLI

Stacked CLI offre déjà :

- `stacked create view <name>`
- `stacked create service <name>`
- etc.

**Question** : Les prompts sont-ils redondants ?

**Réponse** : Non, car les prompts Copilot peuvent :

- Créer du code plus personnalisé (pas juste le scaffold)
- Inclure la logique métier
- Créer plusieurs fichiers liés en une fois
- Adapter au contexte existant

### 3. Agents : Utile ou Overkill ?

Les agents sont utiles si :

- Tu veux limiter les capacités de Copilot selon le contexte
- Tu travailles en équipe avec des rôles différents
- Tu veux des workflows spécialisés

**Si tu es seul** : Les instructions + prompts suffisent peut-être

### 4. Format des Commits

Options :

- **Conventional Commits** : `feat(auth): add login` ✅ Recommandé
- **Gitmoji** : `✨ Add login feature`
- **Simple** : `Add login feature`

---

## 🚀 Prochaines Étapes

1. **Valider** cette structure ensemble
2. **Créer** les fichiers dans l'ordre de la checklist
3. **Tester** avec des cas d'usage réels
4. **Itérer** selon les résultats

---

## 📚 Ressources

- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [GitHub Copilot Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

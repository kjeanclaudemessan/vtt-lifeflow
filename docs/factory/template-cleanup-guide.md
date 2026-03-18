# Guide de nettoyage du template après clonage

> Après avoir cloné le template VTT et renommé le projet (cf. [clone-and-setup-guide.md](clone-and-setup-guide.md)),
> ce guide détaille **comment supprimer les éléments spécifiques à LifeFlow** pour obtenir un template vierge.

---

## Table des matières

- [Guide de nettoyage du template après clonage](#guide-de-nettoyage-du-template-après-clonage)
  - [Table des matières](#table-des-matières)
  - [1. Principes de codage](#1-principes-de-codage)
    - [Ce qui n'a PAS besoin d'être touché](#ce-qui-na-pas-besoin-dêtre-touché)
  - [2. Vue d'ensemble](#2-vue-densemble)
  - [3. Étape 1 — Supprimer les dossiers entiers](#3-étape-1--supprimer-les-dossiers-entiers)
  - [4. Étape 2 — Supprimer les fichiers LifeFlow individuels](#4-étape-2--supprimer-les-fichiers-lifeflow-individuels)
    - [Domain layer (entités + interfaces)](#domain-layer-entités--interfaces)
    - [Data layer (modèles + repositories)](#data-layer-modèles--repositories)
    - [Services LifeFlow](#services-lifeflow)
    - [Assets LifeFlow](#assets-lifeflow)
    - [Documentation LifeFlow](#documentation-lifeflow)
    - [Tests d'intégration LifeFlow](#tests-dintégration-lifeflow)
  - [5. Étape 3 — Nettoyer app.dart](#5-étape-3--nettoyer-appdart)
    - [Imports à SUPPRIMER](#imports-à-supprimer)
    - [Routes à SUPPRIMER](#routes-à-supprimer)
    - [Dependencies à SUPPRIMER](#dependencies-à-supprimer)
    - [Après nettoyage, régénérer](#après-nettoyage-régénérer)
  - [6. Étape 4 — Éditer les fichiers mixtes](#6-étape-4--éditer-les-fichiers-mixtes)
    - [`.specify/memory/constitution.md`](#specifymemoryconstitutionmd)
    - [`docs/process/DEVELOPER_GUIDE.md`](#docsprocessdeveloper_guidemd)
    - [`docs/README.md`](#docsreadmemd)
    - [`MIGRATION_SUPABASE_CLOUD.md`](#migration_supabase_cloudmd)
    - [`.github/workflows/*.yml`](#githubworkflowsyml)
  - [7. Étape 5 — Nettoyer les migrations Supabase](#7-étape-5--nettoyer-les-migrations-supabase)
    - [Migrations à SUPPRIMER (LifeFlow)](#migrations-à-supprimer-lifeflow)
    - [Migrations à GARDER (Core)](#migrations-à-garder-core)
  - [8. Étape 6 — Vérification finale](#8-étape-6--vérification-finale)
  - [9. Récapitulatif — Ce qui RESTE dans le template](#9-récapitulatif--ce-qui-reste-dans-le-template)
    - [Flutter — Structure conservée](#flutter--structure-conservée)
    - [Supabase — Migrations conservées](#supabase--migrations-conservées)
    - [Documentation conservée](#documentation-conservée)
  - [10. Script de nettoyage automatisé](#10-script-de-nettoyage-automatisé)

---

## 1. Principes de codage

**Oui, tous les principes de codage sont clairement documentés et sont 100% génériques** (aucune référence à LifeFlow). Après clonage, un développeur a accès à :

| Document | Chemin | Contenu |
|----------|--------|---------|
| **Instructions monorepo** | `.github/copilot-instructions.md` | Architecture 3 layers, système de modules, communication cross-layer, conventions de nommage |
| **Instructions Flutter** | `flutter/.github/copilot-instructions.md` | Stacked MVVM, Clean Architecture, DI GetIt, layer rules, folder structure |
| **46 instructions spécifiques** | `flutter/.github/instructions/*.md` | Design system, Dart standards, responsive, i18n, a11y, tests, etc. |
| **Instructions FastAPI** | `fastapi/.github/copilot-instructions.md` | Clean Architecture modulaire, settings/schemas, application factory |
| **Instructions Supabase** | `supabase/.github/copilot-instructions.md` | Migrations, RLS policies, naming conventions, triggers |
| **Constitution (à éditer)** | `.specify/memory/constitution.md` | Principes architecturaux universels (**contient des refs LifeFlow → à généraliser**) |
| **Guide développeur (à éditer)** | `docs/process/DEVELOPER_GUIDE.md` | Setup, build, deploy, env vars (**titre LifeFlow → à renommer**) |
| **Pipeline SpecKit** | `docs/process/SPECKIT.md` | Workflow obligatoire : specify → plan → tasks → implement |

### Ce qui n'a PAS besoin d'être touché

- `flutter/.github/instructions/` → 46 fichiers, tous génériques
- `flutter/.github/prompts/` → Tous génériques
- `flutter/.github/agents/` → Tous génériques
- `fastapi/.github/` → Tout générique
- `supabase/.github/` → Tout générique
- `.github/copilot-instructions.md` → Tout générique
- `.github/prompts/project-kickoff.prompt.md` → Prompt de démarrage pour chaque nouveau projet

### Prompt de démarrage (kickoff)

Après clonage, renommage et nettoyage, lancer dans Copilot Chat :

```
/project-kickoff
```

Ce prompt guide l'IA à :
1. Lire tous les fichiers d'architecture dans l'ordre
2. Explorer le codebase existant (modules, services, entités, migrations)
3. Comprendre le workflow SpecKit (specify → plan → tasks → implement)
4. Découvrir les 19 prompts spécialisés disponibles (create-feature, write-tests, etc.)
5. Demander la description du projet et de la première feature

> **C'est le premier prompt à lancer sur tout nouveau projet cloné depuis le template.**

---

## 2. Vue d'ensemble

```
97 éléments à nettoyer au total :

├── 5 dossiers de features Flutter       → SUPPRIMER
├── 6 entités domaine                     → SUPPRIMER
├── 7 modèles + repositories data        → SUPPRIMER  
├── 4 services métier                     → SUPPRIMER
├── 6 migrations Supabase                 → SUPPRIMER
├── 50+ fichiers business/ecosystem docs  → SUPPRIMER
├── 8 dossiers de specs                   → SUPPRIMER
├── 7 assets d'onboarding                 → SUPPRIMER
├── 12+ tests d'intégration               → SUPPRIMER
├── app.dart                              → ÉDITER (retirer routes + DI LifeFlow)
├── constitution.md                       → ÉDITER (généraliser)
├── DEVELOPER_GUIDE.md                    → ÉDITER (renommer titre)
└── quelques docs design/product          → SUPPRIMER
```

---

## 3. Étape 1 — Supprimer les dossiers entiers

```powershell
# Depuis la racine du projet cloné

# ── Dossiers documentaires LifeFlow ──
Remove-Item -Recurse -Force "apps_docs"
Remove-Item -Recurse -Force "specs"
Remove-Item -Recurse -Force ".specify/specs"

# ── Features Flutter (logique métier LifeFlow) ──
Remove-Item -Recurse -Force "flutter/lib/features/today"
Remove-Item -Recurse -Force "flutter/lib/features/habits"
Remove-Item -Recurse -Force "flutter/lib/features/domains"
Remove-Item -Recurse -Force "flutter/lib/features/counter"
Remove-Item -Recurse -Force "flutter/lib/features/bilan"

# ── Tools LifeFlow ──
Remove-Item -Recurse -Force "tools/src/lifeflow_tools" -ErrorAction SilentlyContinue
```

**Résultat** : ~60 fichiers supprimés.

---

## 4. Étape 2 — Supprimer les fichiers LifeFlow individuels

### Domain layer (entités + interfaces)

```powershell
# Entités LifeFlow
Remove-Item "flutter/lib/domain/entities/habit_entity.dart"
Remove-Item "flutter/lib/domain/entities/habit_log_entity.dart"
Remove-Item "flutter/lib/domain/entities/domain_entity.dart"
Remove-Item "flutter/lib/domain/entities/streak_info.dart"
Remove-Item "flutter/lib/domain/entities/weekly_bilan.dart"
Remove-Item "flutter/lib/domain/entities/time_counter.dart"

# Interfaces repositories LifeFlow
Remove-Item "flutter/lib/domain/repositories/i_domain_repository.dart"
Remove-Item "flutter/lib/domain/repositories/i_habit_repository.dart"

# ── GARDER ──
# flutter/lib/domain/entities/user_entity.dart         ← Core
# flutter/lib/domain/entities/notification_entity.dart  ← Core
# flutter/lib/domain/repositories/i_auth_repository.dart         ← Core
# flutter/lib/domain/repositories/i_notification_repository.dart ← Core
```

### Data layer (modèles + repositories)

```powershell
# Modèles LifeFlow
Remove-Item "flutter/lib/data/models/habit_model.dart"
Remove-Item "flutter/lib/data/models/habit_model.g.dart"
Remove-Item "flutter/lib/data/models/habit_log_model.dart"
Remove-Item "flutter/lib/data/models/habit_log_model.g.dart"
Remove-Item "flutter/lib/data/models/domain_model.dart"
Remove-Item "flutter/lib/data/models/domain_model.g.dart"

# Repositories LifeFlow
Remove-Item "flutter/lib/data/repositories/habit_repository_impl.dart"
Remove-Item "flutter/lib/data/repositories/domain_repository_impl.dart"

# ── GARDER ──
# flutter/lib/data/models/user_model.dart + .g.dart             ← Core
# flutter/lib/data/models/notification_model.dart + .g.dart     ← Core
# flutter/lib/data/repositories/auth_repository_impl.dart       ← Core
# flutter/lib/data/repositories/notification_repository_impl.dart ← Core
```

### Services LifeFlow

```powershell
Remove-Item "flutter/lib/services/habit_event_service.dart"
Remove-Item "flutter/lib/services/habit_toggle_service.dart"
Remove-Item "flutter/lib/services/time_counter_service.dart"
Remove-Item "flutter/lib/services/bilan_service.dart"

# ── GARDER ──
# Tous les dossiers de services/ (analytics, api, celebration, connectivity,
# database, dialog, haptic, local_notification, moneroo, notification_router,
# push_notification, settings, storage, supabase, sync) ← Core/générique
```

### Assets LifeFlow

```powershell
# Onboarding spécifique LifeFlow
Remove-Item "flutter/assets/images/onboarding" -Recurse -ErrorAction SilentlyContinue
Remove-Item "flutter/assets/lottie/onboarding_habits.json" -ErrorAction SilentlyContinue
Remove-Item "flutter/assets/lottie/onboarding_progress.json" -ErrorAction SilentlyContinue
Remove-Item "flutter/assets/lottie/onboarding_time.json" -ErrorAction SilentlyContinue

# Icon LifeFlow (remplacer par votre icône)
Remove-Item "flutter/assets/icon/app_icon.png"

# ── GARDER ──
# flutter/assets/icons/google.svg, github.svg, apple.svg ← Social login
```

### Documentation LifeFlow

```powershell
# Business model & product
Remove-Item "business_model_lifeflow.md"
Remove-Item "CHANGELOG.md"
Remove-Item "docs/product/business-model.md" -ErrorAction SilentlyContinue
Remove-Item "docs/product/personas.md" -ErrorAction SilentlyContinue
Remove-Item "docs/product/product-audit.md" -ErrorAction SilentlyContinue
Remove-Item "docs/product/competitive-analysis.md" -ErrorAction SilentlyContinue
Remove-Item "docs/product/feature-scoring.md" -ErrorAction SilentlyContinue

# Design spécifique
Remove-Item "docs/design/ds-config.md" -ErrorAction SilentlyContinue
Remove-Item "docs/design/voice-and-tone.md" -ErrorAction SilentlyContinue
Remove-Item "docs/design/UI_UX_AUDIT_2026.md" -ErrorAction SilentlyContinue

# Factory (spécifique LifeFlow)
Remove-Item "docs/factory/pipeline-strategy.md" -ErrorAction SilentlyContinue
Remove-Item "docs/factory/factory-pipeline.tasks.md" -ErrorAction SilentlyContinue
Remove-Item "docs/factory/certified-gate-loop.md" -ErrorAction SilentlyContinue
Remove-Item "docs/factory/certified-gate-loop-part2.md" -ErrorAction SilentlyContinue

# Screen maps
Remove-Item "scripts/mobile/screen-maps/lifeflow.json"

# Tools
Remove-Item "tools/pyproject.toml" -ErrorAction SilentlyContinue
```

### Tests d'intégration LifeFlow

```powershell
# Supprimer tous les tests de parcours LifeFlow
Remove-Item "flutter/test/integration" -Recurse -ErrorAction SilentlyContinue

# ── OU garder la structure et supprimer uniquement les parcours LifeFlow ──
# Remove-Item "flutter/test/integration/flow_*"
# Remove-Item "flutter/test/integration/parcours_*"
```

---

## 5. Étape 3 — Nettoyer app.dart

Fichier : `flutter/lib/app/app.dart`

### Imports à SUPPRIMER

```dart
// ── Supprimer ces imports ──
import 'package:<app>/services/habit_event_service.dart';
import 'package:<app>/services/habit_toggle_service.dart';
import 'package:<app>/services/bilan_service.dart';
import 'package:<app>/services/time_counter_service.dart';
import 'package:<app>/data/repositories/domain_repository_impl.dart';
import 'package:<app>/data/repositories/habit_repository_impl.dart';
import 'package:<app>/domain/repositories/i_domain_repository.dart';
import 'package:<app>/domain/repositories/i_habit_repository.dart';
import 'package:<app>/features/domains/views/domains_view.dart';
import 'package:<app>/features/habits/views/habits_view.dart';
import 'package:<app>/features/habits/views/habit_form_view.dart';
import 'package:<app>/features/counter/views/counter_view.dart';
import 'package:<app>/features/today/views/today_view.dart';
import 'package:<app>/features/bilan/views/bilan_view.dart';
```

### Routes à SUPPRIMER

```dart
// Supprimer ce bloc dans @StackedApp routes:
    // FEATURE ROUTES (Phase 1)
    MaterialRoute(page: DomainsView),
    MaterialRoute(page: HabitsView),
    MaterialRoute(page: HabitFormView),
    MaterialRoute(page: CounterView),
    MaterialRoute(page: TodayView),
    MaterialRoute(page: BilanView),
```

### Dependencies à SUPPRIMER

```dart
// Supprimer ces dépendances dans @StackedApp dependencies:
    LazySingleton(classType: DomainRepositoryImpl, asType: IDomainRepository),
    LazySingleton(classType: HabitRepositoryImpl, asType: IHabitRepository),
    LazySingleton(classType: HabitEventService),
    LazySingleton(classType: HabitToggleService),
    LazySingleton(classType: TimeCounterService),
    LazySingleton(classType: BilanService),
```

### Après nettoyage, régénérer

```powershell
cd flutter
dart run build_runner build --delete-conflicting-outputs
```

---

## 6. Étape 4 — Éditer les fichiers mixtes

### `.specify/memory/constitution.md`

```
AVANT : # LifeFlow Constitution
APRÈS : # [MonProjet] Architecture Constitution

SUPPRIMER : Sections spécifiques LifeFlow
  - Système à 7 niveaux
  - Habitudes, routines, domaines
  - IA Levels 1-2 LifeFlow
  
GARDER : Principes universels
  - Supabase-first architecture
  - Feature independence
  - Progressive disclosure
  - IA passive-informative
  - Either pattern for errors
  - Entity/Model separation
```

### `docs/process/DEVELOPER_GUIDE.md`

```
AVANT : # Guide Développeur — LifeFlow
APRÈS : # Guide Développeur — [MonProjet]

Le reste du contenu est 95% générique — juste renommer les occurrences "LifeFlow".
```

### `docs/README.md`

Supprimer les entrées des fichiers supprimés dans l'index et remplacer les mentions "LifeFlow" par le nom du projet.

### `MIGRATION_SUPABASE_CLOUD.md`

Remplacer les références `lifeflow` par le nom du projet.

### `.github/workflows/*.yml`

Chercher et remplacer `LifeFlow` dans les release notes et commentaires.

---

## 7. Étape 5 — Nettoyer les migrations Supabase

### Migrations à SUPPRIMER (LifeFlow)

```powershell
Remove-Item "supabase/migrations/20260220000001_create_domains.sql"
Remove-Item "supabase/migrations/20260220000002_create_habits.sql"
Remove-Item "supabase/migrations/20260220000003_create_routines.sql"
Remove-Item "supabase/migrations/20260220000004_create_tasks.sql"
Remove-Item "supabase/migrations/20260220000005_create_inbox_items.sql"
Remove-Item "supabase/migrations/20260305000001_enhance_habits_and_logs.sql"
```

### Migrations à GARDER (Core)

| Fichier | Description |
|---------|-------------|
| `20260122000000_create_profiles.sql` | Table profils utilisateurs |
| `20260123000005_create_payments.sql` | Table paiements (module optionnel) |
| `20260220000006_create_notifications.sql` | Table notifications |
| `20260220000007_create_device_tokens.sql` | Tokens push notifications |

---

## 8. Étape 6 — Vérification finale

```powershell
# 1. Chercher les résidus "lifeflow" (hors .git)
cd <racine-projet>
Get-ChildItem -Recurse -File -Exclude ".git" |
  Select-String -Pattern "lifeflow|LifeFlow|life_flow" |
  Where-Object { $_.Path -notlike "*\.git\*" } |
  Select-Object Path, LineNumber, Line |
  Format-Table -AutoSize

# 2. Vérifier que Flutter compile
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze --no-fatal-warnings

# 3. Vérifier que Supabase démarre
cd ../supabase
supabase db reset

# 4. Vérifier que FastAPI démarre
cd ../fastapi
uv sync
uv run python -c "from app.main import create_app; print('OK')"

# 5. Lancer les gates
cd ..
.\scripts\gates\verify-gates.ps1
```

---

## 9. Récapitulatif — Ce qui RESTE dans le template

### Flutter — Structure conservée

```
flutter/lib/
├── app/
│   ├── app.dart                    ← Nettoyé (routes + DI core only)
│   ├── app.router.dart             ← Régénéré
│   └── app.locator.dart            ← Régénéré
├── data/
│   ├── models/
│   │   ├── user_model.dart         ← Core
│   │   └── notification_model.dart ← Core
│   └── repositories/
│       ├── auth_repository_impl.dart       ← Core
│       └── notification_repository_impl.dart ← Core
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart        ← Core
│   │   └── notification_entity.dart ← Core
│   └── repositories/
│       ├── i_auth_repository.dart   ← Core
│       └── i_notification_repository.dart ← Core
├── features/                       ← VIDE (prêt pour vos features)
├── modules/
│   ├── auth/                       ← Login, Register, Forgot Password
│   ├── onboarding/                 ← Onboarding flow
│   ├── profile/                    ← Profile, Edit Profile
│   ├── settings/                   ← Settings
│   ├── notifications/              ← Notifications
│   ├── splash/                     ← Splash screen
│   └── optional/                   ← Payments, etc.
├── services/                       ← Tous conservés (analytics, api, auth, storage, sync...)
├── ui/
│   ├── bottom_sheets/              ← NoticeSheet
│   ├── dialogs/                    ← InfoAlertDialog
│   ├── views/
│   │   ├── home/                   ← HomeView (à adapter)
│   │   ├── startup/                ← StartupView
│   │   └── design_showcase/        ← Design system showcase
│   └── widgets/                    ← Design system complet
└── core/                           ← Extensions, constants, theme, l10n
```

### Supabase — Migrations conservées

```
supabase/migrations/
├── 20260122000000_create_profiles.sql      ← Core
├── 20260123000005_create_payments.sql      ← Core (optional)
├── 20260220000006_create_notifications.sql ← Core
└── 20260220000007_create_device_tokens.sql ← Core
```

### Documentation conservée

```
.github/copilot-instructions.md         ← Monorepo architecture
flutter/.github/                        ← 46 instructions + prompts + agents
fastapi/.github/                        ← FastAPI patterns
supabase/.github/                       ← Supabase conventions
docs/process/DEVELOPER_GUIDE.md         ← Guide dev (titre à renommer)
docs/process/SPECKIT.md                 ← Workflow SpecKit
docs/factory/clone-and-setup-guide.md   ← Ce guide de clonage
docs/architecture/                      ← Architecture docs
```

---

## 10. Script de nettoyage automatisé

Pour automatiser le nettoyage, exécuter depuis la **racine du projet cloné** :

```powershell
# ══════════════════════════════════════════════════════════════
# cleanup-lifeflow.ps1 — Supprime tous les éléments LifeFlow
# Exécuter APRÈS le renommage du projet (rename_project.ps1)
# ══════════════════════════════════════════════════════════════

param(
    [switch]$DryRun  # Affiche ce qui serait supprimé sans supprimer
)

$ErrorActionPreference = "Stop"

$foldersToDelete = @(
    "apps_docs",
    "specs",
    ".specify/specs",
    "flutter/lib/features/today",
    "flutter/lib/features/habits",
    "flutter/lib/features/domains",
    "flutter/lib/features/counter",
    "flutter/lib/features/bilan",
    "flutter/test/integration",
    "flutter/assets/images/onboarding",
    "tools/src/lifeflow_tools"
)

$filesToDelete = @(
    # Domain entities
    "flutter/lib/domain/entities/habit_entity.dart",
    "flutter/lib/domain/entities/habit_log_entity.dart",
    "flutter/lib/domain/entities/domain_entity.dart",
    "flutter/lib/domain/entities/streak_info.dart",
    "flutter/lib/domain/entities/weekly_bilan.dart",
    "flutter/lib/domain/entities/time_counter.dart",
    # Domain repositories
    "flutter/lib/domain/repositories/i_domain_repository.dart",
    "flutter/lib/domain/repositories/i_habit_repository.dart",
    # Data models
    "flutter/lib/data/models/habit_model.dart",
    "flutter/lib/data/models/habit_model.g.dart",
    "flutter/lib/data/models/habit_log_model.dart",
    "flutter/lib/data/models/habit_log_model.g.dart",
    "flutter/lib/data/models/domain_model.dart",
    "flutter/lib/data/models/domain_model.g.dart",
    # Data repositories
    "flutter/lib/data/repositories/habit_repository_impl.dart",
    "flutter/lib/data/repositories/domain_repository_impl.dart",
    # Services
    "flutter/lib/services/habit_event_service.dart",
    "flutter/lib/services/habit_toggle_service.dart",
    "flutter/lib/services/time_counter_service.dart",
    "flutter/lib/services/bilan_service.dart",
    # Assets
    "flutter/assets/icon/app_icon.png",
    "flutter/assets/lottie/onboarding_habits.json",
    "flutter/assets/lottie/onboarding_progress.json",
    "flutter/assets/lottie/onboarding_time.json",
    # Supabase migrations
    "supabase/migrations/20260220000001_create_domains.sql",
    "supabase/migrations/20260220000002_create_habits.sql",
    "supabase/migrations/20260220000003_create_routines.sql",
    "supabase/migrations/20260220000004_create_tasks.sql",
    "supabase/migrations/20260220000005_create_inbox_items.sql",
    "supabase/migrations/20260305000001_enhance_habits_and_logs.sql",
    # Docs
    "business_model_lifeflow.md",
    "CHANGELOG.md",
    "scripts/mobile/screen-maps/lifeflow.json",
    "tools/pyproject.toml",
    # Product docs
    "docs/product/business-model.md",
    "docs/product/personas.md",
    "docs/product/product-audit.md",
    "docs/product/competitive-analysis.md",
    "docs/product/feature-scoring.md",
    # Design docs
    "docs/design/ds-config.md",
    "docs/design/voice-and-tone.md",
    "docs/design/UI_UX_AUDIT_2026.md",
    # Factory docs
    "docs/factory/pipeline-strategy.md",
    "docs/factory/factory-pipeline.tasks.md",
    "docs/factory/certified-gate-loop.md",
    "docs/factory/certified-gate-loop-part2.md"
)

Write-Host "`n🧹 Nettoyage du template — suppression des éléments LifeFlow`n" -ForegroundColor Cyan

# Supprimer les dossiers
foreach ($folder in $foldersToDelete) {
    if (Test-Path $folder) {
        if ($DryRun) {
            Write-Host "[DRY-RUN] Supprimerait : $folder/" -ForegroundColor Yellow
        } else {
            Remove-Item -Recurse -Force $folder
            Write-Host "  Supprimé : $folder/" -ForegroundColor Green
        }
    }
}

# Supprimer les fichiers
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        if ($DryRun) {
            Write-Host "[DRY-RUN] Supprimerait : $file" -ForegroundColor Yellow
        } else {
            Remove-Item -Force $file
            Write-Host "  Supprimé : $file" -ForegroundColor Green
        }
    }
}

Write-Host "`n✅ Nettoyage terminé." -ForegroundColor Cyan
Write-Host @"

⚠️  Actions manuelles restantes :
  1. Éditer flutter/lib/app/app.dart — retirer imports, routes et DI LifeFlow
  2. Éditer .specify/memory/constitution.md — généraliser le titre et contenu
  3. Éditer docs/process/DEVELOPER_GUIDE.md — renommer le titre
  4. Éditer docs/README.md — retirer les entrées supprimées
  5. Lancer : cd flutter && dart run build_runner build --delete-conflicting-outputs
  6. Vérifier : flutter pub get && dart analyze --no-fatal-warnings
  7. Vérifier : supabase db reset
"@
```

**Usage** :

```powershell
# Prévisualiser ce qui sera supprimé
.\cleanup-lifeflow.ps1 -DryRun

# Exécuter le nettoyage
.\cleanup-lifeflow.ps1
```

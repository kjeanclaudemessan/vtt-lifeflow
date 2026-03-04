# Guide Développeur — LifeFlow

> Référence rapide de toutes les commandes et scripts pour aller vite.

---

## Table des matières

1. [Prérequis](#prérequis)
2. [Setup initial](#setup-initial)
3. [Développement quotidien](#développement-quotidien)
4. [Commandes Flutter](#commandes-flutter)
5. [Commandes Supabase](#commandes-supabase)
6. [Commandes FastAPI](#commandes-fastapi)
7. [Tests](#tests)
8. [Build & Deploy](#build--deploy)
9. [Base de données](#base-de-données)
10. [Template (clone & rename)](#template-clone--rename)
11. [Variables d'environnement](#variables-denvironnement)
12. [Analytics (PostHog)](#analytics-posthog)
13. [Git Hooks](#git-hooks)
14. [Troubleshooting](#troubleshooting)

---

## Prérequis

| Outil | Version min. | Installation |
|-------|-------------|--------------|
| Flutter | 3.38+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart | 3.6+ | Inclus avec Flutter |
| Supabase CLI | 1.x | `npm install -g supabase` ou `scoop install supabase` |
| uv (Python) | 0.x | `pip install uv` |
| Docker | — | Pour Supabase local et FastAPI |
| Git | 2.x | — |
| PowerShell | 7+ | Recommandé pour les scripts `.ps1` |

---

## Setup initial

### Tout d'un coup (recommandé)

```powershell
.\scripts\setup.ps1
```

Ce script fait tout :
- Démarre Supabase local (`supabase start` + `db reset`)
- Installe les deps Flutter (`flutter pub get` + `build_runner`)
- Installe les deps FastAPI (`uv sync`)
- Copie `.env.example` → `.env` si manquant

**Flags optionnels :**

```powershell
.\scripts\setup.ps1 -SkipFlutter      # Skip la partie Flutter
.\scripts\setup.ps1 -SkipFastApi       # Skip FastAPI
.\scripts\setup.ps1 -SkipSupabase      # Skip Supabase
```

### Setup manuel (par couche)

```powershell
# 1. Supabase
cd supabase
supabase start
supabase db reset

# 2. Flutter
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 3. FastAPI
cd fastapi
uv sync
```

### Git hooks

```powershell
.\scripts\install-hooks.ps1
```

Installe un hook `pre-commit` qui lance `dart format` + `dart analyze` sur le code Flutter modifié et `ruff check` sur le code FastAPI.

---

## Développement quotidien

### Workflow type

```powershell
# 1. Démarrer Supabase local (si pas déjà lancé)
supabase start

# 2. Lancer l'app Flutter
cd flutter
flutter run -d chrome --web-port=3000          # Web
flutter run -d <device_id>                      # Mobile

# 3. Lancer FastAPI (optionnel, si features backend)
cd fastapi
docker compose up                               # Via Docker
# ou
uv run uvicorn app.main:app --reload --port 8000  # Direct
```

### Après modification de code généré

```powershell
# Après modif de : app.dart (routes/DI), models @JsonSerializable, etc.
cd flutter
dart run build_runner build --delete-conflicting-outputs

# Si ça bloque :
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Après modification de fichiers l10n (.arb)

```powershell
cd flutter
flutter gen-l10n
```

### Après modification de pubspec.yaml

```powershell
cd flutter
flutter pub get
```

---

## Commandes Flutter

| Commande | Usage |
|----------|-------|
| `flutter run -d chrome --web-port=3000` | Lancer en web (port fixe pour OAuth) |
| `flutter run -d <device>` | Lancer sur appareil mobile |
| `flutter pub get` | Installer les dépendances |
| `dart run build_runner build --delete-conflicting-outputs` | Générer le code (routes, locator, JSON) |
| `flutter gen-l10n` | Regénérer les fichiers de traduction |
| `flutter analyze` | Analyse statique du code |
| `dart format lib/ test/` | Formater le code |
| `flutter clean` | Nettoyer le build cache |

### Fichiers générés importants

| Fichier | Généré par | Quand regénérer |
|---------|-----------|-----------------|
| `lib/app/app.locator.dart` | build_runner | Après modif de `app.dart` (DI) |
| `lib/app/app.router.dart` | build_runner | Après modif de `app.dart` (routes) |
| `lib/l10n/generated/` | gen-l10n | Après modif de `lib/l10n/arb/*.arb` |
| `**/*.g.dart` | build_runner | Après modif de models `@JsonSerializable` |

---

## Commandes Supabase

| Commande | Usage |
|----------|-------|
| `supabase start` | Démarrer l'instance locale |
| `supabase stop` | Arrêter l'instance locale |
| `supabase status` | Voir les URLs et clés locales |
| `supabase db reset` | Reset DB + appliquer toutes les migrations + seeds |
| `supabase db diff --local` | Générer une migration depuis les changements locaux |
| `supabase migration new <name>` | Créer un fichier migration vide |
| `supabase db push --db-url <url>` | Pousser les migrations vers un serveur distant |

### URLs locales par défaut

| Service | URL |
|---------|-----|
| API | `http://localhost:54421` |
| Studio (admin) | `http://localhost:54423` |
| Auth | `http://localhost:54421/auth/v1` |
| DB | `postgresql://postgres:postgres@localhost:54322/postgres` |

### Reset de la DB locale

```powershell
# Reset simple (migrations + seeds)
.\scripts\reset_db.ps1

# Reset dur (stop → start → reset)
.\scripts\reset_db.ps1 -Hard
```

### Pousser les migrations en staging/production

```powershell
# Staging
.\scripts\push-migrations.ps1

# Production (demande confirmation)
.\scripts\push-migrations.ps1 -Environment production

# Dry run (preview sans appliquer)
.\scripts\push-migrations.ps1 -DryRun
```

> **Cible :** VPS Coolify (`144.91.67.237`), staging port `5433`, production port `5434`.

---

## Commandes FastAPI

| Commande | Usage |
|----------|-------|
| `docker compose up` | Lancer avec Docker (port 8000, hot reload) |
| `docker compose down` | Arrêter les conteneurs |
| `uv sync` | Installer les dépendances Python |
| `uv run uvicorn app.main:app --reload` | Lancer sans Docker |
| `uv run pytest` | Lancer les tests |
| `uv run ruff check app/` | Lint Python |

### Documentation API

Quand le serveur tourne : `http://localhost:8000/docs` (Swagger UI)

---

## Tests

### Tout tester d'un coup

```powershell
.\scripts\test.ps1
# ou explicitement
.\scripts\test.ps1 -All
```

### Par couche

```powershell
.\scripts\test.ps1 -Flutter         # Tests unitaires Flutter
.\scripts\test.ps1 -FastApi          # Tests pytest FastAPI
.\scripts\test.ps1 -Supabase        # Valide les migrations (db reset)
.\scripts\test.ps1 -Integration      # Tests d'intégration Flutter
.\scripts\test.ps1 -Coverage         # Avec rapport de couverture
```

### Commandes directes

```powershell
# Flutter unit tests
cd flutter
flutter test

# Flutter test spécifique
flutter test test/viewmodels/settings_viewmodel_test.dart

# FastAPI tests
cd fastapi
uv run pytest
uv run pytest --cov=app --cov-report=html  # Avec couverture

# Supabase (valide que toutes les migrations s'appliquent)
supabase db reset
```

---

## Build & Deploy

### Build Flutter

```powershell
# Via le script (recommandé)
.\scripts\build.ps1 -Platform android -Env staging
.\scripts\build.ps1 -Platform ios -Env production -Release
.\scripts\build.ps1 -Platform web -Env staging

# Commandes directes
cd flutter
flutter build apk --dart-define=ENV=staging
flutter build appbundle --dart-define=ENV=production
flutter build web --dart-define=ENV=staging
flutter build ipa --dart-define=ENV=production
```

### Environnements de build

| Env | Utilisation |
|-----|-------------|
| `development` | Local, Supabase local (`localhost:54421`) |
| `staging` | Test serveur, Supabase Cloud staging |
| `production` | Publication store |

### Variables d'env Flutter (--dart-define-from-file)

```powershell
# Si tu utilises un fichier .env pour le build
flutter run --dart-define-from-file=.env.staging
flutter build apk --dart-define-from-file=.env.production
```

---

## Base de données

### Workflow pour les nouvelles migrations

```powershell
# 1. Créer la migration
supabase migration new create_<table_name>

# 2. Éditer le fichier SQL dans supabase/migrations/
# 3. Appliquer localement
supabase db reset

# 4. Tester
.\scripts\test.ps1 -Supabase

# 5. Pousser en staging
.\scripts\push-migrations.ps1 -Environment staging

# 6. Pousser en production
.\scripts\push-migrations.ps1 -Environment production
```

### Convention de nommage

```
supabase/migrations/YYYYMMDDHHMMSS_description.sql
```

Les timestamps doivent être **ordonnés chronologiquement**.

---

## Template (clone & rename)

### Cloner le template

```powershell
.\clone_template.ps1 -Destination "C:\Projects\mon_nouveau_projet"
```

Ce script copie uniquement les fichiers trackés par git (respect `.gitignore`).

**Flags :**
- `-IncludeUntracked` : inclure aussi les fichiers non-trackés non-ignorés
- `-DryRun` : preview sans copier

### Renommer le projet Flutter

```powershell
cd flutter
.\scripts\rename_project.ps1 `
  -Name "mon_app" `
  -BundleId "com.monentreprise.monapp" `
  -DisplayName "Mon App" `
  -OrgName "Mon Entreprise"
```

Ce script met à jour **16 fichiers** automatiquement :
- `pubspec.yaml` (name)
- Android : `build.gradle.kts`, répertoires Kotlin, Fastlane
- iOS : `pbxproj`, `Info.plist`, Fastlane
- Web, Linux, Windows, macOS
- Tous les imports Dart (`package:old/` → `package:new/`)
- Configs env, stacked.json, OAuth redirect URLs, deep links

**Flags :** `-DryRun` (preview), `-Force` (pas de confirmation)

### Workflow complet pour un nouveau projet

```powershell
# 1. Cloner
.\clone_template.ps1 -Destination "C:\Projects\mon_app"

# 2. Aller dans le nouveau projet
cd C:\Projects\mon_app

# 3. Renommer
cd flutter
.\scripts\rename_project.ps1 -Name "mon_app" -BundleId "com.monentreprise.monapp"
cd ..

# 4. Setup
.\scripts\setup.ps1

# 5. Configurer les variables d'env
# Éditer flutter/.env.staging, fastapi/.env, etc.

# 6. Git init
git init
git add .
git commit -m "Initial commit from VTT template"
```

---

## Variables d'environnement

### Fichiers de référence

| Fichier | Couche | Contenu |
|---------|--------|---------|
| `.env.template` | Racine | **Master template** — toutes les vars pour tous les envs |
| `flutter/.env.example` | Flutter | `API_BASE_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY` |
| `fastapi/.env.example` | FastAPI | DB, JWT, Redis, Email, Payments, AI, etc. |
| `fastapi/.env.test` | FastAPI | Valeurs de test pour pytest |

### Variables critiques Flutter

```env
# Supabase
SUPABASE_URL=https://oqziaaabsvnmwxsorcea.supabase.co
SUPABASE_ANON_KEY=sb_publishable_...

# PostHog
POSTHOG_API_KEY=phc_fsT0dUEqJuzDX28AfyvclkiWUmyUcfsNdyS39DYkp6q
POSTHOG_HOST=https://us.i.posthog.com

# Google OAuth (Android)
GOOGLE_CLIENT_ID=16508544154-...apps.googleusercontent.com
```

### Variables critiques FastAPI

```env
SUPABASE_URL=https://oqziaaabsvnmwxsorcea.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...
JWT_SECRET=vAYu46WU2okDThRL/k/OL/...
```

---

## Analytics (PostHog)

### Architecture

```
PostHogWidget (main.dart)
  └─ MaterialApp
      └─ PosthogObserver (navigatorObservers) → screen tracking auto
      
AnalyticsService (bootstrap.dart)
  ├── init() → Posthog().setup()
  ├── identify() ← appelé automatiquement au login (SupabaseAuthService)
  ├── reset() ← appelé automatiquement au logout
  ├── capture() ← events métier (habit_created, habit_completed, etc.)
  └── captureError() ← crash reporting (mobile only)
```

### Events trackés

| Event | Déclenché par | Propriétés |
|-------|---------------|------------|
| `$screen` | Auto (PosthogObserver) | route name |
| `habit_created` | HabitFormViewModel.save() | domain, type, frequency |
| `habit_updated` | HabitFormViewModel.save() | domain, type, frequency |
| `habit_completed` | TodayViewModel.toggleHabit() | habit_id, completion_rate |
| `habit_uncompleted` | TodayViewModel.toggleHabit() | habit_id |
| Lifecycle events | Auto (PostHog SDK) | — |

### Vérifier que ça marche

1. Lancer l'app avec la clé PostHog configurée
2. Naviguer dans l'app (crée des `$screen` events)
3. Créer/compléter une habitude
4. Aller sur [PostHog Dashboard](https://us.posthog.com) → **Activity** → **Live Events**
5. Les events doivent apparaître en quelques secondes

---

## Git Hooks

### Installation

```powershell
.\scripts\install-hooks.ps1
```

### Hook pre-commit

Vérifie automatiquement avant chaque commit :

| Couche | Vérification |
|--------|-------------|
| Flutter (`lib/`, `test/`) | `dart format --set-exit-if-changed` + `dart analyze` |
| FastAPI (`app/`, `tests/`) | `ruff check` |

Si un check échoue, le commit est bloqué.

---

## Troubleshooting

### `build_runner` bloqué ou erreurs de cache

```powershell
cd flutter
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### `flutter gen-l10n` ne produit rien

Vérifier que `l10n.yaml` existe à la racine de `flutter/` et que les fichiers `.arb` sont dans `lib/l10n/arb/`.

### Supabase ne démarre pas

```powershell
supabase stop --no-backup
supabase start
```

Ou vérifier que Docker est lancé.

### OAuth Google ne redirige pas

Vérifier que `http://localhost:3000` est dans les **Redirect URLs** de Supabase Authentication → URL Configuration.

Lancer avec le bon port :
```powershell
flutter run -d chrome --web-port=3000
```

### Erreurs d'import après rename

```powershell
cd flutter
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### PostHog n'envoie pas de données

1. Vérifier que `POSTHOG_API_KEY` n'est pas vide dans l'env
2. En debug, chercher `[PostHog] Initialized` dans la console
3. Si absent : `[PostHog] No API key — analytics disabled`
4. Sur web : PostHog ne capture pas les crash errors (mobile only)

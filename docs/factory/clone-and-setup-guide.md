# Clone & Setup Guide — VTT Template

> Guide complet pour cloner le template VTT et lancer un nouveau projet en quelques minutes.
> Couvre : clonage, renommage, configuration, scripts, et workflow quotidien.

---

## Table des matières

1. [Cloner le template](#1--cloner-le-template)
2. [Renommer le projet](#2--renommer-le-projet)
3. [Configurer les environnements](#3--configurer-les-environnements)
4. [Setup automatisé](#4--setup-automatisé)
5. [Lancer le projet](#5--lancer-le-projet)
6. [Scripts disponibles](#6--scripts-disponibles)
7. [GitHub Actions — Secrets & Variables](#7--github-actions--secrets--variables)
8. [Ce que tu récupères gratuitement](#8--ce-que-tu-récupères-gratuitement)
9. [Checklist rapide](#9--checklist-rapide)

---

## 1 — Cloner le template

```powershell
# Depuis le repo template (ex: lifeflow)
cd F:\programmation\vtt\lifeflow

# Exporter sans historique git
git archive HEAD | tar -x -C "F:\programmation\vtt\monapp"

# Initialiser un nouveau repo
cd F:\programmation\vtt\monapp
git init
git add -A
git commit -m "init: clone from VTT template"
```

> `git archive` exporte uniquement les fichiers trackés, sans `.git/`, sans historique.

---

## 2 — Renommer le projet

### 2.1 — Flutter (AUTOMATISÉ)

```powershell
cd flutter
.\scripts\rename_project.ps1 `
  -Name "monapp" `
  -DisplayName "MonApp" `
  -BundleId "com.monorg.monapp" `
  -OrgName "MonOrg"
```

Ce script met à jour automatiquement **~16 fichiers** :

| Fichier | Ce qui change |
|---------|---------------|
| `pubspec.yaml` | `name`, `description` |
| `android/app/build.gradle.kts` | `namespace`, `applicationId` |
| `android/app/src/main/AndroidManifest.xml` | `android:label`, deep link scheme |
| `android/app/src/debug/AndroidManifest.xml` | Deep link scheme |
| `android/app/src/profile/AndroidManifest.xml` | Deep link scheme |
| `ios/Runner/Info.plist` | `CFBundleDisplayName`, `CFBundleName`, `CFBundleURLSchemes` |
| `ios/Runner.xcodeproj/project.pbxproj` | Bundle ID |
| `linux/CMakeLists.txt` | `APPLICATION_ID` |
| `web/index.html`, `web/manifest.json` | App name |
| `windows/`, `macos/` configs | App name |
| `android/fastlane/Appfile` | `package_name` |
| `ios/fastlane/Appfile` | `app_identifier` |
| `ios/fastlane/Matchfile` | `app_identifier` |

> Tip : ajouter `-DryRun` pour prévisualiser sans modifier.

### 2.2 — Hors Flutter (MANUEL — 6 fichiers)

Ces fichiers ne sont **pas couverts** par `rename_project.ps1`. Modifier à la main ou via Find & Replace global (`Ctrl+Shift+H` dans VS Code) :

| Fichier | Valeur à changer |
|---------|-----------------|
| `fastapi/pyproject.toml` | `name = "monapp"` |
| `fastapi/fly.toml` | `app = "monapp-api"` |
| `fastapi/fly.staging.toml` | `app = "monapp-api-staging"` |
| `fastapi/.env.staging` | `APP_NAME="MonApp API"` |
| `supabase/config.toml` | `project_id = "monapp"` |
| `scripts/mobile/screen-maps/lifeflow.json` | Renommer le fichier → `monapp.json` + changer `"package"` |
| `flutter/lib/services/supabase/supabase_auth_service.dart` | Callback URL : `com.monorg.monapp://login-callback/` |

---

## 3 — Configurer les environnements

### 3.1 — Créer un projet Supabase

1. Aller sur [app.supabase.com](https://app.supabase.com)
2. Créer un nouveau projet
3. Récupérer : **URL**, **anon key**, **service role key**, **JWT secret**

### 3.2 — Fichiers .env

```powershell
# Flutter
cp flutter/.env.example flutter/.env.staging
# → Éditer : SUPABASE_URL, SUPABASE_ANON_KEY, POSTHOG_API_KEY, GOOGLE_WEB_CLIENT_ID

# FastAPI
cp fastapi/.env.example fastapi/.env.staging
# → Éditer : SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY, SUPABASE_JWT_SECRET, FIREBASE_PROJECT_ID
```

### 3.3 — Firebase (si push notifications / analytics)

1. Créer un projet sur [console.firebase.google.com](https://console.firebase.google.com)
2. Télécharger `google-services.json` → `flutter/android/app/`
3. Télécharger `GoogleService-Info.plist` → `flutter/ios/Runner/`

### 3.4 — OAuth Google (si Google Sign-In)

1. Créer un OAuth Client ID dans Google Cloud Console
2. Mettre le Client ID dans `flutter/.env.staging` → `GOOGLE_WEB_CLIENT_ID`
3. Configurer la redirect URL dans Supabase : Dashboard → Authentication → Providers → Google

---

## 4 — Setup automatisé

```powershell
cd F:\programmation\vtt\monapp

# Installe TOUT d'un coup
.\scripts\setup.ps1
```

Ce script fait :
- `supabase start` — lance les conteneurs Docker locaux
- `supabase db reset` — applique migrations + seeds
- `flutter pub get` — installe les dépendances Dart
- `dart run build_runner build` — code generation
- `uv sync` — installe les dépendances Python (FastAPI)
- Crée `.env` depuis `.env.example` si manquant

Options :
```powershell
.\scripts\setup.ps1 -SkipFlutter    # Skip Flutter
.\scripts\setup.ps1 -SkipFastApi    # Skip FastAPI
.\scripts\setup.ps1 -SkipSupabase   # Skip Supabase
```

### Installer les hooks git

```powershell
.\scripts\install-hooks.ps1
```

### Générer les icônes

```powershell
# 1. Placer ton icône 1024x1024 dans flutter/assets/icon/app_icon.png
# 2. Générer
cd flutter
dart run flutter_launcher_icons
```

---

## 5 — Lancer le projet

```powershell
# Web (dev rapide)
cd flutter
flutter run -d chrome --dart-define-from-file=.env.staging

# Android (émulateur)
flutter run -d emulator-5554 --dart-define-from-file=.env.staging

# iOS (simulateur)
flutter run -d iPhone --dart-define-from-file=.env.staging
```

---

## 6 — Scripts disponibles

### Initialisation

| Script | Commande | Description |
|--------|----------|-------------|
| Clone | `.\clone_template.ps1 -Destination "path"` | Cloner le template (respecte `.gitignore`) |
| Rename | `cd flutter; .\scripts\rename_project.ps1 -Name x -BundleId y` | Renommer le projet Flutter |
| Setup | `.\scripts\setup.ps1` | Installer toutes les dépendances |
| Hooks | `.\scripts\install-hooks.ps1` | Installer les hooks git |
| Icônes | `cd flutter; dart run flutter_launcher_icons` | Générer les icônes multi-plateforme |

### Base de données

| Script | Commande | Description |
|--------|----------|-------------|
| Reset DB | `.\scripts\reset_db.ps1` | Reset DB locale (migrations + seeds) |
| Reset Hard | `.\scripts\reset_db.ps1 -Hard` | Stop/restart Supabase + reset complet |
| Seed only | `.\scripts\reset_db.ps1 -SeedOnly` | Rejouer les seeds sans remigrer |
| Push migrations | `.\scripts\push-migrations.ps1 -Environment staging` | Pusher les migrations vers le VPS |

### Build

| Script | Commande | Description |
|--------|----------|-------------|
| APK debug | `.\scripts\build.ps1 -Platform apk -Env staging` | Build APK debug |
| AAB release | `.\scripts\build.ps1 -Platform aab -Env production -Release` | Build Play Store |
| iOS | `.\scripts\build.ps1 -Platform ipa -Env production -Release` | Build App Store |
| Web | `.\scripts\build.ps1 -Platform web -Env staging` | Build web |

### Tests & Qualité

| Script | Commande | Description |
|--------|----------|-------------|
| Tests Flutter | `.\scripts\test.ps1 -Flutter` | Unit tests Flutter |
| Tests FastAPI | `.\scripts\test.ps1 -FastApi` | Tests Python |
| Tests intégration | `.\scripts\test.ps1 -Integration` | Tests E2E (Supabase local requis) |
| Tous les tests | `.\scripts\test.ps1 -All -Coverage` | Tout + couverture |
| Gates (toutes) | `.\scripts\gates\verify-gates.ps1` | 8 gates de qualité |
| Gate spécifique | `.\scripts\gates\verify-gates.ps1 -Gate 1` | Gate 1 uniquement |
| Auto-fix | `.\scripts\gates\verify-gates.ps1 -Fix` | Fix automatique (dart format, etc.) |
| Post-tâche | `.\scripts\gates\run-post-task.ps1 -TaskId T001` | Gates + boucle correction AI |

### Visual Testing

| Script | Commande | Description |
|--------|----------|-------------|
| Mobile loop | `.\scripts\mobile\mobile-loop.ps1` | Build → install → émulateur → MCP |
| Skip build | `.\scripts\mobile\mobile-loop.ps1 -SkipBuild` | Réutiliser l'APK existant |
| Env custom | `.\scripts\mobile\mobile-loop.ps1 -EnvFile .env.staging` | Env spécifique |

### Détail des 8 Gates de qualité

| Gate | Vérifie | Auto-fix |
|------|---------|----------|
| 1 — Compilation | `dart analyze`, `dart format`, DB reset | Oui (format) |
| 2 — Patterns | Entity/Model/Repo/View/ViewModel conventions | Non |
| 3 — Architecture | Isolation des couches, imports cross-feature | Non |
| 4 — Expérience | Design tokens, i18n, UX writing | Non |
| 5 — Réactivité | ReactiveServiceMixin, dispose, refresh | Non |
| 6 — RLS | Policies Supabase sur chaque table | Non |
| 7 — Tests | Couverture, nommage, assertions | Non |
| 8 — Visuel | Screenshots, a11y labels, touch targets | Non |

---

## 7 — GitHub Actions — Secrets & Variables

### Secrets (GitHub → Settings → Secrets and variables → Actions)

```
# Supabase
SUPABASE_ACCESS_TOKEN
STAGING_SUPABASE_URL
STAGING_SUPABASE_ANON_KEY
PROD_SUPABASE_URL
PROD_SUPABASE_ANON_KEY

# Firebase
GOOGLE_SERVICES_JSON_BASE64          # base64 de google-services.json
GOOGLE_SERVICE_INFO_PLIST_BASE64     # base64 de GoogleService-Info.plist

# Android Signing
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_PASSWORD
ANDROID_KEY_ALIAS

# Play Store
ANDROID_GOOGLE_PLAY_SA_JSON          # Service Account JSON

# Apple (si iOS)
APPLE_MATCH_GIT_URL
APPLE_MATCH_PASSWORD
APPLE_APPSTORE_KEY_ID
APPLE_APPSTORE_ISSUER_ID
APPLE_APPSTORE_API_KEY

# Analytics
POSTHOG_API_KEY

# OTA (optionnel)
SHOREBIRD_TOKEN
```

### Variables

```
STAGING_SUPABASE_PROJECT_REF         # Ref du projet Supabase staging
PROD_SUPABASE_PROJECT_REF            # Ref du projet Supabase production
ENABLE_PLAYSTORE_STAGING=true        # Activer upload Play Store staging
ENABLE_IOS_BUILD=false               # Activer build iOS
ENABLE_SHOREBIRD=false               # Activer OTA Shorebird
```

---

## 8 — Ce que tu récupères gratuitement

### Features fonctionnelles
- Auth complète (email, Google, Apple, forgot password, register)
- Profil utilisateur (édition, avatar)
- Système d'habitudes
- Compteurs de temps
- Notifications (préférences + push)
- Settings (thème, langue, CGU, déconnexion, suppression compte)

### Infrastructure technique
- Design system complet (tokens, composants, dark mode, 27 instructions)
- CI/CD staging + production (GitHub Actions + Fastlane)
- 8 gates de qualité automatisées
- Git hooks pre-commit
- Docker (FastAPI) + Fly.io config

### IA & Automatisation
- SpecKit pipeline (specify → plan → tasks → implement)
- 9 agents SpecKit + 10 agents Flutter
- 19 prompts Flutter + 2 prompts cross-stack
- 40 fichiers d'instructions Flutter
- Mobile MCP loop pour tests visuels
- Boucle de correction automatique post-tâche

---

## 9 — Checklist rapide

```
□ git archive HEAD | tar -x -C "path/monapp"
□ cd monapp && git init
□ cd flutter && .\scripts\rename_project.ps1 -Name x -DisplayName "X" -BundleId com.org.x
□ Renommer manuellement : fastapi/pyproject.toml, fly.toml, fly.staging.toml, supabase/config.toml
□ Créer projet Supabase → récupérer URL + keys
□ Copier et éditer flutter/.env.staging
□ Copier et éditer fastapi/.env.staging
□ (Optionnel) Firebase : déposer google-services.json + GoogleService-Info.plist
□ (Optionnel) OAuth Google : créer Client ID + configurer Supabase
□ cd .. && .\scripts\setup.ps1
□ .\scripts\install-hooks.ps1
□ Placer icône 1024x1024 → cd flutter && dart run flutter_launcher_icons
□ flutter run -d chrome --dart-define-from-file=.env.staging
□ git add -A && git commit -m "init: monapp from VTT template"
□ git remote add origin https://github.com/org/monapp.git && git push -u origin main
□ (Si CI/CD) Configurer GitHub Secrets & Variables (voir section 7)
```

---

*Dernière mise à jour : 18 Mars 2026*

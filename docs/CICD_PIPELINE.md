# LifeFlow — CI/CD Pipeline & Automation

> **Pipeline automatisé complet** : du commit au Store, en passant par les tests, builds, screenshots et monitoring.

---

## Architecture du Pipeline

```
Code → Lint/Analyze → Test → Build → Screenshots → Sign → Distribute → Store → Monitor
```

```
┌──────────────────────────────────────────────────────────────────────────┐
│                           DEVELOPER PUSH                                 │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ① GitHub Actions CI (automatique sur chaque PR)                         │
│     ├─ Flutter: dart analyze + flutter test                              │
│     ├─ FastAPI: pytest + ruff                                            │
│     ├─ Supabase: supabase db start + db reset + gen types                │
│     └─ Golden tests (screenshots de régression)                          │
│                                                                          │
│  ② Merge sur dev → Staging                                              │
│     ├─ Supabase: db push vers staging DB (Coolify VPS)                   │
│     ├─ FastAPI: Webhook Coolify → auto re-deploy conteneur               │
│     ├─ Flutter: Build APK → GitHub Artifacts + Firebase App Distribution │
│     └─ Summary GitHub Actions                                            │
│                                                                          │
│  ③ Tag v* → Production                                                   │
│     ├─ cider bump + tag (version + CHANGELOG)                            │
│     ├─ Supabase: db push vers production DB (Coolify VPS)                │
│     ├─ FastAPI: Webhook Coolify → auto re-deploy conteneur               │
│     ├─ Flutter Android: Build AAB/APK → GitHub Release                   │
│     ├─ Flutter iOS: Build (quand compte Apple dispo)                     │
│     ├─ Play Store / App Store (quand comptes dispos)                     │
│     └─ Shorebird: release OTA (quand activé)                             │
│                                                                          │
│  ④ Hotfix urgent                                                         │
│     └─ Shorebird patch → OTA en minutes (pas besoin de review Store)     │
│                                                                          │
│  ⑤ Monitoring continu                                                    │
│     ├─ Firebase Crashlytics (crashes)                                    │
│     ├─ Firebase Analytics (usage)                                        │
│     └─ Sentry (erreurs FastAPI)                                          │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Stack d'Outils

### 1. CI/CD — Orchestrateurs

| Outil | Rôle | Coût |
|-------|------|------|
| **GitHub Actions** | CI + builds + deploy triggers | Gratuit (2000 min/mois) |

### 2. Build & Deploy

| Outil | Rôle | Open Source |
|-------|------|-------------|
| **Fastlane** | Automatise signing, build, upload stores | ✅ MIT |
| **Fastlane `match`** | Certificats iOS centralisés (Git-based) | ✅ |
| **Fastlane `deliver`** | Upload App Store | ✅ |
| **Fastlane `supply`** | Upload Google Play | ✅ |
| **Docker** | Containerise FastAPI backend | ✅ |

### 3. Distribution Beta

| Outil | Rôle | Coût |
|-------|------|------|
| **Firebase App Distribution** | Distribution beta iOS + Android aux testeurs | Gratuit |
| **TestFlight** | Beta iOS (via `fastlane pilot`) | Gratuit (Apple) |
| **Google Play Internal Testing** | Beta Android (via `fastlane supply`) | Gratuit (Google) |

### 4. Screenshots Automatisées

| Outil | Rôle | Open Source |
|-------|------|-------------|
| **`golden_toolkit`** | Capture pixel-perfect dans tests Flutter | ✅ (déjà dans pubspec) |
| **`device_frame`** | Cadres de device réalistes | ✅ |
| **Fastlane `frameit`** | Ajoute texte marketing aux screenshots | ✅ |
| **Fastlane `snapshot`** | Capture iOS via XCUITest | ✅ |
| **Fastlane `screengrab`** | Capture Android via Espresso | ✅ |

### 5. Versioning & Release

| Outil | Rôle | Open Source |
|-------|------|-------------|
| **`cider`** | Bump semver `pubspec.yaml` + `CHANGELOG.md` | ✅ MIT |
| **`release-please`** | PR de release auto (Google, GitHub Action) | ✅ |
| **Conventional Commits** | Convention de messages de commit | Standard |

### 6. Supabase Deployment

| Commande | Rôle |
|----------|------|
| `supabase db push` | Pousse migrations vers staging/production |
| `supabase db diff` | Génère diff de schéma automatique |
| `supabase gen types` | Génère types Dart depuis le schéma |
| `supabase/setup-cli@v1` | Action GitHub officielle |

### 7. OTA Updates (Over-The-Air)

| Outil | Rôle | Coût |
|-------|------|------|
| **Shorebird** | Code Push Flutter — patches instantanés sans review Store | Gratuit (5000 installs/mois) |

### 8. Monitoring & Crash Reporting

| Outil | Rôle | Coût |
|-------|------|------|
| **Firebase Crashlytics** | Crash reporting Flutter | Gratuit |
| **Firebase Analytics** | Analytics usage | Gratuit |
| **Sentry** | Error tracking FastAPI | Gratuit (tier) |

### 9. Hosting Backend

| Outil | Rôle | Coût |
|-------|------|------|
| **Coolify (VPS)** | Deploy FastAPI + Supabase (staging+prod) | $0 (VPS déjà payé) |

---

## Coût Total Estimé

| Outil | Coût/mois |
|-------|-----------|
| GitHub Actions | $0 |
| Fastlane | $0 (open source) |
| Firebase (Crashlytics + App Distribution + Analytics) | $0 |
| Coolify + VPS (Supabase staging + prod + FastAPI) | $0 (déjà payé) |
| Shorebird | $0 (5000 installs) → $20 |
| Cider | $0 (open source) |
| **TOTAL** | **$0** |

---

## Structure des Fichiers CI/CD

```
lifeflow/
├── .github/
│   └── workflows/
│       ├── ci.yml                  # CI: lint + test (chaque PR)
│       ├── staging.yml             # Deploy staging (push dev)
│       └── production.yml          # Deploy production (tag v*)
├── flutter/
│   ├── android/
│   │   └── fastlane/
│   │       ├── Appfile
│   │       ├── Fastfile
│   │       └── Gemfile
│   ├── ios/
│   │   └── fastlane/
│   │       ├── Appfile
│   │       ├── Fastfile
│   │       ├── Matchfile
│   │       └── Gemfile
│   └── Gemfile                     # Root Gemfile for fastlane
├── fastapi/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── .dockerignore
│   ├── fly.toml                    # (backup, Coolify utilisé)
│   └── fly.staging.toml            # (backup, Coolify utilisé)
├── scripts/
│   ├── setup.ps1                   # Setup local dev environment
│   ├── test.ps1                    # Run all tests
│   ├── reset_db.ps1                # Reset Supabase DB
│   ├── build.ps1                   # Build Flutter app
│   └── deploy.ps1                  # Deploy to staging/production
└── CHANGELOG.md
```

---

## Workflow Détaillé

### Phase 1 : Chaque PR (CI)

```
on: pull_request
jobs:
  flutter-ci:    dart analyze → flutter test
  fastapi-ci:    ruff check → pytest
  supabase-ci:   db start → db reset → gen types (vérifie types à jour)
```

### Phase 2 : Merge sur dev (Staging)

```
on: push (dev branch)
jobs:
  deploy-supabase-staging:   supabase db push --db-url → staging DB (Coolify VPS)
  deploy-fastapi-staging:    curl webhook Coolify → re-deploy conteneur
  deploy-flutter-staging:    flutter build apk → artifact + firebase app distribution
```

### Phase 3 : Tag v* (Production)

```
on: tag v*
jobs:
  deploy-supabase-prod:      supabase db push --db-url → production DB (Coolify VPS)
  deploy-fastapi-prod:       curl webhook Coolify → re-deploy conteneur
  deploy-flutter-android:    flutter build appbundle + apk → GitHub Release artifacts
  deploy-flutter-ios:        flutter build ios (quand compte Apple dispo)
  github-release:            GitHub Release + changelog + artifacts AAB/APK
```

---

## Secrets GitHub Requis

| Secret | Description |
|--------|-------------|
| `STAGING_SUPABASE_DB_URL` | URL Postgres staging (Coolify VPS) |
| `PROD_SUPABASE_DB_URL` | URL Postgres production (Coolify VPS) |
| `COOLIFY_WEBHOOK_STAGING_API` | Webhook Coolify pour re-deploy FastAPI staging |
| `COOLIFY_WEBHOOK_PROD_API` | Webhook Coolify pour re-deploy FastAPI production |
| `ANDROID_KEYSTORE_BASE64` | Keystore Android encodé base64 |
| `ANDROID_KEY_ALIAS` | Alias de la clé Android |
| `ANDROID_KEY_PASSWORD` | Password de la clé Android |
| `ANDROID_KEYSTORE_PASSWORD` | Password du keystore Android |
| `FIREBASE_APP_ID_ANDROID` | ID app Firebase Android |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Service account JSON Firebase |
| `GOOGLE_PLAY_JSON_KEY` | Service account JSON Google Play (quand compte dispo) |
| `APP_STORE_CONNECT_API_KEY` | API key App Store Connect base64 (quand compte dispo) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID App Store Connect (quand compte dispo) |
| `APP_STORE_CONNECT_KEY_ID` | Key ID App Store Connect (quand compte dispo) |
| `MATCH_GIT_URL` | URL du repo Git pour certificats iOS (quand compte dispo) |
| `MATCH_PASSWORD` | Password pour décrypter les certificats (quand compte dispo) |
| `SHOREBIRD_TOKEN` | Token Shorebird pour code push (quand activé) |

---

## Calendrier de Mise en Place

| Semaine | Tâche | Priorité |
|---------|-------|----------|
| **S1** | GitHub Actions CI (lint + tests + Supabase) | 🔴 Critique |
| **S1** | Scripts locaux (setup, test, reset_db) + Docker FastAPI | 🔴 Critique |
| **S2** | Supabase staging+prod sur Coolify VPS | 🔴 Critique |
| **S2** | FastAPI staging+prod sur Coolify VPS (webhook) | 🔴 Critique |
| **S3** | Firebase App Distribution + keystore Android | 🟡 Haute |
| **S3** | cider versioning + CHANGELOG | 🟡 Haute |
| **S4** | Golden tests screenshots | 🟢 Moyenne |
| **S5** | Comptes Google Play + Apple Developer | 🟢 Moyenne |
| **S5** | Fastlane deliver/supply vers les Stores | 🟢 Moyenne |
| **S6** | Shorebird OTA + Crashlytics | 🔵 Nice-to-have |

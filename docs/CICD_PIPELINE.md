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
│  ② Merge sur develop → Staging                                           │
│     ├─ Supabase: db push vers staging project                            │
│     ├─ FastAPI: Docker build + deploy Fly.io staging                     │
│     ├─ Flutter: Codemagic build → Firebase App Distribution              │
│     └─ Notification Slack                                                │
│                                                                          │
│  ③ Merge sur main → Production                                           │
│     ├─ cider bump + release-please (version + CHANGELOG)                 │
│     ├─ Supabase: db push vers production                                 │
│     ├─ FastAPI: Docker deploy Fly.io production                          │
│     ├─ Flutter Android: fastlane supply → Google Play                    │
│     ├─ Flutter iOS: fastlane deliver → App Store Connect                 │
│     ├─ Screenshots: golden_toolkit + frameit → Store listings            │
│     └─ Shorebird: release (pour futurs patches OTA)                      │
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
| **GitHub Actions** | CI principal (lint, tests, Supabase) | Gratuit (2000 min/mois) |
| **Codemagic** | Builds iOS/Android (macOS M2 inclus) | Gratuit (500 min/mois) |

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
| **Fly.io** | Deploy FastAPI (Docker, global edge) | Gratuit → $5/mois |
| **Supabase Cloud** | DB + Auth + Storage + Realtime | Gratuit → $25/mois |

---

## Coût Total Estimé

| Outil | Coût/mois |
|-------|-----------|
| GitHub Actions | $0 |
| Codemagic | $0 (500 min) → $39 |
| Fastlane | $0 (open source) |
| Firebase (Crashlytics + App Distribution + Analytics) | $0 |
| Supabase (staging + prod) | $0 → $25 |
| Shorebird | $0 (5000 installs) → $20 |
| Fly.io | $0 → $5 |
| Cider | $0 (open source) |
| **TOTAL** | **$0 → $89/mois** |

---

## Structure des Fichiers CI/CD

```
lifeflow/
├── .github/
│   └── workflows/
│       ├── ci.yml                  # CI: lint + test (chaque PR)
│       ├── staging.yml             # Deploy staging (merge develop)
│       └── production.yml          # Deploy production (merge main)
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
│   └── fly.toml
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

### Phase 2 : Merge sur develop (Staging)

```
on: push (develop branch)
jobs:
  deploy-supabase-staging:   supabase db push → staging project
  deploy-fastapi-staging:    docker build → fly deploy staging
  deploy-flutter-staging:    flutter build → firebase app distribution
```

### Phase 3 : Merge sur main (Production)

```
on: push (main branch)
jobs:
  deploy-supabase-prod:      supabase db push → production project
  deploy-fastapi-prod:       docker build → fly deploy production
  deploy-flutter-android:    flutter build appbundle → fastlane supply
  deploy-flutter-ios:        flutter build ipa → fastlane deliver
  shorebird-release:         shorebird release android + ios
```

---

## Secrets GitHub Requis

| Secret | Description |
|--------|-------------|
| `SUPABASE_ACCESS_TOKEN` | Token personnel Supabase CLI |
| `STAGING_PROJECT_ID` | Ref du projet Supabase staging |
| `STAGING_DB_PASSWORD` | Mot de passe DB staging |
| `PRODUCTION_PROJECT_ID` | Ref du projet Supabase production |
| `PRODUCTION_DB_PASSWORD` | Mot de passe DB production |
| `FLY_API_TOKEN` | Token API Fly.io |
| `FIREBASE_APP_ID_ANDROID` | ID app Firebase Android |
| `FIREBASE_APP_ID_IOS` | ID app Firebase iOS |
| `FIREBASE_TOKEN` | Token Firebase CLI |
| `PLAY_STORE_JSON_KEY` | Service account JSON Google Play |
| `APP_STORE_CONNECT_API_KEY` | API key App Store Connect (base64) |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID App Store Connect |
| `APP_STORE_CONNECT_KEY_ID` | Key ID App Store Connect |
| `MATCH_GIT_URL` | URL du repo Git pour certificats iOS |
| `MATCH_PASSWORD` | Password pour décrypter les certificats |
| `SHOREBIRD_TOKEN` | Token Shorebird pour code push |
| `ANDROID_KEYSTORE_BASE64` | Keystore Android encodé base64 |
| `ANDROID_KEY_ALIAS` | Alias de la clé Android |
| `ANDROID_KEY_PASSWORD` | Password de la clé Android |
| `ANDROID_STORE_PASSWORD` | Password du keystore Android |

---

## Calendrier de Mise en Place

| Semaine | Tâche | Priorité |
|---------|-------|----------|
| **S1** | GitHub Actions CI (lint + tests + Supabase) | 🔴 Critique |
| **S2** | Scripts locaux (setup, test, reset_db) + Docker FastAPI | 🔴 Critique |
| **S3** | Fastlane setup (match iOS + keystore Android) | 🟡 Haute |
| **S4** | Codemagic builds + Firebase App Distribution | 🟡 Haute |
| **S5** | Golden tests screenshots + cider versioning | 🟢 Moyenne |
| **S6** | Fastlane deliver/supply vers les Stores | 🟢 Moyenne |
| **S7** | Shorebird integration + Crashlytics | 🔵 Nice-to-have |
| **S8** | Pipeline production complète + monitoring | 🔵 Nice-to-have |

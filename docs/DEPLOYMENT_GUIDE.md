# LifeFlow — Guide de Déploiement

> **Document vivant** — mis à jour au fur et à mesure de l'avancement.
> Dernière mise à jour : 22 février 2026.

---

## Statut actuel

| Élément | Statut | Notes |
|---------|--------|-------|
| CI GitHub Actions (lint + tests) | ✅ Prêt | `.github/workflows/ci.yml` |
| Scripts locaux (setup, test, build, etc.) | ✅ Prêt | `scripts/` |
| Fastlane Android | ✅ Configuré | Lanes beta, internal, release |
| Fastlane iOS | ✅ Configuré | Lanes beta, release, match |
| Dockerfile FastAPI | ✅ Prêt | Multi-stage, uv, non-root |
| Supabase local | ✅ Fonctionne | 7 migrations, seeds |
| Supabase staging (Coolify VPS) | ⬜ À déployer | Instance séparée sur Coolify |
| Supabase prod (Coolify VPS) | ⬜ À déployer | Instance séparée sur Coolify |
| FastAPI staging (Coolify VPS) | ⬜ À déployer | Docker sur Coolify |
| FastAPI prod (Coolify VPS) | ⬜ À déployer | Docker sur Coolify |
| Firebase App Distribution | ⬜ À configurer | Distribution APK beta |
| Android Keystore signing | ⬜ À créer | Nécessaire pour APK release |
| Compte Google Play | ⬜ Pas encore | $25 one-time |
| Compte Apple Developer | ⬜ Pas encore | $99/an |
| Shorebird OTA | ⬜ Plus tard | Après release stores |

---

## Infrastructure

### Architecture cible

```
┌─────────────────────────────────────────────────────────────┐
│                      TON VPS (Coolify)                       │
│                                                              │
│  ┌──────────────────┐    ┌──────────────────┐               │
│  │  Supabase        │    │  Supabase        │               │
│  │  STAGING         │    │  PRODUCTION      │               │
│  │  port: 8000      │    │  port: 9000      │               │
│  │  db: 5433        │    │  db: 5434        │               │
│  └──────────────────┘    └──────────────────┘               │
│                                                              │
│  ┌──────────────────┐    ┌──────────────────┐               │
│  │  FastAPI          │    │  FastAPI          │               │
│  │  STAGING         │    │  PRODUCTION      │               │
│  │  port: 8001      │    │  port: 8002      │               │
│  └──────────────────┘    └──────────────────┘               │
│                                                              │
│  Coolify gère : SSL, reverse proxy, deploy auto             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                     GITHUB ACTIONS (CI)                       │
│                                                              │
│  PR → ci.yml : lint + tests + migrations                     │
│  push dev → staging.yml : deploy staging + build APK/IPA    │
│  tag v* → production.yml : deploy prod + stores (futur)     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│               DISTRIBUTION (pour les testeurs)               │
│                                                              │
│  Android : Firebase App Distribution (gratuit)               │
│  iOS : TestFlight (quand compte Apple dispo)                 │
│  Artifacts : APK/IPA téléchargeables depuis GitHub Actions   │
└─────────────────────────────────────────────────────────────┘
```

### Branches Git

| Branche | Rôle | Déclenche |
|---------|------|-----------|
| `feature/*` | Développement | PR vers `dev` → `ci.yml` |
| `dev` | Staging / intégration | Push → `staging.yml` |
| `main` | Production | Tag `v*` → `production.yml` |

---

## Ce que tu dois configurer MAINTENANT

### Étape 1 : Repo GitHub (5 min)

```powershell
# Si pas déjà fait :
git remote add origin https://github.com/TON_USER/lifeflow.git
git push -u origin main
git push -u origin dev
```

### Étape 2 : Supabase staging + prod sur Coolify (30 min)

Sur le dashboard Coolify de ton VPS :

**Instance Staging :**
1. New Resource → Docker Compose → colle le docker-compose Supabase officiel
2. Change les ports pour éviter les conflits :
   - API : `8000` (au lieu de 54321)
   - Studio : `8443`  (au lieu de 54323)
   - DB : `5433` (au lieu de 54322)
3. Configure un domaine : `supabase-staging.ton-domaine.com`
4. Note les clés générées : `ANON_KEY`, `SERVICE_ROLE_KEY`, `JWT_SECRET`

> **⚠ IMPORTANT : Exposer le port PostgreSQL**
>
> Par défaut, le service `supabase-db` n'est PAS accessible depuis l'extérieur du Docker network.
> Tu DOIS exposer le port 5432 du conteneur `supabase-db` sur un port public du VPS
> pour que `supabase db push --db-url` fonctionne (en local ou depuis GitHub Actions).
>
> **Dans Coolify → Service → supabase-db → Ports :**
> - Ajouter un port mapping : `5433:5432` (staging)
> - Pour la prod : `5434:5432`
>
> **Sécurité** : Tu peux restreindre l'accès au port via UFW :
> ```bash
> # N'autoriser que ton IP à accéder au port Postgres staging
> sudo ufw allow from TON_IP_MAISON to any port 5433
> sudo ufw allow from TON_IP_MAISON to any port 5434
> # OU pour GitHub Actions (IPs dynamiques) — ouvrir mais utiliser un mot de passe fort
> ```

**Instance Production :**
1. Même chose, ports différents :
   - API : `9000`
   - Studio : `9443`
   - DB : `5434`
2. Domaine : `supabase.ton-domaine.com`
3. Note les clés

**Appliquer les migrations :**
```powershell
# Via le script dédié (recommandé)
.\scripts\push-migrations.ps1                           # staging (par défaut)
.\scripts\push-migrations.ps1 -Environment production   # production
.\scripts\push-migrations.ps1 -DryRun                   # voir sans exécuter

# Ou manuellement
supabase db push --db-url postgresql://postgres:MOT_DE_PASSE@ton-vps:5433/postgres
```

### Étape 3 : FastAPI sur Coolify (15 min)

Sur Coolify :
1. New Resource → Docker (from GitHub)
2. Pointe vers ton repo, dossier `fastapi/`, branche `dev`
3. Dockerfile : `Dockerfile`
4. Variables d'environnement :
   ```
   ENV=staging
   SUPABASE_URL=https://supabase-staging.ton-domaine.com
   SUPABASE_SERVICE_ROLE_KEY=eyJ...
   SUPABASE_JWT_SECRET=...
   SECRET_KEY=un-vrai-secret-random
   ```
5. Domaine : `api-staging.ton-domaine.com`
6. Active l'auto-deploy sur push (webhook GitHub)

Répète pour la production avec la branche `main`.

### Étape 4 : Firebase App Distribution (20 min)

> Permet de distribuer automatiquement les APK aux testeurs Android.
> **100% gratuit, pas besoin de compte Google Play.**

1. Va sur [console.firebase.google.com](https://console.firebase.google.com)
2. Crée un projet `lifeflow`
3. Ajoute une app Android :
   - Package name : `com.vitatech.lifeflow`
   - Télécharge `google-services.json` → mets-le dans `flutter/android/app/`
4. Va dans **Project Settings → Service Accounts**
5. Clique **Generate new private key** → télécharge le JSON
6. Va dans **Release & Monitor → App Distribution**
7. Crée un groupe de testeurs : `internal-testers`
8. Ajoute les emails des testeurs

### Étape 5 : Android Keystore (10 min)

> Nécessaire pour signer les APK en mode release.
> **Pas besoin de compte Google Play** pour ça.

```powershell
# Génère un keystore de signing
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Il te demande un mot de passe — note-le bien
# Réponses : ton nom, organisation "Vitatech", pays "TG" etc.
```

Encode le keystore en base64 pour GitHub :
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks"))
# Copie le résultat → c'est ton secret ANDROID_KEYSTORE_BASE64
```

Crée le fichier `flutter/android/key.properties` :
```properties
storePassword=ton-mot-de-passe
keyPassword=ton-mot-de-passe
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

### Étape 6 : Secrets GitHub (10 min)

Va dans **GitHub → ton repo → Settings → Secrets and variables → Actions → New repository secret**

**Secrets nécessaires MAINTENANT (pour CI + staging + APK) :**

| Secret | Valeur | Où la trouver |
|--------|--------|---------------|
| `ANDROID_KEYSTORE_BASE64` | Le base64 du .jks | Étape 5 |
| `ANDROID_KEYSTORE_PASSWORD` | Mot de passe du keystore | Étape 5 |
| `ANDROID_KEY_PASSWORD` | Mot de passe de la clé | Étape 5 |
| `ANDROID_KEY_ALIAS` | `upload` | Étape 5 |
| `FIREBASE_APP_ID_ANDROID` | `1:123456:android:abc123` | Firebase → Project Settings → App ID |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Contenu du JSON téléchargé | Étape 4.5 |

**Secrets pour déployer sur Coolify (staging.yml) :**

| Secret | Valeur | Où la trouver |
|--------|--------|---------------|
| `COOLIFY_WEBHOOK_STAGING_API` | URL webhook | Coolify → App → Webhooks |
| `COOLIFY_WEBHOOK_PROD_API` | URL webhook | Coolify → App → Webhooks |
| `STAGING_SUPABASE_DB_URL` | `postgresql://postgres:xxx@vps:5433/postgres` | Étape 2 |
| `STAGING_SUPABASE_URL` | `http://supabase-staging-lifeflow.xxx.sslip.io` | Coolify → Kong URL |
| `STAGING_SUPABASE_ANON_KEY` | `eyJ...` | Coolify → SERVICE_SUPABASEANON_KEY |
| `PROD_SUPABASE_DB_URL` | `postgresql://postgres:xxx@vps:5434/postgres` | Étape 2 |
| `PROD_SUPABASE_URL` | `http://supabase-prod-lifeflow.xxx.sslip.io` | Coolify → Kong URL |
| `PROD_SUPABASE_ANON_KEY` | `eyJ...` | Coolify → SERVICE_SUPABASEANON_KEY |

**Variables de repo (Settings → Variables → Actions) :**

| Variable | Valeur | Usage |
|----------|--------|-------|
| `STAGING_API_BASE_URL` | `http://144.91.67.237:8000/api/v1` | URL FastAPI staging |
| `PROD_API_BASE_URL` | (quand prêt) | URL FastAPI production |
| `ENABLE_IOS_BUILD` | `false` | Passer à `true` quand compte Apple dispo |

**Secrets PAS ENCORE nécessaires (quand tu auras les comptes stores) :**

| Secret | Quand |
|--------|-------|
| `GOOGLE_PLAY_JSON_KEY` | Quand tu as un compte Google Play ($25) |
| `APP_STORE_CONNECT_*` | Quand tu as un compte Apple Developer ($99/an) |
| `MATCH_GIT_URL` / `MATCH_PASSWORD` | Quand tu as un compte Apple Developer |
| `SHOREBIRD_TOKEN` | Quand tu actives Shorebird OTA |

---

## Ce qui se passe concrètement à chaque étape

### Tu codes et push une PR

```
toi: git checkout -b feat/habit-streaks
toi: (code...)
toi: git commit -m "feat: add habit streaks"    ← pre-commit hook vérifie format+lint
toi: git push origin feat/habit-streaks
toi: (crée une PR vers dev sur GitHub)

GitHub Actions ci.yml (automatique, ~5 min) :
  → dart format --set-exit-if-changed ✅
  → dart analyze --fatal-infos ✅
  → flutter test --exclude-tags=integration ✅
  → supabase start + flutter test --tags=integration ✅
  → uv run ruff check + ruff format + pytest ✅
  → supabase db reset ✅
  → Résultat affiché sur la PR : ✅ All checks passed
```

### Tu merges dans dev

```
toi: (merge la PR dans dev sur GitHub)

GitHub Actions staging.yml (automatique, ~8 min) :
  → supabase db push vers staging (Coolify VPS)
  → Webhook Coolify → re-deploy FastAPI staging automatiquement
  → flutter build apk --release --dart-define=ENV=staging
  → Upload APK vers Firebase App Distribution
  → Tes testeurs reçoivent une notif → installent l'APK
  → APK aussi dispo en artifact sur GitHub Actions (téléchargeable)
```

### Tu fais une release

```
toi: git checkout main
toi: git merge dev
toi: cider bump patch       ← 0.1.0 → 0.1.1
toi: git tag v0.1.1
toi: git push origin main --tags

GitHub Actions production.yml (automatique) :
  → supabase db push vers production (Coolify VPS)
  → Webhook Coolify → re-deploy FastAPI production
  → flutter build appbundle + flutter build ipa
  → Artifacts téléchargeables sur GitHub
  → (Quand comptes stores dispo : auto-upload Play Store + App Store)
  → GitHub Release créée avec le changelog
```

---

## Scripts locaux — Référence rapide

| Script | Commande | Quand |
|--------|----------|-------|
| Setup initial | `.\scripts\setup.ps1` | 1 fois après clone |
| Installer hooks | `.\scripts\install-hooks.ps1` | 1 fois après setup |
| Reset DB | `.\scripts\reset_db.ps1` | DB corrompue / migration modifiée |
| Reset DB total | `.\scripts\reset_db.ps1 -Hard` | Docker Supabase buggé |
| Tests Flutter | `.\scripts\test.ps1 -Flutter` | Pendant le dev |
| Tests intégration | `.\scripts\test.ps1 -Integration` | Avant de push |
| Tests tout | `.\scripts\test.ps1` | Avant une PR |
| Tests + couverture | `.\scripts\test.ps1 -Flutter -Coverage` | Check couverture |
| Tests FastAPI | `.\scripts\test.ps1 -FastApi` | Après modif backend |
| Build APK debug | `.\scripts\build.ps1 -Platform apk` | Tester sur téléphone |
| Build APK release | `.\scripts\build.ps1 -Platform apk -Release` | APK optimisé |
| Build AAB prod | `.\scripts\build.ps1 -Platform aab -Env production -Release` | Pour Play Store |
| Build iOS | `.\scripts\build.ps1 -Platform ios -Release` | Requiert macOS |
| Build Web | `.\scripts\build.ps1 -Platform web` | Version web |

---

## Workflows GitHub Actions — Référence

### ci.yml — À chaque PR vers `main` ou `dev`

| Job | Ce qu'il fait | Durée |
|-----|---------------|-------|
| `flutter-ci` | `pub get` → `dart format` → `dart analyze` → `build_runner` → `flutter test` (unit) → upload coverage | ~3 min |
| `flutter-integration` | `supabase start` → `flutter test --tags=integration` | ~3 min |
| `fastapi-ci` | `uv sync` → `ruff check` → `ruff format` → `mypy` → `pytest --cov` | ~2 min |
| `supabase-ci` | `db start` → `db reset` → `gen types` → vérifier types à jour | ~2 min |

### staging.yml — À chaque push sur `dev`

| Job | Ce qu'il fait | Durée |
|-----|---------------|-------|
| `supabase-staging` | `supabase db push` vers staging sur Coolify VPS | ~1 min |
| `fastapi-staging` | Webhook Coolify → re-deploy conteneur | ~2 min |
| `flutter-beta-android` | Build APK → Firebase App Distribution | ~5 min |
| `flutter-beta-ios` | Build IPA → artifact (TestFlight quand compte Apple dispo) | ~10 min |

### production.yml — À chaque tag `v*`

| Job | Ce qu'il fait | Durée |
|-----|---------------|-------|
| `validate` | Extrait version du tag | <1 min |
| `supabase-production` | `supabase db push` vers prod sur Coolify VPS | ~1 min |
| `fastapi-production` | Webhook Coolify → re-deploy conteneur | ~2 min |
| `flutter-android-release` | Build AAB signé → artifact (Play Store quand compte dispo) | ~5 min |
| `flutter-ios-release` | Build IPA → artifact (App Store quand compte dispo) | ~10 min |
| `github-release` | Crée GitHub Release + attache AAB | ~1 min |

---

## Fastlane — Référence

### iOS (`flutter/ios/fastlane/Fastfile`)

| Lane | Usage | Prérequis |
|------|-------|-----------|
| `fastlane sync_signing` | Télécharge certificats depuis match | Compte Apple Developer |
| `fastlane beta` | Build + upload TestFlight | Compte Apple Developer |
| `fastlane release` | Build + submit App Store | Compte Apple Developer |

### Android (`flutter/android/fastlane/Fastfile`)

| Lane | Usage | Prérequis |
|------|-------|-----------|
| `fastlane beta` | Upload APK → Firebase App Distribution | Firebase (gratuit) |
| `fastlane internal` | Upload AAB → Play Store internal track | Compte Google Play |
| `fastlane release` | Upload AAB → Play Store production | Compte Google Play |
| `fastlane promote` | Promouvoir internal → production | Compte Google Play |

---

## Coût

| Service | Coût | Quand |
|---------|------|-------|
| GitHub Actions | $0 | Maintenant (2000 min/mois gratuit) |
| Firebase App Distribution | $0 | Maintenant |
| Coolify + VPS | $0 (déjà payé) | Maintenant |
| Keystore Android | $0 | Maintenant |
| Compte Google Play | $25 (une fois) | Quand tu veux publier |
| Compte Apple Developer | $99/an | Quand tu veux publier iOS |
| Shorebird OTA | $0 (5000 installs) | Plus tard |
| **Total immédiat** | **$0** | |

---

## Checklist de déploiement

- [ ] Repo GitHub créé et code pushé
- [ ] Supabase staging déployé sur Coolify
- [ ] Supabase production déployé sur Coolify
- [ ] FastAPI staging déployé sur Coolify (auto-deploy webhook)
- [ ] FastAPI production déployé sur Coolify (auto-deploy webhook)
- [ ] Firebase projet créé + App Distribution configuré
- [ ] Android keystore généré
- [ ] GitHub Secrets configurés (6 secrets minimum)
- [ ] Premier push sur `dev` → staging.yml tourne ✅
- [ ] Premier tag `v0.1.0` → production.yml tourne ✅
- [ ] APK téléchargeable depuis GitHub Actions artifacts ✅
- [ ] APK reçu sur Firebase App Distribution ✅
- [ ] (Futur) Compte Google Play → activer auto-upload
- [ ] (Futur) Compte Apple Developer → activer TestFlight + App Store
- [ ] (Futur) Shorebird → activer OTA patches

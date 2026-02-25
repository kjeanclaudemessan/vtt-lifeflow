# Migration vers Supabase Cloud — Checklist

## ✅ Fichiers locaux (FAIT)

- [x] `flutter/.env.staging` → URL et anon key Supabase Cloud
- [x] `fastapi/.env.staging` → URL, anon key, service_role, JWT secret, CORS

---

## ⏳ À FAIRE

### 1️⃣ Vérifier anon key

La clé actuelle semble courte : `sb_publishable_WlsGUQ4EW1icBwpKg8qIpg_NkpwQ81-`

**Action** : Vérifier dans **Supabase dashboard → Settings → API → "anon public"**
Si différente, la remplacer dans :
- `flutter/.env.staging`
- `fastapi/.env.staging`
- GitHub Secret `STAGING_SUPABASE_ANON_KEY`

---

### 2️⃣ GitHub Secrets

**Repository → Settings → Secrets and variables → Actions**

Mettre à jour ces 3 secrets :

```bash
STAGING_SUPABASE_URL
https://oqziaaabsvnmwxsorcea.supabase.co

STAGING_SUPABASE_ANON_KEY
sb_publishable_WlsGUQ4EW1icBwpKg8qIpg_NkpwQ81-

STAGING_SUPABASE_DB_URL
postgresql://postgres.oqziaaabsvnmwxsorcea:rLLT5KXqCU6QNw4f@aws-1-eu-west-1.pooler.supabase.com:5432/postgres
```

---

### 3️⃣ Pousser les migrations (7 fichiers)

Dans le terminal PowerShell :

```powershell
cd f:\programmation\vtt\lifeflow\supabase
supabase db push --db-url "postgresql://postgres.oqziaaabsvnmwxsorcea:rLLT5KXqCU6QNw4f@aws-1-eu-west-1.pooler.supabase.com:5432/postgres"
```

Migrations à appliquer :
1. `20260122000000_create_profiles.sql`
2. `20260123000005_create_payments.sql`
3. `20260220000001_create_domains.sql`
4. `20260220000002_create_habits.sql`
5. `20260220000003_create_routines.sql`
6. `20260220000004_create_tasks.sql`
7. `20260220000005_create_inbox_items.sql`

---

### 4️⃣ Google OAuth — Mettre à jour redirect URI

**Google Cloud Console** → APIs & Services → Credentials → OAuth 2.0 Client ID

**Authorized redirect URIs** → **Ajouter** :

```
https://oqziaaabsvnmwxsorcea.supabase.co/auth/v1/callback
```

(Tu peux garder l'ancien Coolify temporairement)

---

### 5️⃣ Configurer Google OAuth dans Supabase

**Supabase dashboard → Authentication → Providers → Google**

1. **Enable Google provider** ✓
2. **Client ID** : `16508544154-hkgb108rino9qjo3649qoeh9q2rp5avi.apps.googleusercontent.com`
3. **Client Secret** : `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`
4. **Save**

---

### 6️⃣ Firebase Push Notifications (indépendant)

**Firebase Console** → Project Settings → General

Télécharger `google-services.json` et placer dans :

```
flutter/android/app/google-services.json
```

---

### 7️⃣ App Icons (indépendant)

1. Générer icône 1024×1024 PNG (avec le prompt AI fourni précédemment)
2. Placer dans `flutter/assets/icon/` :
   - `app_icon.png` (1024×1024, pas de transparence)
   - `app_icon_foreground.png` (optionnel pour Android adaptive)
3. Exécuter :

```powershell
cd flutter
dart run flutter_launcher_icons
```

---

## 📊 Credentials Supabase Cloud (Référence)

| Item | Valeur |
|------|---------|
| **Project URL** | `https://oqziaaabsvnmwxsorcea.supabase.co` |
| **anon public** | `sb_publishable_WlsGUQ4EW1icBwpKg8qIpg_NkpwQ81-` ⚠️ À vérifier |
| **service_role** | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xemlhYWFic3ZubXd4c29yY2VhIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MjA0NzgyMywiZXhwIjoyMDg3NjIzODIzfQ.sxLWTrjUmeK2JJqFJWds6zpV6Ku1DXHLgiZZA3i2W0Y` |
| **JWT Secret** | `vAYu46WU2okDThRL/k/OL/5LC4a2lGk1QWhdMpE/qs7R0UgbYZSHwrUK1v48PaocAz1Z4Jcx7m2fP15PhJQ25w==` |
| **DB Password** | `rLLT5KXqCU6QNw4f` |
| **Direct URL** | `postgresql://postgres.oqziaaabsvnmwxsorcea:rLLT5KXqCU6QNw4f@aws-1-eu-west-1.pooler.supabase.com:5432/postgres` |

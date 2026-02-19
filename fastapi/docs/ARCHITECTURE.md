# 🏗️ VTT FastAPI Template - Architecture

> **Version**: 1.0.0  
> **Date**: 27 Janvier 2026  
> **Stack**: FastAPI + Supabase + Pydantic v2

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Principes Architecturaux](#principes-architecturaux)
3. [Structure des Dossiers](#structure-des-dossiers)
4. [Couches de l'Application](#couches-de-lapplication)
5. [Modules](#modules)
6. [Services](#services)
7. [Features](#features)
8. [Correspondance avec Supabase](#correspondance-avec-supabase)
9. [Conventions](#conventions)

---

## 🎯 Vue d'Ensemble

### Objectif

Ce template fournit une base solide pour créer des APIs FastAPI qui:

- ✅ S'intègrent avec **Supabase** (Auth, DB, Storage)
- ✅ Respectent la **Clean Architecture**
- ✅ Sont **modulaires** et réutilisables
- ✅ Miroir de l'architecture **Flutter** (cohérence fullstack)
- ✅ Gèrent les **webhooks** et **tâches background**

### Stack Technique

| Composant | Technologie |
|-----------|-------------|
| Framework | FastAPI |
| Validation | Pydantic v2 |
| Config | pydantic-settings |
| HTTP Client | httpx (async) |
| DB Client | supabase-py |
| Cache | Redis (optionnel) |
| Background | Celery / ARQ |
| Testing | pytest + pytest-asyncio |
| Logging | structlog |

---

## 🧱 Principes Architecturaux

### Clean Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         API LAYER                           │
│                  (Routers, Endpoints)                       │
│              Dépend de: Modules, Core                       │
├─────────────────────────────────────────────────────────────┤
│                      MODULES LAYER                          │
│         (Auth, Profile, Notifications, etc.)                │
│              Dépend de: Services, Core                      │
├─────────────────────────────────────────────────────────────┤
│                     SERVICES LAYER                          │
│            (Email, SMS, Storage, Push)                      │
│              Dépend de: Core, DB                            │
├─────────────────────────────────────────────────────────────┤
│                        DB LAYER                             │
│              (Supabase, Redis)                              │
│              Dépend de: Core                                │
├─────────────────────────────────────────────────────────────┤
│                       CORE LAYER                            │
│           (Config, Security, Exceptions)                    │
│              Dépend de: Rien                                │
└─────────────────────────────────────────────────────────────┘
```

### Principes SOLID

| Principe | Application |
|----------|-------------|
| **S**ingle Responsibility | Un module = une responsabilité |
| **O**pen/Closed | Extension via interfaces |
| **L**iskov Substitution | Providers interchangeables |
| **I**nterface Segregation | Petites interfaces ciblées |
| **D**ependency Inversion | Injection de dépendances |

---

## 📁 Structure des Dossiers

```
vtt_fastapi_template/
│
├── app/
│   ├── __init__.py
│   ├── main.py                      # Application factory
│   │
│   ├── core/                        # 🔧 Fondations
│   │   ├── __init__.py
│   │   ├── config.py                # Settings (pydantic-settings)
│   │   ├── security.py              # JWT verification, hashing
│   │   ├── exceptions.py            # Custom exceptions
│   │   ├── middleware.py            # CORS, logging, rate limit
│   │   └── lifespan.py              # Startup/shutdown
│   │
│   ├── db/                          # 🗄️ Database
│   │   ├── __init__.py
│   │   ├── supabase.py              # Supabase client
│   │   └── redis.py                 # Redis client (optionnel)
│   │
│   ├── schemas/                     # 📋 Schemas partagés
│   │   ├── __init__.py
│   │   ├── base.py                  # BaseSchema, responses
│   │   ├── pagination.py            # Pagination schemas
│   │   └── common.py                # Shared schemas
│   │
│   ├── modules/                     # 📦 MODULES (miroir Flutter)
│   │   ├── __init__.py
│   │   │
│   │   ├── auth/                    # 🔐 Authentication
│   │   │   ├── __init__.py
│   │   │   ├── router.py
│   │   │   ├── service.py
│   │   │   ├── schemas.py
│   │   │   └── dependencies.py
│   │   │
│   │   ├── users/                   # 👤 Users
│   │   │   ├── __init__.py
│   │   │   ├── router.py
│   │   │   ├── service.py
│   │   │   ├── repository.py
│   │   │   └── schemas.py
│   │   │
│   │   ├── profile/                 # 📝 Profile
│   │   │   └── ...
│   │   │
│   │   ├── notifications/           # 🔔 Notifications
│   │   │   └── ...
│   │   │
│   │   ├── webhooks/                # 🪝 Webhooks
│   │   │   ├── __init__.py
│   │   │   ├── router.py
│   │   │   └── handlers/
│   │   │
│   │   └── optional/                # ⚡ Optionnels
│   │       ├── organizations/       # → organizations table
│   │       ├── payments/            # → payments table
│   │       ├── subscriptions/       # → subscriptions table
│   │       ├── invitations/         # → invitations table
│   │       ├── comments/            # → comments table
│   │       ├── attachments/         # → attachments table
│   │       ├── tags/                # → tags table
│   │       ├── favorites/           # → favorites table
│   │       └── activities/          # → activities table
│   │
│   ├── services/                    # 🔌 Services externes
│   │   ├── __init__.py
│   │   ├── email/
│   │   ├── sms/
│   │   ├── storage/
│   │   └── push/
│   │
│   ├── features/                    # 🎯 Features spécifiques
│   │   ├── __init__.py
│   │   └── .gitkeep
│   │
│   ├── workers/                     # ⚙️ Background tasks
│   │   ├── __init__.py
│   │   ├── celery.py
│   │   └── tasks/
│   │
│   └── api/                         # 🌐 API versioning
│       ├── __init__.py
│       └── v1/
│           ├── __init__.py
│           └── router.py
│
├── tests/
│   ├── conftest.py
│   ├── modules/
│   └── features/
│
├── scripts/
│   └── seed.py
│
├── docs/
│   └── ARCHITECTURE.md
│
├── .env.example
├── pyproject.toml
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── README.md
```

---

## 📦 Modules

### Modules Core (toujours présents)

| Module | Table Supabase | Description |
|--------|----------------|-------------|
| `auth` | `auth.users` | Vérification JWT Supabase |
| `users` | `auth.users` | Lecture users (admin) |
| `profile` | `profiles` | GET/PATCH profil courant |
| `notifications` | `notifications` | Centre de notifications |
| `webhooks` | - | Handlers webhooks |

### Modules Optionnels (miroir Flutter)

| Module | Table Supabase | Description |
|--------|----------------|-------------|
| `organizations` | `organizations`, `organization_members` | Multi-tenant |
| `payments` | `payments` | Historique paiements |
| `subscriptions` | `subscriptions`, `subscription_plans` | Abonnements |
| `invitations` | `invitations` | Invitations org |
| `comments` | `comments` | Commentaires polymorphiques |
| `attachments` | `attachments` | Fichiers attachés |
| `tags` | `tags`, `taggables` | Tags polymorphiques |
| `favorites` | `favorites` | Favoris polymorphiques |
| `activities` | `activities` | Activity feed |

---

## 🔌 Services

Services techniques wrappant des APIs externes:

| Service | Provider(s) | Usage |
|---------|-------------|-------|
| `email` | Resend, SendGrid | Emails transactionnels |
| `sms` | Twilio, Termii | SMS OTP, notifications |
| `storage` | Supabase Storage | Upload/download fichiers |
| `push` | FCM | Push notifications |

---

## 🎯 Features

Dossier `features/` = **vide dans le template**.

Exemples de features ajoutées par projet:

| Projet | Features |
|--------|----------|
| LingoFlow | `voice_chat/`, `youtube_processor/` |
| StockPilot | `whatsapp_bot/`, `inventory_ai/` |
| PressingSync | `image_matching/`, `whatsapp_bot/` |
| IronFlow | `workout_ai/`, `progressive_overload/` |
| SalesForge | `voice_training/`, `llm_coach/` |

---

## 🗄️ Correspondance avec Supabase

Le backend **ne crée pas** de tables. Il utilise les tables définies dans `supabase/migrations/`.

### Tables Core

```sql
profiles (id, first_name, last_name, display_name, avatar_url, 
          locale, timezone, role, organization_id, metadata, preferences,
          created_at, updated_at, deleted_at)
```

### Tables Optionnelles

```sql
organizations (id, name, slug, logo_url, settings, owner_id, ...)
organization_members (id, organization_id, user_id, role, ...)
subscriptions (id, user_id, plan_id, status, ...)
payments (id, user_id, amount, currency, status, provider, ...)
invitations (id, organization_id, email, role, token, ...)
comments (id, user_id, commentable_type, commentable_id, content, ...)
attachments (id, user_id, attachable_type, attachable_id, file_url, ...)
tags (id, name, slug, ...) + taggables (tag_id, taggable_type, taggable_id)
favorites (id, user_id, favoritable_type, favoritable_id, ...)
activities (id, user_id, action, subject_type, subject_id, metadata, ...)
```

---

## 📐 Conventions

### Nommage

| Élément | Convention | Exemple |
|---------|------------|---------|
| Fichiers | snake_case | `user_service.py` |
| Classes | PascalCase | `UserService` |
| Fonctions | snake_case | `get_current_user` |
| Variables | snake_case | `user_id` |
| Constantes | UPPER_SNAKE | `MAX_RETRIES` |
| Routes | kebab-case | `/api/v1/users/me` |

### Structure d'un Module

```
module_name/
├── __init__.py          # Exports
├── router.py            # Routes FastAPI
├── service.py           # Logique métier
├── repository.py        # Accès données (si besoin)
├── schemas.py           # Pydantic models
└── dependencies.py      # Dépendances injectables
```

### Responses Standardisées

```python
# Succès
{"success": True, "data": {...}, "message": "..."}

# Erreur
{"success": False, "error": "...", "detail": "...", "code": "..."}

# Liste paginée
{"items": [...], "total": 100, "page": 1, "page_size": 20, "pages": 5}
```

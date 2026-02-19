# Modèle de Données Unifié Multi-Stack

> Ce document définit l'architecture de données partagée entre Flutter, NextJS et FastAPI.

---

## 🎯 Problématique

Tu veux:

1. **Un template Flutter** avec modules réutilisables
2. **Un template NextJS** (frontend web)
3. **Un template FastAPI** (backend custom)
4. **Tous partagent la même structure DB**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Flutter   │    │   NextJS    │    │   FastAPI   │
│   (Mobile)  │    │   (Web)     │    │  (Backend)  │
└──────┬──────┘    └──────┬──────┘    └──────┬──────┘
       │                  │                  │
       ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────┐
│              SUPABASE / PostgreSQL                  │
│         (Structure DB unique et flexible)           │
└─────────────────────────────────────────────────────┘
```

---

## 🔄 Deux Modes d'Authentification

### Mode 1: Supabase Direct (simple)

```
Flutter App ──────► Supabase Auth
                         │
                         ▼
                    auth.users (géré par Supabase)
                         │
                         ▼
                    public.profiles (notre table)
```

### Mode 2: FastAPI Backend (custom)

```
Flutter App ──────► FastAPI ──────► Supabase/PostgreSQL
                       │
                       ▼
              JWT custom + validation métier
```

### Comment gérer les deux?

```dart
// lib/core/config/auth_config.dart

enum AuthMode {
  /// Authentification directe via Supabase Auth
  supabase,

  /// Authentification via API custom (FastAPI, etc.)
  api,
}

class AuthConfig {
  static const AuthMode mode = AuthMode.supabase; // Change selon le projet

  // Si mode == api
  static const String apiAuthEndpoint = '/api/v1/auth';
}
```

```dart
// lib/domain/repositories/i_auth_repository.dart
// L'INTERFACE reste la même quel que soit le mode!

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });
  // ...
}

// Deux implémentations:
// - SupabaseAuthRepository (pour mode supabase)
// - ApiAuthRepository (pour mode api/FastAPI)
```

---

## 📊 Analyse de ton UserEntity Actuel

### Ce qui est bien ✅

```dart
class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;
  final bool isEmailConfirmed;
  final bool isPhoneConfirmed;

  // Computed properties ✅
  String get fullName => ...
  String get displayName => ...
  bool get isVerified => ...
}
```

### Ce qui manque ❌

1. **Pas de `role`** - Nécessaire pour RBAC (admin, user, moderator)
2. **Pas de `status`** - (active, suspended, pending_verification)
3. **Pas de `metadata`** - Pour les données custom par projet
4. **Pas de `preferences`** - Settings utilisateur (theme, langue, notifs)

---

## 🏗️ Modèle de Données Unifié

### Tables Core (présentes dans tous les projets)

```sql
-- ============================================================
-- TABLE: profiles
-- Étend auth.users de Supabase, ou users custom si FastAPI
-- ============================================================

CREATE TABLE public.profiles (
  -- Identité
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Infos de base
  email TEXT UNIQUE,
  phone TEXT UNIQUE,
  first_name TEXT,
  last_name TEXT,
  display_name TEXT GENERATED ALWAYS AS (
    COALESCE(first_name || ' ' || last_name, first_name, last_name, email)
  ) STORED,

  -- Avatar
  avatar_url TEXT,

  -- Statut & Rôle
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin', 'moderator')),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'pending')),

  -- Vérification
  email_verified_at TIMESTAMPTZ,
  phone_verified_at TIMESTAMPTZ,

  -- Métadonnées flexibles (champs custom par projet)
  metadata JSONB NOT NULL DEFAULT '{}',

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_sign_in_at TIMESTAMPTZ,

  -- Soft delete
  deleted_at TIMESTAMPTZ
);

-- Index pour les requêtes fréquentes
CREATE INDEX idx_profiles_email ON public.profiles(email);
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_status ON public.profiles(status);
CREATE INDEX idx_profiles_metadata ON public.profiles USING GIN(metadata);

-- ============================================================
-- TABLE: user_preferences
-- Settings utilisateur (theme, langue, notifications)
-- ============================================================

CREATE TABLE public.user_preferences (
  user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,

  -- Apparence
  theme TEXT NOT NULL DEFAULT 'system' CHECK (theme IN ('light', 'dark', 'system')),
  language TEXT NOT NULL DEFAULT 'fr',

  -- Notifications
  push_enabled BOOLEAN NOT NULL DEFAULT true,
  email_notifications BOOLEAN NOT NULL DEFAULT true,
  notification_settings JSONB NOT NULL DEFAULT '{
    "marketing": false,
    "transactional": true,
    "updates": true
  }',

  -- Autres préférences (flexibles)
  preferences JSONB NOT NULL DEFAULT '{}',

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TABLE: sessions (si mode FastAPI/custom auth)
-- ============================================================

CREATE TABLE public.sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,

  -- Token
  refresh_token TEXT UNIQUE NOT NULL,

  -- Device info
  device_name TEXT,
  device_type TEXT CHECK (device_type IN ('ios', 'android', 'web', 'desktop')),
  ip_address INET,
  user_agent TEXT,

  -- Expiration
  expires_at TIMESTAMPTZ NOT NULL,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_used_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sessions_user_id ON public.sessions(user_id);
CREATE INDEX idx_sessions_refresh_token ON public.sessions(refresh_token);
```

### Tables Modules (activées selon les besoins)

```sql
-- ============================================================
-- MODULE: Notifications
-- ============================================================

CREATE TABLE public.push_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  device_name TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, token)
);

CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,

  -- Contenu
  type TEXT NOT NULL, -- 'info', 'success', 'warning', 'error', 'custom'
  title TEXT NOT NULL,
  body TEXT,
  image_url TEXT,

  -- Action
  action_type TEXT, -- 'navigate', 'open_url', 'custom'
  action_data JSONB DEFAULT '{}',

  -- État
  read_at TIMESTAMPTZ,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_read_at ON public.notifications(user_id, read_at);

-- ============================================================
-- MODULE: Favorites (générique)
-- ============================================================

CREATE TABLE public.favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,

  -- Item favori (polymorphique)
  item_type TEXT NOT NULL, -- 'product', 'restaurant', 'article', etc.
  item_id UUID NOT NULL,

  -- Métadonnées (cache du titre/image pour affichage rapide)
  item_data JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, item_type, item_id)
);

CREATE INDEX idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX idx_favorites_item ON public.favorites(item_type, item_id);

-- ============================================================
-- MODULE: App Config (Remote Config)
-- ============================================================

CREATE TABLE public.app_config (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  description TEXT,
  is_public BOOLEAN NOT NULL DEFAULT false, -- Accessible sans auth
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Config par défaut
INSERT INTO public.app_config (key, value, description, is_public) VALUES
  ('app_version', '{"min_version": "1.0.0", "current_version": "1.0.0", "force_update": false}', 'Version control', true),
  ('maintenance_mode', '{"enabled": false, "message": ""}', 'Maintenance mode', true),
  ('feature_flags', '{"new_onboarding": true, "dark_mode": true}', 'Feature toggles', false);
```

---

## 🎯 Entities Dart Améliorées

### UserEntity (mise à jour)

```dart
// lib/domain/entities/user_entity.dart

import 'package:equatable/equatable.dart';

/// Rôles utilisateur disponibles.
enum UserRole {
  user,
  admin,
  moderator;

  bool get isAdmin => this == UserRole.admin;
  bool get canModerate => this == UserRole.admin || this == UserRole.moderator;
}

/// Statuts de compte utilisateur.
enum UserStatus {
  active,
  suspended,
  pending;

  bool get canSignIn => this == UserStatus.active;
}

/// Entité utilisateur du domaine.
class UserEntity extends Equatable {
  // ─────────────────────────────────────────────────────────────────
  // Identité
  // ─────────────────────────────────────────────────────────────────

  final String id;
  final String? email;
  final String? phone;

  // ─────────────────────────────────────────────────────────────────
  // Profil
  // ─────────────────────────────────────────────────────────────────

  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  // ─────────────────────────────────────────────────────────────────
  // Accès & Statut
  // ─────────────────────────────────────────────────────────────────

  final UserRole role;
  final UserStatus status;

  // ─────────────────────────────────────────────────────────────────
  // Vérification
  // ─────────────────────────────────────────────────────────────────

  final bool isEmailVerified;
  final bool isPhoneVerified;

  // ─────────────────────────────────────────────────────────────────
  // Métadonnées (champs custom par projet)
  // ─────────────────────────────────────────────────────────────────

  /// Données métier flexibles.
  ///
  /// Exemples:
  /// - App resto: `{"dietary_preferences": ["vegan"], "favorite_cuisine": "italian"}`
  /// - App fitness: `{"weight": 75, "height": 180, "goal": "muscle_gain"}`
  final Map<String, dynamic> metadata;

  // ─────────────────────────────────────────────────────────────────
  // Timestamps
  // ─────────────────────────────────────────────────────────────────

  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.role = UserRole.user,
    this.status = UserStatus.active,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.metadata = const {},
    required this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  String get fullName {
    if (firstName == null && lastName == null) {
      return email ?? phone ?? '';
    }
    return [firstName, lastName].whereType<String>().join(' ').trim();
  }

  String get displayName => firstName ?? email?.split('@').first ?? phone ?? '';

  String get initials {
    if (firstName == null && lastName == null) {
      return (email ?? phone ?? '?').substring(0, 1).toUpperCase();
    }
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return '$first$last'.toUpperCase();
  }

  bool get hasAvatar => avatarUrl?.isNotEmpty == true;
  bool get isVerified => isEmailVerified || isPhoneVerified;
  bool get isProfileComplete => firstName != null && lastName != null;
  bool get canSignIn => status.canSignIn;
  bool get isAdmin => role.isAdmin;

  // ─────────────────────────────────────────────────────────────────
  // Metadata Helpers
  // ─────────────────────────────────────────────────────────────────

  /// Récupère une valeur du metadata.
  T? getMeta<T>(String key) => metadata[key] as T?;

  /// Récupère une valeur avec default.
  T getMetaOr<T>(String key, T defaultValue) => (metadata[key] as T?) ?? defaultValue;

  // ─────────────────────────────────────────────────────────────────
  // CopyWith
  // ─────────────────────────────────────────────────────────────────

  UserEntity copyWith({
    String? id,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSignInAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  @override
  List<Object?> get props => [
        id, email, phone, firstName, lastName, avatarUrl,
        role, status, isEmailVerified, isPhoneVerified, metadata,
        createdAt, updatedAt, lastSignInAt,
      ];

  // ─────────────────────────────────────────────────────────────────
  // Mock (pour tests)
  // ─────────────────────────────────────────────────────────────────

  factory UserEntity.mock({
    String? id,
    String? email,
    UserRole? role,
    UserStatus? status,
  }) {
    return UserEntity(
      id: id ?? 'mock-user-id',
      email: email ?? 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      role: role ?? UserRole.user,
      status: status ?? UserStatus.active,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
```

### UserPreferences Entity

```dart
// lib/domain/entities/user_preferences_entity.dart

import 'package:equatable/equatable.dart';

/// Préférences utilisateur.
class UserPreferencesEntity extends Equatable {
  final String userId;

  // Apparence
  final ThemeMode theme;
  final String language;

  // Notifications
  final bool pushEnabled;
  final bool emailNotifications;
  final NotificationSettings notificationSettings;

  // Custom (par projet)
  final Map<String, dynamic> preferences;

  const UserPreferencesEntity({
    required this.userId,
    this.theme = ThemeMode.system,
    this.language = 'fr',
    this.pushEnabled = true,
    this.emailNotifications = true,
    this.notificationSettings = const NotificationSettings(),
    this.preferences = const {},
  });

  // ... copyWith, props, etc.
}

enum ThemeMode { light, dark, system }

class NotificationSettings extends Equatable {
  final bool marketing;
  final bool transactional;
  final bool updates;

  const NotificationSettings({
    this.marketing = false,
    this.transactional = true,
    this.updates = true,
  });

  @override
  List<Object?> get props => [marketing, transactional, updates];
}
```

---

## 🔌 Architecture Auth Multi-Backend

### Interface Commune

```dart
// lib/domain/repositories/i_auth_repository.dart
// IDENTIQUE quel que soit le backend!

abstract class IAuthRepository {
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Stream<UserEntity?> watchAuthState();
  bool get isAuthenticated;

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, Unit>> signOut();
  // ... autres méthodes
}
```

### Implémentation Supabase

```dart
// lib/data/repositories/supabase_auth_repository.dart

class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient _supabase;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(AuthFailure.invalidCredentials());
      }

      // Récupère le profil complet
      final profile = await _getProfile(response.user!.id);
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
```

### Implémentation FastAPI

```dart
// lib/data/repositories/api_auth_repository.dart

class ApiAuthRepository implements IAuthRepository {
  final ApiService _api;
  final SecureStorage _storage;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final result = await _api.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return result.fold(
      (failure) => Left(failure),
      (data) async {
        // Stocke les tokens
        await _storage.write('access_token', data['access_token']);
        await _storage.write('refresh_token', data['refresh_token']);

        // Parse l'utilisateur
        final user = UserModel.fromJson(data['user']).toEntity();
        return Right(user);
      },
    );
  }
}
```

### Registration Dynamique

```dart
// lib/app/app.dart

@StackedApp(
  dependencies: [
    // Choix du repository selon la config
    LazySingleton(
      classType: AuthConfig.mode == AuthMode.supabase
          ? SupabaseAuthRepository
          : ApiAuthRepository,
      asType: IAuthRepository,
    ),
  ],
)
```

---

## 📦 Concepts Réutilisables Complets

### Tier 1: Core (toujours présent)

| Concept          | Flutter               | DB                    | FastAPI               |
| ---------------- | --------------------- | --------------------- | --------------------- |
| **User/Profile** | UserEntity            | profiles              | User model            |
| **Preferences**  | UserPreferencesEntity | user_preferences      | UserPreferences model |
| **Auth**         | IAuthRepository       | auth.users / sessions | /auth/\* endpoints    |
| **Storage**      | SecureStorage         | -                     | -                     |
| **API Client**   | ApiService            | -                     | -                     |

### Tier 2: Modules Communs

| Module            | Flutter            | DB                         | FastAPI            |
| ----------------- | ------------------ | -------------------------- | ------------------ |
| **Notifications** | NotificationEntity | notifications, push_tokens | /notifications/\*  |
| **Favorites**     | FavoriteEntity     | favorites                  | /favorites/\*      |
| **Settings**      | SettingsModule     | user_preferences           | /users/preferences |
| **Onboarding**    | OnboardingModule   | app_config                 | -                  |
| **Splash**        | SplashModule       | app_config                 | /config/app        |

### Tier 3: Patterns Réutilisables

| Pattern             | Description                  | Implémentation         |
| ------------------- | ---------------------------- | ---------------------- |
| **List + Detail**   | Liste avec navigation détail | GenericListView<T>     |
| **Search + Filter** | Recherche avec filtres       | SearchableList<T>      |
| **Pagination**      | Infinite scroll / pagination | PaginatedList<T>       |
| **CRUD**            | Create/Read/Update/Delete    | ICrudRepository<T>     |
| **Soft Delete**     | Suppression réversible       | deleted_at field       |
| **Audit Trail**     | Qui a fait quoi quand        | created_by, updated_by |

---

## 🗂️ Structure Finale des Templates

### Flutter Template

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart
│   │   └── auth_config.dart      # ← Mode supabase ou api
│   └── ...
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart      # ← Amélioré avec role, status, metadata
│   │   ├── user_preferences_entity.dart
│   │   └── ...
│   └── repositories/
│       ├── i_auth_repository.dart
│       └── i_user_repository.dart
├── data/
│   ├── repositories/
│   │   ├── supabase_auth_repository.dart
│   │   └── api_auth_repository.dart  # ← Pour FastAPI
│   └── ...
├── modules/
│   ├── auth/
│   ├── profile/
│   ├── settings/
│   ├── onboarding/
│   └── notifications/
└── ...
```

### FastAPI Template

```
app/
├── core/
│   ├── config.py
│   ├── security.py
│   └── database.py
├── models/
│   ├── user.py           # ← Même structure que Flutter
│   ├── user_preferences.py
│   └── ...
├── schemas/
│   ├── user.py           # ← Pydantic (équivalent UserModel)
│   └── ...
├── api/
│   ├── auth/
│   ├── users/
│   └── ...
└── ...
```

### NextJS Template

```
src/
├── lib/
│   ├── supabase/
│   └── api/
├── types/
│   ├── user.ts           # ← Même structure
│   └── ...
├── hooks/
│   ├── useAuth.ts
│   └── useUser.ts
└── ...
```

### Supabase Migrations (partagées)

```
supabase/
├── migrations/
│   ├── 00001_create_profiles.sql
│   ├── 00002_create_user_preferences.sql
│   ├── 00003_create_notifications.sql
│   └── ...
└── seed.sql
```

---

## ✅ Réponses à tes Questions

### 1. "Quels autres concepts réutilisables?"

- **Auth** (login, register, forgot, OTP, social, biometric)
- **Profile** (view, edit, avatar, delete account)
- **Preferences/Settings** (theme, langue, notifications)
- **Notifications** (push, in-app, historique)
- **Onboarding** (slides, skip, remember)
- **Splash** (version check, maintenance mode)
- **Favorites** (polymorphique, any item type)
- **Search** (historique, suggestions)
- **Pagination** (infinite scroll, load more)
- **CRUD générique** (interface réutilisable)
- **Offline** (cache, sync)
- **Analytics** (events, screens)

### 2. "Comment généraliser Supabase vs FastAPI?"

**Interface commune** (`IAuthRepository`) avec **deux implémentations**:

- `SupabaseAuthRepository` → Supabase direct
- `ApiAuthRepository` → FastAPI/custom backend

Switch via `AuthConfig.mode` au moment de la compilation.

### 3. "FastAPI partage la DB?"

**OUI.** Le schéma SQL est le même:

- Flutter lit `profiles` via Supabase SDK ou API
- FastAPI lit `profiles` via SQLAlchemy/asyncpg
- NextJS lit `profiles` via Supabase JS SDK

**Le schéma est la source de vérité.**

### 4. "UserEntity cohérent?"

**Presque.** Il manque:

- `role` (UserRole enum)
- `status` (UserStatus enum)
- `metadata` (Map<String, dynamic>)

J'ai proposé la version améliorée ci-dessus.

### 5. "Modélisation de base réutilisable?"

Le **schéma SQL** définit la structure. Chaque stack l'implémente:

| SQL                | Flutter                 | FastAPI           | NextJS                |
| ------------------ | ----------------------- | ----------------- | --------------------- |
| `profiles`         | `UserEntity`            | `User` model      | `User` type           |
| `user_preferences` | `UserPreferencesEntity` | `UserPreferences` | `UserPreferences`     |
| `JSONB metadata`   | `Map<String, dynamic>`  | `dict`            | `Record<string, any>` |

Le **JSONB** absorbe toutes les différences métier.

---

## 🚀 Prochaines Étapes

1. **Mettre à jour `UserEntity`** avec role, status, metadata
2. **Créer `UserPreferencesEntity`**
3. **Créer le fichier SQL de migrations** (à inclure dans le template)
4. **Implémenter les deux repositories** (Supabase + API)
5. **Créer les modules** (auth, profile, settings, etc.)

**On commence par quoi?**

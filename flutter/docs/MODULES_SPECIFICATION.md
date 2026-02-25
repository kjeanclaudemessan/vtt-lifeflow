# VTT Flutter Template - Spécification des Modules

> **Document de référence** pour l'implémentation des modules métier réutilisables.
>
> Ce document guide le développement et sert de contrat pour chaque module.

---

## Table des Matières

1. [Vision & Objectifs](#vision--objectifs)
2. [Architecture des Modules](#architecture-des-modules)
3. [Base de Données Supabase](#base-de-données-supabase)
4. [Module Auth](#module-auth)
5. [Module Onboarding](#module-onboarding)
6. [Module Profile](#module-profile)
7. [Module Settings](#module-settings)
8. [Module Splash](#module-splash)
9. [Module Notifications](#module-notifications)
10. [Workflow d'Utilisation](#workflow-dutilisation)
11. [Checklist d'Implémentation](#checklist-dimplémentation)

---

## Vision & Objectifs

### Objectif Principal

Créer un template Flutter permettant de **livrer une app en 1 demi-journée** en ayant:

- Des modules métier **pré-construits et testés**
- Une configuration **dans le code** (pas de fichiers externes)
- Des variantes UI **prêtes à l'emploi**
- Une structure DB **minimaliste** avec Supabase

### Principes Directeurs

| Principe            | Application                                          |
| ------------------- | ---------------------------------------------------- |
| **Simplicité**      | Pas de CLI, pas de génération, juste du code Flutter |
| **Autonomie**       | Chaque module fonctionne indépendamment              |
| **Configurabilité** | Options via classes Dart avec defaults sensés        |
| **Extensibilité**   | JSONB pour les champs métier spécifiques             |
| **Pas de magie**    | Le dev peut lire et comprendre tout le code          |

### Ce que ce template N'EST PAS

- ❌ Un framework avec courbe d'apprentissage
- ❌ Un système de plugins dynamiques
- ❌ Une solution no-code/low-code
- ❌ Un générateur de code

---

## Architecture des Modules

### Structure des Dossiers

```
lib/
├── core/                          # Fondations (stable)
│   ├── config/
│   │   ├── app_config.dart        # Supabase URL, env, etc.
│   │   └── app_features.dart      # Flags d'activation modules
│   ├── errors/
│   ├── extensions/
│   └── utils/
│
├── design_system/                 # UI Kit Porsche
│   ├── theme/
│   ├── colors/
│   ├── typography/
│   └── tokens/
│
├── services/                      # Services techniques
│   ├── supabase/
│   │   └── supabase_service.dart
│   ├── auth/
│   │   └── supabase_auth_service.dart
│   ├── storage/
│   └── notification/
│
├── modules/                       # ⭐ MODULES MÉTIER
│   ├── auth/
│   ├── onboarding/
│   ├── profile/
│   ├── settings/
│   ├── splash/
│   └── notifications/
│
├── features/                      # Logique métier SPÉCIFIQUE
│   └── (vide - ajouté par le dev)
│
├── domain/
│   ├── entities/
│   └── repositories/
│
├── data/
│   ├── models/
│   └── repositories/
│
└── app/
    ├── app.dart
    ├── app.locator.dart
    └── app.router.dart
```

### Structure d'un Module

Chaque module suit cette structure standardisée:

```
modules/
└── {module_name}/
    ├── config/
    │   └── {module}_config.dart      # Configuration du module
    ├── views/
    │   ├── {feature}_view.dart       # Vues principales
    │   └── widgets/                  # Widgets spécifiques à la vue
    ├── viewmodels/
    │   └── {feature}_viewmodel.dart  # ViewModels Stacked
    ├── widgets/
    │   └── {widget}_widget.dart      # Widgets réutilisables du module
    └── {module}_module.dart          # Point d'entrée (exports)
```

### Pattern de Configuration

```dart
// Chaque module a une classe de config avec des defaults
class AuthConfig {
  // Options avec valeurs par défaut
  final bool enableGoogle;
  final bool enableApple;
  final bool enablePhone;
  final bool enableBiometric;
  final AuthStyle style;

  const AuthConfig({
    this.enableGoogle = true,
    this.enableApple = true,
    this.enablePhone = false,
    this.enableBiometric = true,
    this.style = AuthStyle.modern,
  });

  // Config par défaut accessible globalement
  static const defaultConfig = AuthConfig();
}
```

### Pattern de Variantes UI

```dart
// Enum pour les styles disponibles
enum AuthStyle { modern, classic, minimal }

// Le widget principal utilise un switch
class LoginView extends StackedView<LoginViewModel> {
  final AuthConfig config;

  @override
  Widget builder(context, viewModel, child) {
    return switch (config.style) {
      AuthStyle.modern => _buildModern(context, viewModel),
      AuthStyle.classic => _buildClassic(context, viewModel),
      AuthStyle.minimal => _buildMinimal(context, viewModel),
    };
  }
}
```

---

## Base de Données Supabase

### Philosophie

- **Minimaliste**: Supabase gère l'auth, on étend avec `profiles`
- **Flexible**: Champs `metadata` et `preferences` JSONB pour le spécifique
- **Sécurisé**: RLS activé sur toutes les tables
- **Évolutif**: Colonnes optionnelles prévues (`role`, `organization_id`) mais non utilisées par défaut

### Schéma Core (Toujours Présent)

```sql
-- ════════════════════════════════════════════════════════════════
-- TABLE: profiles
-- Extension de auth.users pour données publiques
-- ════════════════════════════════════════════════════════════════
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Profile
  first_name      TEXT,
  last_name       TEXT,
  display_name    TEXT,
  avatar_url      TEXT,

  -- Settings
  locale          TEXT DEFAULT 'fr',
  timezone        TEXT DEFAULT 'Europe/Paris',

  -- Role (always present, used or not)
  role            TEXT DEFAULT 'user',

  -- Multi-tenant (optional, NULL if not used)
  organization_id UUID,

  -- Flexible JSONB fields
  metadata        JSONB DEFAULT '{}',   -- Business-specific data
  preferences     JSONB DEFAULT '{}',   -- UI/UX preferences

  -- Timestamps
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  deleted_at      TIMESTAMPTZ             -- Soft delete
);

-- ════════════════════════════════════════════════════════════════
-- INDEXES
-- ════════════════════════════════════════════════════════════════
CREATE INDEX idx_profiles_role ON public.profiles(role);
CREATE INDEX idx_profiles_org ON public.profiles(organization_id) WHERE organization_id IS NOT NULL;
CREATE INDEX idx_profiles_metadata ON public.profiles USING GIN (metadata);
CREATE INDEX idx_profiles_deleted ON public.profiles(deleted_at) WHERE deleted_at IS NULL;

-- ════════════════════════════════════════════════════════════════
-- FUNCTIONS
-- ════════════════════════════════════════════════════════════════

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Auto-create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, first_name, last_name, display_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'first_name',
    NEW.raw_user_meta_data->>'last_name',
    COALESCE(
      NEW.raw_user_meta_data->>'display_name',
      NEW.raw_user_meta_data->>'first_name',
      split_part(NEW.email, '@', 1)
    ),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ════════════════════════════════════════════════════════════════
-- TRIGGERS
-- ════════════════════════════════════════════════════════════════
CREATE TRIGGER on_profiles_updated
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ════════════════════════════════════════════════════════════════
-- RLS POLICIES
-- ════════════════════════════════════════════════════════════════
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Select: own profile only (exclude soft-deleted)
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id AND deleted_at IS NULL);

-- Update: own profile only
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id AND deleted_at IS NULL);

-- Insert: handled by trigger (no manual INSERT policy)
```

### Metadata & Preferences Structure

```jsonc
// metadata: Business-specific data (varies by project)
{
  "onboarding_completed": true,
  "onboarding_step": 3,
  "referral_code": "FRIEND123",
  "utm_source": "google",
  "company": "Acme Inc",
  "job_title": "Developer"
}

// preferences: UI/UX settings (stable structure)
{
  "theme": "dark",                    // 'light', 'dark', 'system'
  "notifications": {
    "email": true,
    "push": true,
    "sms": false,
    "marketing": false
  },
  "sidebar_collapsed": false,
  "items_per_page": 20
}
```

### Schéma Optionnel: Notifications

```sql
-- ============================================
-- TABLE: notifications (si module activé)
-- ============================================
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  title TEXT NOT NULL,
  body TEXT,
  data JSONB DEFAULT '{}',

  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own notifications"
  ON public.notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications"
  ON public.notifications FOR UPDATE
  USING (auth.uid() = user_id);
```

### Schéma Optionnel: Push Tokens

```sql
-- ============================================
-- TABLE: push_tokens (pour notifications push)
-- ============================================
CREATE TABLE public.push_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  token TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('ios', 'android', 'web')),

  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id, token)
);

ALTER TABLE public.push_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own tokens"
  ON public.push_tokens FOR ALL
  USING (auth.uid() = user_id);
```

---

## Module Auth

### Responsabilités

- Connexion (email/password, social, phone)
- Inscription avec validation email
- Réinitialisation mot de passe
- Vérification OTP
- Authentification biométrique
- Gestion de session

### Configuration

```dart
// lib/modules/auth/config/auth_config.dart

/// Configuration du module Auth
class AuthConfig {
  /// Active la connexion Google
  final bool enableGoogle;

  /// Active la connexion Apple (iOS/macOS)
  final bool enableApple;

  /// Active la connexion par téléphone (OTP)
  final bool enablePhone;

  /// Active l'authentification biométrique
  final bool enableBiometric;

  /// Requiert la vérification email avant accès
  final bool requireEmailVerification;

  /// Style visuel des écrans auth
  final AuthStyle style;

  /// URL de redirection après vérification email
  final String? emailRedirectUrl;

  const AuthConfig({
    this.enableGoogle = true,
    this.enableApple = true,
    this.enablePhone = false,
    this.enableBiometric = true,
    this.requireEmailVerification = true,
    this.style = AuthStyle.modern,
    this.emailRedirectUrl,
  });
}

/// Styles visuels disponibles
enum AuthStyle {
  /// Design moderne avec gradient et animations
  modern,

  /// Design classique centré
  classic,

  /// Design épuré minimal
  minimal,
}
```

### Vues

| Vue                     | Route                   | Description              |
| ----------------------- | ----------------------- | ------------------------ |
| `LoginView`             | `/auth/login`           | Connexion email + social |
| `RegisterView`          | `/auth/register`        | Inscription              |
| `ForgotPasswordView`    | `/auth/forgot-password` | Demande reset            |
| `ResetPasswordView`     | `/auth/reset-password`  | Nouveau mot de passe     |
| `OtpVerificationView`   | `/auth/otp`             | Vérification code        |
| `EmailVerificationView` | `/auth/verify-email`    | Attente vérification     |

### Widgets Réutilisables

```dart
// Boutons sociaux configurables
SocialLoginButtons(
  showGoogle: true,
  showApple: true,
  onGoogleTap: () => viewModel.loginWithGoogle(),
  onAppleTap: () => viewModel.loginWithApple(),
)

// En-tête auth avec logo et titre
AuthHeader(
  title: 'Bienvenue',
  subtitle: 'Connectez-vous pour continuer',
)

// Bouton biométrique
BiometricButton(
  onTap: () => viewModel.loginWithBiometric(),
  available: viewModel.biometricAvailable,
)

// Lien terms & conditions
TermsCheckbox(
  value: viewModel.acceptedTerms,
  onChanged: viewModel.setAcceptedTerms,
  termsUrl: 'https://...',
  privacyUrl: 'https://...',
)
```

### Flows

```
┌─────────────────────────────────────────────────────────────┐
│                     FLOW LOGIN                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  LoginView ──────┬──► Email/Password ──► Success ──► Home   │
│                  │                                          │
│                  ├──► Google ──► Success ──► Home           │
│                  │                                          │
│                  ├──► Apple ──► Success ──► Home            │
│                  │                                          │
│                  ├──► Biometric ──► Success ──► Home        │
│                  │                                          │
│                  ├──► Forgot Password ──► ForgotView        │
│                  │                                          │
│                  └──► Register ──► RegisterView             │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   FLOW REGISTER                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  RegisterView ──► Validation ──► Create Account             │
│                                      │                      │
│                    ┌─────────────────┴─────────────────┐    │
│                    │                                   │    │
│                    ▼                                   ▼    │
│          [requireEmailVerification]           [!requireEmail]
│                    │                                   │    │
│                    ▼                                   │    │
│          EmailVerificationView                         │    │
│                    │                                   │    │
│                    ▼                                   ▼    │
│                  Home ◄────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Module Onboarding

### Responsabilités

- Afficher des slides d'introduction
- Gérer la navigation entre slides
- Mémoriser si déjà vu (ne plus afficher)
- Permettre de skip

### Configuration

```dart
// lib/modules/onboarding/config/onboarding_config.dart

/// Configuration du module Onboarding
class OnboardingConfig {
  /// Liste des slides à afficher
  final List<OnboardingSlide> slides;

  /// Style visuel
  final OnboardingStyle style;

  /// Permet de passer l'onboarding
  final bool canSkip;

  /// Afficher l'indicateur de progression
  final bool showIndicator;

  /// Style de l'indicateur
  final IndicatorStyle indicatorStyle;

  /// Callback à la fin
  final VoidCallback? onComplete;

  const OnboardingConfig({
    required this.slides,
    this.style = OnboardingStyle.cards,
    this.canSkip = true,
    this.showIndicator = true,
    this.indicatorStyle = IndicatorStyle.dots,
    this.onComplete,
  });
}

/// Données d'un slide
class OnboardingSlide {
  final String image;       // Asset path ou URL
  final String title;       // Texte ou clé i18n
  final String description;
  final Color? backgroundColor;

  const OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
    this.backgroundColor,
  });
}

/// Styles visuels
enum OnboardingStyle {
  /// Cards qui swipent horizontalement
  cards,

  /// Image plein écran avec texte en overlay
  fullscreen,

  /// Design minimal avec illustration centrée
  minimal,
}

/// Styles d'indicateur
enum IndicatorStyle {
  dots,
  line,
  numbers,
}
```

### Vues

| Vue              | Route         | Description                |
| ---------------- | ------------- | -------------------------- |
| `OnboardingView` | `/onboarding` | Vue principale avec slides |

### Widgets Réutilisables

```dart
// Slide individuel
OnboardingSlideWidget(
  slide: slide,
  style: OnboardingStyle.cards,
)

// Indicateur de progression
OnboardingIndicator(
  currentIndex: 2,
  totalCount: 4,
  style: IndicatorStyle.dots,
)

// Boutons navigation
OnboardingNavigation(
  isLastSlide: false,
  onNext: () => viewModel.next(),
  onSkip: () => viewModel.skip(),
  canSkip: true,
)
```

### Persistence

```dart
// Stocké en local avec SharedPreferences
class OnboardingStorage {
  static const _key = 'onboarding_completed';

  Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
```

---

## Module Profile

### Responsabilités

- Afficher le profil utilisateur
- Éditer les informations
- Gérer l'avatar (upload, crop)
- Champs extensibles via config

### Configuration

```dart
// lib/modules/profile/config/profile_config.dart

/// Configuration du module Profile
class ProfileConfig {
  /// Champs à afficher/éditer
  final List<ProfileField> fields;

  /// Activer l'avatar
  final bool enableAvatar;

  /// Taille max avatar en MB
  final double maxAvatarSizeMb;

  /// Permettre suppression compte
  final bool enableDeleteAccount;

  /// Permettre export données (RGPD)
  final bool enableDataExport;

  /// Style visuel
  final ProfileStyle style;

  const ProfileConfig({
    this.fields = defaultFields,
    this.enableAvatar = true,
    this.maxAvatarSizeMb = 5.0,
    this.enableDeleteAccount = true,
    this.enableDataExport = false,
    this.style = ProfileStyle.card,
  });

  static const defaultFields = [
    ProfileField.displayName(required: true),
    ProfileField.email(editable: false),
    ProfileField.phone(required: false),
  ];
}

/// Définition d'un champ de profil
class ProfileField {
  final String key;
  final String labelKey;  // Clé i18n
  final FieldType type;
  final bool required;
  final bool editable;
  final String? validation;
  final List<String>? options;  // Pour select/multiSelect

  const ProfileField({
    required this.key,
    required this.labelKey,
    this.type = FieldType.text,
    this.required = false,
    this.editable = true,
    this.validation,
    this.options,
  });

  // Factories pour champs communs
  const ProfileField.displayName({bool required = true})
      : this(
          key: 'display_name',
          labelKey: 'profile.field.displayName',
          required: required,
        );

  const ProfileField.email({bool editable = false})
      : this(
          key: 'email',
          labelKey: 'profile.field.email',
          type: FieldType.email,
          editable: editable,
        );

  const ProfileField.phone({bool required = false})
      : this(
          key: 'phone',
          labelKey: 'profile.field.phone',
          type: FieldType.phone,
          required: required,
          validation: 'phone',
        );

  // Factory pour champs custom (stockés dans metadata JSONB)
  const ProfileField.custom({
    required String key,
    required String label,
    FieldType type = FieldType.text,
    bool required = false,
    List<String>? options,
  }) : this(
         key: 'metadata.$key',
         labelKey: label,  // Texte direct, pas clé i18n
         type: type,
         required: required,
         options: options,
       );
}

enum FieldType {
  text,
  email,
  phone,
  number,
  date,
  select,
  multiSelect,
  textarea,
}

enum ProfileStyle {
  card,
  list,
  hero,
}
```

### Vues

| Vue                 | Route           | Description      |
| ------------------- | --------------- | ---------------- |
| `ProfileView`       | `/profile`      | Affichage profil |
| `EditProfileView`   | `/profile/edit` | Édition profil   |
| `AvatarPickerSheet` | Bottom sheet    | Sélection avatar |

### Widgets Réutilisables

```dart
// Avatar avec gestion upload
AvatarWidget(
  url: user.avatarUrl,
  size: 120,
  editable: true,
  onTap: () => viewModel.pickAvatar(),
)

// Champ de profil générique
ProfileFieldWidget(
  field: ProfileField.phone(),
  value: viewModel.phone,
  onChanged: viewModel.setPhone,
  error: viewModel.phoneError,
)

// Section de profil
ProfileSection(
  title: 'Informations personnelles',
  children: [...],
)
```

---

## Module Settings

### Responsabilités

- Changer le thème (light/dark/system)
- Changer la langue
- Liens légaux (CGU, confidentialité)
- Actions compte (déconnexion, suppression)
- Version de l'app
- Autres options configurables

### Configuration

```dart
// lib/modules/settings/config/settings_config.dart

/// Configuration du module Settings
class SettingsConfig {
  /// Sections à afficher
  final List<SettingsSection> sections;

  /// Style visuel
  final SettingsStyle style;

  const SettingsConfig({
    this.sections = defaultSections,
    this.style = SettingsStyle.ios,
  });

  static const defaultSections = [
    SettingsSection.appearance(),
    SettingsSection.notifications(),
    SettingsSection.legal(),
    SettingsSection.account(),
    SettingsSection.about(),
  ];
}

/// Section de settings
class SettingsSection {
  final String id;
  final String titleKey;
  final List<SettingsItem> items;

  const SettingsSection({
    required this.id,
    required this.titleKey,
    required this.items,
  });

  const SettingsSection.appearance()
      : this(
          id: 'appearance',
          titleKey: 'settings.section.appearance',
          items: const [
            SettingsItem.themeSelector(),
            SettingsItem.languageSelector(),
          ],
        );

  const SettingsSection.notifications()
      : this(
          id: 'notifications',
          titleKey: 'settings.section.notifications',
          items: const [
            SettingsItem.notificationToggle(),
          ],
        );

  const SettingsSection.legal()
      : this(
          id: 'legal',
          titleKey: 'settings.section.legal',
          items: const [
            SettingsItem.termsOfService(),
            SettingsItem.privacyPolicy(),
          ],
        );

  const SettingsSection.account()
      : this(
          id: 'account',
          titleKey: 'settings.section.account',
          items: const [
            SettingsItem.logout(),
            SettingsItem.deleteAccount(),
          ],
        );

  const SettingsSection.about()
      : this(
          id: 'about',
          titleKey: 'settings.section.about',
          items: const [
            SettingsItem.appVersion(),
            SettingsItem.rateApp(),
          ],
        );
}

/// Item de settings
class SettingsItem {
  final String id;
  final String titleKey;
  final SettingsItemType type;
  final String? url;  // Pour links
  final IconData? icon;
  final bool destructive;  // Rouge pour actions dangereuses

  const SettingsItem({
    required this.id,
    required this.titleKey,
    required this.type,
    this.url,
    this.icon,
    this.destructive = false,
  });

  // Factories pour items communs
  const SettingsItem.themeSelector()
      : this(id: 'theme', titleKey: 'settings.theme', type: SettingsItemType.themeSelector);

  const SettingsItem.languageSelector()
      : this(id: 'language', titleKey: 'settings.language', type: SettingsItemType.languageSelector);

  const SettingsItem.notificationToggle()
      : this(id: 'notifications', titleKey: 'settings.notifications', type: SettingsItemType.toggle);

  const SettingsItem.termsOfService()
      : this(id: 'terms', titleKey: 'settings.terms', type: SettingsItemType.link, url: 'https://...');

  const SettingsItem.privacyPolicy()
      : this(id: 'privacy', titleKey: 'settings.privacy', type: SettingsItemType.link, url: 'https://...');

  const SettingsItem.logout()
      : this(id: 'logout', titleKey: 'settings.logout', type: SettingsItemType.action);

  const SettingsItem.deleteAccount()
      : this(id: 'delete', titleKey: 'settings.deleteAccount', type: SettingsItemType.action, destructive: true);

  const SettingsItem.appVersion()
      : this(id: 'version', titleKey: 'settings.version', type: SettingsItemType.info);

  const SettingsItem.rateApp()
      : this(id: 'rate', titleKey: 'settings.rateApp', type: SettingsItemType.action);
}

enum SettingsItemType {
  themeSelector,
  languageSelector,
  toggle,
  link,
  action,
  info,
  navigation,
}

enum SettingsStyle {
  ios,
  material,
  grouped,
}
```

### Vues

| Vue                   | Route        | Description        |
| --------------------- | ------------ | ------------------ |
| `SettingsView`        | `/settings`  | Liste des settings |
| `ThemePickerSheet`    | Bottom sheet | Sélecteur thème    |
| `LanguagePickerSheet` | Bottom sheet | Sélecteur langue   |

### Widgets Réutilisables

```dart
// Section groupée
SettingsSectionWidget(
  section: SettingsSection.appearance(),
)

// Tile générique
SettingsTile(
  item: SettingsItem.themeSelector(),
  onTap: () => viewModel.openThemePicker(),
  trailing: Text('Dark'),
)

// Sélecteur de thème
ThemeSelectorWidget(
  currentTheme: ThemeMode.dark,
  onChanged: (theme) => viewModel.setTheme(theme),
)

// Sélecteur de langue
LanguageSelectorWidget(
  currentLocale: Locale('fr'),
  supportedLocales: [Locale('fr'), Locale('en')],
  onChanged: (locale) => viewModel.setLocale(locale),
)
```

---

## Module Splash

### Responsabilités

- Animation de logo au lancement
- Vérification de version (force update)
- Redirection selon état auth/onboarding
- Préchargement des données essentielles

### Configuration

```dart
// lib/modules/splash/config/splash_config.dart

/// Configuration du module Splash
class SplashConfig {
  /// Durée minimum d'affichage (ms)
  final int minDurationMs;

  /// Type d'animation du logo
  final SplashAnimation animation;

  /// Vérifier la version de l'app
  final bool checkVersion;

  /// URL de l'API pour version check
  final String? versionCheckUrl;

  /// Précharger les données utilisateur
  final bool preloadUserData;

  const SplashConfig({
    this.minDurationMs = 2000,
    this.animation = SplashAnimation.fadeScale,
    this.checkVersion = false,
    this.versionCheckUrl,
    this.preloadUserData = true,
  });
}

enum SplashAnimation {
  /// Fade in + scale
  fadeScale,

  /// Bounce effect
  bounce,

  /// Slide from bottom
  slideUp,

  /// Aucune animation
  none,
}
```

### Flow de Décision

```dart
// lib/modules/splash/viewmodels/splash_viewmodel.dart

Future<void> initialize() async {
  await Future.delayed(Duration(milliseconds: config.minDurationMs));

  // 1. Version check
  if (config.checkVersion) {
    final needsUpdate = await _checkVersion();
    if (needsUpdate) {
      _navigationService.navigateTo(Routes.forceUpdate);
      return;
    }
  }

  // 2. Check auth state
  final isLoggedIn = await _authService.isLoggedIn();

  if (!isLoggedIn) {
    // 3. Check onboarding
    final onboardingDone = await _onboardingStorage.isCompleted();
    if (!onboardingDone && AppFeatures.enableOnboarding) {
      _navigationService.replaceWith(Routes.onboarding);
    } else {
      _navigationService.replaceWith(Routes.login);
    }
  } else {
    // 4. Preload user data
    if (config.preloadUserData) {
      await _profileRepository.fetchCurrentUser();
    }
    _navigationService.replaceWith(Routes.home);
  }
}
```

### Vues

| Vue               | Route           | Description         |
| ----------------- | --------------- | ------------------- |
| `SplashView`      | `/`             | Écran de démarrage  |
| `ForceUpdateView` | `/force-update` | Mise à jour requise |

---

## Module Notifications

### Responsabilités

- Demander la permission
- Enregistrer le token push
- Afficher la liste des notifications
- Marquer comme lu
- Badge count

### Configuration

```dart
// lib/modules/notifications/config/notifications_config.dart

/// Configuration du module Notifications
class NotificationsConfig {
  /// Activer les notifications push
  final bool enablePush;

  /// Activer les notifications in-app
  final bool enableInApp;

  /// Afficher le badge count
  final bool showBadge;

  /// Jouer un son
  final bool playSound;

  /// Catégories de notifications
  final List<NotificationChannel> channels;

  const NotificationsConfig({
    this.enablePush = true,
    this.enableInApp = true,
    this.showBadge = true,
    this.playSound = true,
    this.channels = const [],
  });
}

/// Canal de notification (pour préférences utilisateur)
class NotificationChannel {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final bool enabledByDefault;

  const NotificationChannel({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    this.enabledByDefault = true,
  });
}
```

### Vues

| Vue                      | Route            | Description             |
| ------------------------ | ---------------- | ----------------------- |
| `NotificationsView`      | `/notifications` | Liste des notifications |
| `NotificationPrefsSheet` | Bottom sheet     | Préférences par canal   |

### Widgets Réutilisables

```dart
// Badge de notification (pour AppBar)
NotificationBadge(
  count: viewModel.unreadCount,
  onTap: () => navigator.navigateTo(Routes.notifications),
)

// Card de notification
NotificationCard(
  notification: notification,
  onTap: () => viewModel.handleNotificationTap(notification),
  onDismiss: () => viewModel.markAsRead(notification.id),
)

// Liste de notifications
NotificationsList(
  notifications: viewModel.notifications,
  onRefresh: viewModel.refresh,
  emptyState: EmptyNotificationsWidget(),
)
```

---

## Workflow d'Utilisation

### Nouveau Projet: Step by Step

```
1. CLONE & SETUP (5 min)
   ├── git clone lifeflow mon_app
   ├── cd mon_app
   ├── Renommer bundle ID dans pubspec.yaml
   └── flutter pub get

2. CONFIGURER SUPABASE (10 min)
   ├── Créer projet sur supabase.com
   ├── Copier URL + anon key
   ├── Mettre dans .env
   ├── Appliquer le SQL de profiles (copy-paste)
   └── Configurer auth providers (Google, Apple)

3. PERSONNALISER DESIGN (15 min)
   ├── Changer couleurs dans design_system/colors/
   ├── Changer fonts dans design_system/typography/
   ├── Remplacer logo dans assets/
   └── Modifier splash icon

4. CONFIGURER MODULES (10 min)
   ├── Éditer app_features.dart (activer/désactiver)
   ├── Configurer AuthConfig selon besoins
   ├── Préparer slides onboarding
   └── Configurer ProfileConfig avec champs custom

5. AJOUTER LOGIQUE MÉTIER (variable)
   ├── Créer features/ pour le spécifique
   ├── Ajouter tables Supabase
   └── Connecter le tout

6. BUILD & DEPLOY
   ├── flutter build apk / ipa
   └── Deploy sur stores
```

### Exemple Concret: App de Livraison

```dart
// 1. app_features.dart
abstract class AppFeatures {
  static const bool enableOnboarding = true;
  static const bool enableBiometricAuth = true;
  static const bool enableNotifications = true;
  static const bool enablePhoneAuth = true;  // Livraison = phone important
}

// 2. Onboarding slides
final onboardingConfig = OnboardingConfig(
  style: OnboardingStyle.fullscreen,
  slides: [
    OnboardingSlide(
      image: 'assets/onboarding/browse.svg',
      title: 'Parcourez les restaurants',
      description: 'Des centaines de restaurants près de chez vous',
    ),
    OnboardingSlide(
      image: 'assets/onboarding/order.svg',
      title: 'Commandez facilement',
      description: 'En quelques clics, votre repas est en route',
    ),
    OnboardingSlide(
      image: 'assets/onboarding/track.svg',
      title: 'Suivez en temps réel',
      description: 'Suivez votre livreur en direct',
    ),
  ],
);

// 3. Profile avec champs métier
final profileConfig = ProfileConfig(
  fields: [
    ProfileField.displayName(required: true),
    ProfileField.phone(required: true),  // Obligatoire pour livraison
    ProfileField.custom(
      key: 'default_address',
      label: 'Adresse par défaut',
      type: FieldType.textarea,
    ),
    ProfileField.custom(
      key: 'dietary',
      label: 'Préférences alimentaires',
      type: FieldType.multiSelect,
      options: ['Végétarien', 'Vegan', 'Halal', 'Casher', 'Sans gluten'],
    ),
  ],
);

// 4. Tables Supabase additionnelles
/*
CREATE TABLE restaurants (...);
CREATE TABLE orders (...);
CREATE TABLE addresses (...);
*/

// 5. Features métier
lib/features/
├── restaurants/
│   ├── views/restaurant_list_view.dart
│   ├── views/restaurant_detail_view.dart
│   └── viewmodels/...
├── orders/
│   ├── views/cart_view.dart
│   ├── views/order_tracking_view.dart
│   └── viewmodels/...
└── addresses/
    └── views/address_picker_view.dart
```

---

## Checklist d'Implémentation

### Module Auth ☐

- [ ] `lib/modules/auth/config/auth_config.dart`
- [ ] `lib/modules/auth/views/login_view.dart`
- [ ] `lib/modules/auth/views/register_view.dart`
- [ ] `lib/modules/auth/views/forgot_password_view.dart`
- [ ] `lib/modules/auth/views/otp_verification_view.dart`
- [ ] `lib/modules/auth/viewmodels/login_viewmodel.dart`
- [ ] `lib/modules/auth/viewmodels/register_viewmodel.dart`
- [ ] `lib/modules/auth/viewmodels/forgot_password_viewmodel.dart`
- [ ] `lib/modules/auth/viewmodels/otp_viewmodel.dart`
- [ ] `lib/modules/auth/widgets/social_login_buttons.dart`
- [ ] `lib/modules/auth/widgets/auth_header.dart`
- [ ] `lib/modules/auth/widgets/biometric_button.dart`
- [ ] `lib/modules/auth/widgets/terms_checkbox.dart`
- [ ] Tests unitaires ViewModels
- [ ] Tests widget

### Module Onboarding ☐

- [ ] `lib/modules/onboarding/config/onboarding_config.dart`
- [ ] `lib/modules/onboarding/views/onboarding_view.dart`
- [ ] `lib/modules/onboarding/viewmodels/onboarding_viewmodel.dart`
- [ ] `lib/modules/onboarding/widgets/onboarding_slide.dart`
- [ ] `lib/modules/onboarding/widgets/onboarding_indicator.dart`
- [ ] `lib/modules/onboarding/widgets/onboarding_navigation.dart`
- [ ] `lib/modules/onboarding/services/onboarding_storage.dart`
- [ ] Variante Cards
- [ ] Variante Fullscreen
- [ ] Variante Minimal
- [ ] Tests

### Module Profile ☐

- [ ] `lib/modules/profile/config/profile_config.dart`
- [ ] `lib/modules/profile/views/profile_view.dart`
- [ ] `lib/modules/profile/views/edit_profile_view.dart`
- [ ] `lib/modules/profile/viewmodels/profile_viewmodel.dart`
- [ ] `lib/modules/profile/viewmodels/edit_profile_viewmodel.dart`
- [ ] `lib/modules/profile/widgets/avatar_widget.dart`
- [ ] `lib/modules/profile/widgets/profile_field_widget.dart`
- [ ] `lib/modules/profile/widgets/profile_section.dart`
- [ ] `lib/modules/profile/bottom_sheets/avatar_picker_sheet.dart`
- [ ] Tests

### Module Settings ☐

- [ ] `lib/modules/settings/config/settings_config.dart`
- [ ] `lib/modules/settings/views/settings_view.dart`
- [ ] `lib/modules/settings/viewmodels/settings_viewmodel.dart`
- [ ] `lib/modules/settings/widgets/settings_section_widget.dart`
- [ ] `lib/modules/settings/widgets/settings_tile.dart`
- [ ] `lib/modules/settings/widgets/theme_selector.dart`
- [ ] `lib/modules/settings/widgets/language_selector.dart`
- [ ] `lib/modules/settings/bottom_sheets/theme_picker_sheet.dart`
- [ ] `lib/modules/settings/bottom_sheets/language_picker_sheet.dart`
- [ ] Tests

### Module Splash ☐

- [ ] `lib/modules/splash/config/splash_config.dart`
- [ ] `lib/modules/splash/views/splash_view.dart`
- [ ] `lib/modules/splash/views/force_update_view.dart`
- [ ] `lib/modules/splash/viewmodels/splash_viewmodel.dart`
- [ ] Animation fadeScale
- [ ] Animation bounce
- [ ] Animation slideUp
- [ ] Tests

### Module Notifications ☐

- [ ] `lib/modules/notifications/config/notifications_config.dart`
- [ ] `lib/modules/notifications/views/notifications_view.dart`
- [ ] `lib/modules/notifications/viewmodels/notifications_viewmodel.dart`
- [ ] `lib/modules/notifications/widgets/notification_badge.dart`
- [ ] `lib/modules/notifications/widgets/notification_card.dart`
- [ ] `lib/modules/notifications/widgets/notifications_list.dart`
- [ ] `lib/modules/notifications/services/push_notification_service.dart`
- [ ] Tests

### Intégration ☐

- [ ] Mise à jour `app.dart` avec routes modules
- [ ] Mise à jour `app.locator.dart` avec services
- [ ] `app_features.dart` avec tous les flags
- [ ] Documentation README
- [ ] Exemple d'utilisation
- [ ] Tests E2E

---

## Notes de Design

### Cohérence Visuelle

Tous les modules utilisent le **Design System Porsche** existant:

- `AppColors` pour les couleurs
- `AppTypography` pour les textes
- `AppSpacing` pour les marges
- `AppRadius` pour les bordures
- Widgets `app_*` pour les composants

### Responsive

Les vues doivent fonctionner sur:

- Mobile (portrait)
- Mobile (landscape)
- Tablet
- Desktop (si applicable)

### Accessibilité

- Labels sémantiques sur tous les boutons
- Contraste suffisant
- Tailles de touch target ≥ 48dp
- Support lecteur d'écran

---

## Révisions

| Version | Date       | Changements       |
| ------- | ---------- | ----------------- |
| 1.0     | 2026-01-22 | Création initiale |

---

> **Prêt à implémenter?** Commence par le module Auth, c'est le plus critique.

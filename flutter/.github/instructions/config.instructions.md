---
applyTo: "**/config/**/*.dart,**/core/config/**/*.dart"
---
# Config Instructions

> These instructions apply to all configuration files in `core/config/`.
> Inherits from: `dart.instructions.md`

---

## Config Principles

### Purpose

- **Centralize app configuration** - single source of truth
- **Environment-specific settings** - dev, staging, production
- **Type-safe access** - compile-time checks
- **No hardcoded values** - all values from config

### Location

- **Path**: `lib/core/config/`

---

## Environment Configuration

### Environment Enum

```dart
// lib/core/config/env/environment.dart

/// Application environments.
enum Environment {
  development,
  staging,
  production,
}

extension EnvironmentExtension on Environment {
  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
  
  bool get isDebug => isDevelopment || isStaging;
  bool get isRelease => isProduction;
}
```

### Environment Config

```dart
// lib/core/config/env/env_config.dart

import 'environment.dart';

/// Configuration values that vary by environment.
abstract class EnvConfig {
  /// Current environment.
  Environment get environment;

  /// Base URL for API requests.
  String get apiBaseUrl;

  /// Supabase URL.
  String get supabaseUrl;

  /// Supabase anon key.
  String get supabaseAnonKey;

  /// Whether to enable verbose logging.
  bool get enableLogging;

  /// Whether to enable analytics.
  bool get enableAnalytics;

  /// Whether to enable crash reporting.
  bool get enableCrashReporting;

  /// App display name.
  String get appName;
}
```

### Development Config

```dart
// lib/core/config/env/dev_config.dart

import 'env_config.dart';
import 'environment.dart';

/// Development environment configuration.
class DevConfig implements EnvConfig {
  const DevConfig();

  @override
  Environment get environment => Environment.development;

  @override
  String get apiBaseUrl => 'https://api-dev.example.com/v1';

  @override
  String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://xxx.supabase.co',
      );

  @override
  String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: 'your-anon-key',
      );

  @override
  bool get enableLogging => true;

  @override
  bool get enableAnalytics => false;

  @override
  bool get enableCrashReporting => false;

  @override
  String get appName => 'MyApp Dev';
}
```

### Staging Config

```dart
// lib/core/config/env/staging_config.dart

import 'env_config.dart';
import 'environment.dart';

/// Staging environment configuration.
class StagingConfig implements EnvConfig {
  const StagingConfig();

  @override
  Environment get environment => Environment.staging;

  @override
  String get apiBaseUrl => 'https://api-staging.example.com/v1';

  @override
  String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL');

  @override
  String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY');

  @override
  bool get enableLogging => true;

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get appName => 'MyApp Staging';
}
```

### Production Config

```dart
// lib/core/config/env/prod_config.dart

import 'env_config.dart';
import 'environment.dart';

/// Production environment configuration.
class ProdConfig implements EnvConfig {
  const ProdConfig();

  @override
  Environment get environment => Environment.production;

  @override
  String get apiBaseUrl => 'https://api.example.com/v1';

  @override
  String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL');

  @override
  String get supabaseAnonKey => const String.fromEnvironment('SUPABASE_ANON_KEY');

  @override
  bool get enableLogging => false;

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get appName => 'MyApp';
}
```

---

## App Configuration Singleton

```dart
// lib/core/config/app_config.dart

import 'env/env_config.dart';
import 'env/environment.dart';

/// Global application configuration.
///
/// Initialize in main.dart before running the app:
/// ```dart
/// void main() {
///   AppConfig.initialize(DevConfig());
///   runApp(const MyApp());
/// }
/// ```
class AppConfig {
  static late final EnvConfig _config;
  static bool _initialized = false;

  /// Initializes the app configuration.
  ///
  /// Must be called before accessing any config values.
  /// Should only be called once at app startup.
  static void initialize(EnvConfig config) {
    if (_initialized) {
      throw StateError('AppConfig already initialized');
    }
    _config = config;
    _initialized = true;
  }

  /// Returns the current environment config.
  ///
  /// Throws if [initialize] hasn't been called.
  static EnvConfig get instance {
    if (!_initialized) {
      throw StateError('AppConfig not initialized. Call initialize() first.');
    }
    return _config;
  }

  // ─────────────────────────────────────────────────────────────────
  // Convenience Getters
  // ─────────────────────────────────────────────────────────────────

  static Environment get environment => instance.environment;
  static String get apiBaseUrl => instance.apiBaseUrl;
  static String get supabaseUrl => instance.supabaseUrl;
  static String get supabaseAnonKey => instance.supabaseAnonKey;
  static bool get enableLogging => instance.enableLogging;
  static bool get enableAnalytics => instance.enableAnalytics;
  static bool get enableCrashReporting => instance.enableCrashReporting;
  static String get appName => instance.appName;

  static bool get isDevelopment => environment.isDevelopment;
  static bool get isStaging => environment.isStaging;
  static bool get isProduction => environment.isProduction;
  static bool get isDebug => environment.isDebug;
  static bool get isRelease => environment.isRelease;

  // ─────────────────────────────────────────────────────────────────
  // For Testing
  // ─────────────────────────────────────────────────────────────────

  /// Resets the configuration (for testing only).
  @visibleForTesting
  static void reset() {
    _initialized = false;
  }
}
```

---

## Entry Points

### Development

```dart
// lib/main_dev.dart

import 'package:flutter/material.dart';

import 'app/app.locator.dart';
import 'core/config/app_config.dart';
import 'core/config/env/dev_config.dart';
import 'bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize configuration
  AppConfig.initialize(const DevConfig());
  
  // Setup dependency injection
  await setupLocator();
  
  // Bootstrap and run app
  runApp(await bootstrap());
}
```

### Staging

```dart
// lib/main_staging.dart

import 'package:flutter/material.dart';

import 'app/app.locator.dart';
import 'core/config/app_config.dart';
import 'core/config/env/staging_config.dart';
import 'bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.initialize(const StagingConfig());
  await setupLocator();
  
  runApp(await bootstrap());
}
```

### Production

```dart
// lib/main.dart

import 'package:flutter/material.dart';

import 'app/app.locator.dart';
import 'core/config/app_config.dart';
import 'core/config/env/prod_config.dart';
import 'bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.initialize(const ProdConfig());
  await setupLocator();
  
  runApp(await bootstrap());
}
```

---

## Feature Flags

```dart
// lib/core/config/feature_flags.dart

import 'app_config.dart';

/// Feature flags for gradual rollouts.
///
/// Allows enabling/disabling features based on environment or remote config.
class FeatureFlags {
  const FeatureFlags._();

  /// Enable new onboarding flow.
  static bool get newOnboarding {
    if (AppConfig.isDevelopment) return true;
    if (AppConfig.isStaging) return true;
    return false; // Production: disabled until fully tested
  }

  /// Enable biometric authentication.
  static bool get biometricAuth {
    return true; // Enabled everywhere
  }

  /// Enable dark mode.
  static bool get darkMode {
    return true;
  }

  /// Enable offline mode.
  static bool get offlineMode {
    if (AppConfig.isDevelopment) return true;
    return false; // Not ready for production
  }

  /// Enable push notifications.
  static bool get pushNotifications {
    if (AppConfig.isDevelopment) return false; // Avoid spam in dev
    return true;
  }

  /// Enable analytics tracking.
  static bool get analytics {
    return AppConfig.enableAnalytics;
  }

  /// Enable crash reporting.
  static bool get crashReporting {
    return AppConfig.enableCrashReporting;
  }

  /// Enable verbose logging.
  static bool get verboseLogging {
    return AppConfig.enableLogging;
  }

  /// Enable experimental features.
  static bool get experimental {
    return AppConfig.isDevelopment;
  }
}
```

---

## App Constants

```dart
// lib/core/config/app_constants.dart

/// Application-wide constants.
///
/// Values that don't change between environments.
abstract class AppConstants {
  // ─────────────────────────────────────────────────────────────────
  // App Info
  // ─────────────────────────────────────────────────────────────────

  static const String appId = 'com.example.myapp';
  static const String appStoreId = '123456789';
  static const String playStoreId = 'com.example.myapp';

  // ─────────────────────────────────────────────────────────────────
  // API
  // ─────────────────────────────────────────────────────────────────

  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const int maxRetries = 3;

  // ─────────────────────────────────────────────────────────────────
  // Pagination
  // ─────────────────────────────────────────────────────────────────

  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─────────────────────────────────────────────────────────────────
  // Cache
  // ─────────────────────────────────────────────────────────────────

  static const Duration cacheExpiry = Duration(hours: 24);
  static const Duration shortCacheExpiry = Duration(minutes: 5);
  static const int maxCacheSize = 100; // MB

  // ─────────────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────────────

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 30;
  static const int maxBioLength = 500;

  // ─────────────────────────────────────────────────────────────────
  // Animation
  // ─────────────────────────────────────────────────────────────────

  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // ─────────────────────────────────────────────────────────────────
  // Storage Keys
  // ─────────────────────────────────────────────────────────────────

  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_complete';

  // ─────────────────────────────────────────────────────────────────
  // External URLs
  // ─────────────────────────────────────────────────────────────────

  static const String termsUrl = 'https://example.com/terms';
  static const String privacyUrl = 'https://example.com/privacy';
  static const String supportUrl = 'https://example.com/support';
  static const String faqUrl = 'https://example.com/faq';
}
```

---

## File Organization

```
lib/core/config/
├── app_config.dart              # Main config singleton
├── app_constants.dart           # Static constants
├── feature_flags.dart           # Feature toggles
│
└── env/
    ├── environment.dart         # Environment enum
    ├── env_config.dart          # Config interface
    ├── dev_config.dart          # Development values
    ├── staging_config.dart      # Staging values
    └── prod_config.dart         # Production values
```

---

## Usage in Code

```dart
import 'package:my_app/core/config/app_config.dart';
import 'package:my_app/core/config/app_constants.dart';
import 'package:my_app/core/config/feature_flags.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: AppConstants.apiTimeout,
  ));
}

class AuthViewModel extends BaseViewModel {
  Future<void> login() async {
    if (FeatureFlags.biometricAuth) {
      // Show biometric option
    }
  }
}
```

---

## Running with Environment

```bash
# Development
flutter run --target lib/main_dev.dart

# Staging
flutter run --target lib/main_staging.dart

# Production
flutter run --target lib/main.dart --release

# With dart-define for secrets
flutter run \
  --target lib/main_staging.dart \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-key
```

---

## Don'ts

```dart
// ❌ Don't hardcode environment values
final apiUrl = 'https://api.example.com'; // Use AppConfig.apiBaseUrl

// ❌ Don't check environment with strings
if (Platform.environment['ENV'] == 'dev') { } // Use AppConfig.isDevelopment

// ❌ Don't store secrets in code
const apiKey = 'sk-secret-key'; // Use --dart-define or secure storage

// ❌ Don't access config before initialization
void main() {
  print(AppConfig.apiBaseUrl); // Error! Must call initialize() first
}

// ❌ Don't create multiple instances
final config1 = DevConfig();
final config2 = DevConfig(); // Use AppConfig.instance

// ❌ Don't modify config at runtime
AppConfig.apiBaseUrl = 'new-url'; // Config should be immutable
```

---
applyTo: "**/modules/**/*.dart"
---

# Module Instructions

> These instructions apply to all files within the `modules/` folder.
> Inherits from: `dart.instructions.md`

---

## Module Principles

### What is a Module?

A **module** is a self-contained, reusable business feature:

- **Autonomous** - No dependencies on other modules
- **Configurable** - Options via Dart classes with sensible defaults
- **UI Variants** - Multiple visual styles via enums
- **Copy-paste ready** - Can be copied to any project

### Module vs Feature

| Modules                           | Features                         |
| --------------------------------- | -------------------------------- |
| Generic, reusable                 | Project-specific                 |
| Located in `lib/modules/`         | Located in `lib/features/`       |
| Part of template                  | Added by developer               |
| Examples: Auth, Profile, Settings | Examples: Orders, Products, Chat |

---

## Module Structure

### Standard Structure

```
modules/
└── {module_name}/
    ├── config/
    │   └── {module}_config.dart      # Configuration class
    ├── views/
    │   ├── {feature}_view.dart       # Stacked views
    │   └── widgets/                  # View-specific widgets (optional)
    ├── viewmodels/
    │   └── {feature}_viewmodel.dart  # Stacked ViewModels
    ├── widgets/
    │   └── {widget}_widget.dart      # Reusable widgets
    ├── services/
    │   └── {service}_service.dart    # Module-specific services (optional)
    └── {module}_module.dart          # Barrel file (exports)
```

### Example: Auth Module

```
modules/
└── auth/
    ├── config/
    │   └── auth_config.dart
    ├── views/
    │   ├── login_view.dart
    │   ├── register_view.dart
    │   ├── forgot_password_view.dart
    │   └── otp_verification_view.dart
    ├── viewmodels/
    │   ├── login_viewmodel.dart
    │   ├── register_viewmodel.dart
    │   ├── forgot_password_viewmodel.dart
    │   └── otp_viewmodel.dart
    ├── widgets/
    │   ├── social_login_buttons.dart
    │   ├── auth_header.dart
    │   └── biometric_button.dart
    └── auth_module.dart
```

---

## Module Configuration

### Config Class Pattern

Every module MUST have a config class with:

- `const` constructor
- Default values for all options
- Static `defaultConfig` accessor

```dart
// lib/modules/auth/config/auth_config.dart

/// Configuration for the Auth module.
class AuthConfig {
  /// Enable Google sign-in.
  final bool enableGoogle;

  /// Enable Apple sign-in (iOS/macOS only).
  final bool enableApple;

  /// Enable phone OTP authentication.
  final bool enablePhone;

  /// Enable biometric authentication.
  final bool enableBiometric;

  /// Require email verification before granting access.
  final bool requireEmailVerification;

  /// Visual style of auth screens.
  final AuthStyle style;

  const AuthConfig({
    this.enableGoogle = true,
    this.enableApple = true,
    this.enablePhone = false,
    this.enableBiometric = true,
    this.requireEmailVerification = true,
    this.style = AuthStyle.modern,
  });

  /// Default configuration.
  static const defaultConfig = AuthConfig();
}
```

### Style Enum Pattern

Use enums for UI variants:

```dart
/// Available visual styles for auth screens.
enum AuthStyle {
  /// Modern design with gradients and animations.
  modern,

  /// Classic centered design.
  classic,

  /// Clean minimal design.
  minimal,
}
```

---

## UI Variants

### Implementing Variants

Use `switch` expression in views to render different layouts:

```dart
class LoginView extends StackedView<LoginViewModel> {
  final AuthConfig config;

  const LoginView({
    super.key,
    this.config = const AuthConfig(),
  });

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return switch (config.style) {
      AuthStyle.modern => _buildModern(context, viewModel),
      AuthStyle.classic => _buildClassic(context, viewModel),
      AuthStyle.minimal => _buildMinimal(context, viewModel),
    };
  }

  Widget _buildModern(BuildContext context, LoginViewModel viewModel) {
    // Modern variant implementation
  }

  Widget _buildClassic(BuildContext context, LoginViewModel viewModel) {
    // Classic variant implementation
  }

  Widget _buildMinimal(BuildContext context, LoginViewModel viewModel) {
    // Minimal variant implementation
  }
}
```

### Variant Guidelines

| DO                                    | DON'T                                  |
| ------------------------------------- | -------------------------------------- |
| Share logic across variants           | Duplicate ViewModel logic              |
| Extract common widgets                | Create separate ViewModels per variant |
| Keep variants in same file (if small) | Over-engineer with inheritance         |
| Use design system tokens              | Hardcode colors/spacing per variant    |

---

## Barrel File

### Module Export Pattern

Each module MUST have a barrel file that exports public API:

````dart
// lib/modules/auth/auth_module.dart

/// Auth module - handles authentication flows.
///
/// Usage:
/// ```dart
/// import 'package:myapp/modules/auth/auth_module.dart';
///
/// // Configure
/// final config = AuthConfig(
///   enableGoogle: true,
///   enableApple: true,
///   style: AuthStyle.modern,
/// );
///
/// // Navigate to login
/// navigator.navigateTo(Routes.login);
/// ```
library auth_module;

// Config
export 'config/auth_config.dart';

// Views
export 'views/login_view.dart';
export 'views/register_view.dart';
export 'views/forgot_password_view.dart';
export 'views/otp_verification_view.dart';

// Widgets (reusable outside module)
export 'widgets/social_login_buttons.dart';
export 'widgets/auth_header.dart';
export 'widgets/biometric_button.dart';
````

### What to Export

| Export           | Don't Export              |
| ---------------- | ------------------------- |
| Config class     | ViewModels (internal)     |
| Views            | Private widgets           |
| Reusable widgets | Services (use DI instead) |

---

## Module Dependencies

### Allowed Dependencies

Modules CAN depend on:

- `core/` - Errors, extensions, utils, config
- `design_system/` - Tokens, theme, base widgets
- `services/` - Technical services via DI
- `domain/` - Entities, repository contracts
- External packages

### Forbidden Dependencies

Modules MUST NOT depend on:

- Other modules (`modules/profile` cannot import `modules/auth`)
- `features/` - Project-specific code
- Circular dependencies

### Dependency Injection

Use constructor injection for services:

```dart
class LoginViewModel extends BaseViewModel {
  final IAuthRepository _authRepository;
  final NavigationService _navigationService;

  LoginViewModel({
    required IAuthRepository authRepository,
    required NavigationService navigationService,
  })  : _authRepository = authRepository,
        _navigationService = navigationService;

  // Or use locator if registered
  LoginViewModel()
      : _authRepository = locator<IAuthRepository>(),
        _navigationService = locator<NavigationService>();
}
```

---

## Storage & Persistence

### Local Storage Pattern

For module-specific storage (e.g., onboarding completed):

```dart
// lib/modules/onboarding/services/onboarding_storage.dart

/// Handles onboarding persistence.
class OnboardingStorage {
  static const _key = 'onboarding_completed';

  final SharedPreferences _prefs;

  OnboardingStorage(this._prefs);

  /// Whether onboarding has been completed.
  Future<bool> isCompleted() async {
    return _prefs.getBool(_key) ?? false;
  }

  /// Marks onboarding as completed.
  Future<void> markCompleted() async {
    await _prefs.setBool(_key, true);
  }

  /// Resets onboarding state (for testing/debug).
  Future<void> reset() async {
    await _prefs.remove(_key);
  }
}
```

---

## Testing

### Test Structure

```
test/
└── modules/
    └── auth/
        ├── viewmodels/
        │   ├── login_viewmodel_test.dart
        │   └── register_viewmodel_test.dart
        ├── widgets/
        │   └── social_login_buttons_test.dart
        └── config/
            └── auth_config_test.dart
```

### Config Tests

```dart
void main() {
  group('AuthConfig', () {
    test('has sensible defaults', () {
      const config = AuthConfig();

      expect(config.enableGoogle, isTrue);
      expect(config.enableApple, isTrue);
      expect(config.enablePhone, isFalse);
      expect(config.style, AuthStyle.modern);
    });

    test('defaultConfig is accessible', () {
      expect(AuthConfig.defaultConfig, isNotNull);
    });
  });
}
```

---

## Module Checklist

When creating a new module, ensure:

- [ ] Config class with `const` constructor and defaults
- [ ] Style enum for UI variants
- [ ] Barrel file with clean exports
- [ ] No inter-module dependencies
- [ ] Uses design system tokens
- [ ] ViewModels use `Either<Failure, T>` for operations
- [ ] Documentation comments on public API
- [ ] Unit tests for ViewModels
- [ ] Widget tests for reusable widgets

---

## Module Registry

### Available Modules

| Module          | Description                      | Priority |
| --------------- | -------------------------------- | -------- |
| `splash`        | App launch, routing decisions    | Critical |
| `auth`          | Login, register, password reset  | Critical |
| `onboarding`    | Introduction slides              | High     |
| `profile`       | View/edit user profile           | High     |
| `settings`      | Theme, language, account actions | High     |
| `notifications` | Push notifications, in-app list  | Medium   |

### Module Activation

Modules are activated via `AppFeatures`:

```dart
// lib/core/config/app_features.dart

abstract class AppFeatures {
  static const bool enableOnboarding = true;
  static const bool enableBiometricAuth = true;
  static const bool enableNotifications = true;
  static const bool enablePhoneAuth = false;
}
```

---

## References

- [Stacked Documentation](https://stacked.filledstacks.com/)
- [View Instructions](view.instructions.md)
- [ViewModel Instructions](viewmodel.instructions.md)
- [MODULES_SPECIFICATION.md](../../docs/MODULES_SPECIFICATION.md)

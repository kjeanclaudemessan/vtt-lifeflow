# Flutter — Copilot Instructions

> **Flutter layer** of the VTT monorepo template.
> Stack: Flutter 3.x, Stacked MVVM, GetIt DI, Supabase Flutter.

---

## Architecture: MVVM + Clean Architecture (via Stacked)

### Layer Dependency Rules

```
✅ Core         → No internal dependencies
✅ Domain       → No internal dependencies (pure Dart)
✅ Data         → Domain, Services, Core
✅ Services     → Core only
✅ Presentation → Domain, Services, Core, Design System
✅ Modules      → Can have own views/viewmodels/widgets
✅ Features     → Can have own data/domain/presentation layers
```

### Folder Structure (`lib/`)

```
lib/
├── main.dart                         # Entry point (calls bootstrap)
├── bootstrap.dart                    # App initialization (DI, services, Supabase)
├── app/                              # Stacked configuration
│   ├── app.dart                      # @StackedApp — routes, DI, sheets, dialogs
│   ├── app.locator.dart              # Generated service locator
│   ├── app.router.dart               # Generated router
│   ├── app.dialogs.dart              # Generated dialog setup
│   └── app.bottomsheets.dart         # Generated bottom sheet setup
├── core/                             # Shared foundations (NO external deps)
│   ├── config/                       # AppConfig, Environment, FeatureFlags
│   ├── constants/                    # api_constants, app_constants, regex_patterns, storage_keys
│   ├── enums/                        # LoadState, AuthStatus, ConnectivityStatus
│   ├── errors/                       # Failure hierarchy, ErrorHandler, Exceptions
│   ├── extensions/                   # String, Context, DateTime, List, Num, Either
│   ├── typedefs/                     # Type aliases
│   └── utils/                        # Validators, Formatters, Debouncer, Logger
├── domain/                           # Pure business layer (NO dependencies)
│   ├── entities/                     # UserEntity, etc.
│   └── repositories/                 # Contracts: IAuthRepository, etc.
├── data/                             # Domain implementation
│   ├── models/                       # UserModel (with fromJson/toJson/toEntity)
│   └── repositories/                 # AuthRepositoryImpl implements IAuthRepository
├── services/                         # Technical services (wrap external deps)
│   ├── api/                          # ApiService (Dio + interceptors)
│   ├── supabase/                     # SupabaseService, SupabaseAuthService
│   ├── storage/                      # LocalStorageService, SecureStorageService
│   ├── connectivity/                 # ConnectivityService
│   ├── dialog/                       # DialogHelper
│   └── services.dart                 # Barrel file exporting all services
├── modules/                          # Feature modules (self-contained)
│   ├── auth/                         # Login, Register, ForgotPassword
│   ├── profile/                      # Profile, EditProfile
│   ├── splash/                       # Splash screen
│   ├── onboarding/                   # Onboarding flow
│   ├── settings/                     # App settings
│   ├── notifications/                # Notification center
│   └── optional/                     # Toggled via vtt.yaml
│       ├── organizations/
│       ├── payments/
│       ├── subscriptions/
│       ├── invitations/
│       ├── tags/
│       ├── attachments/
│       ├── comments/
│       ├── favorites/
│       └── activities/
├── features/                         # Project-specific features (add per-project)
├── ui/                               # Shared UI components
│   ├── views/                        # HomeView, StartupView, DesignShowcaseView
│   ├── widgets/                      # Reusable widgets
│   ├── bottom_sheets/                # NoticeSheet, etc.
│   └── dialogs/                      # InfoAlertDialog, etc.
├── design_system/                    # Design tokens & theme
│   ├── theme/                        # AppTheme (light/dark)
│   ├── colors/                       # AppColors
│   ├── typography/                   # AppTextStyles
│   ├── spacing/                      # AppSpacing, AppGaps
│   ├── radius/                       # AppRadius
│   ├── shadows/                      # AppShadows
│   └── design_system.dart            # Barrel file
└── l10n/                             # Internationalization (ARB files)
```

---

## Key Patterns

### DI (GetIt via Stacked)

```dart
// Registration in app.dart via @StackedApp annotation:
@StackedApp(
  dependencies: [
    LazySingleton(classType: ApiService),
    LazySingleton(classType: AuthRepositoryImpl, asType: IAuthRepository),
    Singleton(classType: LocalStorageService),  // Requires init
  ],
)

// Usage anywhere:
final authRepo = locator<IAuthRepository>();
```

### State Management (Stacked ViewModels)

```dart
class LoginViewModel extends BaseViewModel {
  final _authRepository = locator<IAuthRepository>();

  static const String loginBusyKey = 'login';

  Future<void> login() async {
    final result = await runBusyFuture(
      _authRepository.signInWithEmail(email: _email, password: _password),
      busyObject: loginBusyKey,
    );
    // handle result...
  }
}
```

### View Pattern (StackedView)

```dart
class LoginView extends StackedView<LoginViewModel> {
  @override
  Widget builder(BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(/* UI only — no business logic */);
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
```

### Error Handling (Either pattern with dartz)

```dart
// Repository contract returns Either<Failure, T>
Future<Either<Failure, UserEntity>> login({
  required String email,
  required String password,
});

// Failure hierarchy:
// Failure → ServerFailure, NetworkFailure, CacheFailure, AuthFailure, ValidationFailure, UnknownFailure
```

### Auth Pattern

```dart
// 1. Repository contract (domain layer)
abstract class IAuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmail({...});
  Future<Either<Failure, bool>> signInWithOAuth({required OAuthProvider provider});
}

// 2. Implementation uses SupabaseAuthService (data layer)
class AuthRepositoryImpl implements IAuthRepository { ... }

// 3. ViewModel calls repository via locator
class LoginViewModel extends BaseViewModel {
  final _authRepository = locator<IAuthRepository>();
  Future<void> loginWithEmail() async {
    final result = await runBusyFuture(
      _authRepository.signInWithEmail(email: _email, password: _password),
      busyObject: loginBusyKey,
    );
  }
}
```

---

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case` | `login_viewmodel.dart`, `user_entity.dart` |
| Classes | `PascalCase` | `LoginViewModel`, `UserEntity` |
| Variables | `camelCase` | `userName`, `isLoading` |
| Private members | `_camelCase` | `_authRepository`, `_handleResult()` |
| Interfaces | `I` prefix | `IAuthRepository`, `IUserService` |
| Constants | `camelCase` | `maxRetries`, `loginBusyKey` |
| Barrel files | same as folder | `core.dart`, `services.dart`, `design_system.dart` |
| Views | `*_view.dart` | `login_view.dart` |
| ViewModels | `*_viewmodel.dart` | `login_viewmodel.dart` |
| Models | `*_model.dart` | `user_model.dart` |
| Entities | `*_entity.dart` | `user_entity.dart` |
| Services | `*_service.dart` | `api_service.dart` |
| Repositories (contract) | `i_*_repository.dart` | `i_auth_repository.dart` |
| Repositories (impl) | `*_repository_impl.dart` | `auth_repository_impl.dart` |

---

## Import Conventions

Use **relative imports** within the same module, **barrel imports** for cross-module:

```dart
// Within the same module — relative imports
import '../viewmodels/login_viewmodel.dart';
import '../widgets/auth_header.dart';

// Cross-module — barrel files
import 'package:lifeflow/core/core.dart';
import 'package:lifeflow/services/services.dart';
import 'package:lifeflow/design_system/design_system.dart';

// App-level (DI, routing)
import 'package:lifeflow/app/app.locator.dart';
import 'package:lifeflow/app/app.router.dart';
```

**Import grouping order:**
1. `dart:` SDK imports
2. `package:flutter/` framework imports
3. `package:` third-party packages
4. `package:lifeflow/` app-level imports
5. Relative imports (`../`, `./`)

---

## Module Structure

### Standard Module

```
modules/[module_name]/
├── config/                     # Module-specific configuration
├── viewmodels/                 # ViewModels (one per view)
│   └── [name]_viewmodel.dart
├── views/                      # Views (StackedView<ViewModel>)
│   └── [name]_view.dart
└── widgets/                    # Module-specific widgets
    └── [widget_name].dart
```

### Optional Module (services only)

```
modules/optional/[module_name]/
├── [module_name]_service.dart  # Service with Supabase CRUD
└── [module_name]_model.dart    # Data model (if needed)
```

Each module's views → routes in `app/app.dart` under `@StackedApp(routes: [...])`.
Each module's services → dependencies in `app/app.dart` under `@StackedApp(dependencies: [...])`.

---

## Design System

Use design system tokens instead of hardcoded values:

```dart
// Colors
AppColors.primary, AppColors.success, AppColors.error

// Spacing
AppSpacing.xs (8), AppSpacing.sm (12), AppSpacing.md (16), AppSpacing.lg (24)

// Gaps (pre-built SizedBox)
AppGaps.h16, AppGaps.w8

// Typography
AppTextStyles.headlineLarge, AppTextStyles.bodyMedium, AppTextStyles.labelSmall

// Theme access
context.colorScheme.surface, context.colorScheme.primary
```

---

## Internationalization

- ARB files in `lib/l10n/arb/` (template: `app_en.arb`)
- Generated code in `lib/l10n/generated/`
- Access: `context.l10n.login`, `context.l10n.welcomeBack('John')`
- Extension: `extension on BuildContext { AppLocalizations get l10n => AppLocalizations.of(this)!; }`
- Supported: English (`en`), French (`fr`), Arabic (`ar`), Spanish (`es`)

---

## Code Generation

After modifying `app/app.dart`, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This regenerates: `app.locator.dart`, `app.router.dart`, `app.dialogs.dart`, `app.bottomsheets.dart`.

Stacked markers in `app.dart`:
- `// @stacked-import` — where new imports are added
- `// @stacked-route` — where new routes are added
- `// @stacked-service` — where new DI entries are added
- `// @stacked-bottom-sheet` — where new bottom sheets are added
- `// @stacked-dialog` — where new dialogs are added

---

## Testing Patterns

```
test/
├── core/                    # Unit tests for extensions, utils
├── helpers/                 # Test helpers, mocks (Mockito @GenerateMocks)
├── viewmodels/              # ViewModel unit tests
├── services/                # Service unit tests
└── integration/             # Integration tests (Supabase, flows)
```

**ViewModel test pattern:**

```dart
void main() {
  late LoginViewModel viewModel;
  late MockIAuthRepository mockAuthRepo;

  setUp(() {
    registerServices();  // Register mocks in locator
    mockAuthRepo = MockIAuthRepository();
    viewModel = LoginViewModel();
  });

  tearDown(() => unregisterServices());

  test('should login successfully', () async {
    when(mockAuthRepo.login(email: any, password: any))
      .thenAnswer((_) async => Right(testUser));
    await viewModel.login('test@test.com', 'password');
    expect(viewModel.hasError, false);
  });
}
```

---

## Environments

```dart
// bootstrap.dart initializes everything:
await bootstrap(environment: Environment.development);

// Environments: Environment.development, Environment.staging, Environment.production
// Config loaded via AppConfig.initialize(environment)
// Access: AppConfig.instance.apiBaseUrl, AppConfig.instance.supabaseUrl
```

---

## Key Rules

1. **Views contain NO business logic** — all logic lives in ViewModels.
2. **Domain layer has NO external dependencies** — pure Dart only.
3. **Repositories return `Either<Failure, T>`** — never throw exceptions in business logic.
4. **Services are registered in `app.dart`** via `@StackedApp(dependencies: [...])`.
5. **Use barrel files** (`core.dart`, `services.dart`, `design_system.dart`) for cross-module imports.
6. **Modules are self-contained** — a module should not import from another module directly.
7. **Optional modules live under `modules/optional/`** and are toggled via `vtt.yaml`.
8. **Flutter talks directly to Supabase** for most operations — no FastAPI needed for CRUD.

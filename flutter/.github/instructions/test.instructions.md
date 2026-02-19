---
applyTo: "**/test/**/*.dart,**/*_test.dart"
---
# Test Instructions

> These instructions apply to all test files (`*_test.dart`).
> Inherits from: `dart.instructions.md`

---

## Test Principles

### Testing Philosophy

- **Test behavior, not implementation** - focus on what, not how
- **Arrange, Act, Assert** (AAA) pattern
- **One assertion per test** (when practical)
- **Descriptive test names** - describe the expected behavior
- **Fast and independent** - tests should run in isolation

### Test Types

| Type | Location | Purpose |
|------|----------|---------|
| Unit | `test/unit/` | Single class/function |
| Widget | `test/widget/` | UI components |
| Integration | `test/integration/` | Multiple components |
| Golden | `test/golden/` | Visual regression |

---

## Test File Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:my_app/features/auth/login_viewmodel.dart';
import 'package:my_app/domain/repositories/i_auth_repository.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/core/errors/failures.dart';

// Generate mocks for dependencies
@GenerateMocks([
  IAuthRepository,
  NavigationService,
])
import 'login_viewmodel_test.mocks.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────
  // Setup
  // ─────────────────────────────────────────────────────────────────

  late LoginViewModel viewModel;
  late MockIAuthRepository mockAuthRepository;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    mockNavigationService = MockNavigationService();
    viewModel = LoginViewModel(
      authRepository: mockAuthRepository,
      navigationService: mockNavigationService,
    );
  });

  tearDown(() {
    // Clean up if needed
  });

  // ─────────────────────────────────────────────────────────────────
  // Test Groups
  // ─────────────────────────────────────────────────────────────────

  group('LoginViewModel', () {
    // Test data
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = UserEntity.mock();
    const tFailure = AuthFailure('Invalid credentials');

    group('initial state', () {
      test('should have empty email and password', () {
        expect(viewModel.email, isEmpty);
        expect(viewModel.password, isEmpty);
      });

      test('should not be busy', () {
        expect(viewModel.isBusy, isFalse);
      });

      test('should have no error', () {
        expect(viewModel.hasError, isFalse);
      });

      test('should not be valid for submission', () {
        expect(viewModel.canSubmit, isFalse);
      });
    });

    group('setEmail', () {
      test('should update email value', () {
        // Act
        viewModel.setEmail(tEmail);

        // Assert
        expect(viewModel.email, tEmail);
      });

      test('should notify listeners', () {
        // Arrange
        var notified = false;
        viewModel.addListener(() => notified = true);

        // Act
        viewModel.setEmail(tEmail);

        // Assert
        expect(notified, isTrue);
      });
    });

    group('login', () {
      test('should call repository with correct parameters', () async {
        // Arrange
        viewModel.setEmail(tEmail);
        viewModel.setPassword(tPassword);
        when(mockAuthRepository.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Right(tUser));

        // Act
        await viewModel.login();

        // Assert
        verify(mockAuthRepository.login(
          email: tEmail,
          password: tPassword,
        )).called(1);
      });

      test('should set busy state while logging in', () async {
        // Arrange
        viewModel.setEmail(tEmail);
        viewModel.setPassword(tPassword);
        when(mockAuthRepository.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(tUser);
        });

        // Act
        final future = viewModel.login();

        // Assert - busy during operation
        expect(viewModel.isBusy, isTrue);
        await future;
        expect(viewModel.isBusy, isFalse);
      });

      test('should navigate to home on success', () async {
        // Arrange
        viewModel.setEmail(tEmail);
        viewModel.setPassword(tPassword);
        when(mockAuthRepository.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Right(tUser));

        // Act
        await viewModel.login();

        // Assert
        verify(mockNavigationService.replaceWithHomeView()).called(1);
      });

      test('should set error on failure', () async {
        // Arrange
        viewModel.setEmail(tEmail);
        viewModel.setPassword(tPassword);
        when(mockAuthRepository.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => const Left(tFailure));

        // Act
        await viewModel.login();

        // Assert
        expect(viewModel.hasError, isTrue);
        expect(viewModel.modelError, tFailure.message);
        verifyNever(mockNavigationService.replaceWithHomeView());
      });
    });

    group('validation', () {
      test('should be valid when email and password are filled', () {
        // Act
        viewModel.setEmail(tEmail);
        viewModel.setPassword(tPassword);

        // Assert
        expect(viewModel.canSubmit, isTrue);
      });

      test('should be invalid when email is empty', () {
        // Act
        viewModel.setPassword(tPassword);

        // Assert
        expect(viewModel.canSubmit, isFalse);
      });

      test('should be invalid when password is empty', () {
        // Act
        viewModel.setEmail(tEmail);

        // Assert
        expect(viewModel.canSubmit, isFalse);
      });
    });
  });
}
```

---

## Widget Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:my_app/ui/widgets/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('should display label text', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit',
              onPressed: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(AppButton));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit',
              onPressed: null,
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit',
              onPressed: null,
            ),
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should display prefix icon when provided', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Send',
              onPressed: () {},
              prefixIcon: Icons.send,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.send), findsOneWidget);
    });
  });
}
```

---

## Stacked ViewModel Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stacked/stacked.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('HomeViewModel', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('should initialize with correct state', () {
      final viewModel = HomeViewModel();
      viewModel.futureToRun(); // For FutureViewModel

      expect(viewModel.isBusy, isFalse);
      expect(viewModel.hasError, isFalse);
    });

    // Use helper to get registered mocks
    test('should use registered services', () async {
      final mockUserService = getAndRegisterUserService();
      when(mockUserService.getUser()).thenAnswer((_) async => UserEntity.mock());

      final viewModel = HomeViewModel();
      await viewModel.initialize();

      verify(mockUserService.getUser()).called(1);
    });
  });
}
```

---

## Test Helpers

```dart
// test/helpers/test_helpers.dart

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:my_app/app/app.locator.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/domain/repositories/i_auth_repository.dart';

@GenerateMocks([
  NavigationService,
  DialogService,
  BottomSheetService,
  UserService,
  IAuthRepository,
])
import 'test_helpers.mocks.dart';

/// Registers all mock services for testing.
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterDialogService();
  getAndRegisterBottomSheetService();
  getAndRegisterUserService();
  getAndRegisterAuthRepository();
}

/// Unregisters all services after testing.
void unregisterServices() {
  locator.reset();
}

// ─────────────────────────────────────────────────────────────────
// Mock Getters
// ─────────────────────────────────────────────────────────────────

MockNavigationService getAndRegisterNavigationService() {
  _removeIfRegistered<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeIfRegistered<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService() {
  _removeIfRegistered<BottomSheetService>();
  final service = MockBottomSheetService();
  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockUserService getAndRegisterUserService() {
  _removeIfRegistered<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(service);
  return service;
}

MockIAuthRepository getAndRegisterAuthRepository() {
  _removeIfRegistered<IAuthRepository>();
  final repository = MockIAuthRepository();
  locator.registerSingleton<IAuthRepository>(repository);
  return repository;
}

// ─────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────

void _removeIfRegistered<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
```

---

## Golden Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:my_app/ui/widgets/app_button.dart';

void main() {
  group('AppButton Golden Tests', () {
    testGoldens('should match golden - all variants', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 2,
      )
        ..addScenario(
          'Primary',
          AppButton(label: 'Primary', onPressed: () {}),
        )
        ..addScenario(
          'Secondary',
          AppButton.secondary(label: 'Secondary', onPressed: () {}),
        )
        ..addScenario(
          'Disabled',
          const AppButton(label: 'Disabled', onPressed: null),
        )
        ..addScenario(
          'Loading',
          AppButton(label: 'Loading', onPressed: () {}, isLoading: true),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(300, 200),
      );

      await screenMatchesGolden(tester, 'app_button_variants');
    });
  });
}
```

---

## Test Naming Conventions

### Format

```
should <expected behavior> when <condition>
```

### Examples

```dart
test('should return user entity when login is successful', () {});
test('should throw AuthException when credentials are invalid', () {});
test('should set isBusy to true when fetching data', () {});
test('should navigate to home when registration completes', () {});
test('should display error message when validation fails', () {});
```

---

## File Organization

```
test/
├── helpers/
│   ├── test_helpers.dart
│   ├── test_helpers.mocks.dart
│   ├── pump_app.dart            # Widget test helper
│   └── mock_data.dart           # Test fixtures
│
├── unit/
│   ├── core/
│   │   └── extensions/
│   │       └── string_extensions_test.dart
│   ├── domain/
│   │   └── usecases/
│   │       └── login_user_usecase_test.dart
│   └── data/
│       └── repositories/
│           └── auth_repository_impl_test.dart
│
├── viewmodels/
│   ├── login_viewmodel_test.dart
│   ├── home_viewmodel_test.dart
│   └── profile_viewmodel_test.dart
│
├── widget/
│   ├── app_button_test.dart
│   ├── app_text_field_test.dart
│   └── app_list_tile_test.dart
│
├── golden/
│   ├── goldens/                  # Golden image files
│   ├── app_button_golden_test.dart
│   └── login_view_golden_test.dart
│
└── integration/
    └── auth_flow_test.dart
```

---

## Don'ts

```dart
// ❌ Don't test implementation details
test('should call _privateMethod', () {}); // Test public behavior instead

// ❌ Don't use generic test names
test('test 1', () {});
test('it works', () {});

// ❌ Don't have multiple unrelated assertions
test('should login', () {
  expect(viewModel.email, '...');
  expect(viewModel.isBusy, true);
  expect(viewModel.user, isNotNull);
  // Split into multiple focused tests
});

// ❌ Don't test external libraries
test('DateTime.parse works', () {}); // Trust the library

// ❌ Don't forget to await async operations
test('should fetch user', () {
  viewModel.fetchUser(); // Missing await!
  expect(viewModel.user, isNotNull); // Will fail
});

// ❌ Don't leave print statements
test('debug test', () {
  print('User: $user'); // Remove before committing
});

// ❌ Don't hardcode values repeatedly
test('email test', () {
  viewModel.setEmail('test@example.com'); // Use const
});

// ✅ DO use test fixtures
const tEmail = 'test@example.com';
test('email test', () {
  viewModel.setEmail(tEmail);
});
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/viewmodels/login_viewmodel_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests matching a pattern
flutter test --name "should login"

# Update golden files
flutter test --update-goldens

# Run tests in watch mode (with build_runner)
dart run build_runner watch
```

# Write Tests

Generate comprehensive tests for a component.

## Test Details

- **Component to Test**: ${{input:What component to test? (e.g., LoginViewModel, AuthService, UserEntity)}}
- **Test Type**: ${{input:Type: unit, widget, or integration}}
- **File Path**: ${{input:Path to the file being tested}}

## Requirements

Generate test file at `test/<category>/<component_name>_test.dart`

### 1. Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Import component and dependencies
// ...

@GenerateMocks([
  // List dependencies to mock
])
import '<component_name>_test.mocks.dart';

void main() {
  // Declare component and mocks
  late ComponentType component;
  late MockDependency mockDep;

  setUp(() {
    // Initialize mocks
    mockDep = MockDependency();
    // Create component with mocks
    component = ComponentType(dep: mockDep);
  });

  tearDown(() {
    // Clean up
  });

  group('ComponentType', () {
    group('methodName', () {
      test('should do X when Y', () {
        // Arrange
        // Act
        // Assert
      });
    });
  });
}
```

### 2. Test Categories

#### Unit Tests (ViewModels, UseCases, Services)
- Test public methods
- Mock all dependencies
- Test success and failure paths
- Test state changes

#### Widget Tests
- Test UI rendering
- Test user interactions
- Test loading/error states
- Mock ViewModel or providers

#### Integration Tests
- Test multiple components together
- Use real implementations where possible
- Test user flows

### 3. Test Coverage Goals

Cover these scenarios:
- ✅ Happy path (success)
- ✅ Error handling (failures)
- ✅ Edge cases (empty, null, limits)
- ✅ State transitions (loading, success, error)
- ✅ Input validation

## Example Tests

### ViewModel Test
```dart
group('login', () {
  test('should set busy state while logging in', () async {
    when(mockRepo.login(any, any)).thenAnswer(
      (_) async => Right(UserEntity.mock()),
    );
    
    final future = viewModel.login();
    expect(viewModel.isBusy, isTrue);
    
    await future;
    expect(viewModel.isBusy, isFalse);
  });

  test('should set error on failure', () async {
    when(mockRepo.login(any, any)).thenAnswer(
      (_) async => const Left(AuthFailure('Invalid')),
    );
    
    await viewModel.login();
    
    expect(viewModel.hasError, isTrue);
  });
});
```

### Widget Test
```dart
testWidgets('should show loading indicator when busy', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LoginView(viewModel: mockViewModel),
    ),
  );
  
  when(mockViewModel.isBusy).thenReturn(true);
  await tester.pump();
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## After Generation

Run:
```bash
# Generate mocks
dart run build_runner build

# Run tests
flutter test test/<path>/<component_name>_test.dart

# With coverage
flutter test --coverage
```

## Guidelines

- Follow patterns from `test.instructions.md`
- Use descriptive test names: "should X when Y"
- One assertion per test (when practical)
- Use test fixtures for repeated data
- Mock external dependencies
- Test behavior, not implementation

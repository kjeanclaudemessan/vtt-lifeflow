---
applyTo: "**/*.dart"
---
# Dart Code Instructions

> These instructions apply to ALL Dart files in the workspace.
> Inherits from: `.github/copilot-instructions.md`

---

## Code Style

### Formatting

- Line length: **80 characters**
- Use **2 spaces** for indentation
- Always run `dart format` before committing
- Use trailing commas for better diffs

### Imports

Order imports in this sequence with blank lines between groups:

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. External packages (alphabetically)
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stacked/stacked.dart';

// 4. Project imports (alphabetically)
import 'package:vtt_flutter_template/core/core.dart';
import 'package:vtt_flutter_template/services/services.dart';
```

### Documentation

- Use `///` for public API documentation
- Use `//` for implementation comments
- Document all public classes, methods, and properties
- Include examples in documentation when helpful

```dart
/// A service that handles user authentication.
///
/// Example:
/// ```dart
/// final authService = locator<AuthService>();
/// await authService.login(email, password);
/// ```
class AuthService {
  /// Authenticates a user with email and password.
  ///
  /// Returns [Either] with [Failure] on error or [UserEntity] on success.
  Future<Either<Failure, UserEntity>> login(String email, String password);
}
```

---

## Class Structure

Follow this order within a class:

```dart
class MyClass {
  // 1. Static constants
  static const int maxRetries = 3;
  
  // 2. Static fields
  static final Logger _logger = Logger('MyClass');
  
  // 3. Instance fields (final first, then mutable)
  final String id;
  final AuthService _authService;
  String? _cachedValue;
  
  // 4. Constructors
  const MyClass({
    required this.id,
    required AuthService authService,
  }) : _authService = authService;
  
  // 5. Factory constructors
  factory MyClass.empty() => MyClass(id: '', authService: MockAuthService());
  
  // 6. Getters and setters
  bool get isValid => id.isNotEmpty;
  
  // 7. Public methods
  Future<void> doSomething() async { }
  
  // 8. Private methods
  void _internalMethod() { }
  
  // 9. Overrides
  @override
  String toString() => 'MyClass(id: $id)';
  
  @override
  bool operator ==(Object other) { }
  
  @override
  int get hashCode => id.hashCode;
}
```

---

## Null Safety

### Prefer Non-Nullable

```dart
// ✅ Good
final String name;
final List<String> items;

// ❌ Avoid when possible
final String? name;
final List<String>? items;
```

### Null Checks

```dart
// ✅ Good - use null-aware operators
final name = user?.name ?? 'Guest';
final length = items?.length ?? 0;

// ✅ Good - early return
if (user == null) return;
final name = user.name;

// ❌ Avoid - force unwrap without check
final name = user!.name; // Only when you're 100% sure
```

---

## Async/Await

### Always Use async/await

```dart
// ✅ Good
Future<User> fetchUser() async {
  final response = await api.get('/user');
  return User.fromJson(response.data);
}

// ❌ Avoid - then/catchError chains
Future<User> fetchUser() {
  return api.get('/user').then((response) {
    return User.fromJson(response.data);
  }).catchError((e) {
    throw ApiException(e);
  });
}
```

### Error Handling

```dart
// ✅ Good - return Either
Future<Either<Failure, User>> fetchUser() async {
  try {
    final response = await api.get('/user');
    return Right(User.fromJson(response.data));
  } catch (e) {
    return Left(ErrorHandler.handle(e));
  }
}

// ❌ Avoid - throwing exceptions
Future<User> fetchUser() async {
  try {
    final response = await api.get('/user');
    return User.fromJson(response.data);
  } catch (e) {
    throw ApiException(e); // Don't throw, return Left
  }
}
```

---

## Collections

### Prefer Collection Literals

```dart
// ✅ Good
final list = <String>[];
final map = <String, int>{};
final set = <String>{};

// ❌ Avoid
final list = List<String>();
final map = Map<String, int>();
final set = Set<String>();
```

### Collection Operations

```dart
// ✅ Good - use collection methods
final names = users.map((u) => u.name).toList();
final adults = users.where((u) => u.age >= 18).toList();
final hasAdmin = users.any((u) => u.isAdmin);

// ✅ Good - use spread operator
final allItems = [...items1, ...items2];

// ✅ Good - use collection if/for
final widgets = [
  Header(),
  for (final item in items) ItemTile(item),
  if (showFooter) Footer(),
];
```

---

## Type Annotations

### When to Use

```dart
// ✅ Required - public APIs
String getName() => _name;
Future<List<User>> fetchUsers() async { }

// ✅ Required - when type isn't obvious
final Map<String, List<int>> groupedIds = {};

// ✅ Optional - when type is obvious from assignment
final name = 'John'; // String is obvious
final count = 0; // int is obvious
final users = <User>[]; // Type parameter needed
```

---

## Constants

### Prefer const

```dart
// ✅ Good - const for compile-time constants
const maxRetries = 3;
const defaultPadding = EdgeInsets.all(16);

// ✅ Good - static const for class constants
class ApiConstants {
  static const baseUrl = 'https://api.example.com';
  static const timeout = Duration(seconds: 30);
}

// ✅ Good - const constructors for widgets
const SizedBox(height: 16);
const EdgeInsets.symmetric(horizontal: 16);
```

---

## Equality

### Use Equatable

```dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });
  
  @override
  List<Object?> get props => [id, name, email];
}
```

---

## Barrel Files

Use barrel files to simplify imports:

```dart
// core/core.dart
export 'config/app_config.dart';
export 'constants/constants.dart';
export 'enums/enums.dart';
export 'errors/errors.dart';
export 'extensions/extensions.dart';
export 'utils/utils.dart';

// Usage
import 'package:vtt_flutter_template/core/core.dart';
```

---

## Common Patterns

### Singleton Service

```dart
class AnalyticsService {
  // Don't manually implement singleton - use Stacked's LazySingleton
}

// In app.dart
@StackedApp(
  dependencies: [
    LazySingleton(classType: AnalyticsService),
  ],
)
```

### Extension Methods

```dart
extension StringExtensions on String {
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
```

### Typedef

```dart
// For function types
typedef JsonMap = Map<String, dynamic>;
typedef VoidCallback = void Function();
typedef AsyncCallback<T> = Future<T> Function();

// For complex types
typedef Result<T> = Either<Failure, T>;
typedef FutureResult<T> = Future<Either<Failure, T>>;
```

---

## Avoid

### Anti-Patterns

```dart
// ❌ Don't use dynamic
dynamic getData() { }

// ❌ Don't use var for public fields
var name = 'John';

// ❌ Don't ignore return values
fetchData(); // Should handle the result

// ❌ Don't use print for logging
print('Debug: $value'); // Use Logger instead

// ❌ Don't hardcode strings
Text('Login'); // Use localization

// ❌ Don't hardcode colors
color: Color(0xFF123456); // Use design system
```

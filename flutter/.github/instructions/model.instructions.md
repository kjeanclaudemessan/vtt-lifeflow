---
applyTo: "**/*_model.dart,**/models/**/*.dart"
---
# Model Instructions

> These instructions apply to all Model files (`*_model.dart`).
> Inherits from: `dart.instructions.md`

---

## Model Principles

### Models are Data Representations

- **JSON serializable** (for API communication)
- **Located in Data layer** (`lib/data/models/`)
- **Mirror API response structure**
- **Convert to/from Entities** for domain layer
- **Immutable** (use final fields)

---

## Model Structure

### Standard Model Template

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  
  @JsonKey(name: 'first_name')
  final String? firstName;
  
  @JsonKey(name: 'last_name')
  final String? lastName;
  
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;

  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  /// Creates a [UserModel] from JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to JSON map.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Converts this model to domain [UserEntity].
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isActive: isActive,
      );

  /// Creates a [UserModel] from domain [UserEntity].
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        firstName: entity.firstName,
        lastName: entity.lastName,
        avatarUrl: entity.avatarUrl,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isActive: entity.isActive,
      );

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        avatarUrl,
        createdAt,
        updatedAt,
        isActive,
      ];
}
```

---

## JSON Annotations

### Field Name Mapping

```dart
// API returns snake_case, Dart uses camelCase
@JsonKey(name: 'first_name')
final String? firstName;

@JsonKey(name: 'created_at')
final DateTime createdAt;

@JsonKey(name: 'is_verified')
final bool isVerified;
```

### Default Values

```dart
@JsonKey(defaultValue: 0)
final int count;

@JsonKey(defaultValue: false)
final bool isActive;

@JsonKey(defaultValue: [])
final List<String> tags;
```

### Nullable Fields

```dart
// Nullable with includeIfNull: false (won't include in JSON if null)
@JsonKey(includeIfNull: false)
final String? optionalField;
```

### Custom Converters

```dart
// For DateTime
@JsonKey(
  name: 'created_at',
  fromJson: _dateTimeFromJson,
  toJson: _dateTimeToJson,
)
final DateTime createdAt;

static DateTime _dateTimeFromJson(String date) => DateTime.parse(date);
static String _dateTimeToJson(DateTime date) => date.toIso8601String();
```

### Enum Handling

```dart
@JsonKey(unknownEnumValue: UserStatus.unknown)
final UserStatus status;

// Enum with custom values
enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('PENDING')
  pending,
  unknown,
}
```

---

## Nested Models

### Child Model

```dart
@JsonSerializable()
class OrderModel extends Equatable {
  final String id;
  final UserModel user;
  final List<OrderItemModel> items;
  final AddressModel? shippingAddress;
  
  const OrderModel({
    required this.id,
    required this.user,
    required this.items,
    this.shippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderEntity toEntity() => OrderEntity(
        id: id,
        user: user.toEntity(),
        items: items.map((i) => i.toEntity()).toList(),
        shippingAddress: shippingAddress?.toEntity(),
      );

  @override
  List<Object?> get props => [id, user, items, shippingAddress];
}
```

---

## Request Models

### For API requests (POST, PUT)

```dart
@JsonSerializable(createFactory: false)
class LoginRequestModel {
  final String email;
  final String password;
  
  @JsonKey(name: 'remember_me')
  final bool rememberMe;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}

@JsonSerializable(createFactory: false)
class UpdateUserRequestModel {
  @JsonKey(name: 'first_name', includeIfNull: false)
  final String? firstName;
  
  @JsonKey(name: 'last_name', includeIfNull: false)
  final String? lastName;
  
  @JsonKey(name: 'avatar_url', includeIfNull: false)
  final String? avatarUrl;

  const UpdateUserRequestModel({
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => _$UpdateUserRequestModelToJson(this);
}
```

---

## Response Models

### Paginated Response

```dart
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final MetaModel meta;

  const PaginatedResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [data, meta];
}

@JsonSerializable()
class MetaModel extends Equatable {
  @JsonKey(name: 'current_page')
  final int currentPage;
  
  @JsonKey(name: 'last_page')
  final int lastPage;
  
  @JsonKey(name: 'per_page')
  final int perPage;
  
  final int total;

  const MetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];
}
```

### API Response Wrapper

```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final bool success;
  final String? message;
  final T? data;
  final ApiErrorModel? error;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  @override
  List<Object?> get props => [success, message, data, error];
}
```

---

## CopyWith Support

```dart
@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;

  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
  });

  /// Creates a copy with the given fields replaced.
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
```

---

## Code Generation

### Generate JSON serialization code

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs
```

This generates `*.g.dart` files with `_$ModelNameFromJson` and `_$ModelNameToJson` functions.

---

## File Organization

```
lib/data/models/
├── base/
│   ├── base_model.dart
│   ├── paginated_response.dart
│   └── api_response.dart
├── auth/
│   ├── login_request_model.dart
│   ├── login_response_model.dart
│   ├── register_request_model.dart
│   └── auth_token_model.dart
├── user/
│   ├── user_model.dart
│   └── update_user_request_model.dart
└── common/
    ├── meta_model.dart
    └── api_error_model.dart
```

---

## Don'ts

```dart
// ❌ Don't include business logic
String get displayName => isVip ? '⭐ $name' : name; // Use Entity for this

// ❌ Don't have methods that mutate state
void updateName(String name) { } // Models are immutable

// ❌ Don't expose in domain layer
class UserUseCase {
  UserModel getUser(); // Return Entity, not Model
}

// ❌ Don't use dynamic
factory UserModel.fromJson(dynamic json) // Use Map<String, dynamic>

// ❌ Don't forget part directive
// Missing: part 'user_model.g.dart';
```

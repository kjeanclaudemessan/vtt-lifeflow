---
applyTo: "**/*_entity.dart,**/entities/**/*.dart"
---
# Entity Instructions

> These instructions apply to all Entity files (`*_entity.dart`).
> Inherits from: `dart.instructions.md`

---

## Entity Principles

### Entities are Pure Domain Objects

- **NO external dependencies** (no packages except Dart core + equatable)
- **NO JSON serialization** (that's Model's job)
- **Located in Domain layer** (`lib/domain/entities/`)
- **Contain business attributes and computed properties**
- **Immutable** (use final fields)

---

## Entity Structure

### Standard Entity Template

```dart
import 'package:equatable/equatable.dart';

/// Represents a user in the domain layer.
///
/// This entity contains all user-related business logic and computed properties.
/// It is framework-agnostic and does not depend on any external packages.
class UserEntity extends Equatable {
  /// Unique identifier of the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's first name (optional).
  final String? firstName;

  /// User's last name (optional).
  final String? lastName;

  /// URL to user's avatar image.
  final String? avatarUrl;

  /// When the user account was created.
  final DateTime createdAt;

  /// When the user account was last updated.
  final DateTime? updatedAt;

  /// Whether the user account is active.
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties (Business Logic)
  // ─────────────────────────────────────────────────────────────────

  /// Full name combining first and last name.
  /// Returns email if no name is set.
  String get fullName {
    if (firstName == null && lastName == null) {
      return email;
    }
    return [firstName, lastName].whereType<String>().join(' ').trim();
  }

  /// User's initials (max 2 characters).
  String get initials {
    if (firstName == null && lastName == null) {
      return email.substring(0, 1).toUpperCase();
    }
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return '$first$last'.toUpperCase();
  }

  /// Whether the user has a profile picture.
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Whether the user has completed their profile.
  bool get isProfileComplete =>
      firstName != null &&
      lastName != null &&
      firstName!.isNotEmpty &&
      lastName!.isNotEmpty;

  /// How long ago the user was created.
  Duration get accountAge => DateTime.now().difference(createdAt);

  /// Whether this is a new user (created within last 7 days).
  bool get isNewUser => accountAge.inDays <= 7;

  // ─────────────────────────────────────────────────────────────────
  // CopyWith
  // ─────────────────────────────────────────────────────────────────

  /// Creates a copy of this entity with the given fields replaced.
  UserEntity copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Equatable
  // ─────────────────────────────────────────────────────────────────

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

  // ─────────────────────────────────────────────────────────────────
  // Factory Constructors (Optional)
  // ─────────────────────────────────────────────────────────────────

  /// Creates an empty user entity (useful for initial state).
  factory UserEntity.empty() => UserEntity(
        id: '',
        email: '',
        createdAt: DateTime.now(),
      );

  /// Creates a mock user entity (useful for testing/preview).
  factory UserEntity.mock() => UserEntity(
        id: 'mock-user-id',
        email: 'john.doe@example.com',
        firstName: 'John',
        lastName: 'Doe',
        avatarUrl: 'https://example.com/avatar.png',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
      );
}
```

---

## Entity with Nested Entities

```dart
class OrderEntity extends Equatable {
  final String id;
  final UserEntity customer;
  final List<OrderItemEntity> items;
  final AddressEntity? shippingAddress;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  const OrderEntity({
    required this.id,
    required this.customer,
    required this.items,
    this.shippingAddress,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
  });

  // Computed properties
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  
  double get tax => subtotal * 0.1; // 10% tax
  
  double get total => subtotal + tax;
  
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;
  
  bool get isDelivered => status == OrderStatus.delivered;
  
  Duration? get deliveryTime {
    if (deliveredAt == null) return null;
    return deliveredAt!.difference(createdAt);
  }

  @override
  List<Object?> get props => [
        id,
        customer,
        items,
        shippingAddress,
        status,
        createdAt,
        deliveredAt,
      ];
}

class OrderItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
  });

  double get total => unitPrice * quantity;

  @override
  List<Object?> get props => [id, productId, productName, unitPrice, quantity];
}
```

---

## Entity with Enums

```dart
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum UserRole {
  user,
  admin,
  moderator,
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isModerator => role == UserRole.moderator;
  bool get hasModeratorAccess =>
      role == UserRole.admin || role == UserRole.moderator;

  @override
  List<Object?> get props => [id, email, role];
}
```

---

## Entity Validation

```dart
class EmailEntity extends Equatable {
  final String value;

  const EmailEntity._(this.value);

  /// Creates an EmailEntity if valid, throws otherwise.
  factory EmailEntity(String email) {
    if (!_isValid(email)) {
      throw ArgumentError('Invalid email: $email');
    }
    return EmailEntity._(email.toLowerCase().trim());
  }

  /// Creates an EmailEntity if valid, returns null otherwise.
  static EmailEntity? tryCreate(String email) {
    if (!_isValid(email)) return null;
    return EmailEntity._(email.toLowerCase().trim());
  }

  static bool _isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
```

---

## File Organization

```
lib/domain/entities/
├── user_entity.dart
├── auth/
│   └── session_entity.dart
├── order/
│   ├── order_entity.dart
│   └── order_item_entity.dart
├── product/
│   └── product_entity.dart
└── common/
    └── address_entity.dart
```

---

## Comparison: Entity vs Model

| Aspect | Entity | Model |
|--------|--------|-------|
| **Layer** | Domain | Data |
| **Purpose** | Business logic | API communication |
| **JSON** | No | Yes |
| **Dependencies** | Equatable only | json_annotation, etc. |
| **Computed props** | Yes (business logic) | Minimal |
| **Used by** | UseCases, ViewModels | Repositories, DataSources |

---

## Don'ts

```dart
// ❌ Don't add JSON annotations
@JsonSerializable() // This belongs in Model
class UserEntity { }

// ❌ Don't add external dependencies
import 'package:dio/dio.dart'; // No external packages

// ❌ Don't have side effects
void save() async {
  await api.post(...); // Entities don't call APIs
}

// ❌ Don't be mutable
String name; // Use final

// ❌ Don't reference Models
import '../data/models/user_model.dart'; // Domain doesn't know about Data

// ❌ Don't add toJson/fromJson
Map<String, dynamic> toJson() => { }; // This belongs in Model
```

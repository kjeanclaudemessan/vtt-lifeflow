# Create a Model with Entity

Create a data model and its corresponding domain entity.

## Model Details

- **Name**: ${{input:Enter the name (e.g., User, Order, Product)}}
- **API Endpoint**: ${{input:What API endpoint does this model represent? (e.g., /users, /orders)}}
- **Description**: ${{input:Briefly describe this data structure}}

## Requirements

Generate the following files:

### 1. Entity (Domain Layer)
`lib/domain/entities/<name>_entity.dart`:
- Pure Dart class with `Equatable`
- Business logic and computed properties
- `copyWith` method
- No JSON annotations
- Factory constructors for empty/mock states

### 2. Model (Data Layer)
`lib/data/models/<name>_model.dart`:
- `@JsonSerializable()` annotation
- `fromJson` / `toJson` methods
- `toEntity()` conversion method
- Handle null values from API
- Use `@JsonKey` for field mapping

### 3. Request/Response Models (if needed)
`lib/data/models/requests/<name>_request.dart`:
- For POST/PUT request bodies

`lib/data/models/responses/<name>_response.dart`:
- For paginated or wrapped responses

## Example Structure

For a `User` model:

### Entity
```dart
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  
  const UserEntity({...});
  
  // Computed properties
  String get fullName => '$firstName $lastName'.trim();
  bool get isProfileComplete => firstName != null && lastName != null;
  
  // copyWith, props, factories
}
```

### Model
```dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  
  const UserModel({...});
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
}
```

## After Generation

Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Guidelines

- Follow patterns from `entity.instructions.md` and `model.instructions.md`
- Entity = business logic, Model = JSON serialization
- Use snake_case for JSON keys (API convention)
- Use camelCase for Dart properties
- Always handle nullable fields from API

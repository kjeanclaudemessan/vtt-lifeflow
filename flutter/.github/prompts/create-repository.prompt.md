# Create a New Repository

Create a repository following Clean Architecture principles.

## Repository Details

- **Repository Name**: ${{input:Enter the repository name (e.g., user, order, product)}}
- **Description**: ${{input:Briefly describe what data this repository manages}}
- **Has Offline Support**: ${{input:Should this support offline mode? (yes/no)}}

## Requirements

Generate the following:

### 1. Repository Interface (Domain Layer)
Create `lib/domain/repositories/i_<name>_repository.dart`:
- Define abstract methods
- Use `Either<Failure, T>` for all return types
- Use domain entities, NOT models
- Document all methods

### 2. Repository Implementation (Data Layer)
Create `lib/data/repositories/<name>_repository_impl.dart`:
- Implement the interface
- Inject data sources (API, local storage)
- Convert models to entities
- Handle errors with ErrorHandler

### 3. Related Files (if needed)

#### Entity (if not exists)
Create `lib/domain/entities/<name>_entity.dart`

#### Model (if not exists)
Create `lib/data/models/<name>_model.dart`:
- Include `@JsonSerializable()`
- Include `toEntity()` method

#### Mapper (optional)
Create `lib/data/mappers/<name>_mapper.dart` for complex conversions

### 4. Registration
Update `app.dart`:
```dart
LazySingleton(classType: <Name>RepositoryImpl, asType: I<Name>Repository),
```

## Offline Support Pattern

If offline support is needed:

```dart
class UserRepositoryImpl implements IUserRepository {
  final ApiService _api;
  final LocalStorageService _storage;
  final ConnectivityService _connectivity;

  @override
  Future<Either<Failure, UserEntity>> getUser(String id) async {
    // Try network first
    if (await _connectivity.isConnected) {
      final result = await _api.get('/users/$id');
      if (result.isRight()) {
        // Cache for offline
        await _storage.save('user_$id', result.getOrElse(() => null));
      }
      return result;
    }
    
    // Fallback to cache
    final cached = await _storage.get<UserModel>('user_$id');
    if (cached != null) {
      return Right(cached.toEntity());
    }
    
    return const Left(NetworkFailure('No connection and no cached data'));
  }
}
```

## Guidelines

- Follow patterns from `repository.instructions.md`
- Interface in domain, implementation in data
- Always use Either<Failure, T>
- Convert Model → Entity at repository boundary

---
applyTo: "**/*_repository*.dart,**/repositories/**/*.dart"
---
# Repository Instructions

> These instructions apply to Repository files (interfaces and implementations).
> Inherits from: `dart.instructions.md`

---

## Repository Principles

### Repositories Bridge Domain and Data

- **Define contracts** in Domain layer (interfaces)
- **Implement contracts** in Data layer
- **Return Either<Failure, T>** for all operations
- **Convert Models ↔ Entities** at repository boundary
- **Handle all data source errors** and convert to Failures

---

## Repository Contract (Interface)

### Location

`lib/domain/repositories/i_<name>_repository.dart`

### Template

```dart
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Contract for user data operations.
///
/// Implementations:
/// - [UserRepositoryImpl] - API-based implementation
/// - [UserRepositorySupabaseImpl] - Supabase-based implementation
abstract class IUserRepository {
  /// Fetches the current authenticated user.
  ///
  /// Returns [UserEntity] on success, [Failure] on error.
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Fetches a user by their ID.
  ///
  /// Returns [UserEntity] on success, [NotFoundFailure] if user doesn't exist.
  Future<Either<Failure, UserEntity>> getUserById(String id);

  /// Updates the user profile.
  ///
  /// Returns updated [UserEntity] on success.
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);

  /// Deletes the user account.
  ///
  /// Returns [Unit] on success (void equivalent in Either).
  Future<Either<Failure, Unit>> deleteUser(String id);

  /// Fetches a paginated list of users.
  ///
  /// [page] starts at 1, [limit] defaults to 20.
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int limit = 20,
  });

  /// Searches users by query.
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}
```

### Naming Convention

- Always prefix with `I` (for Interface)
- File: `i_<name>_repository.dart`
- Class: `I<Name>Repository`

---

## Repository Implementation

### Location

`lib/data/repositories/<name>_repository_impl.dart`

### Template

```dart
import 'package:dartz/dartz.dart';

import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../services/api/api_service.dart';
import '../datasources/remote/user_remote_datasource.dart';
import '../models/user/user_model.dart';

class UserRepositoryImpl implements IUserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Try cache first
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      // Fetch from remote
      final userModel = await _remoteDataSource.getCurrentUser();
      
      // Cache the result
      await _localDataSource.cacheUser(userModel);
      
      // Convert Model to Entity and return
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final userModel = await _remoteDataSource.getUserById(id);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedModel = await _remoteDataSource.updateUser(userModel);
      
      // Update cache
      await _localDataSource.cacheUser(updatedModel);
      
      return Right(updatedModel.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(String id) async {
    try {
      await _remoteDataSource.deleteUser(id);
      await _localDataSource.clearCache();
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getUsers(page: page, limit: limit);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final models = await _remoteDataSource.searchUsers(query);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
```

### Naming Convention

- File: `<name>_repository_impl.dart`
- Class: `<Name>RepositoryImpl`
- Implements the interface: `implements I<Name>Repository`

---

## Multiple Implementations

### When to Use

When you need different data sources (API, Supabase, Mock):

```dart
// API implementation
class AuthRepositoryImpl implements IAuthRepository {
  final ApiService _apiService;
  // ...
}

// Supabase implementation
class AuthRepositorySupabaseImpl implements IAuthRepository {
  final SupabaseClient _supabaseClient;
  // ...
}

// Mock implementation (for testing/development)
class AuthRepositoryMock implements IAuthRepository {
  @override
  Future<Either<Failure, UserEntity>> login(...) async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(UserEntity.mock());
  }
}
```

### Registration

```dart
@StackedApp(
  dependencies: [
    // Choose implementation based on environment
    LazySingleton(
      classType: AuthRepositoryImpl, // or AuthRepositorySupabaseImpl
      asType: IAuthRepository,
    ),
  ],
)
```

---

## DataSource Integration

### Remote DataSource

```dart
class UserRemoteDataSource {
  final ApiService _apiService;

  UserRemoteDataSource(this._apiService);

  Future<UserModel> getCurrentUser() async {
    final response = await _apiService.get('/users/me');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> getUserById(String id) async {
    final response = await _apiService.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(UserModel user) async {
    final response = await _apiService.put(
      '/users/${user.id}',
      data: user.toJson(),
    );
    return UserModel.fromJson(response.data);
  }

  Future<void> deleteUser(String id) async {
    await _apiService.delete('/users/$id');
  }
}
```

### Local DataSource (Cache)

```dart
class UserLocalDataSource {
  final LocalStorageService _storage;
  
  static const String _userKey = 'cached_user';

  UserLocalDataSource(this._storage);

  Future<UserModel?> getCachedUser() async {
    final json = _storage.getObject(_userKey);
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  Future<void> cacheUser(UserModel user) async {
    await _storage.setObject(_userKey, user.toJson());
  }

  Future<void> clearCache() async {
    await _storage.remove(_userKey);
  }
}
```

---

## Offline Support Pattern

```dart
class ProductRepositoryImpl implements IProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    if (_connectivityService.isOnline) {
      try {
        // Online: fetch from API
        final models = await _remoteDataSource.getProducts();
        
        // Cache for offline use
        await _localDataSource.cacheProducts(models);
        
        return Right(models.map((m) => m.toEntity()).toList());
      } catch (e) {
        // API failed, try cache
        return _getFromCache();
      }
    } else {
      // Offline: use cache
      return _getFromCache();
    }
  }

  Future<Either<Failure, List<ProductEntity>>> _getFromCache() async {
    try {
      final cached = await _localDataSource.getCachedProducts();
      if (cached.isEmpty) {
        return Left(CacheFailure(message: 'No cached data available'));
      }
      return Right(cached.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to read cache'));
    }
  }
}
```

---

## Registration

### In app.dart

```dart
@StackedApp(
  dependencies: [
    // DataSources
    LazySingleton(classType: UserRemoteDataSource),
    LazySingleton(classType: UserLocalDataSource),
    
    // Repositories (always with interface)
    LazySingleton(classType: UserRepositoryImpl, asType: IUserRepository),
    LazySingleton(classType: AuthRepositoryImpl, asType: IAuthRepository),
    LazySingleton(classType: ProductRepositoryImpl, asType: IProductRepository),
  ],
)
```

---

## Don'ts

```dart
// ❌ Don't expose Models from repository
Future<Either<Failure, UserModel>> getUser(); // Return Entity, not Model

// ❌ Don't throw exceptions
throw NotFoundException(); // Return Left(NotFoundFailure())

// ❌ Don't have business logic
if (user.subscriptionExpired) { } // Business logic belongs in UseCase

// ❌ Don't call UI
showError('Failed'); // Repository doesn't know about UI

// ❌ Don't register without interface
LazySingleton(classType: UserRepositoryImpl); // Always use asType

// ❌ Don't access other repositories
final other = locator<IOtherRepository>(); // Use composition in UseCase
```

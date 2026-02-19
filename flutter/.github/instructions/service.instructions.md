---
applyTo: "**/services/**/*.dart"
---
# Service Instructions

> These instructions apply to all Service files in `services/` directory.
> Inherits from: `dart.instructions.md`

---

## Service Principles

### Services are Technical Helpers

- **Wrap external dependencies** (APIs, storage, device features)
- **Provide clean interfaces** to the rest of the app
- **Handle technical concerns** (not business logic)
- **Are singleton** (one instance throughout app lifecycle)

---

## Service Structure

### Standard Service Template

```dart
import 'package:stacked/stacked.dart';

import '../../app/app.locator.dart';
import '../../core/errors/failures.dart';

/// Service that handles [description].
///
/// Example:
/// ```dart
/// final service = locator<MyService>();
/// final result = await service.doSomething();
/// ```
class MyService with ListenableServiceMixin {
  // 1. Dependencies
  final _otherService = locator<OtherService>();

  // 2. Reactive values (if needed)
  final _isConnected = ReactiveValue<bool>(false);
  bool get isConnected => _isConnected.value;

  // 3. Constructor
  MyService() {
    listenToReactiveValues([_isConnected]);
  }

  // 4. Initialization (if needed)
  Future<void> init() async {
    // Initialize service
  }

  // 5. Public methods
  Future<Either<Failure, Data>> getData() async {
    try {
      // Implementation
      return Right(data);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // 6. Private helper methods
  void _handleInternalLogic() {
    // Internal logic
  }

  // 7. Cleanup (if needed)
  void dispose() {
    // Cleanup resources
  }
}
```

---

## Service Types

### Simple Service

No reactive state, just methods:

```dart
class UrlLauncherService {
  Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }

  Future<bool> sendEmail(String email, {String? subject, String? body}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    return launchUrl(uri);
  }

  Future<bool> makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    return launchUrl(uri);
  }
}
```

### Reactive Service

Exposes state that ViewModels can listen to:

```dart
class ConnectivityService with ListenableServiceMixin {
  final _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  final _isOnline = ReactiveValue<bool>(true);
  final _connectionType = ReactiveValue<ConnectivityResult>(
    ConnectivityResult.none,
  );

  bool get isOnline => _isOnline.value;
  ConnectivityResult get connectionType => _connectionType.value;

  ConnectivityService() {
    listenToReactiveValues([_isOnline, _connectionType]);
  }

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(ConnectivityResult result) {
    _connectionType.value = result;
    _isOnline.value = result != ConnectivityResult.none;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
```

### Wrapper Service

Wraps an external package:

```dart
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  Future<bool> containsKey({required String key}) {
    return _storage.containsKey(key: key);
  }
}
```

---

## Service Categories

### API Service

```dart
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
```

### Storage Service

```dart
class LocalStorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  // Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  // Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int getInt(String key, {int defaultValue = 0}) =>
      _prefs.getInt(key) ?? defaultValue;

  // Double
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);
  double getDouble(String key, {double defaultValue = 0.0}) =>
      _prefs.getDouble(key) ?? defaultValue;

  // Object (JSON)
  Future<bool> setObject(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));
  
  Map<String, dynamic>? getObject(String key) {
    final string = _prefs.getString(key);
    if (string == null) return null;
    return jsonDecode(string) as Map<String, dynamic>;
  }

  // List
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  List<String> getStringList(String key) => _prefs.getStringList(key) ?? [];

  // Delete
  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
  bool containsKey(String key) => _prefs.containsKey(key);
}
```

### Auth Service

```dart
class AuthService with ListenableServiceMixin {
  final _tokenService = locator<TokenService>();
  final _authRepository = locator<IAuthRepository>();

  final _authStatus = ReactiveValue<AuthStatus>(AuthStatus.unknown);
  final _currentUser = ReactiveValue<UserEntity?>(null);

  AuthStatus get authStatus => _authStatus.value;
  UserEntity? get currentUser => _currentUser.value;
  bool get isAuthenticated => _authStatus.value == AuthStatus.authenticated;

  AuthService() {
    listenToReactiveValues([_authStatus, _currentUser]);
  }

  Future<void> init() async {
    final hasToken = await _tokenService.hasValidToken();
    if (hasToken) {
      await _loadCurrentUser();
    } else {
      _authStatus.value = AuthStatus.unauthenticated;
    }
  }

  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => null,
      (user) {
        _currentUser.value = user;
        _authStatus.value = AuthStatus.authenticated;
      },
    );

    return result;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _tokenService.clearTokens();
    _currentUser.value = null;
    _authStatus.value = AuthStatus.unauthenticated;
  }

  Future<void> _loadCurrentUser() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        _authStatus.value = AuthStatus.unauthenticated;
      },
      (user) {
        _currentUser.value = user;
        _authStatus.value = AuthStatus.authenticated;
      },
    );
  }
}
```

---

## Registration

### In app.dart

```dart
@StackedApp(
  dependencies: [
    // Core services (initialize early)
    Singleton(classType: LocalStorageService),
    Singleton(classType: SecureStorageService),
    
    // Stacked services
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: SnackbarService),
    
    // App services
    LazySingleton(classType: ApiService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: TokenService),
    
    // Repositories (with interface)
    LazySingleton(classType: AuthRepositoryImpl, asType: IAuthRepository),
    LazySingleton(classType: UserRepositoryImpl, asType: IUserRepository),
  ],
)
```

---

## Service Initialization

### In bootstrap.dart

```dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup locator
  await setupLocator();
  
  // Initialize services that need async setup
  await locator<LocalStorageService>().init();
  await locator<ConnectivityService>().init();
  await locator<AuthService>().init();
  
  // Run app
  runApp(const MyApp());
}
```

---

## Error Handling in Services

### Return Either

```dart
class DataService {
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      final response = await _apiService.get('/items');
      final items = (response.data as List)
          .map((json) => ItemModel.fromJson(json).toEntity())
          .toList();
      return Right(items);
    } on DioException catch (e) {
      return Left(ErrorHandler.handleDio(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

---

## Don'ts

```dart
// ❌ Don't have business logic in services
if (user.age >= 18 && user.hasPermission) {
  // This is business logic - belongs in UseCase or ViewModel
}

// ❌ Don't expose external types directly
Dio get dio => _dio; // Don't expose Dio, wrap it

// ❌ Don't throw exceptions
throw ApiException('Failed'); // Return Either instead

// ❌ Don't create services manually
final service = MyService(); // Use locator<MyService>()

// ❌ Don't access UI from services
showDialog(...); // Services don't know about UI
```

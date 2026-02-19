# 🏗️ VTT Flutter Template - Architecture & Features

> **Version**: 1.0.0  
> **Dernière mise à jour**: 21 Janvier 2026  
> **Auteur**: VTT Team

---

## 📋 Table des Matières

1. [Vue d'Ensemble](#vue-densemble)
2. [Principes Architecturaux](#principes-architecturaux)
3. [Structure des Dossiers](#structure-des-dossiers)
4. [Couches de l'Architecture](#couches-de-larchitecture)
5. [Design System](#design-system)
6. [Services](#services)
7. [Features](#features)
8. [Gestion des Erreurs](#gestion-des-erreurs)
9. [Internationalisation](#internationalisation)
10. [Navigation](#navigation)
11. [Tests](#tests)
12. [Environnements](#environnements)
13. [Conventions de Code](#conventions-de-code)

---

## 🎯 Vue d'Ensemble

### Objectif

Ce template fournit une base solide et flexible pour démarrer rapidement de nouveaux projets Flutter. Il inclut :

- ✅ Architecture MVVM avec **Stacked**
- ✅ Design System complet et personnalisable
- ✅ Authentification prête à l'emploi (API / Supabase)
- ✅ Services pré-configurés
- ✅ Internationalisation
- ✅ Gestion d'erreurs robuste
- ✅ Structure de tests
- ✅ Multi-environnements (dev/staging/prod)

### Stack Technique

| Catégorie | Technologie |
|-----------|-------------|
| Framework | Flutter 3.x |
| Architecture | MVVM avec Stacked |
| State Management | Stacked ViewModels |
| DI | GetIt + Stacked Locator |
| Navigation | Stacked Navigation Service |
| Backend | API REST / Supabase (configurable) |
| Base locale | Hive / SharedPreferences |
| Tests | Flutter Test + Mockito + Golden Toolkit |

---

## 🧱 Principes Architecturaux

### 1. Clean Architecture Adaptée

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION                            │
│              (Views, ViewModels, Widgets)                   │
│         Dépend de: Domain, Design System                    │
├─────────────────────────────────────────────────────────────┤
│                       DOMAIN                                │
│           (Entities, UseCases, Contracts)                   │
│                  Dépend de: Rien                            │
├─────────────────────────────────────────────────────────────┤
│                        DATA                                 │
│        (Models, Repositories, DataSources)                  │
│              Dépend de: Domain, Services                    │
├─────────────────────────────────────────────────────────────┤
│                      SERVICES                               │
│            (API, Storage, Device, etc.)                     │
│                  Dépend de: Core                            │
├─────────────────────────────────────────────────────────────┤
│                        CORE                                 │
│        (Config, Utils, Extensions, Errors)                  │
│                  Dépend de: Rien                            │
└─────────────────────────────────────────────────────────────┘
```

### 2. Principes SOLID

| Principe | Application |
|----------|-------------|
| **S**ingle Responsibility | Chaque classe a une seule raison de changer |
| **O**pen/Closed | Extensions via interfaces, pas modifications |
| **L**iskov Substitution | Implémentations interchangeables |
| **I**nterface Segregation | Interfaces spécifiques et ciblées |
| **D**ependency Inversion | Dépendre des abstractions |

### 3. Règles de Dépendances

```
✅ Core         → Aucune dépendance interne
✅ Services     → Core uniquement
✅ Domain       → Aucune dépendance interne
✅ Data         → Domain, Services, Core
✅ Presentation → Domain, Services, Core, Design System
✅ Features     → Peuvent avoir leur propre Data/Domain/Presentation
```

### 4. Inversion de Contrôle

Toutes les dépendances sont injectées via le **Service Locator** (GetIt) :

```dart
// Enregistrement
locator.registerLazySingleton<IAuthRepository>(
  () => ApiAuthRepository(locator<ApiService>()),
);

// Utilisation
final authRepo = locator<IAuthRepository>();
```

---

## 📁 Structure des Dossiers

```
lib/
├── main.dart                         # Point d'entrée principal
├── main_dev.dart                     # Entry point développement
├── main_staging.dart                 # Entry point staging
├── main_prod.dart                    # Entry point production
├── bootstrap.dart                    # Initialisation de l'app
│
├── app/                              # Configuration Stacked
│   ├── app.dart                      # @StackedApp annotation
│   ├── app.locator.dart              # Service Locator (généré)
│   ├── app.router.dart               # Router (généré)
│   ├── app.dialogs.dart              # Dialogs (généré)
│   ├── app.bottomsheets.dart         # BottomSheets (généré)
│   └── app.logger.dart               # Configuration Logger
│
├── core/                             # Fondations partagées
│   ├── config/                       # Configuration app
│   ├── constants/                    # Constantes globales
│   ├── enums/                        # Énumérations
│   ├── errors/                       # Gestion erreurs
│   ├── extensions/                   # Extensions Dart
│   ├── mixins/                       # Mixins réutilisables
│   ├── utils/                        # Utilitaires
│   ├── typedefs/                     # Alias de types
│   └── guards/                       # Route guards
│
├── data/                             # Couche Data
│   ├── datasources/                  # Sources de données
│   │   ├── local/                    # Stockage local
│   │   └── remote/                   # API / Supabase
│   ├── models/                       # Modèles de données
│   ├── repositories/                 # Implémentations repos
│   └── mappers/                      # Model ↔ Entity mappers
│
├── domain/                           # Couche Domain (pure)
│   ├── entities/                     # Entités métier
│   ├── repositories/                 # Contrats (interfaces)
│   ├── usecases/                     # Cas d'utilisation
│   └── value_objects/                # Objets valeur
│
├── services/                         # Services techniques
│   ├── api/                          # Client HTTP
│   ├── supabase/                     # Services Supabase
│   ├── auth/                         # Authentification
│   ├── storage/                      # Stockage
│   ├── network/                      # Réseau
│   ├── notification/                 # Notifications
│   ├── analytics/                    # Analytics
│   ├── device/                       # Device info
│   ├── media/                        # Images, fichiers
│   ├── location/                     # Géolocalisation
│   ├── security/                     # Sécurité
│   └── third_party/                  # Services tiers
│
├── features/                         # Features métier
│   ├── auth/                         # Authentification
│   ├── onboarding/                   # Onboarding
│   ├── profile/                      # Profil utilisateur
│   ├── settings/                     # Paramètres
│   ├── notifications/                # Centre de notifications
│   └── home/                         # Accueil
│
├── ui/                               # UI partagée
│   ├── views/                        # Vues système
│   ├── widgets/                      # Widgets réutilisables
│   ├── bottom_sheets/                # BottomSheets
│   ├── dialogs/                      # Dialogs
│   └── shared/                       # Base classes
│
├── design_system/                    # Design System
│   ├── theme/                        # Thèmes
│   ├── colors/                       # Couleurs
│   ├── typography/                   # Typographie
│   ├── spacing/                      # Espacements
│   ├── radius/                       # Border radius
│   ├── shadows/                      # Ombres
│   ├── borders/                      # Bordures
│   ├── icons/                        # Icônes
│   └── tokens/                       # Design tokens
│
├── l10n/                             # Internationalisation
│   ├── arb/                          # Fichiers ARB
│   └── generated/                    # Code généré
│
├── navigation/                       # Navigation
│   ├── app_router.dart
│   ├── route_names.dart
│   ├── route_guards.dart
│   ├── route_transitions.dart
│   └── deep_link_handler.dart
│
└── generated/                        # Code généré
    ├── assets.gen.dart
    └── l10n/
```

---

## 🏛️ Couches de l'Architecture

### 1. Core (`lib/core/`)

Contient les fondations partagées par toute l'application.

#### Config (`core/config/`)

```dart
// app_config.dart
class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final LogLevel logLevel;
  
  const AppConfig({...});
}

// Environnements
abstract class Env {
  static late AppConfig config;
  
  static void init(AppConfig config) {
    Env.config = config;
  }
}
```

#### Constants (`core/constants/`)

| Fichier | Contenu |
|---------|---------|
| `app_constants.dart` | Nom app, version min API, etc. |
| `api_constants.dart` | Endpoints, headers |
| `storage_keys.dart` | Clés SharedPreferences/SecureStorage |
| `asset_paths.dart` | Chemins des assets |
| `regex_patterns.dart` | Patterns de validation |
| `durations.dart` | Durées (animations, timeouts) |
| `dimensions.dart` | Dimensions fixes |

#### Enums (`core/enums/`)

```dart
// load_state.dart
enum LoadState {
  initial,
  loading,
  loaded,
  error,
  empty,
}

// auth_status.dart
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

// connectivity_status.dart
enum ConnectivityStatus {
  online,
  offline,
}
```

#### Errors (`core/errors/`)

```dart
// failures.dart
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });
}

class ServerFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }
class CacheFailure extends Failure { ... }
class AuthFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
class UnknownFailure extends Failure { ... }
```

#### Extensions (`core/extensions/`)

| Extension | Méthodes ajoutées |
|-----------|-------------------|
| `StringExtensions` | `isEmail`, `capitalize`, `isNullOrEmpty`, `toSlug` |
| `ContextExtensions` | `screenWidth`, `screenHeight`, `showSnackbar`, `theme` |
| `DateTimeExtensions` | `toFormattedString`, `isToday`, `timeAgo`, `isSameDay` |
| `ListExtensions` | `firstOrNull`, `groupBy`, `distinct`, `sortedBy` |
| `NumExtensions` | `toCurrency`, `toCompact`, `toPercentage` |
| `WidgetExtensions` | `withPadding`, `withMargin`, `centered`, `expanded` |
| `FutureExtensions` | `withMinDuration`, `withTimeout` |
| `EitherExtensions` | `getOrNull`, `getOrThrow`, `mapFailure` |

#### Utils (`core/utils/`)

| Utilitaire | Fonctionnalités |
|------------|-----------------|
| `validators.dart` | Validation email, password, phone, etc. |
| `formatters.dart` | Formatage dates, nombres, devises |
| `debouncer.dart` | Debounce pour recherche |
| `throttler.dart` | Throttle pour scroll |
| `retry_helper.dart` | Retry avec exponential backoff |

#### Guards (`core/guards/`)

```dart
// auth_guard.dart
class AuthGuard extends StackedRouteGuard {
  @override
  Future<bool> canNavigate(BuildContext context, String routeName) async {
    final authService = locator<AuthService>();
    if (!authService.isAuthenticated) {
      // Rediriger vers login
      return false;
    }
    return true;
  }
}
```

---

### 2. Domain (`lib/domain/`)

Couche métier **pure** sans dépendance externe.

#### Entities (`domain/entities/`)

```dart
// user_entity.dart
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final DateTime createdAt;
  
  String get fullName => '$firstName $lastName'.trim();
  
  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
```

#### Repository Contracts (`domain/repositories/`)

```dart
// i_auth_repository.dart
abstract class IAuthRepository {
  /// Stream de l'état d'authentification
  Stream<AuthStatus> get authStateChanges;
  
  /// Utilisateur courant (null si non connecté)
  UserEntity? get currentUser;
  
  /// Connexion par email/password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });
  
  /// Connexion via provider (Google, Apple, etc.)
  Future<Either<Failure, UserEntity>> loginWithProvider(AuthProvider provider);
  
  /// Inscription
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });
  
  /// Mot de passe oublié
  Future<Either<Failure, void>> forgotPassword(String email);
  
  /// Réinitialisation mot de passe
  Future<Either<Failure, void>> resetPassword({
    required String code,
    required String newPassword,
  });
  
  /// Vérification OTP
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });
  
  /// Rafraîchir le token
  Future<Either<Failure, void>> refreshToken();
  
  /// Déconnexion
  Future<Either<Failure, void>> logout();
}
```

#### UseCases (`domain/usecases/`)

```dart
// base_usecase.dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

// login_usecase.dart
class LoginParams extends Equatable {
  final String email;
  final String password;
  
  const LoginParams({required this.email, required this.password});
  
  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final IAuthRepository _authRepository;
  
  LoginUseCase(this._authRepository);
  
  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}
```

#### Value Objects (`domain/value_objects/`)

```dart
// email.dart
class Email extends Equatable {
  final String value;
  
  const Email._(this.value);
  
  factory Email.create(String input) {
    if (!_isValid(input)) {
      throw ValidationException('Email invalide');
    }
    return Email._(input.toLowerCase().trim());
  }
  
  static Either<ValidationFailure, Email> validate(String input) {
    if (_isValid(input)) {
      return Right(Email._(input.toLowerCase().trim()));
    }
    return Left(ValidationFailure(message: 'Email invalide'));
  }
  
  static bool _isValid(String input) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
  }
  
  @override
  List<Object?> get props => [value];
}
```

---

### 3. Data (`lib/data/`)

Implémentation concrète de la couche domain.

#### Models (`data/models/`)

```dart
// user_model.dart
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
  
  const UserModel({...});
  
  factory UserModel.fromJson(Map<String, dynamic> json) => 
    _$UserModelFromJson(json);
    
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  // Conversion vers Entity
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
  );
  
  // Création depuis Entity
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    avatarUrl: entity.avatarUrl,
    createdAt: entity.createdAt,
  );
}
```

#### DataSources (`data/datasources/`)

```dart
// remote/api_datasource.dart
abstract class IApiDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(RegisterRequest request);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class ApiDataSource implements IApiDataSource {
  final ApiService _apiService;
  
  ApiDataSource(this._apiService);
  
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _apiService.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data);
  }
}

// remote/supabase_datasource.dart
class SupabaseDataSource implements IApiDataSource {
  final SupabaseClient _client;
  
  SupabaseDataSource(this._client);
  
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return UserModel.fromSupabaseUser(response.user!);
  }
}
```

#### Repositories (`data/repositories/`)

```dart
// auth_repository_impl.dart
class AuthRepositoryImpl implements IAuthRepository {
  final IApiDataSource _remoteDataSource;
  final ILocalStorageDataSource _localDataSource;
  final INetworkInfo _networkInfo;
  
  AuthRepositoryImpl({
    required IApiDataSource remoteDataSource,
    required ILocalStorageDataSource localDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;
  
  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'Pas de connexion internet'));
    }
    
    try {
      final userModel = await _remoteDataSource.login(email, password);
      await _localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
```

---

### 4. Services (`lib/services/`)

Services techniques réutilisables.

#### API Service (`services/api/`)

```dart
// api_service.dart
class ApiService {
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: Env.config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
      RetryInterceptor(),
    ]);
  }
  
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.get(path, queryParameters: queryParameters, options: options);
  
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  
  // PUT, PATCH, DELETE...
}
```

#### Auth Service (`services/auth/`)

```dart
// auth_service.dart
class AuthService with ReactiveServiceMixin {
  final IAuthRepository _authRepository;
  final TokenService _tokenService;
  
  AuthService(this._authRepository, this._tokenService) {
    listenToReactiveValues([_authStatus, _currentUser]);
  }
  
  final _authStatus = ReactiveValue<AuthStatus>(AuthStatus.unknown);
  final _currentUser = ReactiveValue<UserEntity?>(null);
  
  AuthStatus get authStatus => _authStatus.value;
  UserEntity? get currentUser => _currentUser.value;
  bool get isAuthenticated => authStatus == AuthStatus.authenticated;
  
  Future<void> init() async {
    final hasToken = await _tokenService.hasValidToken();
    if (hasToken) {
      await _loadCurrentUser();
    } else {
      _authStatus.value = AuthStatus.unauthenticated;
    }
  }
  
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    final result = await _authRepository.login(email: email, password: password);
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
}
```

#### Storage Service (`services/storage/`)

```dart
// local_storage_service.dart
class LocalStorageService {
  late SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // String
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);
  
  // Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);
  
  // Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);
  
  // Object (JSON)
  Future<bool> setObject(String key, Map<String, dynamic> value) =>
    _prefs.setString(key, jsonEncode(value));
  Map<String, dynamic>? getObject(String key) {
    final string = _prefs.getString(key);
    return string != null ? jsonDecode(string) : null;
  }
  
  // Remove
  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();
}

// secure_storage_service.dart
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  Future<void> write(String key, String value) =>
    _storage.write(key: key, value: value);
    
  Future<String?> read(String key) => _storage.read(key: key);
  
  Future<void> delete(String key) => _storage.delete(key: key);
  
  Future<void> deleteAll() => _storage.deleteAll();
}
```

---

## 🎨 Design System

### Structure (`lib/design_system/`)

```
design_system/
├── theme/
│   ├── app_theme.dart              # ThemeData factory
│   ├── light_theme.dart            # Thème clair
│   ├── dark_theme.dart             # Thème sombre
│   └── theme_service.dart          # Gestion du thème
├── colors/
│   ├── app_colors.dart             # Couleurs de l'app
│   ├── color_palette.dart          # Palette complète
│   └── semantic_colors.dart        # success, error, warning...
├── typography/
│   ├── app_text_styles.dart        # Styles de texte
│   └── app_fonts.dart              # Fonts
├── spacing/
│   ├── app_spacing.dart            # Espacements (4, 8, 12, 16, 24, 32...)
│   ├── app_insets.dart             # EdgeInsets prédéfinis
│   └── app_gaps.dart               # SizedBox prédéfinis
├── radius/
│   └── app_radius.dart             # BorderRadius
├── shadows/
│   └── app_shadows.dart            # BoxShadow
├── borders/
│   └── app_borders.dart            # Bordures
└── tokens/
    └── design_tokens.dart          # Tous les tokens exportés
```

### Exemple: Couleurs

```dart
// colors/app_colors.dart
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  
  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onError = Color(0xFFFFFFFF);
  
  // Text
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textTertiary = Color(0xFF79747E);
  static const Color textDisabled = Color(0xFFCAC4D0);
  
  // Divider
  static const Color divider = Color(0xFFE7E0EC);
}
```

### Exemple: Spacing

```dart
// spacing/app_spacing.dart
abstract class AppSpacing {
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

// spacing/app_gaps.dart
abstract class AppGaps {
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);
  
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w24 = SizedBox(width: 24);
  static const SizedBox w32 = SizedBox(width: 32);
}
```

### Exemple: Typography

```dart
// typography/app_text_styles.dart
abstract class AppTextStyles {
  // Display
  static TextStyle displayLarge = GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );
  
  // Headlines
  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  
  // Title
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );
  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  
  // Body
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
  
  // Label
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
```

---

## 🔧 Services Disponibles

### Liste Complète

| Service | Description | Dépendances |
|---------|-------------|-------------|
| **ApiService** | Client HTTP avec intercepteurs | `dio` |
| **SupabaseService** | Wrapper Supabase complet | `supabase_flutter` |
| **AuthService** | Gestion authentification | - |
| **AuthStateService** | Stream état auth | `rxdart` |
| **TokenService** | Gestion tokens JWT | `flutter_secure_storage`, `jwt_decoder` |
| **BiometricAuthService** | Face ID / Fingerprint | `local_auth` |
| **SocialAuthService** | Google, Apple, Facebook | providers respectifs |
| **LocalStorageService** | Stockage simple | `shared_preferences` |
| **SecureStorageService** | Stockage sécurisé | `flutter_secure_storage` |
| **CacheService** | Cache en mémoire avec TTL | - |
| **DatabaseService** | Base locale | `hive` ou `isar` |
| **ConnectivityService** | Monitoring réseau | `connectivity_plus` |
| **WebSocketService** | Temps réel | `web_socket_channel` |
| **PushNotificationService** | Notifications push | `firebase_messaging` |
| **LocalNotificationService** | Notifications locales | `flutter_local_notifications` |
| **AnalyticsService** | Tracking événements | provider analytics |
| **CrashReportingService** | Rapport de crash | `firebase_crashlytics` |
| **DeviceInfoService** | Info appareil | `device_info_plus` |
| **PermissionService** | Gestion permissions | `permission_handler` |
| **PackageInfoService** | Info app | `package_info_plus` |
| **ImagePickerService** | Sélection images | `image_picker` |
| **ImageCompressionService** | Compression images | `flutter_image_compress` |
| **FileService** | Gestion fichiers | `file_picker` |
| **LocationService** | Géolocalisation | `geolocator` |
| **ShareService** | Partage natif | `share_plus` |
| **UrlLauncherService** | Ouverture URLs | `url_launcher` |
| **InAppReviewService** | Notation app | `in_app_review` |
| **InAppUpdateService** | Mise à jour | `in_app_update` |
| **RemoteConfigService** | Feature flags | `firebase_remote_config` |
| **ThemeService** | Gestion thème | - |
| **LocalizationService** | Gestion langue | `flutter_localizations` |

---

## 🧩 Features

### Structure d'une Feature

Chaque feature métier suit la structure :

```
features/
└── [feature_name]/
    ├── data/
    │   ├── datasources/
    │   │   ├── [feature]_local_datasource.dart
    │   │   └── [feature]_remote_datasource.dart
    │   ├── models/
    │   │   └── [model]_model.dart
    │   └── repositories/
    │       └── [feature]_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── [entity].dart
    │   ├── repositories/
    │   │   └── i_[feature]_repository.dart
    │   └── usecases/
    │       └── [action]_usecase.dart
    └── presentation/
        ├── views/
        │   └── [view_name]/
        │       ├── [view_name]_view.dart
        │       └── [view_name]_viewmodel.dart
        └── widgets/
            └── [widget_name].dart
```

### Features Incluses

#### 1. Auth (`features/auth/`)

| Vue | Description |
|-----|-------------|
| `LoginView` | Connexion email/password + social |
| `RegisterView` | Inscription avec validation |
| `ForgotPasswordView` | Demande reset password |
| `ResetPasswordView` | Nouveau mot de passe |
| `OtpVerificationView` | Vérification code OTP |

**Widgets spécifiques:**
- `SocialLoginButtons` - Boutons Google/Apple/Facebook
- `PasswordStrengthIndicator` - Indicateur force mot de passe
- `AuthHeader` - Header avec logo

#### 2. Onboarding (`features/onboarding/`)

| Vue | Description |
|-----|-------------|
| `OnboardingView` | Slides d'introduction |

**Widgets spécifiques:**
- `OnboardingPage` - Page de slide
- `PageIndicator` - Indicateur de page

#### 3. Profile (`features/profile/`)

| Vue | Description |
|-----|-------------|
| `ProfileView` | Affichage profil |
| `EditProfileView` | Modification profil |
| `ChangePasswordView` | Changement mot de passe |

#### 4. Settings (`features/settings/`)

| Vue | Description |
|-----|-------------|
| `SettingsView` | Liste des paramètres |
| `LanguageSettingsView` | Choix de la langue |
| `ThemeSettingsView` | Choix du thème |
| `NotificationSettingsView` | Préférences notifications |
| `PrivacySettingsView` | Confidentialité |

**Widgets spécifiques:**
- `SettingsTile` - Tuile de paramètre
- `SettingsSection` - Section de paramètres

#### 5. Notifications (`features/notifications/`)

| Vue | Description |
|-----|-------------|
| `NotificationsView` | Centre de notifications |

#### 6. Home (`features/home/`)

| Vue | Description |
|-----|-------------|
| `HomeView` | Page d'accueil |

---

## ⚠️ Gestion des Erreurs

### Hiérarchie des Failures

```
Failure (abstract)
├── NetworkFailure          # Pas de connexion
├── ServerFailure           # Erreur serveur (4xx, 5xx)
│   ├── UnauthorizedFailure # 401
│   ├── ForbiddenFailure    # 403
│   └── NotFoundFailure     # 404
├── CacheFailure            # Erreur cache local
├── AuthFailure             # Erreur authentification
│   ├── InvalidCredentials
│   ├── TokenExpired
│   └── AccountDisabled
├── ValidationFailure       # Erreur validation
└── UnknownFailure          # Erreur inconnue
```

### Error Handler Global

```dart
// error_handler.dart
class ErrorHandler {
  static Failure handleException(dynamic exception) {
    if (exception is DioException) {
      return _handleDioException(exception);
    }
    if (exception is SocketException) {
      return NetworkFailure(message: 'Pas de connexion internet');
    }
    if (exception is FormatException) {
      return ServerFailure(message: 'Format de réponse invalide');
    }
    return UnknownFailure(
      message: 'Une erreur inattendue est survenue',
      originalError: exception,
    );
  }
  
  static Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(message: 'Délai de connexion dépassé');
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception.response);
      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'Impossible de se connecter au serveur');
      default:
        return UnknownFailure(message: exception.message ?? 'Erreur réseau');
    }
  }
  
  static Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final message = _extractErrorMessage(response?.data);
    
    switch (statusCode) {
      case 400:
        return ValidationFailure(message: message);
      case 401:
        return UnauthorizedFailure(message: message);
      case 403:
        return ForbiddenFailure(message: message);
      case 404:
        return NotFoundFailure(message: message);
      case 500:
      case 502:
      case 503:
        return ServerFailure(message: 'Erreur serveur, réessayez plus tard');
      default:
        return ServerFailure(message: message, code: statusCode.toString());
    }
  }
}
```

---

## 🌍 Internationalisation

### Configuration

```yaml
# l10n.yaml
arb-dir: lib/l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n/generated
```

### Fichiers ARB

```json
// app_en.arb
{
  "@@locale": "en",
  "appName": "My App",
  "login": "Login",
  "register": "Register",
  "email": "Email",
  "password": "Password",
  "forgotPassword": "Forgot password?",
  "welcomeBack": "Welcome back, {name}!",
  "@welcomeBack": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

```json
// app_fr.arb
{
  "@@locale": "fr",
  "appName": "Mon App",
  "login": "Connexion",
  "register": "Inscription",
  "email": "Email",
  "password": "Mot de passe",
  "forgotPassword": "Mot de passe oublié ?",
  "welcomeBack": "Bon retour, {name} !",
  "itemCount": "{count, plural, =0{Aucun élément} =1{1 élément} other{{count} éléments}}"
}
```

### Utilisation

```dart
// Accès via context
Text(context.l10n.login)
Text(context.l10n.welcomeBack('John'))
Text(context.l10n.itemCount(5))

// Extension pour faciliter
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
```

### Langues Supportées

| Code | Langue | RTL |
|------|--------|-----|
| `en` | English | Non |
| `fr` | Français | Non |
| `ar` | العربية | Oui |
| `es` | Español | Non |

---

## 🧭 Navigation

### Configuration Routes

```dart
// navigation/route_names.dart
abstract class RouteNames {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  
  // Main
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Shell (bottom nav)
  static const String shell = '/';
}
```

### Guards

```dart
// Vérification authentification
class AuthGuard extends StackedRouteGuard {
  @override
  Future<bool> canNavigate(BuildContext context, String routeName) async {
    final authService = locator<AuthService>();
    return authService.isAuthenticated;
  }
}

// Vérification onboarding complété
class OnboardingGuard extends StackedRouteGuard {
  @override
  Future<bool> canNavigate(BuildContext context, String routeName) async {
    final storage = locator<LocalStorageService>();
    return storage.getBool(StorageKeys.onboardingCompleted) ?? false;
  }
}
```

### Deep Linking

```dart
// deep_link_handler.dart
class DeepLinkHandler {
  final NavigationService _navigationService;
  
  void handleDeepLink(Uri uri) {
    switch (uri.path) {
      case '/reset-password':
        final token = uri.queryParameters['token'];
        _navigationService.navigateTo(
          RouteNames.resetPassword,
          arguments: ResetPasswordArgs(token: token),
        );
        break;
      case '/product':
        final id = uri.queryParameters['id'];
        _navigationService.navigateTo(
          RouteNames.productDetail,
          arguments: ProductDetailArgs(id: id),
        );
        break;
    }
  }
}
```

---

## 🧪 Tests

### Structure

```
test/
├── unit/
│   ├── core/
│   │   ├── extensions/
│   │   └── utils/
│   ├── data/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   └── usecases/
│   └── services/
├── widget/
│   ├── widgets/
│   └── views/
├── integration/
│   └── flows/
├── golden/
│   └── screenshots/
├── helpers/
│   ├── test_helpers.dart
│   ├── test_helpers.mocks.dart
│   └── fakes/
└── fixtures/
    └── json/
```

### Test Helpers

```dart
// helpers/test_helpers.dart
@GenerateMocks([
  IAuthRepository,
  IUserRepository,
  ApiService,
  LocalStorageService,
  SecureStorageService,
  NavigationService,
])
void registerServices() {
  locator.registerSingleton<IAuthRepository>(MockIAuthRepository());
  locator.registerSingleton<ApiService>(MockApiService());
  // ...
}

void unregisterServices() {
  locator.reset();
}
```

### Exemple Test ViewModel

```dart
void main() {
  late LoginViewModel viewModel;
  late MockIAuthRepository mockAuthRepo;
  
  setUp(() {
    mockAuthRepo = MockIAuthRepository();
    viewModel = LoginViewModel(authRepository: mockAuthRepo);
  });
  
  group('LoginViewModel', () {
    test('should login successfully', () async {
      // Arrange
      when(mockAuthRepo.login(email: 'test@test.com', password: 'password'))
        .thenAnswer((_) async => Right(testUser));
      
      // Act
      await viewModel.login('test@test.com', 'password');
      
      // Assert
      expect(viewModel.hasError, false);
      verify(mockAuthRepo.login(email: 'test@test.com', password: 'password')).called(1);
    });
    
    test('should show error on failure', () async {
      // Arrange
      when(mockAuthRepo.login(email: any, password: any))
        .thenAnswer((_) async => Left(AuthFailure(message: 'Invalid credentials')));
      
      // Act
      await viewModel.login('test@test.com', 'wrong');
      
      // Assert
      expect(viewModel.hasError, true);
      expect(viewModel.modelError, 'Invalid credentials');
    });
  });
}
```

---

## 🌐 Environnements

### Configuration

```dart
// main_dev.dart
void main() {
  Env.init(DevEnv.config);
  runApp(const MyApp());
}

// main_staging.dart
void main() {
  Env.init(StagingEnv.config);
  runApp(const MyApp());
}

// main_prod.dart
void main() {
  Env.init(ProdEnv.config);
  runApp(const MyApp());
}
```

### Fichiers Env

```dart
// env/dev_env.dart
class DevEnv {
  static const config = AppConfig(
    appName: 'MyApp DEV',
    apiBaseUrl: 'https://api-dev.myapp.com',
    supabaseUrl: 'https://xxx.supabase.co',
    supabaseAnonKey: 'dev_key',
    enableAnalytics: false,
    enableCrashReporting: false,
    logLevel: LogLevel.verbose,
  );
}

// env/prod_env.dart
class ProdEnv {
  static const config = AppConfig(
    appName: 'MyApp',
    apiBaseUrl: 'https://api.myapp.com',
    supabaseUrl: 'https://xxx.supabase.co',
    supabaseAnonKey: 'prod_key',
    enableAnalytics: true,
    enableCrashReporting: true,
    logLevel: LogLevel.error,
  );
}
```

### Commandes de Build

```bash
# Development
flutter run --target lib/main_dev.dart

# Staging
flutter run --target lib/main_staging.dart

# Production
flutter run --target lib/main_prod.dart --release
```

---

## 📏 Conventions de Code

### Nommage

| Type | Convention | Exemple |
|------|------------|---------|
| Classes | PascalCase | `UserModel`, `LoginViewModel` |
| Fichiers | snake_case | `user_model.dart`, `login_view.dart` |
| Variables | camelCase | `userName`, `isLoading` |
| Constantes | camelCase ou SCREAMING_SNAKE_CASE | `maxRetries`, `API_TIMEOUT` |
| Privé | _prefix | `_privateMethod()`, `_internalState` |
| Interfaces | I prefix | `IAuthRepository`, `IUserService` |

### Structure d'un Fichier

```dart
// 1. Imports (groupés et ordonnés)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:myapp/core/core.dart';
import 'package:myapp/services/services.dart';

// 2. Part directives (si nécessaire)
part 'user_model.g.dart';

// 3. Documentation
/// Description de la classe
class MyClass {
  // 4. Constantes statiques
  static const int maxItems = 10;
  
  // 5. Champs (final d'abord, puis mutables)
  final String id;
  String? name;
  
  // 6. Constructeurs
  const MyClass({required this.id, this.name});
  
  // 7. Factory constructors
  factory MyClass.fromJson(Map<String, dynamic> json) => ...
  
  // 8. Getters/Setters
  bool get hasName => name != null;
  
  // 9. Méthodes publiques
  void doSomething() { }
  
  // 10. Méthodes privées
  void _internalMethod() { }
  
  // 11. Overrides
  @override
  String toString() => 'MyClass(id: $id)';
}
```

### Règles Stacked

```dart
// View - Uniquement UI, pas de logique
class LoginView extends StackedView<LoginViewModel> {
  @override
  Widget builder(context, viewModel, child) {
    // ✅ Bon
    return AppButton(
      onPressed: viewModel.login,
      isLoading: viewModel.isBusy,
    );
    
    // ❌ Mauvais - logique dans la vue
    return AppButton(
      onPressed: () async {
        await authService.login();
      },
    );
  }
  
  @override
  LoginViewModel viewModelBuilder(context) => LoginViewModel();
}

// ViewModel - Logique uniquement
class LoginViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  
  Future<void> login() async {
    final result = await runBusyFuture(
      _authService.login(email, password),
    );
    // Traitement...
  }
}
```

---

## 📚 Ressources

- [Stacked Documentation](https://stacked.filledstacks.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📝 Changelog

### Version 1.0.0 (21/01/2026)
- Initial template release
- Core architecture setup
- Design system foundation
- Auth module
- Base services

---
applyTo: "**/*_usecase.dart,**/usecases/**/*.dart"
---
# UseCase Instructions

> These instructions apply to all UseCase files (`*_usecase.dart`).
> Inherits from: `dart.instructions.md`

---

## UseCase Principles

### Single Responsibility

- **One use case = One business operation**
- Encapsulates a single piece of business logic
- Named with a verb (action) + noun (subject): `LoginUserUseCase`, `GetOrdersUseCase`
- Pure domain logic - no framework dependencies

### Location

- **Path**: `lib/domain/usecases/<feature>/`
- **Example**: `lib/domain/usecases/auth/login_user_usecase.dart`

---

## UseCase Structure

### Standard UseCase Template

```dart
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/i_auth_repository.dart';

/// Parameters required for the [LoginUserUseCase].
class LoginUserParams {
  final String email;
  final String password;

  const LoginUserParams({
    required this.email,
    required this.password,
  });
}

/// Use case for logging in a user with email and password.
///
/// This use case handles:
/// - User authentication
/// - Session creation
/// - Returning the authenticated user entity
///
/// Example:
/// ```dart
/// final result = await loginUserUseCase(
///   LoginUserParams(email: 'user@example.com', password: 'password'),
/// );
/// result.fold(
///   (failure) => showError(failure.message),
///   (user) => navigateToHome(user),
/// );
/// ```
class LoginUserUseCase {
  final IAuthRepository _authRepository;

  const LoginUserUseCase(this._authRepository);

  /// Executes the use case.
  ///
  /// Returns [Either] with:
  /// - [Failure] on error (invalid credentials, network error, etc.)
  /// - [UserEntity] on success
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) async {
    // Validate inputs (optional - can also be done in ViewModel)
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email is required'));
    }
    if (params.password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }
    if (params.password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    // Execute the operation
    return _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}
```

---

## UseCase Without Parameters

```dart
/// Use case for getting the currently authenticated user.
class GetCurrentUserUseCase {
  final IAuthRepository _authRepository;

  const GetCurrentUserUseCase(this._authRepository);

  /// Executes the use case.
  ///
  /// Returns the current user or null if not authenticated.
  Future<Either<Failure, UserEntity?>> call() {
    return _authRepository.getCurrentUser();
  }
}
```

---

## UseCase Returning Stream

```dart
/// Use case for watching authentication state changes.
class WatchAuthStateUseCase {
  final IAuthRepository _authRepository;

  const WatchAuthStateUseCase(this._authRepository);

  /// Returns a stream of authentication state changes.
  ///
  /// Emits:
  /// - [UserEntity] when user is authenticated
  /// - `null` when user is signed out
  Stream<UserEntity?> call() {
    return _authRepository.watchAuthState();
  }
}
```

---

## UseCase Returning List

```dart
/// Parameters for fetching orders with pagination.
class GetOrdersParams {
  final int page;
  final int pageSize;
  final OrderStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;

  const GetOrdersParams({
    this.page = 1,
    this.pageSize = 20,
    this.status,
    this.fromDate,
    this.toDate,
  });
}

/// Use case for fetching user orders with filters and pagination.
class GetOrdersUseCase {
  final IOrderRepository _orderRepository;

  const GetOrdersUseCase(this._orderRepository);

  Future<Either<Failure, List<OrderEntity>>> call(GetOrdersParams params) {
    return _orderRepository.getOrders(
      page: params.page,
      pageSize: params.pageSize,
      status: params.status,
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  }
}
```

---

## UseCase Combining Multiple Repositories

```dart
/// Use case for placing an order.
///
/// This use case orchestrates multiple repositories to complete an order.
class PlaceOrderUseCase {
  final IOrderRepository _orderRepository;
  final ICartRepository _cartRepository;
  final IPaymentRepository _paymentRepository;
  final IInventoryRepository _inventoryRepository;

  const PlaceOrderUseCase(
    this._orderRepository,
    this._cartRepository,
    this._paymentRepository,
    this._inventoryRepository,
  );

  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) async {
    // Step 1: Validate cart
    final cartResult = await _cartRepository.getCart();
    final cart = cartResult.fold(
      (failure) => null,
      (cart) => cart,
    );

    if (cart == null || cart.isEmpty) {
      return const Left(ValidationFailure('Cart is empty'));
    }

    // Step 2: Check inventory
    for (final item in cart.items) {
      final availableResult = await _inventoryRepository.checkAvailability(
        productId: item.productId,
        quantity: item.quantity,
      );

      final isAvailable = availableResult.fold(
        (failure) => false,
        (available) => available,
      );

      if (!isAvailable) {
        return Left(ValidationFailure('${item.productName} is out of stock'));
      }
    }

    // Step 3: Process payment
    final paymentResult = await _paymentRepository.processPayment(
      amount: cart.total,
      paymentMethodId: params.paymentMethodId,
    );

    return paymentResult.fold(
      (failure) => Left(failure),
      (payment) async {
        // Step 4: Create order
        final orderResult = await _orderRepository.createOrder(
          items: cart.items,
          paymentId: payment.id,
          shippingAddress: params.shippingAddress,
        );

        // Step 5: Clear cart on success
        orderResult.fold(
          (failure) => null,
          (order) => _cartRepository.clearCart(),
        );

        return orderResult;
      },
    );
  }
}

class PlaceOrderParams {
  final String paymentMethodId;
  final AddressEntity shippingAddress;

  const PlaceOrderParams({
    required this.paymentMethodId,
    required this.shippingAddress,
  });
}
```

---

## UseCase with Caching

```dart
/// Use case for fetching products with caching support.
class GetProductsUseCase {
  final IProductRepository _productRepository;
  final ICacheService _cacheService;

  static const _cacheKey = 'products_cache';
  static const _cacheDuration = Duration(minutes: 5);

  const GetProductsUseCase(
    this._productRepository,
    this._cacheService,
  );

  Future<Either<Failure, List<ProductEntity>>> call({
    bool forceRefresh = false,
  }) async {
    // Check cache first (unless forced refresh)
    if (!forceRefresh) {
      final cached = await _cacheService.get<List<ProductEntity>>(_cacheKey);
      if (cached != null) {
        return Right(cached);
      }
    }

    // Fetch from repository
    final result = await _productRepository.getProducts();

    // Cache on success
    result.fold(
      (failure) => null,
      (products) => _cacheService.set(
        _cacheKey,
        products,
        duration: _cacheDuration,
      ),
    );

    return result;
  }
}
```

---

## File Organization

```
lib/domain/usecases/
├── auth/
│   ├── login_user_usecase.dart
│   ├── logout_user_usecase.dart
│   ├── register_user_usecase.dart
│   ├── get_current_user_usecase.dart
│   ├── watch_auth_state_usecase.dart
│   └── reset_password_usecase.dart
├── user/
│   ├── update_profile_usecase.dart
│   └── delete_account_usecase.dart
├── order/
│   ├── get_orders_usecase.dart
│   ├── get_order_details_usecase.dart
│   ├── place_order_usecase.dart
│   └── cancel_order_usecase.dart
└── product/
    ├── get_products_usecase.dart
    ├── search_products_usecase.dart
    └── get_product_details_usecase.dart
```

---

## Registering UseCases

In `app.dart`:

```dart
@StackedApp(
  dependencies: [
    // Repositories first
    LazySingleton(classType: AuthRepositoryImpl, asType: IAuthRepository),
    LazySingleton(classType: OrderRepositoryImpl, asType: IOrderRepository),
    
    // Then UseCases (depend on repositories)
    LazySingleton(classType: LoginUserUseCase),
    LazySingleton(classType: GetCurrentUserUseCase),
    LazySingleton(classType: GetOrdersUseCase),
  ],
)
```

---

## Using UseCases in ViewModels

```dart
class LoginViewModel extends BaseViewModel {
  final LoginUserUseCase _loginUserUseCase;
  final NavigationService _navigationService;

  LoginViewModel({
    required LoginUserUseCase loginUserUseCase,
    required NavigationService navigationService,
  })  : _loginUserUseCase = loginUserUseCase,
        _navigationService = navigationService;

  String _email = '';
  String _password = '';

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;

  Future<void> login() async {
    final result = await runBusyFuture(
      _loginUserUseCase(LoginUserParams(
        email: _email,
        password: _password,
      )),
    );

    result.fold(
      (failure) => setError(failure.message),
      (user) => _navigationService.replaceWithHomeView(),
    );
  }
}
```

---

## Don'ts

```dart
// ❌ Don't put UI logic in UseCases
void showSnackbar(String message) { } // UI logic belongs in ViewModel

// ❌ Don't access BuildContext
BuildContext get context => _context; // UseCases are framework-agnostic

// ❌ Don't call other UseCases (orchestrate at ViewModel level)
final otherUseCase = OtherUseCase(); // Inject, don't instantiate

// ❌ Don't have multiple responsibilities
class AuthUseCase {
  login() { }
  logout() { }
  register() { }
} // Split into separate UseCases

// ❌ Don't mutate state
List<OrderEntity> _orders = [];
void addOrder(OrderEntity order) => _orders.add(order); // UseCases are stateless

// ❌ Don't use print for logging
print('Logging in...'); // Use a Logger service if needed

// ❌ Don't directly access external services
final response = await http.get(...); // Use Repository abstractions
```

---

## Testing UseCases

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late LoginUserUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = LoginUserUseCase(mockRepository);
  });

  group('LoginUserUseCase', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = UserEntity.mock();

    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(mockRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await useCase(LoginUserParams(
        email: tEmail,
        password: tPassword,
      ));

      // Assert
      expect(result, Right(tUser));
      verify(mockRepository.login(email: tEmail, password: tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when email is empty', () async {
      // Act
      final result = await useCase(LoginUserParams(
        email: '',
        password: tPassword,
      ));

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should be Left'),
      );
      verifyZeroInteractions(mockRepository);
    });
  });
}
```

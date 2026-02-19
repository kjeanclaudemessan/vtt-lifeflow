# Create UseCase

Create a business use case following Clean Architecture principles.

## UseCase Details

- **UseCase Name**: ${{input:Enter the use case name (e.g., LoginUser, GetOrders, UpdateProfile)}}
- **Feature**: ${{input:Which feature does this belong to? (e.g., auth, order, profile)}}
- **Description**: ${{input:Describe the business operation this use case performs}}

## Requirements

Generate the following:

### 1. UseCase Class
`lib/domain/usecases/<feature>/<name>_usecase.dart`:

```dart
class <Name>UseCase {
  final I<Repository>Repository _repository;
  
  const <Name>UseCase(this._repository);
  
  Future<Either<Failure, ResultType>> call(Params params) async {
    // Validation (optional)
    // Business logic
    // Repository call
  }
}
```

### 2. Parameters Class (if needed)
Include in the same file:

```dart
class <Name>Params {
  final String field1;
  final int field2;
  
  const <Name>Params({
    required this.field1,
    required this.field2,
  });
}
```

### 3. Registration
Add to `app.dart`:
```dart
LazySingleton(classType: <Name>UseCase),
```

## UseCase Patterns

### Query UseCase (GET)
```dart
class GetUserProfileUseCase {
  final IUserRepository _userRepository;
  
  const GetUserProfileUseCase(this._userRepository);
  
  Future<Either<Failure, UserEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}
```

### Command UseCase (POST/PUT)
```dart
class UpdateProfileUseCase {
  final IUserRepository _userRepository;
  
  const UpdateProfileUseCase(this._userRepository);
  
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    // Validate
    if (params.firstName.isEmpty) {
      return const Left(ValidationFailure('First name is required'));
    }
    
    // Execute
    return _userRepository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}
```

### Orchestration UseCase (multiple repos)
```dart
class PlaceOrderUseCase {
  final IOrderRepository _orderRepository;
  final ICartRepository _cartRepository;
  final IPaymentRepository _paymentRepository;
  
  const PlaceOrderUseCase(
    this._orderRepository,
    this._cartRepository,
    this._paymentRepository,
  );
  
  Future<Either<Failure, OrderEntity>> call(PlaceOrderParams params) async {
    // Step 1: Validate cart
    // Step 2: Process payment
    // Step 3: Create order
    // Step 4: Clear cart
  }
}
```

## Guidelines

- Follow patterns from `usecase.instructions.md`
- One use case = one business operation
- Use Either<Failure, T> for all returns
- Validate inputs before calling repository
- Keep use cases stateless
- Document the business operation

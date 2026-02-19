# Create API Endpoint Integration

Integrate a new API endpoint into the application.

## Endpoint Details

- **HTTP Method**: ${{input:HTTP method (GET, POST, PUT, DELETE, PATCH)}}
- **Endpoint Path**: ${{input:API endpoint path (e.g., /users, /orders/{id})}}
- **Feature**: ${{input:Which feature does this belong to? (e.g., auth, user, order)}}
- **Description**: ${{input:Describe what this endpoint does}}

## Requirements

Generate the following components:

### 1. Request Model (for POST/PUT/PATCH)
`lib/data/models/requests/<endpoint>_request.dart`:

```dart
@JsonSerializable()
class CreateOrderRequest {
  final List<OrderItemRequest> items;
  @JsonKey(name: 'shipping_address_id')
  final String shippingAddressId;
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  const CreateOrderRequest({
    required this.items,
    required this.shippingAddressId,
    required this.paymentMethodId,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
```

### 2. Response Model
`lib/data/models/responses/<endpoint>_response.dart`:

```dart
@JsonSerializable()
class OrderResponse {
  final OrderModel order;
  final String message;

  const OrderResponse({
    required this.order,
    required this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

// For paginated responses
@JsonSerializable()
class OrderListResponse {
  final List<OrderModel> data;
  final PaginationMeta meta;

  const OrderListResponse({
    required this.data,
    required this.meta,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);
}
```

### 3. Repository Method

Add to interface `lib/domain/repositories/i_<feature>_repository.dart`:
```dart
Future<Either<Failure, OrderEntity>> createOrder({
  required List<OrderItemEntity> items,
  required String shippingAddressId,
  required String paymentMethodId,
});
```

Add to implementation `lib/data/repositories/<feature>_repository_impl.dart`:
```dart
@override
Future<Either<Failure, OrderEntity>> createOrder({
  required List<OrderItemEntity> items,
  required String shippingAddressId,
  required String paymentMethodId,
}) async {
  try {
    final request = CreateOrderRequest(
      items: items.map((e) => OrderItemRequest.fromEntity(e)).toList(),
      shippingAddressId: shippingAddressId,
      paymentMethodId: paymentMethodId,
    );
    
    final response = await _apiService.post<OrderResponse>(
      '/orders',
      data: request.toJson(),
      fromJson: OrderResponse.fromJson,
    );
    
    return Right(response.order.toEntity());
  } catch (e) {
    return Left(ErrorHandler.handle(e));
  }
}
```

### 4. UseCase (optional but recommended)

`lib/domain/usecases/<feature>/create_order_usecase.dart`

### 5. Error Handling

The repository should handle these HTTP status codes:
- 200/201: Success
- 400: Bad Request → `ValidationFailure`
- 401: Unauthorized → `UnauthorizedFailure`
- 403: Forbidden → `ForbiddenFailure`
- 404: Not Found → `NotFoundFailure`
- 422: Validation Error → `ValidationFailure`
- 500+: Server Error → `ServerFailure`

## API Service Method Reference

```dart
// GET
final users = await _apiService.get<List<UserModel>>(
  '/users',
  queryParameters: {'page': 1, 'limit': 20},
  fromJson: (json) => (json['data'] as List)
      .map((e) => UserModel.fromJson(e))
      .toList(),
);

// POST
final order = await _apiService.post<OrderModel>(
  '/orders',
  data: request.toJson(),
  fromJson: OrderModel.fromJson,
);

// PUT
final user = await _apiService.put<UserModel>(
  '/users/${userId}',
  data: updateRequest.toJson(),
  fromJson: UserModel.fromJson,
);

// DELETE
await _apiService.delete('/orders/${orderId}');

// PATCH
final user = await _apiService.patch<UserModel>(
  '/users/${userId}',
  data: {'status': 'active'},
  fromJson: UserModel.fromJson,
);
```

## After Generation

Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Guidelines

- Use snake_case for JSON keys
- Handle all error cases
- Use Either<Failure, T> returns
- Convert Model → Entity at repository layer
- Document expected request/response format

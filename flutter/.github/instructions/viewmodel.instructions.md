---
applyTo: "**/*_viewmodel.dart"
---
# ViewModel Instructions

> These instructions apply to all ViewModel files (`*_viewmodel.dart`).
> Inherits from: `dart.instructions.md`

---

## ViewModel Principles

### ViewModels Handle ALL Logic

- **ALL business logic** lives in ViewModels
- **ALL state** is managed by ViewModels
- **ALL service calls** go through ViewModels
- ViewModels:
  - Expose state to Views
  - Handle user interactions
  - Coordinate with services/repositories
  - Manage navigation

---

## ViewModel Structure

### Standard ViewModel Template

```dart
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../domain/repositories/i_auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  // 1. Services (injected via locator)
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authRepository = locator<IAuthRepository>();

  // 2. Busy keys for multiple loading states
  static const String loginBusyKey = 'login';
  static const String forgotPasswordBusyKey = 'forgot';

  // 3. Private state fields
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;

  // 4. Public getters
  String get email => _email;
  String get password => _password;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  
  bool get canSubmit => 
      _email.isNotEmpty && 
      _password.isNotEmpty && 
      _emailError == null && 
      _passwordError == null;

  // 5. Setters with validation
  void setEmail(String value) {
    _email = value;
    _validateEmail();
    rebuildUi();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    rebuildUi();
  }

  // 6. Private validation methods
  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = null;
    } else if (!_email.contains('@')) {
      _emailError = 'Invalid email format';
    } else {
      _emailError = null;
    }
  }

  void _validatePassword() {
    if (_password.isEmpty) {
      _passwordError = null;
    } else if (_password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
    } else {
      _passwordError = null;
    }
  }

  // 7. Public actions
  Future<void> login() async {
    if (!canSubmit) return;

    final result = await runBusyFuture(
      _authRepository.login(_email, _password),
      busyObject: loginBusyKey,
    );

    result.fold(
      (failure) => _handleLoginError(failure),
      (user) => _handleLoginSuccess(user),
    );
  }

  // 8. Private handlers
  void _handleLoginError(Failure failure) {
    _dialogService.showDialog(
      title: 'Login Failed',
      description: failure.message,
    );
  }

  void _handleLoginSuccess(UserEntity user) {
    _navigationService.clearStackAndShow(Routes.homeView);
  }

  // 9. Initialization (optional)
  Future<void> init() async {
    // Called from onViewModelReady in View
  }

  // 10. Cleanup (optional)
  @override
  void dispose() {
    // Cleanup resources
    super.dispose();
  }
}
```

---

## State Management

### Reactive State

```dart
class ProfileViewModel extends BaseViewModel {
  // Private state
  UserEntity? _user;
  List<Post> _posts = [];
  
  // Public getters (Views read from these)
  UserEntity? get user => _user;
  List<Post> get posts => List.unmodifiable(_posts);
  bool get hasUser => _user != null;
  int get postCount => _posts.length;
  
  // State mutation (always call rebuildUi or notifyListeners)
  void setUser(UserEntity user) {
    _user = user;
    rebuildUi(); // Triggers View rebuild
  }
  
  void addPost(Post post) {
    _posts.add(post);
    rebuildUi();
  }
}
```

### Multiple Busy States

```dart
class OrderViewModel extends BaseViewModel {
  // Define busy keys
  static const String fetchOrdersBusyKey = 'fetchOrders';
  static const String submitOrderBusyKey = 'submitOrder';
  static const String cancelOrderBusyKey = 'cancelOrder';
  
  // Use specific busy key
  Future<void> fetchOrders() async {
    await runBusyFuture(
      _repository.getOrders(),
      busyObject: fetchOrdersBusyKey,
    );
  }
  
  Future<void> submitOrder() async {
    await runBusyFuture(
      _repository.submitOrder(_order),
      busyObject: submitOrderBusyKey,
    );
  }
  
  // Check specific busy state in View
  // viewModel.busy(OrderViewModel.fetchOrdersBusyKey)
}
```

### Error State

```dart
class DataViewModel extends BaseViewModel {
  Future<void> fetchData() async {
    final result = await runBusyFuture(_repository.getData());
    
    result.fold(
      (failure) => setError(failure), // Sets modelError
      (data) => _handleSuccess(data),
    );
  }
  
  void retry() {
    clearErrors(); // Clear error state
    fetchData();
  }
}

// In View:
// if (viewModel.hasError) { ... }
// viewModel.modelError.toString()
```

---

## Async Operations

### runBusyFuture

Use for all async operations - automatically manages `isBusy` state:

```dart
Future<void> loadData() async {
  // Sets isBusy = true, then false when complete
  final result = await runBusyFuture(_repository.getData());
  
  result.fold(
    (failure) => setError(failure.message),
    (data) => _data = data,
  );
}
```

### runErrorFuture

Use when you don't need busy state but want error handling:

```dart
Future<void> silentRefresh() async {
  final result = await runErrorFuture(_repository.refresh());
  // Won't show loading, but will catch errors
}
```

### Multiple Concurrent Operations

```dart
Future<void> init() async {
  await Future.wait([
    _loadUser(),
    _loadPosts(),
    _loadNotifications(),
  ]);
}

Future<void> _loadUser() async {
  final result = await runBusyFuture(
    _userRepository.getCurrentUser(),
    busyObject: 'loadUser',
  );
  result.fold((_) => null, (user) => _user = user);
}
```

---

## Service Injection

### Via Locator

```dart
class MyViewModel extends BaseViewModel {
  // Use locator for singleton services
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authService = locator<AuthService>();
  final _authRepository = locator<IAuthRepository>();
}
```

### Via Constructor (for testing)

```dart
class MyViewModel extends BaseViewModel {
  final IAuthRepository _authRepository;
  final NavigationService _navigationService;
  
  MyViewModel({
    IAuthRepository? authRepository,
    NavigationService? navigationService,
  }) : _authRepository = authRepository ?? locator<IAuthRepository>(),
       _navigationService = navigationService ?? locator<NavigationService>();
}
```

---

## Navigation

### Basic Navigation

```dart
void goToProfile() {
  _navigationService.navigateTo(Routes.profileView);
}

void goBack() {
  _navigationService.back();
}

void goBackWithResult(bool success) {
  _navigationService.back(result: success);
}
```

### With Arguments

```dart
void goToProductDetail(String productId) {
  _navigationService.navigateTo(
    Routes.productDetailView,
    arguments: ProductDetailViewArguments(productId: productId),
  );
}
```

### Clear Stack

```dart
void logout() {
  _authService.logout();
  _navigationService.clearStackAndShow(Routes.loginView);
}
```

### Replace Current

```dart
void completeOnboarding() {
  _navigationService.replaceWith(Routes.homeView);
}
```

---

## Dialogs & BottomSheets

### Show Dialog

```dart
Future<void> confirmDelete() async {
  final response = await _dialogService.showDialog(
    title: 'Delete Item',
    description: 'Are you sure you want to delete this item?',
    buttonTitle: 'Delete',
    cancelTitle: 'Cancel',
  );
  
  if (response?.confirmed == true) {
    await _deleteItem();
  }
}
```

### Custom Dialog

```dart
Future<void> showCustomDialog() async {
  final response = await _dialogService.showCustomDialog(
    variant: DialogType.confirmation,
    title: 'Custom Title',
    data: CustomDialogData(message: 'Custom data'),
  );
  
  if (response?.data != null) {
    // Handle response data
  }
}
```

### BottomSheet

```dart
Future<void> showOptions() async {
  final response = await _bottomSheetService.showCustomSheet(
    variant: BottomSheetType.options,
    data: ['Option 1', 'Option 2', 'Option 3'],
  );
  
  if (response?.data != null) {
    final selectedOption = response!.data as String;
    // Handle selection
  }
}
```

---

## Form Handling

### Validation Pattern

```dart
class RegistrationViewModel extends BaseViewModel {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  bool get isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty;
  
  void setEmail(String value) {
    _email = value;
    _emailError = Validators.email(value);
    rebuildUi();
  }
  
  void setPassword(String value) {
    _password = value;
    _passwordError = Validators.password(value);
    _validateConfirmPassword(); // Re-validate confirm
    rebuildUi();
  }
  
  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _validateConfirmPassword();
    rebuildUi();
  }
  
  void _validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = null;
    } else if (_confirmPassword != _password) {
      _confirmPasswordError = 'Passwords do not match';
    } else {
      _confirmPasswordError = null;
    }
  }
}
```

---

## Reactive Services

### Listen to Service Changes

```dart
class HomeViewModel extends ReactiveViewModel {
  final _authService = locator<AuthService>();
  final _connectivityService = locator<ConnectivityService>();
  
  UserEntity? get currentUser => _authService.currentUser;
  bool get isOnline => _connectivityService.isOnline;
  
  @override
  List<ListenableServiceMixin> get listenableServices => [
    _authService,
    _connectivityService,
  ];
}
```

---

## Testing Support

### Constructor Injection for Tests

```dart
class LoginViewModel extends BaseViewModel {
  final IAuthRepository _authRepository;
  final NavigationService _navigationService;
  
  LoginViewModel({
    IAuthRepository? authRepository,
    NavigationService? navigationService,
  }) : _authRepository = authRepository ?? locator<IAuthRepository>(),
       _navigationService = navigationService ?? locator<NavigationService>();
}

// In tests:
final mockAuthRepo = MockIAuthRepository();
final mockNavService = MockNavigationService();

final viewModel = LoginViewModel(
  authRepository: mockAuthRepo,
  navigationService: mockNavService,
);
```

---

## Don'ts

```dart
// ❌ Don't expose private state directly
List<Item> items = []; // Should be private with getter

// ❌ Don't forget rebuildUi after state change
void addItem(Item item) {
  _items.add(item);
  // Missing rebuildUi()!
}

// ❌ Don't use setState or notifyListeners for simple updates
notifyListeners(); // Use rebuildUi() instead

// ❌ Don't handle UI directly
showDialog(...); // Use DialogService instead

// ❌ Don't throw exceptions
throw AuthException('Failed'); // Return Either<Failure, T> instead

// ❌ Don't call View methods from ViewModel
view.showError('message'); // ViewModel doesn't know about View
```

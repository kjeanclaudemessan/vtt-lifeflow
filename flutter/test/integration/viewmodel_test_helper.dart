/// Integration test helper — registers REAL services into GetIt
/// so that actual ViewModels (LoginViewModel, RegisterViewModel, etc.)
/// work against a real local Supabase.
///
/// Chain: SupabaseClient → SupabaseService → SupabaseAuthService
///        → AuthRepositoryImpl → locator<IAuthRepository>()
///
/// Requires: `supabase start` running locally.
///
/// Usage:
/// ```dart
/// setUpAll(() async => await ViewModelTestHelper.initialize());
/// tearDownAll(() async => await ViewModelTestHelper.cleanup());
/// ```
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase/supabase.dart';
import 'package:lifeflow/data/repositories/auth_repository_impl.dart';
import 'package:lifeflow/domain/repositories/i_auth_repository.dart';
import 'package:lifeflow/services/storage/local_storage_service.dart';
import 'package:lifeflow/services/supabase/supabase_auth_service.dart';
import 'package:lifeflow/services/supabase/supabase_service.dart';

import 'supabase_test_config.dart';

final _locator = GetIt.instance;

/// Helper to set up REAL services for ViewModel integration tests.
///
/// After [initialize], you can do: `final vm = LoginViewModel();`
/// and it will use a real SupabaseClient at http://127.0.0.1:54321.
class ViewModelTestHelper {
  static SupabaseClient? _adminClient;

  /// Admin client (service_role) for creating/deleting test users.
  static SupabaseClient get adminClient {
    _adminClient ??= SupabaseClient(testSupabaseUrl, testSupabaseServiceKey);
    return _adminClient!;
  }

  /// The shared SupabaseService registered in GetIt.
  static SupabaseService get supabaseService => _locator<SupabaseService>();

  /// The test LocalStorageService (in-memory).
  static LocalStorageService get localStorage =>
      _locator<LocalStorageService>();

  /// The test DialogService (auto-confirms).
  static TestDialogService get dialogService =>
      _locator<DialogService>() as TestDialogService;

  /// The test NavigationService (records calls, no real navigator).
  static TestNavigationService get navigationService =>
      _locator<NavigationService>() as TestNavigationService;

  /// Bootstraps GetIt with the REAL service chain:
  ///
  /// 1. SupabaseClient (pure Dart — no Flutter binding needed)
  /// 2. SupabaseService (wraps client)
  /// 3. SupabaseAuthService (reactive auth state)
  /// 4. AuthRepositoryImpl (as IAuthRepository)
  /// 5. Stacked services (NavigationService, etc.)
  static Future<void> initialize() async {
    await _locator.reset();

    // 1. Real SupabaseClient (from `supabase` package, NOT supabase_flutter)
    //    Use implicit flow — PKCE requires asyncStorage which isn't available
    //    in pure Dart tests (no SharedPreferences).
    final client = SupabaseClient(
      testSupabaseUrl,
      testSupabaseAnonKey,
      authOptions: const AuthClientOptions(
        authFlowType: AuthFlowType.implicit,
      ),
    );

    // 2. SupabaseService with injected client (skips Supabase.initialize)
    final supabaseSvc = SupabaseService(client: client);
    _locator.registerSingleton<SupabaseService>(supabaseSvc);

    // 3. SupabaseAuthService with injected SupabaseService
    final authSvc = SupabaseAuthService(supabaseService: supabaseSvc);
    await authSvc.init();
    _locator.registerSingleton<SupabaseAuthService>(authSvc);

    // 4. AuthRepositoryImpl (real impl, injected services)
    _locator.registerSingleton<IAuthRepository>(
      AuthRepositoryImpl(
        authService: authSvc,
        supabaseService: supabaseSvc,
      ),
    );

    // 5. LocalStorageService (in-memory test backend — no SharedPreferences)
    final storageSvc = LocalStorageService.test();
    _locator.registerSingleton<LocalStorageService>(storageSvc);

    // 6. Stacked services — ViewModels do locator<NavigationService>() etc.
    _locator.registerSingleton<NavigationService>(TestNavigationService());
    _locator.registerSingleton<DialogService>(TestDialogService());
    _locator.registerSingleton<BottomSheetService>(BottomSheetService());
    _locator.registerSingleton<SnackbarService>(SnackbarService());
  }

  /// Create a confirmed test user via admin API.
  static Future<User> createUser({
    String? email,
    String password = 'Test123456!',
    String? firstName,
    String? lastName,
  }) async {
    final userEmail = email ?? generateVmTestEmail();
    final response = await adminClient.auth.admin.createUser(
      AdminUserAttributes(
        email: userEmail,
        password: password,
        emailConfirm: true,
        userMetadata: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      ),
    );
    return response.user!;
  }

  /// Sign in on the shared client (sets session for ViewModels).
  static Future<void> signIn({
    required String email,
    String password = 'Test123456!',
  }) async {
    await supabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    // Let auth listener fire
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Sign out on the shared client.
  static Future<void> signOut() async {
    try {
      await supabaseService.client.auth.signOut();
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (_) {}
  }

  /// Delete a test user by email via admin API.
  static Future<void> deleteUser(String email) async {
    try {
      final users = await adminClient.auth.admin.listUsers();
      final user = users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('not found'),
      );
      await adminClient.auth.admin.deleteUser(user.id);
    } catch (_) {}
  }

  /// Cleanup: sign out + delete all vm_test_ users + reset GetIt.
  static Future<void> cleanup() async {
    try {
      await signOut();
      final users = await adminClient.auth.admin.listUsers();
      for (final user in users) {
        if (user.email?.startsWith('vm_test_') == true) {
          await adminClient.auth.admin.deleteUser(user.id);
        }
      }
    } catch (_) {}
    await _locator.reset();
  }
}

/// Generate unique test email for ViewModel tests.
int _vmTestEmailCounter = 0;
String generateVmTestEmail() {
  final ts = DateTime.now().millisecondsSinceEpoch;
  _vmTestEmailCounter++;
  return 'vm_test_${ts}_$_vmTestEmailCounter@example.com';
}

/// A NavigationService that records navigation calls without using Get.
///
/// All methods are no-ops that record the last route navigated to.
/// This avoids WidgetsBinding errors in pure Dart tests.
class TestNavigationService extends NavigationService {
  /// The last route that was navigated to.
  String? lastRoute;

  /// The last navigation action (e.g., 'navigateTo', 'replaceWith', etc.).
  String? lastAction;

  /// Clears recorded navigation state.
  void clearNavigation() {
    lastRoute = null;
    lastAction = null;
  }

  @override
  Future<T?>? navigateTo<T>(
    String routeName, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    RouteTransitionsBuilder? transition,
  }) {
    lastRoute = routeName;
    lastAction = 'navigateTo';
    return Future.value(null);
  }

  @override
  Future<T?>? replaceWith<T>(
    String routeName, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    RouteTransitionsBuilder? transition,
  }) {
    lastRoute = routeName;
    lastAction = 'replaceWith';
    return Future.value(null);
  }

  @override
  Future<T?>? clearStackAndShow<T>(
    String routeName, {
    dynamic arguments,
    int? id,
    Map<String, String>? parameters,
  }) {
    lastRoute = routeName;
    lastAction = 'clearStackAndShow';
    return Future.value(null);
  }

  @override
  bool back<T>({dynamic result, int? id}) {
    lastAction = 'back';
    return true;
  }
}

/// A DialogService that auto-responds to confirmation dialogs.
///
/// By default, confirms all dialogs. Set [autoConfirm] to false
/// to simulate the user cancelling.
class TestDialogService extends DialogService {
  /// Whether to auto-confirm dialogs.
  bool autoConfirm = true;

  @override
  Future<DialogResponse?> showConfirmationDialog({
    String? title,
    String? description,
    String cancelTitle = 'Cancel',
    Color? cancelTitleColor,
    String confirmationTitle = 'Ok',
    Color? confirmationTitleColor,
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
    DialogPlatform? dialogPlatform,
  }) async {
    return DialogResponse(confirmed: autoConfirm);
  }

  @override
  Future<DialogResponse?> showDialog({
    String? title,
    String? description,
    String? cancelTitle,
    Color? cancelTitleColor,
    String buttonTitle = 'Ok',
    Color? buttonTitleColor,
    bool barrierDismissible = false,
    RouteSettings? routeSettings,
    GlobalKey<NavigatorState>? navigatorKey,
    DialogPlatform? dialogPlatform,
  }) async {
    return DialogResponse(confirmed: autoConfirm);
  }
}

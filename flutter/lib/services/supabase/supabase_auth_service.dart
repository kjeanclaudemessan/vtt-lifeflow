import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:stacked/stacked.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../analytics/analytics_service.dart';
import 'supabase_service.dart';

/// Authentication status.
enum AuthStatus {
  /// Initial state before checking auth.
  unknown,

  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,
}

/// Supabase authentication service.
///
/// Provides reactive authentication state and methods for sign in/up/out.
///
/// Example:
/// ```dart
/// final auth = locator<SupabaseAuthService>();
///
/// // Listen to auth changes in ViewModel
/// @override
/// List<ListenableServiceMixin> get listenableServices => [auth];
///
/// // Sign in with email
/// final result = await auth.signInWithEmail(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// result.fold(
///   (failure) => showError(failure.message),
///   (user) => navigateToHome(),
/// );
/// ```
class SupabaseAuthService with ListenableServiceMixin {
  final SupabaseService _supabase;

  // ═══════════════════════════════════════════════════════════════════════════
  // REACTIVE VALUES
  // ═══════════════════════════════════════════════════════════════════════════

  final _authStatus = ReactiveValue<AuthStatus>(AuthStatus.unknown);
  final _currentUser = ReactiveValue<User?>(null);

  /// Current authentication status.
  AuthStatus get authStatus => _authStatus.value;

  /// Current authenticated user.
  User? get currentUser => _currentUser.value;

  /// Whether user is authenticated.
  bool get isAuthenticated => _authStatus.value == AuthStatus.authenticated;

  /// Whether authentication status is still loading.
  bool get isLoading => _authStatus.value == AuthStatus.unknown;

  /// Stream of auth state changes (User or null).
  Stream<User?> get authStateChanges => _supabase.client.auth.onAuthStateChange
      .map((state) => state.session?.user);

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTRUCTOR & INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Creates a [SupabaseAuthService].
  ///
  /// Optionally accepts a [SupabaseService] for testing.
  /// Falls back to `locator<SupabaseService>()` in production.
  SupabaseAuthService({SupabaseService? supabaseService})
      : _supabase = supabaseService ?? locator<SupabaseService>() {
    listenToReactiveValues([_authStatus, _currentUser]);
  }

  /// Initializes the auth service.
  ///
  /// Checks current auth state and listens for changes.
  Future<void> init() async {
    // Check initial auth state
    final user = _supabase.client.auth.currentUser;
    if (user != null) {
      _currentUser.value = user;
      _authStatus.value = AuthStatus.authenticated;
      _identifyUser(user);
    } else {
      _authStatus.value = AuthStatus.unauthenticated;
    }

    // Listen for auth changes
    _supabase.client.auth.onAuthStateChange.listen(_handleAuthStateChange);
  }

  void _handleAuthStateChange(AuthState data) {
    final event = data.event;
    final session = data.session;

    switch (event) {
      case AuthChangeEvent.signedIn:
        _currentUser.value = session?.user;
        _authStatus.value = AuthStatus.authenticated;
        if (session?.user != null) _identifyUser(session!.user);
      case AuthChangeEvent.signedOut:
        _currentUser.value = null;
        _authStatus.value = AuthStatus.unauthenticated;
        locator<AnalyticsService>().reset();
      case AuthChangeEvent.tokenRefreshed:
        _currentUser.value = session?.user;
      case AuthChangeEvent.userUpdated:
        _currentUser.value = session?.user;
      default:
        break;
    }
  }

  /// Identify the user in analytics after authentication.
  void _identifyUser(User user) {
    locator<AnalyticsService>().identify(
      userId: user.id,
      properties: {
        if (user.email != null) 'email': user.email!,
        'provider': user.appMetadata['provider'] ?? 'email',
        'created_at': user.createdAt,
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMAIL AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Signs in with email and password.
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Sign in failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Signs up with email and password.
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Sign up failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OAUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Signs in with OAuth provider (Google, Apple, GitHub, etc.).
  Future<Either<Failure, bool>> signInWithOAuth(
    OAuthProvider provider, {
    String? redirectTo,
  }) async {
    try {
      // Web: redirect back to current origin (e.g. http://localhost:3000)
      // Mobile: use deep link scheme to reopen the app
      final defaultRedirect =
          kIsWeb ? Uri.base.origin : 'com.vitatech.lifeflow://login-callback/';
      final success = await _supabase.client.auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo ?? defaultRedirect,
      );
      return Right(success);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Signs in with Google.
  Future<Either<Failure, bool>> signInWithGoogle({String? redirectTo}) {
    return signInWithOAuth(OAuthProvider.google, redirectTo: redirectTo);
  }

  /// Signs in with Apple.
  Future<Either<Failure, bool>> signInWithApple({String? redirectTo}) {
    return signInWithOAuth(OAuthProvider.apple, redirectTo: redirectTo);
  }

  /// Signs in with GitHub.
  Future<Either<Failure, bool>> signInWithGitHub({String? redirectTo}) {
    return signInWithOAuth(OAuthProvider.github, redirectTo: redirectTo);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PHONE AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Signs in with phone number (sends OTP).
  ///
  /// After calling this, the user will receive an SMS with a code.
  /// Use [verifyPhoneOtp] to complete the sign in.
  ///
  /// Example:
  /// ```dart
  /// // Step 1: Send OTP
  /// await auth.signInWithPhone(phone: '+33612345678');
  ///
  /// // Step 2: Verify OTP (user enters the code)
  /// await auth.verifyPhoneOtp(phone: '+33612345678', token: '123456');
  /// ```
  Future<Either<Failure, void>> signInWithPhone({
    required String phone,
  }) async {
    try {
      await _supabase.client.auth.signInWithOtp(phone: phone);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Signs up with phone number (sends OTP).
  ///
  /// Use [verifyPhoneOtp] to complete the sign up.
  Future<Either<Failure, void>> signUpWithPhone({
    required String phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.client.auth.signInWithOtp(
        phone: phone,
        data: metadata,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Verifies phone OTP and completes sign in/up.
  Future<Either<Failure, User>> verifyPhoneOtp({
    required String phone,
    required String token,
    OtpType type = OtpType.sms,
  }) async {
    try {
      final response = await _supabase.client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: type,
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Phone verification failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Resends the phone OTP.
  Future<Either<Failure, void>> resendPhoneOtp({
    required String phone,
  }) async {
    try {
      await _supabase.client.auth.resend(
        type: OtpType.sms,
        phone: phone,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PASSWORD MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sends password reset email.
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _supabase.client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Updates user password.
  Future<Either<Failure, User>> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Password update failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USER MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Updates user metadata.
  Future<Either<Failure, User>> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _supabase.client.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: metadata,
        ),
      );

      if (response.user == null) {
        return const Left(AuthFailure(message: 'Update failed'));
      }

      return Right(response.user!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  /// Refreshes the current session.
  Future<Either<Failure, Session>> refreshSession() async {
    try {
      final response = await _supabase.client.auth.refreshSession();

      if (response.session == null) {
        return const Left(AuthFailure(message: 'Session refresh failed'));
      }

      return Right(response.session!);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SIGN OUT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Signs out the current user.
  Future<Either<Failure, void>> signOut() async {
    try {
      await _supabase.client.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

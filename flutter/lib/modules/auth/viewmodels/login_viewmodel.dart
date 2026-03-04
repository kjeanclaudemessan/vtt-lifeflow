import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/core.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/supabase/supabase_auth_service.dart';
import '../config/auth_config.dart';

/// ViewModel for the Login screen.
///
/// Handles email/password login, social login, and navigation.
class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();
  final SupabaseAuthService _authService = locator<SupabaseAuthService>();

  StreamSubscription? _authSubscription;
  bool _isWaitingForOAuth = false;
  bool get isWaitingForOAuth => _isWaitingForOAuth;

  /// Start listening for OAuth completion (auth state change).
  void _listenForOAuthCompletion() {
    _authSubscription?.cancel();
    _authSubscription = _authService.authStateChanges.listen((user) {
      if (user != null && _isWaitingForOAuth) {
        _isWaitingForOAuth = false;
        _authSubscription?.cancel();
        _navigationService.clearStackAndShow(Routes.homeView);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Configuration for the auth module.
  AuthConfig get config => const AuthConfig();

  // ─────────────────────────────────────────────────────────────────
  // Form State
  // ─────────────────────────────────────────────────────────────────

  // Dev defaults for quick testing
  String _email = AppConfig.isDevelopment ? 'messanjeanclaude@gmail.com' : '';
  String get email => _email;

  String _password =
      AppConfig.isDevelopment ? 'messanjeanclaude@gmail.com' : '';
  String get password => _password;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // ─────────────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────────────

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  bool get canSubmit =>
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _emailError == null &&
      _passwordError == null;

  // ─────────────────────────────────────────────────────────────────
  // Busy Keys
  // ─────────────────────────────────────────────────────────────────

  static const String loginBusyKey = 'login';
  static const String googleBusyKey = 'google';
  static const String appleBusyKey = 'apple';
  static const String githubBusyKey = 'github';

  // ─────────────────────────────────────────────────────────────────
  // Setters
  // ─────────────────────────────────────────────────────────────────

  void setEmail(String value) {
    _email = value.trim();
    _emailError = _validateEmail(_email);
    rebuildUi();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = _validatePassword(_password);
    rebuildUi();
  }

  void setRememberMe(bool? value) {
    _rememberMe = value ?? false;
    rebuildUi();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    rebuildUi();
  }

  // ─────────────────────────────────────────────────────────────────
  // Validation Helpers
  // ─────────────────────────────────────────────────────────────────

  String? _validateEmail(String email) {
    if (email.isEmpty) return null;
    if (!RegexPatterns.email.hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return null;
    if (password.length < config.minPasswordLength) {
      return 'Password must be at least ${config.minPasswordLength} characters';
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────

  /// Login with email and password.
  Future<void> loginWithEmail() async {
    if (!canSubmit) return;

    final result = await runBusyFuture(
      _authRepository.signInWithEmail(email: _email, password: _password),
      busyObject: loginBusyKey,
    );

    _handleAuthResult(result);
  }

  /// Login with Google.
  Future<void> loginWithGoogle() async {
    final result = await runBusyFuture(
      _authRepository.signInWithOAuth(provider: OAuthProvider.google),
      busyObject: googleBusyKey,
    );

    _handleOAuthResult(result);
  }

  /// Login with Apple.
  Future<void> loginWithApple() async {
    final result = await runBusyFuture(
      _authRepository.signInWithOAuth(provider: OAuthProvider.apple),
      busyObject: appleBusyKey,
    );

    _handleOAuthResult(result);
  }

  /// Login with GitHub.
  Future<void> loginWithGithub() async {
    final result = await runBusyFuture(
      _authRepository.signInWithOAuth(provider: OAuthProvider.github),
      busyObject: githubBusyKey,
    );

    _handleOAuthResult(result);
  }

  void _handleAuthResult(Either<Failure, UserEntity> result) {
    result.fold(
      (failure) => setError(failure.message),
      (_) => _navigationService.clearStackAndShow(Routes.homeView),
    );
  }

  void _handleOAuthResult(Either<Failure, bool> result) {
    result.fold(
      (failure) {
        _isWaitingForOAuth = false;
        setError(failure.message);
      },
      (success) {
        if (success) {
          // Don't navigate here — the browser just opened.
          // Navigation happens in _listenForOAuthCompletion when
          // onAuthStateChange fires with a valid session.
          _isWaitingForOAuth = true;
          _listenForOAuthCompletion();
          rebuildUi();
        }
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────

  void goToRegister() {
    _navigationService.navigateTo(Routes.registerView);
  }

  void goToForgotPassword() {
    _navigationService.navigateTo(Routes.forgotPasswordView);
  }
}

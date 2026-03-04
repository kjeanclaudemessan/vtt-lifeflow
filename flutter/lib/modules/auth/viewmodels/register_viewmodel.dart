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

/// ViewModel for the Register screen.
///
/// Handles user registration with email/password.
class RegisterViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();
  final SupabaseAuthService _authService = locator<SupabaseAuthService>();

  StreamSubscription? _authSubscription;
  bool _isWaitingForOAuth = false;
  bool get isWaitingForOAuth => _isWaitingForOAuth;

  /// Configuration for the auth module.
  AuthConfig get config => const AuthConfig();

  // ─────────────────────────────────────────────────────────────────
  // Form State
  // ─────────────────────────────────────────────────────────────────

  // Dev defaults for quick testing
  String _firstName = AppConfig.isDevelopment ? 'Jean-Claude' : '';
  String get firstName => _firstName;

  String _lastName = AppConfig.isDevelopment ? 'Messan' : '';
  String get lastName => _lastName;

  String _email = AppConfig.isDevelopment ? 'messanjeanclaude@gmail.com' : '';
  String get email => _email;

  String _password =
      AppConfig.isDevelopment ? 'messanjeanclaude@gmail.com' : '';
  String get password => _password;

  String _confirmPassword =
      AppConfig.isDevelopment ? 'messanjeanclaude@gmail.com' : '';
  String get confirmPassword => _confirmPassword;

  bool _acceptedTerms = false;
  bool get acceptedTerms => _acceptedTerms;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // ─────────────────────────────────────────────────────────────────
  // Validation Errors
  // ─────────────────────────────────────────────────────────────────

  String? _firstNameError;
  String? get firstNameError => _firstNameError;

  String? _lastNameError;
  String? get lastNameError => _lastNameError;

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // ─────────────────────────────────────────────────────────────────
  // Password Strength
  // ─────────────────────────────────────────────────────────────────

  PasswordStrength get passwordStrength => _calculateStrength(_password);

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  bool get canSubmit {
    final hasRequiredFields = _email.isNotEmpty && _password.isNotEmpty;
    final hasNoErrors = _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
    final termsOk = !config.showTermsCheckbox || _acceptedTerms;
    return hasRequiredFields && hasNoErrors && termsOk;
  }

  // ─────────────────────────────────────────────────────────────────
  // Busy Keys
  // ─────────────────────────────────────────────────────────────────

  static const String registerBusyKey = 'register';

  // ─────────────────────────────────────────────────────────────────
  // Setters
  // ─────────────────────────────────────────────────────────────────

  void setFirstName(String value) {
    _firstName = value.trim();
    _firstNameError = null;
    rebuildUi();
  }

  void setLastName(String value) {
    _lastName = value.trim();
    _lastNameError = null;
    rebuildUi();
  }

  void setEmail(String value) {
    _email = value.trim();
    _emailError = _validateEmail(_email);
    rebuildUi();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = _validatePassword(_password);
    if (_confirmPassword.isNotEmpty) {
      _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    }
    rebuildUi();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    rebuildUi();
  }

  void setAcceptedTerms(bool? value) {
    _acceptedTerms = value ?? false;
    rebuildUi();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    rebuildUi();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
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

  String? _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) return null;
    if (confirmPassword != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────

  /// Register with email and password.
  Future<void> register() async {
    if (!canSubmit) return;

    final metadata = <String, dynamic>{};
    if (_firstName.isNotEmpty) metadata['first_name'] = _firstName;
    if (_lastName.isNotEmpty) metadata['last_name'] = _lastName;

    final result = await runBusyFuture(
      _authRepository.signUpWithEmail(
        email: _email,
        password: _password,
        metadata: metadata.isNotEmpty ? metadata : null,
      ),
      busyObject: registerBusyKey,
    );

    _handleAuthResult(result);
  }

  void _handleAuthResult(Either<Failure, UserEntity> result) {
    result.fold(
      (failure) => setError(failure.message),
      (_) {
        if (config.requireEmailVerification) {
          // TODO: Navigate to email verification view
          _navigationService.clearStackAndShow(Routes.homeView);
        } else {
          _navigationService.clearStackAndShow(Routes.homeView);
        }
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────

  // ─────────────────────────────────────────────────────────────────
  // OAuth Registration (same flow as login — social accounts auto-create)
  // ─────────────────────────────────────────────────────────────────

  Future<void> registerWithGoogle() async {
    await _handleOAuth(OAuthProvider.google);
  }

  Future<void> registerWithApple() async {
    await _handleOAuth(OAuthProvider.apple);
  }

  Future<void> registerWithGithub() async {
    await _handleOAuth(OAuthProvider.github);
  }

  Future<void> _handleOAuth(OAuthProvider provider) async {
    final result = await runBusyFuture(
      _authRepository.signInWithOAuth(provider: provider),
      busyObject: RegisterViewModel.registerBusyKey,
    );

    result.fold(
      (failure) {
        _isWaitingForOAuth = false;
        setError(failure.message);
      },
      (success) {
        if (success) {
          _isWaitingForOAuth = true;
          _listenForOAuthCompletion();
          rebuildUi();
        }
      },
    );
  }

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

  // ─────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────

  void goToLogin() {
    _navigationService.back();
  }

  void openTerms() {
    // TODO: Open terms URL in browser
  }

  void openPrivacy() {
    // TODO: Open privacy URL in browser
  }
}

/// Password strength levels.
enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}

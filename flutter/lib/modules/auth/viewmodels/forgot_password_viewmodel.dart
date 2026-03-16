import 'package:dartz/dartz.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/core.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/haptic_service.dart';
import '../config/auth_config.dart';

/// ViewModel for the Forgot Password screen.
///
/// Handles password reset email request.
class ForgotPasswordViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();
  final HapticService _haptic = locator<HapticService>();

  // ─────────────────────────────────────────────────────────────────
  // Config
  // ─────────────────────────────────────────────────────────────────

  AuthConfig get config => const AuthConfig();

  // ─────────────────────────────────────────────────────────────────
  // State
  // ─────────────────────────────────────────────────────────────────

  String _email = '';
  String get email => _email;

  String? _emailError;
  String? get emailError => _emailError;

  bool _emailSent = false;
  bool get emailSent => _emailSent;

  bool get canSubmit => _email.isNotEmpty && _emailError == null;

  // ─────────────────────────────────────────────────────────────────
  // Busy Keys
  // ─────────────────────────────────────────────────────────────────

  static const String resetBusyKey = 'reset';

  // ─────────────────────────────────────────────────────────────────
  // Setters
  // ─────────────────────────────────────────────────────────────────

  void setEmail(String value) {
    _email = value.trim();
    _emailError = _validateEmail(_email);
    rebuildUi();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return null;
    if (!RegexPatterns.email.hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────

  /// Send password reset email.
  Future<void> sendResetEmail() async {
    if (!canSubmit) return;

    final result = await runBusyFuture(
      _authRepository.resetPassword(email: _email),
      busyObject: resetBusyKey,
    );

    _handleResult(result);
  }

  void _handleResult(Either<Failure, Unit> result) {
    result.fold(
      (failure) {
        _haptic.error();
        setError(failure.message);
      },
      (_) {
        _haptic.success();
        _emailSent = true;
        rebuildUi();
      },
    );
  }

  /// Resend the reset email.
  Future<void> resendEmail() async {
    _emailSent = false;
    rebuildUi();
    await sendResetEmail();
  }

  // ─────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────

  void goBack() {
    _navigationService.back();
  }
}

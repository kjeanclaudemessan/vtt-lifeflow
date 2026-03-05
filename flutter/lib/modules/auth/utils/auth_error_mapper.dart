import 'package:flutter/widgets.dart';

import '../../../core/errors/failures.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Maps [Failure] error codes to i18n messages.
///
/// Usage in views:
/// ```dart
/// Text(AuthErrorMapper.message(context, viewModel.modelError))
/// ```
class AuthErrorMapper {
  AuthErrorMapper._();

  /// Resolves a user-friendly i18n message from a [Failure] or raw error.
  static String message(BuildContext context, dynamic error) {
    final l10n = AppLocalizations.of(context)!;

    if (error is Failure) {
      return _fromCode(l10n, error.code) ?? error.message;
    }

    // Raw string fallback
    final raw = error?.toString() ?? '';
    return raw.isNotEmpty ? raw : l10n.errorUnknown;
  }

  /// Maps Supabase auth error codes to l10n strings.
  static String? _fromCode(AppLocalizations l10n, String? code) {
    if (code == null) return null;

    return switch (code) {
      'invalid_credentials' => l10n.errorInvalidCredentials,
      'user_not_found' => l10n.errorUserNotFound,
      'email_not_confirmed' => l10n.errorEmailNotConfirmed,
      'user_already_exists' || 'email_exists' => l10n.errorEmailAlreadyInUse,
      'weak_password' => l10n.errorWeakPassword,
      'over_request_rate_limit' || 'rate_limit' => l10n.errorTooManyRequests,
      'otp_expired' => l10n.errorOtpExpired,
      'session_not_found' => l10n.errorSessionExpired,
      'user_banned' => l10n.errorUserBanned,
      'NETWORK_ERROR' => l10n.errorNetwork,
      'SERVER_ERROR' => l10n.errorServer,
      'TIMEOUT' => l10n.errorTimeout,
      _ => null,
    };
  }
}

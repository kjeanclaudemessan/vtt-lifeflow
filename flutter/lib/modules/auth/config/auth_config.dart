/// Configuration for the Auth module.
///
/// Customize authentication options by creating an instance with desired values:
///
/// ```dart
/// const config = AuthConfig(
///   enableGoogle: true,
///   enableApple: true,
///   enablePhone: false,
///   style: AuthStyle.modern,
/// );
/// ```
class AuthConfig {
  // ─────────────────────────────────────────────────────────────────
  // Social Login Options
  // ─────────────────────────────────────────────────────────────────

  /// Enable Google sign-in.
  final bool enableGoogle;

  /// Enable Apple sign-in (iOS/macOS only).
  final bool enableApple;

  /// Enable GitHub sign-in.
  final bool enableGithub;

  /// Enable phone/SMS sign-in (OTP).
  final bool enablePhone;

  /// Enable email magic link sign-in.
  final bool enableMagicLink;

  // ─────────────────────────────────────────────────────────────────
  // Security Options
  // ─────────────────────────────────────────────────────────────────

  /// Enable biometric authentication (fingerprint/face).
  final bool enableBiometric;

  /// Require email verification before access.
  final bool requireEmailVerification;

  /// Minimum password length.
  final int minPasswordLength;

  /// Show password strength indicator.
  final bool showPasswordStrength;

  // ─────────────────────────────────────────────────────────────────
  // UI Options
  // ─────────────────────────────────────────────────────────────────

  /// Visual style of auth screens.
  final AuthStyle style;

  /// Show "Remember me" checkbox.
  final bool showRememberMe;

  /// Show terms and conditions checkbox on register.
  final bool showTermsCheckbox;

  /// URL for terms and conditions.
  final String? termsUrl;

  /// URL for privacy policy.
  final String? privacyUrl;

  // ─────────────────────────────────────────────────────────────────
  // Redirect Options
  // ─────────────────────────────────────────────────────────────────

  /// Redirect URL for email verification (deep link).
  final String? emailRedirectUrl;

  /// Redirect URL for password reset (deep link).
  final String? resetPasswordRedirectUrl;

  // ─────────────────────────────────────────────────────────────────
  // Constructor
  // ─────────────────────────────────────────────────────────────────

  const AuthConfig({
    this.enableGoogle = true,
    this.enableApple = true,
    this.enableGithub = false,
    this.enablePhone = false,
    this.enableMagicLink = false,
    this.enableBiometric = true,
    this.requireEmailVerification = false,
    this.minPasswordLength = 8,
    this.showPasswordStrength = true,
    this.style = AuthStyle.modern,
    this.showRememberMe = true,
    this.showTermsCheckbox = true,
    this.termsUrl,
    this.privacyUrl,
    this.emailRedirectUrl,
    this.resetPasswordRedirectUrl,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  /// Whether any social login is enabled.
  bool get hasSocialLogin => enableGoogle || enableApple || enableGithub;

  /// Whether any alternative login method is enabled.
  bool get hasAlternativeLogin => enablePhone || enableMagicLink;
}

/// Visual styles for auth screens.
enum AuthStyle {
  /// Modern design with gradient background and animations.
  modern,

  /// Classic centered design with card layout.
  classic,

  /// Minimal design with clean lines.
  minimal,
}

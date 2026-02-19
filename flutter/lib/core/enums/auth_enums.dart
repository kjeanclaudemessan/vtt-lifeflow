/// OAuth providers supported by the application.
///
/// This enum is framework-agnostic and can be used with any auth provider
/// (Supabase, Firebase, custom API, etc.).
enum OAuthProvider {
  google,
  apple,
  facebook,
  github,
  twitter,
  microsoft,
  discord,
  slack,
  linkedin;

  /// Creates an [OAuthProvider] from a string value.
  static OAuthProvider? fromString(String? value) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'google' => OAuthProvider.google,
      'apple' => OAuthProvider.apple,
      'facebook' => OAuthProvider.facebook,
      'github' => OAuthProvider.github,
      'twitter' => OAuthProvider.twitter,
      'microsoft' => OAuthProvider.microsoft,
      'discord' => OAuthProvider.discord,
      'slack' => OAuthProvider.slack,
      'linkedin' => OAuthProvider.linkedin,
      _ => null,
    };
  }

  /// Converts this provider to a string value.
  String toValue() => name;

  /// Display name for UI.
  String get displayName {
    return switch (this) {
      OAuthProvider.google => 'Google',
      OAuthProvider.apple => 'Apple',
      OAuthProvider.facebook => 'Facebook',
      OAuthProvider.github => 'GitHub',
      OAuthProvider.twitter => 'Twitter',
      OAuthProvider.microsoft => 'Microsoft',
      OAuthProvider.discord => 'Discord',
      OAuthProvider.slack => 'Slack',
      OAuthProvider.linkedin => 'LinkedIn',
    };
  }

  /// Whether this provider is typically available on iOS.
  bool get availableOnIOS => true;

  /// Whether this provider is typically available on Android.
  bool get availableOnAndroid => this != OAuthProvider.apple;

  /// Whether this provider is typically available on Web.
  bool get availableOnWeb => true;
}

/// OTP (One-Time Password) verification types.
///
/// This enum is framework-agnostic and can be used with any auth provider.
enum OtpType {
  /// OTP sent via SMS.
  sms,

  /// OTP sent via email.
  email,

  /// Magic link sent via email.
  magicLink,

  /// Phone call with OTP.
  phoneCall,

  /// WhatsApp message with OTP.
  whatsapp;

  /// Creates an [OtpType] from a string value.
  static OtpType fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'sms' => OtpType.sms,
      'email' => OtpType.email,
      'magic_link' || 'magiclink' => OtpType.magicLink,
      'phone_call' || 'phonecall' => OtpType.phoneCall,
      'whatsapp' => OtpType.whatsapp,
      _ => OtpType.sms,
    };
  }

  /// Converts this type to a string value.
  String toValue() {
    return switch (this) {
      OtpType.sms => 'sms',
      OtpType.email => 'email',
      OtpType.magicLink => 'magic_link',
      OtpType.phoneCall => 'phone_call',
      OtpType.whatsapp => 'whatsapp',
    };
  }
}

/// Authentication method used by the user.
enum AuthMethod {
  /// Email and password.
  emailPassword,

  /// Phone OTP.
  phoneOtp,

  /// Email magic link.
  magicLink,

  /// OAuth provider.
  oauth,

  /// Biometric (local).
  biometric,

  /// Anonymous.
  anonymous;

  /// Whether this method requires a password.
  bool get requiresPassword => this == AuthMethod.emailPassword;

  /// Whether this method uses OTP.
  bool get usesOtp =>
      this == AuthMethod.phoneOtp || this == AuthMethod.magicLink;
}

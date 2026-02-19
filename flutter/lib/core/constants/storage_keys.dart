/// Storage keys for local and secure storage.
///
/// Centralizes all storage keys to prevent typos and conflicts.
class StorageKeys {
  StorageKeys._();

  // ===== Authentication =====

  /// Key for storing the access token.
  static const String accessToken = 'access_token';

  /// Key for storing the refresh token.
  static const String refreshToken = 'refresh_token';

  /// Key for storing token expiration timestamp.
  static const String tokenExpiry = 'token_expiry';

  /// Key for storing the current user ID.
  static const String userId = 'user_id';

  /// Key for storing the current user data.
  static const String userData = 'user_data';

  // ===== User Preferences =====

  /// Key for storing the selected theme mode.
  static const String themeMode = 'theme_mode';

  /// Key for storing the selected locale.
  static const String locale = 'locale';

  /// Key for storing notification preferences.
  static const String notificationSettings = 'notification_settings';

  /// Key for storing biometric auth preference.
  static const String biometricEnabled = 'biometric_enabled';

  // ===== Onboarding =====

  /// Key for storing whether onboarding has been completed.
  static const String onboardingCompleted = 'onboarding_completed';

  /// Key for storing the app version when onboarding was shown.
  static const String onboardingVersion = 'onboarding_version';

  // ===== App State =====

  /// Key for storing the last opened screen.
  static const String lastScreen = 'last_screen';

  /// Key for storing the first launch timestamp.
  static const String firstLaunch = 'first_launch';

  /// Key for storing the last app version.
  static const String lastAppVersion = 'last_app_version';

  /// Key for storing the number of app launches.
  static const String launchCount = 'launch_count';

  // ===== Cache =====

  /// Prefix for cached API responses.
  static const String cachePrefix = 'cache_';

  /// Key for storing cache timestamps.
  static const String cacheTimestamps = 'cache_timestamps';

  // ===== Feature Flags =====

  /// Key for storing remote feature flags.
  static const String featureFlags = 'feature_flags';

  /// Key for storing feature flags last update timestamp.
  static const String featureFlagsUpdated = 'feature_flags_updated';

  // ===== Debug =====

  /// Key for storing debug settings.
  static const String debugSettings = 'debug_settings';

  /// Key for storing environment override (dev only).
  static const String environmentOverride = 'environment_override';

  // ===== Helper Methods =====

  /// Creates a cache key for a specific endpoint.
  static String cacheKey(String endpoint) => '$cachePrefix$endpoint';

  /// Creates a user-specific key.
  static String userKey(String userId, String key) => '${userId}_$key';
}

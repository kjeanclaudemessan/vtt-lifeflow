/// Application-wide constants.
///
/// Contains general app configuration values that don't change.
class AppConstants {
  AppConstants._();

  // ===== App Info =====

  /// Application name (used as fallback).
  static const String appName = 'MyApp';

  /// Application identifier.
  static const String appId = 'com.example.myapp';

  /// Support email address.
  static const String supportEmail = 'support@example.com';

  /// Website URL.
  static const String websiteUrl = 'https://example.com';

  /// Privacy policy URL.
  static const String privacyPolicyUrl = 'https://example.com/privacy';

  /// Terms of service URL.
  static const String termsOfServiceUrl = 'https://example.com/terms';

  // ===== Validation =====

  /// Minimum password length.
  static const int minPasswordLength = 8;

  /// Maximum password length.
  static const int maxPasswordLength = 128;

  /// Minimum username length.
  static const int minUsernameLength = 3;

  /// Maximum username length.
  static const int maxUsernameLength = 30;

  /// Maximum bio/description length.
  static const int maxBioLength = 500;

  /// Maximum display name length.
  static const int maxDisplayNameLength = 50;

  // ===== UI =====

  /// Default animation duration.
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Fast animation duration.
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  /// Slow animation duration.
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  /// Splash screen minimum duration.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Snackbar display duration.
  static const Duration snackbarDuration = Duration(seconds: 3);

  /// Toast display duration.
  static const Duration toastDuration = Duration(seconds: 2);

  // ===== Debounce =====

  /// Default debounce duration for search inputs.
  static const Duration searchDebounce = Duration(milliseconds: 500);

  /// Debounce duration for button taps (prevent double tap).
  static const Duration tapDebounce = Duration(milliseconds: 300);

  // ===== Pagination =====

  /// Default number of items per page.
  static const int defaultPageSize = 20;

  /// Number of items to prefetch before reaching the end.
  static const int paginationThreshold = 5;

  // ===== Cache =====

  /// Default cache duration.
  static const Duration defaultCacheDuration = Duration(hours: 1);

  /// User data cache duration.
  static const Duration userCacheDuration = Duration(minutes: 30);

  /// Token refresh threshold (refresh if expires within this duration).
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);

  // ===== Image =====

  /// Maximum image upload size in bytes (5MB).
  static const int maxImageSize = 5 * 1024 * 1024;

  /// Allowed image extensions.
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  /// Thumbnail size.
  static const int thumbnailSize = 150;

  /// Avatar size.
  static const int avatarSize = 200;

  // ===== Date Formats =====

  /// Default date format.
  static const String dateFormat = 'dd/MM/yyyy';

  /// Default time format.
  static const String timeFormat = 'HH:mm';

  /// Default datetime format.
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// ISO 8601 format.
  static const String isoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
}

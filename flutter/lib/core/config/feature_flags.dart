import 'app_config.dart';

/// Feature flags for enabling/disabling app features.
///
/// Use these flags to:
/// - Roll out features gradually
/// - A/B test new functionality
/// - Disable features in specific environments
/// - Quick kill switch for problematic features
///
/// Example:
/// ```dart
/// if (FeatureFlags.biometricAuth) {
///   // Show biometric login option
/// }
/// ```
class FeatureFlags {
  FeatureFlags._();

  // ===== Authentication Features =====

  /// Whether biometric authentication is enabled.
  static bool get biometricAuth => true;

  /// Whether social login (Google, Apple, etc.) is enabled.
  static bool get socialLogin => true;

  /// Whether magic link login is enabled.
  static bool get magicLinkLogin => true;

  /// Whether phone number authentication is enabled.
  static bool get phoneAuth => false;

  // ===== UI Features =====

  /// Whether dark mode is available.
  static bool get darkMode => true;

  /// Whether the app supports multiple languages.
  static bool get multiLanguage => true;

  /// Whether to show onboarding for new users.
  static bool get showOnboarding => true;

  /// Whether to show the design system showcase (dev only).
  static bool get designSystemShowcase => AppConfig.isDevelopment;

  // ===== Data Features =====

  /// Whether offline mode is enabled.
  static bool get offlineMode => true;

  /// Whether to enable local caching.
  static bool get enableCaching => true;

  /// Whether to sync data in the background.
  static bool get backgroundSync => true;

  // ===== Notification Features =====

  /// Whether push notifications are enabled.
  static bool get pushNotifications => true;

  /// Whether in-app notifications are enabled.
  static bool get inAppNotifications => true;

  // ===== Analytics & Monitoring =====

  /// Whether to track user analytics.
  static bool get analytics => AppConfig.instance.enableAnalytics;

  /// Whether to enable crash reporting.
  static bool get crashReporting => AppConfig.instance.enableCrashReporting;

  /// Whether to enable performance monitoring.
  static bool get performanceMonitoring =>
      AppConfig.instance.enablePerformanceMonitoring;

  // ===== Experimental Features =====

  /// Whether experimental features are enabled (dev/staging only).
  static bool get experimentalFeatures => AppConfig.isDebug;

  /// Whether to show beta features badge.
  static bool get showBetaBadge => AppConfig.isStaging;

  // ===== Debug Features =====

  /// Whether to show debug info in the app.
  static bool get showDebugInfo => AppConfig.isDevelopment;

  /// Whether to enable verbose logging.
  static bool get verboseLogging => AppConfig.instance.enableLogging;

  /// Whether to show network inspector.
  static bool get networkInspector => AppConfig.isDevelopment;
}

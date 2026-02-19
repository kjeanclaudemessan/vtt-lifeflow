import 'environment.dart';

/// Abstract configuration that varies by environment.
///
/// Implement this interface for each environment (dev, staging, prod).
/// Use [AppConfig] to access the current environment's configuration.
abstract class EnvConfig {
  /// Current environment.
  Environment get environment;

  /// Base URL for API requests.
  ///
  /// Example: `https://api.example.com/v1`
  String get apiBaseUrl;

  /// Supabase project URL.
  ///
  /// Example: `https://xxx.supabase.co`
  String get supabaseUrl;

  /// Supabase anonymous key for public access.
  String get supabaseAnonKey;

  /// Sentry DSN for error reporting.
  ///
  /// Get your DSN from https://sentry.io
  /// Leave empty to disable Sentry.
  String get sentryDsn;

  /// Whether to enable verbose logging.
  ///
  /// Should be `true` in development and staging, `false` in production.
  bool get enableLogging;

  /// Whether to enable analytics tracking.
  ///
  /// Should be `false` in development, `true` in staging and production.
  bool get enableAnalytics;

  /// Whether to enable crash reporting.
  ///
  /// Should be `false` in development, `true` in staging and production.
  bool get enableCrashReporting;

  /// App display name shown to users.
  ///
  /// Can include environment suffix in non-production builds.
  String get appName;

  /// API request timeout duration.
  Duration get apiTimeout;

  /// Whether to enable performance monitoring.
  bool get enablePerformanceMonitoring;

  /// Whether to show debug banner.
  bool get showDebugBanner;

  /// Moneroo API key for payment processing.
  ///
  /// Get your API key from https://moneroo.io
  /// Leave empty to disable Moneroo payments.
  String get monerooApiKey;

  /// Webhook URL for payment callbacks (optional).
  ///
  /// This URL will be called by Moneroo when payment status changes.
  String get paymentWebhookUrl;
}

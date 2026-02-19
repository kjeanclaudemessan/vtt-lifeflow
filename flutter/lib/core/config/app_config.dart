import 'env/dev_config.dart';
import 'env/env_config.dart';
import 'env/environment.dart';
import 'env/prod_config.dart';
import 'env/staging_config.dart';

/// Global application configuration.
///
/// Provides access to environment-specific settings throughout the app.
/// Initialize with [AppConfig.initialize] before use.
///
/// Example:
/// ```dart
/// // In main.dart
/// void main() {
///   AppConfig.initialize(Environment.development);
///   runApp(const MyApp());
/// }
///
/// // Anywhere in the app
/// final baseUrl = AppConfig.instance.apiBaseUrl;
/// if (AppConfig.isDevelopment) {
///   // Debug code
/// }
/// ```
class AppConfig {
  AppConfig._({required EnvConfig config}) : _config = config;

  static AppConfig? _instance;
  final EnvConfig _config;

  /// Gets the singleton instance.
  ///
  /// Throws [StateError] if [initialize] hasn't been called.
  static AppConfig get instance {
    if (_instance == null) {
      throw StateError(
        'AppConfig not initialized. Call AppConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initializes the app configuration for the given environment.
  ///
  /// Must be called before accessing [instance].
  /// Typically called in `main()` before `runApp()`.
  static void initialize(Environment environment) {
    final config = switch (environment) {
      Environment.development => const DevConfig(),
      Environment.staging => const StagingConfig(),
      Environment.production => const ProdConfig(),
    };
    _instance = AppConfig._(config: config);
  }

  /// Resets the configuration (useful for testing).
  static void reset() {
    _instance = null;
  }

  // ===== Environment Checks =====

  /// Current environment.
  static Environment get environment => instance._config.environment;

  /// Whether the app is running in development mode.
  static bool get isDevelopment => environment.isDevelopment;

  /// Whether the app is running in staging mode.
  static bool get isStaging => environment.isStaging;

  /// Whether the app is running in production mode.
  static bool get isProduction => environment.isProduction;

  /// Whether the app is running in a debug environment (dev or staging).
  static bool get isDebug => environment.isDebug;

  /// Whether the app is running in release mode (production).
  static bool get isRelease => environment.isRelease;

  // ===== Configuration Values =====

  /// Base URL for API requests.
  String get apiBaseUrl => _config.apiBaseUrl;

  /// Supabase project URL.
  String get supabaseUrl => _config.supabaseUrl;

  /// Supabase anonymous key.
  String get supabaseAnonKey => _config.supabaseAnonKey;

  /// Sentry DSN for error reporting.
  String get sentryDsn => _config.sentryDsn;

  /// Whether logging is enabled.
  bool get enableLogging => _config.enableLogging;

  /// Whether analytics is enabled.
  bool get enableAnalytics => _config.enableAnalytics;

  /// Whether crash reporting is enabled.
  bool get enableCrashReporting => _config.enableCrashReporting;

  /// App display name.
  String get appName => _config.appName;

  /// API request timeout.
  Duration get apiTimeout => _config.apiTimeout;

  /// Whether performance monitoring is enabled.
  bool get enablePerformanceMonitoring => _config.enablePerformanceMonitoring;

  /// Whether to show debug banner.
  bool get showDebugBanner => _config.showDebugBanner;

  /// Moneroo API key for payment processing.
  static String get monerooApiKey => instance._config.monerooApiKey;

  /// Webhook URL for payment callbacks.
  static String get paymentWebhookUrl => instance._config.paymentWebhookUrl;
}

import 'env_config.dart';
import 'environment.dart';

/// Staging environment configuration.
///
/// Used for testing before production deployment.
class StagingConfig implements EnvConfig {
  /// Creates a new staging configuration.
  const StagingConfig();

  @override
  Environment get environment => Environment.staging;

  @override
  String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api-staging.example.com/v1',
      );

  @override
  String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL');

  @override
  String get supabaseAnonKey =>
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  @override
  String get posthogApiKey => const String.fromEnvironment(
        'POSTHOG_API_KEY',
        defaultValue: 'phc_fsT0dUEqJuzDX28AfyvclkiWUmyUcfsNdyS39DYkp6q',
      );

  @override
  String get posthogHost => const String.fromEnvironment(
        'POSTHOG_HOST',
        defaultValue: 'https://us.i.posthog.com',
      );

  @override
  bool get enableLogging => true;

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get appName => 'LifeFlow Staging';

  @override
  Duration get apiTimeout => const Duration(seconds: 30);

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  bool get showDebugBanner => true;

  @override
  String get monerooApiKey => const String.fromEnvironment(
        'MONEROO_API_KEY',
        defaultValue: '',
      );

  @override
  String get paymentWebhookUrl => const String.fromEnvironment(
        'PAYMENT_WEBHOOK_URL',
        defaultValue: '',
      );
}

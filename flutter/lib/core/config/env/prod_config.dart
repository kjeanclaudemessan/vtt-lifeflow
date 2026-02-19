import 'env_config.dart';
import 'environment.dart';

/// Production environment configuration.
///
/// Used for end-user deployments with optimized settings.
class ProdConfig implements EnvConfig {
  /// Creates a new production configuration.
  const ProdConfig();

  @override
  Environment get environment => Environment.production;

  @override
  String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.example.com/v1',
      );

  @override
  String get supabaseUrl => const String.fromEnvironment('SUPABASE_URL');

  @override
  String get supabaseAnonKey =>
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');

  @override
  bool get enableLogging => false;

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get appName => 'MyApp';

  @override
  Duration get apiTimeout => const Duration(seconds: 30);

  @override
  bool get enablePerformanceMonitoring => true;

  @override
  bool get showDebugBanner => false;

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

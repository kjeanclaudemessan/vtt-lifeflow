import 'env_config.dart';
import 'environment.dart';

/// Development environment configuration.
///
/// Used for local development with debug features enabled.
class DevConfig implements EnvConfig {
  /// Creates a new development configuration.
  const DevConfig();

  @override
  Environment get environment => Environment.development;

  @override
  String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api-dev.example.com/v1',
      );

  @override
  String get supabaseUrl => const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'http://127.0.0.1:54321',
      );

  @override
  String get supabaseAnonKey => const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
      );

  @override
  String get sentryDsn => const String.fromEnvironment(
        'SENTRY_DSN',
        defaultValue: '', // Disabled in dev by default
      );

  @override
  bool get enableLogging => true;

  @override
  bool get enableAnalytics => false;

  @override
  bool get enableCrashReporting => false;

  @override
  String get appName => 'MyApp Dev';

  @override
  Duration get apiTimeout => const Duration(seconds: 60);

  @override
  bool get enablePerformanceMonitoring => false;

  @override
  bool get showDebugBanner => true;

  @override
  String get monerooApiKey => const String.fromEnvironment(
        'MONEROO_API_KEY',
        defaultValue: '', // Set your sandbox API key here
      );

  @override
  String get paymentWebhookUrl => const String.fromEnvironment(
        'PAYMENT_WEBHOOK_URL',
        defaultValue: '', // Your webhook URL
      );
}

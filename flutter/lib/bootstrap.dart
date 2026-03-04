import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/app.bottomsheets.dart';
import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'core/config/app_config.dart';
import 'core/config/env/environment.dart';
import 'services/analytics/analytics_service.dart';
import 'services/connectivity/connectivity_service.dart';
import 'services/local_notification/local_notification_scheduler.dart';
import 'services/push_notification/push_notification_service.dart';
import 'services/settings/app_settings_service.dart';
import 'services/storage/local_storage_service.dart';
import 'services/supabase/supabase_auth_service.dart';
import 'services/supabase/supabase_service.dart';

/// Bootstraps the application.
///
/// Initializes all required services before running the app.
/// Call this from main() instead of directly running the app.
///
/// Example:
/// ```dart
/// void main() async {
///   await bootstrap(Environment.development);
///   runApp(const MainApp());
/// }
/// ```
Future<void> bootstrap({
  Environment environment = Environment.development,
}) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  AppConfig.initialize(environment);

  // Setup service locator
  await setupLocator();

  // Initialize services that require async setup
  await _initializeServices();

  // Setup UI helpers
  setupDialogUi();
  setupBottomSheetUi();

  if (kDebugMode) {
    _logStartupInfo();
  }
}

/// Initializes services that require async setup.
Future<void> _initializeServices() async {
  // Storage must be initialized first
  await locator<LocalStorageService>().init();

  // Connectivity service
  await locator<ConnectivityService>().init();

  // Supabase services
  await locator<SupabaseService>().init();
  await locator<SupabaseAuthService>().init();

  // Firebase (required by push notifications)
  // Gracefully disabled if google-services.json is not present
  try {
    await Firebase.initializeApp();
    debugPrint('[Firebase] Initialized');
  } catch (e) {
    debugPrint('[Firebase] No config found — push notifications disabled: $e');
  }

  // App-wide reactive settings (theme, locale)
  locator<AppSettingsService>().init();

  // Analytics & error tracking (PostHog)
  await locator<AnalyticsService>().init();

  // Push notifications (FCM) — gracefully skips if no Firebase config
  await locator<PushNotificationService>().init();

  // Local notification scheduler (habit reminders, bilan)
  await locator<LocalNotificationScheduler>().init();
  await locator<LocalNotificationScheduler>().scheduleWeeklyBilan();
}

/// Logs startup information in debug mode.
void _logStartupInfo() {
  final config = AppConfig.instance;
  debugPrint('╔════════════════════════════════════════════════════════════╗');
  debugPrint('║  ${config.appName.padRight(54)} ║');
  debugPrint('╠════════════════════════════════════════════════════════════╣');
  debugPrint('║  Environment: ${AppConfig.environment.name.padRight(42)} ║');
  debugPrint(
      '║  API Base: ${config.apiBaseUrl.padRight(45).substring(0, 45)} ║');
  debugPrint(
      '║  Logging: ${config.enableLogging ? 'Enabled' : 'Disabled'}${' '.padRight(45)} ║'
          .substring(0, 65));
  debugPrint('╚════════════════════════════════════════════════════════════╝');
}

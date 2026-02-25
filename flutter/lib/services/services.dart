/// Services Layer
///
/// Technical services that wrap external dependencies and provide
/// clean interfaces to the rest of the app.
///
/// Services handle:
/// - API communication
/// - Local/secure storage
/// - Third-party integrations (PostHog analytics & error tracking)
///
/// Example:
/// ```dart
/// import 'package:lifeflow/services/services.dart';
///
/// // Access services via locator
/// final apiService = locator<ApiService>();
/// final storage = locator<LocalStorageService>();
/// final analytics = locator<AnalyticsService>();
/// ```
library services;

// Analytics
export 'analytics/analytics_service.dart';
// API
export 'api/api_interceptors.dart';
export 'api/api_response.dart';
export 'api/api_service.dart';
// Connectivity
export 'connectivity/connectivity_service.dart';
// Dialog Helper
export 'dialog/dialog_helper.dart';
// Push Notifications
export 'push_notification/push_notification_service.dart';
// Storage
export 'storage/local_storage_service.dart';
export 'storage/secure_storage_service.dart';
export 'storage/storage_service.dart';
// Supabase
export 'supabase/supabase_auth_service.dart';
export 'supabase/supabase_service.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/domain_repository_impl.dart';
import '../data/repositories/habit_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/i_auth_repository.dart';
import '../domain/repositories/i_domain_repository.dart';
import '../domain/repositories/i_habit_repository.dart';
import '../domain/repositories/i_notification_repository.dart';
import '../modules/optional/payments/payment_service.dart';
import '../services/analytics/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/bilan_service.dart';
import '../services/connectivity/connectivity_service.dart';
import '../services/database/app_database.dart';
import '../services/dialog/dialog_helper.dart';
import '../services/habit_event_service.dart';
import '../services/habit_toggle_service.dart';
import '../services/haptic_service.dart';
import '../services/local_notification/local_notification_scheduler.dart';
import '../services/moneroo/moneroo_service.dart';
import '../services/notification_router/notification_router.dart';
import '../services/push_notification/push_notification_service.dart';
import '../services/settings/app_settings_service.dart';
import '../services/storage/local_storage_service.dart';
import '../services/storage/secure_storage_service.dart';
import '../services/storage/storage_service.dart';
import '../services/supabase/supabase_auth_service.dart';
import '../services/supabase/supabase_service.dart';
import '../services/sync/sync_engine.dart';
import '../services/time_counter_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
  // Register environments
  locator.registerEnvironment(
    environment: environment,
    environmentFilter: environmentFilter,
  );

  // Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerSingleton(LocalStorageService());
  locator.registerLazySingleton(() => SecureStorageService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerSingleton(ConnectivityService());
  locator.registerLazySingleton(() => DialogHelper());
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => SyncEngine());
  locator.registerLazySingleton(() => SupabaseService());
  locator.registerLazySingleton(() => SupabaseAuthService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => HapticService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerSingleton(AppSettingsService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => LocalNotificationScheduler());
  locator.registerLazySingleton(() => NotificationRouter());
  locator.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());
  locator.registerLazySingleton<IDomainRepository>(
    () => DomainRepositoryImpl(),
  );
  locator.registerLazySingleton<IHabitRepository>(() => HabitRepositoryImpl());
  locator.registerLazySingleton<INotificationRepository>(
    () => NotificationRepositoryImpl(),
  );
  locator.registerLazySingleton(() => HabitEventService());
  locator.registerLazySingleton(() => HabitToggleService());
  locator.registerLazySingleton(() => TimeCounterService());
  locator.registerLazySingleton(() => BilanService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => MonerooService());
}

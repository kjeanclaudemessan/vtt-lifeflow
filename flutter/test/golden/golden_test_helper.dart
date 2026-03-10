// ════════════════════════════════════════════════════════════════════════════
// Golden Test Helper — Mocked service setup for screenshot golden tests
// ════════════════════════════════════════════════════════════════════════════
//
// Provides a minimal GetIt setup with mocked services so that Views
// can be rendered in golden tests without a real backend.
//
// Usage:
//   setUpAll(() => GoldenTestHelper.initialize());
//   tearDown(() => GoldenTestHelper.cleanup());
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:lifeflow/core/config/app_config.dart';
import 'package:lifeflow/core/config/env/environment.dart';
import 'package:lifeflow/core/enums/lifeflow_enums.dart';
import 'package:lifeflow/design_system/theme/app_theme.dart';
import 'package:lifeflow/domain/entities/domain_entity.dart';
import 'package:lifeflow/domain/entities/habit_entity.dart';
import 'package:lifeflow/domain/entities/user_entity.dart';
import 'package:lifeflow/domain/repositories/i_auth_repository.dart';
import 'package:lifeflow/domain/repositories/i_domain_repository.dart';
import 'package:lifeflow/domain/repositories/i_habit_repository.dart';
import 'package:lifeflow/domain/repositories/i_notification_repository.dart';
import 'package:lifeflow/l10n/generated/app_localizations.dart';
import 'package:lifeflow/services/analytics/analytics_service.dart';
import 'package:lifeflow/services/habit_event_service.dart';
import 'package:lifeflow/services/habit_toggle_service.dart';
import 'package:lifeflow/services/haptic_service.dart';
import 'package:lifeflow/services/push_notification/push_notification_service.dart';
import 'package:lifeflow/services/settings/app_settings_service.dart';
import 'package:lifeflow/services/storage/local_storage_service.dart';
import 'package:lifeflow/services/supabase/supabase_auth_service.dart';
import 'package:lifeflow/services/supabase/supabase_service.dart';
import 'package:lifeflow/services/time_counter_service.dart';
import 'package:lifeflow/services/bilan_service.dart';
import 'package:lifeflow/services/database/app_database.dart';
import 'package:lifeflow/services/local_notification/local_notification_scheduler.dart';
import 'package:lifeflow/services/connectivity/connectivity_service.dart';
import 'package:lifeflow/services/sync/sync_engine.dart';

import 'package:dartz/dartz.dart';
import 'package:lifeflow/core/errors/failures.dart';
import 'package:lifeflow/domain/entities/habit_log_entity.dart';
import 'package:lifeflow/domain/entities/notification_entity.dart';
import 'package:lifeflow/domain/entities/streak_info.dart';

final _locator = GetIt.instance;

// ═══════════════════════════════════════════════════════════════════════════
// SAMPLE DATA
// ═══════════════════════════════════════════════════════════════════════════

final _now = DateTime(2026, 3, 9, 8, 30);

final sampleDomains = [
  DomainEntity(
    id: 'd1',
    userId: 'u1',
    name: 'Santé',
    icon: '❤️',
    color: '#E53935',
    sortOrder: 0,
    createdAt: _now,
    updatedAt: _now,
  ),
  DomainEntity(
    id: 'd2',
    userId: 'u1',
    name: 'Travail',
    icon: '💼',
    color: '#1E88E5',
    sortOrder: 1,
    createdAt: _now,
    updatedAt: _now,
  ),
  DomainEntity(
    id: 'd3',
    userId: 'u1',
    name: 'Relations',
    icon: '👥',
    color: '#43A047',
    sortOrder: 2,
    createdAt: _now,
    updatedAt: _now,
  ),
  DomainEntity(
    id: 'd4',
    userId: 'u1',
    name: 'Finances',
    icon: '💰',
    color: '#FB8C00',
    sortOrder: 3,
    createdAt: _now,
    updatedAt: _now,
  ),
  DomainEntity(
    id: 'd5',
    userId: 'u1',
    name: 'Développement personnel',
    icon: '🌱',
    color: '#8E24AA',
    sortOrder: 4,
    createdAt: _now,
    updatedAt: _now,
  ),
];

final sampleHabits = [
  HabitEntity(
    id: 'h1',
    userId: 'u1',
    domainId: 'd1',
    name: 'Méditation',
    description: '10 minutes de pleine conscience',
    type: HabitType.binary,
    estimatedDurationMinutes: 10,
    startTime: const TimeOfDay(hour: 7, minute: 0),
    createdAt: _now,
    updatedAt: _now,
  ),
  HabitEntity(
    id: 'h2',
    userId: 'u1',
    domainId: 'd1',
    name: 'Sport',
    description: '30 min de course à pied',
    type: HabitType.binary,
    estimatedDurationMinutes: 30,
    startTime: const TimeOfDay(hour: 7, minute: 30),
    createdAt: _now,
    updatedAt: _now,
  ),
  HabitEntity(
    id: 'h3',
    userId: 'u1',
    domainId: 'd2',
    name: 'Deep Work',
    description: '2h de travail concentré',
    type: HabitType.binary,
    estimatedDurationMinutes: 120,
    startTime: const TimeOfDay(hour: 9, minute: 0),
    createdAt: _now,
    updatedAt: _now,
  ),
  HabitEntity(
    id: 'h4',
    userId: 'u1',
    domainId: 'd3',
    name: 'Appeler un proche',
    type: HabitType.binary,
    estimatedDurationMinutes: 15,
    startTime: const TimeOfDay(hour: 12, minute: 30),
    createdAt: _now,
    updatedAt: _now,
  ),
  HabitEntity(
    id: 'h5',
    userId: 'u1',
    domainId: 'd5',
    name: 'Lecture',
    description: 'Lire 20 pages',
    type: HabitType.quantitative,
    targetValue: 20,
    unit: 'pages',
    estimatedDurationMinutes: 30,
    startTime: const TimeOfDay(hour: 21, minute: 0),
    createdAt: _now,
    updatedAt: _now,
  ),
  HabitEntity(
    id: 'h6',
    userId: 'u1',
    domainId: 'd4',
    name: 'Réviser le budget',
    type: HabitType.binary,
    estimatedDurationMinutes: 15,
    frequency: HabitFrequency.weekly,
    startTime: const TimeOfDay(hour: 19, minute: 0),
    createdAt: _now,
    updatedAt: _now,
  ),
];

final sampleUser = UserEntity(
  id: 'u1',
  email: 'jean@lifeflow.app',
  firstName: 'Jean',
  lastName: 'Dupont',
  displayName: 'Jean Dupont',
  locale: 'fr',
  isEmailVerified: true,
  createdAt: _now,
);

// ═══════════════════════════════════════════════════════════════════════════
// GOLDEN TEST HELPER
// ═══════════════════════════════════════════════════════════════════════════

class GoldenTestHelper {
  /// Initializes GetIt with ALL mocked services needed for golden tests.
  static Future<void> initialize() async {
    await _locator.reset();
    AppConfig.initialize(Environment.development);

    // Stacked services
    _locator.registerSingleton<NavigationService>(NavigationService());
    _locator.registerSingleton<DialogService>(DialogService());
    _locator.registerSingleton<BottomSheetService>(BottomSheetService());
    _locator.registerSingleton<SnackbarService>(SnackbarService());

    // Storage
    _locator
        .registerSingleton<LocalStorageService>(LocalStorageService.test());

    // Supabase
    _locator.registerSingleton<SupabaseService>(_MockSupabaseService());

    // Auth
    _locator.registerSingleton<IAuthRepository>(_MockAuthRepository());
    _locator.registerSingleton<SupabaseAuthService>(
      SupabaseAuthService(supabaseService: _locator<SupabaseService>()),
    );

    // Repositories
    _locator.registerSingleton<IDomainRepository>(_MockDomainRepository());
    _locator.registerSingleton<IHabitRepository>(_MockHabitRepository());
    _locator.registerSingleton<INotificationRepository>(
        _MockNotificationRepository());

    // Services (order matters — HabitToggleService uses locator in field initializers)
    _locator.registerSingleton<AnalyticsService>(_MockAnalyticsService());
    _locator.registerSingleton<PushNotificationService>(
        _MockPushNotificationService());
    _locator.registerSingleton<HabitEventService>(HabitEventService());
    _locator.registerSingleton<HapticService>(HapticService());
    _locator.registerSingleton<HabitToggleService>(HabitToggleService());
    _locator.registerSingleton<TimeCounterService>(TimeCounterService());
    _locator.registerSingleton<BilanService>(BilanService());
    _locator.registerSingleton<AppSettingsService>(_MockAppSettingsService());

    // Infrastructure (stubs — drift disabled)
    _locator.registerSingleton<AppDatabase>(AppDatabase.forTesting());
    _locator.registerSingleton<LocalNotificationScheduler>(
        LocalNotificationScheduler());
    _locator.registerSingleton<ConnectivityService>(_MockConnectivityService());
    _locator.registerSingleton<SyncEngine>(SyncEngine());
  }

  /// Clean up GetIt registrations.
  static Future<void> cleanup() async {
    await _locator.reset();
  }

  /// Wrap a widget with the full app shell (MaterialApp + localization +
  /// ScreenUtil) to render in golden tests.
  static Widget wrapWidget(
    Widget child, {
    Size surfaceSize = const Size(412, 892),
    ThemeData? theme,
    Locale locale = const Locale('fr'),
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: surfaceSize,
        devicePixelRatio: 3.0,
        padding: const EdgeInsets.only(top: 44, bottom: 34),
      ),
      child: ScreenUtilInit(
        designSize: surfaceSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme ?? AppTheme.light,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: child,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MOCK SERVICES
// ═══════════════════════════════════════════════════════════════════════════

class _MockAuthRepository implements IAuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    if (memberName.contains('currentUser') || memberName.contains('getCurrentUser')) {
      return Future<Either<Failure, UserEntity?>>.value(Right<Failure, UserEntity?>(sampleUser));
    }
    if (memberName.contains('watchAuthState') || memberName.contains('authState')) {
      return Stream<UserEntity?>.value(sampleUser);
    }
    if (memberName.contains('isAuthenticated')) {
      return true;
    }
    if (memberName.contains('signOut')) {
      return Future<Either<Failure, Unit>>.value(const Right<Failure, Unit>(unit));
    }
    return null;
  }
}

class _MockSupabaseService extends SupabaseService {
  _MockSupabaseService() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockDomainRepository implements IDomainRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    if (memberName.contains('getDomains') ||
        memberName.contains('watchDomains')) {
      return Future<Either<Failure, List<DomainEntity>>>.value(
        Right<Failure, List<DomainEntity>>(sampleDomains),
      );
    }
    if (memberName.contains('getDomainById')) {
      return Future<Either<Failure, DomainEntity>>.value(
        Right<Failure, DomainEntity>(sampleDomains.first),
      );
    }
    return null;
  }
}

class _MockHabitRepository implements IHabitRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    if (memberName.contains('getHabits') ||
        memberName.contains('getActiveHabits') ||
        memberName.contains('getTodayHabits')) {
      return Future<Either<Failure, List<HabitEntity>>>.value(
        Right<Failure, List<HabitEntity>>(sampleHabits),
      );
    }
    if (memberName.contains('getHabitLogs') ||
        memberName.contains('getLogsForDateRange') ||
        memberName.contains('getTodayLogs')) {
      return Future<Either<Failure, List<HabitLogEntity>>>.value(
        const Right<Failure, List<HabitLogEntity>>([]),
      );
    }
    if (memberName.contains('getStreakInfo')) {
      return Future<Either<Failure, StreakInfo>>.value(
        const Right<Failure, StreakInfo>(StreakInfo.empty),
      );
    }
    if (memberName.contains('logHabit')) {
      return Future<Either<Failure, HabitLogEntity>>.value(
        Right<Failure, HabitLogEntity>(HabitLogEntity(
          id: 'log1', habitId: 'h1', logDate: DateTime.now(), completed: true, createdAt: DateTime.now(),
        )),
      );
    }
    return null;
  }
}

class _MockNotificationRepository implements INotificationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    final memberName = invocation.memberName.toString();
    if (memberName.contains('getNotifications')) {
      return Future<Either<Failure, List<NotificationEntity>>>.value(
        const Right<Failure, List<NotificationEntity>>([]),
      );
    }
    if (memberName.contains('getUnreadCount')) {
      return Future<Either<Failure, int>>.value(
        const Right<Failure, int>(3),
      );
    }
    if (memberName.contains('markAsRead') || memberName.contains('markAllAsRead') ||
        memberName.contains('deleteNotification') || memberName.contains('clearAll')) {
      return Future<Either<Failure, void>>.value(
        const Right<Failure, void>(null),
      );
    }
    return null;
  }
}

class _MockAnalyticsService extends AnalyticsService {
  @override
  bool get isInitialized => false;
  @override
  Future<void> init() async {}
  @override
  Future<void> capture(String eventName,
      {Map<String, Object>? properties}) async {}
  @override
  Future<void> screen(String screenName,
      {Map<String, Object>? properties}) async {}
  @override
  Future<void> identify(
      {required String userId, Map<String, Object>? properties}) async {}
  @override
  Future<void> reset() async {}
  @override
  Future<void> setUserProperties(Map<String, Object> properties) async {}
  @override
  Future<bool> isFeatureEnabled(String flagKey) async => false;
  @override
  Future<dynamic> getFeatureFlag(String flagKey) async => null;
  @override
  Future<dynamic> getFeatureFlagPayload(String flagKey) async => null;
  @override
  Future<void> reloadFeatureFlags() async {}
}

class _MockPushNotificationService extends PushNotificationService {
  @override
  bool get isInitialized => false;
  @override
  String? get token => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockAppSettingsService extends AppSettingsService {
  @override
  late final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);
  @override
  late final ValueNotifier<Locale> locale = ValueNotifier(const Locale('fr'));
  @override
  void init() {}
  @override
  Future<void> setThemeMode(ThemeMode mode) async =>
      themeMode.value = mode;
  @override
  Future<void> setLocale(Locale newLocale) async =>
      locale.value = newLocale;
}

class _MockConnectivityService extends ConnectivityService {
  @override
  bool get isOnline => true;
  @override
  Future<void> init() async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

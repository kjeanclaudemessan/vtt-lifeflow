import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/enums/lifeflow_enums.dart';
import '../../domain/entities/habit_entity.dart';

/// Service for scheduling local notifications (habit reminders, streaks, bilan).
///
/// Uses `flutter_local_notifications` directly — no Firebase required.
/// Works independently of [PushNotificationService] (which is for FCM).
///
/// Usage:
/// ```dart
/// final scheduler = locator<LocalNotificationScheduler>();
/// await scheduler.init();
/// await scheduler.scheduleHabitReminder(habit);
/// ```
class LocalNotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // ─────────────────────────────────────────────────────────────────
  // Notification channels
  // ─────────────────────────────────────────────────────────────────

  static const _reminderChannel = AndroidNotificationChannel(
    'lifeflow_reminders',
    'Rappels d\'habitudes',
    description: 'Rappels quotidiens pour tes habitudes',
    importance: Importance.high,
  );

  static const _streakChannel = AndroidNotificationChannel(
    'lifeflow_streaks',
    'Séries',
    description: 'Notifications de séries et accomplissements',
    importance: Importance.defaultImportance,
  );

  static const _bilanChannel = AndroidNotificationChannel(
    'lifeflow_bilan',
    'Bilan hebdomadaire',
    description: 'Rappel pour ton bilan de la semaine',
    importance: Importance.defaultImportance,
  );

  // ─────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────

  /// Initialize the notification scheduler.
  Future<void> init() async {
    try {
      tz.initializeTimeZones();

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _plugin.initialize(initSettings);

      // Create Android notification channels
      if (!kIsWeb && Platform.isAndroid) {
        final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

        await androidPlugin?.createNotificationChannel(_reminderChannel);
        await androidPlugin?.createNotificationChannel(_streakChannel);
        await androidPlugin?.createNotificationChannel(_bilanChannel);
      }

      _isInitialized = true;
      debugPrint('[LocalNotif] Scheduler initialized');
    } catch (e) {
      debugPrint('[LocalNotif] Failed to initialize: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Habit Reminders
  // ─────────────────────────────────────────────────────────────────

  /// Schedule a daily reminder for a habit based on its [startTime].
  ///
  /// Uses the habit ID hash as notification ID for uniqueness.
  /// If the habit has no startTime, no reminder is scheduled.
  Future<void> scheduleHabitReminder(HabitEntity habit) async {
    if (!_isInitialized) return;
    if (habit.startTime == null) return;
    if (habit.isArchived) return;

    final notifId = habit.id.hashCode.abs() % 100000;

    // Cancel existing reminder for this habit
    await _plugin.cancel(notifId);

    // Determine which days to schedule
    final days = _getDaysForHabit(habit);
    if (days.isEmpty) return;

    // Schedule for each applicable day
    for (final day in days) {
      final scheduledDate = _nextInstanceOfDay(
        day,
        habit.startTime!.hour,
        habit.startTime!.minute,
      );

      final dayNotifId = notifId + day;

      await _plugin.zonedSchedule(
        dayNotifId,
        '⏰ ${habit.name}',
        'C\'est l\'heure de ton habitude !',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _reminderChannel.id,
            _reminderChannel.name,
            channelDescription: _reminderChannel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }

    debugPrint(
        '[LocalNotif] Scheduled reminder for "${habit.name}" at ${habit.startTime!.hour}:${habit.startTime!.minute.toString().padLeft(2, '0')} (${days.length} days)');
  }

  /// Cancel all reminders for a habit.
  Future<void> cancelHabitReminder(HabitEntity habit) async {
    if (!_isInitialized) return;
    final notifId = habit.id.hashCode.abs() % 100000;

    // Cancel for all 7 possible days
    for (var day = 0; day < 7; day++) {
      await _plugin.cancel(notifId + day);
    }

    debugPrint('[LocalNotif] Cancelled reminders for "${habit.name}"');
  }

  /// Reschedule all habit reminders (call after bulk changes).
  Future<void> rescheduleAll(List<HabitEntity> habits) async {
    if (!_isInitialized) return;

    // Cancel all existing
    await _plugin.cancelAll();

    // Reschedule each active habit with a startTime
    for (final habit in habits) {
      if (!habit.isArchived && habit.startTime != null) {
        await scheduleHabitReminder(habit);
      }
    }

    debugPrint('[LocalNotif] Rescheduled ${habits.length} habits');
  }

  // ─────────────────────────────────────────────────────────────────
  // Weekly Bilan Reminder
  // ─────────────────────────────────────────────────────────────────

  /// Schedule a weekly bilan reminder (Sunday 20:00).
  Future<void> scheduleWeeklyBilan() async {
    if (!_isInitialized) return;

    const bilanNotifId = 99999;
    await _plugin.cancel(bilanNotifId);

    final nextSunday = _nextInstanceOfDay(DateTime.sunday, 20, 0);

    await _plugin.zonedSchedule(
      bilanNotifId,
      '📊 Bilan hebdomadaire',
      'C\'est dimanche ! Fais le point sur ta semaine.',
      nextSunday,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _bilanChannel.id,
          _bilanChannel.name,
          channelDescription: _bilanChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    debugPrint('[LocalNotif] Weekly bilan scheduled for Sunday 20:00');
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────

  /// Get the days of the week this habit applies to.
  /// Returns list of [DateTime] day constants (1=Monday, 7=Sunday).
  List<int> _getDaysForHabit(HabitEntity habit) {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return [1, 2, 3, 4, 5, 6, 7]; // All days
      case HabitFrequency.weekly:
      case HabitFrequency.custom:
        if (habit.frequencyDays.isEmpty) return [1]; // Default Monday
        // Convert from 0=Sun,6=Sat to DateTime constants (1=Mon,7=Sun)
        return habit.frequencyDays
            .map((d) => d == 0 ? 7 : d) // 0=Sun → 7=Sun
            .toList();
    }
  }

  /// Calculate next occurrence of [dayOfWeek] at [hour]:[minute].
  tz.TZDateTime _nextInstanceOfDay(int dayOfWeek, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Advance to the target day of week
    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If that time already passed today, go to next week
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}

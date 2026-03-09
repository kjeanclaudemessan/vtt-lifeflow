import 'package:flutter/material.dart';

import '../app/app.locator.dart';
import '../domain/entities/habit_log_entity.dart';
import '../domain/entities/streak_info.dart';
import '../domain/repositories/i_habit_repository.dart';
import 'analytics/analytics_service.dart';
import 'haptic_service.dart';
import 'habit_event_service.dart';

/// Result of a habit toggle operation.
class HabitToggleResult {
  /// The updated log (null if habit was unchecked).
  final HabitLogEntity? log;

  /// Whether the habit is now completed.
  final bool completed;

  /// Error message if the operation failed.
  final String? error;

  /// Updated streak info after the toggle.
  final StreakInfo? streak;

  const HabitToggleResult({
    this.log,
    required this.completed,
    this.error,
    this.streak,
  });

  bool get hasError => error != null;
}

/// Shared service that handles habit toggle, value logging, and time editing.
///
/// Eliminates duplication between [TodayViewModel] and [HabitsViewModel].
/// Both ViewModels delegate toggle operations to this service and only
/// update their own UI state from the returned [HabitToggleResult].
///
/// Registered as a [LazySingleton] in the locator.
class HabitToggleService {
  final _habitRepo = locator<IHabitRepository>();
  final _habitEvents = locator<HabitEventService>();
  final _haptic = locator<HapticService>();

  /// Toggles a habit's completion for today.
  ///
  /// If [existingLog] is completed → removes the log (un-check).
  /// Otherwise → logs the habit as completed with optional [value]
  /// and auto-records [actualStartTime] when [recordStartTime] is true.
  Future<HabitToggleResult> toggleHabit({
    required String habitId,
    HabitLogEntity? existingLog,
    double? value,
    bool recordStartTime = false,
  }) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (existingLog != null && existingLog.completed) {
      // Un-check: remove log
      final result = await _habitRepo.removeLog(
        habitId: habitId,
        date: todayDate,
      );

      return result.fold(
        (failure) =>
            HabitToggleResult(completed: false, error: failure.message),
        (_) {
          _haptic.light();
          locator<AnalyticsService>().capture(
            'habit_uncompleted',
            properties: {'habit_id': habitId},
          );
          return const HabitToggleResult(completed: false);
        },
      );
    } else {
      // Check: log habit
      final result = await _habitRepo.logHabit(
        habitId: habitId,
        date: todayDate,
        completed: true,
        value: value,
        actualStartTime: recordStartTime ? TimeOfDay.now() : null,
      );

      return result.fold(
        (failure) => HabitToggleResult(completed: true, error: failure.message),
        (log) {
          _haptic.success();
          return HabitToggleResult(log: log, completed: true);
        },
      );
    }
  }

  /// Logs a quantitative habit with a specific value.
  ///
  /// [completed] is determined by comparing [value] to [targetValue].
  Future<HabitToggleResult> logWithValue({
    required String habitId,
    required double value,
    required double targetValue,
  }) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final completed = value >= targetValue;

    final result = await _habitRepo.logHabit(
      habitId: habitId,
      date: todayDate,
      completed: completed,
      value: value,
      actualStartTime: TimeOfDay.now(),
    );

    return result.fold(
      (failure) =>
          HabitToggleResult(completed: completed, error: failure.message),
      (log) {
        _haptic.success();
        locator<AnalyticsService>().capture(
          'habit_value_logged',
          properties: {
            'habit_id': habitId,
            'value': value,
            'completed': completed,
          },
        );
        return HabitToggleResult(log: log, completed: completed);
      },
    );
  }

  /// Refreshes the streak for a single habit.
  Future<StreakInfo?> refreshStreak(String habitId) async {
    final streakResult = await _habitRepo.getStreakInfo(habitId);
    return streakResult.fold((_) => null, (info) => info);
  }

  /// Loads streaks for multiple habits in parallel.
  Future<Map<String, StreakInfo>> loadStreaksBatch(
    List<String> habitIds,
  ) async {
    final results = await Future.wait(
      habitIds.map((id) => _habitRepo.getStreakInfo(id)),
    );

    final streaks = <String, StreakInfo>{};
    for (var i = 0; i < habitIds.length; i++) {
      results[i].fold((_) {}, (info) => streaks[habitIds[i]] = info);
    }
    return streaks;
  }

  /// Notifies listeners that habit data changed.
  void notifyChanged() => _habitEvents.notifyHabitChanged();
}

import 'package:flutter/material.dart';

import '../../core/typedefs/typedefs.dart';
import '../entities/habit_entity.dart';
import '../entities/habit_log_entity.dart';
import '../entities/streak_info.dart';

/// Contract for habit and habit log operations.
///
/// Implementations: [HabitRepositoryImpl]
abstract class IHabitRepository {
  // ─────────────────────────────────────────────────────────────────
  // Habits CRUD
  // ─────────────────────────────────────────────────────────────────

  /// Gets habits for the current user, optionally filtered.
  FutureResult<List<HabitEntity>> getHabits({
    String? domainId,
    bool? isArchived,
  });

  /// Gets a single habit by ID.
  FutureResult<HabitEntity> getHabitById(String id);

  /// Creates a new habit.
  FutureResult<HabitEntity> createHabit(HabitEntity entity);

  /// Updates an existing habit.
  FutureResult<HabitEntity> updateHabit(HabitEntity entity);

  /// Archives a habit (soft delete).
  FutureResult<void> archiveHabit(String id);

  // ─────────────────────────────────────────────────────────────────
  // Habit Logs
  // ─────────────────────────────────────────────────────────────────

  /// Gets habit logs for all user habits within a date range.
  FutureResult<List<HabitLogEntity>> getLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Logs a habit for a specific date (UPSERT — creates or updates).
  ///
  /// For binary habits: [value] is null, [completed] = true.
  /// For quantitative: [value] is the actual input, [completed] = value >= target.
  FutureResult<HabitLogEntity> logHabit({
    required String habitId,
    required DateTime date,
    required bool completed,
    double? value,
    TimeOfDay? actualStartTime,
    TimeOfDay? actualEndTime,
  });

  /// Removes a habit log for a specific date (uncheck).
  FutureResult<void> removeLog({
    required String habitId,
    required DateTime date,
  });

  // ─────────────────────────────────────────────────────────────────
  // Streaks
  // ─────────────────────────────────────────────────────────────────

  /// Gets streak information for a specific habit.
  ///
  /// [freezeEnabled]: Whether to apply streak freeze (1 gap per 7-day window).
  FutureResult<StreakInfo> getStreakInfo(
    String habitId, {
    bool freezeEnabled = true,
  });
}

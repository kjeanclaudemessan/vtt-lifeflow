import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'habit_entity.dart';

/// Represents a single habit log entry in the domain layer.
///
/// One log per habit per day (enforced by UNIQUE constraint in DB).
/// For binary habits: [completed] = true, [value] = null.
/// For quantitative habits: [value] = user input, [completed] = value >= target.
class HabitLogEntity extends Equatable {
  /// Unique identifier.
  final String id;

  /// The habit this log belongs to.
  final String habitId;

  /// The date of this log entry.
  final DateTime logDate;

  /// Whether the habit was completed for this day.
  final bool completed;

  /// The actual value for quantitative habits (null for binary).
  final double? value;

  /// The actual start time the habit was performed (null = used habit.startTime).
  final TimeOfDay? actualStartTime;

  /// The actual end time the habit was performed (null = computed from start + duration).
  final TimeOfDay? actualEndTime;

  /// When this log was created.
  final DateTime createdAt;

  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.logDate,
    this.completed = false,
    this.value,
    this.actualStartTime,
    this.actualEndTime,
    required this.createdAt,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  /// Completion percentage for quantitative habits.
  ///
  /// Returns 1.0 for completed binary habits, 0.0 for uncompleted,
  /// and `value / targetValue` (clamped 0–1) for quantitative.
  double completionPercentage(double targetValue) {
    if (value != null && targetValue > 0) {
      return (value! / targetValue).clamp(0.0, 1.0);
    }
    return completed ? 1.0 : 0.0;
  }

  /// Minutes this log contributes to the time counter.
  ///
  /// Delegates to [HabitEntity.effectiveDuration] which handles:
  /// - Binary → estimated_duration_minutes
  /// - Quantitative + unit='min' → actual value
  /// - Quantitative + other unit → estimated_duration_minutes
  double contributedMinutes(HabitEntity habit) {
    if (!completed) return 0;
    return habit.effectiveDuration(value);
  }

  /// Calculates time adherence (0.0–1.0) for this log vs the habit’s planned slot.
  ///
  /// Returns 1.0 if:
  /// - The habit has no planned time slot (`habit.startTime == null`)
  /// - The actual time matches the planned slot
  /// Returns a degraded score based on how far the actual time deviates.
  double timeAdherence(HabitEntity habit) {
    if (habit.startTime == null) return 1.0;
    final actual = actualStartTime ?? habit.startTime!;
    final planned = habit.startTime!;
    final diffMinutes =
        ((actual.hour * 60 + actual.minute) -
                (planned.hour * 60 + planned.minute))
            .abs();
    if (diffMinutes <= 15) return 1.0;
    if (diffMinutes <= 60) return 0.85;
    if (diffMinutes <= 120) return 0.6;
    return 0.4;
  }

  /// Human-readable adherence label.
  ///
  /// Returns null if within the planned slot.
  String? adherenceLabel(HabitEntity habit) {
    if (habit.startTime == null) return null;
    final actual = actualStartTime ?? habit.startTime!;
    final planned = habit.startTime!;
    final diffMinutes =
        (actual.hour * 60 + actual.minute) -
        (planned.hour * 60 + planned.minute);
    if (diffMinutes.abs() <= 15) return null; // On time
    final sign = diffMinutes > 0 ? '+' : '-';
    final abs = diffMinutes.abs();
    if (abs < 60) return '$sign${abs}min';
    final h = abs ~/ 60;
    final m = abs % 60;
    return m > 0 ? '$sign${h}h${m.toString().padLeft(2, '0')}' : '$sign${h}h';
  }

  // ─────────────────────────────────────────────────────────────────
  // Copy
  // ─────────────────────────────────────────────────────────────────

  /// Creates a copy with the given fields replaced.
  HabitLogEntity copyWith({
    String? id,
    String? habitId,
    DateTime? logDate,
    bool? completed,
    double? value,
    TimeOfDay? actualStartTime,
    TimeOfDay? actualEndTime,
    DateTime? createdAt,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      logDate: logDate ?? this.logDate,
      completed: completed ?? this.completed,
      value: value ?? this.value,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Factories
  // ─────────────────────────────────────────────────────────────────

  /// Creates an empty log for initialization.
  factory HabitLogEntity.empty() {
    final now = DateTime.now();
    return HabitLogEntity(
      id: '',
      habitId: '',
      logDate: now,
      actualStartTime: null,
      actualEndTime: null,
      createdAt: now,
    );
  }

  /// Creates a mock log for testing.
  factory HabitLogEntity.mock({
    String id = 'mock-log-id',
    String habitId = 'mock-habit-id',
    bool completed = true,
    double? value,
    DateTime? logDate,
  }) {
    final now = DateTime.now();
    return HabitLogEntity(
      id: id,
      habitId: habitId,
      logDate: logDate ?? now,
      completed: completed,
      value: value,
      actualStartTime: null,
      actualEndTime: null,
      createdAt: now,
    );
  }

  @override
  List<Object?> get props => [
    id,
    habitId,
    logDate,
    completed,
    value,
    actualStartTime,
    actualEndTime,
    createdAt,
  ];

  @override
  String toString() =>
      'HabitLogEntity(id: $id, habitId: $habitId, date: $logDate, completed: $completed)';
}

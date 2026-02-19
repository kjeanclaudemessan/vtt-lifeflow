import 'package:equatable/equatable.dart';

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

  /// When this log was created.
  final DateTime createdAt;

  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.logDate,
    this.completed = false,
    this.value,
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
    DateTime? createdAt,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      logDate: logDate ?? this.logDate,
      completed: completed ?? this.completed,
      value: value ?? this.value,
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
      createdAt: now,
    );
  }

  @override
  List<Object?> get props =>
      [id, habitId, logDate, completed, value, createdAt];

  @override
  String toString() =>
      'HabitLogEntity(id: $id, habitId: $habitId, date: $logDate, completed: $completed)';
}

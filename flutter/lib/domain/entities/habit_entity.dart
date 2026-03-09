import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/enums/lifeflow_enums.dart';

/// Represents a habit in the domain layer.
///
/// Habits are behaviors tracked daily (binary or quantitative),
/// linked to a [DomainEntity], with an estimated duration for the time counter.
class HabitEntity extends Equatable {
  /// Unique identifier.
  final String id;

  /// Owner user ID.
  final String userId;

  /// Associated domain ID (nullable — domain may be deleted).
  final String? domainId;

  /// Habit name (e.g., "Méditation", "Lire 30 min").
  final String name;

  /// Optional description.
  final String? description;

  /// Binary (done/not done) or quantitative (tracked with a value).
  final HabitType type;

  /// Target value for quantitative habits (e.g., 2000 for 2000ml water).
  final double? targetValue;

  /// Unit for quantitative habits (e.g., "ml", "min", "pages").
  final String? unit;

  /// How much time this habit represents for the time counter.
  final int estimatedDurationMinutes;

  /// Start of the preferred time range (for TodayView grouping).
  final TimeOfDay? startTime;

  /// How often this habit should be tracked.
  final HabitFrequency frequency;

  /// Days of the week for weekly/custom frequency (0=Sun, 6=Sat).
  final List<int> frequencyDays;

  /// Whether local notification reminders are enabled for this habit.
  final bool notificationsEnabled;

  /// Minutes before [startTime] to send the notification reminder.
  final int reminderOffsetMinutes;

  /// Whether the habit is archived (soft delete).
  final bool isArchived;

  /// When the habit was created.
  final DateTime createdAt;

  /// When the habit was last updated.
  final DateTime updatedAt;

  const HabitEntity({
    required this.id,
    required this.userId,
    this.domainId,
    required this.name,
    this.description,
    this.type = HabitType.binary,
    this.targetValue,
    this.unit,
    this.estimatedDurationMinutes = 15,
    this.startTime,
    this.frequency = HabitFrequency.daily,
    this.frequencyDays = const [],
    this.notificationsEnabled = true,
    this.reminderOffsetMinutes = 5,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  /// Whether this is a quantitative habit.
  bool get isQuantitative => type == HabitType.quantitative;

  /// Time slot based on [startTime] (for TodayView grouping).
  TimeSlot get timeSlot => TimeSlot.fromHour(startTime?.hour);

  /// Computed end time: [startTime] + [estimatedDurationMinutes].
  /// Returns `null` if [startTime] is null.
  TimeOfDay? get endTime {
    if (startTime == null) return null;
    final totalMinutes =
        startTime!.hour * 60 + startTime!.minute + estimatedDurationMinutes;
    return TimeOfDay(
      hour: (totalMinutes ~/ 60) % 24,
      minute: totalMinutes % 60,
    );
  }

  /// Formatted time range label (e.g., "6h – 6h30").
  /// Returns `null` if no time range is set.
  String? get timeRangeLabel {
    if (startTime == null) return null;
    final start =
        '${startTime!.hour}h${startTime!.minute > 0 ? startTime!.minute.toString().padLeft(2, '0') : ''}';
    final end = endTime!;
    final endStr =
        '${end.hour}h${end.minute > 0 ? end.minute.toString().padLeft(2, '0') : ''}';
    return '$start – $endStr';
  }

  /// Calculates the effective duration in minutes for the time counter.
  ///
  /// Logic (from D-006):
  /// - Quantitative + unit='min' → actual [logValue]
  /// - Everything else → [estimatedDurationMinutes]
  double effectiveDuration(double? logValue) {
    if (isQuantitative && unit == 'min' && logValue != null) {
      return logValue;
    }
    return estimatedDurationMinutes.toDouble();
  }

  /// Whether this habit should be tracked today.
  bool get isScheduledForToday {
    final now = DateTime.now();
    final weekday = now.weekday % 7; // 0=Sun, 6=Sat
    return switch (frequency) {
      HabitFrequency.daily => true,
      HabitFrequency.weekly => frequencyDays.contains(weekday),
      HabitFrequency.custom => frequencyDays.contains(weekday),
    };
  }

  // ─────────────────────────────────────────────────────────────────
  // Copy
  // ─────────────────────────────────────────────────────────────────

  /// Creates a copy with the given fields replaced.
  HabitEntity copyWith({
    String? id,
    String? userId,
    String? domainId,
    String? name,
    String? description,
    HabitType? type,
    double? targetValue,
    String? unit,
    int? estimatedDurationMinutes,
    TimeOfDay? startTime,
    HabitFrequency? frequency,
    List<int>? frequencyDays,
    bool? notificationsEnabled,
    int? reminderOffsetMinutes,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      domainId: domainId ?? this.domainId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      startTime: startTime ?? this.startTime,
      frequency: frequency ?? this.frequency,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Factories
  // ─────────────────────────────────────────────────────────────────

  /// Creates an empty habit for form initialization.
  factory HabitEntity.empty() {
    final now = DateTime.now();
    return HabitEntity(
      id: '',
      userId: '',
      name: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates a mock habit for testing.
  factory HabitEntity.mock({
    String id = 'mock-habit-id',
    String name = 'Méditation',
    HabitType type = HabitType.binary,
    int estimatedDurationMinutes = 15,
    String? domainId = 'mock-domain-id',
  }) {
    final now = DateTime.now();
    return HabitEntity(
      id: id,
      userId: 'mock-user-id',
      domainId: domainId,
      name: name,
      type: type,
      estimatedDurationMinutes: estimatedDurationMinutes,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    domainId,
    name,
    description,
    type,
    targetValue,
    unit,
    estimatedDurationMinutes,
    startTime,
    frequency,
    frequencyDays,
    notificationsEnabled,
    reminderOffsetMinutes,
    isArchived,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'HabitEntity(id: $id, name: $name, type: $type)';
}

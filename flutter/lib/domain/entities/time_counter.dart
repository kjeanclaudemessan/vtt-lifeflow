import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'habit_entity.dart';

/// Computed time counter for a single domain for a given week.
///
/// Not stored in Supabase — calculated client-side from habit_logs × habits.
class TimeCounter extends Equatable {
  /// Domain ID.
  final String domainId;

  /// Domain display name.
  final String domainName;

  /// Domain color.
  final Color domainColor;

  /// Domain icon.
  final String domainIcon;

  /// Total minutes accumulated this week.
  final int totalMinutesThisWeek;

  /// Total minutes from last week (for delta calculation).
  final int totalMinutesLastWeek;

  /// Per-habit breakdown: habit → minutes contributed this week.
  final Map<HabitEntity, int> habitBreakdown;

  const TimeCounter({
    required this.domainId,
    required this.domainName,
    required this.domainColor,
    this.domainIcon = '🎯',
    this.totalMinutesThisWeek = 0,
    this.totalMinutesLastWeek = 0,
    this.habitBreakdown = const {},
  });

  /// Difference in minutes between this week and last week.
  int get deltaMinutes => totalMinutesThisWeek - totalMinutesLastWeek;

  /// Whether time increased compared to last week.
  bool get isPositiveDelta => deltaMinutes > 0;

  /// This week's time formatted as hours.
  double get hoursThisWeek => totalMinutesThisWeek / 60;

  @override
  List<Object?> get props => [
        domainId,
        totalMinutesThisWeek,
        totalMinutesLastWeek,
        habitBreakdown,
      ];
}

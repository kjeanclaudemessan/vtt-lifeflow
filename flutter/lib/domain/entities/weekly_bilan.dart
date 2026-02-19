import 'package:equatable/equatable.dart';

import 'habit_entity.dart';
import 'streak_info.dart';
import 'time_counter.dart';

/// Computed weekly summary (bilan) for a given week.
///
/// Not stored in Supabase — calculated client-side by BilanService.
class WeeklyBilan extends Equatable {
  /// Monday of the week this bilan covers.
  final DateTime weekStartDate;

  /// Time counters per domain.
  final List<TimeCounter> domainTimes;

  /// Total minutes across all domains.
  final int totalMinutes;

  /// Total minutes from the previous week.
  final int totalMinutesLastWeek;

  /// Completion rate: habits completed / habits expected (0.0–1.0).
  final double completionRate;

  /// Most consistent habit this week (highest completion rate).
  final HabitEntity? topHabit;

  /// Longest active streak among all habits.
  final StreakInfo? longestStreak;

  /// Whether this is the user's first week (no delta possible).
  final bool isFirstWeek;

  const WeeklyBilan({
    required this.weekStartDate,
    this.domainTimes = const [],
    this.totalMinutes = 0,
    this.totalMinutesLastWeek = 0,
    this.completionRate = 0,
    this.topHabit,
    this.longestStreak,
    this.isFirstWeek = true,
  });

  /// Difference in total minutes between this and last week.
  int get deltaMinutes => totalMinutes - totalMinutesLastWeek;

  /// Total hours (for display).
  double get totalHours => totalMinutes / 60;

  /// Completion rate as percentage string (e.g., "78%").
  String get completionRateLabel => '${(completionRate * 100).round()}%';

  /// An empty bilan.
  factory WeeklyBilan.empty() {
    return WeeklyBilan(
      weekStartDate: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        weekStartDate,
        domainTimes,
        totalMinutes,
        totalMinutesLastWeek,
        completionRate,
        topHabit,
        longestStreak,
        isFirstWeek,
      ];
}

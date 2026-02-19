import '../core/enums/lifeflow_enums.dart';
import '../domain/entities/domain_entity.dart';
import '../domain/entities/habit_entity.dart';
import '../domain/entities/habit_log_entity.dart';
import '../domain/entities/streak_info.dart';
import '../domain/entities/weekly_bilan.dart';
import 'time_counter_service.dart';

/// Pure calculation service for the weekly bilan feature.
///
/// No Supabase dependency — takes data in, returns a computed [WeeklyBilan].
/// Logic follows D-007 from research.md.
class BilanService {
  final TimeCounterService _timeCounterService;

  BilanService({TimeCounterService? timeCounterService})
      : _timeCounterService = timeCounterService ?? TimeCounterService();

  /// Generates a weekly bilan from raw data.
  ///
  /// [habits] — all active habits.
  /// [logsThisWeek] — logs for the target week.
  /// [logsLastWeek] — logs for the previous week (empty if first week).
  /// [domains] — all active domains.
  /// [weekStartDate] — Monday of the target week.
  /// [streaks] — map of habitId → StreakInfo (optional).
  WeeklyBilan generateBilan({
    required List<HabitEntity> habits,
    required List<HabitLogEntity> logsThisWeek,
    required List<HabitLogEntity> logsLastWeek,
    required List<DomainEntity> domains,
    required DateTime weekStartDate,
    Map<String, StreakInfo> streaks = const {},
  }) {
    final isFirstWeek = logsLastWeek.isEmpty;

    // Time counters per domain
    final domainTimes = _timeCounterService.getWeeklyCounters(
      habits: habits,
      logsThisWeek: logsThisWeek,
      logsLastWeek: logsLastWeek,
      domains: domains,
    );

    // Total minutes
    final totalMinutes =
        domainTimes.fold<int>(0, (sum, c) => sum + c.totalMinutesThisWeek);
    final totalMinutesLastWeek =
        domainTimes.fold<int>(0, (sum, c) => sum + c.totalMinutesLastWeek);

    // Completion rate: logs completed / expected checks
    final completionRate = _calculateCompletionRate(
      habits: habits,
      logs: logsThisWeek,
      weekStartDate: weekStartDate,
    );

    // Top habit: highest completion rate this week
    final topHabit = _findTopHabit(
      habits: habits,
      logs: logsThisWeek,
      weekStartDate: weekStartDate,
    );

    // Longest streak
    StreakInfo? longestStreak;
    if (streaks.isNotEmpty) {
      final sorted = streaks.entries.toList()
        ..sort(
            (a, b) => b.value.currentStreak.compareTo(a.value.currentStreak));
      longestStreak = sorted.first.value;
    }

    return WeeklyBilan(
      weekStartDate: weekStartDate,
      domainTimes: domainTimes,
      totalMinutes: totalMinutes,
      totalMinutesLastWeek: totalMinutesLastWeek,
      completionRate: completionRate,
      topHabit: topHabit,
      longestStreak: longestStreak,
      isFirstWeek: isFirstWeek,
    );
  }

  /// Calculates the completion rate for the week.
  ///
  /// Expected = sum of scheduled days per habit × 7 days.
  /// Actual = completed logs.
  double _calculateCompletionRate({
    required List<HabitEntity> habits,
    required List<HabitLogEntity> logs,
    required DateTime weekStartDate,
  }) {
    int totalExpected = 0;
    int totalCompleted = 0;

    for (final habit in habits) {
      if (habit.isArchived) continue;

      // Count expected days this week
      for (int d = 0; d < 7; d++) {
        final date = weekStartDate.add(Duration(days: d));
        final weekday = date.weekday % 7; // 0=Sun, 6=Sat

        final isScheduled = switch (habit.frequency) {
          HabitFrequency.daily => true,
          HabitFrequency.weekly => habit.frequencyDays.contains(weekday),
          HabitFrequency.custom => habit.frequencyDays.contains(weekday),
        };

        if (isScheduled) {
          totalExpected++;
          final hasLog = logs.any(
            (l) =>
                l.habitId == habit.id &&
                l.completed &&
                _isSameDay(l.logDate, date),
          );
          if (hasLog) totalCompleted++;
        }
      }
    }

    if (totalExpected == 0) return 0;
    return totalCompleted / totalExpected;
  }

  /// Finds the habit with the highest completion rate this week.
  HabitEntity? _findTopHabit({
    required List<HabitEntity> habits,
    required List<HabitLogEntity> logs,
    required DateTime weekStartDate,
  }) {
    HabitEntity? topHabit;
    double topRate = 0;

    for (final habit in habits) {
      if (habit.isArchived) continue;

      int expected = 0;
      int completed = 0;

      for (int d = 0; d < 7; d++) {
        final date = weekStartDate.add(Duration(days: d));
        final weekday = date.weekday % 7;

        final isScheduled = switch (habit.frequency) {
          HabitFrequency.daily => true,
          HabitFrequency.weekly => habit.frequencyDays.contains(weekday),
          HabitFrequency.custom => habit.frequencyDays.contains(weekday),
        };

        if (isScheduled) {
          expected++;
          final hasLog = logs.any(
            (l) =>
                l.habitId == habit.id &&
                l.completed &&
                _isSameDay(l.logDate, date),
          );
          if (hasLog) completed++;
        }
      }

      if (expected > 0) {
        final rate = completed / expected;
        if (rate > topRate || (rate == topRate && topHabit == null)) {
          topRate = rate;
          topHabit = habit;
        }
      }
    }

    return topHabit;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

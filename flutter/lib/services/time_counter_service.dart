import '../domain/entities/domain_entity.dart';
import '../domain/entities/habit_entity.dart';
import '../domain/entities/habit_log_entity.dart';
import '../domain/entities/time_counter.dart';

/// Pure calculation service for the time counter feature.
///
/// No Supabase dependency — takes data in, returns computed results.
/// Logic follows D-006 from research.md.
class TimeCounterService {
  /// Calculates weekly time counters per domain.
  ///
  /// [habits] — all active habits for the user.
  /// [logsThisWeek] — logs for the current week.
  /// [logsLastWeek] — logs for the previous week.
  /// [domains] — all active domains.
  List<TimeCounter> getWeeklyCounters({
    required List<HabitEntity> habits,
    required List<HabitLogEntity> logsThisWeek,
    required List<HabitLogEntity> logsLastWeek,
    required List<DomainEntity> domains,
  }) {
    final counters = <TimeCounter>[];

    for (final domain in domains) {
      if (domain.isArchived) continue;

      final domainHabits = habits.where((h) => h.domainId == domain.id);
      if (domainHabits.isEmpty) continue;

      // Calculate this week
      int minutesThisWeek = 0;
      final habitBreakdown = <HabitEntity, int>{};

      for (final habit in domainHabits) {
        final habitLogs = logsThisWeek
            .where((l) => l.habitId == habit.id && l.completed)
            .toList();

        int habitMinutes = 0;
        for (final log in habitLogs) {
          habitMinutes += log.contributedMinutes(habit).round();
        }

        if (habitMinutes > 0) {
          habitBreakdown[habit] = habitMinutes;
          minutesThisWeek += habitMinutes;
        }
      }

      // Calculate last week
      int minutesLastWeek = 0;
      for (final habit in domainHabits) {
        final habitLogs = logsLastWeek
            .where((l) => l.habitId == habit.id && l.completed)
            .toList();

        for (final log in habitLogs) {
          minutesLastWeek += log.contributedMinutes(habit).round();
        }
      }

      counters.add(TimeCounter(
        domainId: domain.id,
        domainName: domain.name,
        domainColor: domain.displayColor,
        domainIcon: domain.icon,
        totalMinutesThisWeek: minutesThisWeek,
        totalMinutesLastWeek: minutesLastWeek,
        habitBreakdown: habitBreakdown,
      ));
    }

    // Sort by total minutes descending
    counters.sort(
      (a, b) => b.totalMinutesThisWeek.compareTo(a.totalMinutesThisWeek),
    );

    return counters;
  }

  /// Calculates total minutes per domain for a single day.
  ///
  /// Returns a map of domainId → total minutes.
  Map<String, int> getDailyTotal({
    required List<HabitEntity> habits,
    required List<HabitLogEntity> logs,
    required DateTime date,
  }) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final dayLogs = logs.where((l) {
      final logDate = DateTime(l.logDate.year, l.logDate.month, l.logDate.day);
      return logDate == dateOnly && l.completed;
    });

    final result = <String, int>{};
    for (final log in dayLogs) {
      final habit = habits.firstWhere(
        (h) => h.id == log.habitId,
        orElse: () => HabitEntity.empty(),
      );
      if (habit.id.isEmpty || habit.domainId == null) continue;

      final minutes = log.contributedMinutes(habit).round();
      result[habit.domainId!] = (result[habit.domainId!] ?? 0) + minutes;
    }

    return result;
  }

  /// Gets the start of the week (Monday) for a given date.
  static DateTime weekStart(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  /// Gets the end of the week (Sunday) for a given date.
  static DateTime weekEnd(DateTime date) {
    final start = weekStart(date);
    return start.add(const Duration(days: 6));
  }
}

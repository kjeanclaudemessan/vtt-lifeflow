import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/lifeflow_enums.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/streak_info.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';
import '../../../domain/repositories/i_notification_repository.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/habit_event_service.dart';
import '../../../services/habit_toggle_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/time_counter_service.dart';

/// ViewModel for the today dashboard.
///
/// Adapts to time of day (morning/progress/bilan) using [TodayMode].
class TodayViewModel extends BaseViewModel {
  final _habitRepo = locator<IHabitRepository>();
  final _domainRepo = locator<IDomainRepository>();
  final _counterService = locator<TimeCounterService>();
  final _notifRepo = locator<INotificationRepository>();
  final _habitEvents = locator<HabitEventService>();
  final _toggleService = locator<HabitToggleService>();
  final _haptic = locator<HapticService>();

  List<HabitEntity> _todayHabits = [];
  List<DomainEntity> _domains = [];
  Map<String, HabitLogEntity> _todayLogs = {};
  Map<String, StreakInfo> _streaks = {};

  /// Unread notification count for badge.
  int _unreadNotificationCount = 0;
  int get unreadNotificationCount => _unreadNotificationCount;

  /// Whether user just completed all habits (triggers celebration).
  bool _justCompletedAll = false;
  bool get justCompletedAll => _justCompletedAll;

  /// Reset celebration flag after animation plays.
  void clearCelebration() {
    _justCompletedAll = false;
    rebuildUi();
  }

  /// Current mode based on hour.
  TodayMode get mode => TodayMode.fromHour(DateTime.now().hour);

  /// All habits scheduled for today.
  List<HabitEntity> get todayHabits => _todayHabits;

  /// Completed habits.
  List<HabitEntity> get completedHabits =>
      _todayHabits.where((h) => _todayLogs[h.id]?.completed == true).toList();

  /// Remaining habits (not completed).
  List<HabitEntity> get remainingHabits =>
      _todayHabits.where((h) => _todayLogs[h.id]?.completed != true).toList();

  /// Completion rate for today.
  double get completionRate {
    if (_todayHabits.isEmpty) return 0;
    return completedHabits.length / _todayHabits.length;
  }

  /// Habits grouped by time slot.
  Map<TimeSlot, List<HabitEntity>> get habitsByTimeSlot {
    final map = <TimeSlot, List<HabitEntity>>{};
    for (final habit in _todayHabits) {
      map.putIfAbsent(habit.timeSlot, () => []).add(habit);
    }
    return Map.fromEntries(
      map.entries.toList()
        ..sort((a, b) => a.key.sortWeight.compareTo(b.key.sortWeight)),
    );
  }

  /// Active domains.
  List<DomainEntity> get domains =>
      _domains.where((d) => !d.isArchived).toList();

  /// Domain for a habit.
  DomainEntity? domainFor(String? domainId) {
    if (domainId == null) return null;
    try {
      return _domains.firstWhere((d) => d.id == domainId);
    } catch (_) {
      return null;
    }
  }

  /// Today's log for a habit.
  HabitLogEntity? todayLogFor(String habitId) => _todayLogs[habitId];

  /// Streak for a habit.
  StreakInfo streakFor(String habitId) => _streaks[habitId] ?? StreakInfo.empty;

  /// Today's time per domain.
  Map<String, int> _todayDomainMinutes = {};
  Map<String, int> get todayDomainMinutes => _todayDomainMinutes;

  /// Total minutes tracked this week.
  int _weeklyTotalMinutes = 0;
  int get weeklyTotalMinutes => _weeklyTotalMinutes;

  /// Whether to show bilan card (Sunday evening or Monday morning).
  bool get showBilanCard {
    final now = DateTime.now();
    final isSundayEvening = now.weekday == 7 && now.hour >= 18;
    final isMondayMorning = now.weekday == 1 && now.hour < 12;
    return isSundayEvening || isMondayMorning;
  }

  Future<void> init() async {
    _habitEvents.addListener(_onHabitDataChanged);
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  void _onHabitDataChanged() {
    _loadData();
  }

  @override
  void dispose() {
    _habitEvents.removeListener(_onHabitDataChanged);
    super.dispose();
  }

  Future<void> _loadData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = TimeCounterService.weekStart(now);
    final weekEnd = TimeCounterService.weekEnd(weekStart);

    // Load all in parallel
    final results = await Future.wait([
      _habitRepo.getHabits(),
      _domainRepo.getDomains(),
      _habitRepo.getLogsForDateRange(today, today),
      _habitRepo.getLogsForDateRange(weekStart, weekEnd),
    ]);

    List<HabitEntity> allHabits = [];
    results[0].fold(
      (f) => setError(f.message),
      (habits) => allHabits = habits as List<HabitEntity>,
    );

    results[1].fold(
      (f) => setError(f.message),
      (domains) => _domains = domains as List<DomainEntity>,
    );

    List<HabitLogEntity> todayLogs = [];
    results[2].fold((f) {}, (logs) => todayLogs = logs as List<HabitLogEntity>);

    List<HabitLogEntity> weekLogs = [];
    results[3].fold((f) {}, (logs) => weekLogs = logs as List<HabitLogEntity>);

    // Filter to today's scheduled habits
    _todayHabits = allHabits
        .where((h) => !h.isArchived && h.isScheduledForToday)
        .toList();

    // Map today's logs by habit ID
    _todayLogs = {for (final log in todayLogs) log.habitId: log};

    // Calculate today's domain minutes
    _todayDomainMinutes = _counterService.getDailyTotal(
      habits: allHabits,
      logs: todayLogs,
      date: today,
    );

    // Weekly total
    _weeklyTotalMinutes = weekLogs.fold(0, (sum, log) {
      final habit = allHabits.where((h) => h.id == log.habitId).firstOrNull;
      if (habit == null || !log.completed) return sum;
      return sum + habit.effectiveDuration(log.value).round();
    });

    // Load streaks in parallel
    _streaks = await _toggleService.loadStreaksBatch(
      _todayHabits.map((h) => h.id).toList(),
    );

    // Load unread notification count
    final notifResult = await _notifRepo.getUnreadCount();
    notifResult.fold((_) {}, (count) => _unreadNotificationCount = count);

    rebuildUi();
  }

  /// Toggle a habit check for today.
  ///
  /// For binary habits: toggles completed on/off. Auto-records actualStartTime.
  /// For quantitative: should NOT be called directly — use [logHabitWithValue].
  Future<void> toggleHabit(String habitId, {double? value}) async {
    final result = await _toggleService.toggleHabit(
      habitId: habitId,
      existingLog: _todayLogs[habitId],
      value: value,
      recordStartTime: true,
    );

    if (result.hasError) {
      setError(result.error);
      return;
    }

    if (result.completed) {
      _todayLogs[habitId] = result.log!;
      locator<AnalyticsService>().capture(
        'habit_completed',
        properties: {'habit_id': habitId, 'completion_rate': completionRate},
      );
      if (completionRate == 1.0) {
        _justCompletedAll = true;
      }
    } else {
      _todayLogs.remove(habitId);
    }

    // Refresh streak
    final streak = await _toggleService.refreshStreak(habitId);
    if (streak != null) _streaks[habitId] = streak;

    _toggleService.notifyChanged();
    rebuildUi();
  }

  /// Logs a quantitative habit with a specific value.
  ///
  /// Called from the [HabitValueSheet]. Auto-determines [completed]
  /// based on whether [value] >= target.
  Future<void> logHabitWithValue(String habitId, double value) async {
    final habit = _todayHabits.where((h) => h.id == habitId).firstOrNull;
    if (habit == null) return;

    final result = await _toggleService.logWithValue(
      habitId: habitId,
      value: value,
      targetValue: habit.targetValue ?? 1,
    );

    if (result.hasError) {
      setError(result.error);
      return;
    }

    _todayLogs[habitId] = result.log!;
    if (completionRate == 1.0) {
      _justCompletedAll = true;
    }

    // Refresh streak
    final streak = await _toggleService.refreshStreak(habitId);
    if (streak != null) _streaks[habitId] = streak;

    _toggleService.notifyChanged();
    rebuildUi();
  }

  /// Updates the actual time range for a completed habit log.
  ///
  /// Called from the [HabitTimeEditSheet] (long-press on completed habit).
  Future<void> updateActualTime(
    String habitId, {
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    final existingLog = _todayLogs[habitId];
    if (existingLog == null || !existingLog.completed) return;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final result = await _habitRepo.logHabit(
      habitId: habitId,
      date: todayDate,
      completed: true,
      value: existingLog.value,
      actualStartTime: startTime,
      actualEndTime: endTime,
    );

    result.fold((f) => setError(f.message), (log) {
      _todayLogs[habitId] = log;
      rebuildUi();
    });
  }

  /// Refresh all data.
  Future<void> refresh() async {
    _haptic.light();
    await _loadData();
  }
}

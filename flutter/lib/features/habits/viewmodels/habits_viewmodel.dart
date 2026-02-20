import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/lifeflow_enums.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/streak_info.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';

/// ViewModel for the habits list view.
///
/// Loads habits + domains, filters by domain, groups by time slot.
class HabitsViewModel extends BaseViewModel {
  final _habitRepo = locator<IHabitRepository>();
  final _domainRepo = locator<IDomainRepository>();

  List<HabitEntity> _allHabits = [];
  List<DomainEntity> _domains = [];
  Map<String, StreakInfo> _streaks = {};
  Map<String, HabitLogEntity> _todayLogs = {};

  /// Currently selected domain filter (null = all).
  String? _selectedDomainId;
  String? get selectedDomainId => _selectedDomainId;

  /// Whether to show archived habits.
  bool _showArchived = false;
  bool get showArchived => _showArchived;

  /// Active (non-archived) domains.
  List<DomainEntity> get domains =>
      _domains.where((d) => !d.isArchived).toList();

  /// Filtered habits based on selected domain.
  List<HabitEntity> get filteredHabits {
    var habits = _allHabits.where((h) => !h.isArchived).toList();
    if (_selectedDomainId != null) {
      habits = habits.where((h) => h.domainId == _selectedDomainId).toList();
    }
    return habits;
  }

  /// Habits grouped by time slot for display.
  Map<TimeSlot, List<HabitEntity>> get habitsByTimeSlot {
    final map = <TimeSlot, List<HabitEntity>>{};
    for (final habit in filteredHabits) {
      final slot = habit.timeSlot;
      map.putIfAbsent(slot, () => []).add(habit);
    }
    // Sort keys by sortWeight
    final sorted = Map.fromEntries(
      map.entries.toList()
        ..sort((a, b) => a.key.sortWeight.compareTo(b.key.sortWeight)),
    );
    return sorted;
  }

  /// Domain entity for a given ID.
  DomainEntity? domainFor(String? domainId) {
    if (domainId == null) return null;
    try {
      return _domains.firstWhere((d) => d.id == domainId);
    } catch (_) {
      return null;
    }
  }

  /// Streak info for a habit.
  StreakInfo streakFor(String habitId) => _streaks[habitId] ?? StreakInfo.empty;

  /// Today's log for a habit (if any).
  HabitLogEntity? todayLogFor(String habitId) => _todayLogs[habitId];

  Future<void> init() async {
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  Future<void> _loadData() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Load habits, domains, and today's logs in parallel
    final results = await Future.wait([
      _habitRepo.getHabits(),
      _domainRepo.getDomains(),
      _habitRepo.getLogsForDateRange(todayDate, todayDate),
    ]);

    results[0].fold(
      (failure) => setError(failure.message),
      (habits) => _allHabits = habits as List<HabitEntity>,
    );

    results[1].fold(
      (failure) => setError(failure.message),
      (domains) => _domains = domains as List<DomainEntity>,
    );

    results[2].fold(
      (failure) {},
      (logs) {
        _todayLogs = {
          for (final log in (logs as List<HabitLogEntity>)) log.habitId: log,
        };
      },
    );

    // Load streaks for all habits
    await _loadStreaks();

    rebuildUi();
  }

  Future<void> _loadStreaks() async {
    final streakMap = <String, StreakInfo>{};
    for (final habit in _allHabits) {
      final result = await _habitRepo.getStreakInfo(habit.id);
      result.fold(
        (_) {},
        (info) => streakMap[habit.id] = info,
      );
    }
    _streaks = streakMap;
  }

  void filterByDomain(String? domainId) {
    _selectedDomainId = _selectedDomainId == domainId ? null : domainId;
    rebuildUi();
  }

  void toggleShowArchived() {
    _showArchived = !_showArchived;
    rebuildUi();
  }

  /// Toggles a habit check for today.
  Future<void> toggleHabit(String habitId, {double? value}) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final existingLog = _todayLogs[habitId];

    if (existingLog != null && existingLog.completed) {
      // Un-check: remove log
      final result =
          await _habitRepo.removeLog(habitId: habitId, date: todayDate);
      result.fold(
        (failure) => setError(failure.message),
        (_) {
          _todayLogs.remove(habitId);
          rebuildUi();
        },
      );
    } else {
      // Check: log habit
      final result = await _habitRepo.logHabit(
        habitId: habitId,
        date: todayDate,
        completed: true,
        value: value,
      );
      result.fold(
        (failure) => setError(failure.message),
        (log) {
          _todayLogs[habitId] = log;
          rebuildUi();
        },
      );
    }

    // Refresh streak for this habit
    final streakResult = await _habitRepo.getStreakInfo(habitId);
    streakResult.fold(
      (_) {},
      (info) {
        _streaks[habitId] = info;
        rebuildUi();
      },
    );
  }

  /// Archives a habit.
  Future<void> archiveHabit(String habitId) async {
    final result = await _habitRepo.archiveHabit(habitId);
    result.fold(
      (failure) => setError(failure.message),
      (_) {},
    );
    if (result.isRight()) await _loadData();
  }

  /// Refreshes data.
  Future<void> refresh() async {
    await _loadData();
  }
}

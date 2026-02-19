import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/time_counter.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';
import '../../../services/time_counter_service.dart';

/// ViewModel for the weekly time counter view.
///
/// Loads habits + logs, computes time counters per domain using [TimeCounterService].
class CounterViewModel extends BaseViewModel {
  final _habitRepo = locator<IHabitRepository>();
  final _domainRepo = locator<IDomainRepository>();
  final _counterService = locator<TimeCounterService>();

  List<TimeCounter> _counters = [];
  List<TimeCounter> get counters => _counters;

  List<HabitEntity> _habits = [];
  List<DomainEntity> _domains = [];

  /// The current week being viewed.
  DateTime _weekStart = TimeCounterService.weekStart(DateTime.now());
  DateTime get weekStart => _weekStart;
  DateTime get weekEnd => TimeCounterService.weekEnd(_weekStart);

  /// Total minutes this week.
  int get totalMinutesThisWeek =>
      _counters.fold(0, (sum, c) => sum + c.totalMinutesThisWeek);

  /// Delta from last week.
  int get deltaMinutes => _counters.fold(0, (sum, c) => sum + c.deltaMinutes);

  /// Formatted total hours.
  String get totalHoursLabel {
    final h = totalMinutesThisWeek ~/ 60;
    final m = totalMinutesThisWeek % 60;
    return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
  }

  /// Formatted delta.
  String get deltaLabel {
    final abs = deltaMinutes.abs();
    final h = abs ~/ 60;
    final m = abs % 60;
    final sign = deltaMinutes >= 0 ? '+' : '-';
    return m > 0 ? '$sign${h}h${m.toString().padLeft(2, '0')}' : '$sign${h}h';
  }

  bool get isPositiveDelta => deltaMinutes >= 0;

  /// Expanded domain index for detail view.
  int? _expandedIndex;
  int? get expandedIndex => _expandedIndex;

  void toggleExpanded(int index) {
    _expandedIndex = _expandedIndex == index ? null : index;
    rebuildUi();
  }

  /// Whether the current view is the current week.
  bool get isCurrentWeek {
    final now = TimeCounterService.weekStart(DateTime.now());
    return _weekStart.year == now.year &&
        _weekStart.month == now.month &&
        _weekStart.day == now.day;
  }

  Future<void> init() async {
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  Future<void> _loadData() async {
    final lastWeekStart = _weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = TimeCounterService.weekEnd(lastWeekStart);

    // Load habits, domains, and logs in parallel
    final results = await Future.wait([
      _habitRepo.getHabits(),
      _domainRepo.getDomains(),
      _habitRepo.getLogsForDateRange(_weekStart, weekEnd),
      _habitRepo.getLogsForDateRange(lastWeekStart, lastWeekEnd),
    ]);

    results[0].fold(
      (f) => setError(f.message),
      (habits) => _habits = habits as List<HabitEntity>,
    );

    results[1].fold(
      (f) => setError(f.message),
      (domains) => _domains = domains as List<DomainEntity>,
    );

    List<HabitLogEntity> logsThisWeek = [];
    results[2].fold(
      (f) {},
      (logs) => logsThisWeek = logs as List<HabitLogEntity>,
    );

    List<HabitLogEntity> logsLastWeek = [];
    results[3].fold(
      (f) {},
      (logs) => logsLastWeek = logs as List<HabitLogEntity>,
    );

    _counters = _counterService.getWeeklyCounters(
      habits: _habits,
      logsThisWeek: logsThisWeek,
      logsLastWeek: logsLastWeek,
      domains: _domains,
    );

    rebuildUi();
  }

  /// Navigate to previous week.
  Future<void> previousWeek() async {
    _weekStart = _weekStart.subtract(const Duration(days: 7));
    _expandedIndex = null;
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  /// Navigate to next week.
  Future<void> nextWeek() async {
    if (isCurrentWeek) return;
    _weekStart = _weekStart.add(const Duration(days: 7));
    _expandedIndex = null;
    setBusy(true);
    await _loadData();
    setBusy(false);
  }

  /// Go to current week.
  Future<void> goToCurrentWeek() async {
    _weekStart = TimeCounterService.weekStart(DateTime.now());
    _expandedIndex = null;
    setBusy(true);
    await _loadData();
    setBusy(false);
  }
}

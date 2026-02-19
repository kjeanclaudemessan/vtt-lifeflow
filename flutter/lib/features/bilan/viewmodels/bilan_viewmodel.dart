import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/weekly_bilan.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';
import '../../../services/bilan_service.dart';
import '../../../services/time_counter_service.dart';

/// ViewModel for the weekly bilan view.
///
/// Loads data for the selected week, generates [WeeklyBilan] via [BilanService].
class BilanViewModel extends BaseViewModel {
  final _habitRepo = locator<IHabitRepository>();
  final _domainRepo = locator<IDomainRepository>();
  final _bilanService = locator<BilanService>();

  WeeklyBilan _bilan = WeeklyBilan.empty();
  WeeklyBilan get bilan => _bilan;

  List<DomainEntity> _domains = [];
  List<DomainEntity> get domains =>
      _domains.where((d) => !d.isArchived).toList();

  /// Week being viewed.
  DateTime _weekStart = TimeCounterService.weekStart(DateTime.now());
  DateTime get weekStart => _weekStart;
  DateTime get weekEnd => TimeCounterService.weekEnd(_weekStart);

  /// Whether viewing current week.
  bool get isCurrentWeek {
    final now = TimeCounterService.weekStart(DateTime.now());
    return _weekStart.year == now.year &&
        _weekStart.month == now.month &&
        _weekStart.day == now.day;
  }

  /// Key for RepaintBoundary used in share.
  final shareWidgetKey = GlobalKey();

  Future<void> init() async {
    setBusy(true);
    await _loadBilan();
    setBusy(false);
  }

  Future<void> _loadBilan() async {
    final lastWeekStart = _weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = TimeCounterService.weekEnd(lastWeekStart);

    final results = await Future.wait([
      _habitRepo.getHabits(),
      _domainRepo.getDomains(),
      _habitRepo.getLogsForDateRange(_weekStart, weekEnd),
      _habitRepo.getLogsForDateRange(lastWeekStart, lastWeekEnd),
    ]);

    List<HabitEntity> habits = [];
    results[0].fold(
      (f) => setError(f.message),
      (h) => habits = h as List<HabitEntity>,
    );

    results[1].fold(
      (f) => setError(f.message),
      (d) => _domains = d as List<DomainEntity>,
    );

    List<HabitLogEntity> logsThisWeek = [];
    results[2].fold(
      (f) {},
      (l) => logsThisWeek = l as List<HabitLogEntity>,
    );

    List<HabitLogEntity> logsLastWeek = [];
    results[3].fold(
      (f) {},
      (l) => logsLastWeek = l as List<HabitLogEntity>,
    );

    _bilan = _bilanService.generateBilan(
      habits: habits,
      logsThisWeek: logsThisWeek,
      logsLastWeek: logsLastWeek,
      domains: _domains,
      weekStartDate: _weekStart,
    );

    rebuildUi();
  }

  /// Navigate to previous week.
  Future<void> previousWeek() async {
    _weekStart = _weekStart.subtract(const Duration(days: 7));
    setBusy(true);
    await _loadBilan();
    setBusy(false);
  }

  /// Navigate to next week.
  Future<void> nextWeek() async {
    if (isCurrentWeek) return;
    _weekStart = _weekStart.add(const Duration(days: 7));
    setBusy(true);
    await _loadBilan();
    setBusy(false);
  }

  /// Capture the share widget and return PNG bytes.
  Future<Uint8List?> captureShareImage() async {
    try {
      final boundary = shareWidgetKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }
}

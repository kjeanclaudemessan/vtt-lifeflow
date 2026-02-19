import 'package:dartz/dartz.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/typedefs/typedefs.dart';
import '../../data/models/habit_log_model.dart';
import '../../data/models/habit_model.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/entities/streak_info.dart';
import '../../domain/repositories/i_habit_repository.dart';
import '../../services/supabase/supabase_service.dart';

/// Implementation of [IHabitRepository] using Supabase.
class HabitRepositoryImpl implements IHabitRepository {
  final SupabaseService _supabaseService;

  HabitRepositoryImpl({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? locator<SupabaseService>();

  /// Current authenticated user ID.
  String get _userId => _supabaseService.client.auth.currentUser!.id;

  // ─────────────────────────────────────────────────────────────────
  // Habits CRUD
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<List<HabitEntity>> getHabits({
    String? domainId,
    bool? isArchived,
  }) async {
    try {
      var query = _supabaseService.client
          .from('habits')
          .select()
          .eq('user_id', _userId);

      if (domainId != null) {
        query = query.eq('domain_id', domainId);
      }
      if (isArchived != null) {
        query = query.eq('is_archived', isArchived);
      }

      final response = await query.order('created_at');

      final habits = (response as List)
          .map((json) => HabitModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();

      return Right(habits);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<HabitEntity> getHabitById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('habits')
          .select()
          .eq('id', id)
          .eq('user_id', _userId)
          .single();

      return Right(HabitModel.fromJson(response).toEntity());
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<HabitEntity> createHabit(HabitEntity entity) async {
    try {
      final data = HabitModel.toInsertJson(
        entity.copyWith(userId: _userId),
      );

      final response = await _supabaseService.client
          .from('habits')
          .insert(data)
          .select()
          .single();

      return Right(HabitModel.fromJson(response).toEntity());
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<HabitEntity> updateHabit(HabitEntity entity) async {
    try {
      final data = HabitModel.toUpdateJson(entity);

      final response = await _supabaseService.client
          .from('habits')
          .update(data)
          .eq('id', entity.id)
          .eq('user_id', _userId)
          .select()
          .single();

      return Right(HabitModel.fromJson(response).toEntity());
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> archiveHabit(String id) async {
    try {
      await _supabaseService.client
          .from('habits')
          .update({'is_archived': true})
          .eq('id', id)
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Habit Logs
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<List<HabitLogEntity>> getLogsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startStr = startDate.toIso8601String().split('T').first;
      final endStr = endDate.toIso8601String().split('T').first;

      // Get all user's habit IDs first (RLS handles via habit ownership)
      final response = await _supabaseService.client
          .from('habit_logs')
          .select('*, habits!inner(user_id)')
          .eq('habits.user_id', _userId)
          .gte('log_date', startStr)
          .lte('log_date', endStr)
          .order('log_date');

      final logs = (response as List)
          .map((json) => HabitLogModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();

      return Right(logs);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<HabitLogEntity> logHabit({
    required String habitId,
    required DateTime date,
    required bool completed,
    double? value,
  }) async {
    try {
      final data = HabitLogModel.toUpsertJson(
        habitId: habitId,
        date: date,
        completed: completed,
        value: value,
      );

      final response = await _supabaseService.client
          .from('habit_logs')
          .upsert(
            data,
            onConflict: 'habit_id,log_date',
          )
          .select()
          .single();

      return Right(HabitLogModel.fromJson(response).toEntity());
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> removeLog({
    required String habitId,
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T').first;

      await _supabaseService.client
          .from('habit_logs')
          .delete()
          .eq('habit_id', habitId)
          .eq('log_date', dateStr);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Streaks (D-005 algorithm)
  // ─────────────────────────────────────────────────────────────────

  @override
  FutureResult<StreakInfo> getStreakInfo(
    String habitId, {
    bool freezeEnabled = true,
  }) async {
    try {
      // Fetch last 90 days of logs for this habit
      final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90));
      final startStr = ninetyDaysAgo.toIso8601String().split('T').first;

      final response = await _supabaseService.client
          .from('habit_logs')
          .select()
          .eq('habit_id', habitId)
          .gte('log_date', startStr)
          .eq('completed', true)
          .order('log_date', ascending: false);

      final completedDates = (response as List)
          .map((json) => DateTime.parse(json['log_date'] as String))
          .toSet();

      // Calculate streak going backwards from today
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      int currentStreak = 0;
      int bestStreak = 0;
      int tempStreak = 0;
      final freezeUsedDates = <DateTime>[];
      bool isFreezeActive = false;

      // Walk backwards from today
      for (int i = 0; i < 90; i++) {
        final checkDate = todayDate.subtract(Duration(days: i));

        if (completedDates.contains(checkDate)) {
          tempStreak++;
        } else if (freezeEnabled &&
            _canUseFreezeInWindow(freezeUsedDates, checkDate)) {
          // Freeze: 1 gap tolerated per 7-day rolling window
          tempStreak++;
          freezeUsedDates.add(checkDate);
          if (i <= 1) isFreezeActive = true;
        } else {
          // Streak broken
          break;
        }
      }

      currentStreak = tempStreak;

      // Calculate best streak (scan all 90 days)
      tempStreak = 0;
      final freezeDatesForBest = <DateTime>[];
      for (int i = 0; i < 90; i++) {
        final checkDate = todayDate.subtract(Duration(days: i));
        if (completedDates.contains(checkDate)) {
          tempStreak++;
        } else if (freezeEnabled &&
            _canUseFreezeInWindow(freezeDatesForBest, checkDate)) {
          tempStreak++;
          freezeDatesForBest.add(checkDate);
        } else {
          if (tempStreak > bestStreak) bestStreak = tempStreak;
          tempStreak = 0;
          freezeDatesForBest.clear();
        }
      }
      if (tempStreak > bestStreak) bestStreak = tempStreak;
      if (currentStreak > bestStreak) bestStreak = currentStreak;

      return Right(StreakInfo(
        currentStreak: currentStreak,
        bestStreak: bestStreak,
        freezeUsedDates: freezeUsedDates,
        isFreezeActive: isFreezeActive,
      ));
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  /// Checks if a freeze can be used for [date] given already-used freezes.
  ///
  /// Rule: max 1 freeze per 7-day rolling window.
  bool _canUseFreezeInWindow(List<DateTime> usedFreezes, DateTime date) {
    final windowStart = date.subtract(const Duration(days: 6));
    final freezesInWindow = usedFreezes.where(
      (d) =>
          d.isAfter(windowStart.subtract(const Duration(days: 1))) &&
          d.isBefore(date.add(const Duration(days: 1))),
    );
    return freezesInWindow.isEmpty;
  }
}

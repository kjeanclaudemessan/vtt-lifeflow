import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../connectivity/connectivity_service.dart';
import '../database/app_database.dart';

/// Mixin providing offline-first read/write patterns.
///
/// Repositories using this mixin will:
/// 1. Always write to local DB first
/// 2. Queue remote operations when offline
/// 3. Read from local DB as primary source (fallback to remote)
/// 4. Sync to Supabase when connectivity is restored
///
/// Usage:
/// ```dart
/// class HabitRepositoryImpl with OfflineFirstRepository implements IHabitRepository {
///   Future<Either<Failure, List<HabitEntity>>> getHabits() async {
///     return localFirst(
///       localQuery: () => fetchHabitsFromDrift(),
///       remoteQuery: () => fetchHabitsFromSupabase(),
///       saveToLocal: (habits) => saveHabitsToDrift(habits),
///     );
///   }
/// }
/// ```
mixin OfflineFirstRepository {
  AppDatabase get db => locator<AppDatabase>();
  ConnectivityService get connectivity => locator<ConnectivityService>();

  /// Reads data with local-first strategy.
  ///
  /// 1. Try local DB first
  /// 2. If online, also fetch from remote and merge
  /// 3. If local is empty and offline, return empty list
  Future<Either<Failure, T>> localFirst<T>({
    required Future<T> Function() localQuery,
    required Future<T> Function() remoteQuery,
    required Future<void> Function(T data) saveToLocal,
  }) async {
    try {
      // Always read local first
      final localData = await localQuery();

      // If online, refresh from remote in background
      if (connectivity.isOnline) {
        try {
          final remoteData = await remoteQuery();
          await saveToLocal(remoteData);
          return Right(remoteData);
        } catch (e) {
          debugPrint('[Offline] Remote fetch failed, using local: $e');
          return Right(localData);
        }
      }

      return Right(localData);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  /// Writes data with offline-first strategy.
  ///
  /// 1. Write to local DB immediately
  /// 2. If online, also push to remote
  /// 3. If offline, queue the operation for later sync
  Future<Either<Failure, T>> writeThrough<T>({
    required Future<T> Function() localWrite,
    required Future<T> Function() remoteWrite,
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    try {
      // Always write locally first
      final result = await localWrite();

      if (connectivity.isOnline) {
        try {
          final remoteResult = await remoteWrite();
          return Right(remoteResult);
        } catch (e) {
          debugPrint('[Offline] Remote write failed, queued: $e');
          await _enqueue(tableName, recordId, operation, payload);
          return Right(result);
        }
      } else {
        // Queue for sync
        await _enqueue(tableName, recordId, operation, payload);
        return Right(result);
      }
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  /// Queues a delete operation with offline-first strategy.
  Future<Either<Failure, void>> deleteThrough({
    required Future<void> Function() localDelete,
    required Future<void> Function() remoteDelete,
    required String tableName,
    required String recordId,
  }) async {
    try {
      await localDelete();

      if (connectivity.isOnline) {
        try {
          await remoteDelete();
        } catch (e) {
          debugPrint('[Offline] Remote delete failed, queued: $e');
          await _enqueue(tableName, recordId, 'delete', {});
        }
      } else {
        await _enqueue(tableName, recordId, 'delete', {});
      }

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  Future<void> _enqueue(
    String tableName,
    String recordId,
    String operation,
    Map<String, dynamic> payload,
  ) async {
    await db.enqueueSync(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      payload: jsonEncode(payload),
    );
    debugPrint('[Offline] Queued: $operation $tableName/$recordId');
  }
}

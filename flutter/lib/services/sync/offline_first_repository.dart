import 'package:dartz/dartz.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/errors/failures.dart';
import '../connectivity/connectivity_service.dart';

/// Stub mixin for offline-first patterns while drift is disabled.
///
/// All operations go directly to remote (Supabase). No local caching.
/// Re-enable by restoring from git:
/// `git checkout -- lib/services/sync/offline_first_repository.dart`
mixin OfflineFirstRepository {
  ConnectivityService get connectivity => locator<ConnectivityService>();

  /// Remote-only read (no local cache while drift is disabled).
  Future<Either<Failure, T>> localFirst<T>({
    required Future<T> Function() localQuery,
    required Future<T> Function() remoteQuery,
    required Future<void> Function(T data) saveToLocal,
  }) async {
    try {
      if (connectivity.isOnline) {
        final remoteData = await remoteQuery();
        return Right(remoteData);
      }
      // Offline fallback — try local query (may fail without drift)
      try {
        return Right(await localQuery());
      } catch (_) {
        return Left(
          const NetworkFailure(
            message: 'No internet connection and no local cache',
          ),
        );
      }
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  /// Remote-only write (no local queue while drift is disabled).
  Future<Either<Failure, T>> writeThrough<T>({
    required Future<T> Function() localWrite,
    required Future<T> Function() remoteWrite,
    required String tableName,
    required String recordId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    try {
      if (connectivity.isOnline) {
        final result = await remoteWrite();
        return Right(result);
      }
      return Left(
        const NetworkFailure(
          message: 'Cannot write while offline (local DB disabled)',
        ),
      );
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  /// Remote-only delete.
  Future<Either<Failure, void>> deleteThrough({
    required Future<void> Function() localDelete,
    required Future<void> Function() remoteDelete,
    required String tableName,
    required String recordId,
  }) async {
    try {
      if (connectivity.isOnline) {
        await remoteDelete();
        return const Right(null);
      }
      return Left(
        const NetworkFailure(
          message: 'Cannot delete while offline (local DB disabled)',
        ),
      );
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }
}

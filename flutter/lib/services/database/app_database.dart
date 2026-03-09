// ═══════════════════════════════════════════════════════════════════════════
// LOCAL-FIRST DISABLED
// ═══════════════════════════════════════════════════════════════════════════
//
// Drift/sqlite3 dependencies are temporarily disabled due to sqlite3 WASM
// interop incompatibility with the current Dart SDK.
//
// This stub preserves the public API surface so the rest of the app compiles.
// Re-enable by uncommenting drift in pubspec.yaml and restoring this file
// from git: `git checkout -- lib/services/database/app_database.dart`
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

/// Stub for [AppDatabase] while drift is disabled.
///
/// All methods are no-ops. Re-enable drift to get actual local persistence.
class AppDatabase {
  AppDatabase();
  AppDatabase.forTesting();

  /// No-op — drift is disabled.
  Future<void> enqueueSync({
    required String tableName,
    required String recordId,
    required String operation,
    required String payload,
  }) async {
    debugPrint('[DB-STUB] enqueueSync skipped (drift disabled)');
  }

  /// No-op — returns empty list.
  Future<List<SyncQueueData>> getPendingSyncOps() async => [];

  /// No-op.
  Future<void> removeSyncOp(int id) async {}

  /// No-op.
  Future<void> incrementRetry(int id) async {}

  /// No-op — returns 0.
  Future<int> pendingSyncCount() async => 0;

  /// No-op.
  Future<void> clearAll() async {
    debugPrint('[DB-STUB] clearAll skipped (drift disabled)');
  }

  /// No-op.
  Future<void> clearForUser(String userId) async {
    debugPrint('[DB-STUB] clearForUser skipped (drift disabled)');
  }
}

/// Stub data class matching drift-generated [SyncQueueData].
class SyncQueueData {
  final int id;
  final String targetTable;
  final String recordId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int retryCount;

  SyncQueueData({
    required this.id,
    required this.targetTable,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });
}

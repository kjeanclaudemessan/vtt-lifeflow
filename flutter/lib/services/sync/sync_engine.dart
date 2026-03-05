import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../app/app.locator.dart';
import '../connectivity/connectivity_service.dart';
import '../database/app_database.dart';
import '../supabase/supabase_service.dart';

/// Processes the sync queue when the device comes back online.
///
/// Watches [ConnectivityService.isOnline] and flushes pending operations
/// from [AppDatabase.syncQueue] → Supabase in FIFO order.
///
/// Operations are retried up to [maxRetries] times before being discarded.
class SyncEngine {
  final AppDatabase _db;
  final SupabaseService _supabase;
  final ConnectivityService _connectivity;

  Timer? _syncTimer;
  bool _isSyncing = false;

  static const int maxRetries = 5;
  static const Duration _pollInterval = Duration(seconds: 30);

  SyncEngine({
    AppDatabase? db,
    SupabaseService? supabase,
    ConnectivityService? connectivity,
  }) : _db = db ?? locator<AppDatabase>(),
       _supabase = supabase ?? locator<SupabaseService>(),
       _connectivity = connectivity ?? locator<ConnectivityService>();

  /// Starts listening for connectivity changes and periodic sync.
  void start() {
    // React to connectivity changes
    _connectivity.addListener(_onConnectivityChanged);

    // Periodic poll as fallback
    _syncTimer = Timer.periodic(_pollInterval, (_) => flush());

    // Initial flush if already online
    if (_connectivity.isOnline) {
      flush();
    }

    debugPrint('[Sync] Engine started');
  }

  /// Stops the sync engine.
  void stop() {
    _connectivity.removeListener(_onConnectivityChanged);
    _syncTimer?.cancel();
    _syncTimer = null;
    debugPrint('[Sync] Engine stopped');
  }

  void _onConnectivityChanged() {
    if (_connectivity.isOnline) {
      debugPrint('[Sync] Back online — flushing queue');
      flush();
    }
  }

  /// Processes all pending sync operations.
  ///
  /// Skips if already syncing or offline.
  Future<void> flush() async {
    if (_isSyncing || !_connectivity.isOnline) return;

    _isSyncing = true;
    try {
      final ops = await _db.getPendingSyncOps();
      if (ops.isEmpty) {
        _isSyncing = false;
        return;
      }

      debugPrint('[Sync] Processing ${ops.length} pending operations');

      for (final op in ops) {
        try {
          await _processOp(op);
          await _db.removeSyncOp(op.id);
        } catch (e) {
          debugPrint(
            '[Sync] Failed op ${op.id} (${op.operation} '
            '${op.targetTable}/${op.recordId}): $e',
          );

          if (op.retryCount >= maxRetries) {
            debugPrint('[Sync] Max retries reached — discarding op ${op.id}');
            await _db.removeSyncOp(op.id);
          } else {
            await _db.incrementRetry(op.id);
          }

          // If we hit a network error, stop processing (we're probably offline)
          if (!_connectivity.isOnline) break;
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Processes a single sync operation against Supabase.
  Future<void> _processOp(SyncQueueData op) async {
    final client = _supabase.client;
    final payload = jsonDecode(op.payload) as Map<String, dynamic>;

    switch (op.operation) {
      case 'insert':
        await client.from(op.targetTable).insert(payload);
        break;

      case 'update':
        await client.from(op.targetTable).update(payload).eq('id', op.recordId);
        break;

      case 'delete':
        await client.from(op.targetTable).delete().eq('id', op.recordId);
        break;

      case 'upsert':
        await client.from(op.targetTable).upsert(payload);
        break;

      default:
        debugPrint('[Sync] Unknown operation: ${op.operation}');
    }

    debugPrint('[Sync] ✓ ${op.operation} ${op.targetTable}/${op.recordId}');
  }

  /// Returns the number of pending sync operations.
  Future<int> pendingCount() => _db.pendingSyncCount();
}

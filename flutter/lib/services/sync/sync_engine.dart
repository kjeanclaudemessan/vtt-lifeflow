import 'package:flutter/foundation.dart';

/// Stub for [SyncEngine] while drift is disabled.
///
/// All methods are no-ops. The real implementation requires AppDatabase (drift).
/// Re-enable by restoring from git: `git checkout -- lib/services/sync/sync_engine.dart`
class SyncEngine {
  SyncEngine();

  /// No-op — drift is disabled.
  void start() {
    debugPrint('[Sync-STUB] Engine start skipped (drift disabled)');
  }

  /// No-op.
  void stop() {}

  /// No-op.
  Future<void> flush() async {}

  /// No-op — returns 0.
  Future<int> pendingCount() async => 0;
}

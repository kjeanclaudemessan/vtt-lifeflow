import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Table Definitions
// ═══════════════════════════════════════════════════════════════════════════

/// Local cache of the Supabase `domains` table.
class LocalDomains extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(const Constant('🎯'))();
  TextColumn get color => text().withDefault(const Constant('#6200EE'))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local cache of the Supabase `habits` table.
class LocalHabits extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get domainId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('binary'))();
  RealColumn get targetValue => real().nullable()();
  TextColumn get unit => text().nullable()();
  IntColumn get estimatedDurationMinutes =>
      integer().withDefault(const Constant(15))();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  TextColumn get frequency => text().withDefault(const Constant('daily'))();
  TextColumn get frequencyDays => text().withDefault(const Constant('[]'))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local cache of the Supabase `habit_logs` table.
class LocalHabitLogs extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text()();
  DateTimeColumn get logDate => dateTime()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  RealColumn get value => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Queue of operations pending sync to Supabase.
///
/// When offline, writes go to the local DB + this queue.
/// When back online, the [SyncEngine] processes this queue in order.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// The Supabase table name (e.g., 'habits', 'habit_logs', 'domains').
  TextColumn get tableName => text()();

  /// The record ID in the target table.
  TextColumn get recordId => text()();

  /// Operation type: 'insert', 'update', 'delete'.
  TextColumn get operation => text()();

  /// JSON-encoded payload for the operation.
  TextColumn get payload => text()();

  /// When this operation was queued.
  DateTimeColumn get createdAt => dateTime()();

  /// Number of retry attempts.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

// ═══════════════════════════════════════════════════════════════════════════
// Database Class
// ═══════════════════════════════════════════════════════════════════════════

@DriftDatabase(tables: [LocalDomains, LocalHabits, LocalHabitLogs, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing — accepts a custom [QueryExecutor].
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
      );

  // ─────────────────────────────────────────────────────────────────
  // Sync Queue Operations
  // ─────────────────────────────────────────────────────────────────

  /// Adds an operation to the sync queue.
  Future<void> enqueueSync({
    required String tableName,
    required String recordId,
    required String operation,
    required String payload,
  }) async {
    await into(syncQueue).insert(SyncQueueCompanion.insert(
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      payload: payload,
      createdAt: DateTime.now().toUtc(),
    ));
  }

  /// Gets all pending sync operations, ordered by creation time.
  Future<List<SyncQueueData>> getPendingSyncOps() async {
    return (select(syncQueue)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  }

  /// Removes a sync operation after successful sync.
  Future<void> removeSyncOp(int id) async {
    await (delete(syncQueue)..where((t) => t.id.equals(id))).go();
  }

  /// Increments the retry count for a failed sync operation.
  Future<void> incrementRetry(int id) async {
    await (update(syncQueue)..where((t) => t.id.equals(id))).write(
      SyncQueueCompanion.custom(
        retryCount: syncQueue.retryCount + const Constant(1),
      ),
    );
  }

  /// Returns the number of pending sync operations.
  Future<int> pendingSyncCount() async {
    final count = countAll();
    final query = selectOnly(syncQueue)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Clears all local data (for logout).
  Future<void> clearAll() async {
    await delete(localDomains).go();
    await delete(localHabits).go();
    await delete(localHabitLogs).go();
    await delete(syncQueue).go();
  }

  /// Clears all data for a specific user.
  Future<void> clearForUser(String userId) async {
    await (delete(localDomains)..where((t) => t.userId.equals(userId))).go();
    await (delete(localHabits)..where((t) => t.userId.equals(userId))).go();
    // habit_logs don't have userId — clear by joining habits
    await delete(localHabitLogs).go();
    await delete(syncQueue).go();
  }
}

/// Opens the SQLite database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lifeflow.sqlite'));
    debugPrint('[DB] Opening database at: ${file.path}');
    return NativeDatabase.createInBackground(file, logStatements: false);
  });
}

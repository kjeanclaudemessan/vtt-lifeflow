import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Opens an IndexedDB-backed database for web platforms.
///
/// Uses sql.js (SQLite compiled to JS) with IndexedDB for persistence.
QueryExecutor connect() {
  return WebDatabase('lifeflow');
}

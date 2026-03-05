import 'package:drift/drift.dart';

/// Stub — should never be called directly.
/// Platform-specific implementations are selected via conditional imports.
QueryExecutor connect() {
  throw UnsupportedError(
    'Cannot create a database connection without dart:ffi or dart:js_interop',
  );
}

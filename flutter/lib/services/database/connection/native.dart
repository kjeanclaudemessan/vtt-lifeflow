import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens a native SQLite database for mobile/desktop platforms.
QueryExecutor connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lifeflow.sqlite'));
    debugPrint('[DB] Opening native database at: ${file.path}');
    return NativeDatabase.createInBackground(file, logStatements: false);
  });
}

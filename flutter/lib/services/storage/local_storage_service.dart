import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Local storage service using SharedPreferences.
///
/// Provides a clean interface for storing simple data locally.
/// For sensitive data, use [SecureStorageService] instead.
///
/// Supports constructor injection for testing:
/// ```dart
/// // Production (default — uses SharedPreferences)
/// final storage = LocalStorageService();
/// await storage.init();
///
/// // Tests (in-memory, no Flutter binding needed)
/// final storage = LocalStorageService.test();
/// ```
class LocalStorageService {
  late SharedPreferences _prefs;

  /// Whether this instance uses an in-memory backend (for tests).
  final bool _isTest;

  /// In-memory storage backend for tests.
  final Map<String, Object> _testStore = {};

  /// Creates a LocalStorageService.
  ///
  /// Default uses SharedPreferences; call [init] before use.
  LocalStorageService() : _isTest = false;

  /// Creates a test-only LocalStorageService backed by an in-memory Map.
  ///
  /// No [init] call needed — ready to use immediately.
  LocalStorageService.test() : _isTest = true;

  /// Initializes the service.
  ///
  /// Must be called before using any other methods.
  /// Skipped automatically for test instances.
  Future<void> init() async {
    if (_isTest) return;
    _prefs = await SharedPreferences.getInstance();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STRING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a string value.
  Future<bool> setString(String key, String value) {
    if (_isTest) {
      _testStore[key] = value;
      return Future.value(true);
    }
    return _prefs.setString(key, value);
  }

  /// Retrieves a string value.
  String? getString(String key) {
    if (_isTest) return _testStore[key] as String?;
    return _prefs.getString(key);
  }

  /// Retrieves a string value with a default.
  String getStringOrDefault(String key, {String defaultValue = ''}) {
    return getString(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOOL
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a boolean value.
  Future<bool> setBool(String key, bool value) {
    if (_isTest) {
      _testStore[key] = value;
      return Future.value(true);
    }
    return _prefs.setBool(key, value);
  }

  /// Retrieves a boolean value.
  bool? getBool(String key) {
    if (_isTest) return _testStore[key] as bool?;
    return _prefs.getBool(key);
  }

  /// Retrieves a boolean value with a default.
  bool getBoolOrDefault(String key, {bool defaultValue = false}) {
    return getBool(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores an integer value.
  Future<bool> setInt(String key, int value) {
    if (_isTest) {
      _testStore[key] = value;
      return Future.value(true);
    }
    return _prefs.setInt(key, value);
  }

  /// Retrieves an integer value.
  int? getInt(String key) {
    if (_isTest) return _testStore[key] as int?;
    return _prefs.getInt(key);
  }

  /// Retrieves an integer value with a default.
  int getIntOrDefault(String key, {int defaultValue = 0}) {
    return getInt(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DOUBLE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a double value.
  Future<bool> setDouble(String key, double value) {
    if (_isTest) {
      _testStore[key] = value;
      return Future.value(true);
    }
    return _prefs.setDouble(key, value);
  }

  /// Retrieves a double value.
  double? getDouble(String key) {
    if (_isTest) return _testStore[key] as double?;
    return _prefs.getDouble(key);
  }

  /// Retrieves a double value with a default.
  double getDoubleOrDefault(String key, {double defaultValue = 0.0}) {
    return getDouble(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // JSON OBJECT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a JSON object.
  Future<bool> setObject(String key, Map<String, dynamic> value) {
    return setString(key, jsonEncode(value));
  }

  /// Retrieves a JSON object.
  Map<String, dynamic>? getObject(String key) {
    final string = getString(key);
    if (string == null) return null;
    try {
      return jsonDecode(string) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Stores a list of JSON objects.
  Future<bool> setObjectList(String key, List<Map<String, dynamic>> value) {
    return setString(key, jsonEncode(value));
  }

  /// Retrieves a list of JSON objects.
  List<Map<String, dynamic>>? getObjectList(String key) {
    final string = getString(key);
    if (string == null) return null;
    try {
      final list = jsonDecode(string) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STRING LIST
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a list of strings.
  Future<bool> setStringList(String key, List<String> value) {
    if (_isTest) {
      _testStore[key] = value;
      return Future.value(true);
    }
    return _prefs.setStringList(key, value);
  }

  /// Retrieves a list of strings.
  List<String>? getStringList(String key) {
    if (_isTest) return _testStore[key] as List<String>?;
    return _prefs.getStringList(key);
  }

  /// Retrieves a list of strings with a default.
  List<String> getStringListOrDefault(String key,
      {List<String> defaultValue = const []}) {
    return getStringList(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATETIME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stores a DateTime value.
  Future<bool> setDateTime(String key, DateTime value) {
    return setString(key, value.toIso8601String());
  }

  /// Retrieves a DateTime value.
  DateTime? getDateTime(String key) {
    final string = getString(key);
    if (string == null) return null;
    return DateTime.tryParse(string);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Removes a value.
  Future<bool> remove(String key) {
    if (_isTest) {
      _testStore.remove(key);
      return Future.value(true);
    }
    return _prefs.remove(key);
  }

  /// Removes multiple values.
  Future<void> removeAll(List<String> keys) async {
    for (final key in keys) {
      await remove(key);
    }
  }

  /// Clears all stored values.
  Future<bool> clear() {
    if (_isTest) {
      _testStore.clear();
      return Future.value(true);
    }
    return _prefs.clear();
  }

  /// Checks if a key exists.
  bool containsKey(String key) {
    if (_isTest) return _testStore.containsKey(key);
    return _prefs.containsKey(key);
  }

  /// Gets all stored keys.
  Set<String> getKeys() {
    if (_isTest) return _testStore.keys.toSet();
    return _prefs.getKeys();
  }

  /// Reloads values from disk.
  Future<void> reload() {
    if (_isTest) return Future.value();
    return _prefs.reload();
  }
}

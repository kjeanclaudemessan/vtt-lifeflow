import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Log levels for categorizing log messages.
enum LogLevel {
  /// Debug information for development.
  debug,

  /// General information about app flow.
  info,

  /// Warning messages for potential issues.
  warning,

  /// Error messages for failures.
  error,
}

/// A simple logging utility for the application.
///
/// Logs are only printed in debug mode and when logging is enabled
/// in the app configuration.
///
/// Example:
/// ```dart
/// Log.d('Debug message');
/// Log.i('Info message');
/// Log.w('Warning message');
/// Log.e('Error message', error: exception, stackTrace: stackTrace);
/// ```
class Log {
  Log._();

  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _cyan = '\x1B[36m';

  /// Whether logging is enabled.
  static bool get _isEnabled {
    try {
      return kDebugMode && AppConfig.instance.enableLogging;
    } catch (_) {
      return kDebugMode;
    }
  }

  /// Logs a debug message.
  static void d(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.debug, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  static void i(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.info, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  static void w(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.warning, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs a message with the specified level.
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    final color = _getColor(level);
    final tagStr = tag != null ? '[$tag] ' : '';

    final logMessage = '$color$timestamp $levelStr $tagStr$message$_reset';

    // Use developer.log for better integration with tools
    developer.log(
      logMessage,
      name: tag ?? 'App',
      error: error,
      stackTrace: stackTrace,
      level: _getDeveloperLogLevel(level),
    );

    // Also print to console for visibility
    if (kDebugMode) {
      // ignore: avoid_print
      print(logMessage);
      if (error != null) {
        // ignore: avoid_print
        print('$_red  Error: $error$_reset');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('$_red  StackTrace: $stackTrace$_reset');
      }
    }
  }

  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO] ';
      case LogLevel.warning:
        return '[WARN] ';
      case LogLevel.error:
        return '[ERROR]';
    }
  }

  static String _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _cyan;
      case LogLevel.info:
        return _green;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
    }
  }

  static int _getDeveloperLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}

/// A logger instance for a specific tag/class.
///
/// Example:
/// ```dart
/// class MyService {
///   final _log = Logger('MyService');
///
///   void doSomething() {
///     _log.d('Doing something...');
///     try {
///       // ...
///     } catch (e, s) {
///       _log.e('Failed to do something', error: e, stackTrace: s);
///     }
///   }
/// }
/// ```
class Logger {
  /// Creates a logger with the specified tag.
  const Logger(this.tag);

  /// The tag used to identify log messages from this logger.
  final String tag;

  /// Logs a debug message.
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    Log.d(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs an info message.
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    Log.i(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    Log.w(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Logs an error message.
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    Log.e(message, tag: tag, error: error, stackTrace: stackTrace);
  }
}

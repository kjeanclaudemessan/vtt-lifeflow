import 'package:flutter/material.dart';

/// Shared utilities for parsing and formatting [TimeOfDay] ↔ TIME string.
///
/// Used by [HabitModel] and [HabitLogModel] for Supabase TIME columns.
abstract final class TimeParsingUtils {
  /// Parses a TIME string (e.g., "06:30:00") into a [TimeOfDay].
  ///
  /// Returns `null` if [time] is null, empty, or malformed.
  static TimeOfDay? parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  /// Formats a [TimeOfDay] to a TIME string (e.g., "06:30:00").
  ///
  /// Returns `null` if [time] is null.
  static String? formatTime(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:00';
  }
}

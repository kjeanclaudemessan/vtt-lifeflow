/// ============================================================================
/// LIFEFLOW — TIME FORMATTING UTILITIES
/// Shared across views (Today, Counter, Bilan, DomainTimeBar, etc.)
/// ============================================================================

/// Formats a duration in minutes to a human-readable string.
///
/// Examples:
/// ```dart
/// formatMinutes(0)     // '0m'
/// formatMinutes(45)    // '45m'
/// formatMinutes(60)    // '1h'
/// formatMinutes(90)    // '1h30'
/// formatMinutes(125)   // '2h05'
/// ```
String formatMinutes(int minutes) {
  if (minutes >= 60) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
  }
  return '${minutes}m';
}

/// Formats a duration in minutes to a short label (e.g. for badges).
///
/// Examples:
/// ```dart
/// formatMinutesShort(0)    // '0min'
/// formatMinutesShort(45)   // '45min'
/// formatMinutesShort(90)   // '1h30'
/// ```
String formatMinutesShort(int minutes) {
  if (minutes >= 60) {
    return formatMinutes(minutes);
  }
  return '${minutes}min';
}

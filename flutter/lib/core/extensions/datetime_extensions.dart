/// Extensions on [DateTime] for common date/time operations.
extension DateTimeExtensions on DateTime {
  /// Returns `true` if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns `true` if this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns `true` if this date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns `true` if this date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Returns `true` if this date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Returns `true` if this date is in the same year as now.
  bool get isThisYear => year == DateTime.now().year;

  /// Returns `true` if this date is in the current week.
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.startOfWeek;
    final endOfWeek = now.endOfWeek;
    return isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }

  /// Returns `true` if this date is in the current month.
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Returns a new [DateTime] with time set to start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a new [DateTime] with time set to end of day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns a new [DateTime] set to the start of the week (Monday).
  DateTime get startOfWeek {
    final diff = weekday - DateTime.monday;
    return subtract(Duration(days: diff)).startOfDay;
  }

  /// Returns a new [DateTime] set to the end of the week (Sunday).
  DateTime get endOfWeek {
    final diff = DateTime.sunday - weekday;
    return add(Duration(days: diff)).endOfDay;
  }

  /// Returns a new [DateTime] set to the start of the month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns a new [DateTime] set to the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Returns a new [DateTime] set to the start of the year.
  DateTime get startOfYear => DateTime(year);

  /// Returns a new [DateTime] set to the end of the year.
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Adds a number of days to this date.
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtracts a number of days from this date.
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Adds a number of months to this date.
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = day > daysInNewMonth ? daysInNewMonth : day;
    return DateTime(newYear, newMonth, newDay, hour, minute, second);
  }

  /// Subtracts a number of months from this date.
  DateTime subtractMonths(int months) => addMonths(-months);

  /// Adds a number of years to this date.
  DateTime addYears(int years) => DateTime(
        year + years,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Subtracts a number of years from this date.
  DateTime subtractYears(int years) => addYears(-years);

  /// Returns the difference in days between this date and [other].
  int differenceInDays(DateTime other) {
    return startOfDay.difference(other.startOfDay).inDays;
  }

  /// Returns the difference in months between this date and [other].
  int differenceInMonths(DateTime other) {
    return (year - other.year) * 12 + (month - other.month);
  }

  /// Returns the difference in years between this date and [other].
  int differenceInYears(DateTime other) {
    var years = year - other.year;
    if (month < other.month || (month == other.month && day < other.day)) {
      years--;
    }
    return years;
  }

  /// Returns `true` if this date is on the same day as [other].
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns `true` if this date is on the same month as [other].
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Returns `true` if this date is on the same year as [other].
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// Returns the age in years from this date to now.
  int get age => differenceInYears(DateTime.now()).abs();

  /// Returns a copy of this date with updated fields.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Returns a human-readable relative time string.
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().subtract(Duration(minutes: 5)).timeAgo // '5 minutes ago'
  /// DateTime.now().add(Duration(hours: 2)).timeAgo // 'in 2 hours'
  /// ```
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return _timeUntil(difference.abs());
    }

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  String _timeUntil(Duration difference) {
    if (difference.inSeconds < 60) {
      return 'in a moment';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'in $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'in $hours ${hours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'in $days ${days == 1 ? 'day' : 'days'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'in $weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? 'year' : 'years'}';
    }
  }
}

/// Extensions on nullable [DateTime].
extension NullableDateTimeExtensions on DateTime? {
  /// Returns `true` if the date is null or in the past.
  bool get isNullOrPast => this == null || this!.isPast;

  /// Returns `true` if the date is not null and in the future.
  bool get isNotNullAndFuture => this != null && this!.isFuture;

  /// Returns the date or current date if null.
  DateTime get orNow => this ?? DateTime.now();
}

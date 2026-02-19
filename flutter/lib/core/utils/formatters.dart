import 'package:intl/intl.dart';

/// Collection of formatting functions for displaying data.
class Formatters {
  Formatters._();

  // ===== Currency =====

  /// Formats a number as currency.
  ///
  /// Example:
  /// ```dart
  /// Formatters.currency(1234.56) // '$1,234.56'
  /// Formatters.currency(1234.56, locale: 'fr_FR', symbol: '€') // '1 234,56 €'
  /// ```
  static String currency(
    num amount, {
    String locale = 'en_US',
    String? symbol,
    int decimalDigits = 2,
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }

  /// Formats a number as compact currency.
  ///
  /// Example:
  /// ```dart
  /// Formatters.compactCurrency(1234567) // '$1.2M'
  /// ```
  static String compactCurrency(
    num amount, {
    String locale = 'en_US',
    String? symbol,
  }) {
    final format = NumberFormat.compactCurrency(
      locale: locale,
      symbol: symbol,
    );
    return format.format(amount);
  }

  // ===== Numbers =====

  /// Formats a number with thousand separators.
  ///
  /// Example:
  /// ```dart
  /// Formatters.number(1234567) // '1,234,567'
  /// ```
  static String number(
    num value, {
    String locale = 'en_US',
    int? decimalDigits,
  }) {
    final format = decimalDigits != null
        ? NumberFormat.decimalPatternDigits(
            locale: locale,
            decimalDigits: decimalDigits,
          )
        : NumberFormat.decimalPattern(locale);
    return format.format(value);
  }

  /// Formats a number as compact (K, M, B).
  ///
  /// Example:
  /// ```dart
  /// Formatters.compact(1234567) // '1.2M'
  /// ```
  static String compact(num value, {String locale = 'en_US'}) {
    return NumberFormat.compact(locale: locale).format(value);
  }

  /// Formats a number as a percentage.
  ///
  /// Example:
  /// ```dart
  /// Formatters.percent(0.1234) // '12%'
  /// Formatters.percent(0.1234, decimalDigits: 1) // '12.3%'
  /// ```
  static String percent(
    num value, {
    String locale = 'en_US',
    int decimalDigits = 0,
  }) {
    final format = NumberFormat.percentPattern(locale)
      ..maximumFractionDigits = decimalDigits
      ..minimumFractionDigits = decimalDigits;
    return format.format(value);
  }

  /// Formats bytes as human-readable size.
  ///
  /// Example:
  /// ```dart
  /// Formatters.fileSize(1024) // '1 KB'
  /// Formatters.fileSize(1234567) // '1.18 MB'
  /// ```
  static String fileSize(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (bytes.bitLength - 1) ~/ 10;
    final size = bytes / (1 << (i * 10));
    return '${size.toStringAsFixed(i == 0 ? 0 : decimals)} ${suffixes[i]}';
  }

  // ===== Date & Time =====

  /// Formats a date using the specified pattern.
  ///
  /// Common patterns:
  /// - `'dd/MM/yyyy'` → 25/12/2024
  /// - `'MMMM dd, yyyy'` → December 25, 2024
  /// - `'E, MMM d'` → Wed, Dec 25
  /// - `'HH:mm'` → 14:30
  /// - `'hh:mm a'` → 02:30 PM
  static String date(
    DateTime date, {
    String pattern = 'dd/MM/yyyy',
    String? locale,
  }) {
    return DateFormat(pattern, locale).format(date);
  }

  /// Formats a date as short date (e.g., "25/12/24").
  static String shortDate(DateTime date, {String? locale}) {
    return DateFormat.yMd(locale).format(date);
  }

  /// Formats a date as medium date (e.g., "Dec 25, 2024").
  static String mediumDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Formats a date as long date (e.g., "December 25, 2024").
  static String longDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMMd(locale).format(date);
  }

  /// Formats a date as full date (e.g., "Wednesday, December 25, 2024").
  static String fullDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMMEEEEd(locale).format(date);
  }

  /// Formats a time (e.g., "14:30" or "2:30 PM").
  static String time(
    DateTime date, {
    bool use24Hour = true,
    String? locale,
  }) {
    final pattern = use24Hour ? 'HH:mm' : 'h:mm a';
    return DateFormat(pattern, locale).format(date);
  }

  /// Formats a date and time.
  static String dateTime(
    DateTime date, {
    String datePattern = 'dd/MM/yyyy',
    bool use24Hour = true,
    String? locale,
  }) {
    final timePattern = use24Hour ? 'HH:mm' : 'h:mm a';
    return DateFormat('$datePattern $timePattern', locale).format(date);
  }

  /// Formats a date as relative time (e.g., "2 hours ago", "in 3 days").
  ///
  /// For dates within the past week or next week, returns relative time.
  /// For older/further dates, returns the formatted date.
  static String relativeDate(
    DateTime date, {
    String datePattern = 'MMM d, yyyy',
    String? locale,
  }) {
    final now = DateTime.now();
    final difference = date.difference(now);
    final absDays = difference.inDays.abs();

    if (absDays == 0) {
      final absHours = difference.inHours.abs();
      if (absHours == 0) {
        final absMinutes = difference.inMinutes.abs();
        if (absMinutes == 0) {
          return 'just now';
        }
        return difference.isNegative
            ? '$absMinutes ${absMinutes == 1 ? 'minute' : 'minutes'} ago'
            : 'in $absMinutes ${absMinutes == 1 ? 'minute' : 'minutes'}';
      }
      return difference.isNegative
          ? '$absHours ${absHours == 1 ? 'hour' : 'hours'} ago'
          : 'in $absHours ${absHours == 1 ? 'hour' : 'hours'}';
    } else if (absDays == 1) {
      return difference.isNegative ? 'yesterday' : 'tomorrow';
    } else if (absDays < 7) {
      return difference.isNegative ? '$absDays days ago' : 'in $absDays days';
    }

    return DateFormat(datePattern, locale).format(date);
  }

  /// Formats a duration (e.g., "2h 30m", "45s").
  static String duration(
    Duration duration, {
    bool showSeconds = true,
  }) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (showSeconds && seconds > 0) parts.add('${seconds}s');

    return parts.isEmpty ? '0s' : parts.join(' ');
  }

  // ===== Phone =====

  /// Formats a phone number.
  ///
  /// Example:
  /// ```dart
  /// Formatters.phone('1234567890') // '(123) 456-7890'
  /// Formatters.phone('0612345678', format: 'FR') // '06 12 34 56 78'
  /// ```
  static String phone(String number, {String format = 'US'}) {
    final digits = number.replaceAll(RegExp(r'\D'), '');

    switch (format) {
      case 'US':
        if (digits.length == 10) {
          return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
        }
        return number;

      case 'FR':
        if (digits.length == 10) {
          return '${digits.substring(0, 2)} ${digits.substring(2, 4)} ${digits.substring(4, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
        }
        return number;

      default:
        return number;
    }
  }

  // ===== Credit Card =====

  /// Formats a credit card number with spaces.
  ///
  /// Example:
  /// ```dart
  /// Formatters.creditCard('4111111111111111') // '4111 1111 1111 1111'
  /// ```
  static String creditCard(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Masks a credit card number.
  ///
  /// Example:
  /// ```dart
  /// Formatters.maskedCreditCard('4111111111111111') // '**** **** **** 1111'
  /// ```
  static String maskedCreditCard(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return number;
    final lastFour = digits.substring(digits.length - 4);
    return '**** **** **** $lastFour';
  }

  // ===== Ordinal =====

  /// Formats a number as ordinal.
  ///
  /// Example:
  /// ```dart
  /// Formatters.ordinal(1) // '1st'
  /// Formatters.ordinal(22) // '22nd'
  /// ```
  static String ordinal(int number) {
    final absNumber = number.abs();
    final lastDigit = absNumber % 10;
    final lastTwoDigits = absNumber % 100;

    String suffix;
    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      suffix = 'th';
    } else {
      switch (lastDigit) {
        case 1:
          suffix = 'st';
        case 2:
          suffix = 'nd';
        case 3:
          suffix = 'rd';
        default:
          suffix = 'th';
      }
    }

    return '$number$suffix';
  }

  // ===== Names =====

  /// Formats a name (capitalizes first letter of each word).
  static String name(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Gets initials from a name.
  ///
  /// Example:
  /// ```dart
  /// Formatters.initials('John Doe') // 'JD'
  /// Formatters.initials('John Michael Doe') // 'JD'
  /// ```
  static String initials(String name, {int maxInitials = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

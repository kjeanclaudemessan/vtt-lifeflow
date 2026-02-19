---
applyTo: "**/*_extensions.dart,**/extensions/**/*.dart"
---
# Extension Instructions

> These instructions apply to all Dart Extension files (`*_extensions.dart`).
> Inherits from: `dart.instructions.md`

---

## Extension Principles

### Purpose

- **Extend existing types** with domain-specific functionality
- **Keep methods small** and single-purpose
- **Document edge cases** and return values
- **No side effects** - pure functions only

### Location

- **Path**: `lib/core/extensions/`
- **Naming**: `<type>_extensions.dart` (e.g., `string_extensions.dart`)

---

## String Extensions

```dart
/// Extensions on [String] for common text operations.
extension StringExtensions on String {
  /// Returns `true` if the string is a valid email address.
  ///
  /// Example:
  /// ```dart
  /// 'user@example.com'.isValidEmail // true
  /// 'invalid-email'.isValidEmail // false
  /// ```
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Returns `true` if the string is a valid phone number.
  ///
  /// Accepts formats: +1234567890, 1234567890, 123-456-7890
  bool get isValidPhone {
    return RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(this);
  }

  /// Returns `true` if the string is a valid URL.
  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }

  /// Capitalizes the first letter of the string.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.capitalize // 'Hello'
  /// 'HELLO'.capitalize // 'HELLO'
  /// ''.capitalize // ''
  /// ```
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word.
  ///
  /// Example:
  /// ```dart
  /// 'hello world'.titleCase // 'Hello World'
  /// 'HELLO WORLD'.titleCase // 'HELLO WORLD'
  /// ```
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncates the string to [maxLength] and adds ellipsis if needed.
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.truncate(5) // 'Hello...'
  /// 'Hi'.truncate(5) // 'Hi'
  /// ```
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Returns initials from a name string.
  ///
  /// Example:
  /// ```dart
  /// 'John Doe'.initials // 'JD'
  /// 'John'.initials // 'J'
  /// 'John Michael Doe'.initials // 'JD' (first and last)
  /// ```
  String get initials {
    if (isEmpty) return '';
    final parts = trim().split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Returns `null` if the string is empty, otherwise returns the string.
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Returns `true` if the string contains only digits.
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Converts string to slug format (lowercase, hyphens).
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.toSlug // 'hello-world'
  /// 'My Blog Post!'.toSlug // 'my-blog-post'
  /// ```
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }
}
```

---

## Nullable String Extensions

```dart
/// Extensions on nullable [String] for safe operations.
extension NullableStringExtensions on String? {
  /// Returns `true` if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the string or a default value if null/empty.
  String orDefault(String defaultValue) {
    return isNullOrEmpty ? defaultValue : this!;
  }

  /// Returns the string or 'N/A' if null/empty.
  String get orNA => orDefault('N/A');
}
```

---

## DateTime Extensions

```dart
import 'package:intl/intl.dart';

/// Extensions on [DateTime] for formatting and calculations.
extension DateTimeExtensions on DateTime {
  /// Formats the date as 'Jan 1, 2024'.
  String get formatted => DateFormat.yMMMd().format(this);

  /// Formats the date as '01/01/2024'.
  String get shortDate => DateFormat('dd/MM/yyyy').format(this);

  /// Formats the time as '14:30' (24h).
  String get time24h => DateFormat.Hm().format(this);

  /// Formats the time as '2:30 PM'.
  String get time12h => DateFormat.jm().format(this);

  /// Formats as 'Jan 1, 2024 at 2:30 PM'.
  String get dateTime => '${DateFormat.yMMMd().format(this)} at ${time12h}';

  /// Returns `true` if the date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns `true` if the date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns `true` if the date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns `true` if the date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Returns `true` if the date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Returns a human-readable relative time string.
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().subtract(Duration(minutes: 5)).timeAgo // '5 minutes ago'
  /// DateTime.now().subtract(Duration(days: 1)).timeAgo // 'Yesterday'
  /// DateTime.now().add(Duration(hours: 2)).timeAgo // 'In 2 hours'
  /// ```
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return _timeFromNow(difference.abs());
    }

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    if (isYesterday) return 'Yesterday';
    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }

    final years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }

  String _timeFromNow(Duration difference) {
    if (difference.inMinutes < 60) {
      return 'In ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    }
    if (difference.inHours < 24) {
      return 'In ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    }
    if (isTomorrow) return 'Tomorrow';
    if (difference.inDays < 7) {
      return 'In ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    }
    return formatted;
  }

  /// Returns the start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns the start of the week (Monday).
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Returns the start of the month.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Returns the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Returns the age in years from this date.
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}
```

---

## Number Extensions

```dart
import 'package:intl/intl.dart';

/// Extensions on [num] for formatting and calculations.
extension NumExtensions on num {
  /// Formats the number as currency.
  ///
  /// Example:
  /// ```dart
  /// 1234.56.toCurrency() // '$1,234.56'
  /// 1234.56.toCurrency(symbol: '€') // '€1,234.56'
  /// ```
  String toCurrency({String symbol = '\$', int decimalDigits = 2}) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  /// Formats the number with thousand separators.
  ///
  /// Example:
  /// ```dart
  /// 1234567.formatted // '1,234,567'
  /// ```
  String get formatted => NumberFormat('#,###').format(this);

  /// Formats the number as a percentage.
  ///
  /// Example:
  /// ```dart
  /// 0.75.toPercent() // '75%'
  /// 0.756.toPercent(decimals: 1) // '75.6%'
  /// ```
  String toPercent({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Formats bytes as human-readable size.
  ///
  /// Example:
  /// ```dart
  /// 1024.toFileSize // '1 KB'
  /// 1048576.toFileSize // '1 MB'
  /// ```
  String get toFileSize {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var bytes = toDouble();
    var i = 0;
    while (bytes >= 1024 && i < suffixes.length - 1) {
      bytes /= 1024;
      i++;
    }
    return '${bytes.toStringAsFixed(bytes < 10 && i > 0 ? 1 : 0)} ${suffixes[i]}';
  }

  /// Returns a Duration in milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Returns a Duration in seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Returns a Duration in minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Returns a Duration in hours.
  Duration get hours => Duration(hours: toInt());

  /// Returns a Duration in days.
  Duration get days => Duration(days: toInt());
}
```

---

## List Extensions

```dart
/// Extensions on [List] for common operations.
extension ListExtensions<T> on List<T> {
  /// Returns the first element or null if empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element or null if empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns element at index or null if out of bounds.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Groups elements by a key.
  ///
  /// Example:
  /// ```dart
  /// final users = [User('Alice', 25), User('Bob', 25), User('Charlie', 30)];
  /// users.groupBy((u) => u.age); // {25: [Alice, Bob], 30: [Charlie]}
  /// ```
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Returns distinct elements.
  List<T> distinct() => toSet().toList();

  /// Returns distinct elements by a key.
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((element) => seen.add(keySelector(element))).toList();
  }

  /// Separates elements with a separator.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].separated(0) // [1, 0, 2, 0, 3]
  /// ```
  List<T> separated(T separator) {
    if (length <= 1) return toList();
    return [
      for (var i = 0; i < length; i++) ...[
        if (i > 0) separator,
        this[i],
      ]
    ];
  }

  /// Sorts the list by a comparable key.
  List<T> sortedBy<K extends Comparable>(K Function(T) keySelector) {
    return [...this]..sort((a, b) => keySelector(a).compareTo(keySelector(b)));
  }

  /// Sorts the list by a comparable key in descending order.
  List<T> sortedByDescending<K extends Comparable>(K Function(T) keySelector) {
    return [...this]..sort((a, b) => keySelector(b).compareTo(keySelector(a)));
  }
}
```

---

## BuildContext Extensions

```dart
import 'package:flutter/material.dart';

/// Extensions on [BuildContext] for quick access to common properties.
extension BuildContextExtensions on BuildContext {
  // ─────────────────────────────────────────────────────────────────
  // Theme
  // ─────────────────────────────────────────────────────────────────

  /// Returns the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Returns the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Returns `true` if dark mode is active.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ─────────────────────────────────────────────────────────────────
  // MediaQuery
  // ─────────────────────────────────────────────────────────────────

  /// Returns the current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen size.
  Size get screenSize => mediaQuery.size;

  /// Returns the screen width.
  double get screenWidth => screenSize.width;

  /// Returns the screen height.
  double get screenHeight => screenSize.height;

  /// Returns the safe area padding.
  EdgeInsets get padding => mediaQuery.padding;

  /// Returns the view insets (keyboard, etc.).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Returns `true` if the keyboard is visible.
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // ─────────────────────────────────────────────────────────────────
  // Device Type
  // ─────────────────────────────────────────────────────────────────

  /// Returns `true` if the device is a phone (< 600px).
  bool get isPhone => screenWidth < 600;

  /// Returns `true` if the device is a tablet (600-900px).
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Returns `true` if the device is a desktop (>= 900px).
  bool get isDesktop => screenWidth >= 900;

  // ─────────────────────────────────────────────────────────────────
  // Navigation
  // ─────────────────────────────────────────────────────────────────

  /// Returns `true` if the navigator can pop.
  bool get canPop => Navigator.of(this).canPop();

  /// Pops the current route.
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // ─────────────────────────────────────────────────────────────────
  // Focus
  // ─────────────────────────────────────────────────────────────────

  /// Unfocuses any focused widget (dismisses keyboard).
  void unfocus() => FocusScope.of(this).unfocus();

  /// Requests focus for a [FocusNode].
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);
}
```

---

## File Organization

```
lib/core/extensions/
├── extensions.dart              # Barrel file
├── string_extensions.dart
├── date_time_extensions.dart
├── num_extensions.dart
├── list_extensions.dart
├── context_extensions.dart
├── iterable_extensions.dart
├── map_extensions.dart
└── duration_extensions.dart
```

### Barrel File

```dart
// lib/core/extensions/extensions.dart
export 'string_extensions.dart';
export 'date_time_extensions.dart';
export 'num_extensions.dart';
export 'list_extensions.dart';
export 'context_extensions.dart';
export 'iterable_extensions.dart';
export 'map_extensions.dart';
export 'duration_extensions.dart';
```

---

## Don'ts

```dart
// ❌ Don't add side effects
extension BadExtension on String {
  void saveToDatabase() { } // Extensions should be pure
}

// ❌ Don't make extensions too specific
extension UserStringExtension on String {
  UserEntity toUser() { } // Too domain-specific
}

// ❌ Don't duplicate existing functionality
extension BadListExtension on List {
  bool get hasItems => isNotEmpty; // Already exists
}

// ❌ Don't access external services
extension BadExtension on DateTime {
  Future<void> sync() => apiService.sync(this); // No service calls
}

// ❌ Don't create overly long extension names
extension StringHelperExtensionMethodsForUserInput on String { } // Too long
```

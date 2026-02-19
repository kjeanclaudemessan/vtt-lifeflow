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
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Returns `true` if the string is a valid phone number.
  ///
  /// Accepts various formats: +1234567890, 123-456-7890, (123) 456-7890
  bool get isValidPhone {
    return RegExp(
      r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}$',
    ).hasMatch(this);
  }

  /// Returns `true` if the string is a valid URL.
  bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  /// Returns `true` if the string contains only digits.
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// Returns `true` if the string contains only alphabetic characters.
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Returns `true` if the string contains only alphanumeric characters.
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Returns `true` if the string is blank (empty or whitespace only).
  bool get isBlank => trim().isEmpty;

  /// Returns `true` if the string is not blank.
  bool get isNotBlank => !isBlank;

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

  /// Converts the string to lowercase with first letter capitalized.
  ///
  /// Example:
  /// ```dart
  /// 'HELLO WORLD'.sentenceCase // 'Hello world'
  /// ```
  String get sentenceCase {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Converts camelCase to snake_case.
  ///
  /// Example:
  /// ```dart
  /// 'firstName'.toSnakeCase // 'first_name'
  /// 'XMLParser'.toSnakeCase // 'x_m_l_parser'
  /// ```
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Converts snake_case to camelCase.
  ///
  /// Example:
  /// ```dart
  /// 'first_name'.toCamelCase // 'firstName'
  /// ```
  String get toCamelCase {
    final parts = split('_');
    if (parts.length == 1) return this;
    return parts.first + parts.skip(1).map((part) => part.capitalize).join();
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
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Collapses multiple spaces into a single space.
  String get collapseWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Removes all HTML tags from the string.
  String get stripHtml => replaceAll(RegExp(r'<[^>]*>'), '');

  /// Returns null if the string is empty, otherwise returns the string.
  String? get nullIfEmpty => isEmpty ? null : this;

  /// Returns null if the string is blank, otherwise returns the trimmed string.
  String? get nullIfBlank => isBlank ? null : trim();

  /// Reverses the string.
  String get reversed => split('').reversed.join();

  /// Returns the string repeated [count] times.
  String times(int count) => List.filled(count, this).join();

  /// Masks part of the string (useful for emails, phone numbers, etc.).
  ///
  /// Example:
  /// ```dart
  /// 'user@example.com'.mask(2, 12) // 'us**********om'
  /// '1234567890'.mask(2, 6) // '12****7890'
  /// ```
  String mask(int start, int end, {String maskChar = '*'}) {
    if (start >= length || end <= start) return this;
    final maskedLength = (end > length ? length : end) - start;
    return replaceRange(
        start, end > length ? length : end, maskChar.times(maskedLength));
  }

  /// Masks an email address.
  ///
  /// Example:
  /// ```dart
  /// 'john.doe@example.com'.maskEmail // 'jo*****@example.com'
  /// ```
  String get maskEmail {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return this;
    return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
  }

  /// Converts a string to an integer, or returns null if invalid.
  int? toIntOrNull() => int.tryParse(this);

  /// Converts a string to a double, or returns null if invalid.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Converts a string to a DateTime, or returns null if invalid.
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);
}

/// Extensions on nullable [String].
extension NullableStringExtensions on String? {
  /// Returns `true` if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `true` if the string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns `true` if the string is null or blank (empty or whitespace).
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Returns `true` if the string is not null and not blank.
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Returns the string or a default value if null/empty.
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}

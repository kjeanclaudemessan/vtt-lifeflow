import '../constants/regex_patterns.dart';

/// Collection of validation functions for form inputs.
///
/// All validators return `null` if valid, or an error message if invalid.
/// These are designed to work with Flutter's `TextFormField.validator`.
///
/// Example:
/// ```dart
/// TextFormField(
///   validator: Validators.email,
/// )
/// ```
class Validators {
  Validators._();

  // ===== Required =====

  /// Validates that the value is not empty.
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  // ===== Email =====

  /// Validates that the value is a valid email address.
  static String? email(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.email.hasMatch(value)) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates that the value is a valid required email.
  static String? requiredEmail(String? value, {String? message}) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    return email(value, message: message);
  }

  // ===== Phone =====

  /// Validates that the value is a valid phone number.
  static String? phone(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.phone.hasMatch(value)) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates that the value is a valid French phone number.
  static String? frenchPhone(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.frenchPhone.hasMatch(value)) {
      return message ?? 'Please enter a valid French phone number';
    }
    return null;
  }

  // ===== Password =====

  /// Validates minimum password requirements.
  static String? password(String? value, {int minLength = 8, String? message}) {
    if (value == null || value.isEmpty) return null;
    if (value.length < minLength) {
      return message ?? 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates strong password requirements.
  ///
  /// Requires uppercase, lowercase, and digit.
  static String? strongPassword(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.passwordStrong.hasMatch(value)) {
      return message ??
          'Password must contain uppercase, lowercase, and a number';
    }
    return null;
  }

  /// Validates very strong password requirements.
  ///
  /// Requires uppercase, lowercase, digit, and special character.
  static String? veryStrongPassword(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.passwordVeryStrong.hasMatch(value)) {
      return message ??
          'Password must contain uppercase, lowercase, number, and special character';
    }
    return null;
  }

  /// Validates that passwords match.
  static String? Function(String?) confirmPassword(
    String? password, {
    String? message,
  }) {
    return (String? value) {
      if (value != password) {
        return message ?? 'Passwords do not match';
      }
      return null;
    };
  }

  // ===== Length =====

  /// Validates minimum length.
  static String? Function(String?) minLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Validates maximum length.
  static String? Function(String?) maxLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Validates exact length.
  static String? Function(String?) exactLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length != length) {
        return message ?? 'Must be exactly $length characters';
      }
      return null;
    };
  }

  /// Validates length within a range.
  static String? Function(String?) lengthBetween(
    int min,
    int max, {
    String? message,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min || value.length > max) {
        return message ?? 'Must be between $min and $max characters';
      }
      return null;
    };
  }

  // ===== Numbers =====

  /// Validates that the value is a valid number.
  static String? number(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return message ?? 'Please enter a valid number';
    }
    return null;
  }

  /// Validates that the value is a valid integer.
  static String? integer(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (int.tryParse(value) == null) {
      return message ?? 'Please enter a valid integer';
    }
    return null;
  }

  /// Validates minimum value.
  static String? Function(String?) min(num minValue, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null || numValue < minValue) {
        return message ?? 'Must be at least $minValue';
      }
      return null;
    };
  }

  /// Validates maximum value.
  static String? Function(String?) max(num maxValue, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null || numValue > maxValue) {
        return message ?? 'Must be at most $maxValue';
      }
      return null;
    };
  }

  /// Validates value within a range.
  static String? Function(String?) range(
    num minValue,
    num maxValue, {
    String? message,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      final numValue = num.tryParse(value);
      if (numValue == null || numValue < minValue || numValue > maxValue) {
        return message ?? 'Must be between $minValue and $maxValue';
      }
      return null;
    };
  }

  // ===== URL =====

  /// Validates that the value is a valid URL.
  static String? url(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.url.hasMatch(value)) {
      return message ?? 'Please enter a valid URL';
    }
    return null;
  }

  // ===== Username =====

  /// Validates a username format.
  static String? username(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.username.hasMatch(value)) {
      return message ??
          'Username must be 3-30 characters, start with a letter, and contain only letters, numbers, underscores, and hyphens';
    }
    return null;
  }

  // ===== Name =====

  /// Validates a name (letters, spaces, hyphens, apostrophes).
  static String? name(String? value, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!RegexPatterns.name.hasMatch(value)) {
      return message ?? 'Please enter a valid name';
    }
    return null;
  }

  // ===== Regex =====

  /// Validates against a custom regex pattern.
  static String? Function(String?) pattern(
    RegExp regex, {
    String? message,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  // ===== Compose =====

  /// Combines multiple validators.
  ///
  /// Returns the first error encountered, or null if all pass.
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.compose([
  ///     Validators.required,
  ///     Validators.email,
  ///   ]),
  /// )
  /// ```
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

/// Common regex patterns for validation.
///
/// Pre-compiled regex patterns for common validation scenarios.
class RegexPatterns {
  RegexPatterns._();

  // ===== Email =====

  /// Email validation pattern.
  ///
  /// Matches standard email formats like `user@example.com`.
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  // ===== Phone =====

  /// International phone number pattern.
  ///
  /// Matches formats like `+1234567890`, `123-456-7890`, `(123) 456-7890`.
  static final RegExp phone = RegExp(
    r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}$',
  );

  /// French phone number pattern.
  ///
  /// Matches formats like `0612345678`, `06 12 34 56 78`, `+33612345678`.
  static final RegExp frenchPhone = RegExp(
    r'^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$',
  );

  // ===== Password =====

  /// Password with minimum complexity.
  ///
  /// Requires at least 8 characters with:
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  static final RegExp passwordStrong = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\W]{8,}$',
  );

  /// Password with special character requirement.
  ///
  /// Requires at least 8 characters with:
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static final RegExp passwordVeryStrong = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[a-zA-Z\d\W_]{8,}$',
  );

  // ===== URL =====

  /// URL validation pattern.
  ///
  /// Matches HTTP and HTTPS URLs.
  static final RegExp url = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    caseSensitive: false,
  );

  /// Simple URL pattern (less strict).
  static final RegExp urlSimple = RegExp(
    r'^(https?:\/\/)?[\w\-]+(\.[\w\-]+)+[/#?]?.*$',
    caseSensitive: false,
  );

  // ===== Username =====

  /// Username pattern.
  ///
  /// Allows alphanumeric characters, underscores, and hyphens.
  /// Must start with a letter, 3-30 characters.
  static final RegExp username = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_-]{2,29}$',
  );

  // ===== Name =====

  /// Name pattern (allows letters, spaces, hyphens, apostrophes).
  static final RegExp name = RegExp(
    r"^[a-zA-ZÀ-ÿ]+([ '-][a-zA-ZÀ-ÿ]+)*$",
  );

  // ===== Numbers =====

  /// Integer pattern (positive and negative).
  static final RegExp integer = RegExp(r'^-?\d+$');

  /// Decimal pattern (positive and negative).
  static final RegExp decimal = RegExp(r'^-?\d+\.?\d*$');

  /// Positive integer only.
  static final RegExp positiveInteger = RegExp(r'^\d+$');

  /// Currency amount (up to 2 decimal places).
  static final RegExp currency = RegExp(r'^\d+(\.\d{1,2})?$');

  // ===== Credit Card =====

  /// Credit card number pattern (16 digits, optionally with spaces/dashes).
  static final RegExp creditCard = RegExp(
    r'^[\d\s-]{13,19}$',
  );

  /// CVV pattern (3 or 4 digits).
  static final RegExp cvv = RegExp(r'^\d{3,4}$');

  // ===== Date =====

  /// Date pattern (DD/MM/YYYY).
  static final RegExp dateDMY = RegExp(
    r'^(0[1-9]|[12][0-9]|3[01])[\/\-](0[1-9]|1[012])[\/\-]\d{4}$',
  );

  /// Date pattern (YYYY-MM-DD).
  static final RegExp dateISO = RegExp(
    r'^\d{4}[\/\-](0[1-9]|1[012])[\/\-](0[1-9]|[12][0-9]|3[01])$',
  );

  // ===== Other =====

  /// UUID pattern (v4).
  static final RegExp uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  /// Hex color pattern (with or without #).
  static final RegExp hexColor = RegExp(
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
  );

  /// Alphanumeric only.
  static final RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  /// Slug pattern (lowercase letters, numbers, hyphens).
  static final RegExp slug = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

  /// HTML tags pattern.
  static final RegExp htmlTags = RegExp(r'<[^>]*>');

  /// Whitespace pattern.
  static final RegExp whitespace = RegExp(r'\s+');

  /// Multiple spaces pattern.
  static final RegExp multipleSpaces = RegExp(r' {2,}');
}

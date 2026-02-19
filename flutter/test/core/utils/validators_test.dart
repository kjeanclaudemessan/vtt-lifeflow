import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/core/utils/validators.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────
  // Validators Tests
  // ─────────────────────────────────────────────────────────────────

  group('Validators', () {
    // ───────────────────────────────────────────────────────────────
    // required
    // ───────────────────────────────────────────────────────────────
    group('required', () {
      test('should return null for non-empty value', () {
        expect(Validators.required('hello'), isNull);
        expect(Validators.required('a'), isNull);
        expect(Validators.required('  hello  '), isNull);
      });

      test('should return error for null or empty value', () {
        expect(Validators.required(null), isNotNull);
        expect(Validators.required(''), isNotNull);
        expect(Validators.required('   '), isNotNull);
      });

      test('should use custom message when provided', () {
        const customMessage = 'Custom error message';
        expect(Validators.required('', message: customMessage),
            equals(customMessage));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // email
    // ───────────────────────────────────────────────────────────────
    group('email', () {
      test('should return null for valid email', () {
        expect(Validators.email('user@example.com'), isNull);
        expect(Validators.email('user.name@example.co.uk'), isNull);
        expect(Validators.email('user+tag@example.org'), isNull);
      });

      test('should return null for empty value (optional)', () {
        expect(Validators.email(null), isNull);
        expect(Validators.email(''), isNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('invalid@'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
        expect(Validators.email('user@.com'), isNotNull);
      });

      test('should use custom message when provided', () {
        const customMessage = 'Invalid email format';
        expect(Validators.email('invalid', message: customMessage),
            equals(customMessage));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // requiredEmail
    // ───────────────────────────────────────────────────────────────
    group('requiredEmail', () {
      test('should return null for valid email', () {
        expect(Validators.requiredEmail('user@example.com'), isNull);
      });

      test('should return error for empty value', () {
        expect(Validators.requiredEmail(null), isNotNull);
        expect(Validators.requiredEmail(''), isNotNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.requiredEmail('invalid'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // phone
    // ───────────────────────────────────────────────────────────────
    group('phone', () {
      test('should return null for valid phone numbers', () {
        // Matches regex: ^\+?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,4}[-\s\.]?[0-9]{1,9}$
        expect(Validators.phone('123-456-7890'), isNull);
        expect(Validators.phone('1234567890'), isNull);
        expect(Validators.phone('+1-234-567890'), isNull);
      });

      test('should return null for empty value (optional)', () {
        expect(Validators.phone(null), isNull);
        expect(Validators.phone(''), isNull);
      });

      test('should return error for invalid phone', () {
        expect(Validators.phone('abc'), isNotNull);
        expect(Validators.phone('12'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // password
    // ───────────────────────────────────────────────────────────────
    group('password', () {
      test('should return null for valid password', () {
        expect(Validators.password('password123'), isNull);
        expect(Validators.password('12345678'), isNull);
      });

      test('should return null for empty value (optional)', () {
        expect(Validators.password(null), isNull);
        expect(Validators.password(''), isNull);
      });

      test('should return error for short password', () {
        expect(Validators.password('short'), isNotNull);
        expect(Validators.password('1234567'), isNotNull);
      });

      test('should respect custom minLength', () {
        expect(Validators.password('abc', minLength: 4), isNotNull);
        expect(Validators.password('abcd', minLength: 4), isNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // strongPassword
    // ───────────────────────────────────────────────────────────────
    group('strongPassword', () {
      test('should return null for strong password', () {
        expect(Validators.strongPassword('Password1'), isNull);
        expect(Validators.strongPassword('MyPass123'), isNull);
      });

      test('should return error for weak password', () {
        expect(Validators.strongPassword('password'),
            isNotNull); // no uppercase or digit
        expect(Validators.strongPassword('PASSWORD'),
            isNotNull); // no lowercase or digit
        expect(Validators.strongPassword('Password'), isNotNull); // no digit
        expect(Validators.strongPassword('12345678'), isNotNull); // no letters
      });
    });

    // ───────────────────────────────────────────────────────────────
    // confirmPassword
    // ───────────────────────────────────────────────────────────────
    group('confirmPassword', () {
      test('should return null when passwords match', () {
        final validator = Validators.confirmPassword('password123');
        expect(validator('password123'), isNull);
      });

      test('should return error when passwords do not match', () {
        final validator = Validators.confirmPassword('password123');
        expect(validator('different'), isNotNull);
        expect(validator('password12'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // minLength
    // ───────────────────────────────────────────────────────────────
    group('minLength', () {
      test('should return null for value meeting minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('hello'), isNull);
        expect(validator('hello world'), isNull);
      });

      test('should return null for empty value (optional)', () {
        final validator = Validators.minLength(5);
        expect(validator(null), isNull);
        expect(validator(''), isNull);
      });

      test('should return error for value below minimum length', () {
        final validator = Validators.minLength(5);
        expect(validator('hi'), isNotNull);
        expect(validator('abcd'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // maxLength
    // ───────────────────────────────────────────────────────────────
    group('maxLength', () {
      test('should return null for value within maximum length', () {
        final validator = Validators.maxLength(5);
        expect(validator('hi'), isNull);
        expect(validator('hello'), isNull);
      });

      test('should return error for value exceeding maximum length', () {
        final validator = Validators.maxLength(5);
        expect(validator('hello!'), isNotNull);
        expect(validator('hello world'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // exactLength
    // ───────────────────────────────────────────────────────────────
    group('exactLength', () {
      test('should return null for value of exact length', () {
        final validator = Validators.exactLength(5);
        expect(validator('hello'), isNull);
        expect(validator('world'), isNull);
      });

      test('should return error for value not matching exact length', () {
        final validator = Validators.exactLength(5);
        expect(validator('hi'), isNotNull);
        expect(validator('hello!'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // compose
    // ───────────────────────────────────────────────────────────────
    group('compose', () {
      test('should return null when all validators pass', () {
        final validator = Validators.compose([
          Validators.required,
          Validators.email,
        ]);
        expect(validator('user@example.com'), isNull);
      });

      test('should return first error when a validator fails', () {
        final validator = Validators.compose([
          Validators.required,
          Validators.email,
        ]);
        expect(validator(''), isNotNull);
        expect(validator('invalid'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // url
    // ───────────────────────────────────────────────────────────────
    group('url', () {
      test('should return null for valid URLs', () {
        expect(Validators.url('https://example.com'), isNull);
        expect(Validators.url('http://example.com'), isNull);
        expect(Validators.url('https://sub.example.com/path'), isNull);
      });

      test('should return error for invalid URLs', () {
        expect(Validators.url('example.com'), isNotNull);
        expect(Validators.url('not a url'), isNotNull);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // integer (numeric validation)
    // ───────────────────────────────────────────────────────────────
    group('integer', () {
      test('should return null for numeric strings', () {
        expect(Validators.integer('123'), isNull);
        expect(Validators.integer('0'), isNull);
      });

      test('should return error for non-numeric strings', () {
        expect(Validators.integer('abc'), isNotNull);
        expect(Validators.integer('12.3'), isNotNull);
        expect(Validators.integer('12a'), isNotNull);
      });
    });
  });
}

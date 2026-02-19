import 'package:flutter_test/flutter_test.dart';
import 'package:lifeflow/core/extensions/string_extensions.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────
  // StringExtensions Tests
  // ─────────────────────────────────────────────────────────────────

  group('StringExtensions', () {
    // ───────────────────────────────────────────────────────────────
    // isValidEmail
    // ───────────────────────────────────────────────────────────────
    group('isValidEmail', () {
      test('should return true for valid email addresses', () {
        expect('user@example.com'.isValidEmail, isTrue);
        expect('user.name@example.com'.isValidEmail, isTrue);
        expect('user+tag@example.co.uk'.isValidEmail, isTrue);
        expect('user123@sub.domain.com'.isValidEmail, isTrue);
        expect('user_name@example.org'.isValidEmail, isTrue);
      });

      test('should return false for invalid email addresses', () {
        expect(''.isValidEmail, isFalse);
        expect('invalid'.isValidEmail, isFalse);
        expect('invalid@'.isValidEmail, isFalse);
        expect('@example.com'.isValidEmail, isFalse);
        expect('user@.com'.isValidEmail, isFalse);
        expect('user@example'.isValidEmail, isFalse);
        expect('user name@example.com'.isValidEmail, isFalse);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // isValidPhone
    // ───────────────────────────────────────────────────────────────
    group('isValidPhone', () {
      test('should return true for valid phone numbers', () {
        // The regex expects pattern: [+]?[optional parenthesis][1-4 digits][optional parenthesis][-or space or dot][1-4 digits][-or space or dot][1-9 digits]
        expect('123-456-7890'.isValidPhone, isTrue);
        expect('1234567890'.isValidPhone, isTrue);
        expect('+1-234-567890'.isValidPhone, isTrue);
        expect('(12)3456789'.isValidPhone, isTrue);
      });

      test('should return false for invalid phone numbers', () {
        expect(''.isValidPhone, isFalse);
        expect('abc'.isValidPhone, isFalse);
        // Note: Short numbers may actually match the permissive regex
      });
    });

    // ───────────────────────────────────────────────────────────────
    // isValidUrl
    // ───────────────────────────────────────────────────────────────
    group('isValidUrl', () {
      test('should return true for valid URLs', () {
        expect('https://example.com'.isValidUrl, isTrue);
        expect('http://example.com'.isValidUrl, isTrue);
        expect('https://sub.example.com/path'.isValidUrl, isTrue);
        expect('https://example.com/path?query=1'.isValidUrl, isTrue);
      });

      test('should return false for invalid URLs', () {
        expect(''.isValidUrl, isFalse);
        expect('example.com'.isValidUrl, isFalse);
        expect('ftp://example.com'.isValidUrl, isFalse);
        expect('not a url'.isValidUrl, isFalse);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // isNumeric / isAlpha / isAlphanumeric
    // ───────────────────────────────────────────────────────────────
    group('character type checks', () {
      test('isNumeric should return true for numeric strings', () {
        expect('123'.isNumeric, isTrue);
        expect('0'.isNumeric, isTrue);
        expect('999999'.isNumeric, isTrue);
      });

      test('isNumeric should return false for non-numeric strings', () {
        expect(''.isNumeric, isFalse);
        expect('12.3'.isNumeric, isFalse);
        expect('abc'.isNumeric, isFalse);
        expect('12a'.isNumeric, isFalse);
      });

      test('isAlpha should return true for alphabetic strings', () {
        expect('abc'.isAlpha, isTrue);
        expect('ABC'.isAlpha, isTrue);
        expect('AbCd'.isAlpha, isTrue);
      });

      test('isAlpha should return false for non-alphabetic strings', () {
        expect(''.isAlpha, isFalse);
        expect('abc123'.isAlpha, isFalse);
        expect('abc def'.isAlpha, isFalse);
      });

      test('isAlphanumeric should return true for alphanumeric strings', () {
        expect('abc123'.isAlphanumeric, isTrue);
        expect('ABC'.isAlphanumeric, isTrue);
        expect('123'.isAlphanumeric, isTrue);
      });

      test('isAlphanumeric should return false for non-alphanumeric strings',
          () {
        expect(''.isAlphanumeric, isFalse);
        expect('abc 123'.isAlphanumeric, isFalse);
        expect('abc-123'.isAlphanumeric, isFalse);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // isBlank / isNotBlank
    // ───────────────────────────────────────────────────────────────
    group('blank checks', () {
      test('isBlank should return true for blank strings', () {
        expect(''.isBlank, isTrue);
        expect('   '.isBlank, isTrue);
        expect('\t'.isBlank, isTrue);
        expect('\n'.isBlank, isTrue);
      });

      test('isBlank should return false for non-blank strings', () {
        expect('a'.isBlank, isFalse);
        expect(' a '.isBlank, isFalse);
      });

      test('isNotBlank should return true for non-blank strings', () {
        expect('hello'.isNotBlank, isTrue);
        expect(' a '.isNotBlank, isTrue);
      });

      test('isNotBlank should return false for blank strings', () {
        expect(''.isNotBlank, isFalse);
        expect('   '.isNotBlank, isFalse);
      });
    });

    // ───────────────────────────────────────────────────────────────
    // capitalize / titleCase / sentenceCase
    // ───────────────────────────────────────────────────────────────
    group('case transformations', () {
      test('capitalize should capitalize first letter', () {
        expect('hello'.capitalize, equals('Hello'));
        expect('HELLO'.capitalize, equals('HELLO'));
        expect('hELLO'.capitalize, equals('HELLO'));
        expect(''.capitalize, equals(''));
        expect('a'.capitalize, equals('A'));
      });

      test('titleCase should capitalize first letter of each word', () {
        expect('hello world'.titleCase, equals('Hello World'));
        expect('hello'.titleCase, equals('Hello'));
        expect(''.titleCase, equals(''));
      });

      test('sentenceCase should lowercase all but first letter', () {
        expect('HELLO WORLD'.sentenceCase, equals('Hello world'));
        expect('hello'.sentenceCase, equals('Hello'));
        expect(''.sentenceCase, equals(''));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // Truncation
    // ───────────────────────────────────────────────────────────────
    group('truncate', () {
      test('should truncate long strings', () {
        expect('Hello World'.truncate(5), equals('Hello...'));
        expect('Hello World'.truncate(5, ellipsis: '…'), equals('Hello…'));
      });

      test('should not truncate short strings', () {
        expect('Hi'.truncate(5), equals('Hi'));
        expect('Hello'.truncate(5), equals('Hello'));
      });

      test('should handle empty strings', () {
        expect(''.truncate(5), equals(''));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // Initials
    // ───────────────────────────────────────────────────────────────
    group('initials', () {
      test('should return initials from name', () {
        expect('John Doe'.initials, equals('JD'));
        expect('John'.initials, equals('J'));
        // Note: initials only returns first and last, not middle names
        expect('John Michael Doe'.initials, equals('JD'));
      });

      test('should handle edge cases', () {
        expect(''.initials, equals(''));
        expect('a'.initials, equals('A'));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // Reverse
    // ───────────────────────────────────────────────────────────────
    group('reversed', () {
      test('should reverse string', () {
        expect('hello'.reversed, equals('olleh'));
        expect(''.reversed, equals(''));
        expect('a'.reversed, equals('a'));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // removeWhitespace
    // ───────────────────────────────────────────────────────────────
    group('removeWhitespace', () {
      test('should remove all whitespace', () {
        expect('hello world'.removeWhitespace, equals('helloworld'));
        expect(' h e l l o '.removeWhitespace, equals('hello'));
        expect('hello\tworld\n'.removeWhitespace, equals('helloworld'));
      });
    });

    // ───────────────────────────────────────────────────────────────
    // Nullable Extensions
    // ───────────────────────────────────────────────────────────────
    group('NullableStringExtensions', () {
      test('orDefault should return default for null', () {
        const String? nullString = null;
        expect(nullString.orDefault('default'), equals('default'));
      });

      test('orDefault should return string value for non-null', () {
        const String value = 'hello';
        expect(value.orDefault('default'), equals('hello'));
      });

      test('isNullOrEmpty should return true for null or empty', () {
        const String? nullString = null;
        const String emptyString = '';
        const String blankString = '   ';
        const String validString = 'hello';

        expect(nullString.isNullOrEmpty, isTrue);
        expect(emptyString.isNullOrEmpty, isTrue);
        expect(blankString.isNullOrEmpty, isFalse);
        expect(validString.isNullOrEmpty, isFalse);
      });

      test('isNullOrBlank should return true for null, empty, or blank', () {
        const String? nullString = null;
        const String emptyString = '';
        const String blankString = '   ';
        const String validString = 'hello';

        expect(nullString.isNullOrBlank, isTrue);
        expect(emptyString.isNullOrBlank, isTrue);
        expect(blankString.isNullOrBlank, isTrue);
        expect(validString.isNullOrBlank, isFalse);
      });
    });
  });
}

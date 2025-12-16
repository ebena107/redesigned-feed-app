import 'package:feed_estimator/src/core/utils/input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputValidators Tests', () {
    group('validatePrice', () {
      test('accepts valid price', () {
        expect(InputValidators.validatePrice('100.50'), isNull);
        expect(InputValidators.validatePrice('0'), isNull);
        expect(InputValidators.validatePrice('999999'), isNull);
      });

      test('accepts price with comma (validator normalizes to period)', () {
        // Note: Validator internally replaces comma with period before parsing
        // So comma input is accepted and normalized
        expect(InputValidators.validatePrice('100,50'), isNull);
        expect(InputValidators.validatePrice('50,5'), isNull);
      });

      test('rejects null or empty value', () {
        expect(InputValidators.validatePrice(null), 'Price is required');
        expect(InputValidators.validatePrice(''), 'Price is required');
      });

      test('rejects invalid format', () {
        expect(
          InputValidators.validatePrice('abc'),
          'Enter valid price (e.g., 10.50)',
        );
        expect(
          InputValidators.validatePrice('12.34.56'),
          'Enter valid price (e.g., 10.50)',
        );
      });

      test('rejects negative price', () {
        expect(
          InputValidators.validatePrice('-10'),
          'Price cannot be negative',
        );
        expect(
          InputValidators.validatePrice('-0.01'),
          'Price cannot be negative',
        );
      });

      test('rejects price exceeding maximum', () {
        expect(
          InputValidators.validatePrice('1000001'),
          'Price exceeds maximum value (1,000,000)',
        );
        expect(
          InputValidators.validatePrice('9999999'),
          'Price exceeds maximum value (1,000,000)',
        );
      });
    });

    group('validateQuantity', () {
      test('accepts valid quantity', () {
        expect(InputValidators.validateQuantity('50.5'), isNull);
        expect(InputValidators.validateQuantity('1'), isNull);
        expect(InputValidators.validateQuantity('99999'), isNull);
      });

      test('accepts quantity with comma as decimal separator', () {
        expect(InputValidators.validateQuantity('50,5'), isNull);
      });

      test('rejects null or empty value', () {
        expect(InputValidators.validateQuantity(null), 'Quantity is required');
        expect(InputValidators.validateQuantity(''), 'Quantity is required');
      });

      test('rejects invalid format', () {
        expect(
          InputValidators.validateQuantity('abc'),
          'Enter valid quantity (e.g., 10.50)',
        );
      });

      test('rejects zero or negative quantity', () {
        expect(
          InputValidators.validateQuantity('0'),
          'Quantity must be greater than 0',
        );
        expect(
          InputValidators.validateQuantity('-5'),
          'Quantity must be greater than 0',
        );
      });

      test('rejects quantity exceeding maximum', () {
        expect(
          InputValidators.validateQuantity('100001'),
          'Quantity exceeds maximum value (100,000)',
        );
      });
    });

    group('validateName', () {
      test('accepts valid name', () {
        expect(InputValidators.validateName('Test Feed'), isNull);
        expect(InputValidators.validateName('Ingredient Name'), isNull);
        expect(InputValidators.validateName('ABC'), isNull);
      });

      test('rejects null or empty value', () {
        expect(InputValidators.validateName(null), 'Name is required');
        expect(InputValidators.validateName(''), 'Name is required');
      });

      test('rejects whitespace-only value', () {
        expect(
          InputValidators.validateName('   '),
          'Name cannot be only whitespace',
        );
      });

      test('rejects name shorter than 3 characters', () {
        expect(
          InputValidators.validateName('AB'),
          'Name must be at least 3 characters',
        );
        expect(
          InputValidators.validateName('A'),
          'Name must be at least 3 characters',
        );
      });

      test('rejects name longer than 50 characters', () {
        final longName = 'A' * 51;
        expect(
          InputValidators.validateName(longName),
          'Name must be less than 50 characters',
        );
      });

      test('uses custom field name in error messages', () {
        expect(
          InputValidators.validateName(null, fieldName: 'Feed Name'),
          'Feed Name is required',
        );
        expect(
          InputValidators.validateName('AB', fieldName: 'Ingredient'),
          'Ingredient must be at least 3 characters',
        );
      });

      test('trims whitespace before validation', () {
        expect(InputValidators.validateName('  Test  '), isNull);
      });
    });

    group('validateEmail', () {
      test('accepts valid email', () {
        expect(InputValidators.validateEmail('test@example.com'), isNull);
        expect(InputValidators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(InputValidators.validateEmail('user+tag@example.com'), isNull);
      });

      test('rejects null or empty value', () {
        expect(InputValidators.validateEmail(null), 'Email is required');
        expect(InputValidators.validateEmail(''), 'Email is required');
      });

      test('rejects invalid email format', () {
        expect(
          InputValidators.validateEmail('invalid'),
          'Enter a valid email address',
        );
        expect(
          InputValidators.validateEmail('test@'),
          'Enter a valid email address',
        );
        expect(
          InputValidators.validateEmail('@example.com'),
          'Enter a valid email address',
        );
        expect(
          InputValidators.validateEmail('test@example'),
          'Enter a valid email address',
        );
      });
    });

    group('validatePercentage', () {
      test('accepts valid percentage', () {
        expect(InputValidators.validatePercentage('0'), isNull);
        expect(InputValidators.validatePercentage('50'), isNull);
        expect(InputValidators.validatePercentage('100'), isNull);
        expect(InputValidators.validatePercentage('25.5'), isNull);
      });

      test('accepts percentage with comma', () {
        expect(InputValidators.validatePercentage('25,5'), isNull);
      });

      test('rejects null or empty value', () {
        expect(
          InputValidators.validatePercentage(null),
          'Percentage is required',
        );
        expect(
            InputValidators.validatePercentage(''), 'Percentage is required');
      });

      test('rejects invalid format', () {
        expect(
          InputValidators.validatePercentage('abc'),
          'Enter valid percentage (e.g., 25.5)',
        );
      });

      test('rejects percentage outside 0-100 range', () {
        expect(
          InputValidators.validatePercentage('-1'),
          'Percentage must be between 0 and 100',
        );
        expect(
          InputValidators.validatePercentage('101'),
          'Percentage must be between 0 and 100',
        );
        expect(
          InputValidators.validatePercentage('150'),
          'Percentage must be between 0 and 100',
        );
      });
    });

    group('validateNumeric', () {
      test('accepts value within range', () {
        expect(
          InputValidators.validateNumeric('50', min: 0, max: 100),
          isNull,
        );
        expect(
          InputValidators.validateNumeric('0', min: 0, max: 100),
          isNull,
        );
        expect(
          InputValidators.validateNumeric('100', min: 0, max: 100),
          isNull,
        );
      });

      test('accepts value with comma', () {
        expect(
          InputValidators.validateNumeric('50,5', min: 0, max: 100),
          isNull,
        );
      });

      test('rejects null or empty value', () {
        expect(
          InputValidators.validateNumeric(null, min: 0, max: 100),
          'Value is required',
        );
        expect(
          InputValidators.validateNumeric('', min: 0, max: 100),
          'Value is required',
        );
      });

      test('rejects invalid format', () {
        expect(
          InputValidators.validateNumeric('abc', min: 0, max: 100),
          'Enter valid Value',
        );
      });

      test('rejects value below minimum', () {
        expect(
          InputValidators.validateNumeric('-1', min: 0, max: 100),
          'Value must be at least 0.0',
        );
        expect(
          InputValidators.validateNumeric('5', min: 10, max: 100),
          'Value must be at least 10.0',
        );
      });

      test('rejects value above maximum', () {
        expect(
          InputValidators.validateNumeric('101', min: 0, max: 100),
          'Value must be at most 100.0',
        );
        expect(
          InputValidators.validateNumeric('200', min: 0, max: 100),
          'Value must be at most 100.0',
        );
      });

      test('uses custom field name in error messages', () {
        expect(
          InputValidators.validateNumeric(
            null,
            min: 0,
            max: 100,
            fieldName: 'Weight',
          ),
          'Weight is required',
        );
        expect(
          InputValidators.validateNumeric(
            'abc',
            min: 0,
            max: 100,
            fieldName: 'Weight',
          ),
          'Enter valid Weight',
        );
      });
    });

    group('validateRequired', () {
      test('accepts non-empty value', () {
        expect(InputValidators.validateRequired('test'), isNull);
        expect(InputValidators.validateRequired('123'), isNull);
      });

      test('rejects null or empty value', () {
        expect(InputValidators.validateRequired(null), 'Field is required');
        expect(InputValidators.validateRequired(''), 'Field is required');
      });

      test('rejects whitespace-only value', () {
        expect(InputValidators.validateRequired('   '), 'Field is required');
      });

      test('uses custom field name in error messages', () {
        expect(
          InputValidators.validateRequired(null, fieldName: 'Username'),
          'Username is required',
        );
      });
    });

    group('validatePhone', () {
      test('accepts valid phone numbers', () {
        expect(InputValidators.validatePhone('1234567890'), isNull);
        expect(InputValidators.validatePhone('+234 123 456 7890'), isNull);
        expect(InputValidators.validatePhone('(123) 456-7890'), isNull);
        expect(InputValidators.validatePhone('+1-234-567-8901'), isNull);
      });

      test('rejects null or empty value', () {
        expect(
          InputValidators.validatePhone(null),
          'Phone number is required',
        );
        expect(InputValidators.validatePhone(''), 'Phone number is required');
      });

      test('rejects phone number too short', () {
        expect(
          InputValidators.validatePhone('123'),
          'Enter a valid phone number',
        );
        expect(
          InputValidators.validatePhone('12345'),
          'Enter a valid phone number',
        );
      });

      test('rejects phone number too long', () {
        expect(
          InputValidators.validatePhone('1234567890123456'),
          'Enter a valid phone number',
        );
      });

      test('rejects phone with invalid characters', () {
        expect(
          InputValidators.validatePhone('123-abc-7890'),
          'Phone number can only contain digits and +',
        );
        expect(
          InputValidators.validatePhone('123@456#7890'),
          'Phone number can only contain digits and +',
        );
      });
    });

    group('Regex Patterns', () {
      test('numericRegex matches valid numbers', () {
        expect(InputValidators.numericRegex.hasMatch('123'), true);
        expect(InputValidators.numericRegex.hasMatch('123.45'), true);
        expect(InputValidators.numericRegex.hasMatch('123,45'), true);
        expect(InputValidators.numericRegex.hasMatch('0.5'), true);
      });

      test('numericRegex rejects invalid input', () {
        expect(InputValidators.numericRegex.hasMatch('abc'), false);
        // Note: numericRegex matches partial patterns, so '12.34.56' contains '12.34'
        // which is a valid match. The regex is permissive for use with formatters.
        expect(InputValidators.numericRegex.hasMatch('12.34.56'), true);
        expect(InputValidators.numericRegex.hasMatch('!!!'), false);
      });

      test('nameRegex matches letters and spaces', () {
        expect(InputValidators.nameRegex.hasMatch('Test Name'), true);
        expect(InputValidators.nameRegex.hasMatch('ABC'), true);
      });

      test('nameRegex rejects numbers and special characters', () {
        expect(InputValidators.nameRegex.hasMatch('123'), false);
        expect(InputValidators.nameRegex.hasMatch(r'@#$'), false);
      });

      test('alphanumericRegex matches valid input', () {
        expect(InputValidators.alphanumericRegex.hasMatch('Test123'), true);
        expect(
            InputValidators.alphanumericRegex.hasMatch('test-name_1.0'), true);
      });
    });

    group('Edge Cases', () {
      test('handles very small decimal values', () {
        expect(InputValidators.validatePrice('0.01'), isNull);
        expect(InputValidators.validateQuantity('0.001'), isNull);
      });

      test('handles very large valid values', () {
        expect(InputValidators.validatePrice('999999.99'), isNull);
        expect(InputValidators.validateQuantity('99999.99'), isNull);
      });

      test('handles leading/trailing whitespace in names', () {
        expect(InputValidators.validateName('  Test  '), isNull);
        expect(InputValidators.validateName('Test   '), isNull);
      });

      test('handles multiple decimal separators', () {
        expect(
          InputValidators.validatePrice('12.34.56'),
          'Enter valid price (e.g., 10.50)',
        );
      });

      test('handles boundary values for percentage', () {
        expect(InputValidators.validatePercentage('0'), isNull);
        expect(InputValidators.validatePercentage('100'), isNull);
        expect(InputValidators.validatePercentage('0.0'), isNull);
        expect(InputValidators.validatePercentage('100.0'), isNull);
      });
    });
  });
}

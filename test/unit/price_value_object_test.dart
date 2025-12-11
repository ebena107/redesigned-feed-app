import 'package:feed_estimator/src/core/value_objects/price.dart';
import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Price Value Object Tests', () {
    group('Constructor', () {
      test('creates price with amount and default currency', () {
        const price = Price(amount: 100.0);

        expect(price.amount, 100.0);
        expect(price.currency, 'NGN');
      });

      test('creates price with custom currency', () {
        const price = Price(amount: 100.0, currency: 'USD');

        expect(price.amount, 100.0);
        expect(price.currency, 'USD');
      });

      test('creates price with zero amount', () {
        const price = Price(amount: 0.0);

        expect(price.amount, 0.0);
      });

      test('creates price with decimal amount', () {
        const price = Price(amount: 99.99);

        expect(price.amount, 99.99);
      });
    });

    group('validated Factory', () {
      test('creates valid price', () {
        final price = Price.validated(100.0);

        expect(price.amount, 100.0);
        expect(price.currency, 'NGN');
      });

      test('creates valid price with custom currency', () {
        final price = Price.validated(100.0, currency: 'USD');

        expect(price.amount, 100.0);
        expect(price.currency, 'USD');
      });

      test('throws ValidationException for negative amount', () {
        expect(
          () => Price.validated(-10.0),
          throwsA(isA<ValidationException>()),
        );
      });

      test('throws ValidationException for amount exceeding maximum', () {
        expect(
          () => Price.validated(1000000001.0),
          throwsA(isA<ValidationException>()),
        );
      });

      test('accepts zero amount', () {
        final price = Price.validated(0.0);

        expect(price.amount, 0.0);
      });

      test('accepts maximum valid amount', () {
        final price = Price.validated(1000000000.0);

        expect(price.amount, 1000000000.0);
      });
    });

    group('Map Serialization', () {
      test('converts to map correctly', () {
        const price = Price(amount: 100.50, currency: 'USD');

        final map = price.toMap();

        expect(map['amount'], 100.50);
        expect(map['currency'], 'USD');
      });

      test('creates from map correctly', () {
        final map = {
          'amount': 100.50,
          'currency': 'USD',
        };

        final price = Price.fromMap(map);

        expect(price.amount, 100.50);
        expect(price.currency, 'USD');
      });

      test('creates from map with default currency', () {
        final map = {
          'amount': 100.50,
        };

        final price = Price.fromMap(map);

        expect(price.amount, 100.50);
        expect(price.currency, 'NGN');
      });

      test('round-trip map conversion preserves data', () {
        const original = Price(amount: 250.75, currency: 'EUR');

        final map = original.toMap();
        final restored = Price.fromMap(map);

        expect(restored.amount, original.amount);
        expect(restored.currency, original.currency);
      });

      test('handles integer amount in map', () {
        final map = {
          'amount': 100, // Integer instead of double
          'currency': 'NGN',
        };

        final price = Price.fromMap(map);

        expect(price.amount, 100.0);
      });
    });

    group('Arithmetic Operations', () {
      test('adds two prices with same currency', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'NGN');

        final result = price1 + price2;

        expect(result.amount, 150.0);
        expect(result.currency, 'NGN');
      });

      test('throws exception when adding prices with different currencies', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'USD');

        expect(
          () => price1 + price2,
          throwsA(isA<ValidationException>()),
        );
      });

      test('subtracts two prices with same currency', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 30.0, currency: 'NGN');

        final result = price1 - price2;

        expect(result.amount, 70.0);
        expect(result.currency, 'NGN');
      });

      test('throws exception when subtracting prices with different currencies',
          () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 30.0, currency: 'USD');

        expect(
          () => price1 - price2,
          throwsA(isA<ValidationException>()),
        );
      });

      test('multiplies price by factor', () {
        const price = Price(amount: 100.0, currency: 'NGN');

        final result = price * 2.5;

        expect(result.amount, 250.0);
        expect(result.currency, 'NGN');
      });

      test('multiplies price by zero', () {
        const price = Price(amount: 100.0, currency: 'NGN');

        final result = price * 0;

        expect(result.amount, 0.0);
      });

      test('divides price by factor', () {
        const price = Price(amount: 100.0, currency: 'NGN');

        final result = price / 2.0;

        expect(result.amount, 50.0);
        expect(result.currency, 'NGN');
      });

      test('throws exception when dividing by zero', () {
        const price = Price(amount: 100.0, currency: 'NGN');

        expect(
          () => price / 0,
          throwsA(isA<ValidationException>()),
        );
      });
    });

    group('Comparison Operations', () {
      test('compares prices with same currency using >', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'NGN');

        expect(price1 > price2, true);
        expect(price2 > price1, false);
      });

      test('compares prices with same currency using <', () {
        const price1 = Price(amount: 50.0, currency: 'NGN');
        const price2 = Price(amount: 100.0, currency: 'NGN');

        expect(price1 < price2, true);
        expect(price2 < price1, false);
      });

      test(
          'throws exception when comparing prices with different currencies using >',
          () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'USD');

        expect(
          () => price1 > price2,
          throwsA(isA<ValidationException>()),
        );
      });

      test(
          'throws exception when comparing prices with different currencies using <',
          () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'USD');

        expect(
          () => price1 < price2,
          throwsA(isA<ValidationException>()),
        );
      });

      test('equal prices are not greater or less than each other', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 100.0, currency: 'NGN');

        expect(price1 > price2, false);
        expect(price1 < price2, false);
      });
    });

    group('Formatting', () {
      test('formats NGN price correctly', () {
        const price = Price(amount: 100.50, currency: 'NGN');

        expect(price.format(), '₦100.50');
      });

      test('formats USD price correctly', () {
        const price = Price(amount: 100.50, currency: 'USD');

        expect(price.format(), '\$100.50');
      });

      test('formats EUR price correctly', () {
        const price = Price(amount: 100.50, currency: 'EUR');

        expect(price.format(), '€100.50');
      });

      test('formats GBP price correctly', () {
        const price = Price(amount: 100.50, currency: 'GBP');

        expect(price.format(), '£100.50');
      });

      test('formats unknown currency with currency code', () {
        const price = Price(amount: 100.50, currency: 'JPY');

        expect(price.format(), 'JPY 100.50');
      });

      test('formats with custom decimal places', () {
        const price = Price(amount: 100.5, currency: 'NGN');

        expect(price.formatWithDecimals(0), '₦101'); // Rounds up
        expect(price.formatWithDecimals(1), '₦100.5');
        expect(price.formatWithDecimals(3), '₦100.500');
      });

      test('toString returns formatted price', () {
        const price = Price(amount: 100.50, currency: 'USD');

        expect(price.toString(), '\$100.50');
      });

      test('formats zero amount correctly', () {
        const price = Price(amount: 0.0, currency: 'NGN');

        expect(price.format(), '₦0.00');
      });

      test('formats large amount correctly', () {
        const price = Price(amount: 1234567.89, currency: 'NGN');

        expect(price.format(), '₦1234567.89');
      });
    });

    group('Equality', () {
      test('prices with same amount and currency are equal', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 100.0, currency: 'NGN');

        expect(price1, equals(price2));
        expect(price1.hashCode, equals(price2.hashCode));
      });

      test('prices with different amounts are not equal', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 50.0, currency: 'NGN');

        expect(price1, isNot(equals(price2)));
      });

      test('prices with different currencies are not equal', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 100.0, currency: 'USD');

        expect(price1, isNot(equals(price2)));
      });

      test('price equals itself', () {
        const price = Price(amount: 100.0, currency: 'NGN');

        expect(price, equals(price));
      });
    });

    group('Complex Scenarios', () {
      test('calculates total price for multiple items', () {
        const itemPrice = Price(amount: 50.0, currency: 'NGN');
        const quantity = 3.0;

        final total = itemPrice * quantity;

        expect(total.amount, 150.0);
        expect(total.currency, 'NGN');
      });

      test('calculates average price', () {
        const price1 = Price(amount: 100.0, currency: 'NGN');
        const price2 = Price(amount: 200.0, currency: 'NGN');
        const price3 = Price(amount: 150.0, currency: 'NGN');

        final total = price1 + price2 + price3;
        final average = total / 3;

        expect(average.amount, 150.0);
      });

      test('calculates discount', () {
        const originalPrice = Price(amount: 100.0, currency: 'NGN');
        const discountPercent = 0.20; // 20% discount

        final discountAmount = originalPrice * discountPercent;
        final finalPrice = originalPrice - discountAmount;

        expect(finalPrice.amount, 80.0);
      });

      test('calculates tax', () {
        const basePrice = Price(amount: 100.0, currency: 'NGN');
        const taxRate = 0.075; // 7.5% VAT

        final taxAmount = basePrice * taxRate;
        final totalPrice = basePrice + taxAmount;

        expect(totalPrice.amount, 107.5);
      });

      test('calculates unit price from total', () {
        const totalPrice = Price(amount: 150.0, currency: 'NGN');
        const quantity = 3.0;

        final unitPrice = totalPrice / quantity;

        expect(unitPrice.amount, 50.0);
      });
    });

    group('Edge Cases', () {
      test('handles very small amounts', () {
        const price = Price(amount: 0.01, currency: 'NGN');

        expect(price.format(), '₦0.01');
      });

      test('handles very large amounts', () {
        const price = Price(amount: 999999999.99, currency: 'NGN');

        expect(price.amount, 999999999.99);
      });

      test('handles currency code case insensitivity in formatting', () {
        const price1 = Price(amount: 100.0, currency: 'ngn');
        const price2 = Price(amount: 100.0, currency: 'NGN');

        expect(price1.format(), '₦100.00');
        expect(price2.format(), '₦100.00');
      });

      test('handles decimal precision in calculations', () {
        const price1 = Price(amount: 0.1, currency: 'NGN');
        const price2 = Price(amount: 0.2, currency: 'NGN');

        final result = price1 + price2;

        expect(result.amount, closeTo(0.3, 0.0001));
      });
    });
  });
}

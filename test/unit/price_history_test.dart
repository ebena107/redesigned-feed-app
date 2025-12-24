import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';

void main() {
  group('PriceHistory Model Tests', () {
    group('Constructor', () {
      test('creates price history with all fields', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 150.50,
          currency: 'NGN',
          effectiveDate: now,
          source: 'user',
          notes: 'Market update',
          createdAt: nowUnix,
        );

        expect(history.id, 1);
        expect(history.ingredientId, 5);
        expect(history.price, 150.50);
        expect(history.currency, 'NGN');
        expect(history.effectiveDate, now);
        expect(history.source, 'user');
        expect(history.notes, 'Market update');
        expect(history.createdAt, nowUnix);
      });

      test('creates price history with default currency', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        expect(history.currency, 'NGN');
      });

      test('creates price history with null notes', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        expect(history.notes, isNull);
      });
    });

    group('JSON Serialization', () {
      test('converts to JSON correctly', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 150.50,
          currency: 'USD',
          effectiveDate: now,
          source: 'api',
          notes: 'Test note',
          createdAt: nowUnix,
        );

        final json = history.toJson();

        expect(json['id'], 1);
        expect(json['ingredient_id'], 5);
        expect(json['price'], 150.50);
        expect(json['currency'], 'USD');
        expect(json['source'], 'api');
        expect(json['notes'], 'Test note');
      });

      test('creates from JSON correctly', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final json = {
          'id': 2,
          'ingredient_id': 10,
          'price': 200.75,
          'currency': 'EUR',
          'effective_date': now.millisecondsSinceEpoch,
          'source': 'system',
          'notes': 'System update',
          'created_at': nowUnix,
        };

        final history = PriceHistory.fromJson(json);

        expect(history.id, 2);
        expect(history.ingredientId, 10);
        expect(history.price, 200.75);
        expect(history.currency, 'EUR');
        expect(history.source, 'system');
        expect(history.notes, 'System update');
      });

      test('round-trip JSON conversion preserves data', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final original = PriceHistory(
          id: 3,
          ingredientId: 15,
          price: 300.25,
          currency: 'GBP',
          effectiveDate: now,
          source: 'user',
          notes: 'Manual entry',
          createdAt: nowUnix,
        );

        final json = original.toJson();
        final restored = PriceHistory.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.ingredientId, original.ingredientId);
        expect(restored.price, original.price);
        expect(restored.currency, original.currency);
        expect(restored.source, original.source);
        expect(restored.notes, original.notes);
      });
    });

    group('Comparisons', () {
      test('two price histories with same data are equal', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history1 = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        final history2 = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        expect(history1, equals(history2));
      });

      test('price histories with different prices are not equal', () {
        final now = DateTime.now();
        final nowUnix = now.millisecondsSinceEpoch ~/ 1000;
        final history1 = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        final history2 = PriceHistory(
          id: 1,
          ingredientId: 5,
          price: 150.0,
          currency: 'NGN',
          effectiveDate: now,
          createdAt: nowUnix,
        );

        expect(history1, isNot(equals(history2)));
      });
    });
  });
}

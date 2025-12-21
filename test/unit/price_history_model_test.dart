import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:flutter_test/flutter_test.dart';

final _baseDate = DateTime(2024, 1, 1, 12, 0, 0);
final _baseCreatedAt = _baseDate.millisecondsSinceEpoch;

void main() {
  group('PriceHistory Model Tests', () {
    group('Constructor and Properties', () {
      test('creates price history with all properties', () {
        final now = _baseDate;
        final nowMs = _baseCreatedAt;
        final record = PriceHistory(
          id: 1,
          ingredientId: 123,
          price: 100.50,
          currency: 'NGN',
          effectiveDate: now,
          source: 'User',
          notes: 'Market price',
          createdAt: nowMs,
        );

        expect(record.id, 1);
        expect(record.ingredientId, 123);
        expect(record.price, 100.50);
        expect(record.currency, 'NGN');
        expect(record.effectiveDate, now);
        expect(record.source, 'User');
        expect(record.notes, 'Market price');
        expect(record.createdAt, nowMs);
      });

      test('creates price history with minimal properties', () {
        final now = _baseDate;
        final nowMs = _baseCreatedAt;
        final record = PriceHistory(
          ingredientId: 456,
          price: 50.0,
          currency: 'USD',
          effectiveDate: now,
          createdAt: nowMs,
        );

        expect(record.id, isNull);
        expect(record.ingredientId, 456);
        expect(record.price, 50.0);
        expect(record.currency, 'USD');
        expect(record.effectiveDate, now);
        expect(record.source, isNull);
        expect(record.notes, isNull);
        expect(record.createdAt, nowMs);
      });
    });

    group('JSON Serialization', () {
      test('converts to JSON correctly', () {
        final now = _baseDate;
        final nowMs = _baseCreatedAt;
        final record = PriceHistory(
          id: 5,
          ingredientId: 789,
          price: 75.25,
          currency: 'EUR',
          effectiveDate: now,
          source: 'System',
          notes: 'Automated update',
          createdAt: nowMs,
        );

        final json = record.toJson();

        expect(json['id'], 5);
        expect(json['ingredient_id'], 789);
        expect(json['price'], 75.25);
        expect(json['currency'], 'EUR');
        expect(json['effective_date'], nowMs);
        expect(json['source'], 'System');
        expect(json['notes'], 'Automated update');
        expect(json['created_at'], nowMs);
      });

      test('creates from JSON correctly', () {
        final now = _baseDate.millisecondsSinceEpoch;
        final json = {
          'id': 10,
          'ingredient_id': 999,
          'price': 120.00,
          'currency': 'GBP',
          'effective_date': now,
          'source': 'Market',
          'notes': 'Bulk price',
          'created_at': now,
        };

        final record = PriceHistory.fromJson(json);

        expect(record.id, 10);
        expect(record.ingredientId, 999);
        expect(record.price, 120.00);
        expect(record.currency, 'GBP');
        expect(record.effectiveDate, DateTime.fromMillisecondsSinceEpoch(now));
        expect(record.source, 'Market');
        expect(record.notes, 'Bulk price');
        expect(record.createdAt, now);
      });

      test('round-trip JSON conversion preserves data', () {
        final now = _baseDate;
        final nowMs = _baseCreatedAt;
        final original = PriceHistory(
          id: 42,
          ingredientId: 555,
          price: 99.99,
          currency: 'INR',
          effectiveDate: now,
          source: 'User',
          notes: 'Test note',
          createdAt: nowMs,
        );

        final json = original.toJson();
        final restored = PriceHistory.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.ingredientId, original.ingredientId);
        expect(restored.price, original.price);
        expect(restored.currency, original.currency);
        expect(restored.effectiveDate, original.effectiveDate);
        expect(restored.source, original.source);
        expect(restored.notes, original.notes);
        expect(restored.createdAt, original.createdAt);
      });

      test('handles null optional fields in JSON', () {
        final json = {
          'ingredient_id': 100,
          'price': 50.0,
          'currency': 'NGN',
          'effective_date': _baseCreatedAt,
          'created_at': _baseCreatedAt,
        };

        final record = PriceHistory.fromJson(json);

        expect(record.id, isNull);
        expect(record.ingredientId, 100);
        expect(record.price, 50.0);
        expect(record.currency, 'NGN');
        expect(record.effectiveDate,
            DateTime.fromMillisecondsSinceEpoch(_baseCreatedAt));
        expect(record.source, isNull);
        expect(record.notes, isNull);
        expect(record.createdAt, _baseCreatedAt);
      });
    });

    group('copyWith Method', () {
      test('copies with updated price', () {
        final record = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final updated = record.copyWith(price: 150.0);

        expect(updated.ingredientId, record.ingredientId);
        expect(updated.price, 150.0);
        expect(updated.currency, record.currency);
      });

      test('copies with updated currency', () {
        final record = PriceHistory(
          ingredientId: 2,
          price: 50.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final updated = record.copyWith(currency: 'USD');

        expect(updated.currency, 'USD');
        expect(updated.price, record.price);
      });

      test('copies with updated source', () {
        final record = PriceHistory(
          ingredientId: 3,
          price: 75.0,
          currency: 'EUR',
          source: 'User',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final updated = record.copyWith(source: 'Market');

        expect(updated.source, 'Market');
        expect(updated.price, record.price);
      });

      test('copyWith without parameters returns identical copy', () {
        final record = PriceHistory(
          id: 1,
          ingredientId: 123,
          price: 100.50,
          currency: 'NGN',
          source: 'User',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final copy = record.copyWith();

        expect(copy.id, record.id);
        expect(copy.ingredientId, record.ingredientId);
        expect(copy.price, record.price);
        expect(copy.currency, record.currency);
        expect(copy.source, record.source);
      });
    });

    group('Equality', () {
      test('price records with same data are equal', () {
        final record1 = PriceHistory(
          id: 1,
          ingredientId: 123,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final record2 = PriceHistory(
          id: 1,
          ingredientId: 123,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record1, equals(record2));
      });

      test('price records with different IDs are not equal', () {
        final record1 = PriceHistory(
          id: 1,
          ingredientId: 123,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final record2 = PriceHistory(
          id: 2,
          ingredientId: 123,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record1, isNot(equals(record2)));
      });

      test('price records with different prices are not equal', () {
        final record1 = PriceHistory(
          ingredientId: 123,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final record2 = PriceHistory(
          ingredientId: 123,
          price: 150.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record1, isNot(equals(record2)));
      });
    });

    group('List Operations', () {
      test('empty list extension works', () {
        final list = <PriceHistory>[];
        final isEmpty = list.isEmpty;
        expect(isEmpty, true);
      });

      test('can create list of price histories', () {
        final records = [
          PriceHistory(
            ingredientId: 1,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 2,
            price: 50.0,
            currency: 'USD',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 3,
            price: 75.0,
            currency: 'EUR',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
        ];

        expect(records.length, 3);
        expect(records.first.ingredientId, 1);
        expect(records.last.ingredientId, 3);
      });

      test('filtering price records by ingredient', () {
        final records = [
          PriceHistory(
            id: 1,
            ingredientId: 100,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            id: 2,
            ingredientId: 100,
            price: 110.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            id: 3,
            ingredientId: 200,
            price: 50.0,
            currency: 'USD',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
        ];

        final filtered = records.where((r) => r.ingredientId == 100).toList();

        expect(filtered.length, 2);
        expect(filtered.every((r) => r.ingredientId == 100), true);
      });

      test('sorting price records by date', () {
        final now = DateTime.now().millisecondsSinceEpoch;
        final records = [
          PriceHistory(
            ingredientId: 1,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: DateTime.fromMillisecondsSinceEpoch(now - 100000),
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 1,
            price: 110.0,
            currency: 'NGN',
            effectiveDate: DateTime.fromMillisecondsSinceEpoch(now),
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 1,
            price: 90.0,
            currency: 'NGN',
            effectiveDate: DateTime.fromMillisecondsSinceEpoch(now - 50000),
            createdAt: _baseCreatedAt,
          ),
        ];

        final sorted = List<PriceHistory>.from(records)
          ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));

        expect(sorted.first.price, 110.0); // Most recent
        expect(sorted.last.price, 100.0); // Oldest
      });
    });

    group('Edge Cases', () {
      test('handles very small price values', () {
        final record = PriceHistory(
          ingredientId: 1,
          price: 0.01,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record.price, 0.01);
      });

      test('handles very large price values', () {
        final record = PriceHistory(
          ingredientId: 1,
          price: 999999.99,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record.price, 999999.99);
      });

      test('handles empty notes string', () {
        final record = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'NGN',
          notes: '',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        expect(record.notes, '');
      });

      test('handles very old timestamps', () {
        final oldTime = DateTime(2000, 1, 1).millisecondsSinceEpoch;
        final record = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: DateTime.fromMillisecondsSinceEpoch(oldTime),
          createdAt: _baseCreatedAt,
        );

        expect(
            record.effectiveDate, DateTime.fromMillisecondsSinceEpoch(oldTime));
      });

      test('handles future timestamps', () {
        final futureTime = DateTime(2050, 12, 31).millisecondsSinceEpoch;
        final record = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: DateTime.fromMillisecondsSinceEpoch(futureTime),
          createdAt: _baseCreatedAt,
        );

        expect(record.effectiveDate,
            DateTime.fromMillisecondsSinceEpoch(futureTime));
      });

      test('currency codes are case-insensitive in data', () {
        final record1 = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        final record2 = PriceHistory(
          ingredientId: 1,
          price: 100.0,
          currency: 'ngn',
          effectiveDate: _baseDate,
          createdAt: _baseCreatedAt,
        );

        // Both should be valid - no case conversion in model
        expect(record1.currency, 'NGN');
        expect(record2.currency, 'ngn');
      });
    });

    group('Real-World Scenarios', () {
      test('track price increase over time', () {
        final now = DateTime.now().millisecondsSinceEpoch;
        final records = [
          PriceHistory(
            id: 1,
            ingredientId: 100,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: DateTime.fromMillisecondsSinceEpoch(now - 86400000),
            source: 'User',
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            id: 2,
            ingredientId: 100,
            price: 110.0,
            currency: 'NGN',
            effectiveDate: DateTime.fromMillisecondsSinceEpoch(now),
            source: 'Market',
            createdAt: _baseCreatedAt,
          ),
        ];

        expect(records[1].price, greaterThan(records[0].price));
      });

      test('track multiple currencies for same ingredient', () {
        final records = [
          PriceHistory(
            ingredientId: 100,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 100,
            price: 0.25,
            currency: 'USD',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 100,
            price: 90.0,
            currency: 'EUR',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
        ];

        final ngn = records.where((r) => r.currency == 'NGN').toList();
        final usd = records.where((r) => r.currency == 'USD').toList();

        expect(ngn.length, 1);
        expect(usd.length, 1);
        expect(records.length, 3);
      });

      test('bulk price update scenario', () {
        final records = [
          PriceHistory(
            ingredientId: 1,
            price: 100.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 2,
            price: 50.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
          PriceHistory(
            ingredientId: 3,
            price: 75.0,
            currency: 'NGN',
            effectiveDate: _baseDate,
            createdAt: _baseCreatedAt,
          ),
        ];

        // Simulate price increase (20% inflation)
        final updated =
            records.map((r) => r.copyWith(price: r.price * 1.2)).toList();

        expect(updated[0].price, closeTo(120.0, 0.01));
        expect(updated[1].price, closeTo(60.0, 0.01));
        expect(updated[2].price, closeTo(90.0, 0.01));
      });
    });
  });
}

import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feed Model Tests', () {
    group('Constructor and Properties', () {
      test('creates feed with all properties', () {
        final feedIngredients = [
          FeedIngredients(
            id: 1,
            feedId: 1,
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 100.0,
          ),
        ];

        final feed = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
          feedIngredients: feedIngredients,
          timestampModified: 1638360000000,
        );

        expect(feed.feedId, 1);
        expect(feed.feedName, 'Test Feed');
        expect(feed.animalId, 1);
        expect(feed.feedIngredients?.length, 1);
        expect(feed.timestampModified, 1638360000000);
      });

      test('creates feed with minimal properties', () {
        final feed = Feed();

        expect(feed.feedId, isNull);
        expect(feed.feedName, isNull);
        expect(feed.animalId, isNull);
        expect(feed.feedIngredients, isNull);
        expect(feed.timestampModified, isNull);
      });

      test('creates feed with empty ingredients list', () {
        final feed = Feed(
          feedId: 1,
          feedName: 'Empty Feed',
          animalId: 2,
          feedIngredients: [],
        );

        expect(feed.feedIngredients, isEmpty);
      });
    });

    group('JSON Serialization', () {
      test('converts to JSON correctly', () {
        final feedIngredients = [
          FeedIngredients(
            id: 1,
            feedId: 1,
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 100.0,
          ),
          FeedIngredients(
            id: 2,
            feedId: 1,
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 150.0,
          ),
        ];

        final feed = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
          feedIngredients: feedIngredients,
          timestampModified: 1638360000000,
        );

        final json = feed.toJson();

        expect(json['feed_id'], 1);
        expect(json['feed_name'], 'Test Feed');
        expect(json['animal_id'], 1);
        expect(json['feedIngredients'], isA<List>());
        expect(json['feedIngredients'].length, 2);
        expect(json['timestamp_modified'], 1638360000000);
      });

      test('converts from JSON correctly', () {
        final json = {
          'feed_id': 1,
          'feed_name': 'Test Feed',
          'animal_id': 1,
          'feedIngredients': [
            {
              'id': 1,
              'feed_id': 1,
              'ingredient_id': 1,
              'quantity': 50.0,
              'price_unit_kg': 100.0,
            },
          ],
          'timestamp_modified': 1638360000000,
        };

        final feed = Feed.fromJson(json);

        expect(feed.feedId, 1);
        expect(feed.feedName, 'Test Feed');
        expect(feed.animalId, 1);
        expect(feed.feedIngredients?.length, 1);
        expect(feed.feedIngredients?[0].ingredientId, 1);
        expect(feed.timestampModified, 1638360000000);
      });

      test('handles null feedIngredients in JSON', () {
        final json = {
          'feed_id': 1,
          'feed_name': 'Test Feed',
          'animal_id': 1,
          'timestamp_modified': 1638360000000,
        };

        final feed = Feed.fromJson(json);

        expect(feed.feedId, 1);
        expect(feed.feedName, 'Test Feed');
        expect(feed.feedIngredients, isNull);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = Feed(
          feedId: 5,
          feedName: 'Round Trip Feed',
          animalId: 2,
          feedIngredients: [
            FeedIngredients(
              id: 1,
              feedId: 5,
              ingredientId: 10,
              quantity: 75.0,
              priceUnitKg: 200.0,
            ),
          ],
          timestampModified: 1638360000000,
        );

        final json = original.toJson();
        final restored = Feed.fromJson(json);

        expect(restored.feedId, original.feedId);
        expect(restored.feedName, original.feedName);
        expect(restored.animalId, original.animalId);
        expect(
            restored.feedIngredients?.length, original.feedIngredients?.length);
        expect(restored.timestampModified, original.timestampModified);
      });
    });

    group('copyWith Method', () {
      test('copies with updated feed name', () {
        final original = Feed(
          feedId: 1,
          feedName: 'Original Name',
          animalId: 1,
        );

        final updated = original.copyWith(feedName: 'Updated Name');

        expect(updated.feedId, 1);
        expect(updated.feedName, 'Updated Name');
        expect(updated.animalId, 1);
      });

      test('copies with updated animal ID', () {
        final original = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
        );

        final updated = original.copyWith(animalId: 2);

        expect(updated.feedId, 1);
        expect(updated.feedName, 'Test Feed');
        expect(updated.animalId, 2);
      });

      test('copies with updated ingredients', () {
        final original = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          feedIngredients: [],
        );

        final newIngredients = [
          FeedIngredients(
            id: 1,
            feedId: 1,
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 100.0,
          ),
        ];

        final updated = original.copyWith(feedIngredients: newIngredients);

        expect(updated.feedIngredients?.length, 1);
        expect(updated.feedIngredients?[0].quantity, 50.0);
      });

      test('copyWith without parameters returns identical copy', () {
        final original = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
        );

        final copy = original.copyWith();

        expect(copy.feedId, original.feedId);
        expect(copy.feedName, original.feedName);
        expect(copy.animalId, original.animalId);
      });
    });

    group('Helper Functions', () {
      test('feedFromJson parses JSON string', () {
        const jsonString = '''
        {
          "feed_id": 1,
          "feed_name": "Test Feed",
          "animal_id": 1,
          "feedIngredients": [],
          "timestamp_modified": 1638360000000
        }
        ''';

        final feed = feedFromJson(jsonString);

        expect(feed.feedId, 1);
        expect(feed.feedName, 'Test Feed');
        expect(feed.animalId, 1);
      });

      test('feedToJson converts to JSON string', () {
        final feed = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
          feedIngredients: [],
        );

        final jsonString = feedToJson(feed);

        expect(jsonString, contains('"feed_id":1'));
        expect(jsonString, contains('"feed_name":"Test Feed"'));
        expect(jsonString, contains('"animal_id":1'));
      });
    });
  });

  group('FeedIngredients Model Tests', () {
    group('Constructor and Properties', () {
      test('creates feed ingredient with all properties', () {
        final feedIngredient = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        expect(feedIngredient.id, 1);
        expect(feedIngredient.feedId, 1);
        expect(feedIngredient.ingredientId, 10);
        expect(feedIngredient.quantity, 50.0);
        expect(feedIngredient.priceUnitKg, 100.0);
      });

      test('creates feed ingredient with minimal properties', () {
        final feedIngredient = FeedIngredients();

        expect(feedIngredient.id, isNull);
        expect(feedIngredient.feedId, isNull);
        expect(feedIngredient.ingredientId, isNull);
        expect(feedIngredient.quantity, isNull);
        expect(feedIngredient.priceUnitKg, isNull);
      });
    });

    group('JSON Serialization', () {
      test('converts to JSON correctly', () {
        final feedIngredient = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final json = feedIngredient.toJson();

        expect(json['id'], 1);
        expect(json['feed_id'], 1);
        expect(json['ingredient_id'], 10);
        expect(json['quantity'], 50.0);
        expect(json['price_unit_kg'], 100.0);
      });

      test('converts from JSON correctly', () {
        final json = {
          'id': 1,
          'feed_id': 1,
          'ingredient_id': 10,
          'quantity': 50.0,
          'price_unit_kg': 100.0,
        };

        final feedIngredient = FeedIngredients.fromJson(json);

        expect(feedIngredient.id, 1);
        expect(feedIngredient.feedId, 1);
        expect(feedIngredient.ingredientId, 10);
        expect(feedIngredient.quantity, 50.0);
        expect(feedIngredient.priceUnitKg, 100.0);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = FeedIngredients(
          id: 5,
          feedId: 10,
          ingredientId: 20,
          quantity: 75.5,
          priceUnitKg: 250.0,
        );

        final json = original.toJson();
        final restored = FeedIngredients.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.feedId, original.feedId);
        expect(restored.ingredientId, original.ingredientId);
        expect(restored.quantity, original.quantity);
        expect(restored.priceUnitKg, original.priceUnitKg);
      });
    });

    group('copyWith Method', () {
      test('copies with updated quantity', () {
        final original = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final updated = original.copyWith(quantity: 75.0);

        expect(updated.id, 1);
        expect(updated.feedId, 1);
        expect(updated.ingredientId, 10);
        expect(updated.quantity, 75.0);
        expect(updated.priceUnitKg, 100.0);
      });

      test('copies with updated price', () {
        final original = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final updated = original.copyWith(priceUnitKg: 150.0);

        expect(updated.quantity, 50.0);
        expect(updated.priceUnitKg, 150.0);
      });

      test('copies with multiple updated properties', () {
        final original = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final updated = original.copyWith(
          quantity: 80.0,
          priceUnitKg: 200.0,
        );

        expect(updated.quantity, 80.0);
        expect(updated.priceUnitKg, 200.0);
        expect(updated.id, 1);
        expect(updated.feedId, 1);
        expect(updated.ingredientId, 10);
      });

      test('copyWith without parameters returns identical copy', () {
        final original = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.feedId, original.feedId);
        expect(copy.ingredientId, original.ingredientId);
        expect(copy.quantity, original.quantity);
        expect(copy.priceUnitKg, original.priceUnitKg);
      });
    });

    group('Helper Functions', () {
      test('feedIngredientsFromJson parses JSON string', () {
        const jsonString = '''
        {
          "id": 1,
          "feed_id": 1,
          "ingredient_id": 10,
          "quantity": 50.0,
          "price_unit_kg": 100.0
        }
        ''';

        final feedIngredient = feedIngredientsFromJson(jsonString);

        expect(feedIngredient.id, 1);
        expect(feedIngredient.feedId, 1);
        expect(feedIngredient.ingredientId, 10);
        expect(feedIngredient.quantity, 50.0);
        expect(feedIngredient.priceUnitKg, 100.0);
      });

      test('feedIngredientsToJson converts to JSON string', () {
        final feedIngredient = FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: 10,
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final jsonString = feedIngredientsToJson(feedIngredient);

        expect(jsonString, contains('"id":1'));
        expect(jsonString, contains('"feed_id":1'));
        expect(jsonString, contains('"ingredient_id":10'));
        expect(jsonString, contains('"quantity":50.0'));
        expect(jsonString, contains('"price_unit_kg":100.0'));
      });
    });

    group('Calculations', () {
      test('calculates total cost for ingredient', () {
        final feedIngredient = FeedIngredients(
          quantity: 50.0,
          priceUnitKg: 100.0,
        );

        final totalCost =
            (feedIngredient.quantity ?? 0) * (feedIngredient.priceUnitKg ?? 0);

        expect(totalCost, 5000.0);
      });

      test('handles null values in calculations', () {
        final feedIngredient = FeedIngredients(
          quantity: 50.0,
        );

        final totalCost =
            (feedIngredient.quantity ?? 0) * (feedIngredient.priceUnitKg ?? 0);

        expect(totalCost, 0.0);
      });
    });
  });

  group('Feed Integration Tests', () {
    test('creates complete feed with multiple ingredients', () {
      final feed = Feed(
        feedId: 1,
        feedName: 'Pig Grower Feed',
        animalId: 1,
        feedIngredients: [
          FeedIngredients(
            id: 1,
            feedId: 1,
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 450.0,
          ),
          FeedIngredients(
            id: 2,
            feedId: 1,
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 300.0,
          ),
          FeedIngredients(
            id: 3,
            feedId: 1,
            ingredientId: 3,
            quantity: 20.0,
            priceUnitKg: 200.0,
          ),
        ],
        timestampModified: DateTime.now().millisecondsSinceEpoch,
      );

      expect(feed.feedIngredients?.length, 3);

      final totalQuantity = feed.feedIngredients?.fold<double>(
        0.0,
        (sum, ingredient) => sum + (ingredient.quantity ?? 0),
      );

      expect(totalQuantity, 100.0);
    });

    test('calculates total feed cost', () {
      final feed = Feed(
        feedId: 1,
        feedName: 'Test Feed',
        feedIngredients: [
          FeedIngredients(quantity: 50.0, priceUnitKg: 100.0),
          FeedIngredients(quantity: 30.0, priceUnitKg: 150.0),
        ],
      );

      final totalCost = feed.feedIngredients?.fold<double>(
        0.0,
        (sum, ingredient) =>
            sum + ((ingredient.quantity ?? 0) * (ingredient.priceUnitKg ?? 0)),
      );

      expect(totalCost, 9500.0); // (50 * 100) + (30 * 150)
    });

    test('updates feed with new ingredients', () {
      final original = Feed(
        feedId: 1,
        feedName: 'Original Feed',
        feedIngredients: [
          FeedIngredients(id: 1, ingredientId: 1, quantity: 50.0),
        ],
      );

      final updated = original.copyWith(
        feedIngredients: [
          FeedIngredients(id: 1, ingredientId: 1, quantity: 50.0),
          FeedIngredients(id: 2, ingredientId: 2, quantity: 30.0),
        ],
      );

      expect(original.feedIngredients?.length, 1);
      expect(updated.feedIngredients?.length, 2);
    });
  });
}

import 'package:feed_estimator/src/core/database/data_validator.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feed Creation Integration Tests', () {
    test('creates complete feed with validated ingredients', () {
      // Step 1: Create ingredients
      final soybeanMeal = Ingredient(
        ingredientId: 1,
        name: 'Soybean Meal',
        crudeProtein: 44.0,
        crudeFiber: 7.0,
        crudeFat: 1.0,
        calcium: 2.7,
        phosphorus: 6.5,
        lysine: 27.0,
        methionine: 6.0,
        meGrowingPig: 3230.0,
        priceKg: 450.0,
        availableQty: 1000.0,
      );

      final corn = Ingredient(
        ingredientId: 2,
        name: 'Corn, Yellow',
        crudeProtein: 8.5,
        crudeFiber: 2.2,
        crudeFat: 3.9,
        calcium: 0.3,
        phosphorus: 2.8,
        lysine: 2.5,
        methionine: 1.8,
        meGrowingPig: 3420.0,
        priceKg: 300.0,
        availableQty: 2000.0,
      );

      // Step 2: Validate ingredients
      final soybeanValidation = NutritionalDataValidator.validate(soybeanMeal);
      final cornValidation = NutritionalDataValidator.validate(corn);

      expect(soybeanValidation.isValid, true);
      expect(cornValidation.isValid, true);

      // Step 3: Create feed ingredients
      final feedIngredients = [
        FeedIngredients(
          id: 1,
          feedId: 1,
          ingredientId: soybeanMeal.ingredientId,
          quantity: 30.0,
          priceUnitKg: soybeanMeal.priceKg,
        ),
        FeedIngredients(
          id: 2,
          feedId: 1,
          ingredientId: corn.ingredientId,
          quantity: 60.0,
          priceUnitKg: corn.priceKg,
        ),
      ];

      // Step 4: Create feed
      final feed = Feed(
        feedId: 1,
        feedName: 'Pig Grower Feed',
        animalId: 1,
        feedIngredients: feedIngredients,
        timestampModified: DateTime.now().millisecondsSinceEpoch,
      );

      // Step 5: Verify feed properties
      expect(feed.feedId, 1);
      expect(feed.feedName, 'Pig Grower Feed');
      expect(feed.animalId, 1);
      expect(feed.feedIngredients?.length, 2);

      // Step 6: Calculate total quantity
      final totalQuantity = feed.feedIngredients?.fold<double>(
        0.0,
        (sum, ingredient) => sum + (ingredient.quantity ?? 0),
      );
      expect(totalQuantity, 90.0);

      // Step 7: Calculate total cost
      final totalCost = feed.feedIngredients?.fold<double>(
        0.0,
        (sum, ingredient) =>
            sum + ((ingredient.quantity ?? 0) * (ingredient.priceUnitKg ?? 0)),
      );
      expect(totalCost, 31500.0); // (30 * 450) + (60 * 300)
    });

    test('validates and rejects invalid ingredient in feed', () {
      // Create invalid ingredient (negative protein)
      final invalidIngredient = Ingredient(
        ingredientId: 1,
        name: 'Invalid Ingredient',
        crudeProtein: -10.0,
        crudeFiber: 5.0,
        crudeFat: 2.0,
      );

      // Validate ingredient
      final validation = NutritionalDataValidator.validate(invalidIngredient);

      expect(validation.isValid, false);
      expect(validation.errors, contains('Protein cannot be negative'));

      // Should not create feed with invalid ingredient
      expect(validation.isValid, false);
    });

    test('updates feed with new ingredients', () {
      // Create initial feed
      final initialFeed = Feed(
        feedId: 1,
        feedName: 'Initial Feed',
        animalId: 1,
        feedIngredients: [
          FeedIngredients(
            id: 1,
            feedId: 1,
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 100.0,
          ),
        ],
      );

      expect(initialFeed.feedIngredients?.length, 1);

      // Update feed with additional ingredient
      final updatedFeed = initialFeed.copyWith(
        feedIngredients: [
          ...initialFeed.feedIngredients!,
          FeedIngredients(
            id: 2,
            feedId: 1,
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 150.0,
          ),
        ],
      );

      expect(updatedFeed.feedIngredients?.length, 2);
      expect(initialFeed.feedIngredients?.length, 1); // Original unchanged
    });

    test('calculates nutritional composition of feed', () {
      // Create feed with 50% of each ingredient
      final feedIngredients = [
        FeedIngredients(
          ingredientId: 1,
          quantity: 50.0,
          priceUnitKg: 100.0,
        ),
        FeedIngredients(
          ingredientId: 2,
          quantity: 50.0,
          priceUnitKg: 80.0,
        ),
      ];

      final totalQuantity = feedIngredients.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );

      // Calculate weighted average protein
      // (40 * 50 + 10 * 50) / 100 = 25%
      final avgProtein = (40.0 * 50.0 + 10.0 * 50.0) / totalQuantity;
      expect(avgProtein, 25.0);

      // Calculate weighted average fat
      // (2 * 50 + 15 * 50) / 100 = 8.5%
      final avgFat = (2.0 * 50.0 + 15.0 * 50.0) / totalQuantity;
      expect(avgFat, 8.5);
    });
  });

  group('Ingredient Management Integration Tests', () {
    test('creates, validates, and serializes custom ingredient', () {
      // Step 1: Create custom ingredient
      final customIngredient = Ingredient(
        ingredientId: 100,
        name: 'My Custom Mix',
        crudeProtein: 25.0,
        crudeFiber: 8.0,
        crudeFat: 5.0,
        calcium: 3.0,
        phosphorus: 2.5,
        priceKg: 500.0,
        availableQty: 100.0,
        isCustom: 1,
        createdBy: 'farmer123',
        createdDate: DateTime.now().millisecondsSinceEpoch,
        notes: 'Special blend for my farm',
      );

      // Step 2: Validate ingredient
      final validation = NutritionalDataValidator.validate(customIngredient);
      expect(validation.isValid, true);
      expect(validation.errors, isEmpty);

      // Step 3: Serialize to JSON
      final json = customIngredient.toJson();
      expect(json['ingredient_id'], 100);
      expect(json['name'], 'My Custom Mix');
      expect(json['is_custom'], 1);

      // Step 4: Deserialize from JSON
      final restored = Ingredient.fromJson(json);
      expect(restored.ingredientId, customIngredient.ingredientId);
      expect(restored.name, customIngredient.name);
      expect(restored.crudeProtein, customIngredient.crudeProtein);
      expect(restored.isCustom, customIngredient.isCustom);

      // Step 5: Update ingredient
      final updated = restored.copyWith(
        priceKg: 550.0,
        availableQty: 150.0,
      );
      expect(updated.priceKg, 550.0);
      expect(updated.availableQty, 150.0);
      expect(updated.name, customIngredient.name); // Unchanged
    });

    test('batch validates multiple ingredients', () {
      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Valid Ingredient 1',
          crudeProtein: 20.0,
          crudeFiber: 10.0,
          crudeFat: 5.0,
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Invalid Ingredient',
          crudeProtein: -5.0, // Invalid
        ),
        Ingredient(
          ingredientId: 3,
          name: 'Valid Ingredient 2',
          crudeProtein: 15.0,
          crudeFiber: 8.0,
          crudeFat: 3.0,
        ),
        Ingredient(
          ingredientId: 4,
          name: 'Rice Bran',
          crudeProtein: 12.0,
          crudeFiber: 0.0, // Invalid for bran
        ),
      ];

      final results = NutritionalDataValidator.validateBatch(ingredients);

      expect(results.length, 4);
      expect(results[1]!.isValid, true);
      expect(results[2]!.isValid, false);
      expect(results[3]!.isValid, true);
      expect(results[4]!.isValid, false);

      // Get all invalid ingredients
      final invalidIds = results.entries
          .where((entry) => !entry.value.isValid)
          .map((entry) => entry.key)
          .toList();

      expect(invalidIds, containsAll([2, 4]));
    });
  });

  group('Data Consistency Integration Tests', () {
    test('maintains data consistency through JSON round-trip', () {
      // Create complete feed with ingredients
      final originalFeed = Feed(
        feedId: 1,
        feedName: 'Test Feed',
        animalId: 1,
        feedIngredients: [
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
        ],
        timestampModified: 1638360000000,
      );

      // Convert to JSON
      final json = originalFeed.toJson();

      // Convert back to Feed
      final restoredFeed = Feed.fromJson(json);

      // Verify all properties match
      expect(restoredFeed.feedId, originalFeed.feedId);
      expect(restoredFeed.feedName, originalFeed.feedName);
      expect(restoredFeed.animalId, originalFeed.animalId);
      expect(
        restoredFeed.feedIngredients?.length,
        originalFeed.feedIngredients?.length,
      );
      expect(restoredFeed.timestampModified, originalFeed.timestampModified);

      // Verify ingredients match
      for (int i = 0; i < originalFeed.feedIngredients!.length; i++) {
        final original = originalFeed.feedIngredients![i];
        final restored = restoredFeed.feedIngredients![i];

        expect(restored.id, original.id);
        expect(restored.feedId, original.feedId);
        expect(restored.ingredientId, original.ingredientId);
        expect(restored.quantity, original.quantity);
        expect(restored.priceUnitKg, original.priceUnitKg);
      }
    });

    test('handles ingredient list serialization', () {
      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Ingredient 1',
          crudeProtein: 20.0,
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Ingredient 2',
          crudeProtein: 15.0,
        ),
        Ingredient(
          ingredientId: 3,
          name: 'Ingredient 3',
          crudeProtein: 25.0,
        ),
      ];

      // Convert to JSON string
      final jsonString = ingredientListToJson(ingredients);

      // Convert back to list
      final restored = ingredientListFromJson(jsonString);

      expect(restored.length, ingredients.length);
      for (int i = 0; i < ingredients.length; i++) {
        expect(restored[i].ingredientId, ingredients[i].ingredientId);
        expect(restored[i].name, ingredients[i].name);
        expect(restored[i].crudeProtein, ingredients[i].crudeProtein);
      }
    });
  });

  group('Business Logic Integration Tests', () {
    test('calculates feed cost breakdown', () {
      final feedIngredients = [
        FeedIngredients(
          ingredientId: 1,
          quantity: 40.0,
          priceUnitKg: 450.0,
        ),
        FeedIngredients(
          ingredientId: 2,
          quantity: 50.0,
          priceUnitKg: 300.0,
        ),
        FeedIngredients(
          ingredientId: 3,
          quantity: 10.0,
          priceUnitKg: 800.0,
        ),
      ];

      final totalQuantity = feedIngredients.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );
      expect(totalQuantity, 100.0);

      final totalCost = feedIngredients.fold<double>(
        0.0,
        (sum, fi) => sum + ((fi.quantity ?? 0) * (fi.priceUnitKg ?? 0)),
      );
      expect(totalCost, 41000.0); // (40*450) + (50*300) + (10*800)

      final costPerKg = totalCost / totalQuantity;
      expect(costPerKg, 410.0);

      // Calculate percentage of each ingredient
      final percentages = feedIngredients.map((fi) {
        return (fi.quantity ?? 0) / totalQuantity * 100;
      }).toList();

      expect(percentages[0], 40.0);
      expect(percentages[1], 50.0);
      expect(percentages[2], 10.0);
    });

    test('validates feed formulation constraints', () {
      // Create feed ingredients that sum to 100%
      final feedIngredients = [
        FeedIngredients(quantity: 30.0),
        FeedIngredients(quantity: 50.0),
        FeedIngredients(quantity: 20.0),
      ];

      final totalQuantity = feedIngredients.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );

      expect(totalQuantity, 100.0);

      // Verify each ingredient is within acceptable range (e.g., 0-100%)
      for (final fi in feedIngredients) {
        final percentage = (fi.quantity ?? 0) / totalQuantity * 100;
        expect(percentage, greaterThanOrEqualTo(0.0));
        expect(percentage, lessThanOrEqualTo(100.0));
      }
    });

    test('handles ingredient substitution in feed', () {
      // Original feed
      final originalFeed = Feed(
        feedId: 1,
        feedName: 'Original Feed',
        feedIngredients: [
          FeedIngredients(id: 1, ingredientId: 1, quantity: 50.0),
          FeedIngredients(id: 2, ingredientId: 2, quantity: 30.0),
          FeedIngredients(id: 3, ingredientId: 3, quantity: 20.0),
        ],
      );

      // Substitute ingredient 2 with ingredient 4
      final updatedIngredients = originalFeed.feedIngredients!.map((fi) {
        if (fi.ingredientId == 2) {
          return fi.copyWith(ingredientId: 4);
        }
        return fi;
      }).toList();

      final updatedFeed = originalFeed.copyWith(
        feedIngredients: updatedIngredients,
      );

      // Verify substitution
      expect(
        updatedFeed.feedIngredients!.any((fi) => fi.ingredientId == 2),
        false,
      );
      expect(
        updatedFeed.feedIngredients!.any((fi) => fi.ingredientId == 4),
        true,
      );

      // Verify quantities remain the same
      final originalTotal = originalFeed.feedIngredients!.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );
      final updatedTotal = updatedFeed.feedIngredients!.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );

      expect(updatedTotal, originalTotal);
    });
  });

  group('Error Handling Integration Tests', () {
    test('handles missing ingredient data gracefully', () {
      final ingredient = Ingredient(
        ingredientId: 1,
        name: 'Minimal Ingredient',
        // No nutritional data
      );

      final validation = NutritionalDataValidator.validate(ingredient);

      // Should pass validation (null values are acceptable)
      expect(validation.isValid, true);
    });

    test('handles empty feed ingredients list', () {
      final feed = Feed(
        feedId: 1,
        feedName: 'Empty Feed',
        animalId: 1,
        feedIngredients: [],
      );

      expect(feed.feedIngredients, isEmpty);

      final totalQuantity = feed.feedIngredients?.fold<double>(
        0.0,
        (sum, fi) => sum + (fi.quantity ?? 0),
      );

      expect(totalQuantity, 0.0);
    });

    test('handles null feed ingredients list', () {
      final feed = Feed(
        feedId: 1,
        feedName: 'Null Ingredients Feed',
        animalId: 1,
      );

      expect(feed.feedIngredients, isNull);
    });
  });
}

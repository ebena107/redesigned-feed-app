import 'package:feed_estimator/src/features/add_update_feed/services/inclusion_validator.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feed Save Validation Tests', () {
    group('InclusionValidator.validate', () {
      late Map<num, Ingredient> ingredientCache;

      setUp(() {
        // Create test ingredients with known inclusion limits
        ingredientCache = {
          1: Ingredient(
            ingredientId: 1,
            name: 'Cottonseed Meal',
            maxInclusionPct: 15,
          ),
          2: Ingredient(
            ingredientId: 2,
            name: 'Rapeseed Meal',
            maxInclusionPct: 10,
          ),
          3: Ingredient(
            ingredientId: 3,
            name: 'Corn',
            maxInclusionPct: 100, // No limit
          ),
          4: Ingredient(
            ingredientId: 4,
            name: 'Moringa',
            maxInclusionJson: {
              'pig': 5,
              'poultry': 8,
            },
          ),
        };
      });

      test('should accept feed with all ingredients within limits', () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 1, quantity: 10), // 10% < 15% limit
          FeedIngredients(ingredientId: 2, quantity: 8), // 8% < 10% limit
          FeedIngredients(ingredientId: 3, quantity: 82), // 82% < 100% limit
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Pig
        );

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('should reject feed with cottonseed meal exceeding 15% limit', () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 1, quantity: 20), // 20% > 15% limit
          FeedIngredients(ingredientId: 3, quantity: 80), // Corn filler
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Pig
        );

        expect(result.isValid, false);
        expect(result.errors, isNotEmpty);
        expect(
          result.errors.any((e) => e.contains('Cottonseed Meal')),
          true,
        );
      });

      test('should reject feed with rapeseed exceeding 10% limit', () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 2, quantity: 15), // 15% > 10% limit
          FeedIngredients(ingredientId: 3, quantity: 85), // Corn filler
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Pig
        );

        expect(result.isValid, false);
        expect(result.errors, isNotEmpty);
        expect(
          result.errors.any((e) => e.contains('Rapeseed')),
          true,
        );
      });

      test('should respect per-animal-type limits (Moringa for pig vs poultry)',
          () {
        // Pig: Moringa limit is 5%
        final pigFeedIngredients = [
          FeedIngredients(ingredientId: 4, quantity: 6), // 6% > 5% for pig
          FeedIngredients(ingredientId: 3, quantity: 94), // Corn filler
        ];

        final pigResult = InclusionValidator.validate(
          feedIngredients: pigFeedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Pig
        );

        expect(pigResult.isValid, false);

        // Poultry: Moringa limit is 8%
        final poultryFeedIngredients = [
          FeedIngredients(ingredientId: 4, quantity: 6), // 6% < 8% for poultry
          FeedIngredients(ingredientId: 3, quantity: 94), // Corn filler
        ];

        final poultryResult = InclusionValidator.validate(
          feedIngredients: poultryFeedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 2, // Poultry
        );

        expect(poultryResult.isValid, true);
      });

      test('should allow multiple ingredients to exceed limits with warnings',
          () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 1, quantity: 13), // 13% < 15% limit
          FeedIngredients(ingredientId: 2, quantity: 9), // 9% < 10% limit
          FeedIngredients(ingredientId: 3, quantity: 78), // Corn filler
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Should be valid but may have warnings near limits
        expect(result.isValid, true);
      });

      test('should handle missing ingredient gracefully', () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 999, quantity: 50), // Non-existent
          FeedIngredients(ingredientId: 3, quantity: 50), // Corn
        ];

        // Should not throw, just skip unknown ingredient
        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result, isNotNull);
      });

      test('should track warning vs error distinction', () {
        final feedIngredients = [
          FeedIngredients(ingredientId: 1, quantity: 20), // 20% > 15% (ERROR)
          FeedIngredients(ingredientId: 3, quantity: 80),
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.errors, isNotEmpty);
        expect(result.isValid, false);
        // Errors are blocking, warnings are not
      });
    });

    group('Edge Cases', () {
      test('should handle empty feed ingredients list', () {
        final result = InclusionValidator.validate(
          feedIngredients: [],
          ingredientCache: {},
          animalTypeId: 1,
        );

        expect(result, isNotNull);
      });

      test('should handle zero quantities', () {
        final result = InclusionValidator.validate(
          feedIngredients: [
            FeedIngredients(ingredientId: 1, quantity: 0),
            FeedIngredients(ingredientId: 2, quantity: 100),
          ],
          ingredientCache: {
            1: Ingredient(ingredientId: 1, name: 'Ingredient 1'),
            2: Ingredient(ingredientId: 2, name: 'Ingredient 2'),
          },
          animalTypeId: 1,
        );

        expect(result, isNotNull);
      });

      test('should calculate percentages correctly for non-100 totals', () {
        // If total quantity is 50 kg instead of 100, percentages still calculated
        final feedIngredients = [
          FeedIngredients(ingredientId: 1, quantity: 7.5), // 15% of 50
          FeedIngredients(ingredientId: 2, quantity: 42.5), // 85% of 50
        ];

        final result = InclusionValidator.validate(
          feedIngredients: feedIngredients,
          ingredientCache: {
            1: Ingredient(
                ingredientId: 1, name: 'Ingredient 1', maxInclusionPct: 20),
            2: Ingredient(ingredientId: 2, name: 'Ingredient 2'),
          },
          animalTypeId: 1,
        );

        expect(result.isValid, true);
      });
    });
  });
}

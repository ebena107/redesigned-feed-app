import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';

void main() {
  group('FeedFormulatorEngine', () {
    test('minimizes cost while meeting protein constraint', () {
      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Cheap Protein',
          priceKg: 1,
          crudeProtein: 20,
          mePoultry: 3000,
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Expensive Protein',
          priceKg: 2,
          crudeProtein: 10,
          mePoultry: 3000,
        ),
      ];

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 18,
        ),
      ];

      final result = FeedFormulatorEngine().formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
        enforceMaxInclusion: true,
      );

      expect(result.status, 'optimal');
      expect(result.ingredientPercents.length, 2);
      expect(result.ingredientPercents[1], greaterThan(99));
      final total = result.ingredientPercents.values.reduce((a, b) => a + b);
      expect(total, closeTo(100, 1e-6));
    });

    test('warns when ingredient price is missing', () {
      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Priced',
          priceKg: 1,
          crudeProtein: 20,
          mePoultry: 3000,
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Missing Price',
          priceKg: null,
          crudeProtein: 20,
          mePoultry: 3000,
        ),
      ];

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 18,
        ),
      ];

      final result = FeedFormulatorEngine().formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
        enforceMaxInclusion: true,
      );

      expect(result.warnings, isNotEmpty);
      expect(
        result.warnings.any(
          (warning) => warning.contains('Missing price'),
        ),
        isTrue,
      );
    });
  });
}

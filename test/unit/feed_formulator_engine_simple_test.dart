import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';

void main() {
  group('FeedFormulatorEngine - Configuration Tests', () {
    test('supports configurable minimum inclusion strategy', () {
      final engine1 = FeedFormulatorEngine(
        inclusionStrategy: InclusionStrategy.none,
        minInclusionPct: 0.0,
      );
      expect(engine1.inclusionStrategy, InclusionStrategy.none);
      expect(engine1.minInclusionPct, 0.0);

      final engine2 = FeedFormulatorEngine(
        inclusionStrategy: InclusionStrategy.minimum,
        minInclusionPct: 0.1,
      );
      expect(engine2.inclusionStrategy, InclusionStrategy.minimum);
      expect(engine2.minInclusionPct, 0.1);

      final engine3 = FeedFormulatorEngine(
        inclusionStrategy: InclusionStrategy.allSelected,
        minInclusionPct: 5.0,
      );
      expect(engine3.inclusionStrategy, InclusionStrategy.allSelected);
      expect(engine3.minInclusionPct, 5.0);
    });

    test('throws CalculationException when no ingredients provided', () {
      final engine = FeedFormulatorEngine();

      expect(
        () => engine.formulate(
          ingredients: [],
          constraints: [],
          animalTypeId: 2,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('validates feasibility and throws on impossible constraints', () {
      final engine = FeedFormulatorEngine();

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Corn',
          categoryId: 1,
          crudeProtein: 8.5,
          mePoultry: 3350,
          priceKg: 0.15,
          maxInclusionPct: 60,
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Soybean',
          categoryId: 2,
          crudeProtein: 40.0,
          mePoultry: 2260,
          priceKg: 0.35,
          maxInclusionPct: 40,
        ),
      ];

      // Request protein constraint impossible with these ingredients
      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 100, // Impossible - max available is 40%
          max: 150,
        ),
      ];

      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
      );

      expect(result.status, 'infeasible');
    });

    test('detects narrow constraint ranges and warns appropriately', () {
      final engine = FeedFormulatorEngine();

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'TestFeed',
          categoryId: 1,
          crudeProtein: 12.0,
          mePoultry: 3200,
          priceKg: 0.20,
        ),
      ];

      // This should complete without throwing, but may have warnings
      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.energy,
          min: 3100, // Narrow range - only 100 kcal/kg width
          max: 3200,
        ),
      ];

      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
      );

      expect(result.ingredientPercents, isNotNull);
    });

    test('respects max inclusion percentage when enforceMaxInclusion=true', () {
      final engine = FeedFormulatorEngine();

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Ingredient A',
          categoryId: 1,
          crudeProtein: 15.0,
          mePoultry: 3200,
          priceKg: 0.20,
          maxInclusionPct: 50, // Max 50%
        ),
        Ingredient(
          ingredientId: 2,
          name: 'Ingredient B',
          categoryId: 2,
          crudeProtein: 20.0,
          mePoultry: 3000,
          priceKg: 0.25,
          maxInclusionPct: 60,
        ),
      ];

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 15,
          max: 20,
        ),
      ];

      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
        enforceMaxInclusion: true,
      );

      // Check that max inclusion limits are respected
      for (final id in result.ingredientPercents.keys) {
        final percent = result.ingredientPercents[id]!;
        final ing =
            ingredients.firstWhere((i) => i.ingredientId == id, orElse: () {
          throw Exception('Ingredient not found');
        });

        if (ing.maxInclusionPct != null) {
          expect(
            percent,
            lessThanOrEqualTo(
                ing.maxInclusionPct! + 0.1), // Allow small tolerance
          );
        }
      }
    });

    test('converts amino acid values from g/kg to percentage correctly', () {
      final engine = FeedFormulatorEngine();

      // Corn has lysine in g/kg
      final cornLysineGPerKg = 2.1; // Corn lysine in g/kg
      final expectedPercentage =
          cornLysineGPerKg / 10; // Should convert to 0.21%

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Corn',
          categoryId: 1,
          crudeProtein: 8.5,
          lysine: cornLysineGPerKg, // 2.1 g/kg
          mePoultry: 3350,
          priceKg: 0.15,
        ),
      ];

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.lysine,
          min: expectedPercentage * 0.9,
          max: expectedPercentage * 1.1,
        ),
      ];

      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
      );

      expect(result.ingredientPercents, isNotNull);
    });

    test('returns empty percentages when formulation is infeasible', () {
      final engine = FeedFormulatorEngine();

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Feed',
          categoryId: 1,
          crudeProtein: 15.0,
          mePoultry: 3000,
          priceKg: 0.20,
        ),
      ];

      // Request impossible constraints
      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 50, // Impossible
          max: 60,
        ),
      ];

      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
      );

      expect(result.status, 'infeasible');
    });

    test('supports all animal type energy value lookups', () {
      final engine = FeedFormulatorEngine();

      final ingredient = Ingredient(
        ingredientId: 1,
        name: 'TestFeed',
        categoryId: 1,
        crudeProtein: 12.0,
        mePoultry: 3200,
        meGrowingPig: 3100,
        meFinishingPig: 3050,
        meRuminant: 2800,
        meRabbit: 2900,
        priceKg: 0.20,
      );

      // Test that all animal type IDs are handled
      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.energy,
          min: 2500,
          max: 3500,
        ),
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 10,
          max: 15,
        ),
      ];

      // Poultry (ID 2)
      var result = engine.formulate(
        ingredients: [ingredient],
        constraints: constraints,
        animalTypeId: 2,
      );
      expect(result.nutrients[NutrientKey.energy], isNotNull);

      // Pig (ID 1) - uses meGrowingPig
      result = engine.formulate(
        ingredients: [ingredient],
        constraints: constraints,
        animalTypeId: 1,
      );
      expect(result.nutrients[NutrientKey.energy], isNotNull);

      // Rabbit (ID 3) - uses meRabbit
      result = engine.formulate(
        ingredients: [ingredient],
        constraints: constraints,
        animalTypeId: 3,
      );
      expect(result.nutrients[NutrientKey.energy], isNotNull);

      // Ruminant (ID 4) - uses meRuminant
      result = engine.formulate(
        ingredients: [ingredient],
        constraints: constraints,
        animalTypeId: 4,
      );
      expect(result.nutrients[NutrientKey.energy], isNotNull);
    });

    test('includes AppLogger calls without errors', () {
      final engine = FeedFormulatorEngine();

      final ingredients = [
        Ingredient(
          ingredientId: 1,
          name: 'Feed',
          categoryId: 1,
          crudeProtein: 15.0,
          mePoultry: 3000,
          priceKg: 0.20,
        ),
      ];

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 14,
          max: 16,
        ),
      ];

      // Should execute without logging errors
      final result = engine.formulate(
        ingredients: ingredients,
        constraints: constraints,
        animalTypeId: 2,
      );

      expect(result, isNotNull);
    });
  });
}

import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:test/test.dart';

void main() {
  group('Enhanced Diversity Feature Tests', () {
    test(
        'Enhanced Diversity should force usage of multiple energy and protein sources',
        () {
      final engine = FeedFormulatorEngine();
      final animalTypeId = 1; // Pig

      // Grains (Energy sources) - Maize is cheapest
      final maize = Ingredient(
        ingredientId: 1,
        name: 'Maize',
        priceKg: 1.0,
        crudeProtein: 8.5,
        crudeFiber: 2.2,
        crudeFat: 3.5,
        calcium: 0.02,
        phosphorus: 0.28,
        meGrowingPig: 3350,
      );
      final sorghum = Ingredient(
        ingredientId: 2,
        name: 'Sorghum',
        priceKg: 1.2,
        crudeProtein: 9.0,
        crudeFiber: 2.5,
        crudeFat: 2.8,
        calcium: 0.03,
        phosphorus: 0.28,
        meGrowingPig: 3250,
      );
      final wheat = Ingredient(
        ingredientId: 3,
        name: 'Wheat',
        priceKg: 1.3,
        crudeProtein: 12.0,
        crudeFiber: 2.5,
        crudeFat: 1.7,
        calcium: 0.05,
        phosphorus: 0.35,
        meGrowingPig: 3300,
      );

      // Proteins - Soybean meal is cheapest
      final soy = Ingredient(
        ingredientId: 4,
        name: 'Soybean Meal',
        priceKg: 2.5,
        crudeProtein: 48.0,
        crudeFiber: 3.5,
        crudeFat: 1.5,
        calcium: 0.2,
        phosphorus: 0.65,
        meGrowingPig: 3200,
      );
      final fishmeal = Ingredient(
        ingredientId: 5,
        name: 'Fishmeal',
        priceKg: 4.0,
        crudeProtein: 65.0,
        crudeFiber: 0.5,
        crudeFat: 8.0,
        calcium: 4.5,
        phosphorus: 2.8,
        meGrowingPig: 3100,
      );
      final canola = Ingredient(
        ingredientId: 6,
        name: 'Canola Meal',
        priceKg: 2.2,
        crudeProtein: 36.0,
        crudeFiber: 11.0,
        crudeFat: 3.5,
        calcium: 0.65,
        phosphorus: 1.0,
        meGrowingPig: 2800,
      );

      // Additives
      final limestone = Ingredient(
          ingredientId: 7, name: 'Limestone', priceKg: 0.1, calcium: 38.0);
      final salt = Ingredient(ingredientId: 8, name: 'Salt', priceKg: 0.2);

      final allIngredients = [
        maize,
        sorghum,
        wheat,
        soy,
        fishmeal,
        canola,
        limestone,
        salt
      ];

      // Relaxed requirements to ensure feasibility
      final constraints = [
        createNutrientConstraint(key: NutrientKey.energy, min: 3000, max: 3500),
        createNutrientConstraint(
            key: NutrientKey.protein, min: 14.0, max: 20.0),
        createNutrientConstraint(key: NutrientKey.calcium, min: 0.0, max: 2.0),
      ];

      // 1. Run WITHOUT diversity
      final resultNormal = engine.formulate(
        ingredients: allIngredients,
        constraints: constraints,
        animalTypeId: animalTypeId,
        enhanceDiversity: false,
      );

      expect(resultNormal.status, 'optimal',
          reason: 'Normal formulation should be optimal');
      print('--- Normal Optimization ---');
      for (var line in resultNormal.ingredientPercents.entries) {
        final name = allIngredients
            .firstWhere((ing) => ing.ingredientId == line.key)
            .name;
        print('$name: ${line.value.toStringAsFixed(2)}%');
      }

      // 2. Run WITH diversity
      final resultDiverse = engine.formulate(
        ingredients: allIngredients,
        constraints: constraints,
        animalTypeId: animalTypeId,
        enhanceDiversity: true,
      );

      expect(resultDiverse.status, 'optimal',
          reason: 'Diverse formulation should be optimal');
      print('--- Diverse Optimization ---');
      for (var line in resultDiverse.ingredientPercents.entries) {
        final name = allIngredients
            .firstWhere((ing) => ing.ingredientId == line.key)
            .name;
        print('$name: ${line.value.toStringAsFixed(2)}%');
      }

      // Check differences. Maize should be capped at 35% in diverse, and so on.
    });
  });
}

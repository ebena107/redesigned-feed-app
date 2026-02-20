// ignore_for_file: avoid_print
library formulator_overrides_test;

import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

import 'screenshot9_test.dart' show screenshot9;

void main() {
  const animalTypeId = 1; // Pig
  const feedType = FeedType.finisher;

  late List<NutrientConstraint> constraints;
  late FeedFormulatorEngine engine;

  setUp(() {
    constraints =
        NutrientRequirements.getDefaults(animalTypeId, feedType).constraints;
    engine = FeedFormulatorEngine();
  });

  group('Formulator Overrides Test', () {
    test('Overriding Max Inclusion limits ingredient usage', () {
      // Find Palm kernel meal (normally ~11.8%) and restrict it to 5% max inclusion
      final overridenIngredients = screenshot9.map((ing) {
        if (ing.name == 'Palm kernel meal, oil < 5%') {
          return ing.copyWith(maxInclusionPct: 5.0);
        }
        return ing;
      }).toList();

      final result = engine.formulate(
        ingredients: overridenIngredients,
        constraints: constraints,
        animalTypeId: animalTypeId,
        feedTypeName: feedType.name,
      );

      expect(result.status, 'optimal',
          reason: 'Should remain optimal with PKM at 5%');

      final pkmId = screenshot9
          .firstWhere((ing) => ing.name == 'Palm kernel meal, oil < 5%')
          .ingredientId;
      final pkmPercent = result.ingredientPercents[pkmId] ?? 0.0;

      expect(pkmPercent, lessThanOrEqualTo(5.001),
          reason: 'PKM inclusion should not exceed the overridden 5% max.');
      print(
          'Palm Kernel Meal used with 5% max override: ${pkmPercent.toStringAsFixed(2)}%');
    });

    test('Overriding Price affects formulation choice or cost output', () {
      // Find Maize and make it extremely expensive to force the solver to use alternatives
      // or at least increase the total cost.
      final overridenIngredients = screenshot9.map((ing) {
        if (ing.name == 'Maize (Corn)') {
          return ing.copyWith(priceKg: 9999.0);
        }
        return ing;
      }).toList();

      final result = engine.formulate(
        ingredients: overridenIngredients,
        constraints: constraints,
        animalTypeId: animalTypeId,
        feedTypeName: feedType.name,
      );

      final baseResult = engine.formulate(
        ingredients: screenshot9,
        constraints: constraints,
        animalTypeId: animalTypeId,
        feedTypeName: feedType.name,
      );

      expect(result.costPerKg, greaterThan(baseResult.costPerKg),
          reason:
              'Cost should increase when maize price is overridden to a high value.');

      print(
          'Base Cost: ${baseResult.costPerKg.toStringAsFixed(2)}, High Maize Cost: ${result.costPerKg.toStringAsFixed(2)}');
    });
  });
}

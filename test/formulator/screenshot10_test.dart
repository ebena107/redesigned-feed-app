// ignore_for_file: avoid_print

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

Ingredient _ing({
  required int id,
  required String name,
  required double cp,
  required double lys,
  required double met,
  required double ca,
  required double p,
  required double energy,
  required double price,
  double? maxInclusionPct,
}) =>
    Ingredient(
      ingredientId: id,
      name: name,
      crudeProtein: cp,
      lysine: lys,
      methionine: met,
      calcium: ca,
      totalPhosphorus: p,
      deSalmonids: energy, // Digetsible energy for fish (animal types 8 & 9)
      priceKg: price,
      maxInclusionPct: maxInclusionPct,
    );

final fishIngredients = <Ingredient>[
  _ing(
      id: 1,
      name: 'Maize',
      cp: 8.5,
      lys: 2.5,
      met: 1.8,
      ca: 0.3,
      p: 2.7,
      energy: 2500,
      price: 180,
      maxInclusionPct: 60.0),
  _ing(
      id: 2,
      name: 'Groundnut cake',
      cp: 45.0,
      lys: 15.0,
      met: 5.0,
      ca: 1.0,
      p: 6.0,
      energy: 2600,
      price: 300,
      maxInclusionPct: 50.0),
  _ing(
      id: 3,
      name: 'Fish meal',
      cp: 65.0,
      lys: 48.0,
      met: 18.0,
      ca: 48.0,
      p: 28.0,
      energy: 3100,
      price: 1500,
      maxInclusionPct: 40.0),
  _ing(
      id: 4,
      name: 'Blood meal',
      cp: 85.0,
      lys: 75.0,
      met: 10.0,
      ca: 3.0,
      p: 2.0,
      energy: 3200,
      price: 800,
      maxInclusionPct: 5.0), // Typically capped for palatability
  _ing(
      id: 5,
      name: 'Bone meal', // Replaced Oyster Shell
      cp: 4.0,
      lys: 0.0,
      met: 0.0,
      ca: 300.0,
      p: 150.0,
      energy: 0,
      price: 150,
      maxInclusionPct: 5.0),
  _ing(
      id: 6,
      name: 'Palm oil',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 0.0,
      p: 0.0,
      energy: 8000,
      price: 1200,
      maxInclusionPct: 5.0),
  _ing(
      id: 7,
      name: 'Vitamin',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 0.0,
      p: 0.0,
      energy: 0,
      price: 1000,
      maxInclusionPct: 2.0),
  _ing(
      id: 8,
      name: 'Salt',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 0.0,
      p: 0.0,
      energy: 0,
      price: 60,
      maxInclusionPct: 0.5),
];

void main() {
  const animalTypeId =
      9; // Catfish (common in combination with these ingredients)
  const feedType = FeedType.grower;

  late List<NutrientConstraint> constraints;
  late FeedFormulatorEngine engine;

  setUp(() {
    constraints =
        NutrientRequirements.getDefaults(animalTypeId, feedType).constraints;
    engine = FeedFormulatorEngine();
  });

  group('Fish Formulation Test (Catfish Grower)', () {
    test('engine formulates feed with Bone Meal instead of Oyster Shell', () {
      print('\\n--- CONSTRAINTS ---');
      for (final c in constraints) {
        print('${c.key.name}: min=${c.min}, max=${c.max}');
      }

      final result = engine.formulate(
        ingredients: fishIngredients,
        constraints: constraints,
        animalTypeId: animalTypeId,
        feedTypeName: feedType.name,
      );

      final nameMap = {
        for (final ing in fishIngredients) ing.ingredientId!: ing.name!
      };
      void log(String s) => print(s);

      log('\n╔═════════════════════════════════════════════════════════╗');
      log('  FISH FORMULATION (Catfish Grower)');
      log('  Using Bone Meal instead of Oyster Shell');
      log('╠═════════════════════════════════════════════════════════╣');
      log('  Status  : ${result.status.toUpperCase()}');
      log('  Cost    : ₦${result.costPerKg.toStringAsFixed(2)} / kg');
      log('──────────────────────────────────────────────────────────');
      log('  INGREDIENT BREAKDOWN');

      final sorted = result.ingredientPercents.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final e in sorted) {
        final name = nameMap[e.key] ?? e.key.toString();
        final pct = e.value.toStringAsFixed(2).padLeft(6);
        log('  $pct %   $name');
      }

      final total = result.ingredientPercents.values.fold(0.0, (a, b) => a + b);
      log('  ─────────────────────────────────────────────────────');
      log('  ${total.toStringAsFixed(2).padLeft(6)} %   TOTAL');

      log('──────────────────────────────────────────────────────────');
      log('  NUTRIENT ANALYSIS');

      const labels = {
        NutrientKey.energy: 'Energy (DE)  kcal/kg',
        NutrientKey.protein: 'Crude Protein      %',
        NutrientKey.lysine: 'Lysine             %',
        NutrientKey.methionine: 'Methionine         %',
        NutrientKey.calcium: 'Calcium            %',
        NutrientKey.phosphorus: 'Phosphorus         %',
      };

      for (final e in result.nutrients.entries) {
        final label = labels[e.key] ?? e.key.name;
        final c = constraints.firstWhere((x) => x.key == e.key,
            orElse: () => createNutrientConstraint(key: e.key));
        final minStr = (c.min ?? 0).toStringAsFixed(2);
        final maxStr = (c.max ?? 0).toStringAsFixed(2);
        final actual = e.value.toStringAsFixed(2).padLeft(8);
        log('  $label  $actual   [target: $minStr – $maxStr]');
      }

      if (result.limitingNutrients.isNotEmpty) {
        log('──────────────────────────────────────────────────────────');
        log('  LIMITING NUTRIENTS: ${result.limitingNutrients.map((n) => n.name).join(', ')}');
      }

      if (result.warnings.isNotEmpty) {
        log('──────────────────────────────────────────────────────────');
        log('  WARNINGS');
        for (final w in result.warnings) {
          log('  ⚠  $w');
        }
      }

      log('╚═════════════════════════════════════════════════════════╝\n');

      expect(result.status, 'optimal',
          reason: 'Should formulate optimal fish feed');
    });
  });
}
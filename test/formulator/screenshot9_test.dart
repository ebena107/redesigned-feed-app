// ignore_for_file: avoid_print
library screenshot9_test;

/// Formulation test using the 8 ingredients from the app screenshot with
/// updated prices and targeted for Pig Finisher (60-125kg).
///
/// Ingredients & Prices:
///   1. Fish meal, 62% protein (₦534)
///   2. Maize (Corn) (₦438)
///   3. Soybean meal, 48% CP (₦485)
///   4. Palm kernel meal, oil < 5% (₦295)
///   5. Wheat bran (₦285)
///   6. Vitamin-Mineral Premix (Layer Spec) (₦2552)
///   7. Limestone (ground) (₦150)
///   8. Salt (Sodium chloride) (₦160)

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

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
      mePoultry: energy,
      meGrowingPig: energy, // Pig energy
      priceKg: price,
      maxInclusionPct: maxInclusionPct,
    );

/// Mock ingredients corresponding to the screenshot provided.
final screenshot9 = <Ingredient>[
  // 1. Fish meal, 62% protein
  _ing(
      id: 11,
      name: 'Fish meal, 62% protein',
      cp: 62.0,
      lys: 48.0,
      met: 18.0,
      ca: 48.0,
      p: 28.0,
      energy: 3480, // me_pig value
      price: 534,
      maxInclusionPct: 10.0),

  // 2. Maize (Corn)
  _ing(
      id: 3,
      name: 'Maize (Corn)',
      cp: 8.5,
      lys: 2.5,
      met: 1.8,
      ca: 0.3,
      p: 2.7,
      energy: 3381,
      price: 438,
      maxInclusionPct: 65.0),

  // 3. Soybean meal, 48% CP, solvent extracted
  _ing(
      id: 6,
      name: 'Soybean meal, 48% CP, solvent extracted',
      cp: 47.5,
      lys: 29.2,
      met: 6.6,
      ca: 3.2,
      p: 6.5,
      energy: 3006,
      price: 485,
      maxInclusionPct: 35.0),

  // 4. Palm kernel meal, oil < 5%
  _ing(
      id: 4,
      name: 'Palm kernel meal, oil < 5%',
      cp: 16.0,
      lys: 6.2,
      met: 3.6,
      ca: 2.5,
      p: 6.0,
      energy: 2100,
      price: 295,
      maxInclusionPct: 20.0),

  // 5. Wheat bran
  _ing(
      id: 8,
      name: 'Wheat bran',
      cp: 15.5,
      lys: 5.8,
      met: 2.7,
      ca: 1.2,
      p: 9.5,
      energy: 2770,
      price: 285,
      maxInclusionPct: 25.0),

  // 6. Vitamin-Mineral Premix (Layer Spec)
  // Even though it's layer spec, we'll try to formulate Pig Finisher with it
  _ing(
      id: 7,
      name: 'Vitamin-Mineral Premix (Layer Spec)',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 0.0,
      p: 0.0,
      energy: 0,
      price: 2552,
      maxInclusionPct: 3.0),

  // 7. Limestone (ground)
  _ing(
      id: 2,
      name: 'Limestone (ground)',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 380.0, // 38%
      p: 0.2,
      energy: 0,
      price: 150,
      maxInclusionPct: 15.0),

  // 8. Salt (Sodium chloride)
  _ing(
      id: 5,
      name: 'Salt (Sodium chloride)',
      cp: 0.0,
      lys: 0.0,
      met: 0.0,
      ca: 0.0,
      p: 0.0,
      energy: 0,
      price: 160,
      maxInclusionPct: 0.5),
];

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  const animalTypeId = 1; // Pig
  const feedType = FeedType.finisher; // Pig Finisher (60-125kg)

  late List<NutrientConstraint> constraints;
  late FeedFormulatorEngine engine;

  setUp(() {
    constraints =
        NutrientRequirements.getDefaults(animalTypeId, feedType).constraints;
    engine = FeedFormulatorEngine();
  });

  group('Screenshot Ingredients — Pig Finisher Formulation', () {
    test(
        'FULL REPORT — 8 Screenshot Ingredients with updated prices (printed to console)',
        () {
      final result = engine.formulate(
        ingredients: screenshot9,
        constraints: constraints,
        animalTypeId: animalTypeId,
        feedTypeName: feedType.name,
      );

      final nameMap = {
        for (final ing in screenshot9) ing.ingredientId!: ing.name!
      };
      void log(String s) => print(s);

      log('\n╔═════════════════════════════════════════════════════════╗');
      log('  8-INGREDIENT FORMULATION  (Updated Prices)');
      log('  Pig Finisher               ·   NRC 2012');
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
        NutrientKey.energy: 'Energy (ME)  kcal/kg',
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
        log('  LIMITING NUTRIENTS');
        log('  ${result.limitingNutrients.map((n) => n.name).join(', ')}');
      }

      if (result.warnings.isNotEmpty) {
        log('──────────────────────────────────────────────────────────');
        log('  WARNINGS & SUGGESTIONS');
        for (final w in result.warnings) {
          log('  $w');
        }
      }

      log('╚═════════════════════════════════════════════════════════╝\n');

      // Expected to be optimal, and should log the output regardless
      expect(result.status, 'optimal',
          reason: 'Should form a valid diet or log warnings');
    });
  });
}

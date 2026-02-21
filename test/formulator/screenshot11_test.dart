// ignore_for_file: avoid_print
library screenshot11_test;

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
  double lys = 0,
  double met = 0,
  double ca = 0,
  double p = 0,
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
      deSalmonids: energy,
      priceKg: price,
      maxInclusionPct: maxInclusionPct,
    );

final allIngredients = <Ingredient>[
  _ing(
      id: 1,
      name: 'Rice Bran',
      cp: 12.0,
      energy: 2400,
      price: 100,
      maxInclusionPct: 20),
  _ing(
      id: 2,
      name: 'Millet Offal',
      cp: 14.0,
      energy: 2500,
      price: 110,
      maxInclusionPct: 20),
  _ing(
      id: 3,
      name: 'Wheat Offal',
      cp: 16.0,
      energy: 2600,
      price: 120,
      maxInclusionPct: 20),
  _ing(
      id: 4,
      name: 'BDG',
      cp: 20.0,
      energy: 2200,
      price: 90,
      maxInclusionPct: 20),
  _ing(
      id: 5,
      name: 'Yeast',
      cp: 45.0,
      energy: 3000,
      price: 400,
      maxInclusionPct: 20),
  _ing(
      id: 6,
      name: 'Fish Meal',
      cp: 65.0,
      lys: 48,
      met: 18,
      ca: 48,
      p: 28,
      energy: 3600,
      price: 1500,
      maxInclusionPct: 40),
  _ing(
      id: 7,
      name: 'Soybean Meal',
      cp: 48.0,
      lys: 29,
      met: 6.6,
      ca: 3,
      p: 6.5,
      energy: 3000,
      price: 500,
      maxInclusionPct: 40),
  _ing(
      id: 8,
      name: 'Maize',
      cp: 9.0,
      energy: 3400,
      price: 200,
      maxInclusionPct: 20),
  _ing(
      id: 9,
      name: 'Lysine',
      cp: 94.0,
      lys: 940,
      energy: 4000,
      price: 2000,
      maxInclusionPct: 2),
  _ing(
      id: 10,
      name: 'Methionine',
      cp: 58.0,
      met: 990,
      energy: 4000,
      price: 2500,
      maxInclusionPct: 2),
  _ing(
      id: 11,
      name: 'Vit. Premix',
      cp: 0.0,
      energy: 0,
      price: 3000,
      maxInclusionPct: 1),
  _ing(
      id: 12,
      name: 'Bone meal',
      cp: 4.0,
      ca: 300,
      p: 150,
      energy: 0,
      price: 150,
      maxInclusionPct: 5),
  _ing(
      id: 13,
      name: 'Vegetable Oil',
      cp: 0.0,
      energy: 8800,
      price: 1200,
      maxInclusionPct: 6),
  _ing(
      id: 14,
      name: 'Salt',
      cp: 0.0,
      energy: 0,
      price: 50,
      maxInclusionPct: 0.5),
];

// Helper to assemble diets from the full list
List<Ingredient> _buildDiet(List<String> carbSources, bool useYeast) {
  final base = [
    'Fish Meal',
    'Soybean Meal',
    'Maize',
    'Lysine',
    'Methionine',
    'Vit. Premix',
    'Bone meal',
    'Vegetable Oil',
    'Salt'
  ];
  if (useYeast) base.add('Yeast');

  final desiredNames = [...base, ...carbSources];
  return allIngredients.where((i) => desiredNames.contains(i.name)).toList();
}

void main() {
  const animalTypeId = 9; // Catfish
  const feedType = FeedType.grower; // 40% target

  late List<NutrientConstraint> originalConstraints;
  late List<NutrientConstraint> customConstraints;
  late FeedFormulatorEngine engine;

  setUp(() {
    originalConstraints =
        NutrientRequirements.getDefaults(animalTypeId, feedType).constraints;

    // Customize constraints to match the paper's 40% CP and ~2900-3000 kcal/kg ME target
    // We remove the default Catfish maximal bounds for Amino Acids/Phosphorus as these
    // experimental diets include 1% pure Lysine/Methionine and 30%+ Fish Meal which blows
    // past standard maximal commercial tolerances (resulting in 2.5%+ Lysine).
    customConstraints = [
      createNutrientConstraint(key: NutrientKey.protein, min: 39.0, max: 42.0),
      createNutrientConstraint(key: NutrientKey.energy, min: 2800, max: 3100),
      createNutrientConstraint(key: NutrientKey.calcium, min: 1.0, max: 3.5),
      createNutrientConstraint(key: NutrientKey.phosphorus, min: 0.5, max: 2.5),
      createNutrientConstraint(key: NutrientKey.lysine, min: 1.0, max: 5.0),
      createNutrientConstraint(key: NutrientKey.methionine, min: 0.5, max: 5.0),
    ];

    engine = FeedFormulatorEngine();
  });

  group('Experimental Fish Diets (Table 2 & 3)', () {
    final diets = [
      {
        'name': 'Diet 1 (RB)',
        'carbs': ['Rice Bran'],
        'yeast': false
      },
      {
        'name': 'Diet 2 (RB+Y)',
        'carbs': ['Rice Bran'],
        'yeast': true
      },
      {
        'name': 'Diet 3 (MO)',
        'carbs': ['Millet Offal'],
        'yeast': false
      },
      {
        'name': 'Diet 4 (MO+Y)',
        'carbs': ['Millet Offal'],
        'yeast': true
      },
      {
        'name': 'Diet 5 (WO)',
        'carbs': ['Wheat Offal'],
        'yeast': false
      },
      {
        'name': 'Diet 6 (WO+Y)',
        'carbs': ['Wheat Offal'],
        'yeast': true
      },
      {
        'name': 'Diet 7 (BDG)',
        'carbs': ['BDG'],
        'yeast': false
      },
      {
        'name': 'Diet 8 (BDG+Y)',
        'carbs': ['BDG'],
        'yeast': true
      },
    ];

    for (final d in diets) {
      test('Formulates ${d['name']} optimally at ~40% CP', () {
        final ings = _buildDiet(d['carbs'] as List<String>, d['yeast'] as bool);

        final result = engine.formulate(
          ingredients: ings,
          constraints: customConstraints,
          animalTypeId: animalTypeId,
          feedTypeName: feedType.name,
        );

        if (result.status != 'optimal') {
          print('FAILED ${d['name']}');
          for (final w in result.warnings) {
            print('  ⚠ $w');
          }
        }

        expect(result.status, 'optimal',
            reason: '${d['name']} must be feasible');

        // Ensure CP is roughly around 40%
        final cp = result.nutrients[NutrientKey.protein] ?? 0.0;
        final energy = result.nutrients[NutrientKey.energy] ?? 0.0;
        expect(cp, greaterThanOrEqualTo(39.4));

        final nameMap = {for (final ing in ings) ing.ingredientId!: ing.name!};
        void log(String s) => print(s);

        log('\n╔═════════════════════════════════════════════════════════╗');
        log('  FORMULATION: ${d['name']}');
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

        final total =
            result.ingredientPercents.values.fold(0.0, (a, b) => a + b);
        log('  ─────────────────────────────────────────────────────');
        log('  ${total.toStringAsFixed(2).padLeft(6)} %   TOTAL');

        log('──────────────────────────────────────────────────────────');
        log('  NUTRIENT ANALYSIS');
        log('  Crude Protein: ${cp.toStringAsFixed(2)}%');
        log('  Energy (DE):   ${energy.toStringAsFixed(0)} kcal/kg');
        log('╚═════════════════════════════════════════════════════════╝\n');
      });
    }
  });
}

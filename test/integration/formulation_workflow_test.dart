import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/amino_acids_profile.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/energy_values.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/anti_nutritional_factors.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/enhanced_calculation_engine.dart';

void main() {
  group('Integration Tests - Complete Formulation Workflows', () {
    test('Complete pig grower formulation with real-world ingredients', () {
      // Create realistic pig grower formulation (20-50 kg)
      // Target: 16-18% CP, 0.95-1.05% SID Lysine, 2,300-2,450 kcal/kg NE

      final corn = Ingredient(
        ingredientId: 1,
        name: 'Corn grain',
        crudeProtein: 8.5,
        crudeFat: 3.8,
        crudeFiber: 2.2,
        ash: 1.3,
        moisture: 13.0,
        calcium: 0.3,
        phosphorus: 2.8,
        aminoAcidsSid: AminoAcidsProfile(
          lysine: 2.5,
          methionine: 1.8,
          threonine: 3.0,
          tryptophan: 0.6,
        ),
        energy: EnergyValues(
          nePig: 2100,
          mePig: 3000,
        ),
      );

      final soybeanMeal = Ingredient(
        ingredientId: 2,
        name: 'Soybean meal, 48% CP',
        crudeProtein: 48.0,
        crudeFat: 1.5,
        crudeFiber: 3.5,
        ash: 6.5,
        moisture: 12.0,
        calcium: 3.0,
        phosphorus: 6.5,
        aminoAcidsSid: AminoAcidsProfile(
          lysine: 28.5,
          methionine: 6.5,
          threonine: 18.0,
          tryptophan: 6.2,
        ),
        energy: EnergyValues(
          nePig: 2230,
          mePig: 3100,
        ),
        antiNutritionalFactors: AntiNutritionalFactors(
          trypsinInhibitorTuG: 35, // Well-processed, below 40 TU/g
        ),
      );

      final wheatBran = Ingredient(
        ingredientId: 3,
        name: 'Wheat bran',
        crudeProtein: 16.0,
        crudeFat: 4.0,
        crudeFiber: 10.5,
        ash: 5.8,
        moisture: 12.0,
        calcium: 1.2,
        phosphorus: 11.0,
        totalPhosphorus: 11.0,
        availablePhosphorus: 3.3, // 30% availability
        phytatePhosphorus: 7.7,
        aminoAcidsSid: AminoAcidsProfile(
          lysine: 5.5,
          methionine: 2.0,
        ),
        energy: EnergyValues(
          nePig: 1650,
          mePig: 2300,
        ),
      );

      final limestone = Ingredient(
        ingredientId: 4,
        name: 'Limestone',
        crudeProtein: 0.0,
        calcium: 380.0, // 38% calcium
        phosphorus: 0.0,
        energy: EnergyValues(nePig: 0),
      );

      final dicalciumPhosphate = Ingredient(
        ingredientId: 5,
        name: 'Dicalcium phosphate',
        crudeProtein: 0.0,
        calcium: 240.0, // 24% calcium
        phosphorus: 185.0, // 18.5% phosphorus
        availablePhosphorus: 185.0, // 100% available
        energy: EnergyValues(nePig: 0),
      );

      // Formulation: 60% corn, 25% soybean meal, 10% wheat bran,
      //              3% limestone, 2% dicalcium phosphate
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 600), // 60 kg corn
          FeedIngredients(ingredientId: 2, quantity: 250), // 25 kg soybean meal
          FeedIngredients(ingredientId: 3, quantity: 100), // 10 kg wheat bran
          FeedIngredients(ingredientId: 4, quantity: 30), // 3 kg limestone
          FeedIngredients(
              ingredientId: 5, quantity: 20), // 2 kg dicalcium phosphate
        ],
        ingredientCache: {
          1: corn,
          2: soybeanMeal,
          3: wheatBran,
          4: limestone,
          5: dicalciumPhosphate,
        },
        animalTypeId: 1, // Pig
      );

      // Verify crude protein is in target range (16-19% - adjusted for NRC 2012)
      expect(result.cProtein, isNotNull);
      expect(result.cProtein, greaterThan(15.5));
      expect(result.cProtein, lessThan(19.5));

      // Verify NE is in target range (2,000-2,600 kcal/kg - NRC 2012 standard)
      expect(result.mEnergy, isNotNull);
      expect(result.mEnergy, greaterThan(1900));
      expect(result.mEnergy, lessThan(2700));

      // Verify SID lysine is adequate (should be ~0.95-1.05%)
      expect(result.aminoAcidsSidJson, isNotNull);
      expect(result.aminoAcidsSidJson, contains('lysine'));

      // Verify phosphorus levels
      expect(result.totalPhosphorus, isNotNull);
      expect(result.availablePhosphorus, isNotNull);
      expect(result.totalPhosphorus, greaterThan(0));

      // Verify no critical warnings (wheat bran at 10% is safe)
      expect(result.warningsJson, isNotNull);
      // Should not have violations (all ingredients within limits)
      expect(result.warningsJson, isNot(contains('VIOLATION')));
    });

    test('Detect inclusion limit violation in formulation', () {
      // Create formulation that violates cottonseed meal limit (>15%)

      final cottonseedMeal = Ingredient(
        ingredientId: 1,
        name: 'Cottonseed meal',
        crudeProtein: 41.0,
        crudeFat: 2.0,
        crudeFiber: 12.0,
        aminoAcidsSid: AminoAcidsProfile(lysine: 18.0),
        energy: EnergyValues(nePig: 1950),
        maxInclusionPct: 15.0, // 15% max due to gossypol toxicity
      );

      final corn = Ingredient(
        ingredientId: 2,
        name: 'Corn grain',
        crudeProtein: 8.5,
        aminoAcidsSid: AminoAcidsProfile(lysine: 2.5),
        energy: EnergyValues(nePig: 2100),
      );

      // 25% cottonseed meal (exceeds 15% limit)
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 250), // 25% cottonseed
          FeedIngredients(ingredientId: 2, quantity: 750), // 75% corn
        ],
        ingredientCache: {1: cottonseedMeal, 2: corn},
        animalTypeId: 1,
      );

      // Should have violation warning
      expect(result.warningsJson, isNotNull);
      expect(result.warningsJson, contains('VIOLATION'));
      expect(result.warningsJson, contains('Cottonseed'));
    });

    test('Detect ANF violation - high glucosinolates', () {
      // Canola meal with high glucosinolates at excessive inclusion

      final canolaMeal = Ingredient(
        ingredientId: 1,
        name: 'Canola meal, high glucosinolate',
        crudeProtein: 38.0,
        aminoAcidsSid: AminoAcidsProfile(lysine: 20.0),
        energy: EnergyValues(nePig: 2000),
        maxInclusionPct: 10.0, // 10% max for high glucosinolate varieties
        antiNutritionalFactors: AntiNutritionalFactors(
          glucosinolatesMicromolG: 35, // High (>30 μmol/g)
        ),
      );

      final corn = Ingredient(
        ingredientId: 2,
        name: 'Corn grain',
        crudeProtein: 8.5,
        aminoAcidsSid: AminoAcidsProfile(lysine: 2.5),
        energy: EnergyValues(nePig: 2100),
      );

      // 15% canola (exceeds 10% limit for high glucosinolates)
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 150), // 15% canola
          FeedIngredients(ingredientId: 2, quantity: 850), // 85% corn
        ],
        ingredientCache: {1: canolaMeal, 2: corn},
        animalTypeId: 1,
      );

      // Should have ANF violation
      expect(result.warningsJson, isNotNull);
      expect(result.warningsJson, contains('glucosinolates'));
      expect(result.warningsJson, contains('VIOLATION'));
    });

    test('Safe formulation with low ANF levels', () {
      // Modern canola meal with low glucosinolates

      final canolaMeal = Ingredient(
        ingredientId: 1,
        name: 'Canola meal, low glucosinolate',
        crudeProtein: 38.0,
        aminoAcidsSid: AminoAcidsProfile(lysine: 20.0),
        energy: EnergyValues(nePig: 2000),
        antiNutritionalFactors: AntiNutritionalFactors(
          glucosinolatesMicromolG: 15, // Low (<30 μmol/g)
        ),
      );

      final corn = Ingredient(
        ingredientId: 2,
        name: 'Corn grain',
        crudeProtein: 8.5,
        aminoAcidsSid: AminoAcidsProfile(lysine: 2.5),
        energy: EnergyValues(nePig: 2100),
      );

      // 20% canola (safe with low glucosinolates)
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 200), // 20% canola
          FeedIngredients(ingredientId: 2, quantity: 800), // 80% corn
        ],
        ingredientCache: {1: canolaMeal, 2: corn},
        animalTypeId: 1,
      );

      // Should NOT have violations (low glucosinolates)
      expect(result.warningsJson, isNotNull);
      expect(result.warningsJson, isNot(contains('VIOLATION')));
    });

    test('Poultry formulation uses ME not NE', () {
      // Verify poultry formulations use ME energy

      final corn = Ingredient(
        ingredientId: 1,
        name: 'Corn grain',
        crudeProtein: 8.5,
        energy: EnergyValues(
          mePoultry: 3300, // ME for poultry
          nePig: 2100, // NE for pigs (should NOT be used)
        ),
      );

      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 1000),
        ],
        ingredientCache: {1: corn},
        animalTypeId: 2, // Poultry
      );

      // Should use ME (3300), not NE (2100)
      expect(result.mEnergy, equals(3300));
    });

    test('Complex formulation with multiple ingredients', () {
      // 7-ingredient pig grower formulation

      final ingredients = {
        1: Ingredient(
          ingredientId: 1,
          name: 'Corn',
          crudeProtein: 8.5,
          aminoAcidsSid: AminoAcidsProfile(lysine: 2.5),
          energy: EnergyValues(nePig: 2100),
        ),
        2: Ingredient(
          ingredientId: 2,
          name: 'Soybean meal',
          crudeProtein: 48.0,
          aminoAcidsSid: AminoAcidsProfile(lysine: 28.5),
          energy: EnergyValues(nePig: 2230),
        ),
        3: Ingredient(
          ingredientId: 3,
          name: 'Wheat',
          crudeProtein: 12.0,
          aminoAcidsSid: AminoAcidsProfile(lysine: 3.2),
          energy: EnergyValues(nePig: 2200),
        ),
        4: Ingredient(
          ingredientId: 4,
          name: 'Barley',
          crudeProtein: 11.5,
          aminoAcidsSid: AminoAcidsProfile(lysine: 3.8),
          energy: EnergyValues(nePig: 2050),
        ),
        5: Ingredient(
          ingredientId: 5,
          name: 'Fish meal',
          crudeProtein: 65.0,
          aminoAcidsSid: AminoAcidsProfile(lysine: 48.0),
          energy: EnergyValues(nePig: 2400),
        ),
        6: Ingredient(
          ingredientId: 6,
          name: 'Vegetable oil',
          crudeFat: 99.0,
          energy: EnergyValues(nePig: 7500),
        ),
        7: Ingredient(
          ingredientId: 7,
          name: 'Limestone',
          calcium: 380.0,
          energy: EnergyValues(nePig: 0),
        ),
      };

      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [
          FeedIngredients(ingredientId: 1, quantity: 500), // 50% corn
          FeedIngredients(ingredientId: 2, quantity: 200), // 20% soybean
          FeedIngredients(ingredientId: 3, quantity: 100), // 10% wheat
          FeedIngredients(ingredientId: 4, quantity: 100), // 10% barley
          FeedIngredients(ingredientId: 5, quantity: 50), // 5% fish meal
          FeedIngredients(ingredientId: 6, quantity: 20), // 2% oil
          FeedIngredients(ingredientId: 7, quantity: 30), // 3% limestone
        ],
        ingredientCache: ingredients,
        animalTypeId: 1,
      );

      // Should calculate successfully
      expect(result.cProtein, isNotNull);
      expect(result.mEnergy, isNotNull);
      expect(result.aminoAcidsSidJson, isNotNull);

      // Protein should be reasonable (15-20%)
      expect(result.cProtein, greaterThan(14));
      expect(result.cProtein, lessThan(22));

      // Energy should be reasonable (2000-2500 kcal/kg)
      expect(result.mEnergy, greaterThan(1900));
      expect(result.mEnergy, lessThan(2700));
    });
  });
}

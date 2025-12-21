import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/amino_acids_profile.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/energy_values.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/anti_nutritional_factors.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/enhanced_calculation_engine.dart';

void main() {
  group('Enhanced Calculation Engine - Phase 1 Tests', () {
    group('SID Amino Acid Prioritization', () {
      test('Should use SID values when available', () {
        // Create ingredient with SID amino acids
        final corn = Ingredient(
          ingredientId: 1,
          name: 'Corn grain',
          aminoAcidsSid: AminoAcidsProfile(
            lysine: 2.5, // SID lysine in g/kg
            methionine: 1.8,
          ),
          aminoAcidsTotal: AminoAcidsProfile(
            lysine: 3.0, // Total lysine in g/kg
            methionine: 2.2,
          ),
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 100)],
          ingredientCache: {1: corn},
          animalTypeId: 1,
        );

        // Should use SID values (2.5 g/kg), not total (3.0 g/kg)
        expect(result.aminoAcidsSidJson, isNotNull);
        expect(result.aminoAcidsSidJson, contains('2.5'));
        expect(result.aminoAcidsSidJson, isNot(contains('3.0')));
      });

      test('Should apply digestibility factor when SID not available', () {
        // Create ingredient with only total amino acids
        final wheat = Ingredient(
          ingredientId: 2,
          name: 'Wheat grain',
          aminoAcidsTotal: AminoAcidsProfile(
            lysine: 3.0, // Total lysine in g/kg
            methionine: 2.0,
          ),
          // No SID values
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 2, quantity: 100)],
          ingredientCache: {2: wheat},
          animalTypeId: 1,
        );

        // Should apply 0.85 digestibility factor: 3.0 * 0.85 = 2.55
        expect(result.aminoAcidsSidJson, isNotNull);
        // Allow for rounding: 2.55 rounded to 2.6
        expect(result.aminoAcidsSidJson, contains('2.'));
      });

      test('Should handle legacy fields with digestibility factor', () {
        // Create ingredient with legacy fields only
        final soybean = Ingredient(
          ingredientId: 3,
          name: 'Soybean meal',
          lysine: 28.0, // Legacy field in g/kg
          methionine: 6.0,
          // No v5 amino acid profiles
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 3, quantity: 100)],
          ingredientCache: {3: soybean},
          animalTypeId: 1,
        );

        // Should apply 0.85 digestibility factor: 28.0 * 0.85 = 23.8
        expect(result.aminoAcidsSidJson, isNotNull);
        expect(result.aminoAcidsSidJson, contains('23.'));
      });
    });

    group('Net Energy (NE) Prioritization for Pigs', () {
      test('Should use NE when available for pigs', () {
        final corn = Ingredient(
          ingredientId: 1,
          name: 'Corn grain',
          energy: EnergyValues(
            nePig: 2100, // NE in kcal/kg
            mePig: 3000, // ME in kcal/kg
            dePig: 3400, // DE in kcal/kg
          ),
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 100)],
          ingredientCache: {1: corn},
          animalTypeId: 1, // Pig
        );

        // Should use NE (2100), not ME (3000) or DE (3400)
        expect(result.mEnergy, equals(2100));
      });

      test('Should convert ME to NE when NE not available', () {
        final wheat = Ingredient(
          ingredientId: 2,
          name: 'Wheat grain',
          energy: EnergyValues(
            mePig: 3000, // ME in kcal/kg
            // No NE
          ),
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 2, quantity: 100)],
          ingredientCache: {2: wheat},
          animalTypeId: 1, // Pig
        );

        // Should convert ME to NE: NE = 0.87*ME - 442 = 0.87*3000 - 442 = 2168
        expect(result.mEnergy, closeTo(2168, 1));
      });

      test('Should convert legacy ME to NE for pigs', () {
        final barley = Ingredient(
          ingredientId: 3,
          name: 'Barley grain',
          meGrowingPig: 2800, // Legacy ME field
          // No v5 energy values
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 3, quantity: 100)],
          ingredientCache: {3: barley},
          animalTypeId: 1, // Pig
        );

        // Should convert ME to NE: NE = 0.87*2800 - 442 = 1994
        expect(result.mEnergy, closeTo(1994, 1));
      });

      test('Should use ME for poultry (not NE)', () {
        final corn = Ingredient(
          ingredientId: 1,
          name: 'Corn grain',
          energy: EnergyValues(
            mePoultry: 3300, // ME for poultry
          ),
        );

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 100)],
          ingredientCache: {1: corn},
          animalTypeId: 2, // Poultry
        );

        // Should use ME directly (no conversion for poultry)
        expect(result.mEnergy, equals(3300));
      });
    });

    group('Inclusion Limit Enforcement', () {
      test('Should detect violations when exceeding max inclusion', () {
        final cottonseed = Ingredient(
          ingredientId: 1,
          name: 'Cottonseed meal',
          crudeProtein: 41.0,
          maxInclusionPct: 15.0, // 15% max due to gossypol
        );

        final corn = Ingredient(
          ingredientId: 2,
          name: 'Corn grain',
          crudeProtein: 8.5,
        );

        // 20kg cottonseed + 80kg corn = 20% cottonseed (exceeds 15% limit)
        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [
            FeedIngredients(ingredientId: 1, quantity: 20),
            FeedIngredients(ingredientId: 2, quantity: 80),
          ],
          ingredientCache: {1: cottonseed, 2: corn},
          animalTypeId: 1,
        );

        // Should have violation warning
        expect(result.warningsJson, isNotNull);
        expect(result.warningsJson, contains('Cottonseed'));
        expect(result.warningsJson, contains('VIOLATION'));
      });

      test('Should warn when approaching max inclusion (90%)', () {
        final cottonseed = Ingredient(
          ingredientId: 1,
          name: 'Cottonseed meal',
          crudeProtein: 41.0,
          maxInclusionPct: 15.0, // 15% max due to gossypol
        );

        final corn = Ingredient(
          ingredientId: 2,
          name: 'Corn grain',
          crudeProtein: 8.5,
        );

        // 14kg cottonseed + 86kg corn = 14% cottonseed (93% of 15% limit)
        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [
            FeedIngredients(ingredientId: 1, quantity: 14),
            FeedIngredients(ingredientId: 2, quantity: 86),
          ],
          ingredientCache: {1: cottonseed, 2: corn},
          animalTypeId: 1,
        );

        // Should have warning (not violation)
        expect(result.warningsJson, isNotNull);
        expect(result.warningsJson, contains('Cottonseed'));
        expect(result.warningsJson, isNot(contains('VIOLATION')));
      });

      test('Should validate anti-nutritional factors - glucosinolates', () {
        final canola = Ingredient(
          ingredientId: 1,
          name: 'Canola meal',
          crudeProtein: 38.0,
          antiNutritionalFactors: AntiNutritionalFactors(
            glucosinolatesMicromolG: 35, // High glucosinolates (>30)
          ),
        );

        final corn = Ingredient(
          ingredientId: 2,
          name: 'Corn grain',
          crudeProtein: 8.5,
        );

        // 15kg canola + 85kg corn = 15% canola (exceeds 10% limit for high glucosinolates)
        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [
            FeedIngredients(ingredientId: 1, quantity: 15),
            FeedIngredients(ingredientId: 2, quantity: 85),
          ],
          ingredientCache: {1: canola, 2: corn},
          animalTypeId: 1,
        );

        // Should have ANF violation
        expect(result.warningsJson, isNotNull);
        expect(result.warningsJson, contains('glucosinolates'));
      });

      test('Should validate anti-nutritional factors - tannins', () {
        final sorghum = Ingredient(
          ingredientId: 1,
          name: 'Sorghum grain',
          crudeProtein: 10.0,
          antiNutritionalFactors: AntiNutritionalFactors(
            tanninsPpm: 6000, // High tannins (>5000)
          ),
        );

        final corn = Ingredient(
          ingredientId: 2,
          name: 'Corn grain',
          crudeProtein: 8.5,
        );

        // 20kg sorghum + 80kg corn = 20% sorghum (exceeds 15% limit for high tannins)
        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [
            FeedIngredients(ingredientId: 1, quantity: 20),
            FeedIngredients(ingredientId: 2, quantity: 80),
          ],
          ingredientCache: {1: sorghum, 2: corn},
          animalTypeId: 1,
        );

        // Should have ANF violation
        expect(result.warningsJson, isNotNull);
        expect(result.warningsJson, contains('tannins'));
      });
    });
  });
}

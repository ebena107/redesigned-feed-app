import 'dart:convert';

import 'package:feed_estimator/src/features/add_ingredients/model/amino_acids_profile.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/enhanced_calculation_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Enhanced Calculation Engine Tests', () {
    // Sample ingredients with v5 data
    late Map<num, Ingredient> ingredientCache;

    setUp(() {
      ingredientCache = {
        1: Ingredient(
          ingredientId: 1,
          name: 'Corn meal',
          crudeProtein: 9.0,
          crudeFat: 4.5,
          crudeFiber: 2.0,
          calcium: 0.1,
          phosphorus: 2.8,
          lysine: 2.5,
          methionine: 1.8,
          meGrowingPig: 3340,
          mePoultry: 3500,
          meRuminant: 2950,
          ash: 1.5,
          moisture: 12.0,
          totalPhosphorus: 2.8,
          availablePhosphorus: 1.0,
          phytatePhosphorus: 1.2,
          maxInclusionPct: 100.0,
          aminoAcidsTotal: AminoAcidsProfile(
            lysine: 2.5,
            methionine: 1.8,
            cystine: 1.5,
            threonine: 3.2,
            tryptophan: 0.7,
            phenylalanine: 4.2,
            leucine: 11.8,
            isoleucine: 3.2,
            valine: 4.5,
          ),
          priceKg: 0.15,
        ),
        2: Ingredient(
          ingredientId: 2,
          name: 'Soybean meal',
          crudeProtein: 48.0,
          crudeFat: 2.0,
          crudeFiber: 6.0,
          calcium: 2.8,
          phosphorus: 6.0,
          lysine: 27.0,
          methionine: 6.0,
          meGrowingPig: 2250,
          mePoultry: 2190,
          meRuminant: 1950,
          ash: 6.5,
          moisture: 10.0,
          totalPhosphorus: 6.5,
          availablePhosphorus: 2.8,
          phytatePhosphorus: 2.5,
          maxInclusionPct: 40.0,
          aminoAcidsTotal: AminoAcidsProfile(
            lysine: 27.0,
            methionine: 6.0,
            cystine: 7.0,
            threonine: 19.0,
            tryptophan: 6.0,
            phenylalanine: 20.0,
            leucine: 35.0,
            isoleucine: 19.0,
            valine: 20.0,
          ),
          priceKg: 0.35,
        ),
        3: Ingredient(
          ingredientId: 3,
          name: 'Cottonseed meal',
          crudeProtein: 42.0,
          crudeFat: 1.5,
          crudeFiber: 12.0,
          calcium: 1.8,
          phosphorus: 6.5,
          lysine: 16.0,
          methionine: 5.0,
          meGrowingPig: 1620,
          mePoultry: 1560,
          meRuminant: 1390,
          ash: 7.5,
          moisture: 10.0,
          totalPhosphorus: 6.5,
          availablePhosphorus: 1.8,
          phytatePhosphorus: 3.2,
          maxInclusionPct: 15.0, // Gossypol limit
          warning: 'High gossypol - limit to 15%',
          aminoAcidsTotal: AminoAcidsProfile(
            lysine: 16.0,
            methionine: 5.0,
            cystine: 6.0,
            threonine: 14.0,
            tryptophan: 4.0,
            phenylalanine: 16.0,
            leucine: 24.0,
            isoleucine: 15.0,
            valine: 16.0,
          ),
          priceKg: 0.25,
        ),
      };
    });

    group('Basic Calculation Accuracy', () {
      test('calculates simple two-ingredient formulation correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 500, // 500 kg corn
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 500, // 500 kg soybean
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Growing pig
        );

        expect(result.totalQuantity, 1000);
        expect(result.cProtein, closeTo(28.5, 0.1)); // (9+48)/2
        expect(result.costPerUnit,
            closeTo(0.25, 0.01)); // Average of 0.15 and 0.35
        expect(result.totalCost, closeTo(250, 10)); // 1000 * 0.25
      });

      test('calculates unequal proportions correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 700, // 70% corn
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 300, // 30% soybean
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Protein: (9*700 + 48*300) / 1000 = (6300 + 14400) / 1000 = 20.7
        expect(result.cProtein, closeTo(20.7, 0.1));
        // Cost: (0.15*700 + 0.35*300) / 1000 = 0.210
        expect(result.costPerUnit, closeTo(0.21, 0.01));
      });
    });

    group('Energy Value Selection', () {
      test('selects growing pig energy for animal type 1', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1, // Growing pig
        );

        // Corn meGrowingPig = 3340 → NE = 0.87*3340 - 442 = 2463.8
        // Now using NE (Net Energy) per NRC 2012 standards
        expect(result.mEnergy, closeTo(2464, 50));
      });

      test('selects poultry energy for animal type 2', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 2, // Poultry
        );

        // Corn mePoultry = 3500
        expect(result.mEnergy, closeTo(3500, 50));
      });

      test('selects ruminant energy for animal type 4', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 4, // Ruminant
        );

        // Corn meRuminant = 2950
        expect(result.mEnergy, closeTo(2950, 50));
      });
    });

    group('Enhanced v5 Calculation', () {
      test('calculates ash content correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 500, // 500 kg corn (ash 1.5%)
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 500, // 500 kg soybean (ash 6.5%)
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // (1.5 + 6.5) / 2 = 4.0
        expect(result.ash, closeTo(4.0, 0.1));
      });

      test('calculates moisture content correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000, // 1000 kg corn (moisture 12%)
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.moisture, closeTo(12.0, 0.1));
      });

      test('calculates phosphorus breakdown correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Corn: total 2.8, available 1.0, phytate 1.2
        expect(result.totalPhosphorus, closeTo(2.8, 0.1));
        expect(result.availablePhosphorus, closeTo(1.0, 0.1));
        expect(result.phytatePhosphorus, closeTo(1.2, 0.1));
      });

      test('accumulates amino acids from all ingredients', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 500,
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 500,
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.aminoAcidsTotalJson, isNotNull);
        final aminoAcids = jsonDecode(result.aminoAcidsTotalJson!) as Map;

        // Lysine: (2.5*500 + 27*500)/1000 = 14.75 g/kg
        expect(aminoAcids['lysine'], closeTo(14.75, 0.5));

        // Should have all 10 amino acids
        expect(aminoAcids.length, 10);
      });
    });

    group('Inclusion Limit Validation', () {
      test('detects inclusion limit violations', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 3, // Cottonseed (limit 15%)
            feedId: 1,
            quantity: 200, // 20% of 1000 kg total
            priceUnitKg: 0.25,
          ),
          FeedIngredients(
            ingredientId: 1, // Corn to fill remaining
            feedId: 1,
            quantity: 800,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.warningsJson, isNotNull);
        final warnings = jsonDecode(result.warningsJson!) as List;

        // Should contain violation for cottonseed
        expect(
          warnings.any((w) => w.toString().contains('Cottonseed')),
          true,
        );
      });

      test('includes ingredient-specific warnings', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 3, // Cottonseed with warning
            feedId: 1,
            quantity: 100, // 10% (within limit but close)
            priceUnitKg: 0.25,
          ),
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 900,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        if (result.warningsJson != null) {
          final warnings = jsonDecode(result.warningsJson!) as List;
          // May include gossypol warning
          expect(warnings.isNotEmpty, true);
        }
      });
    });

    group('Backward Compatibility', () {
      test('maintains v4 calculation results', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 700,
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 300,
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // All v4 fields should be populated
        expect(result.mEnergy, isNotNull);
        expect(result.cProtein, isNotNull);
        expect(result.calcium, isNotNull);
        expect(result.phosphorus, isNotNull);
        expect(result.lysine, isNotNull);
        expect(result.methionine, isNotNull);
      });

      test('handles legacy v4-only ingredients gracefully', () {
        // Ingredient with only v4 fields
        final legacyIngredient = Ingredient(
          ingredientId: 99,
          name: 'Legacy ingredient',
          crudeProtein: 15.0,
          lysine: 6.0,
          methionine: 2.0,
          phosphorus: 6.0,
          meGrowingPig: 3200,
          mePoultry: 3300,
          meRuminant: 2800,
          priceKg: 0.20,
          // No v5 fields
        );

        ingredientCache[99] = legacyIngredient;

        final feedIngredients = [
          FeedIngredients(
            ingredientId: 99,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.20,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Should still calculate v4 values
        expect(result.cProtein, 15.0);
        expect(result.lysine, 6.0);
        // ME 3200 → NE = 0.87*3200 - 442 = 2342
        expect(result.mEnergy, closeTo(2342, 50));
      });
    });

    group('Edge Cases', () {
      test('handles empty ingredient list', () {
        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: [],
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.totalQuantity, isNull);
        expect(result.mEnergy, isNull);
      });

      test('handles single ingredient formulation', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.15,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        expect(result.totalQuantity, 1000);
        expect(result.cProtein, 9.0);
      });

      test('handles missing ingredient in cache gracefully', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 999, // Non-existent
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.50,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Should handle gracefully without crashing
        expect(result.totalQuantity, 1000);
      });

      test('calculates with zero quantities correctly', () {
        final feedIngredients = [
          FeedIngredients(
            ingredientId: 1,
            feedId: 1,
            quantity: 0, // Zero quantity
            priceUnitKg: 0.15,
          ),
          FeedIngredients(
            ingredientId: 2,
            feedId: 1,
            quantity: 1000,
            priceUnitKg: 0.35,
          ),
        ];

        final result = EnhancedCalculationEngine.calculateEnhancedResult(
          feedIngredients: feedIngredients,
          ingredientCache: ingredientCache,
          animalTypeId: 1,
        );

        // Zero quantity ingredient should not affect calculation
        expect(result.cProtein, closeTo(48.0, 0.1));
      });
    });

    group('Number Formatting', () {
      test('roundToDouble works correctly', () {
        expect(EnhancedCalculationEngine.roundToDouble(3.14159),
            closeTo(3.1, 0.05));
        expect(
            EnhancedCalculationEngine.roundToDouble(2.77), closeTo(2.8, 0.05));
        expect(EnhancedCalculationEngine.roundToDouble(5.0), 5.0);
        expect(
            EnhancedCalculationEngine.roundToDouble(6.15), closeTo(6.2, 0.05));
      });
    });
  });
}

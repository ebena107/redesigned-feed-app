import 'dart:convert';

import 'package:feed_estimator/src/features/add_ingredients/model/amino_acids_profile.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Enhanced Model Serialization Tests', () {
    group('Ingredient v5 Fields Serialization', () {
      test('serializes v5 numeric fields correctly', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: 15.5,
          ash: 10.5,
          moisture: 12.0,
          starch: 45.0,
          bulkDensity: 600.0,
          totalPhosphorus: 3.5,
          availablePhosphorus: 1.5,
          phytatePhosphorus: 1.8,
          meFinishingPig: 3200,
          maxInclusionPct: 20.0,
        );

        final json = ingredient.toJson();

        expect(json['ash'], 10.5);
        expect(json['moisture'], 12.0);
        expect(json['starch'], 45.0);
        expect(json['bulk_density'], 600.0);
        expect(json['total_phosphorus'], 3.5);
        expect(json['available_phosphorus'], 1.5);
        expect(json['phytate_phosphorus'], 1.8);
        expect(json['me_finishing_pig'], 3200);
        expect(json['max_inclusion_pct'], 20.0);
      });

      test('deserializes v5 numeric fields correctly', () {
        final json = {
          'ingredient_id': 1,
          'name': 'Test',
          'crude_protein': 15.5,
          'ash': 10.5,
          'moisture': 12.0,
          'starch': 45.0,
          'bulk_density': 600.0,
          'total_phosphorus': 3.5,
          'available_phosphorus': 1.5,
          'phytate_phosphorus': 1.8,
          'me_finishing_pig': 3200,
          'max_inclusion_pct': 20.0,
        };

        final ingredient = Ingredient.fromJson(json);

        expect(ingredient.ash, 10.5);
        expect(ingredient.moisture, 12.0);
        expect(ingredient.starch, 45.0);
        expect(ingredient.bulkDensity, 600.0);
        expect(ingredient.totalPhosphorus, 3.5);
        expect(ingredient.availablePhosphorus, 1.5);
        expect(ingredient.phytatePhosphorus, 1.8);
        expect(ingredient.meFinishingPig, 3200);
        expect(ingredient.maxInclusionPct, 20.0);
      });

      test('serializes amino acids profile correctly', () {
        final aminoAcidsProfile = AminoAcidsProfile(
          lysine: 6.5,
          methionine: 2.0,
          threonine: 6.0,
          tryptophan: 1.8,
          leucine: 8.2,
        );

        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test',
          aminoAcidsTotal: aminoAcidsProfile,
        );

        final json = ingredient.toJson();

        expect(json['amino_acids_total'], isNotNull);
        // JSON is encoded as string in toJson(), must decode first
        final decoded = jsonDecode(json['amino_acids_total'] as String) as Map;
        expect(decoded['lysine'], 6.5);
        expect(decoded['methionine'], 2.0);
      });

      test('deserializes amino acids profile correctly', () {
        final aminoAcids = {
          'lysine': 6.5,
          'methionine': 2.0,
          'threonine': 6.0,
        };

        final json = {
          'ingredient_id': 1,
          'name': 'Test',
          'amino_acids_total': aminoAcids,
        };

        final ingredient = Ingredient.fromJson(json);

        expect(ingredient.aminoAcidsTotal, isNotNull);
        expect(ingredient.aminoAcidsTotal!.lysine, 6.5);
        expect(ingredient.aminoAcidsTotal!.methionine, 2.0);
      });

      test('round-trip serialization preserves v5 data', () {
        final original = Ingredient(
          ingredientId: 1,
          name: 'Alfalfa meal',
          crudeProtein: 15.5,
          ash: 10.5,
          moisture: 12.0,
          totalPhosphorus: 2.4,
          availablePhosphorus: 0.7,
          phytatePhosphorus: 1.7,
          maxInclusionPct: 40.0,
          warning: 'Monitor quality',
          regulatoryNote: 'Approved in EU',
        );

        final json = original.toJson();
        final restored = Ingredient.fromJson(json);

        expect(restored.ash, original.ash);
        expect(restored.moisture, original.moisture);
        expect(restored.totalPhosphorus, original.totalPhosphorus);
        expect(restored.availablePhosphorus, original.availablePhosphorus);
        expect(restored.phytatePhosphorus, original.phytatePhosphorus);
        expect(restored.maxInclusionPct, original.maxInclusionPct);
        expect(restored.warning, original.warning);
        expect(restored.regulatoryNote, original.regulatoryNote);
      });

      test('handles null v5 fields gracefully', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test',
          ash: null,
          moisture: null,
          totalPhosphorus: null,
        );

        final json = ingredient.toJson();
        final restored = Ingredient.fromJson(json);

        expect(restored.ash, isNull);
        expect(restored.moisture, isNull);
        expect(restored.totalPhosphorus, isNull);
      });
    });

    group('Result v5 Fields Serialization', () {
      test('serializes result v5 numeric fields correctly', () {
        final result = Result(
          feedId: 1,
          mEnergy: 3200,
          cProtein: 18.5,
          ash: 9.5,
          moisture: 10.0,
          totalPhosphorus: 3.2,
          availablePhosphorus: 1.4,
          phytatePhosphorus: 1.6,
        );

        final json = result.toJson();

        expect(json['ash'], 9.5);
        expect(json['moisture'], 10.0);
        expect(json['totalPhosphorus'], 3.2);
        expect(json['availablePhosphorus'], 1.4);
        expect(json['phytatePhosphorus'], 1.6);
      });

      test('deserializes result v5 numeric fields correctly', () {
        final json = {
          'feedId': 1,
          'mEnergy': 3200,
          'cProtein': 18.5,
          'ash': 9.5,
          'moisture': 10.0,
          'totalPhosphorus': 3.2,
          'availablePhosphorus': 1.4,
          'phytatePhosphorus': 1.6,
        };

        final result = Result.fromJson(json);

        expect(result.ash, 9.5);
        expect(result.moisture, 10.0);
        expect(result.totalPhosphorus, 3.2);
        expect(result.availablePhosphorus, 1.4);
        expect(result.phytatePhosphorus, 1.6);
      });

      test('stores amino acid JSON correctly', () {
        final aminoAcids = {
          'lysine': 7.2,
          'methionine': 2.1,
          'threonine': 6.5,
          'tryptophan': 2.0,
          'leucine': 8.5,
          'isoleucine': 6.8,
          'valine': 7.5,
          'cystine': 2.2,
          'phenylalanine': 7.8,
          'tyrosine': 6.2,
        };

        final result = Result(
          feedId: 1,
          aminoAcidsTotalJson: jsonEncode(aminoAcids),
        );

        final json = result.toJson();
        final restored = Result.fromJson(json);

        expect(restored.aminoAcidsTotalJson, isNotNull);
        final decoded = jsonDecode(restored.aminoAcidsTotalJson!);
        expect(decoded.length, 10);
        expect(decoded['lysine'], 7.2);
        expect(decoded['methionine'], 2.1);
      });

      test('stores warnings JSON correctly', () {
        final warnings = [
          '🚫 Cottonseed meal exceeds limit: 20.0% > 15.0%',
          '⚠️ Rapeseed is approaching limit: 9.0% of 10.0%',
          '📋 Contains gossypol - verify quality',
        ];

        final result = Result(
          feedId: 1,
          warningsJson: jsonEncode(warnings),
        );

        final json = result.toJson();
        final restored = Result.fromJson(json);

        expect(restored.warningsJson, isNotNull);
        final decoded = jsonDecode(restored.warningsJson!);
        expect(decoded.length, 3);
        expect(decoded[0], contains('Cottonseed'));
      });

      test('round-trip serialization preserves all v5 data', () {
        final original = Result(
          feedId: 1,
          mEnergy: 3200,
          cProtein: 18.5,
          cFat: 5.5,
          cFibre: 4.0,
          calcium: 9.5,
          phosphorus: 6.5,
          lysine: 7.2,
          methionine: 2.1,
          ash: 9.5,
          moisture: 10.0,
          totalPhosphorus: 6.5,
          availablePhosphorus: 2.8,
          phytatePhosphorus: 2.0,
          aminoAcidsTotalJson: jsonEncode({'lysine': 7.2, 'methionine': 2.1}),
          warningsJson: jsonEncode(['⚠️ Warning 1', '⚠️ Warning 2']),
        );

        final json = original.toJson();
        final restored = Result.fromJson(json);

        expect(restored.mEnergy, original.mEnergy);
        expect(restored.cProtein, original.cProtein);
        expect(restored.ash, original.ash);
        expect(restored.moisture, original.moisture);
        expect(restored.totalPhosphorus, original.totalPhosphorus);
        expect(restored.availablePhosphorus, original.availablePhosphorus);
        expect(restored.phytatePhosphorus, original.phytatePhosphorus);
        expect(restored.aminoAcidsTotalJson, original.aminoAcidsTotalJson);
        expect(restored.warningsJson, original.warningsJson);
      });

      test('copyWith preserves v5 fields', () {
        final original = Result(
          feedId: 1,
          ash: 9.5,
          moisture: 10.0,
          totalPhosphorus: 6.5,
        );

        final modified = original.copyWith(
          cProtein: 20.0,
          ash: 9.5, // Preserve v5 field
        );

        expect(modified.cProtein, 20.0);
        expect(modified.ash, 9.5);
        expect(modified.moisture, 10.0);
        expect(modified.totalPhosphorus, 6.5);
      });
    });

    group('JSON Serialization Edge Cases', () {
      test('handles malformed JSON in amino acids gracefully', () {
        final ingredient = Ingredient.fromJson({
          'ingredient_id': 1,
          'name': 'Test',
          'amino_acids_total': 'not valid json',
        });

        // Should not throw, just return null
        expect(ingredient.aminoAcidsTotal, isNull);
      });

      test('handles empty JSON objects', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test',
          aminoAcidsTotal: const AminoAcidsProfile(),
        );

        final json = ingredient.toJson();
        final restored = Ingredient.fromJson(json);

        expect(restored.aminoAcidsTotal, isNotNull);
      });

      test('backward compatible with v4 only data', () {
        final json = {
          'ingredient_id': 1,
          'name': 'Legacy ingredient',
          'crude_protein': 15.5,
          'lysine': 6.5,
          'methionine': 2.0,
          'phosphorus': 6.5,
          'me_growing_pig': 3200,
          // No v5 fields
        };

        final ingredient = Ingredient.fromJson(json);

        expect(ingredient.ingredientId, 1);
        expect(ingredient.name, 'Legacy ingredient');
        expect(ingredient.crudeProtein, 15.5);
        expect(ingredient.lysine, 6.5);
        expect(ingredient.ash, isNull);
        expect(ingredient.totalPhosphorus, isNull);
      });

      test('preserves both v4 and v5 fields in mixed data', () {
        final json = {
          'ingredient_id': 1,
          'name': 'Mixed ingredient',
          'crude_protein': 15.5,
          'lysine': 6.5,
          'phosphorus': 6.5,
          'ash': 9.5,
          'total_phosphorus': 6.8,
          'amino_acids_total': {'lysine': 7.2},
        };

        final ingredient = Ingredient.fromJson(json);

        // v4 fields
        expect(ingredient.crudeProtein, 15.5);
        expect(ingredient.lysine, 6.5);
        expect(ingredient.phosphorus, 6.5);
        // v5 fields
        expect(ingredient.ash, 9.5);
        expect(ingredient.totalPhosphorus, 6.8);
      });
    });
  });
}

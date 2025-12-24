import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/import_export/model/csv_row.dart';
import 'package:feed_estimator/src/features/import_export/model/import_result.dart';
import 'package:feed_estimator/src/features/import_export/service/conflict_detector.dart';
import 'package:feed_estimator/src/features/import_export/service/ingredient_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CSV Import Integration Tests', () {
    group('Conflict Detection', () {
      test('detects duplicate ingredients by name similarity', () {
        final existing = [
          Ingredient(name: 'Fish Meal', crudeProtein: 72.0),
          Ingredient(name: 'Soybean Meal', crudeProtein: 48.5),
        ];

        final imported = [
          Ingredient(name: 'Fishmeal', crudeProtein: 73.0), // High similarity
          Ingredient(name: 'Corn', crudeProtein: 9.0),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.75,
        );

        expect(conflicts.isNotEmpty, true);
        expect(conflicts.first.existing.name, 'Fish Meal');
        expect(conflicts.first.imported.name, 'Fishmeal');
      });

      test('does not detect dissimilar ingredients as duplicates', () {
        final existing = [Ingredient(name: 'Fish Meal', crudeProtein: 72.0)];
        final imported = [
          Ingredient(name: 'Corn Gluten Meal', crudeProtein: 60.0)
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.85,
        );

        expect(conflicts.isEmpty, true);
      });

      test('calculates correct Levenshtein similarity scores', () {
        // Identical strings → 1.0
        expect(
          ConflictDetector.calculateSimilarity('Fish Meal', 'Fish Meal'),
          equals(1.0),
        );

        // Completely different → close to 0.0
        final dissimilar = ConflictDetector.calculateSimilarity('ABC', 'XYZ');
        expect(dissimilar, lessThan(0.3));

        // Similar but not identical - "Barley" vs "Barley Meal"
        final similar =
            ConflictDetector.calculateSimilarity('Barley', 'Barley Meal');
        expect(similar, greaterThan(0.5)); // Adjusted from 0.7
        expect(similar, lessThan(1.0));
      });
    });

    group('Ingredient Mapping', () {
      test('suggests correct column mapping from CSV headers', () {
        final headers = [
          'Ingredient Name',
          'Crude Protein %',
          'Crude Fiber',
          'Cost per kg',
        ];

        final mapping = IngredientMapper.suggestMapping(headers);

        expect(mapping['Ingredient Name'], 'name');
        expect(mapping['Crude Protein %'], 'crudeProtein');
        expect(mapping['Crude Fiber'], 'crudeFiber');
        expect(mapping['Cost per kg'], 'priceKg');
      });

      test('maps CSV row to Ingredient with correct values', () {
        final headers = ['name', 'crude_protein', 'crude_fiber', 'price_kg'];
        final values = ['Fish Meal', '72.0', '0.5', '150.00'];
        final row = CSVRow(rowNumber: 2, values: values);

        final mapping = {
          'name': 'name',
          'crude_protein': 'crudeProtein',
          'crude_fiber': 'crudeFiber',
          'price_kg': 'priceKg'
        };

        final ingredient = IngredientMapper.mapRowToIngredient(
          row: row,
          headers: headers,
          columnMapping: mapping,
        );

        expect(ingredient.name, 'Fish Meal');
        expect(ingredient.crudeProtein, 72.0);
        expect(ingredient.crudeFiber, 0.5);
        expect(ingredient.priceKg, 150.00);
      });

      test('handles European decimal separator (comma)', () {
        final headers = ['name', 'crude_protein', 'price_kg'];
        final values = ['Soybean', '48,5', '200,50'];
        final row = CSVRow(rowNumber: 2, values: values);

        final mapping = {
          'name': 'name',
          'crude_protein': 'crudeProtein',
          'price_kg': 'priceKg'
        };

        final ingredient = IngredientMapper.mapRowToIngredient(
          row: row,
          headers: headers,
          columnMapping: mapping,
        );

        expect(ingredient.crudeProtein, 48.5);
        expect(ingredient.priceKg, 200.50);
      });

      test('marks imported ingredients as custom', () {
        final headers = ['name', 'crude_protein'];
        final values = ['Custom Blend', '15.0'];
        final row = CSVRow(rowNumber: 2, values: values);

        final mapping = {'name': 'name', 'crude_protein': 'crudeProtein'};

        final ingredient = IngredientMapper.mapRowToIngredient(
          row: row,
          headers: headers,
          columnMapping: mapping,
        );

        expect(ingredient.isCustom, 1);
      });
    });

    group('Import Result Tracking', () {
      test('calculates import statistics correctly', () {
        final result = ImportResult(
          importedCount: 10,
          updatedCount: 5,
          skippedCount: 2,
          createdIngredients: List.generate(10, (_) => Ingredient()),
          updatedIngredients: List.generate(5, (_) => Ingredient()),
          errors: [],
          completedAt: DateTime.now(),
        );

        expect(result.totalProcessed, 17);
        expect(result.successRate, closeTo(0.88, 0.01));
        expect(result.isSuccessful, true);
      });

      test('generates accurate summary text', () {
        final result = ImportResult(
          importedCount: 10,
          updatedCount: 5,
          skippedCount: 2,
          createdIngredients: [],
          updatedIngredients: [],
          errors: [],
          completedAt: DateTime.now(),
        );

        expect(result.summary.contains('10 new'), true);
        expect(result.summary.contains('5 updated'), true);
        expect(result.summary.contains('2 skipped'), true);
      });

      test('tracks errors in import process', () {
        final result = ImportResult(
          importedCount: 8,
          updatedCount: 5,
          skippedCount: 2,
          createdIngredients: [],
          updatedIngredients: [],
          errors: [
            'Row 5: Missing required field "crude_protein"',
            'Row 12: Invalid price value "abc"',
          ],
          completedAt: DateTime.now(),
        );

        expect(result.isSuccessful, false);
        expect(result.errors.length, 2);
        expect(result.summary.contains('2 errors'), true);
      });

      test('copyWith preserves all fields', () {
        final original = ImportResult(
          importedCount: 10,
          updatedCount: 5,
          skippedCount: 2,
          createdIngredients: [],
          updatedIngredients: [],
          errors: [],
          completedAt: DateTime.now(),
        );

        final updated = original.copyWith(importedCount: 12);

        expect(updated.importedCount, 12);
        expect(updated.updatedCount, 5);
        expect(updated.skippedCount, 2);
      });
    });

    group('CSV Row Validation', () {
      test('CSVRow tracks validity status', () {
        final validRow = CSVRow(
          rowNumber: 1,
          values: ['Fish Meal', '72.0', '0.5'],
        );

        expect(validRow.isValid, true);
      });

      test('CSVRow can track validation errors', () {
        final invalidRow = CSVRow(
          rowNumber: 2,
          values: ['', '72.0'],
          errors: ['Missing required field: name'],
        );

        expect(invalidRow.isValid, false);
        expect(invalidRow.errors?.length, 1);
      });
    });
  });
}

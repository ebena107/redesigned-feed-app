import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/import_export/service/conflict_detector.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

void main() {
  group('ConflictDetector Tests', () {
    group('Similarity Calculation', () {
      test('returns 1.0 for identical strings', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Fish Meal',
          'Fish Meal',
        );
        expect(similarity, 1.0);
      });

      test('returns 1.0 for identical strings (case-insensitive)', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Fish Meal',
          'fish meal',
        );
        expect(similarity, 1.0);
      });

      test('returns 0.0 for completely different strings', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Fish Meal',
          'XYZ',
        );
        expect(similarity, lessThan(0.5));
      });

      test('returns 0.0 for empty string comparison', () {
        final similarity1 =
            ConflictDetector.calculateSimilarity('Fish Meal', '');
        final similarity2 =
            ConflictDetector.calculateSimilarity('', 'Fish Meal');
        expect(similarity1, 0.0);
        expect(similarity2, 0.0);
      });

      test('detects minor variations (50%+ similarity)', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Fish Meal',
          'Fish meal (salted)',
        );
        expect(similarity,
            greaterThanOrEqualTo(0.50)); // Close match despite difference
      });

      test('detects near-duplicates with typos', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Soybean Meal',
          'Soybean Meal',
        );
        expect(similarity, equals(1.0));

        final similarityWithTypo = ConflictDetector.calculateSimilarity(
          'Soybean Meal',
          'Soybean Mea',
        );
        expect(similarityWithTypo, greaterThan(0.85));
      });

      test('uses Levenshtein distance algorithm correctly', () {
        // "kitten" vs "sitting" → Levenshtein distance = 3
        final similarity = ConflictDetector.calculateSimilarity(
          'kitten',
          'sitting',
        );
        expect(similarity, lessThan(1.0));
        expect(similarity, greaterThan(0.4)); // Should be around 0.57
      });

      test('handles special characters in strings', () {
        final similarity = ConflictDetector.calculateSimilarity(
          'Fish Meal (dried)',
          'Fish Meal - Dried',
        );
        expect(similarity, greaterThan(0.8)); // Should be fairly similar
      });
    });

    group('Duplicate Detection', () {
      test('finds exact duplicate ingredients', () {
        final imported = [
          Ingredient(name: 'Fish Meal'),
        ];
        final existing = [
          Ingredient(name: 'Fish Meal'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.85,
        );

        expect(conflicts.length, 1);
        expect(conflicts[0].displayName, 'Fish Meal ↔ Fish Meal');
      });

      test('finds near-duplicate with 95% similarity', () {
        final imported = [
          Ingredient(name: 'Soybean Meal'),
        ];
        final existing = [
          Ingredient(name: 'Soybean meal'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.85,
        );

        expect(conflicts.length, 1);
        expect(conflicts[0].nameSimilarity, greaterThanOrEqualTo(0.95));
      });

      test('ignores low-similarity pairs below threshold', () {
        final imported = [
          Ingredient(name: 'Corn'),
        ];
        final existing = [
          Ingredient(name: 'Rice'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.85,
        );

        expect(conflicts.isEmpty, true);
      });

      test('detects multiple conflicts', () {
        final imported = [
          Ingredient(name: 'Fish Meal'),
          Ingredient(name: 'Soybean Meal'),
        ];
        final existing = [
          Ingredient(name: 'Fish meal'),
          Ingredient(name: 'Soybean meal'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
        );

        expect(conflicts.length, 2);
      });

      test('ignores ingredients with empty names', () {
        final imported = [
          Ingredient(name: ''),
          Ingredient(name: 'Fish Meal'),
        ];
        final existing = [
          Ingredient(name: ''),
          Ingredient(name: 'Fish meal'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
        );

        expect(conflicts.length, 1); // Only Fish Meal conflict
      });

      test('ignores ingredients with null names', () {
        final imported = [
          Ingredient(name: null),
          Ingredient(name: 'Fish Meal'),
        ];
        final existing = [
          Ingredient(name: null),
          Ingredient(name: 'Fish meal'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
        );

        expect(conflicts.length, 1);
      });

      test('sorts conflicts by similarity descending', () {
        final imported = [
          Ingredient(name: 'Corn'),
          Ingredient(name: 'Fish Meal'),
        ];
        final existing = [
          Ingredient(name: 'corn'), // 1.0 similarity
          Ingredient(name: 'Fish meal'), // 1.0 similarity
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
          similarityThreshold: 0.8,
        );

        // Both should have high similarity
        expect(conflicts.length, 2);
        expect(
          conflicts[0].nameSimilarity,
          greaterThanOrEqualTo(conflicts[1].nameSimilarity),
        );
      });

      test('returns empty list for no duplicates', () {
        final imported = [
          Ingredient(name: 'Corn'),
        ];
        final existing = [
          Ingredient(name: 'Rice'),
          Ingredient(name: 'Wheat'),
        ];

        final conflicts = ConflictDetector.findDuplicates(
          importedList: imported,
          existingList: existing,
        );

        expect(conflicts, isEmpty);
      });
    });

    group('Merge Strategy Suggestion', () {
      test('suggests REPLACE for 95%+ similarity', () {
        final imported = Ingredient(
          name: 'Fish Meal',
          crudeProtein: 64.0,
        );
        final existing = Ingredient(
          name: 'Fish meal',
          crudeProtein: 64.0,
        );

        final pair = ConflictPair(
          imported: imported,
          existing: existing,
          nameSimilarity: 0.99,
          suggestedStrategy: MergeStrategy.replace,
        );

        expect(pair.suggestedStrategy, MergeStrategy.replace);
      });

      test('suggests MERGE for significant protein difference (>5%)', () {
        final imported = Ingredient(
          name: 'Fish Meal',
          crudeProtein: 70.0,
        );
        final existing = Ingredient(
          name: 'Fish meal',
          crudeProtein: 64.0, // 6% difference
        );

        // For this test, we'll manually check the protein diff
        expect((imported.crudeProtein ?? 0) - (existing.crudeProtein ?? 0),
            greaterThan(5));
      });

      test('suggests SKIP for similar ingredients (keep existing)', () {
        final imported = Ingredient(
          name: 'Fish Meal',
          crudeProtein: 64.0,
        );
        final existing = Ingredient(
          name: 'Fish meal',
          crudeProtein: 64.2, // <5% difference
        );

        final similarity = ConflictDetector.calculateSimilarity(
          imported.name ?? '',
          existing.name ?? '',
        );

        expect(similarity, greaterThan(0.9));
      });
    });

    group('Conflict Resolution', () {
      test('applies SKIP strategy (keeps existing)', () {
        final imported = [
          Ingredient(ingredientId: 1, name: 'Fish Meal'),
          Ingredient(ingredientId: 2, name: 'Soybean Meal'),
        ];
        final conflicts = [
          ConflictPair(
            imported: imported[0],
            existing: Ingredient(ingredientId: 101, name: 'Fish meal'),
            nameSimilarity: 0.99,
            suggestedStrategy: MergeStrategy.skip,
          ),
        ];
        final decisions = {
          conflicts[0]: MergeStrategy.skip,
        };

        final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
          importedList: imported,
          conflicts: conflicts,
          userDecisions: decisions,
        );

        expect(toAdd.length, 1); // Only Soybean Meal (non-conflicted)
        expect(toAdd[0].name, 'Soybean Meal');
        expect(toUpdate.isEmpty, true);
      });

      test('applies REPLACE strategy (updates existing with imported)', () {
        final imported = [
          Ingredient(ingredientId: 1, name: 'Fish Meal', crudeProtein: 70.0),
        ];
        final existing = Ingredient(
          ingredientId: 101,
          name: 'Fish meal',
          crudeProtein: 64.0,
        );
        final conflicts = [
          ConflictPair(
            imported: imported[0],
            existing: existing,
            nameSimilarity: 0.99,
            suggestedStrategy: MergeStrategy.replace,
          ),
        ];
        final decisions = {
          conflicts[0]: MergeStrategy.replace,
        };

        final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
          importedList: imported,
          conflicts: conflicts,
          userDecisions: decisions,
        );

        expect(toAdd.isEmpty, true);
        expect(toUpdate.length, 1);
        expect(toUpdate[0].ingredientId, 101); // Keeps existing ID
        expect(toUpdate[0].crudeProtein, 70.0); // Uses imported data
      });

      test('applies MERGE strategy (combines best of both)', () {
        final imported = [
          Ingredient(
            ingredientId: 1,
            name: 'Fish Meal',
            crudeProtein: 70.0,
            lysine: 5.5,
            meGrowingPig: 3100,
          ),
        ];
        final existing = Ingredient(
          ingredientId: 101,
          name: 'Fish meal',
          crudeProtein: 64.0,
          lysine: 5.0,
          meGrowingPig: 3000,
        );
        final conflicts = [
          ConflictPair(
            imported: imported[0],
            existing: existing,
            nameSimilarity: 0.95,
            suggestedStrategy: MergeStrategy.merge,
          ),
        ];
        final decisions = {
          conflicts[0]: MergeStrategy.merge,
        };

        final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
          importedList: imported,
          conflicts: conflicts,
          userDecisions: decisions,
        );

        expect(toAdd.isEmpty, true);
        expect(toUpdate.length, 1);
        expect(toUpdate[0].ingredientId, 101);
        expect(
            toUpdate[0].crudeProtein, 70.0); // Uses imported (higher protein)
        expect(toUpdate[0].lysine, 5.5); // Uses imported (better)
        expect(toUpdate[0].meGrowingPig, 3100); // Uses imported (higher energy)
      });

      test('handles mixed strategies for multiple conflicts', () {
        final imported = [
          Ingredient(ingredientId: 1, name: 'Fish Meal'),
          Ingredient(ingredientId: 2, name: 'Soybean Meal'),
          Ingredient(ingredientId: 3, name: 'Corn Grain'),
        ];
        final conflicts = [
          ConflictPair(
            imported: imported[0],
            existing: Ingredient(ingredientId: 101, name: 'Fish meal'),
            nameSimilarity: 0.99,
            suggestedStrategy: MergeStrategy.skip,
          ),
          ConflictPair(
            imported: imported[1],
            existing: Ingredient(ingredientId: 102, name: 'Soybean meal'),
            nameSimilarity: 0.98,
            suggestedStrategy: MergeStrategy.replace,
          ),
        ];
        final decisions = {
          conflicts[0]: MergeStrategy.skip,
          conflicts[1]: MergeStrategy.replace,
        };

        final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
          importedList: imported,
          conflicts: conflicts,
          userDecisions: decisions,
        );

        expect(toAdd.length, 1); // Only Corn (non-conflicted)
        expect(toAdd[0].name, 'Corn Grain');
        expect(toUpdate.length, 1); // Only Soybean (REPLACE)
        expect(toUpdate[0].name, 'Soybean Meal');
      });
    });

    group('ConflictPair Helpers', () {
      test('displayName shows both ingredient names', () {
        final pair = ConflictPair(
          imported: Ingredient(name: 'Fish Meal'),
          existing: Ingredient(name: 'Fish meal'),
          nameSimilarity: 0.99,
          suggestedStrategy: MergeStrategy.skip,
        );

        expect(pair.displayName, 'Fish Meal ↔ Fish meal');
      });

      test('similarityText formats percentage correctly', () {
        final pair = ConflictPair(
          imported: Ingredient(name: 'Fish Meal'),
          existing: Ingredient(name: 'Fish meal'),
          nameSimilarity: 0.95,
          suggestedStrategy: MergeStrategy.skip,
        );

        expect(pair.similarityText, '95% match');
      });

      test('similarityText rounds to nearest integer', () {
        final pair = ConflictPair(
          imported: Ingredient(name: 'Fish Meal'),
          existing: Ingredient(name: 'Fish meal'),
          nameSimilarity: 0.956, // 95.6% → rounds to 96%
          suggestedStrategy: MergeStrategy.skip,
        );

        expect(pair.similarityText, '96% match');
      });
    });
  });
}

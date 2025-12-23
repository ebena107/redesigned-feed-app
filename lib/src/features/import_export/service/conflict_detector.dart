import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

const String _tag = 'ConflictDetector';

enum MergeStrategy { skip, replace, merge }

/// Finds potential duplicates and suggests merge strategies
class ConflictDetector {
  /// Calculate similarity between two strings (0-1)
  /// Uses Levenshtein distance algorithm
  static double calculateSimilarity(String s1, String s2) {
    final str1 = s1.toLowerCase();
    final str2 = s2.toLowerCase();

    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    // Levenshtein distance
    final matrix = List.generate(
      str2.length + 1,
      (i) => List.generate(str1.length + 1, (j) => 0),
    );

    for (int i = 0; i <= str2.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= str1.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= str2.length; i++) {
      for (int j = 1; j <= str1.length; j++) {
        final cost = str2[i - 1] == str1[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    final distance = matrix[str2.length][str1.length].toDouble();
    final maxLen = [str1.length, str2.length].reduce((a, b) => a > b ? a : b);
    return 1.0 - (distance / maxLen);
  }

  /// Find potential duplicates
  /// Returns: List<ConflictPair> (imported ↔ existing)
  static List<ConflictPair> findDuplicates({
    required List<Ingredient> importedList,
    required List<Ingredient> existingList,
    double similarityThreshold = 0.85,
  }) {
    final conflicts = <ConflictPair>[];

    for (final imported in importedList) {
      final importedName = imported.name ?? '';
      if (importedName.isEmpty) continue;

      for (final existing in existingList) {
        final existingName = existing.name ?? '';
        if (existingName.isEmpty) continue;

        // Calculate name similarity
        final nameSimilarity = calculateSimilarity(importedName, existingName);

        if (nameSimilarity >= similarityThreshold) {
          // Potential duplicate found
          conflicts.add(ConflictPair(
            imported: imported,
            existing: existing,
            nameSimilarity: nameSimilarity,
            suggestedStrategy: _suggestStrategy(imported, existing),
          ));
        }
      }
    }

    // Sort by similarity descending
    conflicts.sort((a, b) => b.nameSimilarity.compareTo(a.nameSimilarity));

    AppLogger.info(
      'Found ${conflicts.length} potential conflicts',
      tag: _tag,
    );

    return conflicts;
  }

  /// Suggest merge strategy based on data comparison
  static MergeStrategy _suggestStrategy(
    Ingredient imported,
    Ingredient existing,
  ) {
    // Very similar names (95%+) → Replace
    final nameSim = calculateSimilarity(
      imported.name ?? '',
      existing.name ?? '',
    );
    if (nameSim >= 0.95) {
      return MergeStrategy.replace;
    }

    // Check nutrient similarity
    final proteinDiff =
        (imported.crudeProtein ?? 0) - (existing.crudeProtein ?? 0);

    // If protein differs significantly (>5%) → Merge/review
    if ((proteinDiff.abs() > 5)) {
      return MergeStrategy.merge;
    }

    // Otherwise skip (keep existing)
    return MergeStrategy.skip;
  }

  /// Apply merge strategies to resolve conflicts
  /// Returns: (ingredientsToAdd, ingredientsToUpdate)
  static (List<Ingredient>, List<Ingredient>) resolveConflicts({
    required List<Ingredient> importedList,
    required List<ConflictPair> conflicts,
    required Map<ConflictPair, MergeStrategy> userDecisions,
  }) {
    final toAdd = <Ingredient>[];
    final toUpdate = <Ingredient>[];
    final conflictedIds = <String>{};

    // Process user decisions
    for (final entry in userDecisions.entries) {
      final conflict = entry.key;
      final strategy = entry.value;

      conflictedIds.add(conflict.imported.ingredientId?.toString() ?? '');

      switch (strategy) {
        case MergeStrategy.skip:
          // Keep existing, discard imported
          break;

        case MergeStrategy.replace:
          // Replace existing with imported data
          toUpdate.add(conflict.imported.copyWith(
            ingredientId: conflict.existing.ingredientId,
          ));
          break;

        case MergeStrategy.merge:
          // Merge: keep existing, but update from imported if better
          final merged = conflict.existing.copyWith(
            crudeProtein: conflict.imported.crudeProtein ??
                conflict.existing.crudeProtein,
            lysine: conflict.imported.lysine ?? conflict.existing.lysine,
            meGrowingPig: conflict.imported.meGrowingPig ??
                conflict.existing.meGrowingPig,
          );
          toUpdate.add(merged);
          break;
      }
    }

    // Add non-conflicted imported ingredients
    for (final ing in importedList) {
      if (!conflictedIds.contains(ing.ingredientId?.toString() ?? '')) {
        toAdd.add(ing);
      }
    }

    AppLogger.info(
      'Conflict resolution: ${toAdd.length} to add, ${toUpdate.length} to update',
      tag: _tag,
    );

    return (toAdd, toUpdate);
  }
}

class ConflictPair {
  final Ingredient imported;
  final Ingredient existing;
  final double nameSimilarity;
  final MergeStrategy suggestedStrategy;

  const ConflictPair({
    required this.imported,
    required this.existing,
    required this.nameSimilarity,
    required this.suggestedStrategy,
  });

  String get displayName => '${imported.name} ↔ ${existing.name}';

  String get similarityText =>
      '${(nameSimilarity * 100).toStringAsFixed(0)}% match';
}

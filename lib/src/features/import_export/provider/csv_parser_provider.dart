import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/import_export/model/csv_row.dart';
import 'package:feed_estimator/src/features/import_export/model/conflict_resolution.dart';
import 'package:feed_estimator/src/features/import_export/repository/csv_import_repository.dart';
import 'package:feed_estimator/src/features/import_export/service/ingredient_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'csv_parser_provider.g.dart';

const String _tag = 'CsvParserProvider';

/// Async provider for parsing CSV rows into Ingredient objects
///
/// Usage:
/// ```dart
/// final ingredients = await ref.read(csvParserProvider(rows, headers, mapping).future);
/// ```
@riverpod
Future<List<Ingredient>> csvParser(
  Ref ref, {
  required List<CSVRow> rows,
  required List<String> headers,
  required Map<String, String> columnMapping,
}) async {
  try {
    AppLogger.info(
      'Parsing ${rows.length} CSV rows to ingredients',
      tag: _tag,
    );

    final ingredients = <Ingredient>[];

    for (final row in rows) {
      try {
        if (!row.isValid) {
          AppLogger.warning(
            'Skipping invalid row ${row.rowNumber}: ${row.errors?.join(", ")}',
            tag: _tag,
          );
          continue;
        }

        final ingredient = IngredientMapper.mapRowToIngredient(
          row: row,
          headers: headers,
          columnMapping: columnMapping,
        );

        ingredients.add(ingredient);
      } catch (e) {
        AppLogger.warning(
          'Failed to parse row ${row.rowNumber}: $e',
          tag: _tag,
        );
        // Continue with next row
      }
    }

    AppLogger.info(
      'Parsed ${ingredients.length}/${rows.length} rows successfully',
      tag: _tag,
    );

    return ingredients;
  } catch (e, stackTrace) {
    AppLogger.error(
      'CSV parsing failed: $e',
      tag: _tag,
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Async provider for detecting conflicts between imported and existing ingredients
///
/// Uses Levenshtein distance to find similar ingredient names
///
/// Usage:
/// ```dart
/// final conflicts = await ref.read(conflictResolverProvider(
///   importedIngredients: imported,
///   similarityThreshold: 0.85,
/// ).future);
/// ```
@riverpod
Future<List<ConflictPair>> conflictResolver(
  Ref ref, {
  required List<Ingredient> importedIngredients,
  double similarityThreshold = 0.85,
}) async {
  try {
    AppLogger.info(
      'Detecting conflicts for ${importedIngredients.length} imported ingredients',
      tag: _tag,
    );

    // Get all existing ingredients
    final existingRepository = ref.watch(csvImportRepository);
    final existingIngredients = await existingRepository.getAll();

    if (existingIngredients.isEmpty) {
      AppLogger.info('No existing ingredients, no conflicts detected',
          tag: _tag);
      return [];
    }

    final conflicts = <ConflictPair>[];

    for (final imported in importedIngredients) {
      final importedName = imported.name ?? '';
      if (importedName.isEmpty) continue;

      for (final existing in existingIngredients) {
        final existingName = existing.name ?? '';
        if (existingName.isEmpty) continue;

        // Calculate similarity
        final similarity = _calculateLevenshteinSimilarity(
          importedName,
          existingName,
        );

        if (similarity >= similarityThreshold) {
          conflicts.add(
            ConflictPair(
              existingIngredient: existing,
              importedIngredient: imported,
              nameSimilarity: similarity,
              conflictReason:
                  'Name similarity: ${(similarity * 100).toStringAsFixed(0)}%',
            ),
          );

          AppLogger.debug(
            'Conflict detected: $existingName ↔ $importedName (${(similarity * 100).toStringAsFixed(0)}%)',
            tag: _tag,
          );

          break; // Move to next imported ingredient
        }
      }
    }

    AppLogger.info(
      'Found ${conflicts.length} conflicts',
      tag: _tag,
    );

    return conflicts;
  } catch (e, stackTrace) {
    AppLogger.error(
      'Conflict detection failed: $e',
      tag: _tag,
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Calculate Levenshtein distance similarity (0.0-1.0)
/// Higher values indicate more similar strings
double _calculateLevenshteinSimilarity(String s1, String s2) {
  final distance = _levenshteinDistance(s1.toLowerCase(), s2.toLowerCase());
  final maxLength = (s1.length > s2.length) ? s1.length : s2.length;
  if (maxLength == 0) return 1.0; // Both strings empty
  return 1.0 - (distance / maxLength);
}

/// Calculate Levenshtein distance between two strings
/// Returns the minimum number of single-character edits required
int _levenshteinDistance(String s1, String s2) {
  final List<List<int>> d = List.generate(
    s1.length + 1,
    (i) => List.generate(s2.length + 1, (j) => 0),
  );

  for (int i = 0; i <= s1.length; i++) {
    d[i][0] = i;
  }
  for (int j = 0; j <= s2.length; j++) {
    d[0][j] = j;
  }

  for (int i = 1; i <= s1.length; i++) {
    for (int j = 1; j <= s2.length; j++) {
      final cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
      d[i][j] = [
        d[i - 1][j] + 1, // deletion
        d[i][j - 1] + 1, // insertion
        d[i - 1][j - 1] + cost, // substitution
      ].reduce((a, b) => (a < b) ? a : b);
    }
  }

  return d[s1.length][s2.length];
}

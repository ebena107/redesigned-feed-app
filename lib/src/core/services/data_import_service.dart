import 'dart:convert';
import 'package:feed_estimator/src/core/constants/feature_flags.dart';
import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'DataImportService';

/// Service for importing ingredient data into the database
///
/// Handles both initial ingredient loading and standardized dataset migration.
/// Uses feature flags to control which dataset is loaded.
class DataImportService {
  final IngredientsRepository _ingredientsRepository;
  final AppDatabase _database;

  DataImportService(this._ingredientsRepository, this._database);

  /// Import ingredients from JSON file to database
  ///
  /// Checks if ingredients already exist before importing.
  /// Uses [FeatureFlags.ingredientDatasetPath] to determine source file.
  ///
  /// Returns the number of ingredients imported.
  Future<int> importIngredients({bool forceReimport = false}) async {
    try {
      AppLogger.info('Starting ingredient import...', tag: _tag);
      AppLogger.info(
        'Dataset: ${FeatureFlags.ingredientDatasetPath}',
        tag: _tag,
      );

      // Check if ingredients already exist
      if (!forceReimport) {
        final existing = await _ingredientsRepository.getAll();
        if (existing.isNotEmpty) {
          AppLogger.info(
            'Ingredients already loaded (${existing.length} items). Skipping import.',
            tag: _tag,
          );
          return 0;
        }
      }

      // Load JSON from assets
      final jsonString = await rootBundle.loadString(
        FeatureFlags.ingredientDatasetPath,
      );
      final List<dynamic> jsonData = jsonDecode(jsonString);

      AppLogger.info(
        'Loaded ${jsonData.length} ingredients from JSON',
        tag: _tag,
      );

      // Clear existing data if force reimport
      if (forceReimport) {
        AppLogger.warning('Force reimport: clearing existing data', tag: _tag);
        await _clearExistingIngredients();
      }

      // Import each ingredient
      int imported = 0;
      for (final item in jsonData) {
        try {
          final ingredient = Ingredient.fromJson(item);
          await _ingredientsRepository.create(ingredient.toJson());
          imported++;
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to import ingredient: ${item['name'] ?? 'unknown'}',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          // Continue with next ingredient instead of failing entire import
        }
      }

      AppLogger.info('Successfully imported $imported ingredients', tag: _tag);
      return imported;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Ingredient import failed',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Verify imported data integrity
  ///
  /// Checks:
  /// - Ingredient count matches expected
  /// - No duplicate IDs
  /// - All required fields present
  /// - Category-specific limits (if standardized dataset)
  ///
  /// Returns validation report as Map.
  Future<Map<String, dynamic>> verifyDataIntegrity() async {
    try {
      AppLogger.info('Starting data integrity verification...', tag: _tag);

      final ingredients = await _ingredientsRepository.getAll();
      final report = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'dataset': FeatureFlags.ingredientDatasetPath,
        'totalCount': ingredients.length,
        'issues': <String>[],
        'warnings': <String>[],
      };

      // Check expected count
      final expectedCount = FeatureFlags.useStandardizedIngredients ? 201 : 165;
      if (ingredients.length != expectedCount) {
        report['warnings'].add(
          'Ingredient count mismatch: got ${ingredients.length}, expected $expectedCount',
        );
      }

      // Check for duplicate IDs
      final ids = ingredients.map((i) => i.ingredientId).toList();
      final uniqueIds = ids.toSet();
      if (ids.length != uniqueIds.length) {
        report['issues'].add(
          'Duplicate ingredient IDs detected: ${ids.length - uniqueIds.length} duplicates',
        );
      }

      // Check required fields
      int missingFields = 0;
      for (final ing in ingredients) {
        if (ing.name == null || ing.name!.isEmpty) {
          missingFields++;
        }
      }
      if (missingFields > 0) {
        report['issues'].add(
          '$missingFields ingredients missing required name field',
        );
      }

      // Standardized dataset-specific checks
      if (FeatureFlags.useStandardizedIngredients) {
        int withStandardNames = 0;
        int withStandardRefs = 0;
        int withCategoryLimits = 0;

        for (final ing in ingredients) {
          if (ing.standardizedName != null &&
              ing.standardizedName!.isNotEmpty) {
            withStandardNames++;
          }
          if (ing.standardReference != null &&
              ing.standardReference!.isNotEmpty) {
            withStandardRefs++;
          }
          if (ing.maxInclusionJson != null &&
              ing.maxInclusionJson!.isNotEmpty) {
            withCategoryLimits++;
          }
        }

        report['standardizedDataStats'] = {
          'withStandardizedNames': withStandardNames,
          'withStandardReferences': withStandardRefs,
          'withCategoryLimits': withCategoryLimits,
        };

        // Verify separated variants exist
        final fishMealVariants = ingredients.where(
          (i) => i.name?.contains('Fish meal') == true,
        );
        if (fishMealVariants.length < 3) {
          report['warnings'].add(
            'Expected 3 fish meal variants, found ${fishMealVariants.length}',
          );
        }
      }

      final hasIssues = (report['issues'] as List).isNotEmpty;
      report['status'] = hasIssues ? 'FAILED' : 'PASSED';

      AppLogger.info(
        'Data integrity check: ${report['status']}',
        tag: _tag,
      );

      if (hasIssues) {
        AppLogger.warning(
          'Issues found: ${report['issues']}',
          tag: _tag,
        );
      }

      return report;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Data integrity verification failed',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return {
        'status': 'ERROR',
        'error': e.toString(),
      };
    }
  }

  /// Clear all existing ingredients from database
  ///
  /// **WARNING:** This is destructive and cannot be undone!
  /// Use only during development or controlled migration.
  Future<void> _clearExistingIngredients() async {
    try {
      final db = await _database.database;
      await db.delete(IngredientsRepository.tableName);
      AppLogger.warning('Cleared all existing ingredients', tag: _tag);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear existing ingredients',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Create verification report markdown file
  ///
  /// Generates a detailed report of data integrity check and saves to doc/.
  Future<String> generateVerificationReport(
    Map<String, dynamic> verificationResult,
  ) async {
    final buffer = StringBuffer();

    buffer.writeln('# Data Import Verification Report');
    buffer.writeln();
    buffer.writeln('**Date:** ${verificationResult['timestamp']}');
    buffer.writeln('**Dataset:** ${verificationResult['dataset']}');
    buffer.writeln('**Status:** ${verificationResult['status']}');
    buffer.writeln();

    buffer.writeln('## Summary');
    buffer.writeln();
    buffer.writeln('- Total ingredients: ${verificationResult['totalCount']}');

    if (verificationResult.containsKey('standardizedDataStats')) {
      final stats = verificationResult['standardizedDataStats'];
      buffer.writeln();
      buffer.writeln('### Standardized Data Coverage');
      buffer.writeln(
        '- Ingredients with standardized names: ${stats['withStandardizedNames']}',
      );
      buffer.writeln(
        '- Ingredients with standard references: ${stats['withStandardReferences']}',
      );
      buffer.writeln(
        '- Ingredients with category-specific limits: ${stats['withCategoryLimits']}',
      );
    }

    if ((verificationResult['issues'] as List).isNotEmpty) {
      buffer.writeln();
      buffer.writeln('## Issues (${verificationResult['issues'].length})');
      buffer.writeln();
      for (final issue in verificationResult['issues']) {
        buffer.writeln('- ❌ $issue');
      }
    }

    if ((verificationResult['warnings'] as List).isNotEmpty) {
      buffer.writeln();
      buffer.writeln('## Warnings (${verificationResult['warnings'].length})');
      buffer.writeln();
      for (final warning in verificationResult['warnings']) {
        buffer.writeln('- ⚠️ $warning');
      }
    }

    if (verificationResult['status'] == 'PASSED') {
      buffer.writeln();
      buffer.writeln('## ✅ Verification Passed');
      buffer.writeln();
      buffer.writeln('All data integrity checks passed successfully.');
    } else {
      buffer.writeln();
      buffer.writeln('## ❌ Verification Failed');
      buffer.writeln();
      buffer
          .writeln('Please review issues above and re-import data if needed.');
    }

    return buffer.toString();
  }
}

/// Provider for DataImportService
final dataImportService = Provider<DataImportService>((ref) {
  final ingredientsRepo = ref.watch(ingredientsRepository);
  final database = ref.watch(appDatabase);
  return DataImportService(ingredientsRepo, database);
});

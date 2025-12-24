import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final csvImportRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return CsvImportRepository(db);
});

/// Repository for CSV import operations
class CsvImportRepository implements Repository {
  final AppDatabase db;

  CsvImportRepository(this.db);

  static const String _tag = 'CsvImportRepository';

  /// Batch insert new ingredients (from CSV)
  ///
  /// Returns list of created ingredient IDs
  Future<List<int>> batchInsertIngredients(List<Ingredient> ingredients) async {
    try {
      AppLogger.info(
        'Batch inserting ${ingredients.length} ingredients',
        tag: _tag,
      );

      final insertedIds = <int>[];

      for (final ingredient in ingredients) {
        try {
          final json = ingredient.toJson();
          // Remove ID to allow auto-increment
          json.remove('ingredient_id');

          final id = await db.insertOne('ingredients', json);
          insertedIds.add(id);

          AppLogger.debug(
            'Inserted ingredient: ${ingredient.name} (ID: $id)',
            tag: _tag,
          );
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to insert ingredient ${ingredient.name}: $e',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          // Continue with next ingredient instead of failing entire batch
        }
      }

      AppLogger.info(
        'Batch insert complete: $insertedIds.length/${ingredients.length} succeeded',
        tag: _tag,
      );

      return insertedIds;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Batch insert failed: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'batchInsert',
        message: 'Failed to batch insert ingredients',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Batch update existing ingredients (from CSV - for replacements)
  ///
  /// Returns number of updated ingredients
  Future<int> batchUpdateIngredients(List<Ingredient> ingredients) async {
    try {
      AppLogger.info(
        'Batch updating ${ingredients.length} ingredients',
        tag: _tag,
      );

      int updatedCount = 0;

      for (final ingredient in ingredients) {
        if (ingredient.ingredientId == null) {
          AppLogger.warning(
            'Skipping update: ingredient ${ingredient.name} has no ID',
            tag: _tag,
          );
          continue;
        }

        try {
          final json = ingredient.toJson();
          final rows = await db.update(
            'ingredients',
            'ingredient_id',
            ingredient.ingredientId!,
            json,
          );

          if (rows > 0) {
            updatedCount += rows;
            AppLogger.debug(
              'Updated ingredient: ${ingredient.name}',
              tag: _tag,
            );
          }
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to update ingredient ${ingredient.name}: $e',
            tag: _tag,
            error: e,
            stackTrace: stackTrace,
          );
          // Continue with next ingredient
        }
      }

      AppLogger.info(
        'Batch update complete: $updatedCount/${ingredients.length} succeeded',
        tag: _tag,
      );

      return updatedCount;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Batch update failed: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'batchUpdate',
        message: 'Failed to batch update ingredients',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Find ingredient by name (for duplicate detection)
  Future<Ingredient?> findByName(String name) async {
    try {
      final results = await db.selectByParam(
        'ingredients',
        query: 'name',
        param: name,
      );

      if (results.isEmpty) return null;

      AppLogger.debug(
        'Found ingredient by name: $name',
        tag: _tag,
      );

      return Ingredient.fromJson(results.first);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to find ingredient by name: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Find multiple ingredients by names
  Future<List<Ingredient>> findByNames(List<String> names) async {
    try {
      final results = <Ingredient>[];

      for (final name in names) {
        final ingredient = await findByName(name);
        if (ingredient != null) {
          results.add(ingredient);
        }
      }

      AppLogger.debug(
        'Found ${results.length}/${names.length} ingredients by name',
        tag: _tag,
      );

      return results;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to find ingredients by names: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get all existing ingredients for duplicate detection
  @override
  Future<List<Ingredient>> getAll() async {
    try {
      final raw = await db.selectAll('ingredients');
      final ingredients = raw.map((item) => Ingredient.fromJson(item)).toList();

      AppLogger.debug(
        'Retrieved ${ingredients.length} existing ingredients',
        tag: _tag,
      );

      return ingredients;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all ingredients: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  @override
  Future<int> create(Map<String, dynamic> placeData) async {
    try {
      final result = await db.insert(
        tableName: 'ingredients',
        columns: 'name, crude_protein',
        values: placeData,
      );
      return result;
    } catch (e, stackTrace) {
      throw RepositoryException(
        operation: 'create',
        message: 'Failed to create ingredient',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> update(Map<String, dynamic> placeData, num id) async {
    try {
      return await db.update('ingredients', 'ingredient_id', id, placeData);
    } catch (e, stackTrace) {
      throw RepositoryException(
        operation: 'update',
        message: 'Failed to update ingredient with ID: $id',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> delete(num id) async {
    try {
      return await db.delete(
        tableName: 'ingredients',
        query: 'ingredient_id',
        param: id,
      );
    } catch (e, stackTrace) {
      throw RepositoryException(
        operation: 'delete',
        message: 'Failed to delete ingredient with ID: $id',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Ingredient?> getSingle(int id) async {
    try {
      final raw = await db.select('ingredients', 'ingredient_id', id);
      if (raw.isEmpty) return null;
      return Ingredient.fromJson(raw.first);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get ingredient $id: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

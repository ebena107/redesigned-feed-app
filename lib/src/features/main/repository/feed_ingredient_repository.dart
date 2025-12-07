import 'dart:async';

import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedIngredientRepositoryProvider =
    FutureProvider((ref) => ref.watch(feedIngredientRepository).getAll());
final feedIngredientRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return FeedIngredientRepository(db);
});

class FeedIngredientRepository implements Repository {
  FeedIngredientRepository(this.db);

  AppDatabase db;

  static const tableName = 'feed_ingredients';

  static const colId = 'id';
  static const colFeedId = 'feed_id';
  static const colIngredientId = 'ingredient_id';
  static const colQuantity = 'quantity';
  static const colPrice = 'price_unit_kg';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colFeedId INTEGER NOT NULL, '
      '$colIngredientId INTEGER NOT NULL, '
      '$colQuantity REAL NOT NULL, '
      '$colPrice REAL NOT NULL, '
      'FOREIGN KEY($colFeedId) REFERENCES ${FeedIngredientRepository.tableName}(${FeedIngredientRepository.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION,'
      'FOREIGN KEY($colIngredientId) REFERENCES ${IngredientsCategoryRepository.tableName}(${IngredientsCategoryRepository.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION'
      ')';

  static const columns =
      '$colId, $colFeedId, $colIngredientId, $colQuantity, $colPrice';

  //static final columnsString = columns.join(',');

  Future<int> deleteByFeedId(id) async {
    try {
      final result =
          await db.delete(tableName: tableName, query: colFeedId, param: id);
      debugPrint(
          'FeedIngredientRepository: Deleted ingredients for feed $id, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error deleting ingredients for feed $id: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<int> deleteByIngredientId(
      {required num feedId, required num ingredientId}) async {
    try {
      final result = await db.deleteWithTwoId(
          tableName: tableName,
          query: '$colFeedId = ? AND $colIngredientId = ?',
          param: [feedId, ingredientId]);
      debugPrint(
          'FeedIngredientRepository: Deleted ingredient $ingredientId from feed $feedId, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error deleting ingredient $ingredientId from feed $feedId: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<int> create(placeData) async {
    try {
      final result = await db.insert(
        tableName: tableName,
        columns: columns,
        values: placeData,
      );
      debugPrint(
          'FeedIngredientRepository: Created feed ingredient with ID: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error creating feed ingredient: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<int> delete(id) async {
    try {
      final result = await db.delete(
          tableName: tableName, query: colIngredientId, param: id);
      debugPrint(
          'FeedIngredientRepository: Deleted ingredient $id, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('FeedIngredientRepository: Error deleting ingredient $id: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<List<FeedIngredients>> getAll() async {
    try {
      final List<Map<String, Object?>> raw = await db.selectAll(tableName);
      debugPrint(
          'FeedIngredientRepository: Retrieved ${raw.length} feed ingredients');
      return raw.map((item) => FeedIngredients.fromJson(item)).toList();
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error getting all feed ingredients: $e');
      debugPrint('Stack trace: $stackTrace');
      return []; // Return empty list on error
    }
  }

  @override
  Future<List<FeedIngredients>> getSingle(int id) async {
    try {
      final raw = await db.select(tableName, colFeedId, id);
      debugPrint(
          'FeedIngredientRepository: Retrieved ${raw.length} ingredients for feed $id');
      return raw.map((item) => FeedIngredients.fromJson(item)).toList();
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error getting ingredients for feed $id: $e');
      debugPrint('Stack trace: $stackTrace');
      return []; // Return empty list on error
    }
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    try {
      final result = await db.update(tableName, colId, id, placeData);
      debugPrint(
          'FeedIngredientRepository: Updated feed ingredient $id, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          'FeedIngredientRepository: Error updating feed ingredient $id: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

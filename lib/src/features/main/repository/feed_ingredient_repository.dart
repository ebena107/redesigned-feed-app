import 'dart:async';

import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';

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

  debugPrint(error) {
    // TODO: implement debugPrint
    throw " ******* feed repository loading feed - $error";
  }

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
    return await db.delete(tableName: tableName, query: colFeedId, param: id);
  }

  Future<int> deleteByIngredientId(
      {required num feedId, required num ingredientId}) async {
    debugPrint('deleting ==== feedId: $feedId and ingredient: $ingredientId');

    final int0 = await db.deleteWithTwoId(
        tableName: tableName,
        query: '$colFeedId = ? AND $colIngredientId = ?',
        param: [feedId, ingredientId]);
    debugPrint(int0.toString());
    return int0;
  }

  @override
  Future<int> create(placeData) async {
    return db.insert(
      tableName: tableName,
      columns: columns,
      values: placeData,
    );
  }

  @override
  Future<int> delete(id) async {
    return await db.delete(
        tableName: tableName, query: colIngredientId, param: id);
  }

  @override
  Future<List<FeedIngredients>> getAll() async {
    final List<Map<String, Object?>> raw = await db.selectAll(tableName);

    return raw.map((item) => FeedIngredients.fromJson(item)).toList();
  }

  @override
  Future<List<FeedIngredients?>> getSingle(int id) async {
    final raw = (await db.select(tableName, colFeedId, id));

    //if (raw.isEmpty) return null;
    return raw.map((item) => FeedIngredients.fromJson(item)).toList();
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    return db.update(tableName, colId, id, placeData);
  }
}

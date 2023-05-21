import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ingredientsRepositoryProvider =
    FutureProvider((ref) => ref.watch(ingredientsRepository).getAll());

final ingredientsRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return IngredientsRepository(db);
});

class IngredientsRepository implements Repository {
  IngredientsRepository(this.db);

  final AppDatabase db;

  static const tableName = 'ingredients';

  static const colId = 'ingredient_id';
  static const colName = 'name';
  static const colCrudeProtein = 'crude_protein';
  static const colCrudeFiber = 'crude_fiber';
  static const colCrudeFat = 'crude_fat';
  static const colCalcium = 'calcium';
  static const colPhosphorus = 'phosphorus';
  static const colLysine = 'lysine';
  static const colMethionine = 'methionine';
  static const colMeGrowingPig = 'me_growing_pig';
  static const colMeAdultPig = 'me_adult_pig';
  static const colMePoultry = 'me_poultry';
  static const colMeRuminant = 'me_ruminant';
  static const colMeRabbit = 'me_rabbit';
  static const colDeSalmonids = 'de_salmonids';
  static const colPriceKg = 'price_kg';
  static const colAvailableQty = 'available_qty';
  static const colCategoryId = 'category_id';
  static const colFavourite = 'favourite';
  static const colTimestamp = 'timestamp';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colName TEXT, '
      '$colCrudeProtein REAL, '
      '$colCrudeFiber REAL, '
      '$colCrudeFat REAL, '
      '$colCalcium REAL, '
      '$colPhosphorus REAL, '
      '$colLysine REAL, '
      '$colMethionine REAL, '
      '$colMeGrowingPig INTEGER, '
      '$colMeAdultPig INTEGER, '
      '$colMePoultry INTEGER, '
      '$colMeRuminant INTEGER, '
      '$colMeRabbit INTEGER, '
      '$colDeSalmonids INTEGER, '
      '$colPriceKg REAL, '
      '$colAvailableQty REAL, '
      '$colCategoryId INTEGER, '
      '$colFavourite INTEGER, '
      '''$colTimestamp INTEGER DEFAULT (cast(strftime('%s','now') as INT)), '''
      'FOREIGN KEY($colCategoryId) REFERENCES ${IngredientsCategoryRepository.tableName}(${IngredientsCategoryRepository.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION'
      ')';

  static const priceUpdateQuery =
      'UPDATE $tableName SET $colPriceKg = ?, $colAvailableQty = ?, $colFavourite = ? WHERE $colId = ?';

  static const columns =
      '$colId, $colName, $colCrudeProtein, $colCrudeFiber, $colCrudeFat, $colCalcium, $colPhosphorus, $colLysine, $colMethionine, $colMeGrowingPig, $colMeAdultPig, $colMePoultry, $colMeRuminant, $colMeRabbit, $colDeSalmonids, $colPriceKg, $colAvailableQty, $colCategoryId, $colFavourite, $colTimestamp';

  Future<void> updateStoredIngredient(
      Map<String, Object?> placeData, num id) async {
    return db.updateByQuery(query: priceUpdateQuery, param: [placeData]);
  }

  @override
  Future<int> create(placeData) async {
    return db.insert(tableName: tableName, columns: columns, values: placeData);
  }

  @override
  Future<int> delete(id) async {
    return db.delete(tableName: tableName, query: colId, param: id);
  }

  @override
  Future<List<Ingredient>> getAll() async {
    final List<Map<String, Object?>> raw = await db.selectAll(tableName);

    return raw.map((item) => Ingredient.fromJson(item)).toList();
  }

  @override
  Future<Ingredient?> getSingle(int id) async {
    final raw = (await db.select(tableName, colId, id));

    if (raw.isEmpty) return null;
    return Ingredient.fromJson(raw.first);
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    return db.update(tableName, colId, id, placeData);
  }
}

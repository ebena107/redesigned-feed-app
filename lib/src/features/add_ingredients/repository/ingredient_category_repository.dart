import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ingredientsCategoryProvider =
    FutureProvider((ref) => ref.watch(ingredientsCategoryRepository).getAll());

final ingredientsCategoryRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return IngredientsCategoryRepository(db);
});

class IngredientsCategoryRepository implements Repository {
  IngredientsCategoryRepository(this.db);

  final AppDatabase db;

  static const tableName = 'category';

  static const colId = 'category_id';
  static const colCategory = 'category';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colCategory TEXT'
      ')';
  static const columns = '$colId, $colCategory';

  @override
  Future<int> create(placeData) async {
    return db.insert(tableName: tableName, columns: columns, values: placeData);
  }

  @override
  Future<int> delete(id) async {
    return db.delete(tableName: tableName, query: colId, param: id);
  }

  @override
  Future<List<IngredientCategory>> getAll() async {
    final List<Map<String, Object?>> raw = await db.selectAll(tableName);

    return raw.map((item) => IngredientCategory.fromJson(item)).toList();
  }

  @override
  Future<IngredientCategory?> getSingle(int id) async {
    final raw = (await db.select(tableName, colId, id));

    if (raw.isEmpty) return null;
    return IngredientCategory.fromJson(raw.first);
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    return db.update(tableName, colId, id, placeData);
  }
}

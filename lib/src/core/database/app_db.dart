import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_update_feed/repository/animal_type_repository.dart';

import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;

import 'initial_data_uploader.dart';

const dbFileName = 'feed_app_db';

final appDatabase = Provider<AppDatabase>((ref) => throw UnimplementedError());

class AppDatabase {
  AppDatabase(this._database);

  final Database _database;

  Future<int> insert({
    required String tableName,
    required String columns,
    required Map<String, Object?> values,
  }) async {

    //return _database .rawInsert('INSERT INTO $tableName ($columns) VALUES($values)');
    return _database.insert(tableName, values);
  }

  Future<int> insertOne(String tableName, placeData) async {
    return _database.insert(tableName, placeData);
  }

  Future<int> insertByParam({
    required String tableName,
    required String columns,
    required values,
  }) async {
    return _database
        .rawInsert('INSERT INTO $tableName ($columns) VALUES($values)');
  }

  Future<Future<int>> deleteByParam({
    required String tableName,
    required String query,
    required param,
  }) async {
    return _database.delete(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> update(String tableName, String colId, num id,
      Map<String, Object?> placeData) async {
    return _database
        .update(tableName, placeData, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> updateById(
    String tableName,
    Map<String, Object?> placeData, {
    required String query,
    required param,
  }) async {
    return _database
        .update(tableName, placeData, where: '$query = ?', whereArgs: [param]);
  }

  Future<void> updateByQuery({
    required String query,
    required param,
  }) async {
    _database.rawUpdate(query, [param]);
  }

  Future<List<Map<String, Object?>>> selectAll(
    String tableName,
  ) async {
    return _database.query(tableName);
  }

  Future<List<Map<String, Object?>>> select(
    String tableName,
    String query,
    int id,
  ) async {
    return _database.query(tableName, where: '$query = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> selectByParam(
    String tableName, {
    required String query,
    required param,
  }) async {
    return _database.query(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> delete(
      {required String tableName,
      required String query,
      required param}) async {
    return _database.delete(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> deleteWithTwoId(
      {required String tableName,
      required String query,
      required param}) async {
    return _database.rawDelete('DELETE FROM $tableName WHERE $query ', param);
  }

  Future<int> getBiggestIdFromTasks() async {
    var table = await _database.rawQuery("SELECT MAX(id)+1 as id FROM tasks");
    int id = table.first["id"] == null ? 1 : table.first["id"] as int;
    return id;
  }
}

Future<Database> createDatabase() async {
  final dbFolder = await getDatabasesPath();
  final dbPath = path.join(dbFolder, dbFileName);

  return openDatabase(
    version: 1,
    dbPath,
    onCreate: (db, version) async {
      await _createAll(db);
    },
  );
}

/// this should be run when the database is being created
/// and populate the tables with initial data
Future<void> _createAll(Database db) async {
  await db.execute(IngredientsRepository.tableCreateQuery);
  await db.execute(IngredientsCategoryRepository.tableCreateQuery);
  await db.execute(AnimalTypeRepository.tableCreateQuery);
  await db.execute(FeedRepository.tableCreateQuery);
  await db.execute(FeedIngredientRepository.tableCreateQuery);

  await _populateTables(db);
}

///Load initial data from Json in assets folder, and load them into db.
Future _populateTables(Database db) async {
  var ingredients = await loadIngredientJson();
  var categories = await loadCategoryJson();
  var animalType = await loadAnimalTypeJson();

  Batch batch = db.batch();
  ingredients
      .map((e) => {batch.insert(IngredientsRepository.tableName, e.toJson())})
      .toList();
  categories
      .map((c) =>
          {batch.insert(IngredientsCategoryRepository.tableName, c.toJson())})
      .toList();
  animalType
      .map((c) => {batch.insert(AnimalTypeRepository.tableName, c.toJson())})
      .toList();

  List<dynamic> result = await batch.commit();
  //


  //await batch.commit();
}

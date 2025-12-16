import 'dart:convert';
import 'dart:io';

import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_update_feed/repository/animal_type_repository.dart';

import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'initial_data_uploader.dart';

const dbFileName = 'feed_app_db';

final appDatabase = Provider<AppDatabase>((ref) => AppDatabase());

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();

  // Current database version - increment when adding migrations
  static const int _currentVersion = 6;

  factory AppDatabase() => _instance;

  AppDatabase._() {
    _initDb();
  }

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreignKeys = ON');
  }

  // Future<Database> _initDb() async {
  //   final dbFolder = await getDatabasesPath();
  //   final dbPath = path.join(dbFolder, dbFileName);
  //
  //   return openDatabase(
  //     version: 1,
  //     dbPath,
  //     onConfigure: onConfigure,
  //     onCreate: (db, version) async {
  //       await _createAll(db);
  //     },
  //   );
  // }

  Future<Database> _initDb() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentsDir.path, "databases", dbFileName);
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: _currentVersion,
          onCreate: (db, version) async {
            await _createAll(db);
          },
          onUpgrade: _onUpgrade,
        ),
      );
      return winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, dbFileName);
      final iOSAndroidDB = await openDatabase(
        path,
        version: _currentVersion,
        onCreate: (db, version) async {
          await _createAll(db);
        },
        onUpgrade: _onUpgrade,
      );
      return iOSAndroidDB;
    }
    throw Exception("Unsupported platform");
  }

  /// Handles database upgrades from old versions to new versions
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from version $oldVersion to $newVersion');

    // Run migrations sequentially
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _runMigration(db, version);
    }
  }

  /// Runs a specific migration based on version number
  Future<void> _runMigration(Database db, int version) async {
    debugPrint('Running migration to version $version');

    switch (version) {
      case 2:
        await _migrationV1ToV2(db);
        break;
      case 3:
        await _migrationV2ToV3(db);
        break;
      case 4:
        await _migrationV3ToV4(db);
        break;
      case 5:
        await _migrationV4ToV5(db);
        break;
      case 6:
        await _migrationV5ToV6(db);
        break;
      // Add future migrations here
      default:
        debugPrint('No migration defined for version $version');
    }
  }

  /// Migration from v1 to v2: Fix rice bran fiber value
  Future<void> _migrationV1ToV2(Database db) async {
    debugPrint('Migration 1→2: Fixing rice bran fiber value');

    // Fix rice bran fiber value (was 0.0, should be ~11.5)
    await db.execute('''
      UPDATE ${IngredientsRepository.tableName}
      SET fiber = 11.5
      WHERE LOWER(name) LIKE '%rice bran%' AND (fiber = 0.0 OR fiber IS NULL)
    ''');

    debugPrint('Migration 1→2: Complete');
  }

  /// Migration from v2 to v3: Add new ingredients
  Future<void> _migrationV2ToV3(Database db) async {
    debugPrint('Migration 2→3: Adding new ingredients');

    try {
      // Load new ingredients from JSON
      final String jsonString =
          await rootBundle.loadString('assets/raw/new_ingredients.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // Insert new ingredients
      Batch batch = db.batch();
      for (var ingredientData in jsonData) {
        batch.insert(
          IngredientsRepository.tableName,
          ingredientData,
          conflictAlgorithm: ConflictAlgorithm.ignore, // Skip if already exists
        );
      }
      await batch.commit(noResult: true);

      debugPrint('Migration 2→3: Added ${jsonData.length} new ingredients');
    } catch (e) {
      debugPrint('Migration 2→3: Error loading new ingredients: $e');
      // Don't fail the migration if new ingredients can't be loaded
    }

    debugPrint('Migration 2→3: Complete');
  }

  /// Migration from v3 to v4: Add custom ingredient support
  Future<void> _migrationV3ToV4(Database db) async {
    debugPrint('Migration 3→4: Adding custom ingredient fields');

    try {
      // Add new columns to ingredients table
      await db.execute('''
        ALTER TABLE ${IngredientsRepository.tableName}
        ADD COLUMN is_custom INTEGER DEFAULT 0
      ''');

      await db.execute('''
        ALTER TABLE ${IngredientsRepository.tableName}
        ADD COLUMN created_by TEXT
      ''');

      await db.execute('''
        ALTER TABLE ${IngredientsRepository.tableName}
        ADD COLUMN created_date INTEGER
      ''');

      await db.execute('''
        ALTER TABLE ${IngredientsRepository.tableName}
        ADD COLUMN notes TEXT
      ''');

      debugPrint('Migration 3→4: Custom ingredient fields added successfully');
    } catch (e, stackTrace) {
      debugPrint('Migration 3→4: Error adding custom ingredient fields: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }

    debugPrint('Migration 3→4: Complete');
  }

  /// Migration from v4 to v5: Add enhanced nutrient columns
  Future<void> _migrationV4ToV5(Database db) async {
    debugPrint('Migration 4→5: Adding enhanced nutrient columns');

    // Helper to add a column if it does not already exist
    Future<void> addColumn(String name, String type) async {
      try {
        await db.execute(
            'ALTER TABLE ${IngredientsRepository.tableName} ADD COLUMN $name $type');
      } catch (e) {
        debugPrint('Migration 4→5: Column $name may already exist: $e');
      }
    }

    await addColumn('ash', 'REAL');
    await addColumn('moisture', 'REAL');
    await addColumn('starch', 'REAL');
    await addColumn('bulk_density', 'REAL');
    await addColumn('total_phosphorus', 'REAL');
    await addColumn('available_phosphorus', 'REAL');
    await addColumn('phytate_phosphorus', 'REAL');
    await addColumn('me_finishing_pig', 'INTEGER');
    await addColumn('amino_acids_total', 'TEXT');
    await addColumn('amino_acids_sid', 'TEXT');
    await addColumn('energy', 'TEXT');
    await addColumn('anti_nutritional_factors', 'TEXT');
    await addColumn('max_inclusion_pct', 'REAL');
    await addColumn('warning', 'TEXT');
    await addColumn('regulatory_note', 'TEXT');

    debugPrint('Migration 4→5: Complete');
  }

  /// Migration from v5 to v6: Add energy column
  Future<void> _migrationV5ToV6(Database db) async {
    debugPrint('Migration 5→6: Adding energy column');

    // Helper to add a column if it does not already exist
    Future<void> addColumn(String name, String type) async {
      try {
        await db.execute(
            'ALTER TABLE ${IngredientsRepository.tableName} ADD COLUMN $name $type');
      } catch (e) {
        debugPrint('Migration 5→6: Column $name may already exist: $e');
      }
    }

    await addColumn('energy', 'TEXT');

    debugPrint('Migration 5→6: Complete');
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

    await batch.commit();
    //

    debugPrint('**************DB created');
  }

  Future<int> insert({
    required String tableName,
    required String columns,
    required Map<String, Object?> values,
  }) async {
    //return _database .rawInsert('INSERT INTO $tableName ($columns) VALUES($values)');
    return _database!.insert(tableName, values);
  }

  Future<int> insertOne(String tableName, placeData) async {
    return _database!.insert(tableName, placeData);
  }

  Future<int> insertByParam({
    required String tableName,
    required String columns,
    required values,
  }) async {
    return _database!
        .rawInsert('INSERT INTO $tableName ($columns) VALUES($values)');
  }

  Future<Future<int>> deleteByParam({
    required String tableName,
    required String query,
    required param,
  }) async {
    return _database!
        .delete(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> update(String tableName, String colId, num id,
      Map<String, Object?> placeData) async {
    return _database!
        .update(tableName, placeData, where: '$colId = ?', whereArgs: [id]);
  }

  Future<int> updateById(
    String tableName,
    Map<String, Object?> placeData, {
    required String query,
    required param,
  }) async {
    return _database!
        .update(tableName, placeData, where: '$query = ?', whereArgs: [param]);
  }

  Future<void> updateByQuery({
    required String query,
    required param,
  }) async {
    _database!.rawUpdate(query, [param]);
  }

  Future<List<Map<String, Object?>>> selectAll(
    String tableName,
  ) async {
    return _database!.query(tableName);
  }

  Future<List<Map<String, Object?>>> select(
    String tableName,
    String query,
    int id,
  ) async {
    return _database!.query(tableName, where: '$query = ?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> selectByParam(
    String tableName, {
    required String query,
    required param,
  }) async {
    return _database!.query(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> delete(
      {required String tableName,
      required String query,
      required param}) async {
    return _database!
        .delete(tableName, where: '$query = ?', whereArgs: [param]);
  }

  Future<int> deleteWithTwoId(
      {required String tableName,
      required String query,
      required param}) async {
    return _database!.rawDelete('DELETE FROM $tableName WHERE $query ', param);
  }

  Future<int> getBiggestIdFromTasks() async {
    var table = await _database!.rawQuery("SELECT MAX(id)+1 as id FROM tasks");
    int id = table.first["id"] == null ? 1 : table.first["id"] as int;
    return id;
  }
}

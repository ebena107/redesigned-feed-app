import 'dart:convert';
import 'dart:io';

// TODO: Integrate DatabaseTimeout utility for async operation timeout handling
// import 'package:feed_estimator/src/core/database/database_timeout.dart';
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
  static const int _currentVersion = 16;

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
      try {
        sqfliteFfiInit();
      } catch (e) {
        if (Platform.isWindows) {
          throw Exception('SQLite3 library initialization failed on Windows.\n'
              'This is typically caused by missing native libraries.\n'
              'Please ensure you have run: flutter pub get\n'
              'And that sqlite3_flutter_libs package is properly configured.\n'
              'Error details: $e');
        } else {
          throw Exception('SQLite3 library initialization failed on Linux.\n'
              'Please ensure you have the required system libraries installed.\n'
              'Error details: $e');
        }
      }

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
      case 7:
        await _migrationV6ToV7(db);
        break;
      case 8:
        await _migrationV7ToV8(db);
        break;
      case 9:
        await _migrationV8ToV9(db);
        break;
      case 10:
        await _migrationV9ToV10(db);
        break;
      case 11:
        await _migrationV10ToV11(db);
        break;
      case 12:
        await _migrationV11ToV12(db);
        break;
      case 13:
        await _migrationV12ToV13(db);
        break;
      case 14:
        await _migrationV13ToV14(db);
        break;
      case 15:
        await _migrationV14ToV15(db);
        break;
      case 16:
        await _migrationV15ToV16(db);
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

  /// Migration from v6 to v7: Populate energy field from JSON
  Future<void> _migrationV6ToV7(Database db) async {
    debugPrint(
        'Migration 6→7: Populating energy field for existing ingredients');

    try {
      // Load ingredient data from JSON
      final ingredients = await loadIngredientJson();

      // Update each ingredient with energy data
      Batch batch = db.batch();
      for (var ingredient in ingredients) {
        if (ingredient.energy != null) {
          final energyJson = jsonEncode(ingredient.energy!.toJson());
          batch.update(
            IngredientsRepository.tableName,
            {'energy': energyJson},
            where: '${IngredientsRepository.colId} = ?',
            whereArgs: [ingredient.ingredientId],
          );
        }
      }

      await batch.commit(noResult: true);
      debugPrint(
          'Migration 6→7: Updated ${ingredients.length} ingredients with energy data');
    } catch (e) {
      debugPrint('Migration 6→7: Error updating energy field: $e');
      rethrow;
    }

    debugPrint('Migration 6→7: Complete');
  }

  /// Migration from v7 to v8: Add performance indexes
  Future<void> _migrationV7ToV8(Database db) async {
    debugPrint('Migration 7→8: Adding performance indexes');

    try {
      // Add index on category_id for faster category filtering
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_ingredients_category_id
        ON ${IngredientsRepository.tableName}(${IngredientsRepository.colCategoryId})
      ''');

      // Add index on is_custom for filtering custom vs standard ingredients
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_ingredients_is_custom
        ON ${IngredientsRepository.tableName}(${IngredientsRepository.colIsCustom})
      ''');

      // Add index on name for search functionality
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_ingredients_name
        ON ${IngredientsRepository.tableName}(${IngredientsRepository.colName})
      ''');

      debugPrint('Migration 7→8: Added 3 performance indexes');
    } catch (e) {
      debugPrint('Migration 7→8: Error creating indexes: $e');
      rethrow;
    }

    debugPrint('Migration 7→8: Complete');
  }

  /// Migration from v8 to v9: Add standardized dataset support columns
  Future<void> _migrationV8ToV9(Database db) async {
    debugPrint('Migration 8→9: Adding standardized dataset support columns');

    Future<void> addColumn(String name, String type,
        {String? defaultValue}) async {
      try {
        final ddl =
            'ALTER TABLE ${IngredientsRepository.tableName} ADD COLUMN ';
        final stmt = defaultValue == null
            ? '$ddl$name $type'
            : '$ddl$name $type DEFAULT $defaultValue';
        await db.execute(stmt);
      } catch (e) {
        debugPrint('Migration 8→9: Column $name may already exist: $e');
      }
    }

    // New columns for standards and limits
    await addColumn('standardized_name', 'TEXT');
    await addColumn('standard_reference', 'TEXT');
    await addColumn('is_standards_based', 'INTEGER', defaultValue: '0');
    await addColumn('separation_notes', 'TEXT');
    await addColumn('max_inclusion_json', 'TEXT');

    // Optional index to speed up searches by standardized name
    try {
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_ingredients_standardized_name
        ON ${IngredientsRepository.tableName}(standardized_name)
      ''');
    } catch (e) {
      debugPrint('Migration 8→9: Error creating index: $e');
    }

    debugPrint('Migration 8→9: Complete');
  }

  /// Migration from v9 to v10: Add production_stage column to feeds table
  Future<void> _migrationV9ToV10(Database db) async {
    debugPrint('Migration 9→10: Adding production_stage column to feeds table');

    try {
      await db.execute('''
        ALTER TABLE ${FeedRepository.tableName}
        ADD COLUMN ${FeedRepository.colProductionStage} TEXT
      ''');

      debugPrint('Migration 9→10: production_stage column added successfully');
    } catch (e) {
      debugPrint('Migration 9→10: Error adding production_stage column: $e');
      rethrow;
    }

    debugPrint('Migration 9→10: Complete');
  }

  /// Migration from v10 to v11: Create price_history table
  Future<void> _migrationV10ToV11(Database db) async {
    debugPrint('Migration 10→11: Creating price_history table');

    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS price_history (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          ingredient_id INTEGER NOT NULL,
          price REAL NOT NULL,
          currency TEXT NOT NULL DEFAULT 'NGN',
          effective_date INTEGER NOT NULL,
          source TEXT DEFAULT 'user',
          notes TEXT,
          created_at INTEGER NOT NULL,
          FOREIGN KEY(ingredient_id) REFERENCES ${IngredientsRepository.tableName}(${IngredientsRepository.colId})
            ON DELETE CASCADE ON UPDATE NO ACTION
        )
      ''');

      // Add index for faster lookups
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_price_history_ingredient_id
        ON price_history(ingredient_id)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_price_history_effective_date
        ON price_history(effective_date)
      ''');

      debugPrint('Migration 10→11: price_history table created successfully');
    } catch (e) {
      debugPrint('Migration 10→11: Error creating price_history table: $e');
      rethrow;
    }

    debugPrint('Migration 10→11: Complete');
  }

  /// Migration from v11 to v12: Add regional tagging support
  /// Adds "region" column to ingredients table to support geographic categorization
  /// Regions: Africa, Asia, Europe, Americas, Oceania, Global (multi-region support via comma-separated values)
  Future<void> _migrationV11ToV12(Database db) async {
    debugPrint('Migration 11→12: Adding region column to ingredients table');

    try {
      // Add region column with default value 'Global'
      await db.execute('''
        ALTER TABLE ${IngredientsRepository.tableName}
        ADD COLUMN ${IngredientsRepository.colRegion} TEXT DEFAULT 'Global'
      ''');

      // Create index for fast region-based queries
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_ingredients_region
        ON ${IngredientsRepository.tableName}(${IngredientsRepository.colRegion})
      ''');

      debugPrint('Migration 11→12: region column added successfully');
    } catch (e) {
      debugPrint('Migration 11→12: Error adding region column: $e');
      rethrow;
    }

    debugPrint('Migration 11→12: Complete');
  }

  /// Migration from v12 to v13: Fix foreign key references in feed_ingredients
  /// CRITICAL: Corrects self-reference bug that caused feed data to become orphaned
  /// This migration recreates the feed_ingredients table with correct foreign keys
  Future<void> _migrationV12ToV13(Database db) async {
    debugPrint('Migration 12→13: Fixing feed_ingredients foreign keys');

    try {
      // SQLite doesn't support ALTER TABLE to modify constraints
      // Must recreate table with correct foreign keys

      // Step 1: Rename old table
      await db.execute('''
        ALTER TABLE feed_ingredients RENAME TO feed_ingredients_old
      ''');

      debugPrint('Migration 12→13: Old table renamed');

      // Step 2: Create new table with correct foreign keys
      await db.execute('''
        CREATE TABLE feed_ingredients (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          feed_id INTEGER NOT NULL,
          ingredient_id INTEGER NOT NULL,
          quantity REAL NOT NULL,
          price_unit_kg REAL NOT NULL,
          FOREIGN KEY(feed_id) REFERENCES ${FeedRepository.tableName}(${FeedRepository.colId})
            ON DELETE CASCADE ON UPDATE NO ACTION,
          FOREIGN KEY(ingredient_id) REFERENCES ${IngredientsRepository.tableName}(${IngredientsRepository.colId})
            ON DELETE CASCADE ON UPDATE NO ACTION
        )
      ''');

      debugPrint(
          'Migration 12→13: New table created with correct foreign keys');

      // Step 3: Copy data from old table to new table
      await db.execute('''
        INSERT INTO feed_ingredients (id, feed_id, ingredient_id, quantity, price_unit_kg)
        SELECT id, feed_id, ingredient_id, quantity, price_unit_kg
        FROM feed_ingredients_old
      ''');

      debugPrint('Migration 12→13: Data copied from old table');

      // Step 4: Drop old table
      await db.execute('DROP TABLE feed_ingredients_old');

      debugPrint('Migration 12→13: Old table dropped');
      debugPrint('Migration 12→13: Foreign keys corrected, all data preserved');
    } catch (e, stackTrace) {
      debugPrint('Migration 12→13: Error fixing foreign keys: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }

    debugPrint('Migration 12→13: Complete');
  }

  /// Migration from v13 to v14: Backfill v5 nutrient fields and energy JSON
  /// Ensures existing ingredient rows get harmonized data for enhanced calculations
  Future<void> _migrationV13ToV14(Database db) async {
    debugPrint('Migration 13→14: Backfilling v5 nutrient fields');

    try {
      final ingredients = await loadIngredientJson();
      final batch = db.batch();

      for (final ingredient in ingredients) {
        final id = ingredient.ingredientId;
        if (id == null) continue;

        final data = <String, Object?>{};

        void put(String key, Object? value) {
          if (value != null) data[key] = value;
        }

        // Legacy + v5 nutrient values
        put('crude_protein', ingredient.crudeProtein);
        put('crude_fiber', ingredient.crudeFiber);
        put('crude_fat', ingredient.crudeFat);
        put('calcium', ingredient.calcium);
        put('phosphorus', ingredient.phosphorus);
        put('lysine', ingredient.lysine);
        put('methionine', ingredient.methionine);
        put('me_growing_pig', ingredient.meGrowingPig);
        put('me_adult_pig', ingredient.meAdultPig);
        put('me_poultry', ingredient.mePoultry);
        put('me_ruminant', ingredient.meRuminant);
        put('me_rabbit', ingredient.meRabbit);
        put('de_salmonids', ingredient.deSalmonids);
        put('ash', ingredient.ash);
        put('moisture', ingredient.moisture);
        put('starch', ingredient.starch);
        put('bulk_density', ingredient.bulkDensity);
        put('total_phosphorus', ingredient.totalPhosphorus);
        put('available_phosphorus', ingredient.availablePhosphorus);
        put('phytate_phosphorus', ingredient.phytatePhosphorus);
        put('me_finishing_pig', ingredient.meFinishingPig);

        // JSON fields
        if (ingredient.aminoAcidsTotal != null) {
          put('amino_acids_total',
              jsonEncode(ingredient.aminoAcidsTotal!.toJson()));
        }
        if (ingredient.aminoAcidsSid != null) {
          put('amino_acids_sid',
              jsonEncode(ingredient.aminoAcidsSid!.toJson()));
        }
        if (ingredient.energy != null) {
          put('energy', jsonEncode(ingredient.energy!.toJson()));
        }
        if (ingredient.antiNutritionalFactors != null) {
          put('anti_nutritional_factors',
              jsonEncode(ingredient.antiNutritionalFactors!.toJson()));
        }

        put('max_inclusion_pct', ingredient.maxInclusionPct);
        if (ingredient.maxInclusionJson != null) {
          put('max_inclusion_json', jsonEncode(ingredient.maxInclusionJson));
        }
        put('warning', ingredient.warning);
        put('regulatory_note', ingredient.regulatoryNote);
        put('region', ingredient.region);

        if (data.isNotEmpty) {
          batch.update(
            IngredientsRepository.tableName,
            data,
            where: '${IngredientsRepository.colId} = ?',
            whereArgs: [id],
          );
        }
      }

      await batch.commit(noResult: true);
      debugPrint('Migration 13→14: Backfill complete');
    } catch (e, stackTrace) {
      debugPrint('Migration 13→14: Error backfilling v5 fields: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Migration from v15 to v16: Update animal_types with complete list
  /// Clears old 5 animal types and repopulates with all 9 animal types
  Future<void> _migrationV15ToV16(Database db) async {
    debugPrint('Migration 15→16: Updating animal_types table');

    try {
      // Clear existing animal types
      await db.execute('DELETE FROM ${AnimalTypeRepository.tableName}');
      debugPrint('Migration 15→16: Cleared existing animal types');

      // Load new animal types from JSON
      final animalTypes = await loadAnimalTypeJson();
      final batch = db.batch();

      for (final animalType in animalTypes) {
        batch.insert(
          AnimalTypeRepository.tableName,
          animalType.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      await batch.commit(noResult: true);
      debugPrint(
          'Migration 15→16: Successfully inserted ${animalTypes.length} animal types');
    } catch (e, stackTrace) {
      debugPrint('Migration 15→16: Error updating animal types: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }

    debugPrint('Migration 15→16: Complete');
  }

  /// Migration from v14 to v15: Create formulation_history table
  /// Adds database persistence for feed formulation results
  Future<void> _migrationV14ToV15(Database db) async {
    debugPrint('Migration 14→15: Creating formulation_history table');

    try {
      // Create formulation_history table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS formulation_history (
          id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          animal_type_id INTEGER NOT NULL,
          feed_type TEXT,
          formulation_name TEXT,
          created_at INTEGER NOT NULL,
          constraints_json TEXT NOT NULL,
          selected_ingredient_ids TEXT NOT NULL,
          result_json TEXT NOT NULL,
          status TEXT NOT NULL,
          cost_per_kg REAL NOT NULL,
          notes TEXT,
          FOREIGN KEY(animal_type_id) REFERENCES ${AnimalTypeRepository.tableName}(${AnimalTypeRepository.colId})
            ON DELETE CASCADE ON UPDATE NO ACTION
        )
      ''');

      debugPrint('Migration 14→15: formulation_history table created');

      // Add indexes for performance
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_formulation_history_animal_type
        ON formulation_history(animal_type_id)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_formulation_history_created_at
        ON formulation_history(created_at DESC)
      ''');

      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_formulation_history_status
        ON formulation_history(status)
      ''');

      debugPrint('Migration 14→15: Added 3 performance indexes');
      debugPrint('Migration 14→15: Complete');
    } catch (e, stackTrace) {
      debugPrint(
          'Migration 14→15: Error creating formulation_history table: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// this should be run when the database is being created
  /// and populate the tables with initial data
  Future<void> _createAll(Database db) async {
    await db.execute(IngredientsRepository.tableCreateQuery);
    await db.execute(IngredientsCategoryRepository.tableCreateQuery);
    await db.execute(AnimalTypeRepository.tableCreateQuery);
    await db.execute(FeedRepository.tableCreateQuery);
    await db.execute(FeedIngredientRepository.tableCreateQuery);

    // Create price_history table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS price_history (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        ingredient_id INTEGER NOT NULL,
        price REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT 'NGN',
        effective_date INTEGER NOT NULL,
        source TEXT DEFAULT 'user',
        notes TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(ingredient_id) REFERENCES ${IngredientsRepository.tableName}(${IngredientsRepository.colId})
          ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

    // Create formulation_history table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS formulation_history (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        animal_type_id INTEGER NOT NULL,
        feed_type TEXT,
        formulation_name TEXT,
        created_at INTEGER NOT NULL,
        constraints_json TEXT NOT NULL,
        selected_ingredient_ids TEXT NOT NULL,
        result_json TEXT NOT NULL,
        status TEXT NOT NULL,
        cost_per_kg REAL NOT NULL,
        notes TEXT,
        FOREIGN KEY(animal_type_id) REFERENCES ${AnimalTypeRepository.tableName}(${AnimalTypeRepository.colId})
          ON DELETE CASCADE ON UPDATE NO ACTION
      )
    ''');

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

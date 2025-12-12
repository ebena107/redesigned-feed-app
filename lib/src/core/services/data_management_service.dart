import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:convert';

/// Service for managing user data (deletion, export, import)
class DataManagementService {
  final AppDatabase _db = AppDatabase();

  /// Delete all user-generated data
  Future<void> deleteAllUserData() async {
    try {
      final database = await _db.database;

      // Delete all feeds
      await database.delete('feeds');
      debugPrint('Deleted all feeds');

      // Delete all feed ingredients
      await database.delete('feed_ingredients');
      debugPrint('Deleted all feed ingredients');

      // Delete custom ingredients (keep pre-loaded ones)
      await database.delete(
        'ingredients',
        where: 'is_custom = ?',
        whereArgs: [1],
      );
      debugPrint('Deleted all custom ingredients');

      // Delete all results (if table exists)
      try {
        await database.delete('results');
        debugPrint('Deleted all results');
      } catch (e) {
        debugPrint('Results table does not exist, skipping deletion');
      }

      // Clear shared preferences (except privacy consent)
      final prefs = await SharedPreferences.getInstance();
      final consentStatus = prefs.getBool('privacy_consent');
      final consentDate = prefs.getInt('privacy_consent_date');
      final seenDialog = prefs.getBool('privacy_seen_dialog');

      await prefs.clear();

      // Restore privacy consent status
      if (consentStatus != null) {
        await prefs.setBool('privacy_consent', consentStatus);
      }
      if (consentDate != null) {
        await prefs.setInt('privacy_consent_date', consentDate);
      }
      if (seenDialog != null) {
        await prefs.setBool('privacy_seen_dialog', seenDialog);
      }

      debugPrint('Data deletion completed successfully');
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      rethrow;
    }
  }

  /// Export all user data to JSON
  Future<Map<String, dynamic>> exportAllData() async {
    try {
      final database = await _db.database;

      // Export feeds
      final feedsData = await database.query('feeds');
      final feeds = feedsData.map((f) => Feed.fromJson(f)).toList();

      // Export feed ingredients
      final feedIngredientsData = await database.query('feed_ingredients');
      final feedIngredients = feedIngredientsData
          .map((fi) => FeedIngredients.fromJson(fi))
          .toList();

      // Export custom ingredients
      final customIngredientsData = await database.query(
        'ingredients',
        where: 'is_custom = ?',
        whereArgs: [1],
      );
      final customIngredients =
          customIngredientsData.map((i) => Ingredient.fromJson(i)).toList();

      // Export results (if table exists)
      List<Map<String, dynamic>> resultsData = [];
      try {
        resultsData = await database.query('results');
      } catch (e) {
        debugPrint('Results table does not exist, skipping export');
      }

      // Get app preferences
      final prefs = await SharedPreferences.getInstance();
      final preferences = prefs.getKeys().fold<Map<String, dynamic>>(
        {},
        (map, key) {
          // Exclude privacy-related keys from export
          if (!key.startsWith('privacy_')) {
            final value = prefs.get(key);
            map[key] = value;
          }
          return map;
        },
      );

      final exportData = {
        'export_version': '1.0',
        'export_date': DateTime.now().toIso8601String(),
        'app_version': '0.1.1',
        'data': {
          'feeds': feeds.map((f) => f.toJson()).toList(),
          'feed_ingredients': feedIngredients.map((fi) => fi.toJson()).toList(),
          'custom_ingredients':
              customIngredients.map((i) => i.toJson()).toList(),
          'results': resultsData,
          'preferences': preferences,
        },
        'statistics': {
          'total_feeds': feeds.length,
          'total_custom_ingredients': customIngredients.length,
          'total_results': resultsData.length,
        },
      };

      debugPrint('Data export completed successfully');
      return exportData;
    } catch (e) {
      debugPrint('Error exporting data: $e');
      rethrow;
    }
  }

  /// Export data to JSON file
  Future<File> exportDataToFile() async {
    try {
      final exportData = await exportAllData();
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'feed_estimator_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      // Write to file
      await file.writeAsString(jsonString);

      debugPrint('Data exported to file: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('Error exporting data to file: $e');
      rethrow;
    }
  }

  /// Import data from JSON
  Future<void> importData(Map<String, dynamic> importData) async {
    try {
      final database = await _db.database;

      // Validate import data
      if (!importData.containsKey('data')) {
        throw Exception('Invalid import data format');
      }

      final data = importData['data'] as Map<String, dynamic>;

      // Import feeds
      if (data.containsKey('feeds')) {
        final feedsList = data['feeds'] as List;
        for (final feedJson in feedsList) {
          final feed = Feed.fromJson(feedJson);
          await database.insert(
            'feeds',
            feed.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        debugPrint('Imported ${feedsList.length} feeds');
      }

      // Import feed ingredients
      if (data.containsKey('feed_ingredients')) {
        final ingredientsList = data['feed_ingredients'] as List;
        for (final ingredientJson in ingredientsList) {
          final ingredient = FeedIngredients.fromJson(ingredientJson);
          await database.insert(
            'feed_ingredients',
            ingredient.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        debugPrint('Imported ${ingredientsList.length} feed ingredients');
      }

      // Import custom ingredients
      if (data.containsKey('custom_ingredients')) {
        final customIngredientsList = data['custom_ingredients'] as List;
        for (final ingredientJson in customIngredientsList) {
          final ingredient = Ingredient.fromJson(ingredientJson);
          await database.insert(
            'ingredients',
            ingredient.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        debugPrint(
            'Imported ${customIngredientsList.length} custom ingredients');
      }

      // Import results (if table exists)
      if (data.containsKey('results')) {
        try {
          final resultsList = data['results'] as List;
          for (final resultJson in resultsList) {
            await database.insert(
              'results',
              resultJson as Map<String, dynamic>,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          debugPrint('Imported ${resultsList.length} results');
        } catch (e) {
          debugPrint('Results table does not exist, skipping import: $e');
        }
      }

      // Import preferences (excluding privacy settings)
      if (data.containsKey('preferences')) {
        final prefs = await SharedPreferences.getInstance();
        final preferences = data['preferences'] as Map<String, dynamic>;

        for (final entry in preferences.entries) {
          // Skip privacy-related keys
          if (entry.key.startsWith('privacy_')) continue;

          final value = entry.value;
          if (value is bool) {
            await prefs.setBool(entry.key, value);
          } else if (value is int) {
            await prefs.setInt(entry.key, value);
          } else if (value is double) {
            await prefs.setDouble(entry.key, value);
          } else if (value is String) {
            await prefs.setString(entry.key, value);
          } else if (value is List<String>) {
            await prefs.setStringList(entry.key, value);
          }
        }
        debugPrint('Imported preferences');
      }

      debugPrint('Data import completed successfully');
    } catch (e) {
      debugPrint('Error importing data: $e');
      rethrow;
    }
  }

  /// Import data from JSON file
  Future<void> importDataFromFile(File file) async {
    try {
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      await importData(data);

      debugPrint('Data imported from file: ${file.path}');
    } catch (e) {
      debugPrint('Error importing data from file: $e');
      rethrow;
    }
  }

  /// Get data statistics
  Future<Map<String, int>> getDataStatistics() async {
    try {
      final database = await _db.database;
      debugPrint('=== Getting Data Statistics ===');

      // Query feeds count
      final feedsResult =
          await database.rawQuery('SELECT COUNT(*) as count FROM feeds');
      final feedsCount = feedsResult.first['count'] as int? ?? 0;
      debugPrint('Feeds count: $feedsCount');

      // Query custom ingredients count
      final customIngredientsResult = await database.rawQuery(
        'SELECT COUNT(*) as count FROM ingredients WHERE is_custom = 1',
      );
      final customIngredientsCount =
          customIngredientsResult.first['count'] as int? ?? 0;
      debugPrint('Custom ingredients count: $customIngredientsCount');

      // Query results count (wrapped in try-catch as table might not exist)
      int resultsCount = 0;
      try {
        final resultsResult =
            await database.rawQuery('SELECT COUNT(*) as count FROM results');
        resultsCount = resultsResult.first['count'] as int? ?? 0;
        debugPrint('Results count: $resultsCount');
      } catch (e) {
        debugPrint('Results table query failed (table might not exist): $e');
      }

      final stats = {
        'feeds': feedsCount,
        'custom_ingredients': customIngredientsCount,
        'results': resultsCount,
      };

      debugPrint('Final statistics: $stats');
      return stats;
    } catch (e, stackTrace) {
      debugPrint('ERROR getting data statistics: $e');
      debugPrint('Stack trace: $stackTrace');
      return {
        'feeds': 0,
        'custom_ingredients': 0,
        'results': 0,
      };
    }
  }

  /// Get database size in bytes
  Future<int> getDatabaseSize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = '${directory.path}/feed_app_db.db';
      final file = File(dbPath);

      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting database size: $e');
      return 0;
    }
  }

  /// Format bytes to human-readable string
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

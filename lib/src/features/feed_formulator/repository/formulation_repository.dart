import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulation_record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formulationRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabase);
  return FormulationRepository(db);
});

class FormulationRepository {
  FormulationRepository(this.db);
  final AppDatabase db;

  static const String _tag = 'FormulationRepository';
  static const String tableName = 'formulation_history';

  static const String colId = 'id';
  static const String colAnimalTypeId = 'animal_type_id';
  static const String colFeedType = 'feed_type';
  static const String colFormulationName = 'formulation_name';
  static const String colCreatedAt = 'created_at';
  static const String colConstraintsJson = 'constraints_json';
  static const String colSelectedIngredientIds = 'selected_ingredient_ids';
  static const String colResultJson = 'result_json';
  static const String colStatus = 'status';
  static const String colCostPerKg = 'cost_per_kg';
  static const String colNotes = 'notes';

  /// Save a new formulation record
  Future<int> save(FormulationRecord record) async {
    try {
      final database = await db.database;
      final id = await database.insert(tableName, record.toJson());
      AppLogger.info('Saved formulation with ID: $id', tag: _tag);
      return id;
    } catch (e, stackTrace) {
      AppLogger.error('Error saving formulation: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'save',
        message: 'Failed to save formulation',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get a formulation by ID
  Future<FormulationRecord?> getById(int id) async {
    try {
      final database = await db.database;
      final results = await database.query(
        tableName,
        where: '$colId = ?',
        whereArgs: [id],
      );

      if (results.isEmpty) {
        AppLogger.warning('No formulation found with ID: $id', tag: _tag);
        return null;
      }

      return FormulationRecord.fromJson(results.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting formulation $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Get all formulations
  Future<List<FormulationRecord>> getAll() async {
    try {
      final database = await db.database;
      final results = await database.query(
        tableName,
        orderBy: '$colCreatedAt DESC',
      );

      AppLogger.debug('Retrieved ${results.length} formulations', tag: _tag);
      return results.map((json) => FormulationRecord.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all formulations: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'getAll',
        message: 'Failed to retrieve formulations',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get formulations by animal type
  Future<List<FormulationRecord>> getByAnimalType(int animalTypeId) async {
    try {
      final database = await db.database;
      final results = await database.query(
        tableName,
        where: '$colAnimalTypeId = ?',
        whereArgs: [animalTypeId],
        orderBy: '$colCreatedAt DESC',
      );

      AppLogger.debug(
        'Retrieved ${results.length} formulations for animal type $animalTypeId',
        tag: _tag,
      );
      return results.map((json) => FormulationRecord.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting formulations by animal type: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'getByAnimalType',
        message:
            'Failed to retrieve formulations for animal type $animalTypeId',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get recent formulations
  Future<List<FormulationRecord>> getRecent({int limit = 10}) async {
    try {
      final database = await db.database;
      final results = await database.query(
        tableName,
        orderBy: '$colCreatedAt DESC',
        limit: limit,
      );

      AppLogger.debug('Retrieved ${results.length} recent formulations',
          tag: _tag);
      return results.map((json) => FormulationRecord.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting recent formulations: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'getRecent',
        message: 'Failed to retrieve recent formulations',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update a formulation record
  Future<int> update(FormulationRecord record) async {
    if (record.id == null) {
      throw ArgumentError('Cannot update formulation without ID');
    }

    try {
      final database = await db.database;
      final rowsAffected = await database.update(
        tableName,
        record.toJson(),
        where: '$colId = ?',
        whereArgs: [record.id],
      );

      AppLogger.info(
          'Updated formulation ${record.id}, rows affected: $rowsAffected',
          tag: _tag);
      return rowsAffected;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating formulation ${record.id}: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'update',
        message: 'Failed to update formulation ${record.id}',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a formulation by ID
  Future<int> delete(int id) async {
    try {
      final database = await db.database;
      final rowsAffected = await database.delete(
        tableName,
        where: '$colId = ?',
        whereArgs: [id],
      );

      AppLogger.info('Deleted formulation $id, rows affected: $rowsAffected',
          tag: _tag);
      return rowsAffected;
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting formulation $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'delete',
        message: 'Failed to delete formulation $id',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get count of formulations
  Future<int> getCount() async {
    try {
      final database = await db.database;
      final result =
          await database.rawQuery('SELECT COUNT(*) as count FROM $tableName');
      return result.first['count'] as int;
    } catch (e, stackTrace) {
      AppLogger.error('Error getting formulation count: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      return 0;
    }
  }
}

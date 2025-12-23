import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../add_update_feed/repository/animal_type_repository.dart';

//final feedRepositoryProvider = FutureProvider((ref) => ref.watch(feedRepository).getAll());

final feedRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return FeedRepository(db);
});

List<Feed> feedList = [];

class FeedRepository implements Repository {
  FeedRepository(this.db);
  final AppDatabase db;

  static const String _tag = 'FeedRepository';
  static const tableName = 'feeds';

  static const colId = 'feed_id';
  static const colFeedName = 'feed_name';
  static const colAnimalTypeId = 'animal_id';
  static const colProductionStage = 'production_stage';
  static const colTimestampModified = 'timestamp_modified';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colFeedName TEXT NOT NULL UNIQUE, '
      '$colAnimalTypeId INTEGER NOT NULL, '
      '$colProductionStage TEXT, '
      '''$colTimestampModified INTEGER DEFAULT (cast(strftime('%s','now') as INT)), '''
      'FOREIGN KEY($colAnimalTypeId) REFERENCES ${AnimalTypeRepository.tableName}(${AnimalTypeRepository.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION'
      ')';

  static const feedCreateQuery = 'INSERT INTO $tableName( '
      '$columns ) VALUES (';

  static const columns =
      '$colId, $colFeedName, $colAnimalTypeId, $colProductionStage, $colTimestampModified';
  static const columnsCreate = [
    colFeedName,
    colAnimalTypeId,
    colProductionStage,
    colTimestampModified
  ];

  // static final columnsStringUpdate = columns.join(',');
  static final columnsStringCreate = columnsCreate.join(',');

  @override
  Future<int> create(placeData) async {
    try {
      final result = await db.insert(
        tableName: tableName,
        columns: columns,
        values: placeData,
      );
      AppLogger.info('Created feed with ID: $result', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error creating feed: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'create',
        message: 'Failed to create feed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<int> insertOne(Feed placeData) async {
    try {
      final result = await db.insertOne(tableName, placeData);
      AppLogger.info('Inserted feed: ${placeData.feedName}', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error inserting feed ${placeData.feedName}: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'insert',
        message: 'Failed to insert feed: ${placeData.feedName}',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<Feed>> getAll() async {
    try {
      final List<Map<String, Object?>> raw = await db.selectAll(tableName);
      AppLogger.debug('Retrieved ${raw.length} feeds', tag: _tag);
      return raw.map((item) => Feed.fromJson(item)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all feeds: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'getAll',
        message: 'Failed to retrieve feeds',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Feed?> getSingle(int id) async {
    try {
      final raw = await db.select(tableName, colId, id);

      if (raw.isEmpty) {
        AppLogger.warning('No feed found with ID: $id', tag: _tag);
        return null;
      }

      AppLogger.debug('Retrieved feed with ID: $id', tag: _tag);
      return Feed.fromJson(raw.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting feed $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null; // Return null on error instead of crashing
    }
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    try {
      final result = await db.update(tableName, colId, id, placeData);
      AppLogger.info('Updated feed $id, rows affected: $result', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating feed $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'update',
        message: 'Failed to update feed with ID: $id',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Feed?> getSingleByName(String? feedName) async {
    if (feedName == null || feedName.isEmpty) {
      AppLogger.warning('Invalid feed name provided', tag: _tag);
      return null;
    }

    try {
      final raw = await db.selectByParam(tableName,
          query: colFeedName, param: feedName);

      if (raw.isEmpty) {
        AppLogger.warning('No feed found with name: $feedName', tag: _tag);
        return null;
      }

      AppLogger.debug('Retrieved feed: $feedName', tag: _tag);
      return Feed.fromJson(raw.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting feed by name $feedName: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<int> delete(feedId) async {
    try {
      final result =
          await db.delete(tableName: tableName, query: colId, param: feedId);
      AppLogger.info('Deleted feed $feedId, rows affected: $result', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting feed $feedId: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'delete',
        message: 'Failed to delete feed with ID: $feedId',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}

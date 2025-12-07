import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:flutter/foundation.dart';
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

  static const tableName = 'feeds';

  static const colId = 'feed_id';
  static const colFeedName = 'feed_name';
  static const colAnimalTypeId = 'animal_id';
  static const colTimestampModified = 'timestamp_modified';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colFeedName TEXT NOT NULL UNIQUE, '
      '$colAnimalTypeId INTEGER NOT NULL, '
      '''$colTimestampModified INTEGER DEFAULT (cast(strftime('%s','now') as INT)), '''
      'FOREIGN KEY($colAnimalTypeId) REFERENCES ${AnimalTypeRepository.tableName}(${AnimalTypeRepository.colId}) ON DELETE NO ACTION ON UPDATE NO ACTION'
      ')';

  static const feedCreateQuery = 'INSERT INTO $tableName( '
      '$columns ) VALUES (';

  static const columns =
      '$colId, $colFeedName, $colAnimalTypeId, $colTimestampModified';
  static const columnsCreate = [
    colFeedName,
    colAnimalTypeId,
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
      debugPrint('FeedRepository: Created feed with ID: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error creating feed: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<int> insertOne(Feed placeData) async {
    try {
      final result = await db.insertOne(tableName, placeData);
      debugPrint('FeedRepository: Inserted feed: ${placeData.feedName}');
      return result;
    } catch (e, stackTrace) {
      debugPrint(
          'FeedRepository: Error inserting feed ${placeData.feedName}: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<List<Feed>> getAll() async {
    try {
      final List<Map<String, Object?>> raw = await db.selectAll(tableName);
      debugPrint('FeedRepository: Retrieved ${raw.length} feeds');
      return raw.map((item) => Feed.fromJson(item)).toList();
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error getting all feeds: $e');
      debugPrint('Stack trace: $stackTrace');
      return []; // Return empty list on error instead of crashing
    }
  }

  @override
  Future<Feed?> getSingle(int id) async {
    try {
      final raw = await db.select(tableName, colId, id);

      if (raw.isEmpty) {
        debugPrint('FeedRepository: No feed found with ID: $id');
        return null;
      }

      debugPrint('FeedRepository: Retrieved feed with ID: $id');
      return Feed.fromJson(raw.first);
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error getting feed $id: $e');
      debugPrint('Stack trace: $stackTrace');
      return null; // Return null on error instead of crashing
    }
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    try {
      final result = await db.update(tableName, colId, id, placeData);
      debugPrint('FeedRepository: Updated feed $id, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error updating feed $id: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Feed?> getSingleByName(String? feedName) async {
    if (feedName == null || feedName.isEmpty) {
      debugPrint('FeedRepository: Invalid feed name provided');
      return null;
    }

    try {
      final raw = await db.selectByParam(tableName,
          query: colFeedName, param: feedName);

      if (raw.isEmpty) {
        debugPrint('FeedRepository: No feed found with name: $feedName');
        return null;
      }

      debugPrint('FeedRepository: Retrieved feed: $feedName');
      return Feed.fromJson(raw.first);
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error getting feed by name $feedName: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<int> delete(feedId) async {
    try {
      final result =
          await db.delete(tableName: tableName, query: colId, param: feedId);
      debugPrint(
          'FeedRepository: Deleted feed $feedId, rows affected: $result');
      return result;
    } catch (e, stackTrace) {
      debugPrint('FeedRepository: Error deleting feed $feedId: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

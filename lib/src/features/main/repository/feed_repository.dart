import 'package:feed_estimator/src/core/database/app_db.dart';
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
    return db.insert(
      tableName: tableName,
      columns: columns,
      values: placeData,
    );
  }

  Future<int> insertOne(Feed placeData) async {
    return db.insertOne(tableName, placeData);
  }

  @override
  Future<List<Feed>> getAll() async {
    final List<Map<String, Object?>> raw = await db.selectAll(tableName);

    return raw.map((item) => Feed.fromJson(item)).toList();
  }

  @override
  Future<Feed?> getSingle(int id) async {
    final raw = (await db.select(tableName, colId, id));

    if (raw.isEmpty) return null;
    return Feed.fromJson(raw.first);
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    return db.update(tableName, colId, id, placeData);
  }

  getSingleByName(String? feedName) async {
    final raw = (await db.selectByParam(tableName,
        query: colFeedName, param: feedName));

    if (raw.isEmpty) return null;
    return Feed.fromJson(raw.first);
  }

  @override
  Future delete(feedId) {
    return db.delete(tableName: tableName, query: colId, param: feedId);
  }
}

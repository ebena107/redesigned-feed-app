import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animalTypeProvider =
    FutureProvider((ref) => ref.watch(animalTypeRepository).getAll());
final animalTypeRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return AnimalTypeRepository(db);
});

class AnimalTypeRepository implements Repository {
  AnimalTypeRepository(this.db);

  final AppDatabase db;

  static const tableName = 'animal_types';

  static const colId = 'type_id';
  static const colType = 'type';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
      '$colType TEXT'
      ')';

  static const columns = '$colId, $colType';

  //static final columnsString = columns.join(',');

  @override
  Future<int> create(placeData) async {
    return db.insert(tableName: tableName, columns: columns, values: placeData);
  }

  @override
  Future<int> delete(id) async {
    return db.delete(tableName: tableName, query: colId, param: id);
  }

  @override
  Future<List<AnimalTypes>> getAll() async {
    final List<Map<String, Object?>> raw = await db.selectAll(tableName);

    return raw.map((item) => AnimalTypes.fromJson(item)).toList();
  }

  @override
  Future<AnimalTypes?> getSingle(int id) async {
    final raw = (await db.select(tableName, colId, id));

    if (raw.isEmpty) return null;
    return AnimalTypes.fromJson(raw.first);
  }

  @override
  Future<int> update(Map<String, Object?> placeData, num id) async {
    return db.update(tableName, colId, id, placeData);
  }
}

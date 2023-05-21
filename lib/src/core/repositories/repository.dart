abstract class Repository {
  Future create(Map<String, Object?> placeData) async {}

  Future update(Map<String, Object?> placeData, num id) async {}

  Future getSingle(int id) async {}

  Future getAll() async {}

  Future delete(num id) async {}
}

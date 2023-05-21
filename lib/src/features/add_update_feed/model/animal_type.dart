import 'dart:convert';

/// type_id : 1
/// type : "Pigs"

AnimalTypes animalTypeFromJson(String str) =>
    AnimalTypes.fromJson(json.decode(str));

String animalTypeToJson(AnimalTypes data) => json.encode(data.toJson());

List<AnimalTypes> animalTypeListFromJson(String str) => List<AnimalTypes>.from(
    json.decode(str).map((x) => AnimalTypes.fromJson(x)));

String animalTypeListToJson(List<AnimalTypes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnimalTypes {
  AnimalTypes({
    this.typeId,
    this.type,
  });

  AnimalTypes.fromJson(dynamic json) {
    typeId = json['type_id'];
    type = json['type'];
  }
  num? typeId;
  String? type;

  AnimalTypes copyWith({
    num? typeId,
    String? type,
  }) =>
      AnimalTypes(
        typeId: typeId ?? this.typeId,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type_id'] = typeId;
    map['type'] = type;
    return map;
  }
}

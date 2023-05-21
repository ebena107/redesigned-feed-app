import 'dart:convert';

/// feedId : 1
/// mEnergy : 1
/// cProtein : 1.1
/// cFat : 1.1
/// cFibre : 1.1
/// calcium : 1.1
/// phosphorus : 1.1
/// lysine : 1.1
/// methionine : 1.1
/// costPerUnit : 1.1
/// totalCost : 1.1
/// totalQuantity : 1.1

Result resultFromJson(String str) => Result.fromJson(json.decode(str));
String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  Result({
    this.feedId,
    this.mEnergy,
    this.cProtein,
    this.cFat,
    this.cFibre,
    this.calcium,
    this.phosphorus,
    this.lysine,
    this.methionine,
    this.costPerUnit,
    this.totalCost,
    this.totalQuantity,
  });

  Result.fromJson(dynamic json) {
    feedId = json['feedId'];
    mEnergy = json['mEnergy'];
    cProtein = json['cProtein'];
    cFat = json['cFat'];
    cFibre = json['cFibre'];
    calcium = json['calcium'];
    phosphorus = json['phosphorus'];
    lysine = json['lysine'];
    methionine = json['methionine'];
    costPerUnit = json['costPerUnit'];
    totalCost = json['totalCost'];
    totalQuantity = json['totalQuantity'];
  }
  num? feedId;
  num? mEnergy;
  num? cProtein;
  num? cFat;
  num? cFibre;
  num? calcium;
  num? phosphorus;
  num? lysine;
  num? methionine;
  num? costPerUnit;
  num? totalCost;
  num? totalQuantity;

  Result copyWith({
    num? feedId,
    num? mEnergy,
    num? cProtein,
    num? cFat,
    num? cFibre,
    num? calcium,
    num? phosphorus,
    num? lysine,
    num? methionine,
    num? costPerUnit,
    num? totalCost,
    num? totalQuantity,
  }) =>
      Result(
        feedId: feedId ?? this.feedId,
        mEnergy: mEnergy ?? this.mEnergy,
        cProtein: cProtein ?? this.cProtein,
        cFat: cFat ?? this.cFat,
        cFibre: cFibre ?? this.cFibre,
        calcium: calcium ?? this.calcium,
        phosphorus: phosphorus ?? this.phosphorus,
        lysine: lysine ?? this.lysine,
        methionine: methionine ?? this.methionine,
        costPerUnit: costPerUnit ?? this.costPerUnit,
        totalCost: totalCost ?? this.totalCost,
        totalQuantity: totalQuantity ?? this.totalQuantity,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feedId'] = feedId;
    map['mEnergy'] = mEnergy;
    map['cProtein'] = cProtein;
    map['cFat'] = cFat;
    map['cFibre'] = cFibre;
    map['calcium'] = calcium;
    map['phosphorus'] = phosphorus;
    map['lysine'] = lysine;
    map['methionine'] = methionine;
    map['costPerUnit'] = costPerUnit;
    map['totalCost'] = totalCost;
    map['totalQuantity'] = totalQuantity;
    return map;
  }
}

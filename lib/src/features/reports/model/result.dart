import 'dart:convert';

/// feedId : 1
/// mEnergy : 1 (kcal/kg - Metabolizable or Digestible Energy)
/// cProtein : 1.1 (% dry matter)
/// cFat : 1.1 (% dry matter)
/// cFibre : 1.1 (% dry matter)
/// calcium : 1.1 (g/kg - to be verified)
/// phosphorus : 1.1 (g/kg - to be verified)
/// lysine : 1.1 (g/kg - to be verified)
/// methionine : 1.1 (g/kg - to be verified)
/// costPerUnit : 1.1 (currency per kg feed)
/// totalCost : 1.1 (currency for total feed quantity)
/// totalQuantity : 1.1 (kg)

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
  num? mEnergy; // Units: kcal/kg (Metabolizable Energy or Digestible Energy)
  num? cProtein; // Units: % dry matter (weighted average)
  num? cFat; // Units: % dry matter (weighted average)
  num? cFibre; // Units: % dry matter (weighted average)
  num? calcium; // Units: g/kg (weighted average) - VERIFY
  num? phosphorus; // Units: g/kg (weighted average) - VERIFY
  num? lysine; // Units: g/kg (weighted average) - VERIFY
  num? methionine; // Units: g/kg (weighted average) - VERIFY
  num? costPerUnit; // Units: currency per kg of feed
  num? totalCost; // Units: currency for complete feed quantity
  num? totalQuantity; // Units: kg

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

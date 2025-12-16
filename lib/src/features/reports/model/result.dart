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
    // v5 Enhanced fields (optional)
    this.ash,
    this.moisture,
    this.totalPhosphorus,
    this.availablePhosphorus,
    this.phytatePhosphorus,
    this.aminoAcidsTotalJson,
    this.aminoAcidsSidJson,
    this.warningsJson,
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
    // v5 fields
    ash = json['ash'];
    moisture = json['moisture'];
    totalPhosphorus = json['totalPhosphorus'];
    availablePhosphorus = json['availablePhosphorus'];
    phytatePhosphorus = json['phytatePhosphorus'];
    aminoAcidsTotalJson = json['aminoAcidsTotalJson'];
    aminoAcidsSidJson = json['aminoAcidsSidJson'];
    warningsJson = json['warningsJson'];
  }

  // ===== LEGACY FIELDS (v4) =====
  num? feedId;
  num? mEnergy; // Units: kcal/kg (Metabolizable Energy or Digestible Energy)
  num? cProtein; // Units: % dry matter (weighted average)
  num? cFat; // Units: % dry matter (weighted average)
  num? cFibre; // Units: % dry matter (weighted average)
  num? calcium; // Units: g/kg (weighted average)
  num? phosphorus; // Units: g/kg (weighted average)
  num? lysine; // Units: g/kg (weighted average)
  num? methionine; // Units: g/kg (weighted average)
  num? costPerUnit; // Units: currency per kg of feed
  num? totalCost; // Units: currency for complete feed quantity
  num? totalQuantity; // Units: kg

  // ===== NEW v5 FIELDS =====
  num? ash; // Units: % dry matter (weighted average)
  num? moisture; // Units: % (weighted average)
  num? totalPhosphorus; // Units: g/kg (weighted average)
  num? availablePhosphorus; // Units: g/kg (weighted average)
  num? phytatePhosphorus; // Units: g/kg (weighted average)

  // JSON strings for complex structures (decode when needed)
  String? aminoAcidsTotalJson; // Map<String, num> of all 10 amino acids (total)
  String? aminoAcidsSidJson; // Map<String, num> of all 10 amino acids (SID)
  String?
      warningsJson; // List<String> of calculation warnings and inclusions issues

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
    num? ash,
    num? moisture,
    num? totalPhosphorus,
    num? availablePhosphorus,
    num? phytatePhosphorus,
    String? aminoAcidsTotalJson,
    String? aminoAcidsSidJson,
    String? warningsJson,
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
        ash: ash ?? this.ash,
        moisture: moisture ?? this.moisture,
        totalPhosphorus: totalPhosphorus ?? this.totalPhosphorus,
        availablePhosphorus: availablePhosphorus ?? this.availablePhosphorus,
        phytatePhosphorus: phytatePhosphorus ?? this.phytatePhosphorus,
        aminoAcidsTotalJson: aminoAcidsTotalJson ?? this.aminoAcidsTotalJson,
        aminoAcidsSidJson: aminoAcidsSidJson ?? this.aminoAcidsSidJson,
        warningsJson: warningsJson ?? this.warningsJson,
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
    // v5 fields
    map['ash'] = ash;
    map['moisture'] = moisture;
    map['totalPhosphorus'] = totalPhosphorus;
    map['availablePhosphorus'] = availablePhosphorus;
    map['phytatePhosphorus'] = phytatePhosphorus;
    map['aminoAcidsTotalJson'] = aminoAcidsTotalJson;
    map['aminoAcidsSidJson'] = aminoAcidsSidJson;
    map['warningsJson'] = warningsJson;
    return map;
  }
}

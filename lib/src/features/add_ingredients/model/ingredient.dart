import 'dart:convert';

import 'amino_acids_profile.dart';
import 'energy_values.dart';
import 'anti_nutritional_factors.dart';

/// name : "Alfalfa, dehydrated, protein < 16% dry matter"
/// crude_protein : 14.1 (% dry matter)
/// crude_fiber : 28.0 (% dry matter)
/// crude_fat : 2.1 (% dry matter)
/// calcium : 20.1 (g/kg or % - see notes)
/// phosphorus : 2.4 (g/kg or % - see notes)
/// lysine : 5.6 (g/kg or % - see notes)
/// methionine : 1.2 (g/kg or % - see notes)
/// me_growing_pig : 1590 (kcal/kg - metabolizable energy)
/// me_adult_pig : 1680 (kcal/kg)
/// me_poultry : 1070 (kcal/kg)
/// me_ruminant : 1910 (kcal/kg)
/// me_rabbit : 1630 (kcal/kg)
/// de_salmonids : 2160 (kcal/kg - digestible energy for fish)
/// price_kg : 0.01 (currency units)
/// available_qty : 0.01 (kg or tonnes)
/// category_id : 13

Ingredient ingredientFromJson(String str) =>
    Ingredient.fromJson(json.decode(str));
String ingredientToJson(Ingredient data) => json.encode(data.toJson());

List<Ingredient> ingredientListFromJson(String str) =>
    List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromJson(x)));

String ingredientListToJson(List<Ingredient> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingredient {
  Ingredient({
    this.ingredientId,
    this.name,
    this.crudeProtein,
    this.crudeFiber,
    this.crudeFat,
    this.calcium,
    this.phosphorus,
    this.lysine,
    this.methionine,
    this.meGrowingPig,
    this.meAdultPig,
    this.mePoultry,
    this.meRuminant,
    this.meRabbit,
    this.deSalmonids,
    this.priceKg,
    this.availableQty,
    this.categoryId,
    this.favourite,
    this.isCustom,
    this.createdBy,
    this.createdDate,
    this.notes,
    // v5 fields
    this.ash,
    this.moisture,
    this.starch,
    this.bulkDensity,
    this.totalPhosphorus,
    this.availablePhosphorus,
    this.phytatePhosphorus,
    this.meFinishingPig,
    this.aminoAcidsTotal,
    this.aminoAcidsSid,
    this.energy,
    this.antiNutritionalFactors,
    this.maxInclusionPct,
    this.warning,
    this.regulatoryNote,
  });

  Ingredient.fromJson(dynamic json) {
    ingredientId = json['ingredient_id'];
    name = json['name'];
    crudeProtein = json['crude_protein'];
    crudeFiber = json['crude_fiber'];
    crudeFat = json['crude_fat'];
    calcium = json['calcium'];
    phosphorus = json['phosphorus'];
    lysine = json['lysine'];
    methionine = json['methionine'];
    meGrowingPig = json['me_growing_pig'];
    meAdultPig = json['me_adult_pig'];
    mePoultry = json['me_poultry'];
    meRuminant = json['me_ruminant'];
    meRabbit = json['me_rabbit'];
    deSalmonids = json['de_salmonids'];
    priceKg = json['price_kg'];
    availableQty = json['available_qty'];
    categoryId = json['category_id'];
    favourite = json['favourite'];
    isCustom = json['is_custom'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    notes = json['notes'];
    // v5 fields
    ash = json['ash'];
    moisture = json['moisture'];
    starch = json['starch'];
    bulkDensity = json['bulk_density'];
    totalPhosphorus = json['total_phosphorus'];
    availablePhosphorus = json['available_phosphorus'];
    phytatePhosphorus = json['phytate_phosphorus'];
    meFinishingPig = json['me_finishing_pig'];
    aminoAcidsTotal = json['amino_acids_total'] != null
        ? AminoAcidsProfile.fromJson(json['amino_acids_total'])
        : null;
    aminoAcidsSid = json['amino_acids_sid'] != null
        ? AminoAcidsProfile.fromJson(json['amino_acids_sid'])
        : null;
    energy =
        json['energy'] != null ? EnergyValues.fromJson(json['energy']) : null;
    antiNutritionalFactors = json['anti_nutritional_factors'] != null
        ? AntiNutritionalFactors.fromJson(json['anti_nutritional_factors'])
        : null;
    maxInclusionPct = json['max_inclusion_pct'];
    warning = json['warning'];
    regulatoryNote = json['regulatory_note'];
  }

  // ===== LEGACY FIELDS (v4) =====
  num? ingredientId;
  String? name;
  num? crudeProtein; // Units: % dry matter (DM)
  num? crudeFiber; // Units: % dry matter (DM)
  num? crudeFat; // Units: % dry matter (DM)
  num? calcium; // Units: g/kg
  num? phosphorus; // Units: g/kg (LEGACY: total - use totalPhosphorus for v5)
  num? lysine; // Units: g/kg (LEGACY: total - use aminoAcidsTotal for v5)
  num? methionine; // Units: g/kg (LEGACY: total - use aminoAcidsTotal for v5)
  num? meGrowingPig; // Units: kcal/kg
  num? meAdultPig; // Units: kcal/kg
  num? mePoultry; // Units: kcal/kg
  num? meRuminant; // Units: kcal/kg
  num? meRabbit; // Units: kcal/kg
  num? deSalmonids; // Units: kcal/kg
  num? priceKg; // Units: currency per kg
  num? availableQty; // Units: kg or tonnes
  num? categoryId;
  num? favourite;
  num? isCustom;
  String? createdBy;
  num? createdDate;
  String? notes;

  // ===== NEW v5 FIELDS =====
  num? ash; // Units: % dry matter
  num? moisture; // Units: %
  num? starch; // Units: % dry matter
  num? bulkDensity; // Units: kg/m³ (for practical formulation)
  num? totalPhosphorus; // Units: g/kg (total)
  num? availablePhosphorus; // Units: g/kg (available for animal)
  num? phytatePhosphorus; // Units: g/kg (bound form)
  num? meFinishingPig; // Units: kcal/kg (new energy value)

  // Complex nested structures
  AminoAcidsProfile? aminoAcidsTotal; // Total amino acids (11 amino acids)
  AminoAcidsProfile?
      aminoAcidsSid; // SID amino acids (standardized ileal digestibility)
  EnergyValues? energy; // Energy values for all animal species
  AntiNutritionalFactors? antiNutritionalFactors; // Anti-nutritional factors

  // Safety and regulatory fields
  num? maxInclusionPct; // Maximum % of total formulation (0 = unlimited)
  String? warning; // Safety warning (e.g., "High gossypol - limit to 15%")
  String? regulatoryNote; // Regulatory restrictions

  Ingredient copyWith({
    num? ingredientId,
    String? name,
    num? crudeProtein,
    num? crudeFiber,
    num? crudeFat,
    num? calcium,
    num? phosphorus,
    num? lysine,
    num? methionine,
    num? meGrowingPig,
    num? meAdultPig,
    num? mePoultry,
    num? meRuminant,
    num? meRabbit,
    num? deSalmonids,
    num? priceKg,
    num? availableQty,
    num? categoryId,
    num? favourite,
    num? isCustom,
    String? createdBy,
    num? createdDate,
    String? notes,
  }) =>
      Ingredient(
        ingredientId: ingredientId ?? this.ingredientId,
        name: name ?? this.name,
        crudeProtein: crudeProtein ?? this.crudeProtein,
        crudeFiber: crudeFiber ?? this.crudeFiber,
        crudeFat: crudeFat ?? this.crudeFat,
        calcium: calcium ?? this.calcium,
        phosphorus: phosphorus ?? this.phosphorus,
        lysine: lysine ?? this.lysine,
        methionine: methionine ?? this.methionine,
        meGrowingPig: meGrowingPig ?? this.meGrowingPig,
        meAdultPig: meAdultPig ?? this.meAdultPig,
        mePoultry: mePoultry ?? this.mePoultry,
        meRuminant: meRuminant ?? this.meRuminant,
        meRabbit: meRabbit ?? this.meRabbit,
        deSalmonids: deSalmonids ?? this.deSalmonids,
        priceKg: priceKg ?? this.priceKg,
        availableQty: availableQty ?? this.availableQty,
        categoryId: categoryId ?? this.categoryId,
        favourite: favourite ?? this.favourite,
        isCustom: isCustom ?? this.isCustom,
        createdBy: createdBy ?? this.createdBy,
        createdDate: createdDate ?? this.createdDate,
        notes: notes ?? this.notes,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ingredient_id'] = ingredientId;
    map['name'] = name;
    map['crude_protein'] = crudeProtein;
    map['crude_fiber'] = crudeFiber;
    map['crude_fat'] = crudeFat;
    map['calcium'] = calcium;
    map['phosphorus'] = phosphorus;
    map['lysine'] = lysine;
    map['methionine'] = methionine;
    map['me_growing_pig'] = meGrowingPig;
    map['me_adult_pig'] = meAdultPig;
    map['me_poultry'] = mePoultry;
    map['me_ruminant'] = meRuminant;
    map['me_rabbit'] = meRabbit;
    map['de_salmonids'] = deSalmonids;
    map['price_kg'] = priceKg;
    map['available_qty'] = availableQty;
    map['category_id'] = categoryId;
    map['favourite'] = favourite;
    map['is_custom'] = isCustom;
    map['created_by'] = createdBy;
    map['created_date'] = createdDate;
    map['notes'] = notes;
    // v5 fields
    map['ash'] = ash;
    map['moisture'] = moisture;
    map['starch'] = starch;
    map['bulk_density'] = bulkDensity;
    map['total_phosphorus'] = totalPhosphorus;
    map['available_phosphorus'] = availablePhosphorus;
    map['phytate_phosphorus'] = phytatePhosphorus;
    map['me_finishing_pig'] = meFinishingPig;
    map['amino_acids_total'] = aminoAcidsTotal?.toJson();
    map['amino_acids_sid'] = aminoAcidsSid?.toJson();
    map['energy'] = energy?.toJson();
    map['anti_nutritional_factors'] = antiNutritionalFactors?.toJson();
    map['max_inclusion_pct'] = maxInclusionPct;
    map['warning'] = warning;
    map['regulatory_note'] = regulatoryNote;
    return map;
  }
}

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
    this.standardizedName,
    this.standardReference,
    this.isStandardsBased,
    this.separationNotes,
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
    this.maxInclusionJson,
    this.warning,
    this.regulatoryNote,
  });

  factory Ingredient.fromJson(dynamic json) {
    // Helper to safely parse numeric values that may arrive as String/num
    num? asNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      if (v is String) {
        final s = v.trim();
        if (s.isEmpty) return null;
        final d = double.tryParse(s);
        if (d != null) return d;
        final i = int.tryParse(s);
        if (i != null) return i;
      }
      return null;
    }

    // Parse energy field - can be Map (from JSON file) or String (from database)
    EnergyValues? parsedEnergy;
    if (json['energy'] != null) {
      parsedEnergy = EnergyValues.fromJson(json['energy'] is String
          ? jsonDecode(json['energy'])
          : json['energy']);
    }

    // Parse aminoAcidsTotal - can be Map (from JSON file) or String (from database)
    AminoAcidsProfile? parsedAminoAcidsTotal;
    if (json['amino_acids_total'] != null) {
      try {
        parsedAminoAcidsTotal = AminoAcidsProfile.fromJson(
            json['amino_acids_total'] is String
                ? jsonDecode(json['amino_acids_total'])
                : json['amino_acids_total']);
      } catch (e) {
        // Handle malformed JSON gracefully - return null
        parsedAminoAcidsTotal = null;
      }
    }

    // Parse aminoAcidsSid - can be Map (from JSON file) or String (from database)
    AminoAcidsProfile? parsedAminoAcidsSid;
    if (json['amino_acids_sid'] != null) {
      try {
        parsedAminoAcidsSid = AminoAcidsProfile.fromJson(
            json['amino_acids_sid'] is String
                ? jsonDecode(json['amino_acids_sid'])
                : json['amino_acids_sid']);
      } catch (e) {
        // Handle malformed JSON gracefully - return null
        parsedAminoAcidsSid = null;
      }
    }

    // Parse antiNutritionalFactors - can be Map (from JSON file) or String (from database)
    AntiNutritionalFactors? parsedAntiNutritionalFactors;
    if (json['anti_nutritional_factors'] != null) {
      parsedAntiNutritionalFactors = AntiNutritionalFactors.fromJson(
          json['anti_nutritional_factors'] is String
              ? jsonDecode(json['anti_nutritional_factors'])
              : json['anti_nutritional_factors']);
    }

    // Extract legacy fields from v5 fields if not present in JSON
    // This handles the case where JSON has amino_acids_total.lysine but not top-level lysine
    final lysineValue =
        asNum(json['lysine']) ?? (parsedAminoAcidsTotal?.lysine);
    final methionineValue =
        asNum(json['methionine']) ?? (parsedAminoAcidsTotal?.methionine);
    final phosphorusValue =
        asNum(json['phosphorus']) ?? asNum(json['total_phosphorus']);

    // CRITICAL FIX: Extract legacy energy fields from v5 energy object
    // The JSON file uses the new "energy" object structure, but the calculation
    // engine still relies on legacy fields (meGrowingPig, mePoultry, etc.)
    final meGrowingPigValue =
        asNum(json['me_growing_pig']) ?? parsedEnergy?.mePig;
    final meAdultPigValue = asNum(json['me_adult_pig']) ?? parsedEnergy?.mePig;
    final mePoultryValue = asNum(json['me_poultry']) ?? parsedEnergy?.mePoultry;
    final meRuminantValue =
        asNum(json['me_ruminant']) ?? parsedEnergy?.meRuminant;
    final meRabbitValue = asNum(json['me_rabbit']) ?? parsedEnergy?.meRabbit;
    final deSalmonidsValue =
        asNum(json['de_salmonids']) ?? parsedEnergy?.deSalmonids;

    // Parse standards fields
    final String? parsedStandardizedName = json['standardized_name'];
    final String? parsedStandardReference = json['standard_reference'];
    num? parsedIsStandardsBased;
    final isStd = json['is_standards_based'];
    if (isStd is bool) {
      parsedIsStandardsBased = isStd ? 1 : 0;
    } else {
      parsedIsStandardsBased = asNum(isStd);
    }
    final String? parsedSeparationNotes = json['separation_notes'];

    // Parse max_inclusion_json which may be a JSON string or map
    Map<String, dynamic>? parsedMaxInclusionJson;
    if (json['max_inclusion_json'] != null) {
      try {
        if (json['max_inclusion_json'] is String) {
          parsedMaxInclusionJson =
              jsonDecode(json['max_inclusion_json']) as Map<String, dynamic>;
        } else if (json['max_inclusion_json'] is Map) {
          parsedMaxInclusionJson =
              Map<String, dynamic>.from(json['max_inclusion_json']);
        }
      } catch (_) {
        parsedMaxInclusionJson = null;
      }
    }

    final ingredient = Ingredient(
      // CRITICAL FIX: Handle both 'id' (from JSON file) and 'ingredient_id' (from database)
      ingredientId: asNum(json['ingredient_id'] ?? json['id']),
      name: json['name'],
      standardizedName: parsedStandardizedName,
      standardReference: parsedStandardReference,
      isStandardsBased: parsedIsStandardsBased,
      separationNotes: parsedSeparationNotes,
      crudeProtein: asNum(json['crude_protein']),
      crudeFiber: asNum(json['crude_fiber']),
      crudeFat: asNum(json['crude_fat']),
      calcium: asNum(json['calcium']),
      phosphorus: phosphorusValue,
      lysine: lysineValue,
      methionine: methionineValue,
      meGrowingPig: meGrowingPigValue,
      meAdultPig: meAdultPigValue,
      mePoultry: mePoultryValue,
      meRuminant: meRuminantValue,
      meRabbit: meRabbitValue,
      deSalmonids: deSalmonidsValue,
      priceKg: asNum(json['price_kg']),
      availableQty: asNum(json['available_qty']),
      categoryId: asNum(json['category_id']),
      favourite: asNum(json['favourite']),
      isCustom: asNum(json['is_custom']),
      createdBy: json['created_by'],
      createdDate: asNum(json['created_date']),
      notes: json['notes'],
      ash: asNum(json['ash']),
      moisture: asNum(json['moisture']),
      starch: asNum(json['starch']),
      bulkDensity: asNum(json['bulk_density']),
      totalPhosphorus: asNum(json['total_phosphorus']),
      availablePhosphorus: asNum(json['available_phosphorus']),
      phytatePhosphorus: asNum(json['phytate_phosphorus']),
      meFinishingPig: asNum(json['me_finishing_pig']),
      aminoAcidsTotal: parsedAminoAcidsTotal,
      aminoAcidsSid: parsedAminoAcidsSid,
      energy: parsedEnergy,
      antiNutritionalFactors: parsedAntiNutritionalFactors,
      maxInclusionPct: asNum(json['max_inclusion_pct']),
      maxInclusionJson: parsedMaxInclusionJson,
      warning: json['warning'],
      regulatoryNote: json['regulatory_note'],
    );

    return ingredient;
  }

  // ===== LEGACY FIELDS (v4) =====
  num? ingredientId;
  String? name;
  // v9 standardized dataset fields
  String? standardizedName;
  String? standardReference;
  num? isStandardsBased; // 0/1 flag stored as INTEGER in DB
  String? separationNotes;
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
  Map<String, dynamic>? maxInclusionJson; // Detailed per-category limits
  String? warning; // Safety warning (e.g., "High gossypol - limit to 15%")
  String? regulatoryNote; // Regulatory restrictions

  Ingredient copyWith({
    num? ingredientId,
    String? name,
    String? standardizedName,
    String? standardReference,
    num? isStandardsBased,
    String? separationNotes,
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
    // v5 fields
    num? ash,
    num? moisture,
    num? starch,
    num? bulkDensity,
    num? totalPhosphorus,
    num? availablePhosphorus,
    num? phytatePhosphorus,
    num? meFinishingPig,
    AminoAcidsProfile? aminoAcidsTotal,
    AminoAcidsProfile? aminoAcidsSid,
    EnergyValues? energy,
    AntiNutritionalFactors? antiNutritionalFactors,
    num? maxInclusionPct,
    Map<String, dynamic>? maxInclusionJson,
    String? warning,
    String? regulatoryNote,
  }) =>
      Ingredient(
        ingredientId: ingredientId ?? this.ingredientId,
        name: name ?? this.name,
        standardizedName: standardizedName ?? this.standardizedName,
        standardReference: standardReference ?? this.standardReference,
        isStandardsBased: isStandardsBased ?? this.isStandardsBased,
        separationNotes: separationNotes ?? this.separationNotes,
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
        // v5 fields
        ash: ash ?? this.ash,
        moisture: moisture ?? this.moisture,
        starch: starch ?? this.starch,
        bulkDensity: bulkDensity ?? this.bulkDensity,
        totalPhosphorus: totalPhosphorus ?? this.totalPhosphorus,
        availablePhosphorus: availablePhosphorus ?? this.availablePhosphorus,
        phytatePhosphorus: phytatePhosphorus ?? this.phytatePhosphorus,
        meFinishingPig: meFinishingPig ?? this.meFinishingPig,
        aminoAcidsTotal: aminoAcidsTotal ?? this.aminoAcidsTotal,
        aminoAcidsSid: aminoAcidsSid ?? this.aminoAcidsSid,
        energy: energy ?? this.energy,
        antiNutritionalFactors:
            antiNutritionalFactors ?? this.antiNutritionalFactors,
        maxInclusionPct: maxInclusionPct ?? this.maxInclusionPct,
        maxInclusionJson: maxInclusionJson ?? this.maxInclusionJson,
        warning: warning ?? this.warning,
        regulatoryNote: regulatoryNote ?? this.regulatoryNote,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ingredient_id'] = ingredientId;
    map['name'] = name;
    map['standardized_name'] = standardizedName;
    map['standard_reference'] = standardReference;
    map['is_standards_based'] = isStandardsBased;
    map['separation_notes'] = separationNotes;
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
    map['amino_acids_total'] =
        aminoAcidsTotal != null ? jsonEncode(aminoAcidsTotal!.toJson()) : null;
    map['amino_acids_sid'] =
        aminoAcidsSid != null ? jsonEncode(aminoAcidsSid!.toJson()) : null;
    map['energy'] = energy != null ? jsonEncode(energy!.toJson()) : null;
    map['anti_nutritional_factors'] = antiNutritionalFactors != null
        ? jsonEncode(antiNutritionalFactors!.toJson())
        : null;
    map['max_inclusion_pct'] = maxInclusionPct;
    map['max_inclusion_json'] =
        maxInclusionJson != null ? jsonEncode(maxInclusionJson) : null;
    map['warning'] = warning;
    map['regulatory_note'] = regulatoryNote;
    return map;
  }
}

import 'dart:convert';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/add_update_feed/services/inclusion_validator.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';

/// Enhanced calculation engine supporting v5 harmonized ingredients
///
/// This engine calculates comprehensive feed nutrient composition with:
/// - All 10 essential amino acids (total and SID values)
/// - Enhanced phosphorus tracking (total, available, phytate)
/// - Inclusion limit validation with warnings
/// - Anti-nutritional factor tracking
/// - Complete proximate analysis (ash, moisture, starch)
/// - Regulatory and safety warnings
class EnhancedCalculationEngine {
  /// Calculate enhanced result with all v5 features
  ///
  /// Parameters:
  /// - feedIngredients: List of ingredients in formulation
  /// - ingredientCache: Map of ingredient ID → Ingredient data
  /// - animalTypeId: Type of animal (1=growing pig, 2=poultry, etc.)
  ///
  /// Returns: Result object with all calculated values and warnings
  static Result calculateEnhancedResult({
    required List<FeedIngredients> feedIngredients,
    required Map<num, Ingredient> ingredientCache,
    required num animalTypeId,
    Map<num, double>? currentPrices,
  }) {
    final totalQuantity = _calcTotalQuantity(feedIngredients);
    if (totalQuantity <= 0 || feedIngredients.isEmpty) {
      return Result();
    }

    // Calculate legacy (v4) values
    final legacyCalcs = _calculateLegacyValues(
      feedIngredients,
      ingredientCache,
      totalQuantity,
      animalTypeId,
      currentPrices,
    );

    // Calculate enhanced (v5) values
    final enhancedCalcs = _calculateEnhancedValues(
      feedIngredients,
      ingredientCache,
      totalQuantity,
    );

    // Validate inclusion limits and anti-nutritional factors
    final inclusionValidation = InclusionValidator.validate(
      feedIngredients: feedIngredients,
      ingredientCache: ingredientCache,
      animalTypeId: animalTypeId,
    );

    // Collect all warnings
    final warnings = _collectWarnings(
      feedIngredients,
      ingredientCache,
      enhancedCalcs,
      inclusionValidation,
    );

    return Result(
      mEnergy: legacyCalcs['mEnergy'] as num?,
      cProtein: legacyCalcs['cProtein'] as num?,
      cFat: legacyCalcs['cFat'] as num?,
      cFibre: legacyCalcs['cFibre'] as num?,
      calcium: legacyCalcs['calcium'] as num?,
      phosphorus: legacyCalcs['phosphorus'] as num?,
      lysine: legacyCalcs['lysine'] as num?,
      methionine: legacyCalcs['methionine'] as num?,
      costPerUnit: legacyCalcs['costPerUnit'] as num?,
      totalCost: legacyCalcs['totalCost'] as num?,
      totalQuantity: totalQuantity,
      // v5 enhanced fields
      ash: enhancedCalcs['ash'] as num?,
      moisture: enhancedCalcs['moisture'] as num?,
      totalPhosphorus: enhancedCalcs['totalPhosphorus'] as num?,
      availablePhosphorus: enhancedCalcs['availablePhosphorus'] as num?,
      phytatePhosphorus: enhancedCalcs['phytatePhosphorus'] as num?,
      aminoAcidsTotalJson: enhancedCalcs['aminoAcidsTotalJson'] as String?,
      aminoAcidsSidJson: enhancedCalcs['aminoAcidsSidJson'] as String?,
      energyJson: enhancedCalcs['energyJson'] as String?,
      warningsJson: jsonEncode(warnings),
    );
  }

  /// Calculate legacy v4 values (backward compatibility)
  static Map<String, dynamic> _calculateLegacyValues(
    List<FeedIngredients> feedIngredients,
    Map<num, Ingredient> ingredientCache,
    double totalQuantity,
    num animalTypeId,
    Map<num, double>? currentPrices,
  ) {
    double totalEnergy = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalCalcium = 0;
    double totalPhosphorus = 0;
    double totalLysine = 0;
    double totalMethionine = 0;
    double totalCost = 0;

    for (final ing in feedIngredients) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = ingredientCache[ing.ingredientId];
      if (data == null) continue;

      final energy = _getEnergyForAnimal(data, animalTypeId);
      totalEnergy += energy * qty;
      totalProtein += (data.crudeProtein ?? 0) * qty;
      totalFat += (data.crudeFat ?? 0) * qty;
      totalFiber += (data.crudeFiber ?? 0) * qty;
      totalCalcium += (data.calcium ?? 0) * qty;
      totalPhosphorus += (data.phosphorus ?? 0) * qty;
      totalLysine += (data.lysine ?? 0) * qty;
      totalMethionine += (data.methionine ?? 0) * qty;
      // Use latest recorded price when available; fallback to feedIngredient price
      final overridePrice =
          currentPrices != null ? currentPrices[ing.ingredientId ?? -1] : null;
      final pricePerKg = overridePrice ?? (ing.priceUnitKg ?? 0).toDouble();
      totalCost += pricePerKg * qty;
    }

    return {
      'mEnergy': totalEnergy / totalQuantity,
      'cProtein': totalProtein / totalQuantity,
      'cFat': totalFat / totalQuantity,
      'cFibre': totalFiber / totalQuantity,
      'calcium': totalCalcium / totalQuantity,
      'phosphorus': totalPhosphorus / totalQuantity,
      'lysine': totalLysine / totalQuantity,
      'methionine': totalMethionine / totalQuantity,
      'costPerUnit': totalCost / totalQuantity,
      'totalCost': totalCost,
    };
  }

  /// Calculate enhanced v5 values (amino acids, phosphorus breakdown, etc.)
  static Map<String, dynamic> _calculateEnhancedValues(
    List<FeedIngredients> feedIngredients,
    Map<num, Ingredient> ingredientCache,
    double totalQuantity,
  ) {
    double totalAsh = 0;
    double totalMoisture = 0;
    double totalPhosphorus = 0;
    double totalAvailablePhosphorus = 0;
    double totalPhytatePhosphorus = 0;

    // Maps for amino acids
    final aminoAcidsTotals = <String, double>{};
    final aminoAcidsSidTotals = <String, double>{};

    // Initialize amino acid maps
    _initializeAminoAcidMaps(aminoAcidsTotals, aminoAcidsSidTotals);

    for (final ing in feedIngredients) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = ingredientCache[ing.ingredientId];
      if (data == null) continue;

      // Proximate analysis
      totalAsh += (data.ash ?? 0) * qty;
      totalMoisture += (data.moisture ?? 0) * qty;

      // Phosphorus breakdown (use v5 fields with fallback to legacy)
      final phosph = data.totalPhosphorus ?? data.phosphorus ?? 0;
      totalPhosphorus += phosph * qty;
      totalAvailablePhosphorus += (data.availablePhosphorus ?? phosph * 0.4) *
          qty; // 40% availability default
      totalPhytatePhosphorus +=
          (data.phytatePhosphorus ?? phosph * 0.3) * qty; // 30% phytate default

      // Amino acids from JSON or legacy fields
      _accumulateAminoAcids(
        data,
        qty,
        aminoAcidsTotals,
        aminoAcidsSidTotals,
      );
    }

    // Calculate comprehensive energy data for all animal types
    final energyMap = _calculateComprehensiveEnergy(
      feedIngredients,
      ingredientCache,
      totalQuantity,
    );

    return {
      'ash': totalAsh / totalQuantity,
      'moisture': totalMoisture / totalQuantity,
      'totalPhosphorus': totalPhosphorus / totalQuantity,
      'availablePhosphorus': totalAvailablePhosphorus / totalQuantity,
      'phytatePhosphorus': totalPhytatePhosphorus / totalQuantity,
      'aminoAcidsTotalJson': jsonEncode(
        _normalizeAminoAcidMap(aminoAcidsTotals, totalQuantity),
      ),
      'aminoAcidsSidJson': jsonEncode(
        _normalizeAminoAcidMap(aminoAcidsSidTotals, totalQuantity),
      ),
      'energyJson': energyMap.isNotEmpty ? jsonEncode(energyMap) : null,
    };
  }

  /// Initialize amino acid maps with all 10 essential amino acids
  static void _initializeAminoAcidMaps(
    Map<String, double> totals,
    Map<String, double> sids,
  ) {
    const aminoAcids = [
      'lysine',
      'methionine',
      'cystine',
      'threonine',
      'tryptophan',
      'phenylalanine',
      'tyrosine',
      'leucine',
      'isoleucine',
      'valine',
    ];

    for (final aa in aminoAcids) {
      totals[aa] = 0.0;
      sids[aa] = 0.0;
    }
  }

  /// Accumulate amino acid values from ingredient with SID prioritization
  ///
  /// Industry-standard approach per NRC 2012:
  /// - PRIORITY 1: Use SID (Standardized Ileal Digestible) values if available
  /// - PRIORITY 2: Apply 0.85 digestibility factor to total amino acids
  /// - PRIORITY 3: Apply 0.85 digestibility factor to legacy fields
  ///
  /// Always tracks total amino acids separately for reference.
  static void _accumulateAminoAcids(
    Ingredient data,
    double qty,
    Map<String, double> aminoAcidsTotals,
    Map<String, double> aminoAcidsSidTotals,
  ) {
    // NRC 2012 average digestibility coefficient for plant proteins
    const digestibilityFactor = 0.85;

    // PRIORITY 1: Use SID values (industry standard for digestibility)
    if (data.aminoAcidsSid != null) {
      final sid = data.aminoAcidsSid!;
      _addAminoAcidValue(aminoAcidsSidTotals, 'lysine', sid.lysine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'methionine', sid.methionine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'cystine', sid.cystine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'threonine', sid.threonine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'tryptophan', sid.tryptophan, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'arginine', sid.arginine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'isoleucine', sid.isoleucine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'leucine', sid.leucine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'valine', sid.valine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'histidine', sid.histidine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'phenylalanine', sid.phenylalanine, qty);
    }
    // PRIORITY 2: Fallback to total amino acids with digestibility factor
    else if (data.aminoAcidsTotal != null) {
      final total = data.aminoAcidsTotal!;
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'lysine',
          total.lysine != null ? total.lysine! * digestibilityFactor : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'methionine',
          total.methionine != null
              ? total.methionine! * digestibilityFactor
              : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'cystine',
          total.cystine != null ? total.cystine! * digestibilityFactor : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'threonine',
          total.threonine != null
              ? total.threonine! * digestibilityFactor
              : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'tryptophan',
          total.tryptophan != null
              ? total.tryptophan! * digestibilityFactor
              : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'arginine',
          total.arginine != null ? total.arginine! * digestibilityFactor : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'isoleucine',
          total.isoleucine != null
              ? total.isoleucine! * digestibilityFactor
              : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'leucine',
          total.leucine != null ? total.leucine! * digestibilityFactor : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'valine',
          total.valine != null ? total.valine! * digestibilityFactor : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'histidine',
          total.histidine != null
              ? total.histidine! * digestibilityFactor
              : null,
          qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'phenylalanine',
          total.phenylalanine != null
              ? total.phenylalanine! * digestibilityFactor
              : null,
          qty);
    }
    // PRIORITY 3: Legacy fallback for old data
    else {
      _addAminoAcidValue(aminoAcidsSidTotals, 'lysine',
          data.lysine != null ? data.lysine! * digestibilityFactor : null, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals,
          'methionine',
          data.methionine != null
              ? data.methionine! * digestibilityFactor
              : null,
          qty);
    }

    // Always track total amino acids for reference
    if (data.aminoAcidsTotal != null) {
      final total = data.aminoAcidsTotal!;
      _addAminoAcidValue(aminoAcidsTotals, 'lysine', total.lysine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'methionine', total.methionine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'cystine', total.cystine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'threonine', total.threonine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'tryptophan', total.tryptophan, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'arginine', total.arginine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'isoleucine', total.isoleucine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'leucine', total.leucine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'valine', total.valine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'histidine', total.histidine, qty);
      _addAminoAcidValue(
          aminoAcidsTotals, 'phenylalanine', total.phenylalanine, qty);
    }
    // Fallback: Use legacy fields if model objects not available
    else if (data.lysine != null || data.methionine != null) {
      if (data.lysine != null) {
        aminoAcidsTotals['lysine'] =
            (aminoAcidsTotals['lysine'] ?? 0) + data.lysine! * qty;
      }
      if (data.methionine != null) {
        aminoAcidsTotals['methionine'] =
            (aminoAcidsTotals['methionine'] ?? 0) + data.methionine! * qty;
      }
    }
  }

  /// Helper method to add amino acid value to accumulation map
  static void _addAminoAcidValue(
    Map<String, double> map,
    String key,
    num? value,
    double qty,
  ) {
    if (value != null) {
      map[key] = (map[key] ?? 0) + value.toDouble() * qty;
    }
  }

  /// Normalize amino acid accumulations to per-kg values
  static Map<String, num> _normalizeAminoAcidMap(
    Map<String, double> accumulated,
    double totalQuantity,
  ) {
    final normalized = <String, num>{};
    accumulated.forEach((key, value) {
      // Ingredient data is already in g/kg, so just divide by total quantity for average
      normalized[key] = roundToDouble(value / totalQuantity);
    });
    return normalized;
  }

  /// Collect all warnings and issues from calculation
  static List<String> _collectWarnings(
    List<FeedIngredients> feedIngredients,
    Map<num, Ingredient> ingredientCache,
    Map<String, dynamic> enhancedCalcs,
    InclusionValidationResult inclusionValidation,
  ) {
    final warnings = <String>[];

    // Inclusion limit errors (critical violations)
    for (final error in inclusionValidation.errors) {
      warnings.add('🚫 VIOLATION: $error');
    }

    // Inclusion limit warnings (approaching limits, ANF warnings)
    for (final warning in inclusionValidation.warnings) {
      warnings.add('⚠️ $warning');
    }

    // Ingredient-specific warnings
    for (final ing in feedIngredients) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = ingredientCache[ing.ingredientId];
      if (data == null) continue;

      if (data.warning != null && data.warning!.isNotEmpty) {
        warnings.add('⚠️ ${data.name}: ${data.warning}');
      }

      if (data.regulatoryNote != null && data.regulatoryNote!.isNotEmpty) {
        warnings.add('📋 ${data.name}: ${data.regulatoryNote}');
      }
    }

    return warnings;
  }

  static double _calcTotalQuantity(List<FeedIngredients> ingList) {
    double total = 0;
    for (final i in ingList) {
      total += (i.quantity ?? 0).toDouble();
    }
    return total;
  }

  /// Get energy value for specific animal type with NE prioritization for pigs
  ///
  /// Animal Type IDs:
  /// - 1 = Pig (uses NE - Net Energy per NRC 2012)
  /// - 2 = Poultry (uses ME - Metabolizable Energy)
  /// - 3 = Rabbit (uses ME)
  /// - 4 = Ruminant (uses ME)
  /// - 5 = Salmonids (uses DE - Digestible Energy)
  ///
  /// For pigs, NE is prioritized per NRC 2012 standards with conversion formulas:
  /// - ME to NE: NE = 0.87*ME - 442 (kcal/kg)
  /// - DE to NE: NE = 0.75*DE - 600 (kcal/kg)
  static double _getEnergyForAnimal(Ingredient ing, num animalTypeId) {
    // PIGS: Prioritize NE > ME > DE (NRC 2012 standard)
    if (animalTypeId == 1) {
      // Priority 1: Use NE directly if available
      if (ing.energy?.nePig != null) {
        return ing.energy!.nePig!.toDouble();
      }

      // Priority 2: Convert ME to NE using NRC 2012 equation
      if (ing.energy?.mePig != null) {
        final me = ing.energy!.mePig!.toDouble();
        // NRC 2012: NE = 0.87*ME - 442
        return (0.87 * me - 442).clamp(0, double.infinity);
      }

      // Priority 3: Legacy ME field with conversion
      if (ing.meGrowingPig != null) {
        final me = ing.meGrowingPig!.toDouble();
        // NRC 2012: NE = 0.87*ME - 442
        return (0.87 * me - 442).clamp(0, double.infinity);
      }

      // Priority 4: Convert DE to NE (approximate)
      if (ing.energy?.dePig != null) {
        final de = ing.energy!.dePig!.toDouble();
        // Approximate: NE = 0.75*DE - 600
        return (0.75 * de - 600).clamp(0, double.infinity);
      }

      return 0;
    }

    // POULTRY: Use ME (industry standard)
    if (animalTypeId == 2) {
      return (ing.energy?.mePoultry ?? ing.mePoultry ?? 0).toDouble();
    }

    // RABBITS: Use ME
    if (animalTypeId == 3) {
      return (ing.energy?.meRabbit ?? ing.meRabbit ?? 0).toDouble();
    }

    // RUMINANTS: Use ME
    if (animalTypeId == 4 ||
        animalTypeId == 5 ||
        animalTypeId == 6 ||
        animalTypeId == 7) {
      return (ing.energy?.meRuminant ?? ing.meRuminant ?? 0).toDouble();
    }

    // SALMONIDS (FISH): Use DE
    if (animalTypeId == 8 || animalTypeId == 9) {
      return (ing.energy?.deSalmonids ?? ing.deSalmonids ?? 0).toDouble();
    }

    return 0;
  }

  /// Round double to 1 decimal place
  static double roundToDouble(double value) => (value * 10).round() / 10;

  /// Calculate comprehensive energy data for all animal types
  static Map<String, num> _calculateComprehensiveEnergy(
    List<FeedIngredients> feedIngredients,
    Map<num, Ingredient> ingredientCache,
    double totalQuantity,
  ) {
    double totalDePig = 0;
    double totalMePig = 0;
    double totalNePig = 0;
    double totalMePoultry = 0;
    double totalMeRuminant = 0;
    double totalMeRabbit = 0;
    double totalDeSalmonids = 0;

    for (final ing in feedIngredients) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = ingredientCache[ing.ingredientId];
      if (data == null) continue;

      // Get energy from v5 energy object or legacy fields
      if (data.energy != null) {
        totalDePig += (data.energy!.dePig ?? 0) * qty;
        totalMePig += (data.energy!.mePig ?? 0) * qty;
        totalNePig += (data.energy!.nePig ?? 0) * qty;
        totalMePoultry += (data.energy!.mePoultry ?? 0) * qty;
        totalMeRuminant += (data.energy!.meRuminant ?? 0) * qty;
        totalMeRabbit += (data.energy!.meRabbit ?? 0) * qty;
        totalDeSalmonids += (data.energy!.deSalmonids ?? 0) * qty;
      } else {
        // Fallback to legacy fields
        totalMePig += (data.meGrowingPig ?? 0) * qty;
        totalMePoultry += (data.mePoultry ?? 0) * qty;
        totalMeRuminant += (data.meRuminant ?? 0) * qty;
        totalMeRabbit += (data.meRabbit ?? 0) * qty;
        totalDeSalmonids += (data.deSalmonids ?? 0) * qty;
      }
    }

    final result = <String, num>{};

    if (totalDePig > 0) result['de_pig'] = totalDePig / totalQuantity;
    if (totalMePig > 0) result['me_pig'] = totalMePig / totalQuantity;
    if (totalNePig > 0) result['ne_pig'] = totalNePig / totalQuantity;
    if (totalMePoultry > 0) {
      result['me_poultry'] = totalMePoultry / totalQuantity;
    }
    if (totalMeRuminant > 0) {
      result['me_ruminant'] = totalMeRuminant / totalQuantity;
    }
    if (totalMeRabbit > 0) result['me_rabbit'] = totalMeRabbit / totalQuantity;
    if (totalDeSalmonids > 0) {
      result['de_salmonids'] = totalDeSalmonids / totalQuantity;
    }

    return result;
  }
}

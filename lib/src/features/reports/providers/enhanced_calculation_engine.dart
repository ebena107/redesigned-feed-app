import 'dart:convert';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/model/inclusion_limit_validator.dart';
import 'package:feed_estimator/src/features/reports/model/inclusion_validation.dart';
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
    );

    // Calculate enhanced (v5) values
    final enhancedCalcs = _calculateEnhancedValues(
      feedIngredients,
      ingredientCache,
      totalQuantity,
    );

    // Validate inclusion limits
    final inclusionValidation = InclusionLimitValidator.validateFormulation(
      feedIngredients: feedIngredients,
      ingredientCache: ingredientCache,
      totalQuantity: totalQuantity,
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
      warningsJson: jsonEncode(warnings),
    );
  }

  /// Calculate legacy v4 values (backward compatibility)
  static Map<String, dynamic> _calculateLegacyValues(
    List<FeedIngredients> feedIngredients,
    Map<num, Ingredient> ingredientCache,
    double totalQuantity,
    num animalTypeId,
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
      totalCost += (ing.priceUnitKg ?? 0) * qty;
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

  /// Accumulate amino acid values from ingredient
  static void _accumulateAminoAcids(
    Ingredient data,
    double qty,
    Map<String, double> aminoAcidsTotals,
    Map<String, double> aminoAcidsSidTotals,
  ) {
    // Try to use v5 model objects first
    if (data.aminoAcidsTotal != null) {
      final profile = data.aminoAcidsTotal!;
      _addAminoAcidValue(aminoAcidsTotals, 'lysine', profile.lysine, qty);
      _addAminoAcidValue(
          aminoAcidsTotals, 'methionine', profile.methionine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'cystine', profile.cystine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'threonine', profile.threonine, qty);
      _addAminoAcidValue(
          aminoAcidsTotals, 'tryptophan', profile.tryptophan, qty);
      _addAminoAcidValue(
          aminoAcidsTotals, 'phenylalanine', profile.phenylalanine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'leucine', profile.leucine, qty);
      _addAminoAcidValue(
          aminoAcidsTotals, 'isoleucine', profile.isoleucine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'valine', profile.valine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'arginine', profile.arginine, qty);
      _addAminoAcidValue(aminoAcidsTotals, 'histidine', profile.histidine, qty);
    }

    if (data.aminoAcidsSid != null) {
      final profile = data.aminoAcidsSid!;
      _addAminoAcidValue(aminoAcidsSidTotals, 'lysine', profile.lysine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'methionine', profile.methionine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'cystine', profile.cystine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'threonine', profile.threonine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'tryptophan', profile.tryptophan, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'phenylalanine', profile.phenylalanine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'leucine', profile.leucine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'isoleucine', profile.isoleucine, qty);
      _addAminoAcidValue(aminoAcidsSidTotals, 'valine', profile.valine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'arginine', profile.arginine, qty);
      _addAminoAcidValue(
          aminoAcidsSidTotals, 'histidine', profile.histidine, qty);
    }

    // Fallback: Use legacy fields if model objects not available
    if (data.aminoAcidsTotal == null) {
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

    // Inclusion limit violations
    for (final violation in inclusionValidation.violations) {
      warnings.add(
        '🚫 VIOLATION: ${violation.description}',
      );
    }

    // Inclusion limit warnings
    for (final warning in inclusionValidation.warnings) {
      warnings.add(
        '⚠️ ${warning.description}',
      );
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

  static double _getEnergyForAnimal(Ingredient ing, num animalTypeId) {
    if (animalTypeId == 1) return (ing.meGrowingPig ?? 0).toDouble();
    if (animalTypeId == 2) return (ing.mePoultry ?? 0).toDouble();
    if (animalTypeId == 3) return (ing.meRabbit ?? 0).toDouble();
    if (animalTypeId == 4) return (ing.meRuminant ?? 0).toDouble();
    if (animalTypeId == 5) return (ing.deSalmonids ?? 0).toDouble();
    return 0;
  }

  /// Round double to 1 decimal place
  static double roundToDouble(double value) => (value * 10).round() / 10;
}

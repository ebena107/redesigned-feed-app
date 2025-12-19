import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/model/inclusion_validation.dart';

const String _tag = 'InclusionLimitValidator';

/// Validates ingredient inclusion percentages against maximum limits
///
/// This validator checks:
/// - Maximum inclusion rates from ingredient dataset
/// - Anti-nutritional factor (ANF) safety limits
/// - Regulatory and safety restrictions
///
/// Industry Standards:
/// - Glucosinolates: >30 μmol/g requires <10% inclusion
/// - Trypsin Inhibitors: >40 TU/g requires heat treatment warning
/// - Tannins: >5000 ppm requires <15% inclusion
class InclusionLimitValidator {
  /// Check if formulation violates any ingredient limits
  ///
  /// Parameters:
  /// - feedIngredients: List of ingredients in the formulation
  /// - ingredientCache: Map of ingredient ID → Ingredient data
  /// - totalQuantity: Sum of all ingredient quantities (kg)
  /// - animalTypeId: Type of animal (for species-specific limits)
  ///
  /// Returns: InclusionValidationResult with violations and warnings
  static InclusionValidationResult validateFormulation({
    required List<FeedIngredients> feedIngredients,
    required Map<num, Ingredient> ingredientCache,
    required double totalQuantity,
    num? animalTypeId,
  }) {
    final violations = <InclusionViolation>[];
    final warnings = <InclusionWarning>[];

    if (totalQuantity <= 0 || feedIngredients.isEmpty) {
      return InclusionValidationResult();
    }

    for (final ing in feedIngredients) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final ingredientData = ingredientCache[ing.ingredientId];
      if (ingredientData == null) continue;

      final inclusionPct = (qty / totalQuantity) * 100;

      // Get max inclusion limit from ingredient data
      final maxInclusionPct = _getMaxInclusionLimit(
        ingredientData,
        animalTypeId,
      );

      // Check for hard violations
      if (maxInclusionPct > 0 && inclusionPct > maxInclusionPct) {
        violations.add(
          InclusionViolation(
            ingredientName: ingredientData.name ?? 'Unknown',
            maxAllowedPct: maxInclusionPct,
            actualPct: inclusionPct,
            reason: _getInclusionReason(ingredientData),
          ),
        );
        AppLogger.warning(
          '${ingredientData.name} exceeds inclusion limit: ${inclusionPct.toStringAsFixed(1)}% > ${maxInclusionPct.toStringAsFixed(1)}%',
          tag: _tag,
        );
      }
      // Check for warnings (approaching limit at 90%)
      else if (maxInclusionPct > 0 && inclusionPct > (maxInclusionPct * 0.9)) {
        warnings.add(
          InclusionWarning(
            ingredientName: ingredientData.name ?? 'Unknown',
            maxAllowedPct: maxInclusionPct,
            actualPct: inclusionPct,
            warningThresholdPct: 0.9,
          ),
        );
        AppLogger.info(
          '${ingredientData.name} is approaching inclusion limit: ${inclusionPct.toStringAsFixed(1)}% of ${maxInclusionPct.toStringAsFixed(1)}%',
          tag: _tag,
        );
      }

      // Validate anti-nutritional factors
      _validateAntiNutritionalFactors(
        ingredientData,
        inclusionPct,
        violations,
        warnings,
      );
    }

    return InclusionValidationResult(
      violations: violations,
      warnings: warnings,
    );
  }

  /// Get maximum inclusion limit for an ingredient
  ///
  /// Priority:
  /// 1. Use maxInclusionPct from ingredient data (if available)
  /// 2. Parse max_inclusion JSON for animal-specific limits
  /// 3. Fallback to safety-based hardcoded limits
  ///
  /// Returns the maximum percentage this ingredient can be in the total
  /// formulation, or 0 if no limit is set (unlimited).
  static double _getMaxInclusionLimit(
    Ingredient ingredient,
    num? animalTypeId,
  ) {
    // Priority 1: Use maxInclusionPct field if available
    if (ingredient.maxInclusionPct != null && ingredient.maxInclusionPct! > 0) {
      return ingredient.maxInclusionPct!.toDouble();
    }

    // Priority 2: Parse max_inclusion JSON for animal-specific limits
    // TODO: When max_inclusion JSON is added to Ingredient model, parse it here
    // Example: {"pig_grower": 150, "pig_finisher": 200, "poultry": 100}
    // For now, use hardcoded safety limits

    // Priority 3: Hardcoded safety limits based on known restrictions
    final name = (ingredient.name ?? '').toLowerCase();

    // CRITICAL TOXICITY LIMITS
    if (name.contains('urea')) {
      return 0.0; // DANGEROUS - Ruminants only with special handling
    }
    if (name.contains('castor')) {
      return 0.0; // Ricin toxicity - do not use
    }

    // HIGH TOXICITY LIMITS
    if (name.contains('cottonseed') || name.contains('gossypol')) {
      return 15.0; // Free gossypol toxicity
    }
    if (name.contains('mustard')) {
      return 5.0; // High glucosinolates
    }

    // MODERATE TOXICITY/SAFETY LIMITS
    if (name.contains('moringa')) {
      return 10.0; // High oxalate and saponin
    }
    if (name.contains('rapeseed') && name.contains('high')) {
      return 10.0; // High glucosinolates
    }
    if (name.contains('canola') || name.contains('rapeseed')) {
      return 20.0; // Modern low-glucosinolate varieties
    }

    // REGULATORY LIMITS
    if (name.contains('bone meal') || name.contains('meat meal')) {
      return 20.0; // Regulatory limits in some regions
    }
    if (name.contains('poultry by-product')) {
      return 20.0; // Regulatory concerns
    }
    if (name.contains('blood meal')) {
      return 5.0; // Palatability and amino acid imbalance
    }

    // NUTRITIONAL/DIGESTIBILITY LIMITS
    if (name.contains('straw') || name.contains('hull')) {
      return 30.0; // High fiber - limited for monogastrics
    }
    if (name.contains('wheat bran')) {
      return 30.0; // High fiber, phytate
    }
    if (name.contains('rice bran')) {
      return 25.0; // High fiber, fat oxidation risk
    }

    // No limit set - ingredient can be used freely
    return 0.0;
  }

  /// Validate anti-nutritional factors (ANFs)
  ///
  /// Checks for:
  /// - Glucosinolates (canola/rapeseed)
  /// - Trypsin inhibitors (soybean)
  /// - Tannins (sorghum, legumes)
  /// - Phytic acid (cereals, legumes)
  static void _validateAntiNutritionalFactors(
    Ingredient ingredient,
    double inclusionPct,
    List<InclusionViolation> violations,
    List<InclusionWarning> warnings,
  ) {
    final anf = ingredient.antiNutritionalFactors;
    if (anf == null) return;

    final name = ingredient.name ?? 'Unknown';

    // GLUCOSINOLATES (Canola/Rapeseed)
    // Industry Standard: >30 μmol/g requires <10% inclusion
    if (anf.glucosinolatesMicromolG != null) {
      final glucosinolates = anf.glucosinolatesMicromolG!;

      if (glucosinolates > 30 && inclusionPct > 10) {
        violations.add(
          InclusionViolation(
            ingredientName: name,
            maxAllowedPct: 10.0,
            actualPct: inclusionPct,
            reason:
                'High glucosinolates (${glucosinolates.toStringAsFixed(1)} μmol/g)',
          ),
        );
      } else if (glucosinolates > 20 && inclusionPct > 15) {
        warnings.add(
          InclusionWarning(
            ingredientName: name,
            maxAllowedPct: 20.0,
            actualPct: inclusionPct,
          ),
        );
      }
    }

    // TRYPSIN INHIBITORS (Soybean)
    // Industry Standard: >40 TU/g requires heat treatment
    if (anf.trypsinInhibitorTuG != null) {
      final trypsinInhibitor = anf.trypsinInhibitorTuG!;

      if (trypsinInhibitor > 40) {
        warnings.add(
          InclusionWarning(
            ingredientName: name,
            maxAllowedPct: 100.0, // No hard limit, just warning
            actualPct: inclusionPct,
          ),
        );
        AppLogger.warning(
          '$name has high trypsin inhibitors (${trypsinInhibitor.toStringAsFixed(1)} TU/g). Ensure proper heat treatment.',
          tag: _tag,
        );
      }
    }

    // TANNINS (Sorghum, Legumes)
    // Industry Standard: >5000 ppm requires <15% inclusion
    if (anf.tanninsPpm != null) {
      final tannins = anf.tanninsPpm!;

      if (tannins > 5000 && inclusionPct > 15) {
        violations.add(
          InclusionViolation(
            ingredientName: name,
            maxAllowedPct: 15.0,
            actualPct: inclusionPct,
            reason: 'High tannins (${tannins.toStringAsFixed(0)} ppm)',
          ),
        );
      } else if (tannins > 3000 && inclusionPct > 20) {
        warnings.add(
          InclusionWarning(
            ingredientName: name,
            maxAllowedPct: 25.0,
            actualPct: inclusionPct,
          ),
        );
      }
    }

    // PHYTIC ACID (Cereals, Legumes)
    // Industry Standard: >15,000 ppm may require phytase supplementation
    if (anf.phyticAcidPpm != null) {
      final phyticAcid = anf.phyticAcidPpm!;

      if (phyticAcid > 15000 && inclusionPct > 40) {
        warnings.add(
          InclusionWarning(
            ingredientName: name,
            maxAllowedPct: 50.0,
            actualPct: inclusionPct,
          ),
        );
        AppLogger.info(
          '$name has high phytic acid (${phyticAcid.toStringAsFixed(0)} ppm). Consider phytase supplementation.',
          tag: _tag,
        );
      }
    }
  }

  /// Get the reason for an ingredient's inclusion limit
  static String _getInclusionReason(Ingredient ingredient) {
    final name = (ingredient.name ?? '').toLowerCase();

    // Check ANF first
    final anf = ingredient.antiNutritionalFactors;
    if (anf != null) {
      if (anf.glucosinolatesMicromolG != null &&
          anf.glucosinolatesMicromolG! > 30) {
        return 'High glucosinolates (${anf.glucosinolatesMicromolG!.toStringAsFixed(1)} μmol/g)';
      }
      if (anf.tanninsPpm != null && anf.tanninsPpm! > 5000) {
        return 'High tannins (${anf.tanninsPpm!.toStringAsFixed(0)} ppm)';
      }
      if (anf.trypsinInhibitorTuG != null && anf.trypsinInhibitorTuG! > 40) {
        return 'High trypsin inhibitors - requires heat treatment';
      }
    }

    // Fallback to name-based reasons
    if (name.contains('urea')) {
      return 'Ammonia toxicity risk';
    }
    if (name.contains('cottonseed') || name.contains('gossypol')) {
      return 'Free gossypol toxicity';
    }
    if (name.contains('moringa')) {
      return 'High oxalate and saponin content';
    }
    if (name.contains('rapeseed') || name.contains('canola')) {
      return 'Glucosinolates and erucic acid';
    }
    if (name.contains('mustard')) {
      return 'Glucosinolates';
    }
    if (name.contains('bone meal') || name.contains('meat meal')) {
      return 'Regulatory restrictions';
    }
    if (name.contains('blood meal')) {
      return 'Palatability and amino acid imbalance';
    }
    if (name.contains('straw') || name.contains('hull')) {
      return 'High fiber content';
    }

    return 'Safety/nutritional concern';
  }
}

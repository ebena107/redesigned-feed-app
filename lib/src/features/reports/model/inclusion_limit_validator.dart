import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/model/inclusion_validation.dart';

const String _tag = 'InclusionLimitValidator';

/// Validates ingredient inclusion percentages against maximum limits
///
/// This validator checks that no ingredient exceeds its maximum inclusion
/// percentage of the total feed formulation. Some ingredients have toxicity
/// concerns (e.g., cottonseed meal with gossypol) or regulatory restrictions
/// that require maximum limits.
class InclusionLimitValidator {
  /// Check if formulation violates any ingredient limits
  ///
  /// Parameters:
  /// - feedIngredients: List of ingredients in the formulation
  /// - ingredientCache: Map of ingredient ID → Ingredient data
  /// - totalQuantity: Sum of all ingredient quantities (kg)
  ///
  /// Returns: InclusionValidationResult with violations and warnings
  static InclusionValidationResult validateFormulation({
    required List<FeedIngredients> feedIngredients,
    required Map<num, Ingredient> ingredientCache,
    required double totalQuantity,
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
      final maxInclusionPct = _getMaxInclusionLimit(ingredientData);

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
      // Check for warnings (approaching limit)
      else if (maxInclusionPct > 0 && inclusionPct > (maxInclusionPct * 0.8)) {
        warnings.add(
          InclusionWarning(
            ingredientName: ingredientData.name ?? 'Unknown',
            maxAllowedPct: maxInclusionPct,
            actualPct: inclusionPct,
          ),
        );
        AppLogger.info(
          '${ingredientData.name} is approaching inclusion limit: ${inclusionPct.toStringAsFixed(1)}% of ${maxInclusionPct.toStringAsFixed(1)}%',
          tag: _tag,
        );
      }
    }

    return InclusionValidationResult(
      violations: violations,
      warnings: warnings,
    );
  }

  /// Get maximum inclusion limit for an ingredient
  ///
  /// Returns the maximum percentage this ingredient can be in the total
  /// formulation, or 0 if no limit is set (unlimited).
  static double _getMaxInclusionLimit(Ingredient ingredient) {
    // These should come from the harmonized dataset's max_inclusion_pct field
    // For now, we use hardcoded values based on known safety limits

    final name = (ingredient.name ?? '').toLowerCase();

    // Toxicity-based limits
    if (name.contains('cottonseed') || name.contains('gossypol')) {
      return 15.0; // High gossypol content
    }
    if (name.contains('urea')) {
      return 0.0; // DANGEROUS - Ruminants only with special handling
    }
    if (name.contains('moringa')) {
      return 10.0; // High oxalate and saponin
    }
    if (name.contains('rapeseed') && name.contains('high')) {
      return 10.0; // High glucosinolates
    }
    if (name.contains('mustard')) {
      return 5.0; // Glucosinolates
    }
    if (name.contains('castor')) {
      return 0.0; // Ricin toxicity - do not use
    }

    // By-product limits
    if (name.contains('bone meal') || name.contains('meat meal')) {
      return 20.0; // Regulatory limits in some regions
    }
    if (name.contains('poultry by-product')) {
      return 20.0; // Regulatory concerns
    }

    // Fiber limits (affects digestibility)
    if (name.contains('straw') || name.contains('hull')) {
      return 30.0; // High fiber - limited for monogastrics
    }

    // No limit set
    return 0.0;
  }

  /// Get the reason for an ingredient's inclusion limit
  static String _getInclusionReason(Ingredient ingredient) {
    final name = (ingredient.name ?? '').toLowerCase();

    if (name.contains('urea')) {
      return 'Ammonia toxicity risk';
    }
    if (name.contains('cottonseed') || name.contains('gossypol')) {
      return 'Free gossypol toxicity';
    }
    if (name.contains('moringa')) {
      return 'High oxalate and saponin content';
    }
    if (name.contains('rapeseed')) {
      return 'Glucosinolates and erucic acid';
    }
    if (name.contains('mustard')) {
      return 'Glucosinolates';
    }
    if (name.contains('bone meal') || name.contains('meat meal')) {
      return 'Regulatory restrictions';
    }

    return 'Safety/nutritional concern';
  }
}

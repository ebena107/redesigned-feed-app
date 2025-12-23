import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/core/constants/animal_categories.dart';

/// Validates ingredient inclusion rates against safety limits
///
/// Checks:
/// - Maximum inclusion percentages per ingredient
/// - Anti-nutritional factor (ANF) thresholds
/// - Ingredient-specific warnings
///
/// Returns validation result with warnings and errors for formulation review.
class InclusionValidator {
  /// Validate formulation against inclusion limits
  ///
  /// Returns validation result with warnings and errors
  static InclusionValidationResult validate({
    required List<FeedIngredients> feedIngredients,
    required Map<num, Ingredient> ingredientCache,
    required num animalTypeId,
  }) {
    final warnings = <String>[];
    final errors = <String>[];
    final totalQty = feedIngredients.fold<double>(
      0,
      (sum, ing) => sum + (ing.quantity ?? 0).toDouble(),
    );

    if (totalQty <= 0) {
      return InclusionValidationResult(warnings: [], errors: []);
    }

    for (final feedIng in feedIngredients) {
      final ingredient = ingredientCache[feedIng.ingredientId];
      if (ingredient == null) continue;

      final qty = (feedIng.quantity ?? 0).toDouble();
      final inclusionPct = (qty / totalQty) * 100;

      // Check max_inclusion limits from ingredient data
      final maxInclusion = _getMaxInclusionForAnimal(ingredient, animalTypeId);

      if (maxInclusion != null && maxInclusion > 0) {
        if (inclusionPct > maxInclusion) {
          errors.add(
            '${ingredient.name}: ${inclusionPct.toStringAsFixed(1)}% '
            'exceeds maximum ${maxInclusion.toStringAsFixed(0)}% for this animal type',
          );
        } else if (inclusionPct > maxInclusion * 0.9) {
          // Warning at 90% of limit
          warnings.add(
            '${ingredient.name}: ${inclusionPct.toStringAsFixed(1)}% '
            'approaching limit of ${maxInclusion.toStringAsFixed(0)}%',
          );
        }
      }

      // Check anti-nutritional factors
      if (ingredient.antiNutritionalFactors != null) {
        final anf = ingredient.antiNutritionalFactors!;

        // Glucosinolates (canola/rapeseed): >30 μmol/g requires <10% inclusion
        if (anf.glucosinolatesMicromolG != null &&
            anf.glucosinolatesMicromolG! > 30 &&
            inclusionPct > 10) {
          warnings.add(
            '${ingredient.name}: High glucosinolates '
            '(${anf.glucosinolatesMicromolG} μmol/g). Limit to 10% inclusion.',
          );
        }

        // Trypsin inhibitors (soybean): >40 TU/g requires heat treatment
        if (anf.trypsinInhibitorTuG != null && anf.trypsinInhibitorTuG! > 40) {
          warnings.add(
            '${ingredient.name}: High trypsin inhibitors '
            '(${anf.trypsinInhibitorTuG} TU/g). Ensure proper heat treatment.',
          );
        }

        // Tannins: >5000 ppm requires <15% inclusion
        if (anf.tanninsPpm != null &&
            anf.tanninsPpm! > 5000 &&
            inclusionPct > 15) {
          warnings.add(
            '${ingredient.name}: High tannins (${anf.tanninsPpm} ppm). '
            'Limit to 15% inclusion.',
          );
        }

        // Phytic acid: >20,000 ppm may require phytase
        if (anf.phyticAcidPpm != null && anf.phyticAcidPpm! > 20000) {
          warnings.add(
            '${ingredient.name}: High phytic acid (${anf.phyticAcidPpm} ppm). '
            'Consider adding phytase enzyme.',
          );
        }
      }

      // Ingredient-specific warnings
      if (ingredient.warning != null && ingredient.warning!.isNotEmpty) {
        warnings.add('${ingredient.name}: ${ingredient.warning}');
      }
    }

    return InclusionValidationResult(
      warnings: warnings,
      errors: errors,
      isValid: errors.isEmpty,
    );
  }

  /// Get max inclusion for specific animal type
  ///
  /// Checks per-animal category limits in maxInclusionJson using
  /// AnimalCategoryMapper to determine category preference list.
  /// Falls back to maxInclusionPct and hardcoded rules.
  static double? _getMaxInclusionForAnimal(
    Ingredient ingredient,
    num animalTypeId,
  ) {
    // 1) Prefer JSON-based per-animal/category limits when available
    final map = ingredient.maxInclusionJson;
    if (map != null && map.isNotEmpty) {
      // Get preference list from AnimalCategoryMapper
      final preference =
          AnimalCategoryMapper.getCategoryPreferencesForAnimalType(
              animalTypeId);

      // Try preferred keys first
      for (final key in preference) {
        final val = map[key];
        if (val is num) return val.toDouble();
      }
      // Common fallbacks
      for (final key in const ['default', 'all', 'any']) {
        final val = map[key];
        if (val is num) return val.toDouble();
      }
      // Last resort: pick the most conservative (minimum positive) limit
      final numericValues = map.values.whereType<num>().toList()
        ..removeWhere((e) => e <= 0);
      if (numericValues.isNotEmpty) {
        numericValues.sort();
        return numericValues.first.toDouble();
      }
    }

    // 2) Fallback to simple percentage value
    if (ingredient.maxInclusionPct != null) {
      return ingredient.maxInclusionPct!.toDouble();
    }

    return null;
  }
}

/// Result of inclusion validation
class InclusionValidationResult {
  final List<String> warnings;
  final List<String> errors;
  final bool isValid;

  const InclusionValidationResult({
    required this.warnings,
    required this.errors,
    this.isValid = true,
  });

  /// Check if there are any issues (warnings or errors)
  bool get hasIssues => warnings.isNotEmpty || errors.isNotEmpty;

  /// Get all issues combined
  List<String> get allIssues => [...errors, ...warnings];
}

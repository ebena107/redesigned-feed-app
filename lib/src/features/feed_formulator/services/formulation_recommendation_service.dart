import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';

/// Service to generate recommendations when feed formulation is infeasible
///
/// NOTE: This service generates English messages. Localization should be applied
/// at the UI layer (display_recommendations) to use context.l10n keys:
/// - missingPriceWarning
/// - addMoreIngredientsRecommendation
/// - tightenedConstraintsRecommendation
/// - addHigherNutrientIngredientsRecommendation
/// - conflictingConstraintsError
/// - narrowRangeWarning
/// - nutrientCoverageIssue
/// - lowInclusionLimitsWarning
/// - totalInclusionLimitWarning
///
/// UNIT HANDLING (RESOLVED):
/// - Energy values in kcal/kg (ingredients stored as mePoultry, etc. in kcal)
/// - Nutrient values in % (protein, amino acids, minerals)
/// - Thresholds adjusted per unit type:
///   • Energy: 100 kcal/kg (e.g., 788-836 range = 48 kcal, acceptable)
///   • Nutrients: 0.5% (e.g., 1.2-1.4 range = 0.2%, too narrow - warn)
class FormulationRecommendationService {
  /// Analyze infeasible formulation and generate user-friendly recommendations
  static List<String> generateRecommendations({
    required List<Ingredient> ingredients,
    required List<NutrientConstraint> constraints,
    required int animalTypeId,
    required bool enforceMaxInclusion,
  }) {
    final recommendations = <String>[];

    // Check if ingredients are too few
    if (ingredients.length < 3) {
      recommendations.add(
        'Add more ingredients (at least 3-5 recommended) to have more flexibility in meeting nutrient targets.',
      );
    }

    // Check for conflicting constraints
    final conflicts = _detectConflictingConstraints(constraints);
    for (final conflict in conflicts) {
      recommendations.add(conflict);
    }

    // Analyze ingredient nutrient coverage
    final coverageIssues =
        _analyzeNutrientCoverage(ingredients, constraints, animalTypeId);
    recommendations.addAll(coverageIssues);

    // Check inclusion limits
    if (enforceMaxInclusion) {
      final inclusionWarnings = _checkInclusionLimits(ingredients);
      recommendations.addAll(inclusionWarnings);
    }

    // If no specific issues found, provide general guidance
    if (recommendations.isEmpty) {
      recommendations.add(
        'The nutrient requirements may be too strict for the selected ingredients. Try relaxing the min/max ranges by 5-10%.',
      );
      recommendations.add(
        'Alternatively, add ingredients with higher nutrient density in limiting nutrients.',
      );
    }

    return recommendations;
  }

  /// Detect conflicting or overly tight constraints
  static List<String> _detectConflictingConstraints(
    List<NutrientConstraint> constraints,
  ) {
    final conflicts = <String>[];

    for (final constraint in constraints) {
      final min = constraint.min;
      final max = constraint.max;

      // Check if min > max
      if (min != null && max != null && min > max) {
        conflicts.add(
          '❌ ${_nutrientName(constraint.key)}: Minimum (${min.toStringAsFixed(2)}) exceeds maximum (${max.toStringAsFixed(2)}). Please correct this.',
        );
      }

      // Check if range is too narrow - use nutrient-specific thresholds
      // Energy is in kcal/kg (NRC 2012 ranges are typically 100-150 kcal variation)
      // Percentages (protein, amino acids, minerals) are smaller, threshold 0.35%
      // (0.35 allows reasonable ranges like lysine 0.72-1.10 which is 0.38)
      if (min != null && max != null) {
        final rangeWidth = max - min;
        final minThreshold = constraint.key == NutrientKey.energy ? 150 : 0.35;

        if (rangeWidth < minThreshold) {
          conflicts.add(
            '⚠ ${_nutrientName(constraint.key)}: Range is very narrow (${rangeWidth.toStringAsFixed(2)}). Try widening by 10-20%.',
          );
        }
      }
    }

    return conflicts;
  }

  /// Analyze which nutrients can be supplied by ingredients
  static List<String> _analyzeNutrientCoverage(
    List<Ingredient> ingredients,
    List<NutrientConstraint> constraints,
    int animalTypeId,
  ) {
    final coverage = <String>[];

    for (final constraint in constraints) {
      final targetMin = constraint.min;
      if (targetMin == null) continue;

      // Find max value for this nutrient across all ingredients
      double maxNutrient = 0;
      switch (constraint.key) {
        case NutrientKey.protein:
          maxNutrient = (ingredients
                  .map((i) => i.crudeProtein ?? 0)
                  .reduce((a, b) => a > b ? a : b)) *
              1.0;
          break;
        case NutrientKey.lysine:
          maxNutrient = (ingredients
                  .map((i) => i.lysine ?? 0)
                  .reduce((a, b) => a > b ? a : b)) *
              1.0;
          break;
        case NutrientKey.methionine:
          maxNutrient = (ingredients
                  .map((i) => i.methionine ?? 0)
                  .reduce((a, b) => a > b ? a : b)) *
              1.0;
          break;
        case NutrientKey.energy:
          maxNutrient = ingredients
              .map((i) => _energyValueForRecommendation(i, animalTypeId))
              .reduce((a, b) => a > b ? a : b);
          break;
        case NutrientKey.calcium:
          maxNutrient = (ingredients
                  .map((i) => i.calcium ?? 0)
                  .reduce((a, b) => a > b ? a : b)) *
              1.0;
          break;
        case NutrientKey.phosphorus:
          maxNutrient = (ingredients
                  .map((i) => i.phosphorus ?? 0)
                  .reduce((a, b) => a > b ? a : b)) *
              1.0;
          break;
      }

      // If no ingredient can reach the target, recommend lower requirement
      if (maxNutrient < targetMin) {
        coverage.add(
          '➜ ${_nutrientName(constraint.key)}: Max available from ingredients is ${maxNutrient.toStringAsFixed(2)}, but minimum required is ${targetMin.toStringAsFixed(2)}. Lower the requirement or select ingredients with higher ${_nutrientName(constraint.key)}.',
        );
      }
    }

    return coverage;
  }

  /// Check if inclusion limits are preventing feasible solutions
  static List<String> _checkInclusionLimits(List<Ingredient> ingredients) {
    final warnings = <String>[];

    // Find ingredients with very low inclusion limits
    final restrictiveIngredients = ingredients
        .where((i) => i.maxInclusionPct != null && i.maxInclusionPct! < 5)
        .toList();

    if (restrictiveIngredients.isNotEmpty && ingredients.length < 5) {
      warnings.add(
        'Several ingredients have very low maximum inclusion limits. Add more diverse ingredients to balance constraints.',
      );
    }

    // Check if total inclusion limits sum to less than 100%
    final totalMaxInclusion = ingredients.fold<double>(
      0,
      (sum, ing) => sum + (ing.maxInclusionPct ?? 100),
    );

    if (totalMaxInclusion < 100 && ingredients.length < 10) {
      warnings.add(
        '⚠ Total maximum inclusion across selected ingredients is ${totalMaxInclusion.toStringAsFixed(1)}%. Add more ingredients or increase individual limits.',
      );
    }

    return warnings;
  }

  /// Get human-readable nutrient name
  static String _nutrientName(NutrientKey key) {
    switch (key) {
      case NutrientKey.energy:
        return 'Energy (ME)';
      case NutrientKey.protein:
        return 'Crude Protein';
      case NutrientKey.lysine:
        return 'Lysine';
      case NutrientKey.methionine:
        return 'Methionine';
      case NutrientKey.calcium:
        return 'Calcium';
      case NutrientKey.phosphorus:
        return 'Phosphorus';
    }
  }

  static double _energyValueForRecommendation(
    Ingredient ingredient,
    int animalTypeId,
  ) {
    switch (animalTypeId) {
      case 1:
        return ingredient.meGrowingPig?.toDouble() ??
            ingredient.meAdultPig?.toDouble() ??
            ingredient.meFinishingPig?.toDouble() ??
            0;
      case 2:
        return ingredient.mePoultry?.toDouble() ?? 0;
      case 3:
        return ingredient.meRabbit?.toDouble() ?? 0;
      case 4:
      case 5:
      case 6:
      case 7:
        return ingredient.meRuminant?.toDouble() ?? 0;
      case 8:
      case 9:
        return ingredient.deSalmonids?.toDouble() ?? 0;
      default:
        return 0;
    }
  }
}

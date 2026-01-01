import '../model/optimization_constraint.dart';
import '../model/optimization_result.dart';
import '../../add_ingredients/model/ingredient.dart';

/// Service for scoring and comparing feed formulations
class FormulationScorer {
  /// Calculate overall quality score for a formulation (0-100)
  ///
  /// Score is based on:
  /// - Nutritional adequacy (50%)
  /// - Cost efficiency (25%)
  /// - Safety margins (25%)
  double calculateQualityScore({
    required OptimizationResult result,
    required List<OptimizationConstraint> constraints,
    required Map<int, Ingredient> ingredientCache,
  }) {
    if (!result.success) return 0.0;

    final nutritionalScore = _calculateNutritionalScore(result, constraints);
    final costScore = _calculateCostScore(result, ingredientCache);
    final safetyScore = _calculateSafetyScore(result, ingredientCache);

    // Weighted average
    final totalScore =
        (nutritionalScore * 0.5) + (costScore * 0.25) + (safetyScore * 0.25);

    return totalScore.clamp(0.0, 100.0);
  }

  /// Calculate nutritional adequacy score (0-100)
  double _calculateNutritionalScore(
    OptimizationResult result,
    List<OptimizationConstraint> constraints,
  ) {
    if (constraints.isEmpty) return 100.0;

    double totalScore = 0.0;
    int constraintCount = 0;

    for (final constraint in constraints) {
      final nutrientKey = constraint.nutrientName.toLowerCase();
      final achieved = result.achievedNutrients[nutrientKey] ?? 0.0;
      final target = constraint.value;

      double score;
      switch (constraint.type) {
        case ConstraintType.exact:
          // Score based on how close to exact value
          final deviation = (achieved - target).abs() / target;
          score = (1.0 - deviation.clamp(0.0, 1.0)) * 100.0;
          break;
        case ConstraintType.min:
          // Score based on how much above minimum
          if (achieved >= target) {
            // Bonus for exceeding minimum (up to 20% above)
            final excess = (achieved - target) / target;
            score = excess <= 0.2 ? 100.0 : 100.0 - (excess - 0.2) * 50.0;
          } else {
            score = (achieved / target) * 100.0;
          }
          break;
        case ConstraintType.max:
          // Score based on how much below maximum
          if (achieved <= target) {
            // Higher score for being well below max (safety margin)
            final margin = (target - achieved) / target;
            score = margin >= 0.1 ? 100.0 : 90.0 + (margin * 100.0);
          } else {
            score = (target / achieved) * 100.0;
          }
          break;
      }

      totalScore += score.clamp(0.0, 100.0);
      constraintCount++;
    }

    return constraintCount > 0 ? totalScore / constraintCount : 100.0;
  }

  /// Calculate cost efficiency score (0-100)
  double _calculateCostScore(
    OptimizationResult result,
    Map<int, Ingredient> ingredientCache,
  ) {
    final cost = result.totalCost;

    // Estimate reasonable cost range based on ingredient prices
    final avgPrice = ingredientCache.values
            .map((ing) => (ing.priceKg ?? 0.0).toDouble())
            .fold<double>(0.0, (sum, price) => sum + price) /
        ingredientCache.length;

    // Score inversely proportional to cost
    // Lower cost = higher score
    if (cost <= avgPrice * 0.5) {
      return 100.0; // Excellent cost
    } else if (cost <= avgPrice) {
      return 80.0 + ((avgPrice - cost) / (avgPrice * 0.5)) * 20.0;
    } else if (cost <= avgPrice * 1.5) {
      return 60.0 + ((avgPrice * 1.5 - cost) / (avgPrice * 0.5)) * 20.0;
    } else if (cost <= avgPrice * 2.0) {
      return 40.0 + ((avgPrice * 2.0 - cost) / (avgPrice * 0.5)) * 20.0;
    } else {
      return (avgPrice * 2.0 / cost) * 40.0; // Poor cost
    }
  }

  /// Calculate safety margin score (0-100)
  double _calculateSafetyScore(
    OptimizationResult result,
    Map<int, Ingredient> ingredientCache,
  ) {
    double totalScore = 0.0;
    int checkCount = 0;

    // Check inclusion limits
    for (final entry in result.ingredientProportions.entries) {
      final ingredient = ingredientCache[entry.key];
      if (ingredient == null) continue;

      final proportion = entry.value;
      final maxInclusion = ingredient.maxInclusionPct?.toDouble() ?? 100.0;

      // Score based on safety margin from max inclusion
      if (maxInclusion > 0) {
        final utilizationRatio = proportion / maxInclusion;
        double score;
        if (utilizationRatio <= 0.7) {
          score = 100.0; // Safe margin
        } else if (utilizationRatio <= 0.9) {
          score = 80.0 + (0.9 - utilizationRatio) * 100.0;
        } else if (utilizationRatio <= 1.0) {
          score = 60.0 + (1.0 - utilizationRatio) * 200.0;
        } else {
          score = 0.0; // Exceeded limit
        }

        totalScore += score;
        checkCount++;
      }
    }

    // Check for warnings
    final warningPenalty = (result.warnings?.length ?? 0) * 10.0;

    final baseScore = checkCount > 0 ? totalScore / checkCount : 100.0;
    return (baseScore - warningPenalty).clamp(0.0, 100.0);
  }

  /// Compare two formulations and return comparison result
  FormulationComparison compareFormulations({
    required OptimizationResult formulation1,
    required OptimizationResult formulation2,
    required List<OptimizationConstraint> constraints,
    required Map<int, Ingredient> ingredientCache,
  }) {
    final score1 = calculateQualityScore(
      result: formulation1,
      constraints: constraints,
      ingredientCache: ingredientCache,
    );

    final score2 = calculateQualityScore(
      result: formulation2,
      constraints: constraints,
      ingredientCache: ingredientCache,
    );

    final costDiff = formulation2.totalCost - formulation1.totalCost;
    final scoreDiff = score2 - score1;

    String recommendation;
    if (scoreDiff > 5.0) {
      recommendation =
          'Formulation 2 is significantly better (${scoreDiff.toStringAsFixed(1)} points higher)';
    } else if (scoreDiff < -5.0) {
      recommendation =
          'Formulation 1 is significantly better (${(-scoreDiff).toStringAsFixed(1)} points higher)';
    } else if (costDiff.abs() > 1.0) {
      if (costDiff > 0) {
        recommendation =
            'Formulation 1 is cheaper by \$${costDiff.toStringAsFixed(2)}';
      } else {
        recommendation =
            'Formulation 2 is cheaper by \$${(-costDiff).toStringAsFixed(2)}';
      }
    } else {
      recommendation = 'Both formulations are comparable';
    }

    return FormulationComparison(
      score1: score1,
      score2: score2,
      scoreDifference: scoreDiff,
      costDifference: costDiff,
      recommendation: recommendation,
    );
  }

  /// Calculate cost per unit of protein
  double calculateCostPerProtein(OptimizationResult result) {
    final protein = result.achievedNutrients['crudeprotein'] ??
        result.achievedNutrients['protein'] ??
        0.0;
    if (protein == 0.0) return double.infinity;
    return result.totalCost / protein;
  }

  /// Calculate cost per unit of energy
  double calculateCostPerEnergy(OptimizationResult result) {
    final energy = result.achievedNutrients['energy'] ?? 0.0;
    if (energy == 0.0) return double.infinity;
    return result.totalCost / energy;
  }

  /// Get formulation efficiency metrics
  FormulationMetrics getMetrics({
    required OptimizationResult result,
    required List<OptimizationConstraint> constraints,
    required Map<int, Ingredient> ingredientCache,
  }) {
    return FormulationMetrics(
      qualityScore: calculateQualityScore(
        result: result,
        constraints: constraints,
        ingredientCache: ingredientCache,
      ),
      costPerProtein: calculateCostPerProtein(result),
      costPerEnergy: calculateCostPerEnergy(result),
      totalCost: result.totalCost,
      ingredientCount: result.ingredientProportions.length,
      warningCount: result.warnings?.length ?? 0,
    );
  }
}

/// Comparison result between two formulations
class FormulationComparison {
  final double score1;
  final double score2;
  final double scoreDifference;
  final double costDifference;
  final String recommendation;

  FormulationComparison({
    required this.score1,
    required this.score2,
    required this.scoreDifference,
    required this.costDifference,
    required this.recommendation,
  });
}

/// Formulation efficiency metrics
class FormulationMetrics {
  final double qualityScore;
  final double costPerProtein;
  final double costPerEnergy;
  final double totalCost;
  final int ingredientCount;
  final int warningCount;

  FormulationMetrics({
    required this.qualityScore,
    required this.costPerProtein,
    required this.costPerEnergy,
    required this.totalCost,
    required this.ingredientCount,
    required this.warningCount,
  });

  @override
  String toString() => 'FormulationMetrics('
      'score: ${qualityScore.toStringAsFixed(1)}, '
      'cost: \$${totalCost.toStringAsFixed(2)}, '
      'ingredients: $ingredientCount, '
      'warnings: $warningCount)';
}

import '../model/optimization_constraint.dart';
import '../model/optimization_result.dart';
import '../../add_ingredients/model/ingredient.dart';

/// Service for validating optimization constraints and results
class ConstraintValidator {
  /// Validate a single constraint
  ValidationResult validateConstraint(OptimizationConstraint constraint) {
    // Check if value is positive
    if (constraint.value < 0) {
      return ValidationResult(
        isValid: false,
        message: '${constraint.nutrientName}: Value cannot be negative',
      );
    }

    // Check if value is reasonable (not too large)
    if (constraint.value > 1000) {
      return ValidationResult(
        isValid: false,
        message:
            '${constraint.nutrientName}: Value seems unreasonably high (${constraint.value})',
      );
    }

    return ValidationResult(isValid: true, message: 'Valid');
  }

  /// Validate a list of constraints for conflicts
  ValidationResult validateConstraints(
      List<OptimizationConstraint> constraints) {
    if (constraints.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'At least one constraint is required',
      );
    }

    // Group constraints by nutrient
    final nutrientGroups = <String, List<OptimizationConstraint>>{};
    for (final constraint in constraints) {
      nutrientGroups
          .putIfAbsent(constraint.nutrientName.toLowerCase(), () => [])
          .add(constraint);
    }

    // Check each nutrient for conflicts
    for (final entry in nutrientGroups.entries) {
      final nutrient = entry.key;
      final nutrientConstraints = entry.value;

      double? minValue;
      double? maxValue;
      double? exactValue;

      for (final constraint in nutrientConstraints) {
        switch (constraint.type) {
          case ConstraintType.min:
            if (minValue != null && constraint.value != minValue) {
              return ValidationResult(
                isValid: false,
                message: 'Multiple different minimum values for $nutrient',
              );
            }
            minValue = constraint.value;
            break;
          case ConstraintType.max:
            if (maxValue != null && constraint.value != maxValue) {
              return ValidationResult(
                isValid: false,
                message: 'Multiple different maximum values for $nutrient',
              );
            }
            maxValue = constraint.value;
            break;
          case ConstraintType.exact:
            if (exactValue != null && constraint.value != exactValue) {
              return ValidationResult(
                isValid: false,
                message: 'Multiple different exact values for $nutrient',
              );
            }
            exactValue = constraint.value;
            break;
        }
      }

      // Check for conflicts
      if (exactValue != null && (minValue != null || maxValue != null)) {
        return ValidationResult(
          isValid: false,
          message: 'Cannot have exact value with min/max for $nutrient',
        );
      }

      if (minValue != null && maxValue != null && minValue > maxValue) {
        return ValidationResult(
          isValid: false,
          message: 'Minimum ($minValue) > Maximum ($maxValue) for $nutrient',
        );
      }
    }

    return ValidationResult(isValid: true, message: 'All constraints valid');
  }

  /// Validate optimization result against constraints
  ValidationResult validateResult(
    OptimizationResult result,
    List<OptimizationConstraint> constraints,
  ) {
    if (!result.success) {
      return ValidationResult(
        isValid: false,
        message: result.errorMessage ?? 'Optimization failed',
      );
    }

    final violations = <String>[];

    for (final constraint in constraints) {
      final nutrientKey = constraint.nutrientName.toLowerCase();
      final achievedValue = result.achievedNutrients[nutrientKey];

      if (achievedValue == null) {
        violations.add('${constraint.nutrientName}: No value achieved');
        continue;
      }

      switch (constraint.type) {
        case ConstraintType.min:
          if (achievedValue < constraint.value) {
            violations.add(
              '${constraint.nutrientName}: $achievedValue < ${constraint.value} (min)',
            );
          }
          break;
        case ConstraintType.max:
          if (achievedValue > constraint.value) {
            violations.add(
              '${constraint.nutrientName}: $achievedValue > ${constraint.value} (max)',
            );
          }
          break;
        case ConstraintType.exact:
          final tolerance = constraint.value * 0.01; // 1% tolerance
          if ((achievedValue - constraint.value).abs() > tolerance) {
            violations.add(
              '${constraint.nutrientName}: $achievedValue ≠ ${constraint.value} (exact)',
            );
          }
          break;
      }
    }

    if (violations.isNotEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Constraint violations:\n${violations.join('\n')}',
        violations: violations,
      );
    }

    return ValidationResult(
      isValid: true,
      message: 'All constraints satisfied',
    );
  }

  /// Check if ingredients meet minimum requirements
  ValidationResult validateIngredientAvailability(
    List<int> ingredientIds,
    Map<int, Ingredient> ingredientCache,
  ) {
    if (ingredientIds.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'No ingredients selected',
      );
    }

    final missing = <int>[];
    for (final id in ingredientIds) {
      if (!ingredientCache.containsKey(id)) {
        missing.add(id);
      }
    }

    if (missing.isNotEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Missing ingredients: ${missing.join(', ')}',
      );
    }

    return ValidationResult(
      isValid: true,
      message: 'All ingredients available',
    );
  }

  /// Validate ingredient proportions sum to 100%
  ValidationResult validateProportions(Map<int, double> proportions) {
    if (proportions.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'No ingredient proportions',
      );
    }

    final total = proportions.values.fold<double>(0.0, (sum, val) => sum + val);
    const tolerance = 0.1; // 0.1% tolerance

    if ((total - 100.0).abs() > tolerance) {
      return ValidationResult(
        isValid: false,
        message: 'Proportions sum to $total%, expected 100%',
      );
    }

    // Check for negative proportions
    final negative = proportions.entries
        .where((e) => e.value < 0)
        .map((e) => e.key)
        .toList();

    if (negative.isNotEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Negative proportions for ingredients: ${negative.join(', ')}',
      );
    }

    return ValidationResult(
      isValid: true,
      message: 'Proportions valid (total: ${total.toStringAsFixed(2)}%)',
    );
  }
}

/// Result of a validation check
class ValidationResult {
  final bool isValid;
  final String message;
  final List<String>? violations;

  ValidationResult({
    required this.isValid,
    required this.message,
    this.violations,
  });

  @override
  String toString() => isValid ? 'Valid: $message' : 'Invalid: $message';
}

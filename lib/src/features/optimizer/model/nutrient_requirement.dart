import 'optimization_constraint.dart';

/// Nutrient requirement model for animal categories
class NutrientRequirement {
  final String nutrientName;
  final double? minValue;
  final double? maxValue;
  final double? targetValue; // Recommended/optimal value
  final String unit;
  final String source; // e.g., "NRC 2012", "CVB 2021"
  final String? notes;

  const NutrientRequirement({
    required this.nutrientName,
    this.minValue,
    this.maxValue,
    this.targetValue,
    required this.unit,
    required this.source,
    this.notes,
  });

  /// Convert to optimization constraints
  List<OptimizationConstraint> toConstraints() {
    final constraints = <OptimizationConstraint>[];

    if (minValue != null) {
      constraints.add(OptimizationConstraint(
        nutrientName: nutrientName,
        type: ConstraintType.min,
        value: minValue!,
        unit: unit,
      ));
    }

    if (maxValue != null) {
      constraints.add(OptimizationConstraint(
        nutrientName: nutrientName,
        type: ConstraintType.max,
        value: maxValue!,
        unit: unit,
      ));
    }

    // If only target value is provided, use it as exact constraint
    if (targetValue != null && minValue == null && maxValue == null) {
      constraints.add(OptimizationConstraint(
        nutrientName: nutrientName,
        type: ConstraintType.exact,
        value: targetValue!,
        unit: unit,
      ));
    }

    return constraints;
  }

  Map<String, dynamic> toJson() => {
        'nutrientName': nutrientName,
        'minValue': minValue,
        'maxValue': maxValue,
        'targetValue': targetValue,
        'unit': unit,
        'source': source,
        'notes': notes,
      };

  factory NutrientRequirement.fromJson(Map<String, dynamic> json) =>
      NutrientRequirement(
        nutrientName: json['nutrientName'] as String,
        minValue: json['minValue'] as double?,
        maxValue: json['maxValue'] as double?,
        targetValue: json['targetValue'] as double?,
        unit: json['unit'] as String,
        source: json['source'] as String,
        notes: json['notes'] as String?,
      );
}

/// Animal category with production stage
class AnimalCategory {
  final String species; // e.g., "Poultry", "Swine"
  final String stage; // e.g., "Starter", "Grower"
  final String description;
  final List<NutrientRequirement> requirements;

  const AnimalCategory({
    required this.species,
    required this.stage,
    required this.description,
    required this.requirements,
  });

  String get displayName => '$species - $stage';

  /// Get all constraints from requirements
  List<OptimizationConstraint> getAllConstraints() {
    return requirements.expand((req) => req.toConstraints()).toList();
  }
}

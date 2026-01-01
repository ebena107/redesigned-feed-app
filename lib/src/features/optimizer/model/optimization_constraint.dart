/// Optimization constraint representing a nutritional requirement
class OptimizationConstraint {
  final String nutrientName; // e.g., "crudeProtein", "lysine", "calcium"
  final ConstraintType type; // MIN, MAX, EXACT
  final double value; // constraint value
  final String unit; // %, g/kg, kcal/kg
  final String? animalCategory; // optional: specific to animal type

  const OptimizationConstraint({
    required this.nutrientName,
    required this.type,
    required this.value,
    required this.unit,
    this.animalCategory,
  });

  OptimizationConstraint copyWith({
    String? nutrientName,
    ConstraintType? type,
    double? value,
    String? unit,
    String? animalCategory,
  }) {
    return OptimizationConstraint(
      nutrientName: nutrientName ?? this.nutrientName,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      animalCategory: animalCategory ?? this.animalCategory,
    );
  }

  Map<String, dynamic> toJson() => {
        'nutrientName': nutrientName,
        'type': type.name,
        'value': value,
        'unit': unit,
        'animalCategory': animalCategory,
      };

  factory OptimizationConstraint.fromJson(Map<String, dynamic> json) {
    return OptimizationConstraint(
      nutrientName: json['nutrientName'] as String,
      type: ConstraintType.values.firstWhere((e) => e.name == json['type']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      animalCategory: json['animalCategory'] as String?,
    );
  }

  @override
  String toString() =>
      'OptimizationConstraint($nutrientName ${type.name} $value $unit)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimizationConstraint &&
          runtimeType == other.runtimeType &&
          nutrientName == other.nutrientName &&
          type == other.type &&
          value == other.value &&
          unit == other.unit &&
          animalCategory == other.animalCategory;

  @override
  int get hashCode =>
      nutrientName.hashCode ^
      type.hashCode ^
      value.hashCode ^
      unit.hashCode ^
      (animalCategory?.hashCode ?? 0);
}

/// Type of constraint
enum ConstraintType {
  min, // Minimum requirement
  max, // Maximum limit
  exact, // Exact value
}

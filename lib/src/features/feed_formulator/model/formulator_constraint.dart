enum NutrientKey {
  energy,
  protein,
  lysine,
  methionine,
  calcium,
  phosphorus,
}

/// Represents a min/max constraint for a specific nutrient
///
/// UNIT DEFINITIONS (CORRECTED - NRC 2012 ACTUAL STANDARDS):
/// - energy: kcal/kg (kilocalories per kilogram, metabolizable energy)
///   • Matches ingredient energy storage (mePoultry, meGrowingPig, etc.)
///   • NRC 2012 Standards:
///     - Swine Starter: 3300-3400 kcal/kg
///     - Swine Grower: 3200-3300 kcal/kg
///     - Swine Finisher: 3100-3200 kcal/kg
///     - Poultry Starter: 2900-3000 kcal/kg
///     - Poultry Grower: 3050-3150 kcal/kg
///     - Poultry Finisher: 3100-3200 kcal/kg
/// - protein: % (percentage of feed dry matter) - e.g., 20%
/// - lysine: % (percentage of feed) - e.g., 1.2%
/// - methionine: % (percentage of feed) - e.g., 0.4%
/// - calcium: % (percentage of feed) - e.g., 0.7%
/// - phosphorus: % (percentage of feed) - e.g., 0.6%
///
/// Thresholds for detecting overly narrow ranges:
/// - Energy: ±150 kcal/kg (NRC ranges typically 100-150 kcal variation)
/// - Nutrients: ±0.5% (smaller percentage values, tighter threshold)
sealed class NutrientConstraint {
  const NutrientConstraint({
    required this.key,
    this.min,
    this.max,
  });

  final NutrientKey key;
  final double? min;
  final double? max;

  NutrientConstraint copyWith({
    double? min,
    double? max,
  });

  /// Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'key': key.index,
      'min': min,
      'max': max,
    };
  }

  /// Create from JSON
  static NutrientConstraint fromJson(Map<String, dynamic> json) {
    return _NutrientConstraint(
      key: NutrientKey.values[json['key'] as int],
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }
}

/// Private implementation of NutrientConstraint
class _NutrientConstraint extends NutrientConstraint {
  const _NutrientConstraint({
    required super.key,
    super.min,
    super.max,
  });

  @override
  NutrientConstraint copyWith({
    double? min,
    double? max,
  }) {
    return _NutrientConstraint(
      key: key,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}

/// Factory function to create NutrientConstraint instances
NutrientConstraint createNutrientConstraint({
  required NutrientKey key,
  double? min,
  double? max,
}) {
  return _NutrientConstraint(
    key: key,
    min: min,
    max: max,
  );
}

/// Optimization request containing all parameters for feed formulation optimization
class OptimizationRequest {
  final List<OptimizationConstraint> constraints;
  final List<int> availableIngredientIds;
  final Map<int, double> ingredientPrices; // ingredientId -> price per kg
  final ObjectiveFunction objective;
  final Map<int, InclusionLimit>? ingredientLimits; // optional custom limits
  final int? animalTypeId;
  final String? formulationName;

  const OptimizationRequest({
    required this.constraints,
    required this.availableIngredientIds,
    required this.ingredientPrices,
    required this.objective,
    this.ingredientLimits,
    this.animalTypeId,
    this.formulationName,
  });

  Map<String, dynamic> toJson() => {
        'constraints': constraints.map((c) => c.toJson()).toList(),
        'availableIngredientIds': availableIngredientIds,
        'ingredientPrices':
            ingredientPrices.map((k, v) => MapEntry(k.toString(), v)),
        'objective': objective.name,
        'ingredientLimits':
            ingredientLimits?.map((k, v) => MapEntry(k.toString(), v.toJson())),
        'animalTypeId': animalTypeId,
        'formulationName': formulationName,
      };

  factory OptimizationRequest.fromJson(Map<String, dynamic> json) {
    return OptimizationRequest(
      constraints: (json['constraints'] as List)
          .map(
              (c) => OptimizationConstraint.fromJson(c as Map<String, dynamic>))
          .toList(),
      availableIngredientIds:
          (json['availableIngredientIds'] as List).cast<int>(),
      ingredientPrices: (json['ingredientPrices'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(int.parse(k), (v as num).toDouble())),
      objective: ObjectiveFunction.values
          .firstWhere((e) => e.name == json['objective']),
      ingredientLimits: json['ingredientLimits'] != null
          ? (json['ingredientLimits'] as Map<String, dynamic>).map(
              (k, v) => MapEntry(
                int.parse(k),
                InclusionLimit.fromJson(v as Map<String, dynamic>),
              ),
            )
          : null,
      animalTypeId: json['animalTypeId'] as int?,
      formulationName: json['formulationName'] as String?,
    );
  }

  @override
  String toString() =>
      'OptimizationRequest(${constraints.length} constraints, ${availableIngredientIds.length} ingredients, objective: ${objective.name})';
}

/// Objective function for optimization
enum ObjectiveFunction {
  minimizeCost, // Minimize total formulation cost
  maximizeProtein, // Maximize crude protein content
  maximizeEnergy, // Maximize energy content
}

/// Inclusion limit for an ingredient
class InclusionLimit {
  final double minPct; // Minimum percentage (0-100)
  final double maxPct; // Maximum percentage (0-100)

  const InclusionLimit({
    required this.minPct,
    required this.maxPct,
  });

  Map<String, dynamic> toJson() => {
        'minPct': minPct,
        'maxPct': maxPct,
      };

  factory InclusionLimit.fromJson(Map<String, dynamic> json) {
    return InclusionLimit(
      minPct: (json['minPct'] as num).toDouble(),
      maxPct: (json['maxPct'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'InclusionLimit($minPct%-$maxPct%)';
}

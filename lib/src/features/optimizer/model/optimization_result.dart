/// Result of feed formulation optimization
class OptimizationResult {
  final bool success;
  final Map<int, double> ingredientProportions; // ingredientId -> percentage
  final double totalCost;
  final double qualityScore;
  final Map<String, double> achievedNutrients;
  final List<String>? warnings;
  final String? errorMessage; // if success = false
  final DateTime? timestamp;

  const OptimizationResult({
    required this.success,
    required this.ingredientProportions,
    required this.totalCost,
    required this.qualityScore,
    required this.achievedNutrients,
    this.warnings,
    this.errorMessage,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'success': success,
        'ingredientProportions':
            ingredientProportions.map((k, v) => MapEntry(k.toString(), v)),
        'totalCost': totalCost,
        'qualityScore': qualityScore,
        'achievedNutrients': achievedNutrients,
        'warnings': warnings,
        'errorMessage': errorMessage,
        'timestamp': timestamp?.toIso8601String(),
      };

  factory OptimizationResult.fromJson(Map<String, dynamic> json) {
    return OptimizationResult(
      success: json['success'] as bool,
      ingredientProportions:
          (json['ingredientProportions'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(int.parse(k), (v as num).toDouble())),
      totalCost: (json['totalCost'] as num).toDouble(),
      qualityScore: (json['qualityScore'] as num).toDouble(),
      achievedNutrients: (json['achievedNutrients'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      warnings: (json['warnings'] as List<dynamic>?)?.cast<String>(),
      errorMessage: json['errorMessage'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  /// Create a failed result
  factory OptimizationResult.failure(String message) {
    return OptimizationResult(
      success: false,
      ingredientProportions: {},
      totalCost: 0.0,
      qualityScore: 0.0,
      achievedNutrients: {},
      errorMessage: message,
      timestamp: DateTime.now(),
    );
  }

  /// Create a successful result
  factory OptimizationResult.successResult({
    required Map<int, double> proportions,
    required double cost,
    required double score,
    required Map<String, double> nutrients,
    List<String>? warnings,
  }) {
    return OptimizationResult(
      success: true,
      ingredientProportions: proportions,
      totalCost: cost,
      qualityScore: score,
      achievedNutrients: nutrients,
      warnings: warnings,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() => success
      ? 'OptimizationResult(success, cost: \$$totalCost, score: $qualityScore)'
      : 'OptimizationResult(failed: $errorMessage)';
}

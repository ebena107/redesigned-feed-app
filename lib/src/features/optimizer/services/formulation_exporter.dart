import 'dart:convert';
import '../model/optimization_result.dart';
import '../model/optimization_constraint.dart';
import '../model/optimization_request.dart';
import '../../add_ingredients/model/ingredient.dart';
import '../../main/model/feed.dart';

/// Service for exporting formulations in various formats
class FormulationExporter {
  /// Export formulation as JSON
  String exportAsJson({
    required OptimizationResult result,
    required OptimizationRequest request,
    required Map<int, Ingredient> ingredientCache,
    String? feedName,
  }) {
    final export = {
      'feedName': feedName ?? 'Optimized Feed',
      'timestamp': DateTime.now().toIso8601String(),
      'success': result.success,
      'qualityScore': result.qualityScore,
      'totalCost': result.totalCost,
      'objective': request.objective.name,
      'constraints': request.constraints.map((c) => c.toJson()).toList(),
      'ingredients': result.ingredientProportions.entries.map((entry) {
        final ingredient = ingredientCache[entry.key];
        return {
          'id': entry.key,
          'name': ingredient?.name ?? 'Unknown',
          'proportion': entry.value,
          'price': request.ingredientPrices[entry.key] ?? 0.0,
        };
      }).toList(),
      'achievedNutrients': result.achievedNutrients,
      'warnings': result.warnings,
    };

    return const JsonEncoder.withIndent('  ').convert(export);
  }

  /// Export formulation as CSV
  String exportAsCsv({
    required OptimizationResult result,
    required OptimizationRequest request,
    required Map<int, Ingredient> ingredientCache,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
        'Ingredient ID,Ingredient Name,Proportion (%),Price per kg,Cost Contribution');

    // Ingredients
    for (final entry in result.ingredientProportions.entries) {
      final ingredient = ingredientCache[entry.key];
      final price = request.ingredientPrices[entry.key] ?? 0.0;
      final costContribution = (entry.value / 100.0) * price;

      buffer.writeln(
        '${entry.key},'
        '"${ingredient?.name ?? 'Unknown'}",'
        '${entry.value.toStringAsFixed(2)},'
        '${price.toStringAsFixed(2)},'
        '${costContribution.toStringAsFixed(2)}',
      );
    }

    // Summary
    buffer.writeln();
    buffer.writeln('Summary');
    buffer.writeln('Total Cost,${result.totalCost.toStringAsFixed(2)}');
    buffer.writeln('Quality Score,${result.qualityScore.toStringAsFixed(1)}');
    buffer.writeln('Objective,${request.objective.name}');

    // Achieved nutrients
    buffer.writeln();
    buffer.writeln('Achieved Nutrients');
    buffer.writeln('Nutrient,Value');
    for (final entry in result.achievedNutrients.entries) {
      buffer.writeln('${entry.key},${entry.value.toStringAsFixed(2)}');
    }

    return buffer.toString();
  }

  /// Export formulation as human-readable text report
  String exportAsTextReport({
    required OptimizationResult result,
    required OptimizationRequest request,
    required Map<int, Ingredient> ingredientCache,
    String? feedName,
  }) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('=' * 60);
    buffer.writeln('FEED FORMULATION REPORT');
    buffer.writeln('=' * 60);
    buffer.writeln();
    buffer.writeln('Feed Name: ${feedName ?? 'Optimized Feed'}');
    buffer.writeln('Generated: ${DateTime.now().toString()}');
    buffer.writeln('Optimization Objective: ${request.objective.name}');
    buffer.writeln(
        'Quality Score: ${result.qualityScore.toStringAsFixed(1)}/100');
    buffer.writeln('Total Cost: \$${result.totalCost.toStringAsFixed(2)}');
    buffer.writeln();

    // Ingredients
    buffer.writeln('-' * 60);
    buffer.writeln('INGREDIENT COMPOSITION');
    buffer.writeln('-' * 60);
    buffer.writeln();

    final sortedIngredients = result.ingredientProportions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by proportion desc

    for (final entry in sortedIngredients) {
      final ingredient = ingredientCache[entry.key];
      final price = request.ingredientPrices[entry.key] ?? 0.0;
      final costContribution = (entry.value / 100.0) * price;

      buffer.writeln(ingredient?.name ?? 'Unknown Ingredient');
      buffer.writeln('  Proportion: ${entry.value.toStringAsFixed(2)}%');
      buffer.writeln('  Price: \$${price.toStringAsFixed(2)}/kg');
      buffer.writeln(
          '  Cost Contribution: \$${costContribution.toStringAsFixed(2)}');
      buffer.writeln();
    }

    // Nutritional Profile
    buffer.writeln('-' * 60);
    buffer.writeln('NUTRITIONAL PROFILE');
    buffer.writeln('-' * 60);
    buffer.writeln();

    for (final entry in result.achievedNutrients.entries) {
      buffer.writeln(
          '${_formatNutrientName(entry.key)}: ${entry.value.toStringAsFixed(2)}');
    }
    buffer.writeln();

    // Constraints
    buffer.writeln('-' * 60);
    buffer.writeln('CONSTRAINTS');
    buffer.writeln('-' * 60);
    buffer.writeln();

    for (final constraint in request.constraints) {
      final achieved =
          result.achievedNutrients[constraint.nutrientName.toLowerCase()] ??
              0.0;
      final status = _checkConstraintStatus(constraint, achieved);

      buffer.writeln('${constraint.nutrientName}:');
      buffer.writeln(
          '  Target: ${constraint.type.name} ${constraint.value} ${constraint.unit}');
      buffer.writeln(
          '  Achieved: ${achieved.toStringAsFixed(2)} ${constraint.unit}');
      buffer.writeln('  Status: $status');
      buffer.writeln();
    }

    // Warnings
    if (result.warnings != null && result.warnings!.isNotEmpty) {
      buffer.writeln('-' * 60);
      buffer.writeln('WARNINGS');
      buffer.writeln('-' * 60);
      buffer.writeln();

      for (final warning in result.warnings!) {
        buffer.writeln('⚠ $warning');
      }
      buffer.writeln();
    }

    buffer.writeln('=' * 60);
    buffer.writeln('END OF REPORT');
    buffer.writeln('=' * 60);

    return buffer.toString();
  }

  /// Export formulation as Feed object for database storage
  Feed exportAsFeed({
    required OptimizationResult result,
    required OptimizationRequest request,
    required String feedName,
    required int animalId,
    String? productionStage,
  }) {
    final feedIngredients = result.ingredientProportions.entries.map((entry) {
      return FeedIngredients(
        ingredientId: entry.key,
        quantity: entry.value / 100.0,
        priceUnitKg: request.ingredientPrices[entry.key] ?? 0.0,
      );
    }).toList();

    final constraintsJson = jsonEncode(
      request.constraints.map((c) => c.toJson()).toList(),
    );

    return Feed(
      feedName: feedName,
      animalId: animalId,
      feedIngredients: feedIngredients,
      productionStage: productionStage,
      isOptimized: true,
      optimizationConstraintsJson: constraintsJson,
      optimizationScore: result.qualityScore,
      optimizationObjective: request.objective.name,
      timestampModified: DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _formatNutrientName(String key) {
    // Convert camelCase to Title Case
    final words = key
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim()
        .split(' ');

    return words
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _checkConstraintStatus(
      OptimizationConstraint constraint, double achieved) {
    switch (constraint.type) {
      case ConstraintType.min:
        return achieved >= constraint.value ? '✓ Met' : '✗ Below target';
      case ConstraintType.max:
        return achieved <= constraint.value ? '✓ Met' : '✗ Exceeded';
      case ConstraintType.exact:
        final tolerance = constraint.value * 0.01;
        return (achieved - constraint.value).abs() <= tolerance
            ? '✓ Met'
            : '✗ Off target';
    }
  }
}

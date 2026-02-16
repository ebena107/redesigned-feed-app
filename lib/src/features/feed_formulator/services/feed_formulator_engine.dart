import 'dart:math';

import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/dual_extractor.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/formulation_recommendation_service.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/linear_program_solver.dart';

class FeedFormulatorEngine {
  FeedFormulatorEngine(
      {LinearProgramSolver? solver, DualExtractor? dualExtractor})
      : _solver = solver ?? LinearProgramSolver(),
        _dualExtractor = dualExtractor ?? DualExtractor();

  final LinearProgramSolver _solver;
  final DualExtractor _dualExtractor;

  FormulatorResult formulate({
    required List<Ingredient> ingredients,
    required List<NutrientConstraint> constraints,
    required int animalTypeId,
    String? feedTypeName,
    bool enforceMaxInclusion = true,
  }) {
    if (ingredients.isEmpty) {
      throw CalculationException(
        operation: 'formulate',
        message: 'No ingredients provided for formulation.',
      );
    }

    // Validate constraints are feasible with available ingredients
    _validateFeasibility(ingredients, constraints, animalTypeId);

    final warnings = <String>[];
    final objective = _buildObjective(ingredients, warnings);
    final lpConstraints = <LinearConstraint>[];

    // Sum of all ingredient fractions equals 1.
    lpConstraints.add(
      LinearConstraint(
        coefficients: List<double>.filled(ingredients.length, 1),
        rhs: 1,
        type: ConstraintType.equal,
      ),
    );

    // Enforce non-negative fractions AND minimum inclusion (all ingredients must be used)
    // Minimum = 5% per ingredient ensures all selected ingredients are included in the blend
    const double minInclusionPct =
        5.0; // All ingredients must be at least 5% of formulation

    print('\n🔒 ADDING MINIMUM INCLUSION CONSTRAINTS (5% per ingredient):');
    for (var i = 0; i < ingredients.length; i++) {
      final coeffs = List<double>.filled(ingredients.length, 0);
      coeffs[i] = 1;

      // Minimum inclusion: x_i >= 0.05 (5%)
      lpConstraints.add(
        LinearConstraint(
          coefficients: coeffs,
          rhs: minInclusionPct / 100,
          type: ConstraintType.greaterOrEqual,
        ),
      );
      print('   ${ingredients[i].name} >= 5%');
    }

    if (enforceMaxInclusion) {
      for (var i = 0; i < ingredients.length; i++) {
        // Get max inclusion % for this specific animal type & feed stage
        double? maxPct;

        final maxInclusionJson = ingredients[i].maxInclusionJson;
        if (maxInclusionJson != null &&
            maxInclusionJson.isNotEmpty &&
            feedTypeName != null) {
          // Build key from animal type ID and feed stage name
          final key = _getInclusionKey(animalTypeId, feedTypeName);

          if (key != null && maxInclusionJson.containsKey(key)) {
            maxPct = (maxInclusionJson[key] as num?)?.toDouble();
          }
        }

        // Fallback to generic maxInclusionPct if specific key not found
        if (maxPct == null) {
          maxPct = ingredients[i].maxInclusionPct?.toDouble();
        }

        if (maxPct != null && maxPct > 0) {
          final coeffs = List<double>.filled(ingredients.length, 0);
          coeffs[i] = 1;
          lpConstraints.add(
            LinearConstraint(
              coefficients: coeffs,
              rhs: maxPct / 100,
              type: ConstraintType.lessOrEqual,
            ),
          );
        }
      }
    }

    for (final constraint in constraints) {
      final coeffs = ingredients
          .map((ingredient) =>
              _nutrientValue(ingredient, constraint.key, animalTypeId))
          .toList();

      if (constraint.min != null) {
        lpConstraints.add(
          LinearConstraint(
            coefficients: coeffs,
            rhs: constraint.min!,
            type: ConstraintType.greaterOrEqual,
          ),
        );
      }

      if (constraint.max != null) {
        lpConstraints.add(
          LinearConstraint(
            coefficients: coeffs,
            rhs: constraint.max!,
            type: ConstraintType.lessOrEqual,
          ),
        );
      }
    }

    final solution = _solver.solve(
      objective: objective,
      constraints: lpConstraints,
    );

    print('\n📊 SOLVER RESULT:');
    print(
        '   Status: ${solution.isOptimal ? "OPTIMAL" : solution.isInfeasible ? "INFEASIBLE" : "SUBOPTIMAL"}');
    if (solution.isOptimal || solution.solution.isNotEmpty) {
      print('   Solution values:');
      for (var i = 0; i < ingredients.length; i++) {
        final pct = solution.solution[i] * 100;
        print('      ${ingredients[i].name}: ${pct.toStringAsFixed(2)}%');
      }
    }

    if (solution.isInfeasible || !solution.isOptimal) {
      if (solution.isInfeasible) {
        warnings.addAll(
          FormulationRecommendationService.generateRecommendations(
            ingredients: ingredients,
            constraints: constraints,
            animalTypeId: animalTypeId,
            enforceMaxInclusion: enforceMaxInclusion,
          ),
        );
      }

      return FormulatorResult(
        ingredientPercents: _defaultPercents(ingredients),
        costPerKg: 0,
        nutrients: _calculateNutrients(
          ingredients,
          List<double>.filled(ingredients.length, 0),
          constraints,
          animalTypeId,
        ),
        status: _statusFromResult(solution),
        warnings: warnings,
      );
    }

    final percents = <num, double>{};
    for (var i = 0; i < ingredients.length; i++) {
      final id = ingredients[i].ingredientId ?? i;
      percents[id] = solution.solution[i] * 100;
      if (ingredients[i].ingredientId == null) {
        warnings.add('Ingredient at index $i has no ID; using index as key.');
      }
    }

    final nutrients = _calculateNutrients(
      ingredients,
      solution.solution,
      constraints,
      animalTypeId,
    );

    final limiting = _detectLimitingNutrients(constraints, nutrients);

    // Calculate shadow prices using DualExtractor (500-3000x faster than finite difference)
    final shadowPrices = _calculateShadowPrices(
      solution: solution,
      constraints: constraints,
      numVariables: ingredients.length,
    );

    return FormulatorResult(
      ingredientPercents: percents,
      costPerKg: _calculateCost(objective, solution.solution),
      nutrients: nutrients,
      status: _statusFromResult(solution),
      warnings: warnings,
      limitingNutrients: limiting,
      sensitivity: shadowPrices,
    );
  }

  /// Calculate shadow prices from LP solution tableau
  ///
  /// Shadow prices represent the marginal cost of relaxing each constraint.
  /// Extracted directly from the simplex tableau for optimal performance.
  Map<num, double> _calculateShadowPrices({
    required LinearProgramResult solution,
    required List<NutrientConstraint> constraints,
    required int numVariables,
  }) {
    if (!solution.isOptimal || solution.tableau.isEmpty) {
      return {};
    }

    // Extract shadow prices for nutrient constraints
    // Note: First constraint is "sum = 1", so nutrient constraints start at index 1
    final constraintKeys = constraints.map((c) => c.key).toList();

    final shadowPricesByKey =
        _dualExtractor.extractShadowPricesWithKeys<NutrientKey>(
      tableau: solution.tableau,
      basis: solution.basis,
      numVariables: numVariables,
      constraintKeys: constraintKeys,
    );

    // Convert NutrientKey to num for compatibility with existing API
    final shadowPrices = <num, double>{};
    for (final entry in shadowPricesByKey.entries) {
      shadowPrices[entry.key.index] = entry.value;
    }

    return shadowPrices;
  }

  List<double> _buildObjective(
    List<Ingredient> ingredients,
    List<String> warnings,
  ) {
    final prices = ingredients
        .map((ingredient) => ingredient.priceKg?.toDouble())
        .whereType<double>()
        .toList();

    final defaultPrice =
        prices.isEmpty ? 0.0 : prices.reduce((a, b) => a + b) / prices.length;

    var missingPriceCount = 0;

    final objective = ingredients.map((ingredient) {
      final price = ingredient.priceKg?.toDouble();
      if (price == null) {
        missingPriceCount += 1;
        return defaultPrice;
      }
      return price;
    }).toList();

    if (missingPriceCount > 0) {
      warnings.add(
        'Missing price for $missingPriceCount ingredients; using average price.',
      );
    }

    return objective;
  }

  double _nutrientValue(
    Ingredient ingredient,
    NutrientKey key,
    int animalTypeId,
  ) {
    switch (key) {
      case NutrientKey.energy:
        return _energyValue(ingredient, animalTypeId);
      case NutrientKey.protein:
        return ingredient.crudeProtein?.toDouble() ?? 0;
      case NutrientKey.lysine:
        // UNIT CONVERSION: Lysine stored as g/kg, convert to % for constraints
        // g/kg ÷ 10 = %
        final lysineGPerKg = ingredient.lysine?.toDouble() ?? 0;
        return lysineGPerKg / 10;
      case NutrientKey.methionine:
        // UNIT CONVERSION: Methionine stored as g/kg, convert to % for constraints
        // g/kg ÷ 10 = %
        final methionineGPerKg = ingredient.methionine?.toDouble() ?? 0;
        return methionineGPerKg / 10;
      case NutrientKey.calcium:
        // UNIT CONVERSION: Calcium stored as g/kg, convert to % for constraints
        // g/kg ÷ 10 = %
        final calciumGPerKg = ingredient.calcium?.toDouble() ?? 0;
        return calciumGPerKg / 10;
      case NutrientKey.phosphorus:
        // UNIT CONVERSION: Phosphorus stored as g/kg, convert to % for constraints
        // g/kg ÷ 10 = %
        final phosphorusGPerKg = ingredient.totalPhosphorus?.toDouble() ??
            ingredient.phosphorus?.toDouble() ??
            ingredient.availablePhosphorus?.toDouble() ??
            0;
        return phosphorusGPerKg / 10;
    }
  }

  double _energyValue(Ingredient ingredient, int animalTypeId) {
    double value = 0;

    switch (animalTypeId) {
      case 1:
        value = ingredient.meGrowingPig?.toDouble() ??
            ingredient.meAdultPig?.toDouble() ??
            ingredient.meFinishingPig?.toDouble() ??
            0;
        break;
      case 2:
        value = ingredient.mePoultry?.toDouble() ?? 0;
        break;
      case 3:
        value = ingredient.meRabbit?.toDouble() ?? 0;
        break;
      case 4:
      case 5:
      case 6:
      case 7:
        value = ingredient.meRuminant?.toDouble() ?? 0;
        break;
      case 8:
      case 9:
        value = ingredient.deSalmonids?.toDouble() ?? 0;
        break;
      default:
        value = 0;
    }

    // AUTO-NORMALIZE MJ → kcal
    // If value is between 1-100, likely in MJ; convert to kcal (1 MJ ≈ 239 kcal)
    if (value > 0 && value < 100) {
      value *= 239;
    }

    return value;
  }

  Map<NutrientKey, double> _calculateNutrients(
    List<Ingredient> ingredients,
    List<double> solution,
    List<NutrientConstraint> constraints,
    int animalTypeId,
  ) {
    final keys = constraints.map((c) => c.key).toSet();
    final nutrients = <NutrientKey, double>{};

    for (final key in keys) {
      var total = 0.0;
      for (var i = 0; i < ingredients.length; i++) {
        total +=
            solution[i] * _nutrientValue(ingredients[i], key, animalTypeId);
      }
      nutrients[key] = total;
    }

    return nutrients;
  }

  List<NutrientKey> _detectLimitingNutrients(
    List<NutrientConstraint> constraints,
    Map<NutrientKey, double> nutrients,
  ) {
    const threshold = 1e-3;
    final limiting = <NutrientKey>[];

    for (final constraint in constraints) {
      final value = nutrients[constraint.key] ?? 0;
      if (constraint.min != null &&
          (value - constraint.min!).abs() < threshold) {
        limiting.add(constraint.key);
      } else if (constraint.max != null &&
          (constraint.max! - value).abs() < threshold) {
        limiting.add(constraint.key);
      }
    }

    return limiting;
  }

  double _calculateCost(List<double> prices, List<double> solution) {
    var total = 0.0;
    for (var i = 0; i < prices.length; i++) {
      total += prices[i] * solution[i];
    }
    return total;
  }

  Map<num, double> _defaultPercents(List<Ingredient> ingredients) {
    return {
      for (var i = 0; i < ingredients.length; i++)
        ingredients[i].ingredientId ?? i: 0,
    };
  }

  String _statusFromResult(LinearProgramResult result) {
    if (result.isOptimal) return 'optimal';
    if (result.isInfeasible) return 'infeasible';
    return 'failed';
  }

  /// Validates that all constraints are feasible with the given ingredients
  ///
  /// Throws [CalculationException] if a constraint is impossible to achieve:
  /// - Minimum constraint higher than max possible nutrient value
  /// - Maximum constraint lower than min possible nutrient value
  void _validateFeasibility(
    List<Ingredient> ingredients,
    List<NutrientConstraint> constraints,
    int animalTypeId,
  ) {
    for (final constraint in constraints) {
      final values = ingredients
          .map((i) => _nutrientValue(i, constraint.key, animalTypeId))
          .toList();

      if (values.isEmpty) continue;

      final maxPossible = values.reduce(max);
      final minPossible = values.reduce(min);

      // Debug logging
      final ingredientNutrients = <String>[];
      for (var i = 0; i < ingredients.length; i++) {
        final nutrientVal = values[i].toStringAsFixed(2);
        final name = ingredients[i].name ?? 'Unknown';
        ingredientNutrients.add('$name: $nutrientVal');
      }

      print('=== FEASIBILITY CHECK: ${constraint.key.name} ===');
      print('Ingredients: ${ingredientNutrients.join(' | ')}');
      print('Min possible: $minPossible, Max possible: $maxPossible');
      print('Required: min=${constraint.min}, max=${constraint.max}');

      if (constraint.min != null && constraint.min! > maxPossible) {
        throw CalculationException(
          operation: 'formulate',
          message:
              '${constraint.key.name} minimum (${constraint.min}) is impossible. '
              'Max available from ingredients = $maxPossible. '
              'Available: ${ingredientNutrients.join(", ")}',
        );
      }

      if (constraint.max != null && constraint.max! < minPossible) {
        throw CalculationException(
          operation: 'formulate',
          message:
              '${constraint.key.name} maximum (${constraint.max}) is impossible. '
              'Min available from ingredients = $minPossible. '
              'Available: ${ingredientNutrients.join(", ")}',
        );
      }
    }
  }

  /// Map animal type ID and feed type name to inclusion key
  /// Example: animalTypeId=1, feedTypeName="finisher" → "pig_finisher"
  String? _getInclusionKey(int animalTypeId, String feedTypeName) {
    final prefix = switch (animalTypeId) {
      1 => 'pig',
      2 => 'poultry',
      3 => 'rabbit',
      4 => 'ruminant_dairy',
      5 => 'ruminant_beef',
      6 => 'ruminant_sheep',
      7 => 'ruminant_goat',
      8 || 9 => 'fish',
      _ => null,
    };

    if (prefix == null) {
      print('⚠️  Unknown animal type ID: $animalTypeId');
      return null;
    }

    // Normalize feed type name to lowercase
    final normalizedFeedType = feedTypeName.toLowerCase();

    // Some feed types map to different keys
    final feedTypeKey = switch (normalizedFeedType) {
      'prestarter' => 'starter',
      'starter' => 'starter',
      'grower' => 'grower',
      'finisher' => 'finisher',
      'lactating' => 'lactating',
      'gestating' => 'gestating',
      'broiler' => 'starter',
      'layer' => 'layer',
      'breeder' => 'breeder',
      'tilapia' => 'freshwater',
      'catfish' => 'freshwater',
      _ => normalizedFeedType,
    };

    final key = '${prefix}_$feedTypeKey';
    print(
        '🔑 Generated inclusion key: "$key" (animalTypeId=$animalTypeId, feedType=$feedTypeName)');
    return key;
  }
}

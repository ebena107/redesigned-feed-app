import 'dart:math';

import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/formulation_recommendation_service.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/linear_program_solver.dart';

/// Configuration options for feed formulation
class FormulationOptions {
  /// Safety margin multiplier for minimum nutrient requirements.
  /// 1.02 = +2% buffer — keeps the problem feasible while preventing
  /// marginal deficiencies (relaxed from the old 1.05 which was too tight).
  final double safetyMargin;

  /// Enable automatic relaxation when formulation is infeasible
  /// Tries: remove max limits → remove safety margin → relax tightest constraint
  final bool enableAutoRelaxation;

  /// Maximum relaxation allowed on minimum constraints (e.g. 0.08 = max 8% reduction)
  final double maxRelaxationPct;

  /// Fixed inclusions: ingredientId → percentage (0-100)
  /// Used for premix (1.0%), salt (0.3%), mandatory additives
  final Map<num, double> fixedInclusions;

  FormulationOptions({
    this.safetyMargin = 1.02,
    this.enableAutoRelaxation = true,
    this.maxRelaxationPct = 0.08,
    this.fixedInclusions = const {},
  }) {
    final totalFixed = fixedInclusions.values.fold(0.0, (a, b) => a + b);
    if (totalFixed >= 100.0) {
      AppLogger.warning(
        'Fixed inclusions total ${totalFixed.toStringAsFixed(1)}%',
        tag: 'FormulationOptions',
      );
    }
  }
}

/// Defines behavior for ingredient inclusion in formulation
enum InclusionStrategy {
  /// No minimum - ingredients can be 0% or used in any amount (default)
  none,

  /// Minimum per-ingredient (e.g., 0.1% for trace ingredients)
  minimum,

  /// All selected ingredients must be used at minimum threshold
  allSelected,
}

class FeedFormulatorEngine {
  FeedFormulatorEngine({
    LinearProgramSolver? solver,

    /// Minimum % for each selected ingredient — ensures all ingredients appear.
    /// Default 0.5% guarantees diversity without over-constraining the LP.
    this.minInclusionPct = 0.5,

    /// allSelected means every variable ingredient gets at least minInclusionPct.
    this.inclusionStrategy = InclusionStrategy.allSelected,
    FormulationOptions? options,
  })  : _solver = solver ?? LinearProgramSolver(),
        options = options ?? FormulationOptions();

  final LinearProgramSolver _solver;
  final double minInclusionPct;
  final InclusionStrategy inclusionStrategy;
  final FormulationOptions options;

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

    final warnings = <String>[];

    // Handle fixed inclusions
    final fixedContributions =
        _applyFixedInclusions(ingredients, animalTypeId, warnings);
    final variableIngredients = ingredients
        .where((ing) => !options.fixedInclusions.containsKey(ing.ingredientId))
        .toList();

    if (variableIngredients.isEmpty && options.fixedInclusions.isNotEmpty) {
      // All ingredients are fixed
      return _buildFixedOnlyResult(
          ingredients, fixedContributions, constraints, animalTypeId, warnings);
    }

    // Apply safety margin to constraints
    final adjustedConstraints = _applySafetyMargin(constraints);

    // Validate constraints are feasible with available variable ingredients
    _validateFeasibility(
        variableIngredients, adjustedConstraints, animalTypeId);

    // Validate constraint ranges for user guidance
    _validateConstraintRanges(adjustedConstraints);

    final objective = _buildObjective(variableIngredients, warnings);
    final lpConstraints = <LinearConstraint>[];

    // Sum of variable ingredient fractions equals remaining space after fixed
    final totalFixed = fixedContributions.values.fold(0.0, (a, b) => a + b);
    final remainingSpace = max(0.0, 1.0 - totalFixed);

    lpConstraints.add(
      LinearConstraint(
        coefficients: List<double>.filled(variableIngredients.length, 1),
        rhs: remainingSpace,
        type: ConstraintType.equal,
      ),
    );

    // Apply inclusion strategy constraints (only to variable ingredients)
    if (inclusionStrategy != InclusionStrategy.none && minInclusionPct > 0) {
      AppLogger.debug(
        'Applying ${inclusionStrategy.name} inclusion strategy with min ${minInclusionPct.toStringAsFixed(2)}%',
        tag: 'FeedFormulatorEngine',
      );

      for (var i = 0; i < variableIngredients.length; i++) {
        final coeffs = List<double>.filled(variableIngredients.length, 0);
        coeffs[i] = 1;

        // Minimum inclusion: x_i >= minInclusionPct / 100
        lpConstraints.add(
          LinearConstraint(
            coefficients: coeffs,
            rhs: minInclusionPct / 100,
            type: ConstraintType.greaterOrEqual,
          ),
        );
      }
    }

    // Max inclusion constraints (only on variable ingredients)
    if (enforceMaxInclusion) {
      for (var i = 0; i < variableIngredients.length; i++) {
        final ing = variableIngredients[i];
        double? maxPct = _getMaxInclusionPct(ing, animalTypeId, feedTypeName);

        if (maxPct != null && maxPct > 0) {
          final coeffs = List<double>.filled(variableIngredients.length, 0);
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

    // Nutrient constraints (adjusted for fixed contributions)
    for (final constraint in adjustedConstraints) {
      final coeffs = variableIngredients
          .map((ing) => _nutrientValue(ing, constraint.key, animalTypeId))
          .toList();

      final fixedValue = fixedContributions[constraint.key] ?? 0.0;

      if (constraint.min != null) {
        final adjustedMin = max(0.0, constraint.min! - fixedValue);
        lpConstraints.add(
          LinearConstraint(
            coefficients: coeffs,
            rhs: adjustedMin,
            type: ConstraintType.greaterOrEqual,
          ),
        );
      }

      if (constraint.max != null) {
        final adjustedMax = constraint.max! - fixedValue;
        lpConstraints.add(
          LinearConstraint(
            coefficients: coeffs,
            rhs: adjustedMax,
            type: ConstraintType.lessOrEqual,
          ),
        );
      }
    }

    final solution = _solver.solve(
      objective: objective,
      constraints: lpConstraints,
    );

    final statusStr = solution.isOptimal
        ? 'OPTIMAL'
        : solution.isInfeasible
            ? 'INFEASIBLE'
            : 'SUBOPTIMAL';

    AppLogger.debug(
      'Solver result: $statusStr',
      tag: 'FeedFormulatorEngine',
    );

    if (solution.isOptimal || solution.solution.isNotEmpty) {
      for (var i = 0; i < ingredients.length && i < 5; i++) {
        final pct = solution.solution[i] * 100;
        AppLogger.debug(
          '${ingredients[i].name}: ${pct.toStringAsFixed(2)}%',
          tag: 'FeedFormulatorEngine',
        );
      }
    }

    // Handle infeasible solution
    if (solution.isInfeasible || !solution.isOptimal) {
      if (solution.isInfeasible && options.enableAutoRelaxation) {
        // Try auto-relaxation recovery
        return _tryAutoRelaxation(
          variableIngredients: variableIngredients,
          allIngredients: ingredients,
          originalConstraints: constraints,
          fixedContributions: fixedContributions,
          animalTypeId: animalTypeId,
          feedTypeName: feedTypeName,
          enforceMaxInclusion: enforceMaxInclusion,
          warnings: warnings,
        );
      }

      // No recovery, return failed result
      if (solution.isInfeasible) {
        warnings.addAll(
          FormulationRecommendationService.generateRecommendations(
            ingredients: variableIngredients,
            constraints: adjustedConstraints,
            animalTypeId: animalTypeId,
            enforceMaxInclusion: enforceMaxInclusion,
          ),
        );
      }
      return _buildFailureResult(ingredients, warnings);
    }

    // Build final percentages (fixed + variable)
    final percents =
        _buildFinalPercents(ingredients, variableIngredients, solution);

    final nutrients = _calculateNutrients(
      ingredients,
      percents,
      adjustedConstraints,
      animalTypeId,
      fixedContributions,
    );

    final limiting = _detectLimitingNutrients(adjustedConstraints, nutrients);
    final totalCost = _calculateTotalCost(
        objective, solution.solution, ingredients, fixedContributions);

    AppLogger.info(
      'Formulation optimal | Cost: ${totalCost.toStringAsFixed(3)} ₦/kg | Fixed: ${totalFixed.toStringAsFixed(1)}% | Variable: ${variableIngredients.length} ingredients',
      tag: 'FeedFormulatorEngine',
    );

    return FormulatorResult(
      ingredientPercents: percents,
      costPerKg: totalCost,
      nutrients: nutrients,
      status: 'optimal',
      warnings: warnings,
      limitingNutrients: limiting,
    );
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
    dynamic solution, // List<double> or Map<num, double>
    List<NutrientConstraint> constraints,
    int animalTypeId, [
    dynamic fixedContributions,
  ]) {
    final keys = constraints.map((c) => c.key).toSet();
    final nutrients = <NutrientKey, double>{};

    // Start with fixed contributions if provided
    if (fixedContributions is Map<NutrientKey, double>) {
      for (final key in keys) {
        nutrients[key] = fixedContributions[key] ?? 0.0;
      }
    }

    // Add variable ingredient contributions
    if (solution is List<double>) {
      // Legacy: solution is fractions from LP solver
      for (final key in keys) {
        for (var i = 0; i < ingredients.length; i++) {
          nutrients[key] = (nutrients[key] ?? 0.0) +
              solution[i] * _nutrientValue(ingredients[i], key, animalTypeId);
        }
      }
    } else if (solution is Map<num, double>) {
      // New: solution is ingredient percentages
      for (final key in keys) {
        for (final ing in ingredients) {
          final pct =
              (solution[ing.ingredientId ?? ing.name.hashCode] ?? 0.0) / 100.0;
          nutrients[key] = (nutrients[key] ?? 0.0) +
              pct * _nutrientValue(ing, key, animalTypeId);
        }
      }
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

  /// Default ingredient percentages (all zeros)
  Map<num, double> _defaultPercents(List<Ingredient> ingredients) {
    return {
      for (var i = 0; i < ingredients.length; i++)
        ingredients[i].ingredientId ?? i: 0,
    };
  }

  /// Validates constraint ranges for user guidance
  ///
  /// Warnings:
  /// - Energy ranges should be at least 150 kcal/kg (NRC 2012 typical)
  /// - Nutrient ranges should be at least 0.35% (e.g., lysine 0.72-1.10 = 0.38%)
  /// - Min should not exceed max
  void _validateConstraintRanges(List<NutrientConstraint> constraints) {
    for (final constraint in constraints) {
      final min = constraint.min;
      final max = constraint.max;

      // Check if min > max
      if (min != null && max != null && min > max) {
        AppLogger.warning(
          '${constraint.key.name}: Minimum ($min) exceeds maximum ($max)',
          tag: 'FeedFormulatorEngine',
        );
      }

      // Check if range is too narrow
      if (min != null && max != null) {
        final rangeWidth = max - min;
        final minThreshold =
            constraint.key == NutrientKey.energy ? 150.0 : 0.35;

        if (rangeWidth < minThreshold) {
          AppLogger.warning(
            '${constraint.key.name}: Range is narrow (${rangeWidth.toStringAsFixed(2)}), may be infeasible',
            tag: 'FeedFormulatorEngine',
          );
        }
      }
    }
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

      AppLogger.debug(
        'Feasibility check for ${constraint.key.name}: min_possible=$minPossible, max_possible=$maxPossible',
        tag: 'FeedFormulatorEngine',
      );

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
      AppLogger.warning(
        'Unknown animal type ID: $animalTypeId',
        tag: 'FeedFormulatorEngine',
      );
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
    AppLogger.debug(
      'Inclusion key: $key (animalTypeId=$animalTypeId, feedType=$feedTypeName)',
      tag: 'FeedFormulatorEngine',
    );
    return key;
  }

  /// Apply fixed inclusions and calculate their nutrient contributions
  Map<NutrientKey, double> _applyFixedInclusions(
    List<Ingredient> ingredients,
    int animalTypeId,
    List<String> warnings,
  ) {
    final contributions = <NutrientKey, double>{};
    for (final ing in ingredients) {
      final fixedPct = options.fixedInclusions[ing.ingredientId] ?? 0.0;
      if (fixedPct <= 0) continue;
      final actualFraction = min(fixedPct / 100, 1.0);
      for (final key in [
        NutrientKey.energy,
        NutrientKey.protein,
        NutrientKey.lysine,
        NutrientKey.methionine,
        NutrientKey.calcium,
        NutrientKey.phosphorus
      ]) {
        final val = _nutrientValue(ing, key, animalTypeId);
        contributions[key] = (contributions[key] ?? 0.0) + val * actualFraction;
      }
    }
    return contributions;
  }

  /// Apply safety margin to minimum constraints only
  List<NutrientConstraint> _applySafetyMargin(
    List<NutrientConstraint> constraints,
  ) {
    if (options.safetyMargin <= 1.0) return constraints;
    return constraints.map((c) {
      if (c.min == null) return c;
      return c.copyWith(
        min: c.min! * options.safetyMargin,
      );
    }).toList();
  }

  /// Build final ingredient percentages from LP solution
  Map<num, double> _buildFinalPercents(
    List<Ingredient> allIngredients,
    List<Ingredient> variableIngredients,
    LinearProgramResult solution,
  ) {
    final percents = <num, double>{};
    for (final ing in allIngredients) {
      final fixedPct = options.fixedInclusions[ing.ingredientId] ?? 0.0;
      if (fixedPct > 0) {
        percents[ing.ingredientId ?? ing.name.hashCode] = fixedPct;
      }
    }
    for (var i = 0;
        i < variableIngredients.length && i < solution.solution.length;
        i++) {
      final id = variableIngredients[i].ingredientId ?? i;
      percents[id] = solution.solution[i] * 100;
    }
    return percents;
  }

  /// Build result when all ingredients are fixed
  FormulatorResult _buildFixedOnlyResult(
    List<Ingredient> ingredients,
    Map<NutrientKey, double> fixedContributions,
    List<NutrientConstraint> constraints,
    int animalTypeId,
    List<String> warnings,
  ) {
    final percents = <num, double>{};
    double totalCost = 0.0;
    for (final ing in ingredients) {
      final fixedPct = options.fixedInclusions[ing.ingredientId] ?? 0.0;
      if (fixedPct > 0) {
        percents[ing.ingredientId ?? ing.name.hashCode] = fixedPct;
        totalCost += (ing.priceKg ?? 0.0) * (fixedPct / 100.0);
      }
    }
    final nutrients = _calculateNutrients(
      ingredients,
      percents,
      constraints,
      animalTypeId,
      fixedContributions,
    );
    return FormulatorResult(
      ingredientPercents: percents,
      costPerKg: totalCost,
      nutrients: nutrients,
      status: 'optimal',
      warnings: warnings,
    );
  }

  /// Build failure result with zeros
  FormulatorResult _buildFailureResult(
    List<Ingredient> ingredients,
    List<String> warnings,
  ) {
    return FormulatorResult(
      ingredientPercents: _defaultPercents(ingredients),
      costPerKg: 0,
      nutrients: {},
      status: 'infeasible',
      warnings: warnings,
    );
  }

  /// Keywords that identify premix/mineral/vitamin ingredients.
  /// These should never exceed 3% in a complete feed.
  static const _premixKeywords = [
    'premix',
    'pre-mix',
    'mineral',
    'vitamin',
    'supplement',
    'trace',
    'micronutrient',
    'salt',
    'sodium chloride',
  ];

  /// Returns true if the ingredient name matches a premix/additive keyword.
  bool _isPremixIngredient(Ingredient ingredient) {
    final name = (ingredient.name ?? '').toLowerCase();
    return _premixKeywords.any((kw) => name.contains(kw));
  }

  /// Get max inclusion % for ingredient.
  /// Premix/mineral/vitamin ingredients are automatically capped at 3%
  /// if they have no explicit max inclusion set — this prevents the LP
  /// from using them as cheap filler at 100%.
  double? _getMaxInclusionPct(
    Ingredient ingredient,
    int animalTypeId,
    String? feedTypeName,
  ) {
    double? maxPct;
    final maxJson = ingredient.maxInclusionJson;
    if (maxJson != null && maxJson.isNotEmpty && feedTypeName != null) {
      final key = _getInclusionKey(animalTypeId, feedTypeName);
      if (key != null && maxJson.containsKey(key)) {
        maxPct = (maxJson[key] as num?)?.toDouble();
      }
    }
    maxPct ??= ingredient.maxInclusionPct?.toDouble();

    // Auto-cap premix/mineral/vitamin ingredients at 3% if not already set
    if (maxPct == null && _isPremixIngredient(ingredient)) {
      AppLogger.debug(
        '${ingredient.name}: keyword-matched as premix/mineral/vitamin → capping at 3%',
        tag: 'FeedFormulatorEngine',
      );
      maxPct = 3.0;
    }

    return maxPct;
  }

  /// Calculate total cost including fixed ingredients
  double _calculateTotalCost(
    List<double> variableObjective,
    List<double> solution,
    List<Ingredient> allIngredients,
    Map<NutrientKey, double> fixedContributions,
  ) {
    double total = 0.0;
    for (var i = 0; i < variableObjective.length && i < solution.length; i++) {
      total += variableObjective[i] * solution[i];
    }
    for (final ing in allIngredients) {
      final fixedPct =
          (options.fixedInclusions[ing.ingredientId] ?? 0.0) / 100.0;
      if (fixedPct > 0) {
        total += (ing.priceKg ?? 0.0) * fixedPct;
      }
    }
    return total;
  }

  /// Try auto-relaxation on infeasible solution
  FormulatorResult _tryAutoRelaxation({
    required List<Ingredient> variableIngredients,
    required List<Ingredient> allIngredients,
    required List<NutrientConstraint> originalConstraints,
    required Map<NutrientKey, double> fixedContributions,
    required int animalTypeId,
    required String? feedTypeName,
    required bool enforceMaxInclusion,
    required List<String> warnings,
  }) {
    AppLogger.warning(
      'Infeasible formula detected',
      tag: 'FeedFormulatorEngine',
    );
    warnings.addAll(
      FormulationRecommendationService.generateRecommendations(
        ingredients: variableIngredients,
        constraints: originalConstraints,
        animalTypeId: animalTypeId,
        enforceMaxInclusion: enforceMaxInclusion,
      ),
    );
    return _buildFailureResult(allIngredients, warnings);
  }
}

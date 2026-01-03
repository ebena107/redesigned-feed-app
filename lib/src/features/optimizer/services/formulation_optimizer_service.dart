import '../model/optimization_constraint.dart';
import '../model/optimization_request.dart';
import '../model/optimization_result.dart';
import 'simplex_solver.dart';
import '../../add_ingredients/model/ingredient.dart';

// ============ Helper Classes ============

class _ValidationResult {
  final bool isValid;
  final String message;

  _ValidationResult(this.isValid, this.message);
}

class _LPProblem {
  final List<double> objectiveCoefficients;
  final List<List<double>> constraintMatrix;
  final List<double> constraintBounds;
  final List<double> lowerBounds;
  final List<double> upperBounds;

  _LPProblem({
    required this.objectiveCoefficients,
    required this.constraintMatrix,
    required this.constraintBounds,
    required this.lowerBounds,
    required this.upperBounds,
  });
}

class _ConstraintMatrixResult {
  final List<List<double>> matrix;
  final List<double> bounds;

  _ConstraintMatrixResult({required this.matrix, required this.bounds});
}

class _VariableBounds {
  final List<double> lower;
  final List<double> upper;

  _VariableBounds({required this.lower, required this.upper});
}

/// Main service for feed formulation optimization
///
/// This service coordinates the optimization process by:
/// 1. Validating constraints and inputs
/// 2. Building the Linear Programming problem
/// 3. Solving using Simplex algorithm
/// 4. Calculating nutritional profile and quality score
class FormulationOptimizerService {
  final SimplexSolver _simplexSolver = SimplexSolver();

  /// Optimize a feed formulation based on the given request
  ///
  /// Returns an [OptimizationResult] with ingredient proportions,
  /// cost, quality score, and achieved nutritional profile
  Future<OptimizationResult> optimize({
    required OptimizationRequest request,
    required Map<int, Ingredient> ingredientCache,
  }) async {
    try {
      // Step 1: Validate inputs
      final validation = _validateRequest(request, ingredientCache);
      if (!validation.isValid) {
        return OptimizationResult.failure(validation.message);
      }

      // Step 2: Build LP problem
      final lpProblem = _buildLinearProgrammingProblem(
        request,
        ingredientCache,
      );

      // Step 3: Solve using Simplex
      final simplexResult = _simplexSolver.solve(
        objectiveCoefficients: lpProblem.objectiveCoefficients,
        constraintMatrix: lpProblem.constraintMatrix,
        constraintBounds: lpProblem.constraintBounds,
        lowerBounds: lpProblem.lowerBounds,
        upperBounds: lpProblem.upperBounds,
      );

      if (simplexResult == null || !simplexResult.success) {
        return OptimizationResult.failure(
          simplexResult?.message ?? 'No feasible solution found',
        );
      }

      // Step 4: Convert solution to ingredient proportions (percentages)
      final proportions = _convertSolutionToProportions(
        simplexResult.solution,
        request.availableIngredientIds,
      );

      // Step 5: Calculate achieved nutritional profile
      final achievedNutrients = _calculateAchievedNutrients(
        proportions,
        ingredientCache,
        request.animalTypeId,
      );

      // Step 6: Calculate quality score
      final qualityScore = _calculateQualityScore(
        achievedNutrients,
        request.constraints,
      );

      // Step 7: Generate warnings if any
      final warnings = _generateWarnings(
        proportions,
        achievedNutrients,
        request,
        ingredientCache,
      );

      return OptimizationResult.successResult(
        proportions: proportions,
        cost: simplexResult.objectiveValue,
        score: qualityScore,
        nutrients: achievedNutrients,
        warnings: warnings.isEmpty ? null : warnings,
      );
    } catch (e) {
      return OptimizationResult.failure('Optimization error: ${e.toString()}');
    }
  }

  /// Validate optimization request and ingredient data
  _ValidationResult _validateRequest(
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    // Check if we have ingredients
    if (request.availableIngredientIds.isEmpty) {
      return _ValidationResult(false, 'No ingredients selected');
    }

    // Check if we have constraints
    if (request.constraints.isEmpty) {
      return _ValidationResult(false, 'No nutritional constraints specified');
    }

    // Check if all ingredients exist in cache
    for (final id in request.availableIngredientIds) {
      if (!ingredientCache.containsKey(id)) {
        return _ValidationResult(false, 'Ingredient ID $id not found');
      }
    }

    // Check for conflicting constraints
    final conflictCheck = _checkConflictingConstraints(request.constraints);
    if (!conflictCheck.isValid) {
      return conflictCheck;
    }

    return _ValidationResult(true, 'Valid');
  }

  /// Check for conflicting constraints (e.g., min > max for same nutrient)
  _ValidationResult _checkConflictingConstraints(
    List<OptimizationConstraint> constraints,
  ) {
    final nutrientConstraints = <String, List<OptimizationConstraint>>{};

    // Group constraints by nutrient
    for (final constraint in constraints) {
      nutrientConstraints
          .putIfAbsent(constraint.nutrientName, () => [])
          .add(constraint);
    }

    // Check each nutrient for conflicts
    for (final entry in nutrientConstraints.entries) {
      final nutrient = entry.key;
      final nutrientCons = entry.value;

      double? minValue;
      double? maxValue;

      for (final con in nutrientCons) {
        if (con.type == ConstraintType.min ||
            con.type == ConstraintType.exact) {
          minValue = con.value;
        }
        if (con.type == ConstraintType.max ||
            con.type == ConstraintType.exact) {
          maxValue = con.value;
        }
      }

      if (minValue != null && maxValue != null && minValue > maxValue) {
        return _ValidationResult(
          false,
          'Conflicting constraints for $nutrient: min ($minValue) > max ($maxValue)',
        );
      }
    }

    return _ValidationResult(true, 'No conflicts');
  }

  /// Build Linear Programming problem from optimization request
  _LPProblem _buildLinearProgrammingProblem(
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    // Objective coefficients (based on objective function)
    final objectiveCoefficients = _buildObjectiveCoefficients(
      request,
      ingredientCache,
    );

    // Constraint matrix and bounds
    final constraints = _buildConstraintMatrix(
      request,
      ingredientCache,
    );

    // Variable bounds (inclusion limits)
    final bounds = _buildVariableBounds(
      request,
      ingredientCache,
    );

    return _LPProblem(
      objectiveCoefficients: objectiveCoefficients,
      constraintMatrix: constraints.matrix,
      constraintBounds: constraints.bounds,
      lowerBounds: bounds.lower,
      upperBounds: bounds.upper,
    );
  }

  /// Build objective coefficients based on objective function
  List<double> _buildObjectiveCoefficients(
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    final coefficients = <double>[];

    for (final ingredientId in request.availableIngredientIds) {
      final ingredient = ingredientCache[ingredientId]!;
      double coefficient;

      switch (request.objective) {
        case ObjectiveFunction.minimizeCost:
          // Use price (minimize)
          coefficient = request.ingredientPrices[ingredientId] ?? 0.0;
          break;
        case ObjectiveFunction.maximizeProtein:
          // Use negative protein (to maximize via minimization)
          coefficient = -((ingredient.crudeProtein ?? 0.0).toDouble());
          break;
        case ObjectiveFunction.maximizeEnergy:
          // Use negative energy (to maximize via minimization)
          coefficient = -((ingredient.energy?.nePig ?? 0.0).toDouble());
          break;
      }

      coefficients.add(coefficient);
    }

    return coefficients;
  }

  /// Build constraint matrix from nutritional constraints
  _ConstraintMatrixResult _buildConstraintMatrix(
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    final matrix = <List<double>>[];
    final bounds = <double>[];

    // CRITICAL: Add equality constraint - sum of all proportions = 100%
    // This ensures the formulation is complete and prevents issues with >10 ingredients
    final sumRow = List.filled(request.availableIngredientIds.length, 1.0);
    matrix.add(sumRow);
    bounds.add(100.0); // Sum must equal 100%

    // Add another row for the equality (convert to two inequalities: >= 100 and <= 100)
    final sumRow2 = List.filled(request.availableIngredientIds.length, -1.0);
    matrix.add(sumRow2);
    bounds.add(-100.0); // Negative sum <= -100 means sum >= 100

    // Add nutritional constraints
    // Convert all to <= form for simplex
    for (final constraint in request.constraints) {
      final row = <double>[];

      for (final ingredientId in request.availableIngredientIds) {
        final ingredient = ingredientCache[ingredientId]!;
        final nutrientValue =
            _getNutrientValue(ingredient, constraint.nutrientName);

        // Nutrient contribution: nutrient_value * percentage / 100
        // Since x is in percentage (0-100), we scale by 1/100
        final scaledValue = nutrientValue / 100.0;

        if (constraint.type == ConstraintType.min) {
          // Min constraint: nutrient * x / 100 >= minValue
          // Convert to: -nutrient * x / 100 <= -minValue
          row.add(-scaledValue);
        } else {
          // Max constraint: nutrient * x / 100 <= maxValue
          row.add(scaledValue);
        }
      }

      matrix.add(row);

      // Set bound based on constraint type
      if (constraint.type == ConstraintType.min) {
        // For min: -sum(nutrient * x / 100) <= -minValue
        bounds.add(-constraint.value);
      } else if (constraint.type == ConstraintType.max) {
        // For max: sum(nutrient * x / 100) <= maxValue
        bounds.add(constraint.value);
      }
    }

    return _ConstraintMatrixResult(matrix: matrix, bounds: bounds);
  }

  /// Build variable bounds (inclusion limits)
  _VariableBounds _buildVariableBounds(
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    final lower = <double>[];
    final upper = <double>[];

    for (final ingredientId in request.availableIngredientIds) {
      final ingredient = ingredientCache[ingredientId]!;

      // Check for custom limits in request
      final customLimit = request.ingredientLimits?[ingredientId];

      double minPct = customLimit?.minPct ?? 0.0;
      double maxPct = customLimit?.maxPct ?? 100.0;

      // Also check ingredient's own max inclusion limit
      if (ingredient.maxInclusionPct != null) {
        maxPct = maxPct.clamp(0.0, (ingredient.maxInclusionPct!).toDouble());
      }

      lower.add(minPct);
      upper.add(maxPct);
    }

    return _VariableBounds(lower: lower, upper: upper);
  }

  /// Get nutrient value from ingredient
  double _getNutrientValue(Ingredient ingredient, String nutrientName) {
    switch (nutrientName.toLowerCase()) {
      case 'crudeprotein':
      case 'protein':
        return (ingredient.crudeProtein ?? 0.0).toDouble();
      case 'crudefat':
      case 'fat':
        return (ingredient.crudeFat ?? 0.0).toDouble();
      case 'crudefiber':
      case 'fiber':
        return (ingredient.crudeFiber ?? 0.0).toDouble();
      case 'ash':
        return (ingredient.ash ?? 0.0).toDouble();
      case 'moisture':
        return (ingredient.moisture ?? 0.0).toDouble();
      case 'calcium':
        return (ingredient.calcium ?? 0.0).toDouble();
      case 'phosphorus':
      case 'totalphosphorus':
        return (ingredient.totalPhosphorus ?? ingredient.phosphorus ?? 0.0)
            .toDouble();
      case 'availablephosphorus':
        return (ingredient.availablePhosphorus ?? 0.0).toDouble();
      case 'lysine':
        return (ingredient.lysine ?? 0.0).toDouble();
      case 'methionine':
        return (ingredient.methionine ?? 0.0).toDouble();
      case 'energy':
      case 'nepig':
        return (ingredient.energy?.nePig ?? 0.0).toDouble();
      case 'mepoultry':
        return (ingredient.energy?.mePoultry ?? ingredient.mePoultry ?? 0.0)
            .toDouble();
      case 'mepig':
        return (ingredient.energy?.mePig ?? ingredient.meGrowingPig ?? 0.0)
            .toDouble();
      case 'meruminant':
        return (ingredient.energy?.meRuminant ?? ingredient.meRuminant ?? 0.0)
            .toDouble();
      case 'merabbit':
        return (ingredient.energy?.meRabbit ?? ingredient.meRabbit ?? 0.0)
            .toDouble();
      // Add more nutrients as needed
      default:
        return 0.0;
    }
  }

  /// Convert Simplex solution to ingredient proportions (percentages)
  Map<int, double> _convertSolutionToProportions(
    List<double> solution,
    List<int> ingredientIds,
  ) {
    final proportions = <int, double>{};

    for (int i = 0; i < ingredientIds.length && i < solution.length; i++) {
      if (solution[i] > 0.01) {
        // Only include if > 0.01%
        proportions[ingredientIds[i]] = solution[i];
      }
    }

    return proportions;
  }

  /// Calculate achieved nutritional profile
  Map<String, double> _calculateAchievedNutrients(
    Map<int, double> proportions,
    Map<int, Ingredient> ingredientCache,
    int? animalTypeId,
  ) {
    final nutrients = <String, double>{
      'crudeProtein': 0.0,
      'crudeFat': 0.0,
      'crudeFiber': 0.0,
      'ash': 0.0,
      'moisture': 0.0,
      'calcium': 0.0,
      'phosphorus': 0.0,
      'availablePhosphorus': 0.0,
      'lysine': 0.0,
      'methionine': 0.0,
      'energy': 0.0,
    };

    for (final entry in proportions.entries) {
      final ingredient = ingredientCache[entry.key]!;
      final proportion = entry.value / 100.0; // Convert % to decimal

      nutrients['crudeProtein'] = nutrients['crudeProtein']! +
          (ingredient.crudeProtein ?? 0.0) * proportion;
      nutrients['crudeFat'] =
          nutrients['crudeFat']! + (ingredient.crudeFat ?? 0.0) * proportion;
      nutrients['crudeFiber'] = nutrients['crudeFiber']! +
          (ingredient.crudeFiber ?? 0.0) * proportion;
      nutrients['ash'] =
          nutrients['ash']! + (ingredient.ash ?? 0.0) * proportion;
      nutrients['moisture'] =
          nutrients['moisture']! + (ingredient.moisture ?? 0.0) * proportion;
      nutrients['calcium'] =
          nutrients['calcium']! + (ingredient.calcium ?? 0.0) * proportion;
      nutrients['phosphorus'] = nutrients['phosphorus']! +
          (ingredient.totalPhosphorus ?? ingredient.phosphorus ?? 0.0) *
              proportion;
      nutrients['availablePhosphorus'] = nutrients['availablePhosphorus']! +
          (ingredient.availablePhosphorus ?? 0.0) * proportion;
      nutrients['lysine'] =
          nutrients['lysine']! + (ingredient.lysine ?? 0.0) * proportion;
      nutrients['methionine'] = nutrients['methionine']! +
          (ingredient.methionine ?? 0.0) * proportion;

      // Calculate energy based on animal type ID
      final energy = _getEnergyForAnimal(ingredient, animalTypeId);
      nutrients['energy'] = nutrients['energy']! + energy * proportion;
    }

    return nutrients;
  }

  /// Get energy value for specific animal type with NE prioritization for pigs
  double _getEnergyForAnimal(Ingredient ing, int? animalTypeId) {
    if (animalTypeId == null) return 0.0;

    // PIGS: Prioritize NE > ME > DE (NRC 2012 standard)
    if (animalTypeId == 1) {
      if (ing.energy?.nePig != null) return ing.energy!.nePig!.toDouble();
      if (ing.energy?.mePig != null) {
        final me = ing.energy!.mePig!.toDouble();
        return (0.87 * me - 442).clamp(0, double.infinity);
      }
      if (ing.meGrowingPig != null) {
        final me = ing.meGrowingPig!.toDouble();
        return (0.87 * me - 442).clamp(0, double.infinity);
      }
      if (ing.energy?.dePig != null) {
        final de = ing.energy!.dePig!.toDouble();
        return (0.75 * de - 600).clamp(0, double.infinity);
      }
      return 0;
    }

    // POULTRY: Use ME (industry standard)
    if (animalTypeId == 2) {
      return (ing.energy?.mePoultry ?? ing.mePoultry ?? 0).toDouble();
    }

    // RABBITS: Use ME
    if (animalTypeId == 3) {
      return (ing.energy?.meRabbit ?? ing.meRabbit ?? 0).toDouble();
    }

    // RUMINANTS: Use ME
    if (animalTypeId == 4) {
      return (ing.energy?.meRuminant ?? ing.meRuminant ?? 0).toDouble();
    }

    // SALMONIDS: Use DE
    if (animalTypeId == 5) {
      return (ing.energy?.deSalmonids ?? ing.deSalmonids ?? 0).toDouble();
    }

    return 0;
  }

  /// Calculate quality score (0-100)
  double _calculateQualityScore(
    Map<String, double> achievedNutrients,
    List<OptimizationConstraint> constraints,
  ) {
    if (constraints.isEmpty) return 100.0;

    double totalScore = 0.0;
    int constraintCount = 0;

    for (final constraint in constraints) {
      final achieved =
          achievedNutrients[constraint.nutrientName.toLowerCase()] ?? 0.0;
      final target = constraint.value;

      double score;
      if (constraint.type == ConstraintType.exact) {
        // Exact: score based on how close to target
        final deviation = (achieved - target).abs() / target;
        score = (1.0 - deviation.clamp(0.0, 1.0)) * 100.0;
      } else if (constraint.type == ConstraintType.min) {
        // Min: score based on how much above minimum
        score = achieved >= target ? 100.0 : (achieved / target) * 100.0;
      } else {
        // Max: score based on how much below maximum
        score = achieved <= target ? 100.0 : (target / achieved) * 100.0;
      }

      totalScore += score;
      constraintCount++;
    }

    return constraintCount > 0 ? totalScore / constraintCount : 100.0;
  }

  /// Generate warnings for the formulation
  List<String> _generateWarnings(
    Map<int, double> proportions,
    Map<String, double> achievedNutrients,
    OptimizationRequest request,
    Map<int, Ingredient> ingredientCache,
  ) {
    final warnings = <String>[];

    // Check if any constraints are violated
    for (final constraint in request.constraints) {
      final achieved =
          achievedNutrients[constraint.nutrientName.toLowerCase()] ?? 0.0;

      if (constraint.type == ConstraintType.min &&
          achieved < constraint.value) {
        warnings.add(
          '${constraint.nutrientName} is below minimum: $achieved ${constraint.unit} < ${constraint.value} ${constraint.unit}',
        );
      } else if (constraint.type == ConstraintType.max &&
          achieved > constraint.value) {
        warnings.add(
          '${constraint.nutrientName} exceeds maximum: $achieved ${constraint.unit} > ${constraint.value} ${constraint.unit}',
        );
      }
    }

    // Check inclusion limits
    for (final entry in proportions.entries) {
      final ingredient = ingredientCache[entry.key]!;
      if (ingredient.maxInclusionPct != null &&
          entry.value > ingredient.maxInclusionPct!) {
        warnings.add(
          '${ingredient.name} exceeds maximum inclusion: ${entry.value.toStringAsFixed(1)}% > ${ingredient.maxInclusionPct}%',
        );
      }
    }

    return warnings;
  }
}

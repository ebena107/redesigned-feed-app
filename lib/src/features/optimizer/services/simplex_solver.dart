/// Simplex algorithm implementation for Linear Programming
/// Optimized for feed formulation problems
class SimplexSolver {
  /// Solves a linear programming problem using the Simplex algorithm
  ///
  /// Minimizes: c^T * x
  /// Subject to: A * x <= b
  ///            x >= 0
  ///
  /// Returns the optimal solution vector x, or null if infeasible
  SimplexResult? solve({
    required List<double> objectiveCoefficients, // c vector
    required List<List<double>> constraintMatrix, // A matrix
    required List<double> constraintBounds, // b vector
    required List<double> lowerBounds, // x_min vector
    required List<double> upperBounds, // x_max vector
  }) {
    try {
      // Validate inputs
      _validateInputs(
        objectiveCoefficients,
        constraintMatrix,
        constraintBounds,
        lowerBounds,
        upperBounds,
      );

      // Convert to standard form (add slack variables)
      final standardForm = _convertToStandardForm(
        objectiveCoefficients,
        constraintMatrix,
        constraintBounds,
        lowerBounds,
        upperBounds,
      );

      // Initialize simplex tableau
      final tableau = _initializeTableau(standardForm);

      // Perform simplex iterations
      final solution = _simplexIterations(tableau, standardForm);

      if (solution == null) {
        return SimplexResult(
          success: false,
          solution: [],
          objectiveValue: double.infinity,
          message: 'No feasible solution found',
        );
      }

      return SimplexResult(
        success: true,
        solution: solution,
        objectiveValue:
            _calculateObjectiveValue(solution, objectiveCoefficients),
        message: 'Optimal solution found',
      );
    } catch (e) {
      return SimplexResult(
        success: false,
        solution: [],
        objectiveValue: double.infinity,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  void _validateInputs(
    List<double> c,
    List<List<double>> A,
    List<double> b,
    List<double> lb,
    List<double> ub,
  ) {
    if (c.isEmpty) {
      throw ArgumentError('Objective coefficients cannot be empty');
    }
    if (A.isEmpty) {
      throw ArgumentError('Constraint matrix cannot be empty');
    }
    if (b.isEmpty) {
      throw ArgumentError('Constraint bounds cannot be empty');
    }

    final numVars = c.length;
    if (lb.length != numVars) {
      throw ArgumentError('Lower bounds length mismatch');
    }
    if (ub.length != numVars) {
      throw ArgumentError('Upper bounds length mismatch');
    }
    if (A.length != b.length) {
      throw ArgumentError('Constraint matrix/bounds mismatch');
    }

    for (final row in A) {
      if (row.length != numVars) {
        throw ArgumentError('Constraint matrix row length mismatch');
      }
    }

    // Check bounds validity
    for (int i = 0; i < numVars; i++) {
      if (lb[i] > ub[i]) {
        throw ArgumentError('Lower bound > upper bound for variable $i');
      }
    }
  }

  _StandardForm _convertToStandardForm(
    List<double> c,
    List<List<double>> A,
    List<double> b,
    List<double> lb,
    List<double> ub,
  ) {
    final numVars = c.length;
    final numConstraints = A.length;

    // Add slack variables for inequality constraints
    final numSlackVars = numConstraints;

    // Extended objective coefficients (original + slack variables)
    final extendedC = List<double>.from(c)
      ..addAll(List.filled(numSlackVars, 0.0));

    // Extended constraint matrix
    final extendedA = <List<double>>[];
    for (int i = 0; i < numConstraints; i++) {
      final row = List<double>.from(A[i]);
      // Add slack variable (identity matrix)
      for (int j = 0; j < numSlackVars; j++) {
        row.add(i == j ? 1.0 : 0.0);
      }
      extendedA.add(row);
    }

    return _StandardForm(
      objectiveCoefficients: extendedC,
      constraintMatrix: extendedA,
      constraintBounds: List.from(b),
      numOriginalVars: numVars,
      numSlackVars: numSlackVars,
      lowerBounds: lb,
      upperBounds: ub,
    );
  }

  List<List<double>> _initializeTableau(_StandardForm form) {
    final numConstraints = form.constraintMatrix.length;

    // Tableau format:
    // [A | I | b]  <- constraint rows
    // [c | 0 | 0]  <- objective row

    final tableau = <List<double>>[];

    // Add constraint rows
    for (int i = 0; i < numConstraints; i++) {
      final row = List<double>.from(form.constraintMatrix[i])
        ..add(form.constraintBounds[i]);
      tableau.add(row);
    }

    // Add objective row (negated for minimization)
    final objectiveRow = form.objectiveCoefficients.map((c) => -c).toList()
      ..add(0.0);
    tableau.add(objectiveRow);

    return tableau;
  }

  List<double>? _simplexIterations(
    List<List<double>> tableau,
    _StandardForm form,
  ) {
    const maxIterations = 1000;
    int iteration = 0;

    while (iteration < maxIterations) {
      // Find entering variable (most negative coefficient in objective row)
      final enteringCol = _findEnteringVariable(tableau);
      if (enteringCol == -1) {
        // Optimal solution found
        return _extractSolution(tableau, form);
      }

      // Find leaving variable (minimum ratio test)
      final leavingRow = _findLeavingVariable(tableau, enteringCol);
      if (leavingRow == -1) {
        // Unbounded problem
        return null;
      }

      // Perform pivot operation
      _pivot(tableau, leavingRow, enteringCol);

      iteration++;
    }

    // Max iterations reached
    return null;
  }

  int _findEnteringVariable(List<List<double>> tableau) {
    final objectiveRow = tableau.last;
    double mostNegative = 0.0;
    int enteringCol = -1;

    for (int j = 0; j < objectiveRow.length - 1; j++) {
      if (objectiveRow[j] < mostNegative) {
        mostNegative = objectiveRow[j];
        enteringCol = j;
      }
    }

    return enteringCol;
  }

  int _findLeavingVariable(List<List<double>> tableau, int enteringCol) {
    double minRatio = double.infinity;
    int leavingRow = -1;

    for (int i = 0; i < tableau.length - 1; i++) {
      final pivot = tableau[i][enteringCol];
      if (pivot > 1e-10) {
        // Positive pivot element
        final rhs = tableau[i].last;
        final ratio = rhs / pivot;
        if (ratio >= 0 && ratio < minRatio) {
          minRatio = ratio;
          leavingRow = i;
        }
      }
    }

    return leavingRow;
  }

  void _pivot(List<List<double>> tableau, int pivotRow, int pivotCol) {
    final pivotElement = tableau[pivotRow][pivotCol];

    // Normalize pivot row
    for (int j = 0; j < tableau[pivotRow].length; j++) {
      tableau[pivotRow][j] /= pivotElement;
    }

    // Eliminate pivot column in other rows
    for (int i = 0; i < tableau.length; i++) {
      if (i != pivotRow) {
        final factor = tableau[i][pivotCol];
        for (int j = 0; j < tableau[i].length; j++) {
          tableau[i][j] -= factor * tableau[pivotRow][j];
        }
      }
    }
  }

  List<double> _extractSolution(
    List<List<double>> tableau,
    _StandardForm form,
  ) {
    final solution = List.filled(form.numOriginalVars, 0.0);

    // Extract basic variables from tableau
    for (int j = 0; j < form.numOriginalVars; j++) {
      // Check if column j is a basic variable (has exactly one 1 and rest 0s)
      int basicRow = -1;
      bool isBasic = true;
      int onesCount = 0;

      for (int i = 0; i < tableau.length - 1; i++) {
        final value = tableau[i][j];
        if ((value - 1.0).abs() < 1e-10) {
          onesCount++;
          basicRow = i;
        } else if (value.abs() > 1e-10) {
          isBasic = false;
          break;
        }
      }

      if (isBasic && onesCount == 1 && basicRow != -1) {
        solution[j] = tableau[basicRow].last;
      }
    }

    return solution;
  }

  double _calculateObjectiveValue(List<double> solution, List<double> c) {
    double value = 0.0;
    for (int i = 0; i < solution.length; i++) {
      value += c[i] * solution[i];
    }
    return value;
  }
}

/// Standard form representation of LP problem
class _StandardForm {
  final List<double> objectiveCoefficients;
  final List<List<double>> constraintMatrix;
  final List<double> constraintBounds;
  final int numOriginalVars;
  final int numSlackVars;
  final List<double> lowerBounds;
  final List<double> upperBounds;

  _StandardForm({
    required this.objectiveCoefficients,
    required this.constraintMatrix,
    required this.constraintBounds,
    required this.numOriginalVars,
    required this.numSlackVars,
    required this.lowerBounds,
    required this.upperBounds,
  });
}

/// Result of simplex algorithm
class SimplexResult {
  final bool success;
  final List<double> solution;
  final double objectiveValue;
  final String message;

  SimplexResult({
    required this.success,
    required this.solution,
    required this.objectiveValue,
    required this.message,
  });
}

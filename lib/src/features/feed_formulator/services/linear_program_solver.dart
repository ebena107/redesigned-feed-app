enum ConstraintType {
  lessOrEqual,
  greaterOrEqual,
  equal,
}

class LinearConstraint {
  final List<double> coefficients;
  final double rhs;
  final ConstraintType type;

  LinearConstraint({
    required this.coefficients,
    required this.rhs,
    required this.type,
  });
}

class LinearProgramResult {
  final bool isOptimal;
  final bool isInfeasible;
  final List<double> solution;
  final double objectiveValue;
  final List<List<double>> tableau; // Expose for shadow price extraction
  final List<int> basis; // Expose for shadow price extraction

  LinearProgramResult({
    required this.isOptimal,
    required this.isInfeasible,
    required this.solution,
    required this.objectiveValue,
    required this.tableau,
    required this.basis,
  });
}

class LinearProgramSolver {
  static const double epsilon = 1e-9;

  late List<List<double>> tableau;
  late int rows;
  late int cols;
  late int numVariables;
  late List<int> basis;
  late List<int> artificialColumns;

  LinearProgramResult solve({
    required List<double> objective,
    required List<LinearConstraint> constraints,
  }) {
    try {
      _buildTableau(objective, constraints);
      _simplex();

      if (_phaseOneObjectiveValue() > epsilon || _isInfeasible()) {
        return LinearProgramResult(
          isOptimal: false,
          isInfeasible: true,
          solution: [],
          objectiveValue: double.infinity,
          tableau: tableau,
          basis: basis,
        );
      }

      _removeArtificialFromBasis();
      _setupPhaseTwoObjective(objective);
      _simplex();

      if (_isInfeasible()) {
        return LinearProgramResult(
          isOptimal: false,
          isInfeasible: true,
          solution: [],
          objectiveValue: double.infinity,
          tableau: tableau,
          basis: basis,
        );
      }

      final solution = List<double>.filled(numVariables, 0);

      for (int i = 0; i < basis.length; i++) {
        if (basis[i] < numVariables) {
          solution[basis[i]] = tableau[i][cols - 1];
        }
      }

      return LinearProgramResult(
        isOptimal: true,
        isInfeasible: false,
        solution: solution,
        objectiveValue: tableau[rows - 1][cols - 1],
        tableau: tableau,
        basis: basis,
      );
    } catch (_) {
      return LinearProgramResult(
        isOptimal: false,
        isInfeasible: true,
        solution: [],
        objectiveValue: double.infinity,
        tableau: [],
        basis: [],
      );
    }
  }

  void _buildTableau(
    List<double> objective,
    List<LinearConstraint> constraints,
  ) {
    numVariables = objective.length;

    final normalized = _normalizeRhs(constraints);

    var slackCount = 0;
    var artificialCount = 0;

    for (final constraint in normalized) {
      if (constraint.type == ConstraintType.lessOrEqual) {
        slackCount += 1;
      } else if (constraint.type == ConstraintType.greaterOrEqual) {
        slackCount += 1;
        artificialCount += 1;
      } else {
        artificialCount += 1;
      }
    }

    rows = normalized.length + 1;
    cols = numVariables + slackCount + artificialCount + 1;

    tableau = List.generate(
      rows,
      (_) => List.filled(cols, 0.0),
    );

    basis = List.filled(normalized.length, 0);
    artificialColumns = [];

    var slackOffset = numVariables;
    var artificialOffset = numVariables + slackCount;

    for (int i = 0; i < normalized.length; i++) {
      final c = normalized[i];

      for (int j = 0; j < numVariables; j++) {
        tableau[i][j] = c.coefficients[j];
      }

      if (c.type == ConstraintType.lessOrEqual) {
        tableau[i][slackOffset] = 1;
        basis[i] = slackOffset;
        slackOffset += 1;
      } else if (c.type == ConstraintType.greaterOrEqual) {
        tableau[i][slackOffset] = -1;
        slackOffset += 1;
        tableau[i][artificialOffset] = 1;
        basis[i] = artificialOffset;
        artificialColumns.add(artificialOffset);
        artificialOffset += 1;
      } else {
        tableau[i][artificialOffset] = 1;
        basis[i] = artificialOffset;
        artificialColumns.add(artificialOffset);
        artificialOffset += 1;
      }

      tableau[i][cols - 1] = c.rhs;
    }

    // Phase I objective: minimize sum of artificial variables
    for (final col in artificialColumns) {
      tableau[rows - 1][col] = 1;
    }

    for (int i = 0; i < basis.length; i++) {
      if (artificialColumns.contains(basis[i])) {
        for (int j = 0; j < cols; j++) {
          tableau[rows - 1][j] -= tableau[i][j];
        }
      }
    }
  }

  List<LinearConstraint> _normalizeRhs(
    List<LinearConstraint> constraints,
  ) {
    return constraints.map((constraint) {
      if (constraint.rhs >= 0) return constraint;

      final flippedType = switch (constraint.type) {
        ConstraintType.lessOrEqual => ConstraintType.greaterOrEqual,
        ConstraintType.greaterOrEqual => ConstraintType.lessOrEqual,
        ConstraintType.equal => ConstraintType.equal,
      };

      return LinearConstraint(
        coefficients: constraint.coefficients.map((v) => -v).toList(),
        rhs: -constraint.rhs,
        type: flippedType,
      );
    }).toList();
  }

  double _phaseOneObjectiveValue() {
    return tableau[rows - 1][cols - 1].abs();
  }

  void _removeArtificialFromBasis() {
    for (int i = 0; i < basis.length; i++) {
      if (!artificialColumns.contains(basis[i])) continue;

      var pivotCol = -1;
      for (int j = 0; j < cols - 1; j++) {
        if (!artificialColumns.contains(j) && tableau[i][j].abs() > epsilon) {
          pivotCol = j;
          break;
        }
      }

      if (pivotCol != -1) {
        _pivot(i, pivotCol);
        basis[i] = pivotCol;
      }
    }
  }

  void _setupPhaseTwoObjective(List<double> objective) {
    for (int j = 0; j < cols; j++) {
      tableau[rows - 1][j] = 0;
    }

    for (int j = 0; j < numVariables; j++) {
      tableau[rows - 1][j] = -objective[j];
    }

    for (final col in artificialColumns) {
      tableau[rows - 1][col] = 0;
    }

    for (int i = 0; i < basis.length; i++) {
      final basicVar = basis[i];
      if (basicVar >= cols - 1) continue;
      final coeff = tableau[rows - 1][basicVar];
      if (coeff.abs() < epsilon) continue;

      for (int j = 0; j < cols; j++) {
        tableau[rows - 1][j] -= coeff * tableau[i][j];
      }
    }
  }

  void _simplex() {
    while (true) {
      final pivotCol = _findEnteringColumn();
      if (pivotCol == -1) break;

      final pivotRow = _findLeavingRow(pivotCol);

      if (pivotRow == -1) {
        throw Exception("Unbounded");
      }

      _pivot(pivotRow, pivotCol);

      basis[pivotRow] = pivotCol;
    }
  }

  int _findEnteringColumn() {
    int pivotCol = -1;
    double minValue = -epsilon;

    for (int j = 0; j < cols - 1; j++) {
      if (tableau[rows - 1][j] < minValue) {
        minValue = tableau[rows - 1][j];
        pivotCol = j;
      }
    }

    return pivotCol;
  }

  int _findLeavingRow(int pivotCol) {
    int pivotRow = -1;
    double minRatio = double.infinity;

    for (int i = 0; i < rows - 1; i++) {
      final element = tableau[i][pivotCol];

      if (element > epsilon) {
        final ratio = tableau[i][cols - 1] / element;

        if (ratio < minRatio) {
          minRatio = ratio;
          pivotRow = i;
        }
      }
    }

    return pivotRow;
  }

  void _pivot(int pivotRow, int pivotCol) {
    final pivotValue = tableau[pivotRow][pivotCol];

    for (int j = 0; j < cols; j++) {
      tableau[pivotRow][j] /= pivotValue;
    }

    for (int i = 0; i < rows; i++) {
      if (i == pivotRow) continue;

      final factor = tableau[i][pivotCol];

      for (int j = 0; j < cols; j++) {
        tableau[i][j] -= factor * tableau[pivotRow][j];
      }
    }
  }

  bool _isInfeasible() {
    return tableau[rows - 1][cols - 1].isNaN ||
        tableau[rows - 1][cols - 1].isInfinite;
  }
}

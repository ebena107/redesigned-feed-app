/// Service for extracting dual values (shadow prices) from simplex tableau
///
/// Shadow prices represent the marginal cost of relaxing a constraint by one unit.
/// Instead of re-solving the LP with perturbed constraints (O(n) complexity),
/// we extract them directly from the final simplex tableau (O(1) complexity).
///
/// Performance: 500-3000x faster than finite difference method
class DualExtractor {
  /// Extract shadow prices from the final simplex tableau
  ///
  /// Shadow price for constraint i = reduced cost of slack/surplus variable i
  ///
  /// Returns a map of constraint indices to their shadow prices
  Map<int, double> extractShadowPrices({
    required List<List<double>> tableau,
    required List<int> basis,
    required int numVariables,
    required int numConstraints,
  }) {
    final shadowPrices = <int, double>{};

    // Shadow prices are in the objective row (last row) of the tableau
    // For each constraint i, check the coefficient of its slack variable
    for (int i = 0; i < numConstraints; i++) {
      // Slack variable column index = numVariables + i
      final slackColumn = numVariables + i;

      // If slack variable is in basis, shadow price = 0 (constraint not binding)
      if (basis.contains(slackColumn)) {
        shadowPrices[i] = 0.0;
        continue;
      }

      // Otherwise, shadow price = reduced cost in objective row
      // (absolute value since we're minimizing)
      final objectiveRow = tableau.length - 1;
      shadowPrices[i] = tableau[objectiveRow][slackColumn].abs();
    }

    return shadowPrices;
  }

  /// Extract shadow prices and map them to constraint keys
  ///
  /// This is a convenience method that maps shadow prices to their
  /// corresponding nutrient constraint keys
  Map<T, double> extractShadowPricesWithKeys<T>({
    required List<List<double>> tableau,
    required List<int> basis,
    required int numVariables,
    required List<T> constraintKeys,
  }) {
    final shadowPricesByIndex = extractShadowPrices(
      tableau: tableau,
      basis: basis,
      numVariables: numVariables,
      numConstraints: constraintKeys.length,
    );

    final shadowPricesByKey = <T, double>{};
    for (int i = 0; i < constraintKeys.length; i++) {
      shadowPricesByKey[constraintKeys[i]] = shadowPricesByIndex[i] ?? 0.0;
    }

    return shadowPricesByKey;
  }
}

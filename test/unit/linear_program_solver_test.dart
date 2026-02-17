import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/linear_program_solver.dart';

void main() {
  group('LinearProgramSolver', () {
    test('solves >= constraint for single variable', () {
      final solver = LinearProgramSolver();
      final result = solver.solve(
        objective: [1],
        constraints: [
          LinearConstraint(
            coefficients: [1],
            rhs: 1,
            type: ConstraintType.greaterOrEqual,
          ),
        ],
      );

      expect(result.isOptimal, isTrue);
      expect(result.solution.length, 1);
      expect(result.solution.first, closeTo(1, 1e-6));
    });

    test('solves equality constraint', () {
      final solver = LinearProgramSolver();
      final result = solver.solve(
        objective: [1],
        constraints: [
          LinearConstraint(
            coefficients: [1],
            rhs: 2,
            type: ConstraintType.equal,
          ),
        ],
      );

      expect(result.isOptimal, isTrue);
      expect(result.solution.length, 1);
      expect(result.solution.first, closeTo(2, 1e-6));
    });

    test('solves two-variable equality', () {
      final solver = LinearProgramSolver();
      final result = solver.solve(
        objective: [1, 1],
        constraints: [
          LinearConstraint(
            coefficients: [1, 1],
            rhs: 1,
            type: ConstraintType.equal,
          ),
          LinearConstraint(
            coefficients: [1, 0],
            rhs: 0,
            type: ConstraintType.greaterOrEqual,
          ),
          LinearConstraint(
            coefficients: [0, 1],
            rhs: 0,
            type: ConstraintType.greaterOrEqual,
          ),
        ],
      );

      expect(result.isOptimal, isTrue);
      expect(result.solution.length, 2);
      final sum = result.solution[0] + result.solution[1];
      expect(sum, closeTo(1, 1e-6));
      expect(result.solution[0], greaterThanOrEqualTo(0));
      expect(result.solution[1], greaterThanOrEqualTo(0));
    });
  });
}

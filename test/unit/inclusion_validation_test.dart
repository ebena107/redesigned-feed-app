import 'package:feed_estimator/src/features/reports/model/inclusion_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InclusionValidation Tests', () {
    group('InclusionValidationResult', () {
      test('hasViolations returns true when violations exist', () {
        final violation = InclusionViolation(
          ingredientName: 'Cottonseed meal',
          maxAllowedPct: 15.0,
          actualPct: 20.0,
          reason: 'Gossypol toxicity',
        );

        final result = InclusionValidationResult(violations: [violation]);

        expect(result.hasViolations, true);
      });

      test('hasViolations returns false when no violations', () {
        final result = InclusionValidationResult();

        expect(result.hasViolations, false);
      });

      test('hasWarnings returns true when warnings exist', () {
        final warning = InclusionWarning(
          ingredientName: 'Moringa',
          maxAllowedPct: 10.0,
          actualPct: 8.5,
        );

        final result = InclusionValidationResult(warnings: [warning]);

        expect(result.hasWarnings, true);
      });

      test('hasWarnings returns false when no warnings', () {
        final result = InclusionValidationResult();

        expect(result.hasWarnings, false);
      });

      test('hasIssues returns true for violations', () {
        final violation = InclusionViolation(
          ingredientName: 'Cottonseed',
          maxAllowedPct: 15.0,
          actualPct: 20.0,
        );

        final result = InclusionValidationResult(violations: [violation]);

        expect(result.hasIssues, true);
      });

      test('hasIssues returns true for warnings', () {
        final warning = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.0,
        );

        final result = InclusionValidationResult(warnings: [warning]);

        expect(result.hasIssues, true);
      });

      test('hasIssues returns false for empty result', () {
        final result = InclusionValidationResult();

        expect(result.hasIssues, false);
      });
    });

    group('InclusionViolation', () {
      test('creates violation with correct properties', () {
        final violation = InclusionViolation(
          ingredientName: 'Cottonseed meal',
          maxAllowedPct: 15.0,
          actualPct: 25.5,
          reason: 'Free gossypol toxicity',
        );

        expect(violation.ingredientName, 'Cottonseed meal');
        expect(violation.maxAllowedPct, 15.0);
        expect(violation.actualPct, 25.5);
        expect(violation.reason, 'Free gossypol toxicity');
      });

      test('generates correct description for violation', () {
        final violation = InclusionViolation(
          ingredientName: 'Cottonseed meal',
          maxAllowedPct: 15.0,
          actualPct: 25.5,
          reason: 'Gossypol toxicity',
        );

        expect(
          violation.description,
          'Cottonseed meal exceeds limit: 25.5% > 15.0% (Gossypol toxicity)',
        );
      });

      test('generates description without reason when reason is null', () {
        final violation = InclusionViolation(
          ingredientName: 'Cottonseed meal',
          maxAllowedPct: 15.0,
          actualPct: 25.5,
        );

        expect(
          violation.description,
          'Cottonseed meal exceeds limit: 25.5% > 15.0%',
        );
      });

      test('violation equality works correctly', () {
        final violation1 = InclusionViolation(
          ingredientName: 'Cottonseed',
          maxAllowedPct: 15.0,
          actualPct: 20.0,
        );

        final violation2 = InclusionViolation(
          ingredientName: 'Cottonseed',
          maxAllowedPct: 15.0,
          actualPct: 20.0,
        );

        expect(violation1, equals(violation2));
      });

      test('different violations are not equal', () {
        final violation1 = InclusionViolation(
          ingredientName: 'Cottonseed',
          maxAllowedPct: 15.0,
          actualPct: 20.0,
        );

        final violation2 = InclusionViolation(
          ingredientName: 'Moringa',
          maxAllowedPct: 10.0,
          actualPct: 15.0,
        );

        expect(violation1, isNot(equals(violation2)));
      });
    });

    group('InclusionWarning', () {
      test('creates warning with correct properties', () {
        final warning = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.5,
        );

        expect(warning.ingredientName, 'Rapeseed');
        expect(warning.maxAllowedPct, 10.0);
        expect(warning.actualPct, 8.5);
        expect(warning.warningThresholdPct, 0.8);
      });

      test('calculates percentageOfLimit correctly', () {
        final warning = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.0,
        );

        // 8.0 / 10.0 * 100 = 80.0
        expect(warning.percentageOfLimit, 80.0);
      });

      test('rounds percentageOfLimit to 1 decimal place', () {
        final warning = InclusionWarning(
          ingredientName: 'Test ingredient',
          maxAllowedPct: 3.0,
          actualPct: 2.35,
        );

        // 2.35 / 3.0 * 100 = 78.333... rounds to 78.3
        expect(
          warning.percentageOfLimit,
          closeTo(78.3, 0.1),
        );
      });

      test('generates correct description for warning', () {
        final warning = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.0,
        );

        expect(
          warning.description,
          'Rapeseed is at 80.0% of maximum: 8.0% of 10.0% limit',
        );
      });

      test('warning equality works correctly', () {
        final warning1 = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.0,
        );

        final warning2 = InclusionWarning(
          ingredientName: 'Rapeseed',
          maxAllowedPct: 10.0,
          actualPct: 8.0,
        );

        expect(warning1, equals(warning2));
      });
    });

    group('Edge Cases', () {
      test('handles very small percentage values', () {
        final warning = InclusionWarning(
          ingredientName: 'Additive',
          maxAllowedPct: 0.5,
          actualPct: 0.4,
        );

        // 0.4 / 0.5 * 100 = 80.0
        expect(warning.percentageOfLimit, 80.0);
      });

      test('handles 100% inclusion (maximum allowed)', () {
        final warning = InclusionWarning(
          ingredientName: 'Corn',
          maxAllowedPct: 100.0,
          actualPct: 99.5,
        );

        // 99.5 / 100.0 * 100 = 99.5
        expect(warning.percentageOfLimit, 99.5);
      });

      test('violation with very high actual percentage', () {
        final violation = InclusionViolation(
          ingredientName: 'Dangerous ingredient',
          maxAllowedPct: 5.0,
          actualPct: 50.0,
        );

        expect(violation.description, contains('50.0%'));
        expect(violation.description, contains('5.0%'));
      });

      test('empty ingredient name handled correctly', () {
        final violation = InclusionViolation(
          ingredientName: '',
          maxAllowedPct: 10.0,
          actualPct: 15.0,
        );

        expect(violation.ingredientName, isEmpty);
        expect(violation.description, contains('exceeds limit'));
      });
    });
  });
}

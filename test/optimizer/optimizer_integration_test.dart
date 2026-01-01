import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/optimizer/services/simplex_solver.dart';
import 'package:feed_estimator/src/features/optimizer/services/formulation_optimizer_service.dart';
import 'package:feed_estimator/src/features/optimizer/services/constraint_validator.dart';
import 'package:feed_estimator/src/features/optimizer/services/formulation_scorer.dart';
import 'package:feed_estimator/src/features/optimizer/services/formulation_exporter.dart';
import 'package:feed_estimator/src/features/optimizer/model/optimization_constraint.dart';
import 'package:feed_estimator/src/features/optimizer/model/optimization_request.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

void main() {
  group('Feed Optimizer Integration Tests', () {
    late FormulationOptimizerService optimizerService;
    late ConstraintValidator validator;
    late FormulationScorer scorer;
    late FormulationExporter exporter;
    late Map<int, Ingredient> ingredientCache;

    setUp(() {
      optimizerService = FormulationOptimizerService();
      validator = ConstraintValidator();
      scorer = FormulationScorer();
      exporter = FormulationExporter();

      // Create sample ingredients
      ingredientCache = {
        1: Ingredient(
          ingredientId: 1,
          name: 'Corn',
          crudeProtein: 8.5,
          crudeFat: 3.8,
          crudeFiber: 2.2,
          calcium: 0.02,
          phosphorus: 0.28,
          priceKg: 0.25,
          maxInclusionPct: 70.0,
        ),
        2: Ingredient(
          ingredientId: 2,
          name: 'Soybean Meal',
          crudeProtein: 44.0,
          crudeFat: 1.0,
          crudeFiber: 7.0,
          calcium: 0.27,
          phosphorus: 0.65,
          priceKg: 0.45,
          maxInclusionPct: 30.0,
        ),
        3: Ingredient(
          ingredientId: 3,
          name: 'Wheat Bran',
          crudeProtein: 15.5,
          crudeFat: 4.0,
          crudeFiber: 10.0,
          calcium: 0.13,
          phosphorus: 1.18,
          priceKg: 0.15,
          maxInclusionPct: 20.0,
        ),
      };
    });

    test('SimplexSolver - Basic LP Problem', () {
      final solver = SimplexSolver();

      // Minimize: 2x + 3y
      // Subject to: x + y >= 4
      //            2x + y >= 5
      //            x, y >= 0
      final result = solver.solve(
        objectiveCoefficients: [2.0, 3.0],
        constraintMatrix: [
          [1.0, 1.0],
          [2.0, 1.0],
        ],
        constraintBounds: [4.0, 5.0],
        lowerBounds: [0.0, 0.0],
        upperBounds: [100.0, 100.0],
      );

      expect(result, isNotNull);
      expect(result!.success, isTrue);
      expect(result.solution.length, equals(2));
      // Solution should be approximately x=1, y=3
      expect(result.solution[0], closeTo(1.0, 0.1));
      expect(result.solution[1], closeTo(3.0, 0.1));
    });

    test('ConstraintValidator - Detect Conflicts', () {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'protein',
          type: ConstraintType.min,
          value: 18.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'protein',
          type: ConstraintType.max,
          value: 15.0, // Conflict: max < min
          unit: '%',
        ),
      ];

      final result = validator.validateConstraints(constraints);
      expect(result.isValid, isFalse);
      expect(result.message.toLowerCase(), contains('minimum'));
      expect(result.message.toLowerCase(), contains('maximum'));
    });

    test('ConstraintValidator - Valid Constraints', () {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'protein',
          type: ConstraintType.min,
          value: 16.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'protein',
          type: ConstraintType.max,
          value: 20.0,
          unit: '%',
        ),
      ];

      final result = validator.validateConstraints(constraints);
      expect(result.isValid, isTrue);
    });

    test('FormulationOptimizerService - Minimize Cost', () async {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 16.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'crudeFiber',
          type: ConstraintType.max,
          value: 8.0,
          unit: '%',
        ),
      ];

      final request = OptimizationRequest(
        constraints: constraints,
        availableIngredientIds: [1, 2, 3],
        ingredientPrices: {1: 0.25, 2: 0.45, 3: 0.15},
        objective: ObjectiveFunction.minimizeCost,
      );

      final result = await optimizerService.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      expect(result.success, isTrue);
      expect(result.ingredientProportions.isNotEmpty, isTrue);
      expect(result.totalCost, greaterThan(0.0));
      expect(result.qualityScore, greaterThan(0.0));
      expect(result.qualityScore, lessThanOrEqualTo(100.0));

      // Check proportions sum to ~100%
      final total = result.ingredientProportions.values
          .fold<double>(0.0, (sum, val) => sum + val);
      expect(total, closeTo(100.0, 0.1));

      print('Optimization Result:');
      print('  Success: ${result.success}');
      print('  Cost: \$${result.totalCost.toStringAsFixed(2)}');
      print('  Quality Score: ${result.qualityScore.toStringAsFixed(1)}');
      print('  Ingredients:');
      result.ingredientProportions.forEach((id, proportion) {
        print(
            '    ${ingredientCache[id]?.name}: ${proportion.toStringAsFixed(2)}%');
      });
    });

    test('FormulationScorer - Quality Score Calculation', () async {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 16.0,
          unit: '%',
        ),
      ];

      final request = OptimizationRequest(
        constraints: constraints,
        availableIngredientIds: [1, 2, 3],
        ingredientPrices: {1: 0.25, 2: 0.45, 3: 0.15},
        objective: ObjectiveFunction.minimizeCost,
      );

      final result = await optimizerService.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      final score = scorer.calculateQualityScore(
        result: result,
        constraints: constraints,
        ingredientCache: ingredientCache,
      );

      expect(score, greaterThan(0.0));
      expect(score, lessThanOrEqualTo(100.0));

      final metrics = scorer.getMetrics(
        result: result,
        constraints: constraints,
        ingredientCache: ingredientCache,
      );

      expect(metrics.qualityScore, equals(score));
      expect(metrics.totalCost, equals(result.totalCost));
      expect(
          metrics.ingredientCount, equals(result.ingredientProportions.length));

      print('Formulation Metrics:');
      print('  Quality Score: ${metrics.qualityScore.toStringAsFixed(1)}');
      print('  Total Cost: \$${metrics.totalCost.toStringAsFixed(2)}');
      print(
          '  Cost per Protein: \$${metrics.costPerProtein.toStringAsFixed(3)}');
      print('  Ingredient Count: ${metrics.ingredientCount}');
      print('  Warnings: ${metrics.warningCount}');
    });

    test('FormulationExporter - JSON Export', () async {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 16.0,
          unit: '%',
        ),
      ];

      final request = OptimizationRequest(
        constraints: constraints,
        availableIngredientIds: [1, 2, 3],
        ingredientPrices: {1: 0.25, 2: 0.45, 3: 0.15},
        objective: ObjectiveFunction.minimizeCost,
      );

      final result = await optimizerService.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      final jsonExport = exporter.exportAsJson(
        result: result,
        request: request,
        ingredientCache: ingredientCache,
        feedName: 'Test Feed',
      );

      expect(jsonExport, isNotEmpty);
      expect(jsonExport, contains('Test Feed'));
      expect(jsonExport, contains('qualityScore'));
      expect(jsonExport, contains('totalCost'));

      print('JSON Export (first 200 chars):');
      print(jsonExport.substring(
          0, jsonExport.length > 200 ? 200 : jsonExport.length));
    });

    test('FormulationExporter - Text Report', () async {
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 16.0,
          unit: '%',
        ),
      ];

      final request = OptimizationRequest(
        constraints: constraints,
        availableIngredientIds: [1, 2, 3],
        ingredientPrices: {1: 0.25, 2: 0.45, 3: 0.15},
        objective: ObjectiveFunction.minimizeCost,
      );

      final result = await optimizerService.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      final report = exporter.exportAsTextReport(
        result: result,
        request: request,
        ingredientCache: ingredientCache,
        feedName: 'Test Feed',
      );

      expect(report, isNotEmpty);
      expect(report, contains('FEED FORMULATION REPORT'));
      expect(report, contains('Test Feed'));
      expect(report, contains('INGREDIENT COMPOSITION'));
      expect(report, contains('NUTRITIONAL PROFILE'));

      print('\n$report');
    });

    test('End-to-End Optimization Workflow', () async {
      // 1. Define constraints
      final constraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 18.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.max,
          value: 22.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'crudeFiber',
          type: ConstraintType.max,
          value: 6.0,
          unit: '%',
        ),
      ];

      // 2. Validate constraints
      final validationResult = validator.validateConstraints(constraints);
      expect(validationResult.isValid, isTrue);

      // 3. Create optimization request
      final request = OptimizationRequest(
        constraints: constraints,
        availableIngredientIds: [1, 2, 3],
        ingredientPrices: {1: 0.25, 2: 0.45, 3: 0.15},
        objective: ObjectiveFunction.minimizeCost,
      );

      // 4. Run optimization
      final result = await optimizerService.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      expect(result.success, isTrue);

      // 5. Validate result
      final resultValidation = validator.validateResult(result, constraints);
      print('Result Validation: ${resultValidation.message}');

      // 6. Calculate score
      final score = scorer.calculateQualityScore(
        result: result,
        constraints: constraints,
        ingredientCache: ingredientCache,
      );
      expect(score, greaterThan(0.0));

      // 7. Export as Feed
      final feed = exporter.exportAsFeed(
        result: result,
        request: request,
        feedName: 'Optimized Broiler Feed',
        animalId: 1,
        productionStage: 'Grower',
      );

      expect(feed.feedName, equals('Optimized Broiler Feed'));
      expect(feed.isOptimized, isTrue);
      expect(feed.optimizationScore, equals(result.qualityScore));
      expect(feed.feedIngredients, isNotEmpty);

      print('\n=== End-to-End Test Complete ===');
      print('Feed: ${feed.feedName}');
      print('Optimized: ${feed.isOptimized}');
      print('Score: ${feed.optimizationScore?.toStringAsFixed(1)}');
      print('Objective: ${feed.optimizationObjective}');
      print('Ingredients: ${feed.feedIngredients?.length}');
    });
  });
}

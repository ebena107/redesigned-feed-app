import 'package:feed_estimator/src/core/database/data_validator.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NutritionalDataValidator Tests', () {
    group('Negative Value Validation', () {
      test('rejects negative protein value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: -5.0,
          crudeFiber: 10.0,
          crudeFat: 5.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Protein cannot be negative'));
      });

      test('rejects negative fiber value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: 15.0,
          crudeFiber: -10.0,
          crudeFat: 5.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Fiber cannot be negative'));
      });

      test('rejects negative fat value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: 15.0,
          crudeFiber: 10.0,
          crudeFat: -5.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Fat cannot be negative'));
      });

      test('rejects negative calcium value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          calcium: -2.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Calcium cannot be negative'));
      });

      test('rejects negative phosphorus value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          phosphorus: -1.5,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Phosphorus cannot be negative'));
      });

      test('rejects negative lysine value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          lysine: -0.5,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Lysine cannot be negative'));
      });

      test('rejects negative methionine value', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          methionine: -0.3,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors, contains('Methionine cannot be negative'));
      });
    });

    group('Bran Product Validation', () {
      test('rejects bran product with zero fiber', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Rice Bran',
          crudeProtein: 12.0,
          crudeFiber: 0.0,
          crudeFat: 15.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(
          result.errors,
          contains('Bran products should have fiber content greater than zero'),
        );
      });

      test('rejects bran product with null fiber', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Wheat Bran',
          crudeProtein: 15.0,
          crudeFat: 4.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(
          result.errors,
          contains('Bran products should have fiber content greater than zero'),
        );
      });

      test('accepts bran product with valid fiber', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Rice Bran',
          crudeProtein: 12.0,
          crudeFiber: 11.0,
          crudeFat: 15.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });
    });

    group('Total Nutritional Content Validation', () {
      test('rejects ingredient with total > 100%', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Invalid Ingredient',
          crudeProtein: 60.0,
          crudeFiber: 30.0,
          crudeFat: 20.0, // Total = 110%
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(
          result.errors,
          contains(
              'Total nutritional content (protein + fat + fiber) exceeds 100%'),
        );
      });

      test('accepts ingredient with total = 100%', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Valid Ingredient',
          crudeProtein: 50.0,
          crudeFiber: 30.0,
          crudeFat: 20.0, // Total = 100%
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('accepts ingredient with total < 100%', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Valid Ingredient',
          crudeProtein: 40.0,
          crudeFiber: 25.0,
          crudeFat: 15.0, // Total = 80%
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('skips total validation for mineral supplements', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Calcium Carbonate',
          crudeProtein: 0.0,
          crudeFiber: 0.0,
          crudeFat: 0.0,
          calcium: 380.0, // High calcium is expected
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('skips total validation for limestone', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Limestone',
          calcium: 350.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
      });
    });

    group('Energy Value Validation', () {
      test('rejects regular ingredient with ME > 5000 kcal/kg', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Regular Ingredient',
          crudeProtein: 20.0,
          crudeFat: 10.0,
          meGrowingPig: 6000.0, // Too high for regular ingredient
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(
          result.errors,
          contains('ME for growing pig seems unusually high (>5000 kcal/kg)'),
        );
      });

      test('accepts high-fat ingredient with ME up to 6000 kcal/kg', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'High Fat Ingredient',
          crudeFat: 50.0, // > 40% fat
          meGrowingPig: 5500.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('accepts pure oil with ME up to 10000 kcal/kg', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Soybean Oil',
          crudeFat: 99.0, // > 90% fat
          mePoultry: 9000.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('accepts amino acid supplement with ME up to 6000 kcal/kg', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'DL-Methionine',
          crudeFat: 0.0,
          mePoultry: 5800.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('rejects pure oil with ME > 10000 kcal/kg', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Oil',
          crudeFat: 99.0,
          meGrowingPig: 11000.0, // Too high even for oil
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(
          result.errors,
          contains('ME for growing pig seems unusually high (>10000 kcal/kg)'),
        );
      });
    });

    group('Batch Validation', () {
      test('validates multiple ingredients and returns results map', () {
        final ingredients = [
          Ingredient(
            ingredientId: 1,
            name: 'Valid Ingredient',
            crudeProtein: 20.0,
            crudeFiber: 10.0,
            crudeFat: 5.0,
          ),
          Ingredient(
            ingredientId: 2,
            name: 'Invalid Ingredient',
            crudeProtein: -5.0, // Negative value
          ),
          Ingredient(
            ingredientId: 3,
            name: 'Rice Bran',
            crudeProtein: 12.0,
            crudeFiber: 0.0, // Bran without fiber
          ),
        ];

        final results = NutritionalDataValidator.validateBatch(ingredients);

        expect(results.length, 3);
        expect(results[1]!.isValid, true);
        expect(results[2]!.isValid, false);
        expect(results[3]!.isValid, false);
      });

      test('handles empty ingredient list', () {
        final results = NutritionalDataValidator.validateBatch([]);

        expect(results, isEmpty);
      });

      test('skips ingredients without ID', () {
        final ingredients = [
          Ingredient(
            name: 'No ID Ingredient',
            crudeProtein: 20.0,
          ),
        ];

        final results = NutritionalDataValidator.validateBatch(ingredients);

        expect(results, isEmpty);
      });
    });

    group('Complex Validation Scenarios', () {
      test('accepts valid complete ingredient', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Soybean Meal',
          crudeProtein: 44.0,
          crudeFiber: 7.0,
          crudeFat: 1.0,
          calcium: 2.7,
          phosphorus: 6.5,
          lysine: 27.0,
          methionine: 6.0,
          meGrowingPig: 3230.0,
          meAdultPig: 3380.0,
          mePoultry: 2230.0,
          meRuminant: 2990.0,
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('accumulates multiple errors', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Rice Bran',
          crudeProtein: -5.0, // Error 1: negative
          crudeFiber: 0.0, // Error 2: bran without fiber
          crudeFat: 15.0,
          calcium: -2.0, // Error 3: negative
        );

        final result = NutritionalDataValidator.validate(ingredient);

        expect(result.isValid, false);
        expect(result.errors.length, 3);
        expect(result.errors, contains('Protein cannot be negative'));
        expect(result.errors, contains('Calcium cannot be negative'));
        expect(
          result.errors,
          contains('Bran products should have fiber content greater than zero'),
        );
      });
    });

    group('ValidationResult Factory Methods', () {
      test('ValidationResult.success creates valid result', () {
        final result = ValidationResult.success();

        expect(result.isValid, true);
        expect(result.errors, isEmpty);
      });

      test('ValidationResult.failure creates invalid result with errors', () {
        final errors = ['Error 1', 'Error 2'];
        final result = ValidationResult.failure(errors);

        expect(result.isValid, false);
        expect(result.errors, errors);
      });
    });
  });
}

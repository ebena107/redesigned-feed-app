import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ingredient Model Tests', () {
    group('Constructor and Properties', () {
      test('creates ingredient with all properties', () {
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
          meRabbit: 2100.0,
          deSalmonids: 3000.0,
          priceKg: 450.0,
          availableQty: 1000.0,
          categoryId: 1,
          favourite: 1,
          isCustom: 0,
          createdBy: 'test_user',
          createdDate: 1638360000000,
          notes: 'Test notes',
        );

        expect(ingredient.ingredientId, 1);
        expect(ingredient.name, 'Soybean Meal');
        expect(ingredient.crudeProtein, 44.0);
        expect(ingredient.crudeFiber, 7.0);
        expect(ingredient.crudeFat, 1.0);
        expect(ingredient.calcium, 2.7);
        expect(ingredient.phosphorus, 6.5);
        expect(ingredient.lysine, 27.0);
        expect(ingredient.methionine, 6.0);
        expect(ingredient.meGrowingPig, 3230.0);
        expect(ingredient.meAdultPig, 3380.0);
        expect(ingredient.mePoultry, 2230.0);
        expect(ingredient.meRuminant, 2990.0);
        expect(ingredient.meRabbit, 2100.0);
        expect(ingredient.deSalmonids, 3000.0);
        expect(ingredient.priceKg, 450.0);
        expect(ingredient.availableQty, 1000.0);
        expect(ingredient.categoryId, 1);
        expect(ingredient.favourite, 1);
        expect(ingredient.isCustom, 0);
        expect(ingredient.createdBy, 'test_user');
        expect(ingredient.createdDate, 1638360000000);
        expect(ingredient.notes, 'Test notes');
      });

      test('creates ingredient with minimal properties', () {
        final ingredient = Ingredient();

        expect(ingredient.ingredientId, isNull);
        expect(ingredient.name, isNull);
        expect(ingredient.crudeProtein, isNull);
        expect(ingredient.crudeFiber, isNull);
        expect(ingredient.crudeFat, isNull);
      });

      test('creates ingredient with partial properties', () {
        final ingredient = Ingredient(
          ingredientId: 2,
          name: 'Corn',
          crudeProtein: 8.5,
        );

        expect(ingredient.ingredientId, 2);
        expect(ingredient.name, 'Corn');
        expect(ingredient.crudeProtein, 8.5);
        expect(ingredient.crudeFiber, isNull);
        expect(ingredient.crudeFat, isNull);
      });
    });

    group('JSON Serialization', () {
      test('converts to JSON correctly', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: 20.0,
          crudeFiber: 10.0,
          crudeFat: 5.0,
          calcium: 2.0,
          phosphorus: 1.5,
          lysine: 10.0,
          methionine: 3.0,
          meGrowingPig: 3000.0,
          meAdultPig: 3100.0,
          mePoultry: 2800.0,
          meRuminant: 2900.0,
          meRabbit: 2700.0,
          deSalmonids: 3200.0,
          priceKg: 100.0,
          availableQty: 500.0,
          categoryId: 1,
          favourite: 0,
          isCustom: 1,
          createdBy: 'user123',
          createdDate: 1638360000000,
          notes: 'Custom ingredient',
        );

        final json = ingredient.toJson();

        expect(json['ingredient_id'], 1);
        expect(json['name'], 'Test Ingredient');
        expect(json['crude_protein'], 20.0);
        expect(json['crude_fiber'], 10.0);
        expect(json['crude_fat'], 5.0);
        expect(json['calcium'], 2.0);
        expect(json['phosphorus'], 1.5);
        expect(json['lysine'], 10.0);
        expect(json['methionine'], 3.0);
        expect(json['me_growing_pig'], 3000.0);
        expect(json['me_adult_pig'], 3100.0);
        expect(json['me_poultry'], 2800.0);
        expect(json['me_ruminant'], 2900.0);
        expect(json['me_rabbit'], 2700.0);
        expect(json['de_salmonids'], 3200.0);
        expect(json['price_kg'], 100.0);
        expect(json['available_qty'], 500.0);
        expect(json['category_id'], 1);
        expect(json['favourite'], 0);
        expect(json['is_custom'], 1);
        expect(json['created_by'], 'user123');
        expect(json['created_date'], 1638360000000);
        expect(json['notes'], 'Custom ingredient');
      });

      test('converts from JSON correctly', () {
        final json = {
          'ingredient_id': 1,
          'name': 'Test Ingredient',
          'crude_protein': 20.0,
          'crude_fiber': 10.0,
          'crude_fat': 5.0,
          'calcium': 2.0,
          'phosphorus': 1.5,
          'lysine': 10.0,
          'methionine': 3.0,
          'me_growing_pig': 3000.0,
          'me_adult_pig': 3100.0,
          'me_poultry': 2800.0,
          'me_ruminant': 2900.0,
          'me_rabbit': 2700.0,
          'de_salmonids': 3200.0,
          'price_kg': 100.0,
          'available_qty': 500.0,
          'category_id': 1,
          'favourite': 0,
          'is_custom': 1,
          'created_by': 'user123',
          'created_date': 1638360000000,
          'notes': 'Custom ingredient',
        };

        final ingredient = Ingredient.fromJson(json);

        expect(ingredient.ingredientId, 1);
        expect(ingredient.name, 'Test Ingredient');
        expect(ingredient.crudeProtein, 20.0);
        expect(ingredient.crudeFiber, 10.0);
        expect(ingredient.crudeFat, 5.0);
        expect(ingredient.calcium, 2.0);
        expect(ingredient.phosphorus, 1.5);
        expect(ingredient.lysine, 10.0);
        expect(ingredient.methionine, 3.0);
        expect(ingredient.meGrowingPig, 3000.0);
        expect(ingredient.meAdultPig, 3100.0);
        expect(ingredient.mePoultry, 2800.0);
        expect(ingredient.meRuminant, 2900.0);
        expect(ingredient.meRabbit, 2700.0);
        expect(ingredient.deSalmonids, 3200.0);
        expect(ingredient.priceKg, 100.0);
        expect(ingredient.availableQty, 500.0);
        expect(ingredient.categoryId, 1);
        expect(ingredient.favourite, 0);
        expect(ingredient.isCustom, 1);
        expect(ingredient.createdBy, 'user123');
        expect(ingredient.createdDate, 1638360000000);
        expect(ingredient.notes, 'Custom ingredient');
      });

      test('handles null values in JSON', () {
        final json = {
          'ingredient_id': 1,
          'name': 'Minimal Ingredient',
        };

        final ingredient = Ingredient.fromJson(json);

        expect(ingredient.ingredientId, 1);
        expect(ingredient.name, 'Minimal Ingredient');
        expect(ingredient.crudeProtein, isNull);
        expect(ingredient.crudeFiber, isNull);
        expect(ingredient.crudeFat, isNull);
      });

      test('round-trip JSON conversion preserves data', () {
        final original = Ingredient(
          ingredientId: 5,
          name: 'Round Trip Test',
          crudeProtein: 15.5,
          crudeFiber: 8.2,
          crudeFat: 3.7,
          priceKg: 250.0,
        );

        final json = original.toJson();
        final restored = Ingredient.fromJson(json);

        expect(restored.ingredientId, original.ingredientId);
        expect(restored.name, original.name);
        expect(restored.crudeProtein, original.crudeProtein);
        expect(restored.crudeFiber, original.crudeFiber);
        expect(restored.crudeFat, original.crudeFat);
        expect(restored.priceKg, original.priceKg);
      });
    });

    group('copyWith Method', () {
      test('copies with updated name', () {
        final original = Ingredient(
          ingredientId: 1,
          name: 'Original Name',
          crudeProtein: 20.0,
        );

        final updated = original.copyWith(name: 'Updated Name');

        expect(updated.ingredientId, 1);
        expect(updated.name, 'Updated Name');
        expect(updated.crudeProtein, 20.0);
      });

      test('copies with updated nutritional values', () {
        final original = Ingredient(
          ingredientId: 1,
          name: 'Test',
          crudeProtein: 20.0,
          crudeFiber: 10.0,
          crudeFat: 5.0,
        );

        final updated = original.copyWith(
          crudeProtein: 25.0,
          crudeFiber: 12.0,
        );

        expect(updated.crudeProtein, 25.0);
        expect(updated.crudeFiber, 12.0);
        expect(updated.crudeFat, 5.0); // Unchanged
        expect(updated.name, 'Test'); // Unchanged
      });

      test('copies with all properties updated', () {
        final original = Ingredient(
          ingredientId: 1,
          name: 'Original',
          crudeProtein: 20.0,
          priceKg: 100.0,
        );

        final updated = original.copyWith(
          ingredientId: 2,
          name: 'Updated',
          crudeProtein: 25.0,
          crudeFiber: 15.0,
          crudeFat: 8.0,
          calcium: 3.0,
          phosphorus: 2.0,
          lysine: 12.0,
          methionine: 5.0,
          meGrowingPig: 3500.0,
          meAdultPig: 3600.0,
          mePoultry: 3200.0,
          meRuminant: 3300.0,
          meRabbit: 3100.0,
          deSalmonids: 3400.0,
          priceKg: 200.0,
          availableQty: 1000.0,
          categoryId: 2,
          favourite: 1,
          isCustom: 1,
          createdBy: 'new_user',
          createdDate: 1638360000000,
          notes: 'New notes',
        );

        expect(updated.ingredientId, 2);
        expect(updated.name, 'Updated');
        expect(updated.crudeProtein, 25.0);
        expect(updated.crudeFiber, 15.0);
        expect(updated.crudeFat, 8.0);
        expect(updated.calcium, 3.0);
        expect(updated.phosphorus, 2.0);
        expect(updated.lysine, 12.0);
        expect(updated.methionine, 5.0);
        expect(updated.meGrowingPig, 3500.0);
        expect(updated.meAdultPig, 3600.0);
        expect(updated.mePoultry, 3200.0);
        expect(updated.meRuminant, 3300.0);
        expect(updated.meRabbit, 3100.0);
        expect(updated.deSalmonids, 3400.0);
        expect(updated.priceKg, 200.0);
        expect(updated.availableQty, 1000.0);
        expect(updated.categoryId, 2);
        expect(updated.favourite, 1);
        expect(updated.isCustom, 1);
        expect(updated.createdBy, 'new_user');
        expect(updated.createdDate, 1638360000000);
        expect(updated.notes, 'New notes');
      });

      test('copyWith without parameters returns identical copy', () {
        final original = Ingredient(
          ingredientId: 1,
          name: 'Test',
          crudeProtein: 20.0,
        );

        final copy = original.copyWith();

        expect(copy.ingredientId, original.ingredientId);
        expect(copy.name, original.name);
        expect(copy.crudeProtein, original.crudeProtein);
      });
    });

    group('Helper Functions', () {
      test('ingredientFromJson parses JSON string', () {
        const jsonString = '''
        {
          "ingredient_id": 1,
          "name": "Test Ingredient",
          "crude_protein": 20.0
        }
        ''';

        final ingredient = ingredientFromJson(jsonString);

        expect(ingredient.ingredientId, 1);
        expect(ingredient.name, 'Test Ingredient');
        expect(ingredient.crudeProtein, 20.0);
      });

      test('ingredientToJson converts to JSON string', () {
        final ingredient = Ingredient(
          ingredientId: 1,
          name: 'Test Ingredient',
          crudeProtein: 20.0,
        );

        final jsonString = ingredientToJson(ingredient);

        expect(jsonString, contains('"ingredient_id":1'));
        expect(jsonString, contains('"name":"Test Ingredient"'));
        expect(jsonString, contains('"crude_protein":20.0'));
      });

      test('ingredientListFromJson parses JSON array string', () {
        const jsonString = '''
        [
          {
            "ingredient_id": 1,
            "name": "Ingredient 1",
            "crude_protein": 20.0
          },
          {
            "ingredient_id": 2,
            "name": "Ingredient 2",
            "crude_protein": 15.0
          }
        ]
        ''';

        final ingredients = ingredientListFromJson(jsonString);

        expect(ingredients.length, 2);
        expect(ingredients[0].ingredientId, 1);
        expect(ingredients[0].name, 'Ingredient 1');
        expect(ingredients[1].ingredientId, 2);
        expect(ingredients[1].name, 'Ingredient 2');
      });

      test('ingredientListToJson converts list to JSON string', () {
        final ingredients = [
          Ingredient(ingredientId: 1, name: 'Ingredient 1'),
          Ingredient(ingredientId: 2, name: 'Ingredient 2'),
        ];

        final jsonString = ingredientListToJson(ingredients);

        expect(jsonString, contains('"ingredient_id":1'));
        expect(jsonString, contains('"name":"Ingredient 1"'));
        expect(jsonString, contains('"ingredient_id":2'));
        expect(jsonString, contains('"name":"Ingredient 2"'));
      });
    });

    group('Real-World Ingredient Examples', () {
      test('creates realistic soybean meal ingredient', () {
        final soybeanMeal = Ingredient(
          ingredientId: 1,
          name: 'Soybean Meal, 44% CP',
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
          categoryId: 1,
          isCustom: 0,
        );

        expect(soybeanMeal.crudeProtein, 44.0);
        expect(soybeanMeal.lysine, 27.0);
      });

      test('creates realistic corn ingredient', () {
        final corn = Ingredient(
          ingredientId: 2,
          name: 'Corn, Yellow',
          crudeProtein: 8.5,
          crudeFiber: 2.2,
          crudeFat: 3.9,
          calcium: 0.3,
          phosphorus: 2.8,
          lysine: 2.5,
          methionine: 1.8,
          meGrowingPig: 3420.0,
          meAdultPig: 3560.0,
          mePoultry: 3350.0,
          meRuminant: 3190.0,
          categoryId: 2,
          isCustom: 0,
        );

        expect(corn.crudeProtein, 8.5);
        expect(corn.mePoultry, 3350.0);
      });

      test('creates custom ingredient', () {
        final customIngredient = Ingredient(
          ingredientId: 100,
          name: 'My Custom Mix',
          crudeProtein: 25.0,
          crudeFiber: 5.0,
          crudeFat: 10.0,
          priceKg: 500.0,
          availableQty: 100.0,
          isCustom: 1,
          createdBy: 'farmer123',
          createdDate: DateTime.now().millisecondsSinceEpoch,
          notes: 'Special blend for my farm',
        );

        expect(customIngredient.isCustom, 1);
        expect(customIngredient.createdBy, 'farmer123');
        expect(customIngredient.notes, 'Special blend for my farm');
      });
    });
  });
}

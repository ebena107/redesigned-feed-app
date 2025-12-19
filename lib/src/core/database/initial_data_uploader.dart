import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:flutter/services.dart';

Future<String> _loadIngredientDataAssets() async {
  return await rootBundle.loadString('assets/raw/initial_ingredients_.json');
}

Future<String> _loadAnimalTypesAssets() async {
  return await rootBundle.loadString('assets/raw/initial_animal_types.json');
}

Future<String> _loadCategoryAssets() async {
  return await rootBundle.loadString('assets/raw/initial_categories.json');
}

Future<List<AnimalTypes>> loadAnimalTypeJson() async {
  String jsonAnimalType = await _loadAnimalTypesAssets();
  List<AnimalTypes> res = animalTypeListFromJson(jsonAnimalType);
  return res;
}

Future<List<IngredientCategory>> loadCategoryJson() async {
  String jsonCat = await _loadCategoryAssets();
  List<IngredientCategory> res = ingredientCategoryListFromJson(jsonCat);
  return res;
}

Future<List<Ingredient>> loadIngredientJson() async {
  String jsonIngredient = await _loadIngredientDataAssets();
  List<Ingredient> res = ingredientListFromJson(jsonIngredient);
  res = res.map((e) => e.copyWith(favourite: 0)).toList();
  return res;
}

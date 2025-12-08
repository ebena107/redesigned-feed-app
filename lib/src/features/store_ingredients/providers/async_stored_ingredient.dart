import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';

import 'package:flutter/cupertino.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_stored_ingredient.g.dart';

@riverpod
class AsyncStoredIngredients extends _$AsyncStoredIngredients {
  Future<List<Ingredient>> loadIngredient() async {
    ref.watch(storeIngredientProvider.notifier).loadIngredients();
    return ref.watch(ingredientsRepository).getAll();
  }

  @override
  FutureOr<List<Ingredient>> build() async {
    return loadIngredient();
  }

  Future<void> deleteIngredient(num? ingredientId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .watch(ingredientProvider.notifier)
          .deleteIngredient(ingredientId);
      ref.watch(storeIngredientProvider.notifier).reset();
      return loadIngredient();
    });
  }

  Future<void> saveIngredient({
    required VoidCallback onSuccess,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ing = ref.watch(storeIngredientProvider).selectedIngredient;

      await ref
          .watch(ingredientsRepository)
          .update(ing!.toJson(), ing.ingredientId as num);
      // await ref.watch(storeIngredientProvider.notifier).reset();
      return [];
    });

    if (state.hasError == false) {
      loadIngredient();
    }
  }
}
//
// @riverpod
// final priceEditingController = Provider.autoDispose<TextEditingController>((PriceEditingControllerRef ref) {
//   var price = ref.watch(storeIngredientProvider).selectedIngredient!.priceKg;
//   price = price ?? 0;
//   return TextEditingController(text:price.toString());
// });

@riverpod
String quantityController(dynamic ref) {
  var qty = ref.watch(storeIngredientProvider).selectedIngredient!.availableQty;
  qty = qty ?? 0;
  return qty.toString();
}

@riverpod
GlobalKey<FormState> storedIngredientFormKey(dynamic ref) {
  return GlobalKey<FormState>();
}

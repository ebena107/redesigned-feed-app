import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_stored_ingredient.g.dart';

@riverpod
class AsyncStoredIngredients extends _$AsyncStoredIngredients {
  Future<List<Ingredient>> loadIngredient() async {
    return ref.watch(ingredientsRepository).getAll();
  }

  @override
  FutureOr<List<Ingredient>> build() async {
    return loadIngredient();
  }

  Future<void> deleteIngredient(num? ingredientId) async {
    if (ingredientId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .watch(ingredientProvider.notifier)
          .deleteIngredient(ingredientId);
      await ref.watch(storeIngredientProvider.notifier).reset();
      return loadIngredient();
    });
  }

  Future<void> saveIngredient({
    VoidCallback? onSuccess,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ing = ref.watch(storeIngredientProvider).selectedIngredient;

      if (ing == null) return [];

      await ref
          .watch(ingredientsRepository)
          .update(ing.toJson(), ing.ingredientId as num);

      return loadIngredient();
    });

    if (state.hasError == false) {
      onSuccess?.call();
    }
  }
}

@riverpod
String quantityController(Ref ref) {
  var qty = ref.watch(storeIngredientProvider).selectedIngredient?.availableQty;
  qty = qty ?? 0;
  return qty.toString();
}

@riverpod
GlobalKey<FormState> storedIngredientFormKey(Ref ref) {
  return GlobalKey<FormState>();
}

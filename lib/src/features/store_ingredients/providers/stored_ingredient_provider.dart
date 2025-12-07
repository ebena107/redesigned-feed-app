import 'package:feed_estimator/src/core/models/validation_model.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stored_ingredient_provider.freezed.dart';

final storeIngredientProvider =
    NotifierProvider<StoreIngredientNotifier, StoreIngredientState>(
        StoreIngredientNotifier.new);

@freezed
class StoreIngredientState with _$StoreIngredientState {
  const factory StoreIngredientState({
    @Default([]) List<Ingredient> ingredients,
    Ingredient? selectedIngredient,
    @Default(false) bool validate,
    @Default(0) num id,
    @Default(0) num priceKg,
    @Default(0) num availableQty,
    @Default(0) num favourite,
    @Default("") String status,
    @Default("") String message,
  }) = _StoreIngredientState;

  const StoreIngredientState._();
}

class StoreIngredientNotifier extends Notifier<StoreIngredientState> {
  @override
  StoreIngredientState build() {
    loadIngredients();
    return const StoreIngredientState();
  }

  reset() {
    state = state.copyWith(
      selectedIngredient: Ingredient(),
      id: 0,
      priceKg: 0,
      availableQty: 0,
      favourite: 0,
    );
  }

  loadIngredients() async {
    final ingList = await ref.watch(ingredientsRepository).getAll();

    state = state.copyWith(ingredients: ingList);
  }

  setIngredient(num? id) async {
    final ing = state.ingredients
        .firstWhere((e) => e.ingredientId == id, orElse: () => Ingredient());
    if (ing != Ingredient()) {
      state = state.copyWith(
          selectedIngredient: ing,
          priceKg: ing.priceKg as num,
          availableQty: ing.availableQty as num,
          favourite: ing.favourite as num);
    }
  }

  setPrice(String? value) {
    if (value!.isValidNumber && state.selectedIngredient != Ingredient()) {
      final ing = state.selectedIngredient!
          .copyWith(priceKg: double.tryParse(value) as num);
      state = state.copyWith(
          priceKg: double.tryParse(value) as num, selectedIngredient: ing);
    }
  }

  setAvailableQuantity(String? value) {
    if (value!.isValidNumber && state.selectedIngredient != Ingredient()) {
      final ing = state.selectedIngredient!
          .copyWith(availableQty: double.tryParse(value) as num);
      state = state.copyWith(
          availableQty: double.tryParse(value) as num, selectedIngredient: ing);
    }
  }

  void setFavourite(bool? value) {
    state = state.copyWith(favourite: value == true ? 1 : 0);
    final ing = state.selectedIngredient!.copyWith(favourite: state.favourite);
    state = state.copyWith(selectedIngredient: ing);
  }

  void deleteIngredient() {}

  Future<void> save() async {
    if (state.selectedIngredient != Ingredient()) {
      try {
        await ref.watch(ingredientsRepository).update(
            state.selectedIngredient!.toJson(),
            state.selectedIngredient!.ingredientId as num);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> update() async {
    if (state.selectedIngredient != Ingredient()) {
      await ref
          .read(ingredientProvider.notifier)
          .setIngredient(state.selectedIngredient!.ingredientId);
      // ref.read(routerProvider).goNamed(
      //   "newIngredient",
      //   queryParameters: {
      //     'id': state.selectedIngredient!.ingredientId.toString(),
      //   },
      // );
    }
  }
}

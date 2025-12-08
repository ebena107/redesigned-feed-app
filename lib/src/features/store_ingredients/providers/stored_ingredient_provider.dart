import 'package:feed_estimator/src/core/models/validation_model.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeIngredientProvider =
    NotifierProvider<StoreIngredientNotifier, StoreIngredientState>(() {
  return StoreIngredientNotifier();
});

sealed class StoreIngredientState {
  const StoreIngredientState();

  StoreIngredientState copyWith({
    List<Ingredient>? ingredients,
    Ingredient? selectedIngredient,
    bool? validate,
    num? id,
    num? priceKg,
    num? availableQty,
    num? favourite,
    String? status,
    String? message,
    num? selectedCategoryId,
    List<Ingredient>? filteredIngredients,
  }) {
    return _StoreIngredientState(
      ingredients: ingredients ?? this.ingredients,
      selectedIngredient: selectedIngredient ?? this.selectedIngredient,
      validate: validate ?? this.validate,
      id: id ?? this.id,
      priceKg: priceKg ?? this.priceKg,
      availableQty: availableQty ?? this.availableQty,
      favourite: favourite ?? this.favourite,
      status: status ?? this.status,
      message: message ?? this.message,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      filteredIngredients: filteredIngredients ?? this.filteredIngredients,
    );
  }

  List<Ingredient> get ingredients;
  Ingredient? get selectedIngredient;
  bool get validate;
  num get id;
  num get priceKg;
  num get availableQty;
  num get favourite;
  String get status;
  String get message;
  num? get selectedCategoryId;
  List<Ingredient> get filteredIngredients;
}

class _StoreIngredientState extends StoreIngredientState {
  const _StoreIngredientState({
    this.ingredients = const [],
    this.selectedIngredient,
    this.validate = false,
    this.id = 0,
    this.priceKg = 0,
    this.availableQty = 0,
    this.favourite = 0,
    this.status = "",
    this.message = "",
    this.selectedCategoryId,
    this.filteredIngredients = const [],
  });

  @override
  final List<Ingredient> ingredients;
  @override
  final Ingredient? selectedIngredient;
  @override
  final bool validate;
  @override
  final num id;
  @override
  final num priceKg;
  @override
  final num availableQty;
  @override
  final num favourite;
  @override
  final String status;
  @override
  final String message;
  @override
  final num? selectedCategoryId;
  @override
  final List<Ingredient> filteredIngredients;
}

class StoreIngredientNotifier extends Notifier<StoreIngredientState> {
  @override
  StoreIngredientState build() {
    loadIngredients();
    return const _StoreIngredientState();
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
    state = state.copyWith(
      ingredients: ingList,
      filteredIngredients: ingList,
      selectedCategoryId: null,
    );
  }

  setIngredient(num? id) async {
    final source = state.selectedCategoryId == null
        ? state.ingredients
        : state.filteredIngredients;
    final ing = source.firstWhere((e) => e.ingredientId == id,
        orElse: () => Ingredient());
    if (ing != Ingredient()) {
      state = state.copyWith(
          selectedIngredient: ing,
          priceKg: ing.priceKg as num,
          availableQty: ing.availableQty as num,
          favourite: ing.favourite as num);
    }
  }

  setCategory(num? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(
        selectedCategoryId: null,
        filteredIngredients: state.ingredients,
      );
    } else {
      final filtered = state.ingredients
          .where((ing) => ing.categoryId == categoryId)
          .toList();
      state = state.copyWith(
        selectedCategoryId: categoryId,
        filteredIngredients: filtered,
      );
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

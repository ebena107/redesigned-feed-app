import 'package:feed_estimator/src/core/models/validation_model.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredients_provider.freezed.dart';

final ingredientProvider =
    NotifierProvider<IngredientNotifier, IngredientState>(
        IngredientNotifier.new);

// ignore: use_to_and_then
@freezed
class IngredientState with _$IngredientState {
  const factory IngredientState({
    @Default([]) List<Ingredient> ingredients,
    @Default([]) List<IngredientCategory> categoryList,
    @Default([]) List<Ingredient> filteredIngredients,
    @Default([]) List<FeedIngredients> selectedIngredients,
    @Default(0) count,
    @Default(false) bool search,
    @Default(false) bool sort,
    @Default(true) bool showSearch,
    @Default(true) bool showSort,
    @Default("") String query,
    num? sortByCategory,

    //@Default(false) bool filter,
    @Default(false) bool validate,
    Ingredient? newIngredient,
    @Default(false) bool singleEnergyValue,
    ValidationModel? name,
    ValidationModel? crudeProtein,
    ValidationModel? crudeFiber,
    ValidationModel? crudeFat,
    ValidationModel? calcium,
    ValidationModel? phosphorus,
    ValidationModel? lysine,
    ValidationModel? methionine,
    ValidationModel? meGrowingPig,
    ValidationModel? meAdultPig,
    ValidationModel? mePoultry,
    ValidationModel? meRuminant,
    ValidationModel? meRabbit,
    ValidationModel? deSalmonids,
    ValidationModel? priceKg,
    ValidationModel? availableQty,
    ValidationModel? categoryId,
    @Default(0) num favourite,
    @Default("") String status,
    @Default("") String message,
  }) = _IngredientState;

  const IngredientState._();
}

class IngredientNotifier extends Notifier<IngredientState> {
  @override
  IngredientState build() {
    loadIngredients();
    loadCategories();
    setDefaultValues();
    return const IngredientState();
  }

  Future<void> loadIngredients() async {
    final ingList = await ref.watch(ingredientsRepository).getAll();

    state = state.copyWith(ingredients: ingList);
    searchIngredients("");
  }

  Future<void> loadCategories() async {
    final catList = await ref.watch(ingredientsCategoryRepository).getAll();

    state = state.copyWith(categoryList: catList);
  }

  void searchIngredients(String val) {
    state = state.copyWith(query: val);
    final query = state.query;

    if (state.query.isNotEmpty) {
      final list = state.ingredients
          .where((e) => e.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredIngredients: list);
    } else {
      state = state.copyWith(filteredIngredients: state.ingredients);
    }
  }

  void toggleSearch() {
    if (state.search == false) {
      if (state.sort == false) {
        state = state.copyWith(showSearch: true, showSort: false, search: true);
      }
      state = state.copyWith(
          showSearch: true, showSort: false, sort: false, search: true);
    } else {
      if (state.sort == false) {
        state = state.copyWith(showSearch: true, showSort: true, search: false);
      }
      state = state.copyWith(
          showSearch: true, showSort: true, sort: false, search: false);
      // state = state.copyWith(search: !state.search);
    }
  }

  void clearSearch() {
    state = state.copyWith(query: "");
//    state = state.copyWith(search: false);
    toggleSearch();
    searchIngredients("");
  }

  void sortIngredientByCat(num? categoryId) {
    state = state.copyWith(sortByCategory: categoryId);
    if (state.sort) {
      final list =
          state.ingredients.where((e) => e.categoryId! == categoryId).toList();
      state = state.copyWith(filteredIngredients: list);
    } else {
      state = state.copyWith(filteredIngredients: state.ingredients);
    }
  }

  void clearSort() {
    state = state.copyWith(
        filteredIngredients: state.ingredients, sortByCategory: null);
    toggleSort();
  }

  void toggleSort() {
    if (state.sort == false) {
      if (state.search == false) {
        state = state.copyWith(showSearch: false, showSort: true, sort: true);
      }
      state = state.copyWith(
          showSearch: false, showSort: true, sort: true, search: false);
    } else {
      if (state.search == false) {
        state = state.copyWith(showSearch: true, showSort: true, sort: false);
      }
      state = state.copyWith(
          showSearch: true, showSort: true, sort: false, search: false);
      // state = state.copyWith(search: !state.search);
    }
  }

  void resetSelections() {
    state = state.copyWith(selectedIngredients: []);
    updateCount();
  }

  String getName(int ingredientId) {
    final ing =
        state.ingredients.firstWhere((e) => e.ingredientId == ingredientId);
    return ing.name.toString();
  }

  void updateCount() {
    state = state.copyWith(count: state.selectedIngredients.length);
  }

  void removeSelected(Ingredient i) {
    List<FeedIngredients> feedIngredients = state.selectedIngredients;
    if (available(i)) {
      var newList = [
        for (final b in feedIngredients)
          if (b.ingredientId != i.ingredientId) b
      ];
      feedIngredients = newList;
    }
    state = state.copyWith(selectedIngredients: feedIngredients);
    //  updateCount();
  }

  void loadFeedExistingIngredients() {
    final feedIngList = ref.watch(feedProvider).feedIngredients;
    for (var i in feedIngList) {
      final ing =
          state.ingredients.firstWhere((e) => e.ingredientId == i.ingredientId);
      addSelectedIngredient(ing);
    }
  }

  void addSelectedIngredient(
    Ingredient ing,
  ) {
    if (!available(ing)) {
      FeedIngredients x = FeedIngredients(
        ingredientId: ing.ingredientId as int,
        priceUnitKg: ing.priceKg as double,
      );

      state = state
          .copyWith(selectedIngredients: [...state.selectedIngredients, x]);
    }

    updateCount();
  }

  bool available(Ingredient i) {
    bool avail = false;
    if (state.selectedIngredients.isNotEmpty) {
      avail = state.selectedIngredients
          .any((e) => e.ingredientId == i.ingredientId);
    }
    return avail;
  }

  void selectIngredient(Ingredient i) {
    if (available(i)) {
      removeSelected(i);
    } else {
      addSelectedIngredient(i);
    }
    updateCount();
  }

  Future<void> removeSelectedById(num? ingredientId) async {
    List<FeedIngredients> feedIngredients = state.selectedIngredients;

    var newList = [
      for (final b in feedIngredients)
        if (b.ingredientId != ingredientId) b
    ];
    feedIngredients = newList;

    state = state.copyWith(selectedIngredients: feedIngredients);

    await ref.watch(feedIngredientRepository).delete(ingredientId!);

    updateCount();
    final count = state.count;
    state = state.copyWith(count: count);
  }

  void setDefaultValues() {
    state = state.copyWith(
      newIngredient: Ingredient(),
      name: ValidationModel(value: null, error: null, isValid: false),
      crudeProtein: ValidationModel(value: null, error: null, isValid: false),
      crudeFiber: ValidationModel(value: null, error: null, isValid: false),
      crudeFat: ValidationModel(value: null, error: null, isValid: false),
      calcium: ValidationModel(value: null, error: null, isValid: false),
      phosphorus: ValidationModel(value: null, error: null, isValid: false),
      lysine: ValidationModel(value: null, error: null, isValid: false),
      methionine: ValidationModel(value: null, error: null, isValid: false),
      meGrowingPig: ValidationModel(value: null, error: null, isValid: false),
      meAdultPig: ValidationModel(value: null, error: null, isValid: false),
      mePoultry: ValidationModel(value: null, error: null, isValid: false),
      meRuminant: ValidationModel(value: null, error: null, isValid: false),
      meRabbit: ValidationModel(value: null, error: null, isValid: false),
      deSalmonids: ValidationModel(value: null, error: null, isValid: false),
      priceKg: ValidationModel(value: null, error: null, isValid: false),
      availableQty: ValidationModel(value: null, error: null, isValid: false),
      categoryId: ValidationModel(value: null, error: null, isValid: false),
    );
  }

  void selectEnergyMode(bool? value) {
    state = state.copyWith(singleEnergyValue: value!);
  }

  void setAllEnergy(String? value) {
    value!.isValidNumber
        ? state = state.copyWith(
            meGrowingPig:
                ValidationModel(value: value, error: null, isValid: true),
            meAdultPig:
                ValidationModel(value: value, error: null, isValid: true),
            mePoultry:
                ValidationModel(value: value, error: null, isValid: true),
            meRuminant:
                ValidationModel(value: value, error: null, isValid: true),
            meRabbit: ValidationModel(value: value, error: null, isValid: true),
            deSalmonids:
                ValidationModel(value: value, error: null, isValid: true),
          )
        : state = state.copyWith(
            meGrowingPig: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
            meAdultPig: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
            mePoultry: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
            meRuminant: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
            meRabbit: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
            deSalmonids: ValidationModel(
                value: null, error: 'Value is required', isValid: false),
          );
  }

  void setName(String? value) {
    if (value!.length > 2) {
      if (state.newIngredient!.ingredientId != null) {
        final ing = state.newIngredient!.copyWith(name: value);
        state = state.copyWith(
            name: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
          name: ValidationModel(value: value, error: null, isValid: true),
        );
      }
    } else {
      state = state.copyWith(
          name: ValidationModel(
              value: null,
              error: 'Name must not be empty and without signs',
              isValid: false));
    }
  }

  void setProtein(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(crudeProtein: double.tryParse(value));
        state = state.copyWith(
            crudeProtein:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            crudeProtein:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          crudeProtein: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setFat(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(crudeFat: double.tryParse(value));
        state = state.copyWith(
            crudeFat: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            crudeFat:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          crudeFat: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setFiber(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(crudeFiber: double.tryParse(value));
        state = state.copyWith(
            crudeFiber:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            crudeFiber:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          crudeFiber: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyAdultPig(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(meAdultPig: int.tryParse(value));
        state = state.copyWith(
            meAdultPig:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            meAdultPig:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          meAdultPig: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyGrowPig(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(meGrowingPig: int.tryParse(value));
        state = state.copyWith(
            meGrowingPig:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            meGrowingPig:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          meGrowingPig: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyRabbit(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(meRabbit: int.tryParse(value));
        state = state.copyWith(
            meRabbit: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            meRabbit:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          meRabbit: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyRuminant(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(meRuminant: int.tryParse(value));
        state = state.copyWith(
            meRuminant:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            meRuminant:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          meRuminant: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyPoultry(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(mePoultry: int.tryParse(value));
        state = state.copyWith(
            mePoultry:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            mePoultry:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          mePoultry: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setEnergyFish(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(deSalmonids: int.tryParse(value));
        state = state.copyWith(
            deSalmonids:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            deSalmonids:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          deSalmonids: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setLyzine(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(lysine: double.tryParse(value));
        state = state.copyWith(
            lysine: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            lysine: ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          lysine: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setMeth(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(methionine: double.tryParse(value));
        state = state.copyWith(
            methionine:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            methionine:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          methionine: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setCalcium(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(calcium: double.tryParse(value));
        state = state.copyWith(
            calcium: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            calcium: ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          calcium: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setPhosphorous(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(phosphorus: double.tryParse(value));
        state = state.copyWith(
            phosphorus:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            phosphorus:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          phosphorus: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setPrice(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(priceKg: double.tryParse(value));
        state = state.copyWith(
            priceKg: ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            priceKg: ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          priceKg: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setAvailableQuantity(String? value) {
    if (value!.isNotEmpty && value.isValidNumber) {
      if (state.newIngredient!.ingredientId != null) {
        final ing =
            state.newIngredient!.copyWith(availableQty: double.tryParse(value));
        state = state.copyWith(
            availableQty:
                ValidationModel(value: value, error: null, isValid: true),
            newIngredient: ing);
      } else {
        state = state.copyWith(
            availableQty:
                ValidationModel(value: value, error: null, isValid: true));
      }
    } else {
      state = state.copyWith(
          availableQty: ValidationModel(
              value: null, error: 'Value is required', isValid: false));
    }
  }

  void setCategory(String value) {
    if (value.isValidNumber) {
      final myCat = state.categoryList.firstWhere(
          (c) => c.categoryId == int.parse(value),
          orElse: () => IngredientCategory());
      if (myCat != IngredientCategory()) {
        if (state.newIngredient!.ingredientId != null) {
          final ing =
              state.newIngredient!.copyWith(categoryId: int.tryParse(value));
          state = state.copyWith(
              categoryId:
                  ValidationModel(value: value, error: null, isValid: true),
              newIngredient: ing);
        } else {
          state = state.copyWith(
              categoryId:
                  ValidationModel(value: value, error: null, isValid: true));
        }
      } else {
        state = state.copyWith(
            categoryId: ValidationModel(
                value: null,
                error: 'Selected Category does not Exist',
                isValid: false));
      }
    } else {
      state = state.copyWith(
          categoryId: ValidationModel(
              value: null, error: 'Category is required', isValid: false));
    }
  }

  void validate() {
    if (state.name!.value != null &&
        state.crudeProtein!.value != null &&
        state.crudeFiber!.value != null &&
        state.crudeFat!.value != null &&
        state.calcium!.value != null &&
        state.phosphorus!.value != null &&
        state.lysine!.value != null &&
        state.methionine!.value != null &&
        state.meGrowingPig!.value != null &&
        state.meAdultPig!.value != null &&
        state.mePoultry!.value != null &&
        state.meRuminant!.value != null &&
        state.meRabbit!.value != null &&
        state.deSalmonids!.value != null &&
        state.priceKg!.value != null &&
        state.availableQty!.value != null &&
        state.categoryId!.value != null) {
      state = state.copyWith(validate: true);
    } else {
      state = state.copyWith(validate: false);
    }
  }

  void createIngredient() {
    Ingredient newIngredient = Ingredient();
    validate();
    if (state.validate) {
      final now = DateTime.now().millisecondsSinceEpoch;
      newIngredient = newIngredient.copyWith(
        name: state.name!.value,
        crudeProtein: double.tryParse(state.crudeProtein!.value.toString()),
        meGrowingPig: int.tryParse(state.meGrowingPig!.value.toString()),
        meAdultPig: int.tryParse(state.meAdultPig!.value.toString()),
        mePoultry: int.tryParse(state.mePoultry!.value.toString()),
        meRuminant: int.tryParse(state.meRuminant!.value.toString()),
        meRabbit: int.tryParse(state.meRabbit!.value.toString()),
        deSalmonids: int.tryParse(state.deSalmonids!.value.toString()),
        crudeFat: double.tryParse(state.crudeFat!.value.toString()),
        crudeFiber: double.tryParse(state.crudeFiber!.value.toString()),
        calcium: double.tryParse(state.calcium!.value.toString()),
        phosphorus: double.tryParse(state.phosphorus!.value.toString()),
        lysine: double.tryParse(state.lysine!.value.toString()),
        methionine: double.tryParse(state.methionine!.value.toString()),
        priceKg: double.tryParse(state.priceKg!.value.toString()),
        availableQty: double.tryParse(state.availableQty!.value.toString()),
        categoryId: int.tryParse(state.categoryId!.value.toString()),
        favourite: state.favourite,
        isCustom: 1, // Mark as custom ingredient
        createdDate: now, // Set creation timestamp
      );
      state = state.copyWith(newIngredient: newIngredient);
    }
  }

  Future<void> updateIngredient(
    int? ingId, {
    required VoidCallback? onSuccess,
    required VoidCallback? onFailure,
  }) async {
    int? response;
    try {
      if (state.newIngredient != Ingredient()) {
        response = await ref
            .read(ingredientsRepository)
            .update(state.newIngredient!.toJson(), ingId as num);
      }
    } catch (e) {
      return onFailure!();
    }

    if (response!.isNaN) {
      return onFailure!();
    } else {
      return onSuccess!();
    }
  }

  Future<void> saveIngredient({
    required VoidCallback? onSuccess,
    required VoidCallback onFailure,
  }) async {
    createIngredient();
    int? response;
    try {
      if (state.newIngredient != Ingredient()) {
        response = await ref
            .read(ingredientsRepository)
            .create(state.newIngredient!.toJson());
      }
    } catch (e) {
      return onFailure();
    }

    if (response!.isNaN) {
      return onFailure();
    } else {
      return onSuccess!();
    }
  }

  Future<void> setIngredient(num? ingredientId) async {
    await loadIngredients();

    final ingredient = state.ingredients.firstWhere(
        (i) => i.ingredientId == ingredientId,
        orElse: () => Ingredient());
    if (ingredient != Ingredient()) {
      state =
          state.copyWith(singleEnergyValue: true, newIngredient: ingredient);

      setName(ingredient.name.toString());
      setPrice(ingredient.priceKg.toString());
      setAvailableQuantity(ingredient.availableQty.toString());
      setCalcium(ingredient.calcium.toString());
      setPhosphorous(ingredient.phosphorus.toString());
      setMeth(ingredient.methionine.toString());
      setLyzine(ingredient.lysine.toString());
      setEnergyFish(ingredient.deSalmonids.toString());
      setEnergyPoultry(ingredient.mePoultry.toString());
      setEnergyRabbit(ingredient.meRabbit.toString());
      setEnergyRuminant(ingredient.meRuminant.toString());
      setEnergyGrowPig(ingredient.meGrowingPig.toString());
      setEnergyAdultPig(ingredient.meAdultPig.toString());
      setFat(ingredient.crudeFat.toString());
      setFiber(ingredient.crudeFiber.toString());
      setProtein(ingredient.crudeProtein.toString());
      setCategory(ingredient.categoryId.toString());
      //  setName(ingredient.name.toString());
    }
  }

  Future<void> deleteIngredient(num? ingredientId) async {
    await ref.watch(ingredientsRepository).delete(ingredientId!);

    await loadIngredients();
  }
}

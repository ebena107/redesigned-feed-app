import 'package:feed_estimator/src/core/models/validation_model.dart';
import 'package:feed_estimator/src/core/services/data_import_service.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final ingredientProvider =
    NotifierProvider<IngredientNotifier, IngredientState>(() {
  return IngredientNotifier();
});

sealed class IngredientState {
  const IngredientState();

  IngredientState copyWith({
    List<Ingredient>? ingredients,
    List<IngredientCategory>? categoryList,
    List<Ingredient>? filteredIngredients,
    List<FeedIngredients>? selectedIngredients,
    int? count,
    bool? search,
    bool? sort,
    bool? showSearch,
    bool? showSort,
    String? query,
    num? sortByCategory,
    bool? validate,
    Ingredient? newIngredient,
    bool? singleEnergyValue,
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
    ValidationModel? createdBy,
    ValidationModel? notes,
    num? favourite,
    String? status,
    String? message,
  }) {
    return _IngredientState(
      ingredients: ingredients ?? this.ingredients,
      categoryList: categoryList ?? this.categoryList,
      filteredIngredients: filteredIngredients ?? this.filteredIngredients,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      count: count ?? this.count,
      search: search ?? this.search,
      sort: sort ?? this.sort,
      showSearch: showSearch ?? this.showSearch,
      showSort: showSort ?? this.showSort,
      query: query ?? this.query,
      sortByCategory: sortByCategory ?? this.sortByCategory,
      validate: validate ?? this.validate,
      newIngredient: newIngredient ?? this.newIngredient,
      singleEnergyValue: singleEnergyValue ?? this.singleEnergyValue,
      name: name ?? this.name,
      crudeProtein: crudeProtein ?? this.crudeProtein,
      crudeFiber: crudeFiber ?? this.crudeFiber,
      crudeFat: crudeFat ?? this.crudeFat,
      calcium: calcium ?? this.calcium,
      phosphorus: phosphorus ?? this.phosphorus,
      lysine: lysine ?? this.lysine,
      methionine: methionine ?? this.methionine,
      meGrowingPig: meGrowingPig ?? this.meGrowingPig,
      meAdultPig: meAdultPig ?? this.meAdultPig,
      mePoultry: mePoultry ?? this.mePoultry,
      meRuminant: meRuminant ?? this.meRuminant,
      meRabbit: meRabbit ?? this.meRabbit,
      deSalmonids: deSalmonids ?? this.deSalmonids,
      priceKg: priceKg ?? this.priceKg,
      availableQty: availableQty ?? this.availableQty,
      categoryId: categoryId ?? this.categoryId,
      createdBy: createdBy ?? this.createdBy,
      notes: notes ?? this.notes,
      favourite: favourite ?? this.favourite,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  List<Ingredient> get ingredients;
  List<IngredientCategory> get categoryList;
  List<Ingredient> get filteredIngredients;
  List<FeedIngredients> get selectedIngredients;
  int get count;
  bool get search;
  bool get sort;
  bool get showSearch;
  bool get showSort;
  String get query;
  num? get sortByCategory;
  bool get validate;
  Ingredient? get newIngredient;
  bool get singleEnergyValue;
  ValidationModel? get name;
  ValidationModel? get crudeProtein;
  ValidationModel? get crudeFiber;
  ValidationModel? get crudeFat;
  ValidationModel? get calcium;
  ValidationModel? get phosphorus;
  ValidationModel? get lysine;
  ValidationModel? get methionine;
  ValidationModel? get meGrowingPig;
  ValidationModel? get meAdultPig;
  ValidationModel? get mePoultry;
  ValidationModel? get meRuminant;
  ValidationModel? get meRabbit;
  ValidationModel? get deSalmonids;
  ValidationModel? get priceKg;
  ValidationModel? get availableQty;
  ValidationModel? get categoryId;
  ValidationModel? get createdBy;
  ValidationModel? get notes;
  num get favourite;
  String get status;
  String get message;
}

class _IngredientState extends IngredientState {
  const _IngredientState({
    this.ingredients = const [],
    this.categoryList = const [],
    this.filteredIngredients = const [],
    this.selectedIngredients = const [],
    this.count = 0,
    this.search = false,
    this.sort = false,
    this.showSearch = true,
    this.showSort = true,
    this.query = "",
    this.sortByCategory,
    this.validate = false,
    this.newIngredient,
    this.singleEnergyValue = false,
    this.name,
    this.crudeProtein,
    this.crudeFiber,
    this.crudeFat,
    this.calcium,
    this.phosphorus,
    this.lysine,
    this.methionine,
    this.meGrowingPig,
    this.meAdultPig,
    this.mePoultry,
    this.meRuminant,
    this.meRabbit,
    this.deSalmonids,
    this.priceKg,
    this.availableQty,
    this.categoryId,
    this.createdBy,
    this.notes,
    this.favourite = 0,
    this.status = "",
    this.message = "",
  });

  @override
  final List<Ingredient> ingredients;
  @override
  final List<IngredientCategory> categoryList;
  @override
  final List<Ingredient> filteredIngredients;
  @override
  final List<FeedIngredients> selectedIngredients;
  @override
  final int count;
  @override
  final bool search;
  @override
  final bool sort;
  @override
  final bool showSearch;
  @override
  final bool showSort;
  @override
  final String query;
  @override
  final num? sortByCategory;
  @override
  final bool validate;
  @override
  final Ingredient? newIngredient;
  @override
  final bool singleEnergyValue;
  @override
  final ValidationModel? name;
  @override
  final ValidationModel? crudeProtein;
  @override
  final ValidationModel? crudeFiber;
  @override
  final ValidationModel? crudeFat;
  @override
  final ValidationModel? calcium;
  @override
  final ValidationModel? phosphorus;
  @override
  final ValidationModel? lysine;
  @override
  final ValidationModel? methionine;
  @override
  final ValidationModel? meGrowingPig;
  @override
  final ValidationModel? meAdultPig;
  @override
  final ValidationModel? mePoultry;
  @override
  final ValidationModel? meRuminant;
  @override
  final ValidationModel? meRabbit;
  @override
  final ValidationModel? deSalmonids;
  @override
  final ValidationModel? priceKg;
  @override
  final ValidationModel? availableQty;
  @override
  final ValidationModel? categoryId;
  @override
  final ValidationModel? createdBy;
  @override
  final ValidationModel? notes;
  @override
  final num favourite;
  @override
  final String status;
  @override
  final String message;
}

class IngredientNotifier extends Notifier<IngredientState> {
  @override
  IngredientState build() {
    // Initialize state first
    state = const _IngredientState();

    // Delay async loading to after first frame when state is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadIngredients();
      loadCategories();
    });

    // Set default values after state initialization
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
      createdBy: ValidationModel(value: 'User', error: null, isValid: true),
      notes: ValidationModel(value: '', error: null, isValid: true),
    );

    return state;
  }

  loadIngredients() async {
    try {
      // Check if ingredients need to be imported
      final importService = ref.read(dataImportService);
      final imported = await importService.importIngredients();

      if (imported > 0) {
        AppLogger.info(
          'Imported $imported ingredients on first launch',
          tag: 'IngredientNotifier',
        );
      }

      // Load ingredients from database
      final ingList = await ref.watch(ingredientsRepository).getAll();

      state = state.copyWith(ingredients: ingList);
      await searchIngredients("");
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load ingredients',
        tag: 'IngredientNotifier',
        error: e,
        stackTrace: stackTrace,
      );
      // Set empty list on error to prevent app crash
      state = state.copyWith(ingredients: []);
    }
  }

  Future<void> loadCategories() async {
    final catList = await ref.watch(ingredientsCategoryRepository).getAll();

    state = state.copyWith(categoryList: catList);
  }

  searchIngredients(String val) {
    state = state.copyWith(query: val);
    final query = state.query;

    if (state.query.isNotEmpty) {
      final list = state.ingredients
          .where((e) => e.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredIngredients: _applyRegionFilter(list));
    } else {
      state = state.copyWith(
          filteredIngredients: _applyRegionFilter(state.ingredients));
    }
  }

  toggleSearch() {
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

  clearSearch() {
    state = state.copyWith(query: "");
//    state = state.copyWith(search: false);
    toggleSearch();
    searchIngredients("");
  }

  sortIngredientByCat(num? categoryId) {
    state = state.copyWith(sortByCategory: categoryId);
    if (state.sort) {
      List<Ingredient> list;

      // Special case: -1 means favorites filter
      if (categoryId == -1) {
        list = state.ingredients.where((e) => e.favourite == 1).toList();
      } else if (categoryId != null) {
        list = state.ingredients
            .where((e) => e.categoryId! == categoryId)
            .toList();
      } else {
        list = state.ingredients;
      }

      state = state.copyWith(filteredIngredients: _applyRegionFilter(list));
    } else {
      state = state.copyWith(
          filteredIngredients: _applyRegionFilter(state.ingredients));
    }
  }

  clearSort() {
    state = state.copyWith(
        filteredIngredients: _applyRegionFilter(state.ingredients),
        sortByCategory: null);
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

  // =====================
  // Region Filtering
  // =====================
  String? _regionFilter; // null or 'All' means no filter

  void setRegionFilter(String? region) {
    // Normalize input
    if (region == null || region.isEmpty || region == 'All') {
      _regionFilter = null;
    } else {
      _regionFilter = region;
    }
    // Re-apply current filters (search/category) with region
    searchIngredients(state.query);
  }

  List<Ingredient> _applyRegionFilter(List<Ingredient> list) {
    if (_regionFilter == null) return list;
    final selected = _regionFilter!;
    return list.where((e) {
      // Untagged ingredients (null/empty region) are always included
      if (e.region == null || e.region!.isEmpty) {
        return true;
      }
      // Check if selected region is in comma-separated list
      final regions = e.region!.split(',').map((s) => s.trim()).toList();
      return regions.contains(selected) || regions.contains('Global');
    }).toList();
  }

  String getName(int ingredientId) {
    final ing =
        state.ingredients.firstWhere((e) => e.ingredientId == ingredientId);
    return ing.name.toString();
  }

  updateCount() {
    state = state.copyWith(count: state.selectedIngredients.length);
  }

  removeSelected(Ingredient i) {
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

  loadFeedExistingIngredients() {
    final feedIngList = ref.watch(feedProvider).feedIngredients;
    for (var i in feedIngList) {
      final ing =
          state.ingredients.firstWhere((e) => e.ingredientId == i.ingredientId);
      addSelectedIngredient(ing);
    }
  }

  addSelectedIngredient(
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

  selectIngredient(Ingredient i) {
    if (available(i)) {
      removeSelected(i);
    } else {
      addSelectedIngredient(i);
    }
    updateCount();
  }

  void removeSelectedIngredient(FeedIngredients ingredient) {
    List<FeedIngredients> feedIngredients = state.selectedIngredients;
    final newList = feedIngredients
        .where((item) => item.ingredientId != ingredient.ingredientId)
        .toList();
    state = state.copyWith(selectedIngredients: newList);
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
      createdBy: ValidationModel(value: 'User', error: null, isValid: true),
      notes: ValidationModel(value: '', error: null, isValid: true),
    );
  }

  selectEnergyMode(bool? value) {
    state = state.copyWith(singleEnergyValue: value!);
  }

  setAllEnergy(String? value) {
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

  setName(String? value) {
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

  setProtein(String? value) {
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

  setFat(String? value) {
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

  setFiber(String? value) {
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

  setEnergyAdultPig(String? value) {
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

  setEnergyGrowPig(String? value) {
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

  setEnergyRabbit(String? value) {
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

  setEnergyRuminant(String? value) {
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

  setEnergyPoultry(String? value) {
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

  setEnergyFish(String? value) {
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

  setLyzine(String? value) {
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

  setMeth(String? value) {
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

  setCalcium(String? value) {
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

  setPhosphorous(String? value) {
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

  setPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (state.newIngredient!.ingredientId != null) {
        final ing = state.newIngredient!.copyWith(priceKg: null);
        state = state.copyWith(
          priceKg: ValidationModel(value: null, error: null, isValid: true),
          newIngredient: ing,
        );
      } else {
        state = state.copyWith(
            priceKg: ValidationModel(value: null, error: null, isValid: true));
      }
      return;
    }

    if (value.isValidNumber) {
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

  setAvailableQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (state.newIngredient!.ingredientId != null) {
        final ing = state.newIngredient!.copyWith(availableQty: null);
        state = state.copyWith(
          availableQty:
              ValidationModel(value: null, error: null, isValid: true),
          newIngredient: ing,
        );
      } else {
        state = state.copyWith(
            availableQty:
                ValidationModel(value: null, error: null, isValid: true));
      }
      return;
    }

    if (value.isValidNumber) {
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

  setCreatedBy(String? value) {
    final trimmed = value?.trim() ?? '';
    final resolved = trimmed.isEmpty ? 'User' : trimmed;
    final updated = state.newIngredient?.copyWith(createdBy: resolved);
    state = state.copyWith(
      createdBy: ValidationModel(value: resolved, error: null, isValid: true),
      newIngredient: updated,
    );
  }

  setNotes(String? value) {
    final trimmed = value?.trim() ?? '';
    // Notes optional; always mark valid and store
    final updated = state.newIngredient?.copyWith(notes: trimmed);
    state = state.copyWith(
      notes: ValidationModel(value: trimmed, error: null, isValid: true),
      newIngredient: updated,
    );
  }

  setCategory(String value) {
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

  validate() {
    if (state.categoryId!.value == null) {
      state = state.copyWith(
          categoryId: ValidationModel(
              value: null, error: 'Category is required', isValid: false));
    }

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
        state.categoryId!.value != null) {
      state = state.copyWith(validate: true);
    } else {
      state = state.copyWith(validate: false);
    }
  }

  createIngredient() {
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
        createdBy: state.createdBy?.value?.toString() ?? 'User',
        notes: state.notes?.value?.toString() ?? '',
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
    await createIngredient();
    int? response;
    try {
      if (state.newIngredient != Ingredient()) {
        response = await ref
            .read(ingredientsRepository)
            .create(state.newIngredient!.toJson());
      }
    } catch (e) {
      AppLogger.error('Error saving ingredient: $e');
      return onFailure();
    }

    // Check if response is valid (> 0 means successful insert)
    if (response == null || response <= 0) {
      AppLogger.error('Failed to save ingredient: invalid response=$response');
      return onFailure();
    } else {
      // Refresh the ingredients list to show the new ingredient
      await loadIngredients();
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
      setCreatedBy(ingredient.createdBy?.toString());
      setNotes(ingredient.notes?.toString());
      //  setName(ingredient.name.toString());
    }
  }

  Future<void> deleteIngredient(num? ingredientId) async {
    await ref.watch(ingredientsRepository).delete(ingredientId!);

    await loadIngredients();
  }

  /// Copy an existing ingredient's values to create a new custom ingredient
  /// This pre-fills the form with all values from the source ingredient
  void copyFromIngredient(Ingredient sourceIngredient) {
    // Reset to default state first
    setDefaultValues();

    // Copy all nutritional values
    setName(sourceIngredient.name.toString());
    setCalcium(sourceIngredient.calcium.toString());
    setPhosphorous(sourceIngredient.phosphorus.toString());
    setMeth(sourceIngredient.methionine.toString());
    setLyzine(sourceIngredient.lysine.toString());
    setEnergyFish(sourceIngredient.deSalmonids.toString());
    setEnergyPoultry(sourceIngredient.mePoultry.toString());
    setEnergyRabbit(sourceIngredient.meRabbit.toString());
    setEnergyRuminant(sourceIngredient.meRuminant.toString());
    setEnergyGrowPig(sourceIngredient.meGrowingPig.toString());
    setEnergyAdultPig(sourceIngredient.meAdultPig.toString());
    setFat(sourceIngredient.crudeFat.toString());
    setFiber(sourceIngredient.crudeFiber.toString());
    setProtein(sourceIngredient.crudeProtein.toString());
    setCategory(sourceIngredient.categoryId.toString());

    // Optional fields - copy if present
    if (sourceIngredient.priceKg != null) {
      setPrice(sourceIngredient.priceKg.toString());
    }
    if (sourceIngredient.availableQty != null) {
      setAvailableQuantity(sourceIngredient.availableQty.toString());
    }

    // Set default createdBy to 'User' and empty notes for new custom ingredient
    setCreatedBy('User');
    setNotes('Copied from ${sourceIngredient.name}');

    // Mark as single energy value if was single
    state = state.copyWith(singleEnergyValue: false);
  }
}

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The Async Data Source (Single Source of Truth)
final ingredientsListProvider = FutureProvider<List<Ingredient>>((ref) async {
  return ref.watch(ingredientsRepository).getAll();
});

// 2. The View Model / Logic
final storeIngredientProvider =
    NotifierProvider<StoreIngredientNotifier, StoreIngredientState>(() {
  return StoreIngredientNotifier();
});

class StoreIngredientState {
  final Ingredient? selectedIngredient;
  final num? selectedCategoryId;
  final bool showFavoritesOnly;
  final bool showCustomOnly;
  final String searchQuery;
  final String? regionFilter; // New: region filter (null = All)

  // Form State (Draft changes)
  final num? draftPrice;
  final num? draftQty;
  final bool draftFavorite;

  const StoreIngredientState({
    this.selectedIngredient,
    this.selectedCategoryId,
    this.showFavoritesOnly = false,
    this.showCustomOnly = false,
    this.searchQuery = '',
    this.regionFilter,
    this.draftPrice,
    this.draftQty,
    this.draftFavorite = false,
  });

  StoreIngredientState copyWith({
    Ingredient? selectedIngredient,
    num? selectedCategoryId,
    bool? showFavoritesOnly,
    bool? showCustomOnly,
    String? searchQuery,
    String? regionFilter,
    num? draftPrice,
    num? draftQty,
    bool? draftFavorite,
    bool clearSelection = false,
  }) {
    return StoreIngredientState(
      selectedIngredient: clearSelection
          ? null
          : (selectedIngredient ?? this.selectedIngredient),
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      showCustomOnly: showCustomOnly ?? this.showCustomOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      regionFilter: regionFilter ?? this.regionFilter,
      draftPrice: draftPrice ?? this.draftPrice,
      draftQty: draftQty ?? this.draftQty,
      draftFavorite: draftFavorite ?? this.draftFavorite,
    );
  }

  bool get hasChanges {
    if (selectedIngredient == null) return false;
    return draftPrice != selectedIngredient?.priceKg ||
        draftQty != selectedIngredient?.availableQty ||
        (draftFavorite ? 1 : 0) != selectedIngredient?.favourite;
  }

  bool get isValid {
    return selectedIngredient != null &&
        draftPrice != null &&
        draftPrice! > 0 &&
        draftQty != null &&
        draftQty! >= 0;
  }
}

class StoreIngredientNotifier extends Notifier<StoreIngredientState> {
  @override
  StoreIngredientState build() {
    return const StoreIngredientState();
  }

  /// Selects an ingredient and initializes draft values
  void selectIngredient(Ingredient? ingredient) {
    if (ingredient == null) {
      state = state.copyWith(clearSelection: true);
    } else {
      // Reset draft state to match the selected ingredient
      state = StoreIngredientState(
        selectedIngredient: ingredient,
        draftPrice: ingredient.priceKg,
        draftQty: ingredient.availableQty,
        draftFavorite: ingredient.favourite == 1,
        // Keep filters
        selectedCategoryId: state.selectedCategoryId,
        showFavoritesOnly: state.showFavoritesOnly,
        showCustomOnly: state.showCustomOnly,
        searchQuery: state.searchQuery,
      );
    }
  }

  /// Updates the draft price value
  void updateDraftPrice(String value) {
    final numVal = num.tryParse(value);
    if (numVal != null && numVal >= 0) {
      state = state.copyWith(draftPrice: numVal);
    }
  }

  /// Updates the draft quantity value
  void updateDraftQty(String value) {
    final numVal = num.tryParse(value);
    if (numVal != null && numVal >= 0) {
      state = state.copyWith(draftQty: numVal);
    }
  }

  /// Toggles the draft favorite status
  void toggleDraftFavorite(bool value) {
    state = state.copyWith(draftFavorite: value);
  }

  /// Resets draft values to the original ingredient values
  void resetDraft() {
    if (state.selectedIngredient != null) {
      final ing = state.selectedIngredient!;
      state = state.copyWith(
        draftPrice: ing.priceKg,
        draftQty: ing.availableQty,
        draftFavorite: ing.favourite == 1,
      );
    }
  }

  /// Resets the entire state (clears selection and filters)
  Future<void> reset() async {
    state = const StoreIngredientState();
  }

  /// Clears all filters but keeps the selection
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategoryId: null,
      showFavoritesOnly: false,
      showCustomOnly: false,
      regionFilter: null,
    );
  }

  // Filter Management Methods

  /// Sets the search query filter
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim());
  }

  /// Sets the region filter
  void setRegionFilter(String? region) {
    state = state.copyWith(regionFilter: region == 'All' ? null : region);
  }

  /// Sets the category filter
  void setCategory(num? id) {
    state = state.copyWith(selectedCategoryId: id);
  }

  /// Toggles the favorites filter
  void toggleFavorites() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  /// Toggles the custom ingredients filter
  void toggleCustom() {
    state = state.copyWith(showCustomOnly: !state.showCustomOnly);
  }

  /// Applies region filter to an ingredient based on current state
  bool _matchesRegion(Ingredient ing) {
    // No filter or 'All' selected - include all ingredients
    if (state.regionFilter == null || state.regionFilter == 'All') {
      return true;
    }

    // Treat null/empty region as 'Global' (always included)
    if (ing.region == null || ing.region!.isEmpty) {
      return true; // Untagged ingredients are always shown
    }

    // Check if selected region is in comma-separated list
    final regions = ing.region!.split(',').map((r) => r.trim()).toList();
    final matched =
        regions.contains(state.regionFilter) || regions.contains('Global');

    // Debug logging
    if (!matched) {
      debugPrint(
          'Region filter: ing="${ing.name}" region="${ing.region}" filter="${state.regionFilter}" regions=$regions matched=$matched');
    }

    return matched;
  }

  /// Filters a list of ingredients based on current state
  List<Ingredient> filterList(List<Ingredient> source) {
    return source.where((ing) {
      // Search filter - matches ingredient name
      final matchesSearch = state.searchQuery.isEmpty ||
          (ing.name?.toLowerCase().contains(state.searchQuery.toLowerCase()) ??
              false);

      // Category filter
      final matchesCategory = state.selectedCategoryId == null ||
          ing.categoryId == state.selectedCategoryId;

      // Favorites filter
      final matchesFav = !state.showFavoritesOnly || ing.favourite == 1;

      // Custom ingredients filter
      final matchesCustom = !state.showCustomOnly || ing.isCustom == 1;

      // Region filter
      final matchesRegion = _matchesRegion(ing);

      return matchesSearch &&
          matchesCategory &&
          matchesFav &&
          matchesCustom &&
          matchesRegion;
    }).toList();
  }
}

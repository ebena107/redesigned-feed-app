import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing user-contributed (custom) ingredients
final userIngredientsProvider =
    NotifierProvider<UserIngredientsNotifier, UserIngredientsState>(() {
  return UserIngredientsNotifier();
});

sealed class UserIngredientsState {
  const UserIngredientsState();

  UserIngredientsState copyWith({
    List<Ingredient>? userIngredients,
    List<Ingredient>? filteredIngredients,
    String? searchQuery,
    String? status,
    String? message,
    bool? isLoading,
  }) {
    return _UserIngredientsState(
      userIngredients: userIngredients ?? this.userIngredients,
      filteredIngredients: filteredIngredients ?? this.filteredIngredients,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Ingredient> get userIngredients;
  List<Ingredient> get filteredIngredients;
  String get searchQuery;
  String get status;
  String get message;
  bool get isLoading;
}

class _UserIngredientsState extends UserIngredientsState {
  const _UserIngredientsState({
    this.userIngredients = const [],
    this.filteredIngredients = const [],
    this.searchQuery = '',
    this.status = '',
    this.message = '',
    this.isLoading = false,
  });

  @override
  final List<Ingredient> userIngredients;
  @override
  final List<Ingredient> filteredIngredients;
  @override
  final String searchQuery;
  @override
  final String status;
  @override
  final String message;
  @override
  final bool isLoading;
}

class UserIngredientsNotifier extends Notifier<UserIngredientsState> {
  @override
  UserIngredientsState build() {
    state = const _UserIngredientsState();
    // Load user ingredients on initialization
    loadUserIngredients();
    return state;
  }

  /// Load all ingredients marked as custom (is_custom = 1) from database
  Future<void> loadUserIngredients() async {
    state = state.copyWith(isLoading: true);
    try {
      final allIngredients = await ref.read(ingredientsRepository).getAll();

      // Filter to only custom ingredients
      final userCreated =
          allIngredients.where((ing) => ing.isCustom == 1).toList();

      state = state.copyWith(
        userIngredients: userCreated,
        filteredIngredients: userCreated,
        isLoading: false,
        status: 'success',
      );
    } catch (e) {
      if (kDebugMode) print('Error loading user ingredients: $e');
      state = state.copyWith(
        isLoading: false,
        status: 'error',
        message: 'Failed to load custom ingredients',
      );
    }
  }

  /// Search user ingredients by name (case-insensitive)
  void searchUserIngredients(String query) {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(filteredIngredients: state.userIngredients);
    } else {
      final filtered = state.userIngredients
          .where((ing) => ing.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filteredIngredients: filtered);
    }
  }

  /// Clear search
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      filteredIngredients: state.userIngredients,
    );
  }

  /// Add a new custom ingredient to the collection
  /// (assumes ingredient was already created and saved to database)
  void addCustomIngredient(Ingredient ingredient) {
    final updated = [...state.userIngredients, ingredient];
    state = state.copyWith(
      userIngredients: updated,
      filteredIngredients: updated,
      message: '${ingredient.name} added to your ingredients',
    );
  }

  /// Remove a custom ingredient
  Future<void> removeCustomIngredient(num ingredientId) async {
    try {
      await ref.read(ingredientsRepository).delete(ingredientId);
      await loadUserIngredients();
      state = state.copyWith(message: 'Custom ingredient removed');
    } catch (e) {
      if (kDebugMode) print('Error removing ingredient: $e');
      state = state.copyWith(
        status: 'error',
        message: 'Failed to remove ingredient',
      );
    }
  }

  /// Get count of user ingredients
  int getUserIngredientCount() => state.userIngredients.length;

  /// Check if ingredient is custom (created by user)
  bool isUserIngredient(Ingredient ingredient) => ingredient.isCustom == 1;

  /// Get ingredients created by a specific user
  List<Ingredient> getIngredientsByCreator(String creatorName) {
    return state.userIngredients
        .where((ing) => ing.createdBy == creatorName)
        .toList();
  }
}

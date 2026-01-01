import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/optimization_constraint.dart';
import '../model/optimization_request.dart';
import '../model/optimization_result.dart';
import '../services/formulation_optimizer_service.dart';
import '../../add_ingredients/model/ingredient.dart';
import '../../add_ingredients/provider/ingredients_provider.dart';

/// Provider for the FormulationOptimizerService
final formulationOptimizerServiceProvider =
    Provider<FormulationOptimizerService>((ref) {
  return FormulationOptimizerService();
});

/// State for the optimizer
class OptimizerState {
  final List<OptimizationConstraint> constraints;
  final List<int> selectedIngredientIds;
  final Map<int, double> ingredientPrices;
  final ObjectiveFunction objective;
  final Map<int, InclusionLimit>? ingredientLimits;
  final OptimizationResult? lastResult;
  final bool isOptimizing;
  final String? errorMessage;

  const OptimizerState({
    this.constraints = const [],
    this.selectedIngredientIds = const [],
    this.ingredientPrices = const {},
    this.objective = ObjectiveFunction.minimizeCost,
    this.ingredientLimits,
    this.lastResult,
    this.isOptimizing = false,
    this.errorMessage,
  });

  OptimizerState copyWith({
    List<OptimizationConstraint>? constraints,
    List<int>? selectedIngredientIds,
    Map<int, double>? ingredientPrices,
    ObjectiveFunction? objective,
    Map<int, InclusionLimit>? ingredientLimits,
    OptimizationResult? lastResult,
    bool? isOptimizing,
    String? errorMessage,
  }) {
    return OptimizerState(
      constraints: constraints ?? this.constraints,
      selectedIngredientIds:
          selectedIngredientIds ?? this.selectedIngredientIds,
      ingredientPrices: ingredientPrices ?? this.ingredientPrices,
      objective: objective ?? this.objective,
      ingredientLimits: ingredientLimits ?? this.ingredientLimits,
      lastResult: lastResult ?? this.lastResult,
      isOptimizing: isOptimizing ?? this.isOptimizing,
      errorMessage: errorMessage,
    );
  }

  /// Clear the last result and error
  OptimizerState clearResult() {
    return copyWith(
      lastResult: null,
      errorMessage: null,
    );
  }
}

/// Notifier for managing optimizer state
class OptimizerNotifier extends Notifier<OptimizerState> {
  @override
  OptimizerState build() {
    return const OptimizerState();
  }

  /// Add a constraint
  void addConstraint(OptimizationConstraint constraint) {
    state = state.copyWith(
      constraints: [...state.constraints, constraint],
    );
  }

  /// Remove a constraint
  void removeConstraint(int index) {
    final newConstraints = List<OptimizationConstraint>.from(state.constraints);
    newConstraints.removeAt(index);
    state = state.copyWith(constraints: newConstraints);
  }

  /// Update a constraint
  void updateConstraint(int index, OptimizationConstraint constraint) {
    final newConstraints = List<OptimizationConstraint>.from(state.constraints);
    newConstraints[index] = constraint;
    state = state.copyWith(constraints: newConstraints);
  }

  /// Clear all constraints
  void clearConstraints() {
    state = state.copyWith(constraints: []);
  }

  /// Set selected ingredients
  void setSelectedIngredients(List<int> ingredientIds) {
    state = state.copyWith(selectedIngredientIds: ingredientIds);
  }

  /// Add an ingredient
  void addIngredient(int ingredientId, double price) {
    final newIds = [...state.selectedIngredientIds, ingredientId];
    final newPrices = Map<int, double>.from(state.ingredientPrices);
    newPrices[ingredientId] = price;

    state = state.copyWith(
      selectedIngredientIds: newIds,
      ingredientPrices: newPrices,
    );
  }

  /// Remove an ingredient
  void removeIngredient(int ingredientId) {
    final newIds =
        state.selectedIngredientIds.where((id) => id != ingredientId).toList();
    final newPrices = Map<int, double>.from(state.ingredientPrices);
    newPrices.remove(ingredientId);

    state = state.copyWith(
      selectedIngredientIds: newIds,
      ingredientPrices: newPrices,
    );
  }

  /// Set ingredient price
  void setIngredientPrice(int ingredientId, double price) {
    final newPrices = Map<int, double>.from(state.ingredientPrices);
    newPrices[ingredientId] = price;
    state = state.copyWith(ingredientPrices: newPrices);
  }

  /// Set ingredient inclusion limit
  void setIngredientLimit(int ingredientId, InclusionLimit limit) {
    final newLimits =
        Map<int, InclusionLimit>.from(state.ingredientLimits ?? {});
    newLimits[ingredientId] = limit;
    state = state.copyWith(ingredientLimits: newLimits);
  }

  /// Remove ingredient inclusion limit
  void removeIngredientLimit(int ingredientId) {
    if (state.ingredientLimits == null) return;
    final newLimits = Map<int, InclusionLimit>.from(state.ingredientLimits!);
    newLimits.remove(ingredientId);
    state = state.copyWith(ingredientLimits: newLimits);
  }

  /// Set optimization objective
  void setObjective(ObjectiveFunction objective) {
    state = state.copyWith(objective: objective);
  }

  /// Run optimization
  Future<void> optimize() async {
    // Validate inputs
    if (state.constraints.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please add at least one nutritional constraint',
      );
      return;
    }

    if (state.selectedIngredientIds.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please select at least one ingredient',
      );
      return;
    }

    // Set optimizing state
    state = state.copyWith(
      isOptimizing: true,
      errorMessage: null,
    );

    try {
      // Get ingredient cache from ingredients provider
      final ingredientsState = ref.read(ingredientProvider);
      final ingredientCache = <int, Ingredient>{};

      for (final id in state.selectedIngredientIds) {
        final ingredient = ingredientsState.ingredients.firstWhere(
          (ing) => ing.ingredientId == id,
          orElse: () => throw Exception('Ingredient $id not found'),
        );
        ingredientCache[id] = ingredient;
      }

      // Get service
      final service = ref.read(formulationOptimizerServiceProvider);

      // Create optimization request
      final request = OptimizationRequest(
        constraints: state.constraints,
        availableIngredientIds: state.selectedIngredientIds,
        ingredientPrices: state.ingredientPrices,
        objective: state.objective,
        ingredientLimits: state.ingredientLimits,
      );

      // Run optimization
      final result = await service.optimize(
        request: request,
        ingredientCache: ingredientCache,
      );

      // Update state with result
      state = state.copyWith(
        lastResult: result,
        isOptimizing: false,
        errorMessage: result.success ? null : result.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isOptimizing: false,
        errorMessage: 'Optimization failed: ${e.toString()}',
      );
    }
  }

  /// Reset optimizer state
  void reset() {
    state = const OptimizerState();
  }
}

/// Provider for optimizer state
final optimizerProvider =
    NotifierProvider<OptimizerNotifier, OptimizerState>(() {
  return OptimizerNotifier();
});

/// Provider for checking if optimization can be run
final canOptimizeProvider = Provider<bool>((ref) {
  final state = ref.watch(optimizerProvider);
  return state.constraints.isNotEmpty &&
      state.selectedIngredientIds.isNotEmpty &&
      !state.isOptimizing;
});

/// Provider for getting the current optimization result
final optimizationResultProvider = Provider<OptimizationResult?>((ref) {
  return ref.watch(optimizerProvider).lastResult;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/optimization_constraint.dart';
import '../model/optimization_request.dart';
import '../model/optimization_result.dart';
import '../model/nutrient_requirement.dart';
import '../services/formulation_optimizer_service.dart';
import '../../add_ingredients/model/ingredient.dart';
import '../../add_ingredients/provider/ingredients_provider.dart';
import '../../price_management/provider/current_price_provider.dart';
import '../../main/model/feed.dart';
import '../../../core/utils/logger.dart';
import '../../../core/constants/animal_categories.dart' as ac;
import '../data/animal_requirements.dart';

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
  final String? selectedCategory; // e.g., "Poultry - Broiler Starter"
  final String? requirementSource; // e.g., "NRC 1994 Poultry"
  final bool hasStartedCustom; // True if user is in custom optimization flow

  const OptimizerState({
    this.constraints = const [],
    this.selectedIngredientIds = const [],
    this.ingredientPrices = const {},
    this.objective = ObjectiveFunction.minimizeCost,
    this.ingredientLimits,
    this.lastResult,
    this.isOptimizing = false,
    this.errorMessage,
    this.selectedCategory,
    this.requirementSource,
    this.hasStartedCustom = false,
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
    String? selectedCategory,
    String? requirementSource,
    bool? hasStartedCustom,
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
      selectedCategory: selectedCategory ?? this.selectedCategory,
      requirementSource: requirementSource ?? this.requirementSource,
      hasStartedCustom: hasStartedCustom ?? this.hasStartedCustom,
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

  /// Load animal category requirements
  void loadAnimalRequirements(dynamic category) {
    // Import needed: import '../model/nutrient_requirement.dart';
    final constraints = category.getAllConstraints();
    final sources =
        category.requirements.map((r) => r.source).toSet().join(', ');

    state = state.copyWith(
      constraints: constraints,
      selectedCategory: category.displayName,
      requirementSource: sources,
    );
  }

  /// Clear animal category
  void clearAnimalCategory() {
    state = state.copyWith(
      selectedCategory: null,
      requirementSource: null,
      constraints: [],
    );
  }

  /// Load quick optimize defaults for Broiler Chicken Starter with 10 common ingredients
  /// Uses NRC 1994 Poultry constraints for broiler starter
  /// Minimizes cost while meeting nutritional requirements
  ///
  /// Quick ingredients: corn, soy, fish meal, limestone, salt, phosphate, vitamin premix,
  /// amino acid supplement, methionine supplement, choline supplement
  Future<void> loadQuickOptimizeDefaults() async {
    try {
      // Broiler Chicken Starter constraints (NRC 1994)
      // Age: 0-3 weeks, Target production: meat production, Quality: high
      const broilerStarterConstraints = [
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.min,
          value: 23.0,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'crudeProtein',
          type: ConstraintType.max,
          value: 24.5,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'mePoultry',
          type: ConstraintType.min,
          value: 2950,
          unit: 'kcal/kg',
        ),
        OptimizationConstraint(
          nutrientName: 'lysine',
          type: ConstraintType.min,
          value: 1.15,
          unit: 'g/kg',
        ),
        OptimizationConstraint(
          nutrientName: 'lysine',
          type: ConstraintType.max,
          value: 1.30,
          unit: 'g/kg',
        ),
        OptimizationConstraint(
          nutrientName: 'calcium',
          type: ConstraintType.min,
          value: 0.85,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'calcium',
          type: ConstraintType.max,
          value: 1.00,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'availablePhosphorus',
          type: ConstraintType.min,
          value: 0.40,
          unit: '%',
        ),
        OptimizationConstraint(
          nutrientName: 'availablePhosphorus',
          type: ConstraintType.max,
          value: 0.55,
          unit: '%',
        ),
      ];

      // Common 10 ingredients: corn, soy, fishmeal, limestone, salt, phosphate,
      // vitamin premix, amino acid premix, methionine, choline
      const commonIngredientsForBroiler = [
        1, // Corn (yellow corn - grain)
        4, // Soybean meal (protein supplement)
        7, // Fish meal (protein + amino acids)
        19, // Limestone (calcium source)
        23, // Salt (mineral)
        25, // Phosphoric acid (phosphorus source)
        34, // Vitamin mineral premix (micronutrients)
        42, // Amino acid supplement (methionine + lysine)
        48, // DL-Methionine (specific amino acid)
        52, // Choline chloride (micronutrient)
      ];

      // Get current prices from price history repository
      Map<int, double> prices = {};
      try {
        for (final ingId in commonIngredientsForBroiler) {
          final price =
              await ref.read(currentPriceProvider(ingredientId: ingId).future);
          prices[ingId] = price;
        }
      } catch (_) {
        // Use default prices if price history unavailable
        // Typical NGN prices per kg (fallback)
        prices = {
          1: 0.01, // Corn (very cheap)
          4: 0.015, // Soybean meal
          7: 0.025, // Fish meal
          19: 0.005, // Limestone
          23: 0.008, // Salt
          25: 0.012, // Phosphoric acid
          34: 0.050, // Vitamin premix (expensive)
          42: 0.040, // Amino acid supplement
          48: 0.045, // DL-Methionine
          52: 0.020, // Choline chloride
        };
      }

      state = state.copyWith(
        constraints: broilerStarterConstraints,
        selectedIngredientIds: commonIngredientsForBroiler.cast<int>(),
        ingredientPrices: prices,
        objective: ObjectiveFunction.minimizeCost,
        selectedCategory: 'poultry_broiler_starter', // Localization key
        requirementSource: 'NRC 1994 Poultry',
        errorMessage: null,
      );

      AppLogger.info(
        'Quick optimize defaults loaded: broiler starter with ${commonIngredientsForBroiler.length} ingredients',
        tag: 'OptimizerNotifier',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load quick optimize defaults: $e',
        tag: 'OptimizerNotifier',
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        errorMessage: 'Failed to load quick optimize defaults',
      );
    }
  }

  /// Start custom optimization flow (user selects all options)
  void startCustomFlow() {
    state = state.copyWith(hasStartedCustom: true);
  }

  /// Load optimizer data from an existing feed
  /// Extracts animal type, ingredients, quantities, and prices from the feed
  Future<void> loadFromExistingFeed(Feed feed) async {
    try {
      AppLogger.info(
          '[OPTIMIZER-BACKEND] loadFromExistingFeed: ${feed.feedName}, animalId=${feed.animalId}, ingredients=${feed.feedIngredients?.length ?? 0}',
          tag: 'OptimizerNotifier');

      // Extract ingredient IDs, prices, and inclusion limits (even if empty)
      final ingredientIds = <int>[];
      final prices = <int, double>{};
      final ingredientLimits = <int, InclusionLimit>{};
      final animalTypeId = feed.animalId?.toInt() ?? 1;

      AppLogger.info(
          '[OPTIMIZER-BACKEND] Extracted animalTypeId: $animalTypeId',
          tag: 'OptimizerNotifier');

      // Get ingredient cache to access maxInclusionJson data
      final ingredientsState = ref.read(ingredientProvider);

      // Process ingredients if they exist
      if (feed.feedIngredients != null && feed.feedIngredients!.isNotEmpty) {
        for (final feedIng in feed.feedIngredients!) {
          if (feedIng.ingredientId != null) {
            final ingId = feedIng.ingredientId!.toInt();
            ingredientIds.add(ingId);

            // Load price
            try {
              final latestPrice = await ref.read(
                currentPriceProvider(ingredientId: ingId).future,
              );
              prices[ingId] = latestPrice;
            } catch (_) {
              // Fallback to feed's stored price
              prices[ingId] = (feedIng.priceUnitKg ?? 0.01).toDouble();
            }

            // Load ingredient-specific inclusion limits from database
            final ingredient = ingredientsState.ingredients.firstWhere(
              (ing) => ing.ingredientId == ingId,
              orElse: () => Ingredient(),
            );

            if (ingredient.maxInclusionJson != null) {
              // Use per-animal-type limits from maxInclusionJson
              final maxInclusion = _getMaxInclusionForAnimal(
                ingredient.maxInclusionJson!,
                animalTypeId,
              );
              if (maxInclusion != null) {
                ingredientLimits[ingId] = InclusionLimit(
                  minPct: 0.0,
                  maxPct: maxInclusion,
                );
              }
            } else if (ingredient.maxInclusionPct != null &&
                ingredient.maxInclusionPct! > 0) {
              // Fallback to simple maxInclusionPct
              ingredientLimits[ingId] = InclusionLimit(
                minPct: 0.0,
                maxPct: ingredient.maxInclusionPct!.toDouble(),
              );
            }
          }
        }
      } else {
        AppLogger.info(
            '[OPTIMIZER-BACKEND] Feed has no ingredients (OK for quick optimize)',
            tag: 'OptimizerNotifier');
      }

      // Load constraints using unified category system
      // Uses AnimalCategoryMapper for consistency with inclusion limits
      final stage = feed.productionStage ?? 'grower';

      AppLogger.info(
          '[OPTIMIZER-BACKEND] Looking for category: animalTypeId=$animalTypeId, stage=$stage',
          tag: 'OptimizerNotifier');

      // Get preference list using unified system
      final categoryPrefs = ac.AnimalCategoryMapper.getCategoryPreferences(
        animalTypeId: animalTypeId,
        productionStage: stage,
      );

      AppLogger.info('[OPTIMIZER-BACKEND] Category preferences: $categoryPrefs',
          tag: 'OptimizerNotifier');

      // Try to find category from preference list
      AnimalCategory? category;
      String requirementSourceStr = 'Unknown';

      for (final categoryKey in categoryPrefs) {
        category = findCategoryByKey(categoryKey);
        if (category != null) {
          AppLogger.info('[OPTIMIZER-BACKEND] Found category: $categoryKey',
              tag: 'OptimizerNotifier');
          break;
        }
      }

      // Set requirement source based on animal type
      if (animalTypeId == 1) {
        requirementSourceStr = 'NRC 2012 Swine';
      } else if (animalTypeId == 2) {
        requirementSourceStr = 'NRC 1994 Poultry';
      } else if (animalTypeId == 3) {
        requirementSourceStr = 'NRC 1977 Rabbit';
      } else if (animalTypeId == 4) {
        requirementSourceStr = 'NRC 2001 Cattle / Ruminants';
      } else if (animalTypeId == 5) {
        requirementSourceStr = 'NRC 2011 Fish / Aquaculture';
      }

      // Fallback if category not found in registry
      if (category == null) {
        AppLogger.warning(
            '[OPTIMIZER-BACKEND] No category found in registry, using swinePiglet fallback',
            tag: 'OptimizerNotifier');
        category = swinePiglet;
        requirementSourceStr = 'NRC 2012 Swine (Fallback)';
      }

      final constraints = category.getAllConstraints();

      AppLogger.info(
          '[OPTIMIZER-BACKEND] Found category: ${category.displayName}, constraints=${constraints.length}',
          tag: 'OptimizerNotifier');

      state = state.copyWith(
        constraints: constraints,
        selectedIngredientIds: ingredientIds,
        ingredientPrices: prices,
        ingredientLimits: ingredientLimits.isNotEmpty ? ingredientLimits : null,
        objective: ObjectiveFunction.minimizeCost,
        selectedCategory: category.displayName,
        requirementSource: requirementSourceStr,
        errorMessage: null,
      );

      AppLogger.info(
          '[OPTIMIZER-BACKEND] Loaded optimizer from feed ${feed.feedName}: ${ingredientIds.length} ingredients, ${ingredientLimits.length} with inclusion limits, category: ${category.displayName}',
          tag: 'OptimizerNotifier');
    } catch (e, stackTrace) {
      AppLogger.error(
        '[OPTIMIZER-BACKEND] Failed to load optimizer from feed: $e',
        tag: 'OptimizerNotifier',
        error: e,
        stackTrace: stackTrace,
      );

      state = state.copyWith(
        errorMessage: 'Failed to load feed data: ${e.toString()}',
      );
    }
  }

  /// Extract max inclusion percentage for specific animal type from ingredient's maxInclusionJson
  /// Uses same logic as InclusionValidator for consistency
  double? _getMaxInclusionForAnimal(
    Map<String, dynamic> maxInclusionJson,
    int animalTypeId,
  ) {
    // Map animal type ID to category keys (same as in core/constants/animal_categories.dart)
    final categoryKeys = <String>[];

    if (animalTypeId == 1) {
      // Pig
      categoryKeys.addAll(['pig', 'swine', 'porcine']);
    } else if (animalTypeId == 2) {
      // Poultry
      categoryKeys.addAll(['poultry', 'chicken', 'broiler', 'layer']);
    } else if (animalTypeId == 3) {
      // Rabbit
      categoryKeys.addAll(['rabbit', 'lagomorph']);
    } else if (animalTypeId == 4) {
      // Ruminant
      categoryKeys
          .addAll(['ruminant', 'cattle', 'beef', 'dairy', 'sheep', 'goat']);
    } else if (animalTypeId == 5) {
      // Fish
      categoryKeys.addAll(['fish', 'aquaculture', 'tilapia', 'catfish']);
    }

    // Try preferred keys first
    for (final key in categoryKeys) {
      final val = maxInclusionJson[key];
      if (val is num && val > 0) return val.toDouble();
    }

    // Common fallbacks
    for (final key in const ['default', 'all', 'any']) {
      final val = maxInclusionJson[key];
      if (val is num && val > 0) return val.toDouble();
    }

    // Last resort: pick the most conservative (minimum positive) limit
    final numericValues =
        maxInclusionJson.values.whereType<num>().where((e) => e > 0).toList();
    if (numericValues.isNotEmpty) {
      numericValues.sort();
      return numericValues.first.toDouble();
    }

    return null;
  }

  /// Start quick optimize with smart defaults for broiler chicken starter
  /// Loads pre-configured constraints and ingredients, skips animal selection step
  /// If feed is provided, loads data from existing feed instead
  Future<void> startQuickOptimize({Feed? existingFeed}) async {
    AppLogger.info(
        '[OPTIMIZER-BACKEND] startQuickOptimize: existingFeed=${existingFeed?.feedName}, animalId=${existingFeed?.animalId}',
        tag: 'OptimizerNotifier');

    if (existingFeed != null) {
      AppLogger.info('[OPTIMIZER-BACKEND] Loading from existing feed...',
          tag: 'OptimizerNotifier');
      await loadFromExistingFeed(existingFeed);
    } else {
      AppLogger.info('[OPTIMIZER-BACKEND] Loading quick optimize defaults...',
          tag: 'OptimizerNotifier');
      await loadQuickOptimizeDefaults();
    }

    AppLogger.info(
        '[OPTIMIZER-BACKEND] startQuickOptimize complete: constraints=${state.constraints.length}, ingredients=${state.selectedIngredientIds.length}, category=${state.selectedCategory}',
        tag: 'OptimizerNotifier');
    // Don't set hasStartedCustom - quick mode shows simplified workflow
  }

  /// Go back to choice screen (quick vs custom)
  void goBackToChoice() {
    state = state.copyWith(hasStartedCustom: false);
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

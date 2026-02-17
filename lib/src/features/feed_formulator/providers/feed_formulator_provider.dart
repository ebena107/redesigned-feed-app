import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_input.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';

/// PROVIDER
final feedFormulatorProvider =
    NotifierProvider<FeedFormulatorNotifier, FeedFormulatorState>(
  FeedFormulatorNotifier.new,
);

/// STATE
sealed class FeedFormulatorState {
  const FeedFormulatorState({
    required this.input,
    this.result,
    this.shadowPrices = const {},
    this.status = FormulatorStatus.idle,
    this.message = '',
  });

  final FormulatorInput input;

  final FormulatorResult? result;

  /// NEW: shadow prices per nutrient
  final Map<NutrientKey, double> shadowPrices;

  final FormulatorStatus status;

  final String message;

  FeedFormulatorState copyWith({
    FormulatorInput? input,
    FormulatorResult? result,
    Map<NutrientKey, double>? shadowPrices,
    FormulatorStatus? status,
    String? message,
  }) {
    return _FeedFormulatorState(
      input: input ?? this.input,
      result: result ?? this.result,
      shadowPrices: shadowPrices ?? this.shadowPrices,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class _FeedFormulatorState extends FeedFormulatorState {
  const _FeedFormulatorState({
    required super.input,
    super.result,
    super.shadowPrices = const {},
    super.status = FormulatorStatus.idle,
    super.message = '',
  });
}

enum FormulatorStatus {
  idle,
  solving,
  success,
  failure,
}

/// NOTIFIER
class FeedFormulatorNotifier extends Notifier<FeedFormulatorState> {
  @override
  FeedFormulatorState build() {
    return _FeedFormulatorState(
      input: FormulatorInput.initial(),
    );
  }

  /// ANIMAL TYPE
  void setAnimalTypeId(int animalTypeId) {
    final availableTypes = FeedType.forAnimalType(animalTypeId);
    final nextFeedType = availableTypes.contains(state.input.feedType)
        ? state.input.feedType
        : availableTypes.first;

    state = state.copyWith(
      input: state.input.copyWith(
        animalTypeId: animalTypeId,
        feedType: nextFeedType,
      ),
    );

    _loadDefaultRequirements(
      animalTypeId,
      nextFeedType,
    );
  }

  /// FEED TYPE
  void setFeedType(FeedType feedType) {
    state = state.copyWith(
      input: state.input.copyWith(
        feedType: feedType,
      ),
    );

    _loadDefaultRequirements(
      state.input.animalTypeId,
      feedType,
    );
  }

  /// LOAD DEFAULT REQUIREMENTS
  void _loadDefaultRequirements(
    int animalTypeId,
    FeedType feedType,
  ) {
    final requirements = NutrientRequirements.getDefaults(
      animalTypeId,
      feedType,
    );

    state = state.copyWith(
      input: state.input.copyWith(
        constraints: requirements.constraints,
      ),
    );
  }

  /// SELECT INGREDIENTS
  void setSelectedIngredientIds(Set<num> ids) {
    state = state.copyWith(
      input: state.input.copyWith(
        selectedIngredientIds: ids,
      ),
    );
  }

  void toggleIngredientId(num id) {
    final updated = Set<num>.from(state.input.selectedIngredientIds);

    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }

    setSelectedIngredientIds(updated);
  }

  void setConstraints(
    List<NutrientConstraint> constraints,
  ) {
    state = state.copyWith(
      input: state.input.copyWith(
        constraints: constraints,
      ),
    );
  }

  void updateConstraint(
    NutrientKey key, {
    double? min,
    double? max,
  }) {
    final updated = state.input.constraints.map((c) {
      if (c.key != key) return c;

      return createNutrientConstraint(
        key: key,
        min: min,
        max: max,
      );
    }).toList();

    setConstraints(updated);
  }

  void resetResult() {
    state = state.copyWith(
      result: null,
      shadowPrices: {},
      status: FormulatorStatus.idle,
      message: '',
    );
  }

  /// SOLVE FORMULATION
  Future<void> solve() async {
    if (state.status == FormulatorStatus.solving) return;

    state = state.copyWith(
      status: FormulatorStatus.solving,
      message: '',
      shadowPrices: {},
    );

    try {
      final ingredientState = ref.read(ingredientProvider);

      final ingredients = _selectIngredients(
        ingredientState.ingredients,
        state.input.selectedIngredientIds,
      );

      if (ingredients.isEmpty) {
        AppLogger.warning(
          'No ingredients selected for formulation',
          tag: 'FeedFormulatorNotifier',
        );
        state = state.copyWith(
          status: FormulatorStatus.failure,
          message: 'Select at least one ingredient.',
        );

        return;
      }

      AppLogger.info(
        'Starting formulation with ${ingredients.length} ingredients for animal type ${state.input.animalTypeId}',
        tag: 'FeedFormulatorNotifier',
      );

      final engine = FeedFormulatorEngine();
      final result = engine.formulate(
        ingredients: ingredients,
        constraints: state.input.constraints,
        animalTypeId: state.input.animalTypeId,
        feedTypeName: state.input.feedType.name,
        enforceMaxInclusion: state.input.enforceMaxInclusion,
      );

      AppLogger.debug(
        'Formulation result status: ${result.status}, warnings: ${result.warnings.length}, cost: ${result.costPerKg}',
        tag: 'FeedFormulatorNotifier',
      );

      final status = result.status == 'optimal'
          ? FormulatorStatus.success
          : FormulatorStatus.failure;

      final message = status == FormulatorStatus.success
          ? ''
          : result.warnings.isNotEmpty
              ? result.warnings.first
              : 'No feasible formulation found.';

      final shadowPrices = _calculateShadowPrices(
        engine,
        ingredients,
        result,
        state.input.constraints,
        state.input.animalTypeId,
        state.input.enforceMaxInclusion,
      );

      state = state.copyWith(
        result: result,
        shadowPrices: shadowPrices,
        status: status,
        message: message,
      );
    } on CalculationException catch (e, stackTrace) {
      AppLogger.error(
        'Formulation failed',
        error: e,
        stackTrace: stackTrace,
      );

      state = state.copyWith(
        status: FormulatorStatus.failure,
        message: e.message,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected formulation error',
        error: e,
        stackTrace: stackTrace,
      );

      state = state.copyWith(
        status: FormulatorStatus.failure,
        message: 'Unexpected error',
      );
    }
  }

  /// SHADOW PRICE CALCULATION
  Map<NutrientKey, double> _calculateShadowPrices(
    FeedFormulatorEngine engine,
    List<Ingredient> ingredients,
    FormulatorResult result,
    List<NutrientConstraint> constraints,
    int animalTypeId,
    bool enforceMaxInclusion,
  ) {
    final shadow = <NutrientKey, double>{};

    if (result.status != 'optimal') return shadow;

    final baseCost = result.costPerKg;
    const delta = 0.001;

    for (final constraint in constraints) {
      if (constraint.min == null) continue;

      final modified = constraints.map((c) {
        if (c.key != constraint.key) return c;

        return createNutrientConstraint(
          key: c.key,
          min: c.min! + delta,
          max: c.max,
        );
      }).toList();

      final newResult = engine.formulate(
        ingredients: ingredients,
        constraints: modified,
        animalTypeId: animalTypeId,
        enforceMaxInclusion: enforceMaxInclusion,
      );

      if (newResult.status != 'optimal') continue;

      shadow[constraint.key] = (newResult.costPerKg - baseCost) / delta;
    }

    return shadow;
  }

  /// SELECT INGREDIENTS
  List<Ingredient> _selectIngredients(
    List<Ingredient> all,
    Set<num> selectedIds,
  ) {
    final selected = <Ingredient>[];

    for (final ingredient in all) {
      final id = ingredient.ingredientId;

      if (id != null && selectedIds.contains(id)) {
        selected.add(ingredient);
      }
    }

    return selected;
  }
}

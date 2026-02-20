import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_input.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulation_record.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';
import 'package:feed_estimator/src/features/feed_formulator/repository/formulation_repository.dart';
import 'package:feed_estimator/src/features/feed_formulator/services/feed_formulator_engine.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';

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

  void setIngredientPriceOverride(num ingredientId, double? price) {
    final updated = Map<num, double>.from(state.input.priceOverrides);
    if (price == null) {
      updated.remove(ingredientId);
    } else {
      updated[ingredientId] = price;
    }
    state = state.copyWith(
      input: state.input.copyWith(priceOverrides: updated),
    );
  }

  void setIngredientMaxInclusionOverride(num ingredientId, double? maxPct) {
    final updated = Map<num, double>.from(state.input.maxInclusionOverrides);
    if (maxPct == null) {
      updated.remove(ingredientId);
    } else {
      updated[ingredientId] = maxPct;
    }
    state = state.copyWith(
      input: state.input.copyWith(maxInclusionOverrides: updated),
    );
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

  /// SAVE FORMULATION
  /// Saves the current formulation result to the database
  Future<int?> saveFormulation({
    String? name,
    String? notes,
  }) async {
    final currentResult = state.result;
    if (currentResult == null) {
      AppLogger.warning('Cannot save formulation: no result available',
          tag: 'FeedFormulatorNotifier');
      return null;
    }

    try {
      final repository = ref.read(formulationRepositoryProvider);
      final record = FormulationRecord(
        animalTypeId: state.input.animalTypeId,
        feedType: state.input.feedType.name,
        formulationName: name,
        createdAt: DateTime.now(),
        constraints: state.input.constraints,
        selectedIngredientIds:
            state.input.selectedIngredientIds.map((id) => id.toInt()).toList(),
        result: currentResult,
        notes: notes,
      );

      final id = await repository.save(record);
      AppLogger.info('Saved formulation with ID: $id',
          tag: 'FeedFormulatorNotifier');
      return id;
    } catch (e, stackTrace) {
      AppLogger.error('Error saving formulation: $e',
          tag: 'FeedFormulatorNotifier', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// SAVE AS FEED (to main app database)
  Future<bool> saveAsFeed(String feedName) async {
    final currentResult = state.result;
    if (currentResult == null) return false;

    try {
      final feedRepo = ref.read(feedRepository);
      final feedIngRepo = ref.read(feedIngredientRepository);

      final feed = Feed(
        feedName: feedName,
        animalId: state.input.animalTypeId,
        timestampModified: DateTime.now().millisecondsSinceEpoch,
        productionStage: state.input.feedType.name,
      );

      final feedId = await feedRepo.create(feed.toJson());

      // Get ingredient data to map IDs to price
      final ingredientData = ref.read(ingredientProvider);
      final ingredientCache = {
        for (final ing in ingredientData.ingredients)
          if (ing.ingredientId != null) ing.ingredientId!: ing
      };

      final futures =
          currentResult.ingredientPercents.entries.map((entry) async {
        final ingId = entry.key;
        final percentage = entry.value;

        // Skip ingredients with 0% inclusion
        if (percentage <= 0) return;

        final baseIng = ingredientCache[ingId];
        final priceOverride = state.input.priceOverrides[ingId];
        final price = priceOverride ?? baseIng?.priceKg ?? 0.0;

        final feedIng = FeedIngredients(
          feedId: feedId,
          ingredientId: ingId,
          quantity: percentage,
          priceUnitKg: price,
        );

        await feedIngRepo.create(feedIng.toJson());
      });

      await Future.wait(futures);
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error saving formulation as feed: $e',
          tag: 'FeedFormulatorNotifier', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// LOAD FORMULATION
  /// Loads a saved formulation from the database and restores the state
  Future<bool> loadFormulation(int id) async {
    try {
      final repository = ref.read(formulationRepositoryProvider);
      final record = await repository.getById(id);

      if (record == null) {
        AppLogger.warning('Formulation $id not found',
            tag: 'FeedFormulatorNotifier');
        return false;
      }

      // Restore the state from the loaded record
      state = state.copyWith(
        input: state.input.copyWith(
          animalTypeId: record.animalTypeId,
          feedType: record.feedType != null
              ? FeedType.values.firstWhere(
                  (ft) => ft.name == record.feedType,
                  orElse: () => FeedType.starter,
                )
              : state.input.feedType,
          constraints: record.constraints,
          selectedIngredientIds:
              record.selectedIngredientIds.map((id) => id as num).toSet(),
        ),
        result: record.result,
        status: FormulatorStatus.success,
      );

      AppLogger.info('Loaded formulation $id', tag: 'FeedFormulatorNotifier');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Error loading formulation $id: $e',
          tag: 'FeedFormulatorNotifier', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// DELETE FORMULATION
  /// Deletes a saved formulation from the database
  Future<bool> deleteFormulation(int id) async {
    try {
      final repository = ref.read(formulationRepositoryProvider);
      final rowsAffected = await repository.delete(id);
      AppLogger.info('Deleted formulation $id (rows affected: $rowsAffected)',
          tag: 'FeedFormulatorNotifier');
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting formulation $id: $e',
          tag: 'FeedFormulatorNotifier', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// SELECT INGREDIENTS AND APPLY OVERRIDES
  List<Ingredient> _selectIngredients(
    List<Ingredient> all,
    Set<num> selectedIds,
  ) {
    final selected = <Ingredient>[];

    for (final ingredient in all) {
      final id = ingredient.ingredientId;

      if (id != null && selectedIds.contains(id)) {
        var merged = ingredient;
        if (state.input.priceOverrides.containsKey(id)) {
          merged = merged.copyWith(priceKg: state.input.priceOverrides[id]);
        }
        if (state.input.maxInclusionOverrides.containsKey(id)) {
          merged = merged.copyWith(
              maxInclusionPct: state.input.maxInclusionOverrides[id]);
        }
        selected.add(merged);
      }
    }

    return selected;
  }
}

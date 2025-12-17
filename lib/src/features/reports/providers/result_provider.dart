import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_provider.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/enhanced_calculation_engine.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final resultProvider =
    NotifierProvider<ResultNotifier, ResultsState>(ResultNotifier.new);

sealed class ResultsState {
  const ResultsState({
    this.results = const [],
    this.myResult,
    this.toggle = false,
  });

  final List<Result> results;
  final Result? myResult;
  final bool toggle;

  ResultsState copyWith({
    List<Result>? results,
    Result? myResult,
    bool? toggle,
  }) =>
      _ResultsState(
        results: results ?? this.results,
        myResult: myResult ?? this.myResult,
        toggle: toggle ?? this.toggle,
      );
}

class _ResultsState extends ResultsState {
  const _ResultsState({
    super.results = const [],
    super.myResult,
    super.toggle = false,
  });
}

class ResultNotifier extends Notifier<ResultsState> {
  @override
  ResultsState build() {
    // setFeed(ref.watch(asyncMainProvider));
    return const _ResultsState();
  }

  num _totalQuantity = 0.0;

  Map<num, Ingredient> _ingredientCache = const {};
  final Map<num, Result> _calculationCache = {};
  bool _cacheInitialized = false;

  Feed _feed = Feed();

  Result _newResult = Result();
  final List<Result> _resultList = [];

  Future<void> loadResults() async {
    if (_resultList.isNotEmpty) {
      state = state.copyWith(results: _resultList);
    }
  }

  Future<void> setFeed(List<Feed> feeds) async {
    //final data = ref.watch(asyncMainProvider);

    //  debugPrint('result - setFeed entered with feed: ${feeds.length.toString()}');
    state = state.copyWith(results: []);

    resetResult();

    if (feeds.isNotEmpty) {
      for (var feed in feeds) {
        if (feed.feedIngredients != null) {
          if (feed.feedIngredients!.isNotEmpty) {
            //
            _feed = feed;

            await calculateResult();

            // Use the enhanced result from state.myResult (set by calculateResult)
            // and add the feedId to it
            if (state.myResult != null) {
              _newResult = Result(
                feedId: feed.feedId,
                mEnergy: state.myResult!.mEnergy,
                cProtein: state.myResult!.cProtein,
                cFat: state.myResult!.cFat,
                cFibre: state.myResult!.cFibre,
                calcium: state.myResult!.calcium,
                phosphorus: state.myResult!.phosphorus,
                lysine: state.myResult!.lysine,
                methionine: state.myResult!.methionine,
                costPerUnit: state.myResult!.costPerUnit,
                totalCost: state.myResult!.totalCost,
                totalQuantity: state.myResult!.totalQuantity,
                // Include all v5 enhanced fields
                ash: state.myResult!.ash,
                moisture: state.myResult!.moisture,
                totalPhosphorus: state.myResult!.totalPhosphorus,
                availablePhosphorus: state.myResult!.availablePhosphorus,
                phytatePhosphorus: state.myResult!.phytatePhosphorus,
                aminoAcidsTotalJson: state.myResult!.aminoAcidsTotalJson,
                aminoAcidsSidJson: state.myResult!.aminoAcidsSidJson,
                warningsJson: state.myResult!.warningsJson,
              );
            }
          }
        }

        if (_resultList.isNotEmpty && _newResult.mEnergy != 0) {
          var available = _resultList.firstWhere(
              (r) => r.feedId == _newResult.feedId,
              orElse: () => Result());

          if (available == Result()) {
            _resultList.add(_newResult);
          } else {
            _resultList.removeWhere((element) => element.feedId == feed.feedId);
            _resultList.add(_newResult);
          }
        } else if (_newResult.mEnergy != 0) {
          _resultList.add(_newResult);
        }
      }
      state = state.copyWith(results: _resultList);
    }

    _feed = Feed();
    _newResult = Result();
  }

  void getMyResult(num feedId) {
    var feeds = ref.watch(mainViewProvider).feeds;

    if (state.results.isNotEmpty &&
        state.results.any((element) => element.feedId == feedId)) {
      final available = _resultList.firstWhere((r) => r.feedId == feedId);
      state = state.copyWith(myResult: available);
    } else {
      final feedList = feeds;
      final myFeed = feedList.firstWhere((feed) => feed.feedId == feedId);

      estimatedResult(
          feedId: feedId,
          ingList: myFeed.feedIngredients,
          animal: myFeed.animalId);
    }
  }

  ///estimating new feed
  Future<void> estimatedResult(
      {Feed? feed,
      num? feedId,
      List<FeedIngredients>? ingList,
      num? animal}) async {
    // TEMPORARILY DISABLED: Cache was returning old results without v5 data
    // Check cache first
    // if (feedId != null && _calculationCache.containsKey(feedId)) {
    //   state = state.copyWith(myResult: _calculationCache[feedId]);
    //   return;
    // }

    resetResult();

    debugPrint('[ResultProvider] estimatedResult called:');
    debugPrint('[ResultProvider]   feedId=$feedId, animal=$animal');
    debugPrint('[ResultProvider]   ingList length=${ingList?.length ?? 0}');
    if (ingList != null && ingList.isNotEmpty) {
      debugPrint(
          '[ResultProvider]   First ingredient: id=${ingList.first.ingredientId}, qty=${ingList.first.quantity}');
    }

    bool checked = false;

    if (feed != null) {
      _feed = feed;

      if (feed.feedIngredients!.any((e) => (e.quantity ?? 0) != 0)) {
        checked = true;
      }
    } else if (ingList != null && ingList.isNotEmpty) {
      _feed = Feed(
        //  feedId: feedId ?? 0,
        animalId: animal ?? 1, //type of animal or default to 1
        feedIngredients: ingList,
      );

      if (ingList.any((e) => (e.quantity ?? 0) != 0)) {
        checked = true;
      }
    } else if (ingList == null || ingList.isEmpty) {
      _newResult = Result();
      state = state.copyWith(myResult: _newResult);
    }

    debugPrint('[ResultProvider] checked=$checked');

    if (checked) {
      debugPrint('[ResultProvider] Starting calculateResult...');
      // debugPrint('result estimate: - resultProvider - : feedIng length: ${ingList.length}');
      await calculateResult();

      // calculateResult() already updates state.myResult with the enhanced result
      // No need to create a new Result object here - it would overwrite the enhanced data!

      // Cache the result if we have a feedId
      if (feedId != null && state.myResult != null) {
        _calculationCache[feedId] = state.myResult!;
      }

      _feed = Feed();
    } else {
      _newResult = Result();
      state = state.copyWith(myResult: _newResult);
    }
  }

  void resetResult() {
    _newResult = Result();
    _feed = Feed();
    _totalQuantity = 0.0;
    state = state.copyWith(myResult: _newResult);
  }

  Future<void> calculateResult() async {
    final ingList = _feed.feedIngredients;
    if (ingList == null || ingList.isEmpty) return;

    await _loadIngredientCache();
    _totalQuantity = _calcTotalQuantity(ingList);
    if (_totalQuantity <= 0) return;

    final animalTypeId = _feed.animalId ?? 1;

    // Use enhanced v5 calculation engine
    final enhanced = EnhancedCalculationEngine.calculateEnhancedResult(
      feedIngredients: ingList,
      ingredientCache: _ingredientCache,
      animalTypeId: animalTypeId,
    );

    // CRITICAL FIX: Update state with the complete enhanced result
    // This ensures all v5 fields (ash, moisture, amino acids, warnings, etc.) are available
    state = state.copyWith(myResult: enhanced);
  }

  double _calcTotalQuantity(List<FeedIngredients> ingList) {
    double total = 0;
    for (final i in ingList) {
      total += (i.quantity ?? 0).toDouble();
    }
    return total;
  }

  Future<void> _loadIngredientCache() async {
    if (_cacheInitialized) return;
    final raw =
        await ref.read(appDatabase).selectAll(IngredientsRepository.tableName);
    final list = raw.map((e) => Ingredient.fromJson(e)).toList();
    _ingredientCache = {
      for (final ing in list)
        if (ing.ingredientId != null) ing.ingredientId!: ing,
    };
    _cacheInitialized = true;
  }

  /// Pre-load ingredient cache at startup for better performance
  Future<void> preLoadIngredientCache() async {
    await _loadIngredientCache();
  }

  /// Clear calculation cache when ingredient data changes
  void clearCalculationCache() {
    _calculationCache.clear();
  }

  double _energyForAnimal(Ingredient ing, num animalTypeId) {
    if (animalTypeId == 1) return (ing.meGrowingPig ?? 0).toDouble();
    if (animalTypeId == 2) return (ing.mePoultry ?? 0).toDouble();
    if (animalTypeId == 3) return (ing.meRabbit ?? 0).toDouble();
    if (animalTypeId == 4) return (ing.meRuminant ?? 0).toDouble();
    if (animalTypeId == 5) return (ing.deSalmonids ?? 0).toDouble();
    return 0;
  }

  void toggle(bool bool) {
    state = state.copyWith(toggle: bool);
  }
}

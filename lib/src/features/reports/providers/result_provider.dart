import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_provider.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  num _mEnergy = 0;
  num _cProtein = 0.0;
  num _cFat = 0.0;
  num _cFibre = 0.0;
  num _calcium = 0.0;
  num _phosphorus = 0.0;
  num _lyzine = 0.0;
  num _methionine = 0.0;
  num _costPerUnit = 0.0;
  num _totalCost = 0.0;
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

            _newResult = Result(
                feedId: feed.feedId,
                mEnergy: _mEnergy,
                cProtein: _cProtein,
                cFat: _cFat,
                cFibre: _cFibre,
                calcium: _calcium,
                phosphorus: _phosphorus,
                lysine: _lyzine,
                methionine: _methionine,
                costPerUnit: _costPerUnit,
                totalCost: _totalCost,
                totalQuantity: _totalQuantity);
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
    // Check cache first
    if (feedId != null && _calculationCache.containsKey(feedId)) {
      state = state.copyWith(myResult: _calculationCache[feedId]);
      return;
    }

    resetResult();

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

    if (checked) {
      // debugPrint('result estimate: - resultProvider - : feedIng length: ${ingList.length}');
      await calculateResult();

      _newResult = Result(
          feedId: _feed.feedId,
          mEnergy: _mEnergy,
          cProtein: _cProtein,
          cFat: _cFat,
          cFibre: _cFibre,
          calcium: _calcium,
          phosphorus: _phosphorus,
          lysine: _lyzine,
          methionine: _methionine,
          costPerUnit: _costPerUnit,
          totalCost: _totalCost,
          totalQuantity: _totalQuantity);

      // Cache the result if we have a feedId
      if (feedId != null) {
        _calculationCache[feedId] = _newResult;
      }

      state = state.copyWith(myResult: _newResult);
      _feed = Feed();
    } else {
      _newResult = Result();
      state = state.copyWith(myResult: _newResult);
    }
  }

  void resetResult() {
    _newResult = Result();
    _feed = Feed();
    _mEnergy = 0;
    _cProtein = 0.0;
    _cFat = 0.0;
    _cFibre = 0.0;
    _calcium = 0.0;
    _phosphorus = 0.0;
    _lyzine = 0.0;
    _methionine = 0.0;
    _costPerUnit = 0.0;
    _totalCost = 0.0;
    _totalQuantity = 0.0;
    state = state.copyWith(myResult: _newResult);
  }

  Future<void> calculateResult() async {
    final ingList = _feed.feedIngredients;
    if (ingList == null || ingList.isEmpty) return;

    await _loadIngredientCache();
    _totalQuantity = _calcTotalQuantity(ingList);
    if (_totalQuantity <= 0) return;

    double totalEnergy = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalCalcium = 0;
    double totalPhosphorus = 0;
    double totalLysine = 0;
    double totalMethionine = 0;
    double totalCost = 0;

    final animalTypeId = _feed.animalId ?? 1;

    for (final ing in ingList) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = _ingredientCache[ing.ingredientId];
      if (data == null) continue;

      final energy = _energyForAnimal(data, animalTypeId);
      totalEnergy += energy * qty;
      totalProtein += (data.crudeProtein ?? 0) * qty;
      totalFat += (data.crudeFat ?? 0) * qty;
      totalFiber += (data.crudeFiber ?? 0) * qty;
      totalCalcium += (data.calcium ?? 0) * qty;
      totalPhosphorus += (data.phosphorus ?? 0) * qty;
      totalLysine += (data.lysine ?? 0) * qty;
      totalMethionine += (data.methionine ?? 0) * qty;
      totalCost += (ing.priceUnitKg ?? 0) * qty;
    }

    _mEnergy = totalEnergy / _totalQuantity;
    _cProtein = totalProtein / _totalQuantity;
    _cFat = totalFat / _totalQuantity;
    _cFibre = totalFiber / _totalQuantity;
    _calcium = totalCalcium / _totalQuantity;
    _phosphorus = totalPhosphorus / _totalQuantity;
    _lyzine = totalLysine / _totalQuantity;
    _methionine = totalMethionine / _totalQuantity;
    _costPerUnit = totalCost / _totalQuantity;
    _totalCost = totalCost;
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

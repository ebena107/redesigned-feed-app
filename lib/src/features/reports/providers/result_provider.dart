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
      final available =
          _resultList.firstWhere((r) => r.feedId == _newResult.feedId);
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
    resetResult();

    bool checked = false;

    if (feed != null) {
      _feed = feed;

      if (feed.feedIngredients!
          .any((e) => e.quantity != 0 || e.quantity != 0.0)) {
        checked = true;
      }
    } else if (ingList != null && ingList.isNotEmpty) {
      _feed = Feed(
        //  feedId: feedId ?? 0,
        animalId: animal ?? 1, //type of animal or default to 1
        feedIngredients: ingList,
      );

      if (ingList.any((e) => e.quantity != 0 || e.quantity != 0.0)) {
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

  calculateResult() async {
    //final ingBox = Hive.box<Ingredients>(HiveBoxes.ingBox);
    //    final ingBox = await Hive.openBox<Ingredients>(HiveBoxes.ingBox);

    final ingList = _feed.feedIngredients;

    if (ingList!.isNotEmpty) {
      calcTotalQuantity();
      await calcEnergy();
      await calcCP();
      await calcFiber();
      await calcCFat();
      await calcLyzine();
      await calcMethionine();
      await calcCalcium();
      await calcPhosphorous();
      await calcCost();
    }
  }

  calcTotalQuantity() {
    num tQuantity = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingQ = i.quantity ?? 0;
        tQuantity += ingQ;
      }
      _totalQuantity = tQuantity;
    }

    //
  }

  Future<void> calcEnergy() async {
    var totalKg = _totalQuantity;
    var mE = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingE = await energyType(i.ingredientId);

        //   num? ingQ =  i.quantity ?? 0;
        num? ingQ = i.quantity ?? 0;
        //
        if (ingE != null) {
          mE += ((ingE * ingQ) / totalKg);
        }
      }
      _mEnergy = mE;
    }
    //
  }

  Future<void> calcCP() async {
    var totalKg = _totalQuantity;
    var cP = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    //

    num? ingP;
    if (ing!.isNotEmpty) {
      for (var i in ing) {
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.crudeProtein;

        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          cP += ((ingP * ingQ) / totalKg);
        }
      }
      _cProtein = cP;
    }
  }

  Future<void> calcCFat() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.crudeFat;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _cFat = data;
      //
    }
  }

  Future<void> calcFiber() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.crudeFiber;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _cFibre = data;
      //
    }
  }

  Future<void> calcCalcium() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.calcium;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _calcium = data;
      //
    }
  }

  Future<void> calcPhosphorous() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.phosphorus;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _phosphorus = data;
      //
    }
  }

  Future<void> calcLyzine() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];
    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.lysine;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _lyzine = data;
      //
    }
  }

  Future<void> calcMethionine() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing!.isNotEmpty) {
      for (var i in ing) {
        num? ingP;
        Ingredient available = await checkAvailable(i.ingredientId);
        ingP = available.methionine;
        num? ingQ = i.quantity ?? 0;

        if (ingP != null) {
          data += ((ingP * ingQ) / totalKg);
        }
      }
      _methionine = data;
      //
    }
  }

  Future<void> calcCost() async {
    var totalKg = _totalQuantity;
    var data = 0.0;
    List<FeedIngredients>? ing = [];

    ing = _feed.feedIngredients;

    if (ing != null) {
      if (ing.isNotEmpty) {
        for (var i in ing) {
          num ingP = i.priceUnitKg != null ? i.priceUnitKg as num : 0;
          num ingQ = i.quantity != null ? i.quantity as num : 0;
          final div = ingP * ingQ;

          data += (div / totalKg);
        }
        _costPerUnit = data;
        _totalCost = _costPerUnit * totalKg;
        //}
      }
    }
  }

  Future<Ingredient> checkAvailable(num? ingredientId) async {
    final ing =
        await ref.watch(appDatabase).selectAll(IngredientsRepository.tableName);

    final ingList = ing.map((e) => Ingredient.fromJson(e)).toList();

    Ingredient available = ingList.firstWhere(
        (e) => e.ingredientId == ingredientId,
        orElse: (() => throw 'Estimating Energy - ingredients not available'));

    return available;
  }

  Future<num?> energyType(num? id) async {
    Ingredient ing = Ingredient();
    num? eM = 0;
    var feed = _feed;

    num? animalTypeId = feed.animalId;

    ing = await checkAvailable(id);

    if (animalTypeId == 1) {
      eM = ing.meGrowingPig;
    } else if (animalTypeId == 2) {
      eM = ing.mePoultry;
    } else if (animalTypeId == 3) {
      eM = ing.meRabbit;
    } else if (animalTypeId == 4) {
      eM = ing.meRuminant;
    } else if (animalTypeId == 5) {
      eM = ing.deSalmonids;
    }

    return eM;
  }

  void toggle(bool bool) {
    state = state.copyWith(toggle: bool);
  }
}

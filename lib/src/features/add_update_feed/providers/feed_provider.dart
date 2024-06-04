import 'dart:async';

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/router/routes.dart';

import 'package:feed_estimator/src/features/add_update_feed/repository/animal_type_repository.dart';

import 'package:feed_estimator/src/features/add_update_feed/model/animal_type.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';

import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_provider.freezed.dart';

final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier(ref);
});

@freezed
class FeedState with _$FeedState {
  factory FeedState({
    @Default("") String feedName,
    @Default(1) num animalTypeId,
    @Default([]) List<AnimalTypes> animalTypes,
    @Default([]) List<FeedIngredients> feedIngredients,
    @Default(0.0) num totalQuantity,
    Feed? newFeed,
    @Default("") String message,
    @Default("") String status,
  }) = _FeedState;

  const FeedState._();

  // calcPercent(double quantity) {}
}

class FeedNotifier extends StateNotifier<FeedState> {
  Ref ref;
  FeedNotifier(this.ref) : super(FeedState()) {
    resetProvider();
    loadAnimalTypes();
  }

  num? _feedId;
  num _totalQuantity = 0.0;

  Future<void> resetProvider() async {
    state = state.copyWith(
        newFeed: Feed(), animalTypeId: 1, feedName: "", feedIngredients: []);
    _feedId = null;
    _totalQuantity = 0.0;
  }

  loadAnimalTypes() async {
    final animals = await ref.watch(animalTypeRepository).getAll();
    state = state.copyWith(animalTypes: animals);
  }

  setFeed(Feed feed) {
    resetProvider();
    _feedId = feed.feedId;

    final animalTypeId = feed.animalId as num;
    final ingList = feed.feedIngredients as List<FeedIngredients>;
    final name = feed.feedName as String;

    state = state.copyWith(
      newFeed: feed,
      animalTypeId: animalTypeId,
      feedIngredients: ingList,
      feedName: name,
    );
    updateQuantity();
  }

  setNewFeed() {
    // final feedIngList = state.feedIngredients;
    // final List<FeedIngredients> newList = [];
    //
    // //_feedId = currentTimeInSecond();
    // for (var ing in feedIngList) {
    //   final inge = FeedIngredients(
    //       //  feedId: _feedId,
    //       ingredientId: ing.ingredientId,
    //       priceUnitKg: ing.priceUnitKg,
    //       quantity: ing.quantity);
    //
    //   newList.add(inge);
    // }
    //
    // state = state.copyWith(feedIngredients: newList);
    final newFeed = Feed(
        // feedId: _feedId,
        feedName: state.feedName,
        animalId: state.animalTypeId,
        feedIngredients: state.feedIngredients,
        timestampModified: currentTimeInSecond());

    // _newFeed = newFeed;
    state = state.copyWith(newFeed: newFeed);
  }

  deleteFeed(num feedId) async {
    await ref.watch(feedRepository).delete(feedId);
    await ref.watch(feedIngredientRepository).delete(feedId);
  }

  Future<String> saveUpdateFeed({required String todo}) async {
    if (state.feedName != "" &&
        state.animalTypeId != 0 &&
        state.feedIngredients.isNotEmpty &&
        state.totalQuantity != 0) {
      if (_feedId == null) {
        await setNewFeed();
      }
      final newFeed = state.newFeed;

      if (newFeed == Feed()) {
        state =
            state.copyWith(message: 'Ensure Feed Details is entered correctly');
        state = state.copyWith(status: 'failure');
      }

      final bool available = await (todo == "save"
          ? checkFeedByName(newFeed!.feedName)
          : checkFeedById(newFeed!.feedId));

      if (available && todo == "save") {
        state = state.copyWith(
            message: 'Saving New Feed: Feed With Same Name already existed');
        state = state.copyWith(status: 'failure');
        return 'failure';
      } else if (!available && todo == "save") {
        await saveNewFeed();
        return 'success';
      } else if (!available && todo == "update") {
        state = state.copyWith(message: 'Updating New Feed Not Possible!');
        state = state.copyWith(status: 'failure');
        return 'failure';
      } else {
        await updateFeed();
        return 'success';
      }
    } else {
      state =
          state.copyWith(message: 'Ensure Feed Details is entered correctly');
      state = state.copyWith(status: 'failure');
      return 'failure';
    }
  }

  saveNewFeed() async {
    var feed = state.newFeed;
    feed = Feed(
      // feedId: feed!.feedId,
      feedName: feed!.feedName,
      animalId: feed.animalId,
      timestampModified: feed.timestampModified,
    );

    _feedId = await ref.watch(feedRepository).create(feed.toJson());

    final list = [];
    for (var ing in state.feedIngredients) {
      ing = ing.copyWith(feedId: _feedId);
      list.add(ing);
    }

    list
        .map((e) async =>
            await ref.watch(feedIngredientRepository).create(e.toJson()))
        .toList();

    state = state.copyWith(
        message: '${state.newFeed!.feedName} successfully saved');
    resetProvider();
    // ref.read(asyncMainProvider.notifier).loadFeed();
    state = state.copyWith(status: 'success');
    const HomeRoute().location;
  }

  updateFeed() async {
    var feed = state.newFeed;
    feed = Feed(
      feedId: feed!.feedId,
      feedName: feed.feedName,
      animalId: feed.animalId,
      timestampModified: feed.timestampModified,
    );

    //debugPrint(feed.toJson().toString());

    List<FeedIngredients> feedIngredients = state.feedIngredients;
    final existingIngredients =
        await ref.read(feedIngredientRepository).getSingle(feed.feedId as int);

    for (var i in feedIngredients) {
      existingIngredients
          .removeWhere((element) => element!.ingredientId == i.ingredientId);
    }

    for (var i in existingIngredients) {
      await ref.read(feedIngredientRepository).deleteByIngredientId(
          feedId: feed.feedId as num, ingredientId: i!.ingredientId as num);
    }

    final list = state.feedIngredients
        .map((e) async => {
              if (e.id == null)
                {await ref.watch(feedIngredientRepository).create(e.toJson())}
              else
                {
                  await ref
                      .watch(feedIngredientRepository)
                      .update(e.toJson(), e.id as num)
                }
            })
        .toList();

    //  debugPrint(list.toString());

    if (list.isNotEmpty && list.length == state.feedIngredients.length) {
      state = state.copyWith(
          message: '${state.newFeed!.feedName} successfully updated');
      resetProvider();
      //   ref.read(asyncMainProvider.notifier).loadFeed();
      state = state.copyWith(status: 'success');
      const HomeRoute().location;
    } else {
      state = state.copyWith(status: 'failure');
    }
  }

  /// add all selected ingredients
  ///
  ///
  addSelectedIngredients(List<FeedIngredients> ingredients) {
    if (_feedId != null) {
      for (var ing in ingredients) {
        if (!available(ing)) {
          final newIng = ing.copyWith(feedId: _feedId);
          state = state
              .copyWith(feedIngredients: [...state.feedIngredients, newIng]);
        }
      }
    } else {
      for (var ing in ingredients) {
        if (!available(ing)) {
          state =
              state.copyWith(feedIngredients: [...state.feedIngredients, ing]);
        }
      }
    }

    updateQuantity();

    // debugPrint(state.feedIngredients.map((e) => e.toJson().toString()).toList().toString());
  }

  removeIng(num? i) {
    List<FeedIngredients> feedIngredients = state.feedIngredients;
    final avail = feedIngredients.firstWhere(
        (element) => element.ingredientId == i,
        orElse: () => FeedIngredients());
    if (avail != FeedIngredients()) {
      var newList = [
        for (final b in feedIngredients)
          if (b.ingredientId != i) b
      ];
      feedIngredients = newList;
    }
    state = state.copyWith(feedIngredients: feedIngredients);
    //   debugPrint('Local delete: - feedProvider - : feedIng length: ${state.feedIngredients.length}');
    updateQuantity();
  }

  void removeIngById(num? ingredientId) {
    List<FeedIngredients> feedIngredients = state.feedIngredients;

    var newList = [
      for (final b in feedIngredients)
        if (b.ingredientId != ingredientId) b
    ];
    // feedIngredients = newList;

    state = state.copyWith(feedIngredients: newList);

    updateQuantity();
  }

  setFeedName(String name) {
    state = state.copyWith(feedName: name);
  }

  setAnimalId(num id) {
    state = state.copyWith(animalTypeId: id);

    //  if (_totalQuantity != 0) {}
  }

  bool available(FeedIngredients i) {
    bool avail = false;
    if (state.feedIngredients.isNotEmpty) {
      avail =
          state.feedIngredients.any((e) => e.ingredientId == i.ingredientId);
    }
    return avail;
  }

  setPrice(num ingredientId, String? price) {
    final num? pce = double.tryParse(price!);

    List<FeedIngredients?> feedIngredients = state.feedIngredients;
    FeedIngredients? ing = feedIngredients.firstWhere(
        (element) => element?.ingredientId == ingredientId,
        orElse: () => FeedIngredients());

    ing = ing!.copyWith(priceUnitKg: pce);

    removeIngById(ingredientId);

    state = state.copyWith(feedIngredients: [...state.feedIngredients, ing]);
  }

  setQuantity(num ingredientId, String? quantity) {
    final num? qty = double.tryParse(quantity!);

    List<FeedIngredients?> feedIngredients = state.feedIngredients;
    FeedIngredients? ing = feedIngredients.firstWhere(
        (element) => element?.ingredientId == ingredientId,
        orElse: () => FeedIngredients());

    ing = ing!.copyWith(quantity: qty);

    removeIngById(ingredientId);
    state = state.copyWith(feedIngredients: [...state.feedIngredients, ing]);

    updateQuantity();
  }

  void updateQuantity() {
    List<FeedIngredients?> feedIngredients = state.feedIngredients;
    num? quantity = 0.0;
    for (var b in feedIngredients) {
      var qty = b?.quantity ?? 0.0;
      quantity = quantity! + qty;
    }
    _totalQuantity = quantity as num;
    state = state.copyWith(totalQuantity: _totalQuantity);

    if (state.totalQuantity > 0) {
      ref.read(resultProvider.notifier).estimatedResult(
          animal: state.animalTypeId, ingList: state.feedIngredients);
    } else {
      ref.read(resultProvider.notifier).resetResult();
    }
  }

  calcPercent(num? quantity) {
    var qty = quantity ?? 0.0;
    return (qty / _totalQuantity) * 100;
  }

  Future<bool> checkFeedByName(String? feedName) async {
    bool available = false;
    final feed = await ref.watch(feedRepository).getSingleByName(feedName);
    if (feed != null) {
      available = true;
    }

    return available;
  }

  Future<bool> checkFeedById(num? feedId) async {
    bool available = false;
    final db = ref.watch(appDatabase);
    final feed = await db.selectByParam(
      FeedRepository.tableName,
      query: 'feed_id',
      param: feedId,
    );
    if (feed.isNotEmpty) {
      available = true;
    }

    return available;
  }

  analyse() async {
    if (state.feedName != "" &&
        state.animalTypeId != 0 &&
        state.feedIngredients.isNotEmpty &&
        state.totalQuantity != 0) {
      if (_feedId == null) {
        await setNewFeed();
      }
      var feed = state.newFeed;
      if (feed!.feedId == null) {
        feed = state.newFeed!.copyWith(feedId: 9999);
      } else {
        final ingList = state.feedIngredients;
        final feed = state.newFeed!.copyWith(feedIngredients: ingList);
        state = state.copyWith(newFeed: feed);
      }

      await ref
          .read(resultProvider.notifier)
          .estimatedResult(feed: state.newFeed);

      ViewFeedReportRoute(feed.feedId as int, "estimate");
    }
  }
}

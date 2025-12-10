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

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedProvider =
    NotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);

sealed class FeedState {
  const FeedState({
    this.feedName = "",
    this.animalTypeId = 1,
    this.animalTypes = const [],
    this.feedIngredients = const [],
    this.totalQuantity = 0.0,
    this.newFeed,
    this.message = "",
    this.status = "",
  });

  final String feedName;
  final num animalTypeId;
  final List<AnimalTypes> animalTypes;
  final List<FeedIngredients> feedIngredients;
  final num totalQuantity;
  final Feed? newFeed;
  final String message;
  final String status;

  FeedState copyWith({
    String? feedName,
    num? animalTypeId,
    List<AnimalTypes>? animalTypes,
    List<FeedIngredients>? feedIngredients,
    num? totalQuantity,
    Feed? newFeed,
    String? message,
    String? status,
  }) =>
      _FeedState(
        feedName: feedName ?? this.feedName,
        animalTypeId: animalTypeId ?? this.animalTypeId,
        animalTypes: animalTypes ?? this.animalTypes,
        feedIngredients: feedIngredients ?? this.feedIngredients,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        newFeed: newFeed ?? this.newFeed,
        message: message ?? this.message,
        status: status ?? this.status,
      );
}

class _FeedState extends FeedState {
  const _FeedState({
    super.feedName = "",
    super.animalTypeId = 1,
    super.animalTypes = const [],
    super.feedIngredients = const [],
    super.totalQuantity = 0.0,
    super.newFeed,
    super.message = "",
    super.status = "",
  });
}

class FeedNotifier extends Notifier<FeedState> {
  @override
  FeedState build() {
    // Initialize internal state
    _feedId = null;
    _totalQuantity = 0.0;

    // Start loading animal types asynchronously after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnimalTypes();
    });

    // Return initial state immediately
    return const _FeedState();
  }

  num? _feedId;
  num _totalQuantity = 0.0;

  Future<void> resetProvider() async {
    _feedId = null;
    _totalQuantity = 0.0;
    state = const _FeedState();
    // Refresh animal types when resetting to keep dropdown up to date
    await _loadAnimalTypes();
  }

  Future<void> _loadAnimalTypes() async {
    try {
      final animals = await ref.read(animalTypeRepository).getAll();
      if (state case var s) {
        state = s.copyWith(animalTypes: animals);
      }
    } catch (e) {
      // Log error but don't crash; UI will show empty dropdown
      debugPrint('Error loading animal types: $e');
    }
  }

  void setFeed(Feed feed) {
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

  void setNewFeed() {
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

  Future<void> deleteFeed(num feedId) async {
    await ref.watch(feedRepository).delete(feedId);
    await ref.watch(feedIngredientRepository).delete(feedId);
  }

  Future<String> saveUpdateFeed({required String todo}) async {
    if (state.feedName != "" &&
        state.animalTypeId != 0 &&
        state.feedIngredients.isNotEmpty &&
        state.totalQuantity != 0) {
      if (_feedId == null) {
        setNewFeed();
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

  Future<void> saveNewFeed() async {
    var feed = state.newFeed;
    feed = Feed(
      // feedId: feed!.feedId,
      feedName: feed!.feedName,
      animalId: feed.animalId,
      timestampModified: feed.timestampModified,
    );

    _feedId = await ref.watch(feedRepository).create(feed.toJson());

    final futures = state.feedIngredients.map((ing) async {
      final withFeedId = ing.copyWith(feedId: _feedId);
      await ref.watch(feedIngredientRepository).create(withFeedId.toJson());
    }).toList();
    await Future.wait(futures);

    state = state.copyWith(
        message: '${state.newFeed!.feedName} successfully saved');
    resetProvider();
    // ref.read(asyncMainProvider.notifier).loadFeed();
    state = state.copyWith(status: 'success');
    const HomeRoute().location;
  }

  Future<void> updateFeed() async {
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
          .removeWhere((element) => element.ingredientId == i.ingredientId);
    }

    for (var i in existingIngredients) {
      await ref.read(feedIngredientRepository).deleteByIngredientId(
          feedId: feed.feedId as num, ingredientId: i.ingredientId as num);
    }

    final futures = state.feedIngredients.map((e) async {
      if (e.id == null) {
        await ref.watch(feedIngredientRepository).create(e.toJson());
      } else {
        await ref.watch(feedIngredientRepository).update(e.toJson(), e.id!);
      }
    }).toList();

    await Future.wait(futures);

    state = state.copyWith(
        message: '${state.newFeed!.feedName} successfully updated');
    resetProvider();
    //   ref.read(asyncMainProvider.notifier).loadFeed();
    state = state.copyWith(status: 'success');
    const HomeRoute().location;
  }

  /// add all selected ingredients
  ///
  ///
  void addSelectedIngredients(List<FeedIngredients> ingredients) {
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

  void removeIng(num? i) {
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

  void setFeedName(String name) {
    state = state.copyWith(feedName: name);
  }

  void setAnimalId(num id) {
    state = state.copyWith(animalTypeId: id);

    //  if (_totalQuantity != 0) {}
  }

  bool available(FeedIngredients i) {
    if (state.feedIngredients.isEmpty) return false;
    return state.feedIngredients.any((e) => e.ingredientId == i.ingredientId);
  }

  void setPrice(num ingredientId, String? price) {
    final num? parsedPrice = double.tryParse(price ?? '');
    if (parsedPrice == null) return;

    final updated = _updateIngredient(ingredientId, (ing) {
      return ing.copyWith(priceUnitKg: parsedPrice);
    });

    if (updated) {
      updateQuantity();
    }
  }

  void setQuantity(num ingredientId, String? quantity) {
    final num? parsedQty = double.tryParse(quantity ?? '');
    if (parsedQty == null) return;

    final updated = _updateIngredient(ingredientId, (ing) {
      return ing.copyWith(quantity: parsedQty);
    });

    if (updated) {
      updateQuantity();
    }
  }

  bool _updateIngredient(
    num ingredientId,
    FeedIngredients Function(FeedIngredients) updater,
  ) {
    final list = [...state.feedIngredients];
    final index = list.indexWhere((ing) => ing.ingredientId == ingredientId);
    if (index == -1) return false;

    final updated = updater(list[index]);
    list[index] = updated;
    state = state.copyWith(feedIngredients: list);
    return true;
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

  double calcPercent(num? quantity) {
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

  Timer? _analyseDebounceTimer;
  bool _isAnalysing = false;

  /// Immediate analysis for user-initiated actions (no debounce)
  Future<void> analyseImmediate() async {
    if (_isAnalysing) return; // Prevent concurrent analysis

    if (state.feedName.isEmpty ||
        state.animalTypeId == 0 ||
        state.feedIngredients.isEmpty ||
        state.totalQuantity == 0) {
      return;
    }

    _isAnalysing = true;
    try {
      // Create or update feed object efficiently
      if (_feedId == null) {
        setNewFeed();
      }

      // Ensure feed has proper ID (9999 for new feeds)
      final Feed feedToAnalyse;
      if (state.newFeed == null) {
        feedToAnalyse = Feed(
          feedId: 9999,
          feedName: state.feedName,
          animalId: state.animalTypeId,
          feedIngredients: state.feedIngredients,
        );
        state = state.copyWith(newFeed: feedToAnalyse);
      } else if (state.newFeed!.feedId == null) {
        feedToAnalyse = state.newFeed!.copyWith(feedId: 9999);
        state = state.copyWith(newFeed: feedToAnalyse);
      } else {
        feedToAnalyse = state.newFeed!.copyWith(
          feedIngredients: state.feedIngredients,
        );
        state = state.copyWith(newFeed: feedToAnalyse);
      }

      // Pre-calculate result before navigation
      await ref
          .read(resultProvider.notifier)
          .estimatedResult(feed: feedToAnalyse);
    } finally {
      _isAnalysing = false;
    }
  }

  /// Debounced analysis for auto-recalculation scenarios
  Future<void> analyse() async {
    // Cancel previous debounce timer if any
    _analyseDebounceTimer?.cancel();

    // Debounce analysis to prevent rapid redundant calls (300ms window)
    _analyseDebounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await analyseImmediate();
    });
  }
}

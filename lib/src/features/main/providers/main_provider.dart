import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_provider.freezed.dart';

final mainViewProvider =
    StateNotifierProvider<MainViewNotifier, MainViewState>((ref) {
  return MainViewNotifier(ref);
});

@freezed
class MainViewState with _$MainViewState {
  const factory MainViewState({
    @Default([]) List<Feed> feeds,
    @Default(0) int animalTypes,
    @Default([]) List<FeedIngredients> feedIngredients,
    // @Default(0.0) totalQuantity,
    // @Default(FeedModel) FeedModel newFeed,
  }) = _MainViewState;

  const MainViewState._();
}

class MainViewNotifier extends StateNotifier<MainViewState> {
  Ref ref;
  MainViewNotifier(this.ref) : super(const MainViewState()) {
    loadFeeds();
  }

  loadFeeds() async {
    final feedList = await ref.read(feedRepository).getAll();
    final ingList = await ref.watch(feedIngredientRepository).getAll();

    state = state.copyWith(feedIngredients: ingList);

    if (feedList.isNotEmpty) {
      for (var feed in feedList) {
        final feedIng = ingList.where((i) => i.feedId == feed.feedId).toList();
        feed = feed.copyWith(feedIngredients: feedIng);
        state = state.copyWith(feeds: [...state.feeds, feed]);
      }
    }
  }

  deleteFeed(num? feedId) async {
    await ref.watch(feedIngredientRepository).deleteByFeedId(feedId);
    await ref.watch(feedRepository).delete(feedId!);

    await loadFeeds();
    state = state;
  }
}

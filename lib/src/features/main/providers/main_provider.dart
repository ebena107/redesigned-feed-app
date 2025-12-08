import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/repository/feed_ingredient_repository.dart';
import 'package:feed_estimator/src/features/main/repository/feed_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainViewProvider =
    NotifierProvider<MainViewNotifier, MainViewState>(MainViewNotifier.new);

sealed class MainViewState {
  const MainViewState({
    this.feeds = const [],
    this.animalTypes = 0,
    this.feedIngredients = const [],
  });

  final List<Feed> feeds;
  final int animalTypes;
  final List<FeedIngredients> feedIngredients;

  MainViewState copyWith({
    List<Feed>? feeds,
    int? animalTypes,
    List<FeedIngredients>? feedIngredients,
  }) =>
      _MainViewState(
        feeds: feeds ?? this.feeds,
        animalTypes: animalTypes ?? this.animalTypes,
        feedIngredients: feedIngredients ?? this.feedIngredients,
      );

  const MainViewState._(
      {required this.feeds,
      required this.animalTypes,
      required this.feedIngredients});
}

class _MainViewState extends MainViewState {
  const _MainViewState({
    super.feeds = const [],
    super.animalTypes = 0,
    super.feedIngredients = const [],
  }) : super._(
          feeds: feeds,
          animalTypes: animalTypes,
          feedIngredients: feedIngredients,
        );
}

class MainViewNotifier extends Notifier<MainViewState> {
  @override
  MainViewState build() {
    loadFeeds();
    return const _MainViewState();
  }

  Future<void> loadFeeds() async {
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

  Future<void> deleteFeed(num? feedId) async {
    await ref.watch(feedIngredientRepository).deleteByFeedId(feedId);
    await ref.watch(feedRepository).delete(feedId!);

    await loadFeeds();
    state = state;
  }
}

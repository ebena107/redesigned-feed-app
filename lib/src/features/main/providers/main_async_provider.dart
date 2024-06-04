import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/feed_ingredient_repository.dart';
import '../repository/feed_repository.dart';

part 'main_async_provider.g.dart';

@riverpod
class AsyncMain extends _$AsyncMain {
  Future<List<Feed>> loadFeed() async {
    final List<Feed> newFeedList = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ingList = await ref.read(feedIngredientRepository).getAll();
      final feedList = await ref.read(feedRepository).getAll();

      //debugPrint('feedList - ${feedList.length.toString()}');
      //debugPrint('ingList - ${ingList.length.toString()}');

      if (feedList.isNotEmpty) {
        for (var feed in feedList) {
          final feedIng =
              ingList.where((i) => i.feedId == feed.feedId).toList();
          feed = feed.copyWith(feedIngredients: feedIng);
          newFeedList.add(feed);
        }
      }

      ref.read(resultProvider.notifier).setFeed(newFeedList);
      return newFeedList;
    });
    return newFeedList;
  }

  Future<void> deleteFeed(num? feedId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(feedIngredientRepository).deleteByFeedId(feedId as int);
      await ref.read(feedRepository).delete(feedId);
      return loadFeed();
    });
  }

  Future<void> deleteFeedIngredient(num? feedId, num? ingredientId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(feedIngredientRepository).deleteByIngredientId(
          feedId: feedId as num, ingredientId: ingredientId as num);

      return loadFeed();
    });
  }

//required VoidCallback Function() onSuccess, required VoidCallback Function() onFailure
  Future<void> saveUpdateFeed(
      {required String todo, required ValueChanged<String> onSuccess}) async {
     String? response;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      response =
          await ref.read(feedProvider.notifier).saveUpdateFeed(todo: todo);

      onSuccess(response!);
      // if (response == 'success') {
      //   const HomeRoute().location;
      // }
      return loadFeed();
    });

    // debugPrint(state.value!.first.feedIngredients.toString());

    if (state.hasError == false && response == 'success') {
      //  debugPrint('saving complete');
      //  await ref.read(asyncMainProvider.notifier).loadFeed();
      // await ref.read(resultProvider.notifier).setFeed();

      const HomeRoute().location;
    }
  }

  @override
  FutureOr<List<Feed>> build() async {
    return await loadFeed();
  }
}

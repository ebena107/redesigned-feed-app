import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/feed_ingredient_repository.dart';
import '../repository/feed_repository.dart';

part 'main_async_provider.g.dart';

/// Async provider for loading and managing feeds from repository
/// Handles loading, deletion, and updates with automatic state management
@riverpod
class AsyncMain extends _$AsyncMain {
  /// Load all feeds with their associated ingredients
  Future<List<Feed>> loadFeed() async {
    final List<Feed> newFeedList = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ingList = await ref.read(feedIngredientRepository).getAll();
      final feedList = await ref.read(feedRepository).getAll();

      // Merge ingredients into feeds
      if (feedList.isNotEmpty) {
        for (var feed in feedList) {
          final feedIng =
              ingList.where((i) => i.feedId == feed.feedId).toList();
          feed = feed.copyWith(feedIngredients: feedIng);
          newFeedList.add(feed);
        }
      }

      // Update result provider with loaded feeds
      ref.read(resultProvider.notifier).setFeed(newFeedList);
      return newFeedList;
    });
    return newFeedList;
  }

  /// Delete a single feed by ID
  Future<void> deleteFeed(num? feedId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(feedIngredientRepository).deleteByFeedId(feedId as int);
      await ref.read(feedRepository).delete(feedId);
      // Reload feeds after deletion
      return loadFeed();
    });
  }

  /// Delete ingredient from a specific feed
  Future<void> deleteFeedIngredient(num? feedId, num? ingredientId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(feedIngredientRepository).deleteByIngredientId(
          feedId: feedId as num, ingredientId: ingredientId as num);
      // Reload feeds after deletion
      return loadFeed();
    });
  }

  /// Save or update a feed and reload the list
  Future<void> saveUpdateFeed({
    required String todo,
    required ValueChanged<String> onSuccess,
  }) async {
    String? response;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      response =
          await ref.read(feedProvider.notifier).saveUpdateFeed(todo: todo);
      onSuccess(response!);
      return loadFeed();
    });
    // Navigation is handled by the caller (onSuccess callback)
  }

  @override
  FutureOr<List<Feed>> build() async {
    return await loadFeed();
  }
}

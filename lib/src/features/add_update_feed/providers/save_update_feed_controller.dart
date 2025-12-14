import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'feed_provider.dart';

part 'save_update_feed_controller.g.dart';

@riverpod
class SaveUpdateFeedController extends _$SaveUpdateFeedController {
  Object? key;

  @override
  FutureOr<void> build() async {
    return null;

    // key = Object();
    // ref.onDispose(() => key = null);
  }

  Future<void> saveUpdateFeed({
    required String todo,
    required ValueChanged<String> onSuccess,
  }) async {
    final provider = ref.read(feedProvider.notifier);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => provider.saveUpdateFeed(todo: todo));
    //
    // if (key == this.key) {
    //   state = newState;
    //   ref.read(routerProvider).pop();
    //
    // }

    debugPrint('finished ${state.hasValue.toString()}');

    if (state.hasError == false) {
      onSuccess('Success');
      // ref.read(asyncMainProvider.notifier).loadFeed();
      // ref.read(resultProvider.notifier).setFeed();

      const HomeRoute().location;
    }
  }
}

// class SaveUpdateFeedController extends AutoDisposeAsyncNotifier<void> {
//   @override
//   Future<void> build() {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//   Future<void> saveUpdateFeed({required String todo}) async {
//     final provider = ref.read(feedProvider.notifier);
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() => provider.saveUpdateFeed(todo));
//
//     if (state.hasError == false) {
//       ref.read(routerProvider).pop();
//     }
//   }
//
//   Future<void> updateFeed() async {}
// }
//
// final saveUpdateFeedControllerProvider =
// AutoDisposeAsyncNotifierProvider<SaveUpdateFeedController, void>(
//     SaveUpdateFeedController.new);

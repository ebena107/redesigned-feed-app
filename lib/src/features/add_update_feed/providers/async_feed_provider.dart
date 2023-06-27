import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/router.dart';
import '../../main/providers/main_async_provider.dart';
import '../../reports/providers/result_provider.dart';
import 'feed_provider.dart';

part 'async_feed_provider.g.dart';

@riverpod
class AsyncFeed extends _$AsyncFeed {
  @override
  FutureOr<void> build() async {}

  Future<void> saveUpdateFeed({required String todo}) async {
    final provider = ref.read(feedProvider.notifier);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => provider.saveUpdateFeed(todo: todo));

    if (state.hasError == false) {
      //  debugPrint('saving complete');
      await ref.read(asyncMainProvider.notifier).loadFeed();
      // await ref.read(resultProvider.notifier).setFeed();

      ref.read(routerProvider).go('/');
    }
  }

  Future<void> deleteIngredient(
    num? ingredientId,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await ref.read(feedProvider.notifier).removeIng(ingredientId),);

    if (state.hasError == false) {
      //  debugPrint('finished delete');
      // await ref.read(asyncMainProvider.notifier).loadFeed();
      await ref.read(resultProvider.notifier).estimatedResult(
          animal: ref.watch(feedProvider).animalTypeId,
          ingList: ref.watch(feedProvider).feedIngredients);
      return;
    }
  }
}

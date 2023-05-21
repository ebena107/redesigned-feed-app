import 'package:feed_estimator/src/core/router/router.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_save_controller.g.dart';

@riverpod
class IngredientSaveController extends _$IngredientSaveController {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<void> saveUpdateIngredient(int? ingId) async {
    final provider = ref.watch(ingredientProvider.notifier);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => provider.saveUpdateIngredient(ingId));

    if (state.hasError == false) {
      ref.read(routerProvider).pop();
    }
  }

  Future<void> updateFeed() async {}
// }
}
// Future<void> saveUpdateFeed({required String todo}) async {
//   final provider = ref.read(ingredientProviderProvider.notifier);
//   state = const AsyncLoading();
//   final key = this.key;
//   final newState =
//   await AsyncValue.guard(() => provider.saveUpdateFeed(todo:todo,));
//
//   if (key == this.key) {
//     state = newState;
//     ref.read(routerProvider).pop();
//
//   }
//
//   if (state.hasError == false) {
//     ref.read(mainViewProvider.notifier).loadFeeds();
//
//     ref.read(routerProvider).go('/');
//
//   }
// }

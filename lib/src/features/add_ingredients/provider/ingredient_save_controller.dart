import 'package:feed_estimator/src/core/router/router.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_save_controller.g.dart';

@riverpod
class IngredientSaveController extends _$IngredientSaveController {
  @override
  FutureOr<void> build() {

  }

  Future<void> saveIngredient({
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final ingredient = ref.read(ingredientProvider).newIngredient;
    final repo = ref.read(ingredientsRepository);

    state = const AsyncLoading();

    try {
      await repo.create(ingredient!.toJson());
      state = const AsyncData(null);
    } catch (e, st) {
      onFailure;
      state = AsyncError(e, st);
    }

    if (state.hasError == false) {

      onSuccess;
      debugPrint('finished');
      //ref.read(routerProvider).pop();
    } else {
      onFailure;
    }

  }

  Future<void> updateIngredient(
    int? ingId, {
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    final ingredient = ref.read(ingredientProvider).newIngredient;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      if (ingredient != Ingredient()) {
        await ref
            .read(ingredientsRepository)
            .update(ingredient!.toJson(), ingId as num);
      }
    });

    if (state.hasError == false) {
      onSuccess;
      ref.read(routerProvider).pop();
    } else {
      onFailure;
    }
  }
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

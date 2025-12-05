import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/async_stored_ingredient.dart';

import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSSelectWidget extends ConsumerWidget {
  const IngredientSSelectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(asyncStoredIngredientsProvider);
    final provider = ref.watch(storeIngredientProvider);
    return data.when(
        data: (ingredients) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 40,
              decoration: BoxDecoration(
                //   color: AppConstants.appBackgroundColor.withOpacity(.6),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                    style: BorderStyle.solid,
                    width: 0.80,
                    color: AppConstants.appHintColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<num>(
                  alignment: AlignmentDirectional.center,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  isDense: true,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: AppConstants.appBackgroundColor,
                  ),
                  hint: Text(
                    "Select Ingredient to Update",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppConstants.appBackgroundColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  // disabledHint:Text("Disabled"),
                  elevation: 8,
                  value: provider.selectedIngredient?.ingredientId,
                  dropdownColor:
                      AppConstants.appIconGreyColor.withValues(alpha: .8),
                  items: ingredients.map((Ingredient ing) {
                    return DropdownMenuItem<num>(
                      alignment: AlignmentDirectional.center,
                      value: ing.ingredientId,
                      child: Text(
                        ing.name.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppConstants.appBackgroundColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  //  value: cat.categoryId,
                  onChanged: (id) => ref
                      .read(storeIngredientProvider.notifier)
                      .setIngredient(id),

                  //   child: Text(cat.category.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
                ),
              ),
            ),
        error: (e, stack) => Text(e.toString()),
        loading: () => const CircularProgressIndicator());
  }
}

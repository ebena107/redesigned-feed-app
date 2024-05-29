import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredients_list_tile_widget.dart';

class IngredientData extends ConsumerWidget {
  final String? feedId;
  const IngredientData({
    super.key,
    this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    List<Ingredient>? ingredients = data.filteredIngredients;

    return ingredients.isNotEmpty
        ? SizedBox(
            // child: ListView(
            //   shrinkWrap: true,
            //   children: ingredients.map((i) {
            //     final isSelected = data.selectedIngredients.contains(i);
            //     return IngredientListTileWidget(
            //         ingredients: i,
            //         isSelected: isSelected,
            //         onSelectedIngredient: selectIngredient);
            //   }).toList(),
            // ),
            child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      endIndent: 20,
                      indent: 20,
                    ),
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return ingredients.isNotEmpty
                      ? IngredientListTileWidget(
                          ingredient: ingredients[index],
                          isSelected: data.selectedIngredients.any((element) =>
                              element.ingredientId ==
                              ingredients[index].ingredientId),
                        )
                      : const SizedBox();
                }),
          )
        : const Center(
            child: Text('empty ingredients db'),
          );
  }
}

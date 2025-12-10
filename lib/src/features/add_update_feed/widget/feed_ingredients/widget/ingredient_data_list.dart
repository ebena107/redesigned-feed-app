import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredients_list_tile_widget.dart';

class IngredientData extends ConsumerWidget {
  final int? feedId;
  const IngredientData({
    super.key,
    this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    List<Ingredient>? ingredients = data.filteredIngredients;

    return ingredients.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return IngredientListTileWidget(
                ingredient: ingredients[index],
                isSelected: data.selectedIngredients.any(
                  (element) =>
                      element.ingredientId == ingredients[index].ingredientId,
                ),
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ingredients match your search',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
  }
}

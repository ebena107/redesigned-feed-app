import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredients_list_tile_widget.dart';

/// Optimized ingredient list with efficient rendering
///
/// Uses ListView.builder for lazy loading and better performance
/// with large ingredient lists (165+ items)
class IngredientData extends ConsumerWidget {
  final int? feedId;
  const IngredientData({
    super.key,
    this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final ingredients = data.filteredIngredients;

    if (ingredients.isEmpty) {
      return _buildEmptyState(context);
    }

    // Use ListView.builder directly (no ScrollView wrapper)
    // This enables efficient lazy loading and recycling of list items
    return ListView.builder(
      // Remove shrinkWrap and NeverScrollableScrollPhysics for better performance
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: ingredients.length,
      // Add item extent hint for better scroll performance estimation
      itemExtent: 72.0, // Approximate height of ingredient tile
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return IngredientListTileWidget(
          ingredient: ingredient,
          isSelected: data.selectedIngredients.any(
            (element) => element.ingredientId == ingredient.ingredientId,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
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
      ),
    );
  }
}

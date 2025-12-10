import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/utils/widgets/get_ingredients_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportIngredientList extends ConsumerWidget {
  final Feed? feed;

  const ReportIngredientList({
    super.key,
    this.feed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(
                    'Ingredient',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Quantity',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Percent',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Ingredient Cards List
          ResultIngredientList(feed: feed),
        ],
      ),
    );
  }
}

class ResultIngredientList extends ConsumerWidget {
  final Feed? feed;

  const ResultIngredientList({
    this.feed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedIngredients = feed?.feedIngredients;

    if (feedIngredients == null || feedIngredients.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No ingredients found',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Column(
      children: feedIngredients.map((ingredient) {
        final percent = calculatePercent(ingredient.quantity);
        final ingredientData =
            ref.watch(ingredientProvider).ingredients.firstWhere(
                  (ing) => ing.ingredientId == ingredient.ingredientId,
                  orElse: () => Ingredient(),
                );

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Category Icon
                Icon(
                  _getCategoryIcon(ingredientData.categoryId, ref),
                  size: 20,
                  color: Colors.deepPurple.shade300,
                ),
                const SizedBox(width: 8),
                // Ingredient Name
                Expanded(
                  flex: 4,
                  child: GetIngredientName(
                    id: ingredient.ingredientId,
                    color: Colors.black87,
                  ),
                ),
                // Quantity
                Expanded(
                  flex: 2,
                  child: Text(
                    ingredient.quantity?.toStringAsFixed(2) ?? '0.00',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Percent
                Expanded(
                  flex: 2,
                  child: Text(
                    '${percent.toStringAsFixed(1)}%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  num calculateTotalQuantity() {
    final total = feed!.feedIngredients!
        .fold(0, (num sum, ingredient) => sum + (ingredient.quantity as num));
    return total;
  }

  num calculatePercent(num? ingQty) {
    final total = calculateTotalQuantity();

    if (ingQty == 0 || total == 0) {
      return 0;
    } else {
      return 100 * (ingQty! / total);
    }
  }

  IconData _getCategoryIcon(num? categoryId, WidgetRef ref) {
    if (categoryId == null) return Icons.category;

    final categories = ref.watch(ingredientProvider).categoryList;
    final category = categories.firstWhere(
      (cat) => cat.categoryId == categoryId,
      orElse: () => IngredientCategory(),
    );

    final categoryName = category.category?.toLowerCase() ?? '';

    // Grain categories
    if (categoryName.contains('cereal') ||
        categoryName.contains('grain') ||
        categoryName.contains('rice') ||
        categoryName.contains('maize') ||
        categoryName.contains('corn') ||
        categoryName.contains('wheat') ||
        categoryName.contains('barley') ||
        categoryName.contains('oats')) {
      return Icons.grain;
    }
    // Oil/Fat categories
    else if (categoryName.contains('oil') ||
        categoryName.contains('fat') ||
        categoryName.contains('lipid') ||
        categoryName.contains('palm') ||
        categoryName.contains('coconut')) {
      return Icons.opacity;
    }
    // Vitamin/Mineral categories
    else if (categoryName.contains('vitamin') ||
        categoryName.contains('mineral') ||
        categoryName.contains('supplement') ||
        categoryName.contains('trace') ||
        categoryName.contains('premix')) {
      return Icons.healing;
    }
    // Protein/Meat categories
    else if (categoryName.contains('protein') ||
        categoryName.contains('meat') ||
        categoryName.contains('fish') ||
        categoryName.contains('bone') ||
        categoryName.contains('blood') ||
        categoryName.contains('poultry') ||
        categoryName.contains('meal')) {
      return Icons.egg;
    }
    // Root/Tuber categories
    else if (categoryName.contains('root') ||
        categoryName.contains('tuber') ||
        categoryName.contains('yam') ||
        categoryName.contains('cassava') ||
        categoryName.contains('potato') ||
        categoryName.contains('sweet')) {
      return Icons.agriculture;
    }
    // Fruit/Vegetable categories
    else if (categoryName.contains('fruit') ||
        categoryName.contains('vegetable') ||
        categoryName.contains('legume') ||
        categoryName.contains('bean') ||
        categoryName.contains('pea') ||
        categoryName.contains('forage')) {
      return Icons.eco;
    }
    // Water/Liquid categories
    else if (categoryName.contains('water') ||
        categoryName.contains('liquid') ||
        categoryName.contains('molasses')) {
      return Icons.water_drop;
    }
    // Salt/Mineral categories
    else if (categoryName.contains('salt') || categoryName.contains('sodium')) {
      return Icons.grain;
    }
    // Feed additive categories
    else if (categoryName.contains('additive') ||
        categoryName.contains('binder') ||
        categoryName.contains('probiotic') ||
        categoryName.contains('enzyme') ||
        categoryName.contains('acidifier')) {
      return Icons.science;
    }
    // Default
    return Icons.category;
  }
}

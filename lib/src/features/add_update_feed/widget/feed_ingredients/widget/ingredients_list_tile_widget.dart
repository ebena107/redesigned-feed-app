import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientListTileWidget extends ConsumerWidget {
  final Ingredient? ingredient;
  final bool isSelected;
//  final ValueChanged<Ingredients> onSelectedIngredient;
  const IngredientListTileWidget({
    super.key,
    required this.ingredient,
    required this.isSelected,
    // required this.onSelectedIngredient
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = Theme.of(context).primaryColor;

    return ingredient != null
        ? Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: isSelected ? 4 : 0,
            color: isSelected
                ? selectedColor.withValues(alpha: 0.1)
                : Colors.transparent,
            child: ListTile(
              selected: isSelected,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? selectedColor : Colors.transparent,
                  width: 2,
                ),
              ),
              onTap: () => ref
                  .read(ingredientProvider.notifier)
                  .selectIngredient(ingredient!),
              leading: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: selectedColor,
                      size: 24,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: Colors.grey[400],
                      size: 24,
                    ),
              title: Text(
                ingredient!.name.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? selectedColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              subtitle: _buildSubtitle(context, ref, ingredient!),
              trailing: ingredient!.favourite == 1
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red[400],
                      size: 22,
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          )
        : const SizedBox();
  }

  Widget _buildSubtitle(
      BuildContext context, WidgetRef ref, Ingredient ingredient) {
    if (ingredient.categoryId == null) return const SizedBox();

    final data = ref.watch(ingredientProvider);
    final category = data.categoryList.firstWhere(
      (cat) => cat.categoryId == ingredient.categoryId,
      orElse: () => IngredientCategory(),
    );

    return Row(
      children: [
        Icon(
          _getCategoryIcon(category.category),
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            category.category ?? 'Unknown',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.category;

    final lower = category.toLowerCase();

    // Grain categories
    if (lower.contains('cereal') ||
        lower.contains('grain') ||
        lower.contains('rice') ||
        lower.contains('maize') ||
        lower.contains('corn') ||
        lower.contains('wheat') ||
        lower.contains('barley') ||
        lower.contains('oats')) {
      return Icons.grain;
    }
    // Oil/Fat categories
    else if (lower.contains('oil') ||
        lower.contains('fat') ||
        lower.contains('lipid') ||
        lower.contains('palm') ||
        lower.contains('coconut')) {
      return Icons.opacity;
    }
    // Vitamin/Mineral categories
    else if (lower.contains('vitamin') ||
        lower.contains('mineral') ||
        lower.contains('supplement') ||
        lower.contains('trace') ||
        lower.contains('premix')) {
      return Icons.healing;
    }
    // Protein/Meat categories
    else if (lower.contains('protein') ||
        lower.contains('meat') ||
        lower.contains('fish') ||
        lower.contains('bone') ||
        lower.contains('blood') ||
        lower.contains('poultry') ||
        lower.contains('meal')) {
      return Icons.egg;
    }
    // Root/Tuber categories
    else if (lower.contains('root') ||
        lower.contains('tuber') ||
        lower.contains('yam') ||
        lower.contains('cassava') ||
        lower.contains('potato') ||
        lower.contains('sweet')) {
      return Icons.agriculture;
    }
    // Fruit/Vegetable categories
    else if (lower.contains('fruit') ||
        lower.contains('vegetable') ||
        lower.contains('legume') ||
        lower.contains('bean') ||
        lower.contains('pea') ||
        lower.contains('forage')) {
      return Icons.eco;
    }
    // Water/Liquid categories
    else if (lower.contains('water') ||
        lower.contains('liquid') ||
        lower.contains('molasses')) {
      return Icons.water_drop;
    }
    // Salt/Mineral categories
    else if (lower.contains('salt') || lower.contains('sodium')) {
      return Icons.grain;
    }
    // Feed additive categories
    else if (lower.contains('additive') ||
        lower.contains('binder') ||
        lower.contains('probiotic') ||
        lower.contains('enzyme') ||
        lower.contains('acidifier')) {
      return Icons.science;
    }
    // Default
    return Icons.category;
  }
}

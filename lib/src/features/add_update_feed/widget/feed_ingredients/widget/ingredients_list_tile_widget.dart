import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
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
              subtitle: ingredient!.categoryId != null
                  ? Text(
                      'Category ID: ${ingredient!.categoryId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    )
                  : null,
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
}

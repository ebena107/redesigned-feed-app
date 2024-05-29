import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
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

    final style = isSelected
        ? TextStyle(
            fontSize: 18,
            color: selectedColor,
            fontWeight: FontWeight.bold,
          )
        : const TextStyle(fontSize: 18);
    return ingredient != null
        ? ListTile(
            tileColor: ingredient!.ingredientId! % 2 != 0 ? Colors.green : null,
            selected: isSelected,
            dense: true,
            onTap: () => ref
                .read(ingredientProvider.notifier)
                .selectIngredient(ingredient!),
            leading: isSelected
                ? Icon(Icons.shopping_bag_outlined,
                    color: selectedColor, size: 26)
                : null,
            title: Text(
              ingredient!.name.toString(),
              style: style,
            ),
            trailing: ingredient!.favourite == 1
                ? Icon(CupertinoIcons.heart_fill,
                    color: selectedColor, size: 26)
                : null,
          )
        : const SizedBox();
  }
}

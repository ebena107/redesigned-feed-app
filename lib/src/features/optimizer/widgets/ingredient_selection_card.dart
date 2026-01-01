import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimizer_provider.dart';
import '../../add_ingredients/provider/ingredients_provider.dart';

/// Card widget for selecting ingredients for optimization
class IngredientSelectionCard extends ConsumerWidget {
  const IngredientSelectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optimizerState = ref.watch(optimizerProvider);
    final ingredientsState = ref.watch(ingredientProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Ingredients',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => _showIngredientSelectionDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Select'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (optimizerState.selectedIngredientIds.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No ingredients selected.\nTap Select to choose ingredients.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: optimizerState.selectedIngredientIds.map((id) {
                  final ingredient = ingredientsState.ingredients
                      .firstWhere((ing) => ing.ingredientId == id);
                  final price = optimizerState.ingredientPrices[id] ?? 0.0;

                  return Chip(
                    avatar: CircleAvatar(
                      child: Text(
                          '${optimizerState.selectedIngredientIds.indexOf(id) + 1}'),
                    ),
                    label: Text(
                        '${ingredient.name} (\$${price.toStringAsFixed(2)}/kg)'),
                    onDeleted: () {
                      ref.read(optimizerProvider.notifier).removeIngredient(id);
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showIngredientSelectionDialog(
      BuildContext context, WidgetRef ref) async {
    final ingredientsState = ref.read(ingredientProvider);
    final optimizerState = ref.read(optimizerProvider);
    final selectedIds = Set<int>.from(optimizerState.selectedIngredientIds);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Ingredients'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ingredientsState.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredientsState.ingredients[index];
                final id = ingredient.ingredientId as int;
                final isSelected = selectedIds.contains(id);

                return CheckboxListTile(
                  title: Text(ingredient.name ?? 'Unknown'),
                  subtitle: Text(
                      'Price: \$${(ingredient.priceKg ?? 0.0).toStringAsFixed(2)}/kg'),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedIds.add(id);
                      } else {
                        selectedIds.remove(id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update optimizer state with selected ingredients
                for (final id in selectedIds) {
                  if (!optimizerState.selectedIngredientIds.contains(id)) {
                    final ingredient = ingredientsState.ingredients
                        .firstWhere((ing) => ing.ingredientId == id);
                    final price = (ingredient.priceKg ?? 0.0).toDouble();
                    ref
                        .read(optimizerProvider.notifier)
                        .addIngredient(id, price);
                  }
                }

                // Remove deselected ingredients
                for (final id in optimizerState.selectedIngredientIds) {
                  if (!selectedIds.contains(id)) {
                    ref.read(optimizerProvider.notifier).removeIngredient(id);
                  }
                }

                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';

/// Widget for selecting ingredients to include in formulation
class IngredientSelector extends ConsumerStatefulWidget {
  const IngredientSelector({super.key});

  @override
  ConsumerState<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends ConsumerState<IngredientSelector> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientProvider).ingredients;
    final formState = ref.watch(feedFormulatorProvider);
    final selectedIds = formState.input.selectedIngredientIds;

    final filtered = ingredients
        .where((ing) =>
            ing.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
            false)
        .toList();

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Ingredients',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: UIConstants.paddingMedium),
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search ingredients...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(UIConstants.paddingSmall),
              ),
            ),
            SizedBox(height: UIConstants.paddingMedium),
            Text(
              'Selected: ${selectedIds.length} ingredient${selectedIds.length != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: UIConstants.paddingSmall),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final ing = filtered[index];
                  final isSelected = selectedIds.contains(ing.ingredientId);

                  return CheckboxListTile(
                    title: Text(ing.name ?? 'Unknown'),
                    subtitle: Text(
                      'Protein: ${ing.crudeProtein?.toStringAsFixed(1) ?? 'N/A'}%',
                    ),
                    value: isSelected,
                    onChanged: (_) {
                      ref
                          .read(feedFormulatorProvider.notifier)
                          .toggleIngredientId(ing.ingredientId ?? index);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: UIConstants.paddingMedium),
            if (selectedIds.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(feedFormulatorProvider.notifier)
                      .setSelectedIngredientIds({});
                },
                child: const Text('Clear All'),
              ),
          ],
        ),
      ),
    );
  }
}

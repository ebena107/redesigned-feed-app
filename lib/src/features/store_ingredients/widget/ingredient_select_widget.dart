import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
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
    final categories = ref.watch(ingredientsCategoryProvider);
    return data.when(
        data: (ingredients) {
          final filtered = provider.filteredIngredients.isNotEmpty ||
                  provider.selectedCategoryId != null
              ? provider.filteredIngredients
              : ingredients;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              categories.when(
                data: (cats) {
                  final List<DropdownMenuItem<num?>> categoryItems = [
                    DropdownMenuItem<num?>(
                      value: null,
                      child: Text(
                        "All Categories",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppConstants.appBackgroundColor),
                      ),
                    ),
                    ...cats.map((IngredientCategory cat) {
                      return DropdownMenuItem<num?>(
                        value: cat.categoryId,
                        child: Text(
                          cat.category ?? '',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppConstants.appBackgroundColor,
                                  ),
                        ),
                      );
                    }).toList(),
                  ];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 0.80,
                        color: AppConstants.appHintColor,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<num?>(
                        alignment: AlignmentDirectional.center,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                        isDense: true,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.filter_alt,
                          color: AppConstants.appBackgroundColor,
                        ),
                        hint: Text(
                          "Filter by Category",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppConstants.appBackgroundColor),
                          textAlign: TextAlign.center,
                        ),
                        value: provider.selectedCategoryId,
                        dropdownColor:
                            AppConstants.appIconGreyColor.withValues(alpha: .8),
                        items: categoryItems,
                        onChanged: (id) => ref
                            .read(storeIngredientProvider.notifier)
                            .setCategory(id),
                      ),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: LinearProgressIndicator(),
                ),
                error: (e, _) => Text(
                  "Failed to load categories",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 40,
                decoration: BoxDecoration(
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
                    elevation: 8,
                    value: provider.selectedIngredient?.ingredientId,
                    dropdownColor:
                        AppConstants.appIconGreyColor.withValues(alpha: .8),
                    items: filtered.map((Ingredient ing) {
                      return DropdownMenuItem<num>(
                        alignment: AlignmentDirectional.center,
                        value: ing.ingredientId,
                        child: Text(
                          ing.name.toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppConstants.appBackgroundColor,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                    onChanged: (id) => ref
                        .read(storeIngredientProvider.notifier)
                        .setIngredient(id),
                  ),
                ),
              ),
            ],
          );
        },
        error: (e, stack) => Text(e.toString()),
        loading: () => const CircularProgressIndicator());
  }
}

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredient_category_repository.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/async_stored_ingredient.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSSelectWidget extends ConsumerStatefulWidget {
  const IngredientSSelectWidget({
    super.key,
  });

  @override
  ConsumerState<IngredientSSelectWidget> createState() =>
      _IngredientSSelectWidgetState();
}

class _IngredientSSelectWidgetState
    extends ConsumerState<IngredientSSelectWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final data = ref.watch(asyncStoredIngredientsProvider);
    final provider = ref.watch(storeIngredientProvider);
    final categories = ref.watch(ingredientsCategoryProvider);

    return data.when(
        data: (ingredients) {
          final filtered = provider.filteredIngredients.isNotEmpty ||
                  provider.selectedCategoryId != null
              ? provider.filteredIngredients
              : ingredients;

          // Further filter by search term if present
          final searchResults = _searchController.text.isNotEmpty
              ? filtered
                  .where((ing) => ing.name!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList()
              : filtered;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search ingredients by name...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              // Category filter
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
                    }),
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
              // Ingredients dropdown with search results count
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
                      "Select Ingredient (${searchResults.length} found)",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppConstants.appBackgroundColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    elevation: 8,
                    value: provider.selectedIngredient?.ingredientId,
                    dropdownColor:
                        AppConstants.appIconGreyColor.withValues(alpha: .8),
                    items: searchResults.map((Ingredient ing) {
                      final isFavourite = ing.favourite == 1;
                      return DropdownMenuItem<num>(
                        alignment: AlignmentDirectional.center,
                        value: ing.ingredientId,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ing.name.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppConstants.appBackgroundColor,
                                    ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isFavourite)
                              const Icon(Icons.star,
                                  color: Colors.orange, size: 16),
                          ],
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

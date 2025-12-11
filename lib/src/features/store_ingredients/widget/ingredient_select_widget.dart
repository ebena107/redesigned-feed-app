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
              const SizedBox(height: 12),

              // Filter chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilterChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('Favorites'),
                      ],
                    ),
                    selected: provider.showFavoritesOnly,
                    onSelected: (value) {
                      ref
                          .read(storeIngredientProvider.notifier)
                          .toggleFavoritesFilter();
                    },
                    selectedColor: Colors.orange.withValues(alpha: 0.2),
                    checkmarkColor: Colors.orange,
                  ),
                  FilterChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle, size: 16),
                        SizedBox(width: 4),
                        Text('Custom Only'),
                      ],
                    ),
                    selected: provider.showCustomOnly,
                    onSelected: (value) {
                      ref
                          .read(storeIngredientProvider.notifier)
                          .toggleCustomFilter();
                    },
                    selectedColor:
                        const Color(0xff87643E).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xff87643E),
                  ),
                  if (searchResults.length != filtered.length)
                    Chip(
                      label:
                          Text('${searchResults.length} of ${filtered.length}'),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Category filter
              categories.when(
                data: (cats) {
                  final List<DropdownMenuItem<num?>> categoryItems = [
                    const DropdownMenuItem<num?>(
                      value: null,
                      child: Text(
                        "All Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...cats.map((IngredientCategory cat) {
                      return DropdownMenuItem<num?>(
                        value: cat.categoryId,
                        child: Text(
                          cat.category ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }),
                  ];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        width: 1.5,
                        color: const Color(0xff87643E).withValues(alpha: 0.3),
                      ),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<num?>(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        isDense: true,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.filter_alt,
                          color: Color(0xff87643E),
                        ),
                        hint: const Text(
                          "Filter by Category",
                          style: TextStyle(
                            color: Color(0xff87643E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: provider.selectedCategoryId,
                        dropdownColor: const Color(0xff87643E),
                        selectedItemBuilder: (BuildContext context) {
                          return categoryItems.map((item) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.value == null
                                    ? "All Categories"
                                    : cats
                                            .firstWhere((c) =>
                                                c.categoryId == item.value)
                                            .category ??
                                        '',
                                style: const TextStyle(
                                  color: Color(0xff87643E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList();
                        },
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
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    width: 1.5,
                    color: const Color(0xff87643E).withValues(alpha: 0.3),
                  ),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<num>(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    isDense: true,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Color(0xff87643E),
                    ),
                    hint: Text(
                      "Select Ingredient (${searchResults.length} found)",
                      style: const TextStyle(
                        color: Color(0xff87643E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    elevation: 8,
                    value: provider.selectedIngredient?.ingredientId,
                    dropdownColor: const Color(0xff87643E),
                    menuMaxHeight: 400,
                    selectedItemBuilder: (BuildContext context) {
                      return searchResults.map((ing) {
                        final isFavourite = ing.favourite == 1;
                        final isCustom = ing.isCustom == 1;
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              if (isFavourite)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6.0),
                                  child: Icon(Icons.star,
                                      color: Colors.orange, size: 16),
                                ),
                              if (isCustom)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6.0),
                                  child: Icon(Icons.science,
                                      color: Colors.blue, size: 14),
                                ),
                              Expanded(
                                child: Text(
                                  ing.name.toString(),
                                  style: const TextStyle(
                                    color: Color(0xff87643E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    items: searchResults.map((Ingredient ing) {
                      final isFavourite = ing.favourite == 1;
                      final isCustom = ing.isCustom == 1;
                      return DropdownMenuItem<num>(
                        value: ing.ingredientId,
                        child: Row(
                          children: [
                            if (isFavourite)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.star,
                                    color: Colors.orange, size: 18),
                              ),
                            if (isCustom)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.science,
                                    color: Colors.lightBlueAccent, size: 16),
                              ),
                            Expanded(
                              child: Text(
                                ing.name.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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

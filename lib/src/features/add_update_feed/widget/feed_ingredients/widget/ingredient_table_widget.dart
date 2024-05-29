import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientDataTable extends ConsumerWidget {
  final int? feedId;
  const IngredientDataTable({super.key, this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = Theme.of(context).primaryColor;
    final data = ref.watch(ingredientProvider);
    final sort = data.sort;
    //final newFeed = ref.watch(feedProvider);
    //  if (feedId != null) data.loadFeedExistingIngredients(feedId!);
    // if (feedId == null) data.resetSelections();
    //List<Ingredients>    _selectedIngredients = data.selectedIngredients;
    List<Ingredient>? ingredients = data.filteredIngredients;

    available(Ingredient e) {
      return ref.watch(ingredientProvider.notifier).available(e);
    }
    /*  _isAvailable(IngredientData ingredient) {
      bool _available;

      IngredientData existingItem;

      if (_selectedIngredients != null && _selectedIngredients.length > 0) {
        existingItem = _selectedIngredients
            .firstWhere((e) => e?.name == ingredient.name, orElse: () => null);
        existingItem != null ? _available = true : _available = false;
      } else {
        _available = false;
      }

      return _available;
    }*/
/*
  _showSnackBar(context, message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }*/

    onSortColumn(int columnIndex, bool ascending) {
      if (columnIndex == 0) {
        if (ascending) {
          ingredients!.sort((a, b) => a.name!.compareTo(b.name.toString()));
          ingredients = ingredients!.reversed.toList();
        } else {
          ingredients!.sort((a, b) => b.name!.compareTo(a.name.toString()));
          ingredients = ingredients!.reversed.toList();
        }
      }
    }

    Future<void> onSelectedRow(bool selected, Ingredient ingredient) async => ref.read(ingredientProvider.notifier).selectIngredient(ingredient);
    return Container(
      color: AppConstants.mainAppColor.withOpacity(0.08),
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: 0,
        dataRowMinHeight: 40,
        showCheckboxColumn: true,
        columns: [
          DataColumn(
            label: const Text('SELECT FEED INGREDIENTS'),
            numeric: false,
            tooltip: 'ingredient name',
            onSort: (columnIndex, sortAscending) {
              onSortColumn(columnIndex, sortAscending);
              ref.read(ingredientProvider.notifier).toggleSort();
            },
          ),
        ],
        rows: ingredients!
            .map(
              (e) => DataRow(
                selected: available(e) ? true : false,
                onSelectChanged: (b) {
                  onSelectedRow(b!, e);
                },
                cells: [
                  DataCell(ListTile(
                    title: Text(e.name.toString()),
                    trailing: e.favourite as bool
                        ? Icon(CupertinoIcons.heart_fill,
                            color: selectedColor, size: 26)
                        : null,
                  )
                      // Row(
                      //   children: [
                      //     Text(e.name.toString()),
                      //   ],
                      // ),
                      ),
                ],
                color: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  // All rows will have the same selected color.
                  if (states.contains(MaterialState.selected)) {
                    return AppConstants.mainAppColor.withOpacity(0.5);
                  }
                  // Even rows will have a grey color.
                  if (e.ingredientId! % 2 != 0) {
                    return const Color(0xFFB2DFDB).withOpacity(0.7);
                  }

                  // Use default value for other states and odd rows.
                  return const Color(0xFFB2DFDB).withOpacity(0.1);
                }),
              ),
            )
            .toList(),
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          return AppConstants.mainAppColor
              .withOpacity(0.9); // Use the default value.
        }),
      ),
    );
  }
}

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient_category.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSortingWidget extends StatelessWidget {
  const IngredientSortingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Card(color: Colors.transparent, child: CategorySortField());
  }
}

class CategorySortField extends ConsumerWidget {
  const CategorySortField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final categories = data.categoryList;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      height: 40,
      decoration: BoxDecoration(
        //   color: AppConstants.appBackgroundColor.withOpacity(.6),
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
            "Sort By Group",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppConstants.appBackgroundColor,
                ),
            textAlign: TextAlign.center,
          ),
          // disabledHint:Text("Disabled"),
          elevation: 8,
          value: data.sortByCategory,
          dropdownColor: AppConstants.appIconGreyColor.withOpacity(.8),
          items: categories.map((IngredientCategory cat) {
            return DropdownMenuItem<num>(
              alignment: AlignmentDirectional.center,
              value: cat.categoryId,
              child: Text(
                cat.category.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppConstants.appBackgroundColor,
                    ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          //  value: cat.categoryId,
          onChanged: (id) =>
              ref.read(ingredientProvider.notifier).sortIngredientByCat(id),

          //   child: Text(cat.category.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
        ),
      ),
      //  color: AppConstants.appBackgroundColor.withOpacity(.6),
      //   child: DropdownButtonFormField(
      //     dropdownColor: AppConstants.appBackgroundColor.withOpacity(.6),
      //     items: categories.map((IngredientCategory cat) {
      //       return DropdownMenuItem<num>(
      //         value: cat.categoryId,
      //         child: Text(cat.category.toString(), style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
      //       );
      //     }).toList(),
      //     onChanged: (value) =>
      //         ref.read(ingredientProvider.notifier).sortIngredientByCat(value),
      //     decoration: const InputDecoration(
      //       isDense: true,
      //    isCollapsed: true,
      //    helperText: 'Sort Ingredients By Categories',
      //       helperStyle: TextStyle(
      //
      //         fontSize: 10
      //       ),
      //       // icon: Icons.filter_list),
      //       focusColor: AppConstants.appCarrotColor,
      //     ),
      //   ),
    );
  }
}

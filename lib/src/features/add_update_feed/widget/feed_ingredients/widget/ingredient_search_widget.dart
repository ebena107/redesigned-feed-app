import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IngredientSearchWidget extends ConsumerWidget {
  const IngredientSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(ingredientProvider).query;
    TextEditingController controller = TextEditingController()
      ..text = query
      ..selection = TextSelection.collapsed(offset: query.length);
    return SizedBox(
      height: displayHeight(context) * .055,
      child: TextField(
        controller: controller,
        onChanged: (val) =>
            ref.read(ingredientProvider.notifier).searchIngredients(val),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          color: AppConstants.appBackgroundColor,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 0.8,
                  style: BorderStyle.solid,
                  color: AppConstants.appCarrotColor),
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Search Ingredients',
            prefixIcon: const Icon(
              CupertinoIcons.search,
              size: 16,
              color: AppConstants.appBackgroundColor,
            ),
            hintStyle: const TextStyle(
                fontSize: 14, color: AppConstants.appBackgroundColor)),
      ),
    );
  }
}

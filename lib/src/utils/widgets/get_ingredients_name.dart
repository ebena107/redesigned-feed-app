import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetIngredientName extends ConsumerWidget {
  final num? id;
  final Color? color;
  const GetIngredientName({this.color, Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedIngredients = ref.watch(ingredientProvider).ingredients;
    Ingredient? e = feedIngredients.firstWhere((e) => e.ingredientId == id,
        orElse: () => Ingredient());

    return Text(
      e.name.toString(),
      maxLines: 3,
      softWrap: true,
      style: color != null
          ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: color)
          : Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: AppConstants.appFontColor),
      textAlign: TextAlign.start,
    );
  }
}

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/async_feed_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';

import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/utils/widgets/get_ingredients_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FeedIngredientsField extends ConsumerWidget {
  const FeedIngredientsField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(feedProvider);
    ref.watch(ingredientProvider);
    final feedIngredients = data.feedIngredients;

    double? width = displayWidth(context);

    return feedIngredients.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              const Divider(
                thickness: 2,
                color: AppConstants.appIconGreyColor,
              ),
              Expanded(
                flex: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * .32,
                      child: Text(
                        "Ingredient",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: width * .2,
                      child: Text(
                        "Price/Unit",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      //  width: width * .2,
                      child: Text(
                        "Quantity",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      //  width: width * .2,
                      child: Text(
                        "T: ${data.totalQuantity} Kg",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 3,
                color: AppConstants.appIconGreyColor,
              ),
              Expanded(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverFixedExtentList(
                      itemExtent: 48.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final ingredient = feedIngredients[index];

                          return ListTile(
                            onTap: () => showUpdateDialog(
                                context, ingredient.ingredientId),
                            //  activeColor: Commons.appCarrotColor,
                            dense: true,

                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: width * 0.32,
                                  child: GetIngredientName(
                                      id: ingredient.ingredientId),
                                ),
                                Expanded(
                                  // width: width * .2,
                                  child: Text(
                                    ingredient.priceUnitKg.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: width * .3,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ingredient.quantity == null
                                          ? ""
                                          : ingredient.quantity.toString()),
                                      Text(
                                        data.totalQuantity > 0
                                            ? "${ref.watch(feedProvider.notifier).calcPercent(ingredient.quantity).toStringAsFixed(1)}%"
                                            : "0.0%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  //   width: width * .12,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.of(context).restorablePush(
                                        deleteDialogBuilder,
                                        arguments: ingredient.ingredientId,
                                      );
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      size: 16,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: data.feedIngredients.length,
                      ),
                    ),
                  ],
                ),
              ),
              // const Expanded(
              //     flex: 1,
              //     child: Divider(thickness: 2, color: AppConstants.mainAppColor)),
            ],
          )
        : const SizedBox();
  }
}

_showSnackBar(context, message) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Route<Object?> deleteDialogBuilder(
  BuildContext context,
  Object? arguments,
) {
  int? id = arguments as int;

  return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => _DeleteIng(ingredientId: id));
}

class _DeleteIng extends ConsumerWidget {
  final num? ingredientId;
  const _DeleteIng({Key? key, this.ingredientId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedId = ref.watch(feedProvider).newFeed!.feedId;
    final ing = ref.watch(ingredientProvider).ingredients.firstWhere(
        (f) => f.ingredientId == ingredientId,
        orElse: () => Ingredient());
    return CupertinoAlertDialog(
      title: Text(
        'Remove ${ing.name}.',
      ),
      content: const Text('Are You Sure?'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Remove'),
          onPressed: () {
            feedId != null
                ? {
                    // ref
                    //     .read(asyncMainProvider.notifier)
                    //     .deleteFeedIngredient(feedId, ingredientId),
                    ref
                        .read(asyncFeedProvider.notifier)
                        .deleteIngredient(ingredientId)
                  }
                : ref
                    .read(asyncFeedProvider.notifier)
                    .deleteIngredient(ingredientId);
            //  ref.read(feedIngredientProvider.notifier).updateCount();
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

Future<dynamic> showUpdateDialog(
  BuildContext context,
  num? ingredientId,
) {
  return showDialog(
    context: context,
    builder: (_) {
      return Consumer(
        builder: (context, ref, child) {
          final data = ref.watch(feedProvider);
          final ingredient = data.feedIngredients.firstWhere(
              (f) => f.ingredientId == ingredientId,
              orElse: () => FeedIngredients());
          final feedPriceController =
              TextEditingController(text: ingredient.priceUnitKg.toString());
          final feedQuantityController = TextEditingController(
              text: ingredient.quantity == null
                  ? ""
                  : ingredient.quantity.toString());
          return CupertinoAlertDialog(
            //  title: Text('Update $GetName(id: ingredientId)'),
            title: GetIngredientName(id: ingredientId),
            content: Card(
              child: SizedBox(
                //   height: 250,
                child: Column(
                  children: [
                    TextField(
                      controller: feedPriceController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          filled: false, labelText: "Price/UnitKG"),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      ],
                      onSubmitted: (val) {},
                      onChanged: (String val) {
                        if (double.tryParse(val) == null) {
                          _showSnackBar(context,
                              'Enter price without Currency e.g 10.50');
                        }
                      },
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: feedQuantityController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                      ],
                      decoration: const InputDecoration(
                          filled: true, labelText: "Quantity"),
                      textInputAction: TextInputAction.next,
                      onChanged: (String val) {
                        if (double.tryParse(val) == null) {
                          _showSnackBar(
                              context, 'Enter quantity value e.g 10.50');
                        }
                      },
                      onSubmitted: (val) {},
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),

            actions: [
              CupertinoDialogAction(
                isDestructiveAction: false,
                child: const Text('Update'),
                onPressed: () {
                  ref
                      .read(feedProvider.notifier)
                      .setPrice(ingredientId!, feedPriceController.text);
                  ref
                      .read(feedProvider.notifier)
                      .setQuantity(ingredientId, feedQuantityController.text);

                  feedQuantityController.clear();
                  feedPriceController.clear();
                  ref.read(resultProvider.notifier).estimatedResult(
                      animal: ref.watch(feedProvider).animalTypeId,
                      ingList: ref.watch(feedProvider).feedIngredients);
                  context.pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Cancel'),
                onPressed: () {
                  context.pop();
                },
              )
            ],
          );
        },
      );
    },
  );
}

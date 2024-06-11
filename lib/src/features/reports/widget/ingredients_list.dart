import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/utils/widgets/get_ingredients_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportIngredientList extends ConsumerWidget {
  final Feed? feed;

  const ReportIngredientList({
    super.key,
    this.feed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Card(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   'Ingredients List',
                //   style: Theme.of(context)
                //       .textTheme
                //       .headlineSmall!
                //       .copyWith(color: AppConstants.appBackgroundColor),
                // ),
                // const Divider(
                //   thickness: 2,
                //   color: AppConstants.appBackgroundColor,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: displayWidth(context) * .25,
                      child: Center(
                        child: Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppConstants.appBackgroundColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * .3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Quantity',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppConstants.appBackgroundColor,
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * .29,
                      child: Center(
                        //alignment: Alignment.centerRight,
                        child: Text(
                          'Percent',
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppConstants.appBackgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: AppConstants.appBackgroundColor,
                ),
                ResultIngredientList(
                  feed: feed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ResultIngredientList extends ConsumerWidget {
  final Feed? feed;

  const ResultIngredientList({
    this.feed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedIngredients = feed!.feedIngredients;
    return ListView.separated(
        itemBuilder: (context, index) {
          final e = feedIngredients[index];
          return feedIngredients.isNotEmpty
              ? ListTile(
                  dense: true,
                  leading: SizedBox(
                    width: displayWidth(context) * .4,
                    child: GetIngredientName(
                      id: e.ingredientId,
                      color: AppConstants.appBackgroundColor,
                    ),
                  ),
                  title: SizedBox(
                    width: displayWidth(context) * .4,
                    child: Center(
                      child: Text(
                        e.quantity != null
                            ? e.quantity!.toStringAsFixed(2)
                            : "0",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppConstants.appBackgroundColor),
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    width: displayWidth(context) * .15,
                    child: Center(
                      child: Text(
                        e.quantity != null
                            ? '${calculatePercent(e.quantity).toStringAsFixed(1)} %'
                            : "0%",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppConstants.appBackgroundColor),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('empty ingredients db'),
                );
        },
        separatorBuilder: (context, index) => const Divider(
              color: AppConstants.appBackgroundColor,
              thickness: 1,
              // endIndent: 5,
              // indent: 5,
            ),
        shrinkWrap: true,
        itemCount: feedIngredients!.length);
  }

  num calculateTotalQuantity() {
    final total = feed!.feedIngredients!
        .fold(0, (num sum, ingredient) => sum + (ingredient.quantity as num));
    return total;
  }

  num calculatePercent(num? ingQty) {
    final total = calculateTotalQuantity();

    if (ingQty == 0) {
      return 0;
    } else {
      return 100 * (ingQty! / total);
    }
  }
}

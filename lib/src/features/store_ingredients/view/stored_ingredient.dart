import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

import 'package:feed_estimator/src/features/store_ingredients/providers/async_stored_ingredient.dart';

import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:feed_estimator/src/features/store_ingredients/widget/ingredient_select_widget.dart';

import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:feed_estimator/src/utils/widgets/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';

class StoredIngredients extends ConsumerWidget {
  const StoredIngredients({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(storeIngredientProvider);
    final ingredient = data.selectedIngredient;

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.repeated,
          stops: [0.4, 0.8],
          colors: [
            AppConstants.appBackgroundColor,
            Color(0xff87643E),
          ],
        )),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: displayHeight(context) * .25,
              //  leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu, color: AppConstants.appBackgroundColor,)),
              actions: const [],
              foregroundColor: AppConstants.appBackgroundColor,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      tileMode: TileMode.repeated,
                      stops: const [
                        0.6,
                        0.9
                      ],
                      colors: [
                        const Color(0xff87643E),
                        const Color(0xff87643E).withOpacity(.7)
                      ]),
                ),
                child: const FlexibleSpaceBar(
                  title: Text('Stored Ingredients'),
                  centerTitle: true,
                  background: Image(
                    image: AssetImage('assets/images/back.png'),
                  ),
                ),
              ),
            ),
            // const SliverToBoxAdapter(
            //   child: SizedBox(height: 20,)
            // ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 48, right: 24.0, left: 24, bottom: 24),
                    child: IngredientSSelectWidget(),
                  ),
                  Card(
                      child: (ingredient == Ingredient() || ingredient == null)
                          ? const SizedBox()
                          : Column(
                              children: [
                                const StoredIngredientForm(),
                                Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue)),
                                          icon: const Icon(
                                            Icons.save,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(
                                                    asyncStoredIngredientsProvider
                                                        .notifier)
                                                .saveIngredient(
                                                    onSuccess:
                                                        showAlert(context));
                                          },
                                          label: const Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            // ref
                                            //     .read(storeIngredientProvider
                                            //         .notifier)
                                            //     .deleteIngredient();
                                            Navigator.of(context)
                                                .restorablePush(
                                                    deleteDialogBuilder,
                                                    arguments: ingredient
                                                        .ingredientId);
                                          },
                                          label: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green)),
                                          onPressed: () {
                                            ref
                                                .read(storeIngredientProvider
                                                    .notifier)
                                                .update();
                                          },
                                          icon: const Icon(
                                            Icons.update,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            'Update',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showAlert(context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Transaction Completed Successfully!',
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
}

class StoredIngredientForm extends ConsumerWidget {
  const StoredIngredientForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(storeIngredientProvider);
    final ingredient = data.selectedIngredient;

    final priceController = TextEditingController(
        text: ingredient!.priceKg == null ? "" : ingredient.priceKg.toString());
    final quantityController = TextEditingController(
        text: ingredient.availableQty == null
            ? ""
            : ingredient.availableQty.toString());

    return Column(
      children: [
        Card(
          color: Colors.transparent,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('New Price/Unit: '),
                      ),
                    ),
                    Expanded(
                        child: Card(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            ref
                                .read(storeIngredientProvider.notifier)
                                .setPrice(priceController.text);
                          }
                        },
                        child: TextFormField(
                          controller: priceController,
                          decoration: inputDecoration(
                              hint: 'Price/Unit',
                              icon: CupertinoIcons.money_dollar_circle),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) => ref
                              .read(storeIngredientProvider.notifier)
                              .setPrice(value),
                          onTapOutside: (value) => ref
                              .read(storeIngredientProvider.notifier)
                              .setPrice(priceController.value.text),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('New Available Quantity: '),
                    )),
                    Expanded(
                        child: Card(
                      child: TextField(
                        controller: quantityController,
                        decoration: inputDecoration(
                            hint: 'Available Quantity',
                            icon: Icons.food_bank_outlined),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (value) => ref
                            .read(storeIngredientProvider.notifier)
                            .setAvailableQuantity(value),
                        onTapOutside: (value) => ref
                            .read(storeIngredientProvider.notifier)
                            .setAvailableQuantity(
                                quantityController.value.text),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            color: Colors.transparent,
            child: Column(
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(ingredient.favourite == 1
                                      ? 'Is Favourite'
                                      : 'Favourite?')),
                              Checkbox(
                                  activeColor: AppConstants.appCarrotColor,
                                  value:
                                      ingredient.favourite == 1 ? true : false,
                                  onChanged: (bool? value) => ref
                                      .read(storeIngredientProvider.notifier)
                                      .setFavourite(value))
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.favorite,
                              //     color: provider.favourite == 1
                              //         ? AppConstants.appCarrotColor
                              //         : AppConstants.appIconGreyColor,
                              //   ),
                              //   onPressed: () {
                              //     ref
                              //         .read(storeIngredientProvider
                              //             .notifier)
                              //         .setFavourite();
                              //   },
                              // )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Route<Object?> deleteDialogBuilder(BuildContext context, Object? argument) {
//num? ing = argument as num;

  return DialogRoute<void>(
      context: context, builder: (BuildContext context) => const _DeleteIng());
}

class _DeleteIng extends ConsumerWidget {
  const _DeleteIng({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final data = ref.watch(feedIngredientProvider);
    final ing = ref.watch(storeIngredientProvider).selectedIngredient;
    return CupertinoAlertDialog(
      title: Text(
        'Delete ${ing!.name}.',
      ),
      content: const Text('Are You Sure?'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Delete'),
          onPressed: () {
            ref
                .read(asyncStoredIngredientsProvider.notifier)
                .deleteIngredient(ing.ingredientId);
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

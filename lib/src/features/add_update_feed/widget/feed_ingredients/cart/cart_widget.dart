import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartIconWithBadge extends ConsumerWidget {
  const CartIconWithBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final counter = data.count;

    Future<void> cartDialog() async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return counter > 0
                ? AlertDialog(
                    backgroundColor: AppConstants.mainAppColor.withOpacity(.9),
                    title: const Text(
                      "Selected Ingredients",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppConstants.appBackgroundColor),
                    ),
                    content: SizedBox(
                      height: 200,
                      width: 350,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final items = data.selectedIngredients[index];

                          // return ListTile(
                          //   title: Text(
                          //     "${index + 1} - ${ref.watch(ingredientProvider.notifier).getName(items.ingredientId as int)}",
                          //     softWrap: true,
                          //     style: const TextStyle(
                          //         color: AppConstants.appBackgroundColor),
                          //   ),
                          //   trailing: IconButton(
                          //     icon: const Icon(Icons.delete),
                          //     onPressed: () {},
                          //   ),
                          // );
                          return Row(
                            children: [
                              Text(
                                "${index + 1} - ",
                                style: const TextStyle(
                                    color: AppConstants.appBackgroundColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Text(
                                  ref
                                      .watch(ingredientProvider.notifier)
                                      .getName(items.ingredientId as int),
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: AppConstants.appBackgroundColor),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.delete),
                              //   onPressed: () {},
                              //   color: AppConstants.appBackgroundColor,
                              // ),
                            ],
                          );
                        },
                        itemCount: counter,
                      ),
                    ),
                    /*   actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  IngredientList(),
                            ),
                          );
                        },
                        child: const Text("Add More"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => AddUpdateFeed(),
                            ),
                          );
                        },
                        child: const Text("Proceed"),
                      )
                    ],*/
                  )
                : Container();
          })) {}
    }

    return Center(
      child: Stack(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: AppConstants.appCarrotColor,
              size: 32,
            ),
            onPressed: () {
              counter <= 0
                  ? const SnackBar(content: Text('No ingredient available'))
                  : cartDialog();
            },
          ),
          counter != 0
              ? Positioned(
                  right: 7,
                  top: 14,
                  child: Container(
                    // padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: AppConstants.appCarrotColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$counter',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Positioned(right: 7, top: 18, child: Container())
        ],
      ),
    );
  }
}

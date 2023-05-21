import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/navigation_providers.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/widget/ingredient_sort_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../cart/cart_widget.dart';
import '../widget/ingredient_data_list.dart';
import '../widget/ingredient_search_widget.dart';

class IngredientList extends ConsumerWidget {
  final String? feedId;
  const IngredientList({
    Key? key,
    this.feedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(ingredientProvider);
    final bool search = data.search;
    final bool sort = data.sort;
    final bool showAppSearch = data.showSearch;
    final bool showSort = data.showSort;

    return Scaffold(
      backgroundColor: AppConstants.appBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.repeated,
            stops: [0.4, 0.8],
            colors: [
              AppConstants.appBackgroundColor,
              AppConstants.mainAppColor
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 48,
            ),
            Container(
              // alignment: Alignment.bottomLeft,
              color: AppConstants.mainAppColor,
              height: displayHeight(context) * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CartIconWithBadge(),
                  SizedBox(
                      // flex: 6,
                      width: displayWidth(context) * .6,
                      child: showAppSearch && search
                          ? const IngredientSearchWidget()
                          : showSort && sort
                              ? const IngredientSortingWidget()
                              : const SizedBox()),
                  Expanded(
                    flex: 2,
                    // width: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          showAppSearch
                              ? search
                                  ? IconButton(
                                      onPressed: () => ref
                                          .read(ingredientProvider.notifier)
                                          .clearSearch(),
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ))
                                  : IconButton(
                                      onPressed: () => ref
                                          .read(ingredientProvider.notifier)
                                          .toggleSearch(),
                                      icon: const Icon(
                                        CupertinoIcons.search,
                                        //  size: 16,
                                        color: AppConstants.appBackgroundColor,
                                      ),
                                    )
                              : const SizedBox(),
                          showSort
                              ? sort
                                  ? IconButton(
                                      onPressed: () => ref
                                          .read(ingredientProvider.notifier)
                                          .clearSort(),
                                      icon: const Icon(
                                        Icons.filter_list_off,
                                        //  size: 16,
                                        color: AppConstants.appCarrotColor,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () => ref
                                          .read(ingredientProvider.notifier)
                                          .toggleSort(),
                                      icon: const Icon(
                                        Icons.filter_list,
                                        //  size: 16,
                                        color: AppConstants.appBackgroundColor,
                                      ),
                                    )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: data.filteredIngredients.isNotEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: displayHeight(context) * .8,
                            //  child: IngredientDataTable(feedId: feedId),
                            child: IngredientData(feedId: feedId),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text('No Ingredient Available'),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(feedId: feedId),
    );
  }
}

Widget buildBottomBar({String? feedId}) {
  return Consumer(builder: (context, ref, child) {
    final currentIndex = ref.watch(appNavigationProvider).navIndex;

    return BottomNavigationBar(
        onTap: (int index) {
          ref.read(appNavigationProvider.notifier).changeIndex(index);
          _onItemTapped(index, context, ref, feedId);
        },
        backgroundColor: AppConstants.appBackgroundColor,
        currentIndex: currentIndex,
        elevation: 0,
        items: const [
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.cart_badge_plus),
          //   label: 'Cart',
          //   backgroundColor: AppConstants.appCarrotColor,
          // ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.refresh_thin), label: 'Clear'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.forward_end_alt), label: 'Proceed'),
          //  BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        ]);
  });
}

Future<void> _onItemTapped(
    int index, BuildContext context, WidgetRef ref, String? feedId) async {
  switch (index) {
    // case 0:
    //   break;
    case 0:
      ref.read(ingredientProvider.notifier).resetSelections();
      break;
    case 1:
      final ingList = ref.watch(ingredientProvider).selectedIngredients;

      ref.read(feedProvider.notifier).addSelectedIngredients(ingList);
      ref.read(ingredientProvider.notifier).resetSelections();
      context.goNamed("newFeed", queryParameters: {"id": feedId});

      break;
  }
}

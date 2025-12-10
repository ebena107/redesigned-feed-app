import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/navigation_providers.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/widget/ingredient_sort_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart/cart_widget.dart';
import '../widget/ingredient_data_list.dart';
import '../widget/ingredient_search_widget.dart';

class IngredientList extends ConsumerWidget {
  final int? feedId;
  const IngredientList({
    super.key,
    this.feedId,
  });

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
            // Status bar spacing
            const SizedBox(height: 48),

            // Header bar with controls
            Container(
              color: AppConstants.mainAppColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CartIconWithBadge(),

                  // Search or sort widget
                  if (showAppSearch && search)
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: IngredientSearchWidget(),
                      ),
                    )
                  else if (showSort && sort)
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: IngredientSortingWidget(),
                      ),
                    )
                  else
                    const SizedBox(),

                  // Control buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (showAppSearch)
                          IconButton(
                            icon: Icon(
                              search ? Icons.clear : Icons.search,
                              color: search
                                  ? Colors.red[400]
                                  : AppConstants.appBackgroundColor,
                              size: 20,
                            ),
                            onPressed: () => search
                                ? ref
                                    .read(ingredientProvider.notifier)
                                    .clearSearch()
                                : ref
                                    .read(ingredientProvider.notifier)
                                    .toggleSearch(),
                            tooltip:
                                search ? 'Clear search' : 'Search ingredients',
                          ),
                        if (showSort)
                          IconButton(
                            icon: Icon(
                              sort ? Icons.filter_list_off : Icons.filter_list,
                              color: sort
                                  ? AppConstants.appCarrotColor
                                  : AppConstants.appBackgroundColor,
                              size: 20,
                            ),
                            onPressed: () => sort
                                ? ref
                                    .read(ingredientProvider.notifier)
                                    .clearSort()
                                : ref
                                    .read(ingredientProvider.notifier)
                                    .toggleSort(),
                            tooltip:
                                sort ? 'Clear filter' : 'Filter ingredients',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: data.filteredIngredients.isNotEmpty
                  ? SingleChildScrollView(
                      child: IngredientData(feedId: feedId),
                    )
                  : _buildEmptyState(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(feedId: feedId),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Ingredients Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your search or filter criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

Widget buildBottomBar({int? feedId}) {
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
    int index, BuildContext context, WidgetRef ref, int? feedId) async {
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
      feedId != null
          ? FeedRoute(feedId: feedId).go(context)
          : const AddFeedRoute().go(context);

      break;
  }
}

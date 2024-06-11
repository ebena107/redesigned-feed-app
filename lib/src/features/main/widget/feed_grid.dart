import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/main/widget/tile_image.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'footer_result_card.dart';
import 'grid_menu.dart';

class FeedGrid extends ConsumerWidget {
  const FeedGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeeds = ref.watch(asyncMainProvider);

    return asyncFeeds.when(
      data: (feeds) => feeds.isNotEmpty
          ? SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                // mainAxisSpacing: 10.0,
                // crossAxisSpacing: 5.0,
                childAspectRatio: 1.0,
              ),
              delegate: _feedGridDelegate(feeds),
            )
          : SliverFillRemaining(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text('No Feed Available'),
                    IconButton(
                      onPressed: () {
                        ref.read(resultProvider.notifier).resetResult();
                        ref.read(ingredientProvider.notifier).resetSelections();
                        ref.read(feedProvider.notifier).resetProvider();
                        const AddFeedRoute().go(context);
                      },
                      icon: const Icon(Icons.add_circle_outline_rounded),
                    )
                  ],
                ),
              ),
            ),
      error: (error, stack) => const SliverFillRemaining(
        child: Center(
          child: Text('No Feed Available'),
        ),
      ),
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

SliverChildDelegate _feedGridDelegate(List<Feed> data) {
  return SliverChildBuilderDelegate((BuildContext context, int index) {
    final feed = data[index];
    //debugPrint('${data.toList().toString()} --- ${feed.toJson().toString()}');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          ReportRoute(
            feed.feedId as int,
          ).go(context);
        },
        child: GridTile(
          header: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: AppConstants.appIconGreyColor.withOpacity(.4),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    //  width: displayWidth(context) * .20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        feed.feedName.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 24,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: GridMenu(feed: feed))),
                ],
              ),
              // trailing: _gridMenu(context, feeds),
            ),
          ),
          footer: FooterResultCard(feedId: feed.feedId),
          child: FeedTileImage(
            id: feed.animalId as int,
          ),
        ),
      ),
    );
  }, childCount: data.length);
}

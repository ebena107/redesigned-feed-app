import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'footer_result_card.dart';
import 'grid_menu.dart';

class FeedList extends ConsumerWidget {
  const FeedList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final data = ref.watch(mainViewProvider);

    final asyncFeeds = ref.watch(asyncMainProvider);

    return asyncFeeds.when(
      data: (feeds) => feeds.isNotEmpty
          ? SliverList(
              delegate: _feedListDelegate(feeds),
            )
          : const SliverFillRemaining(
              child: Align(
                alignment: Alignment.center,
                child: Text('No Feed Available'),
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

    // return data.feeds.isNotEmpty
    //     ? SliverList(
    //         delegate: _feedListDelegate(data.feeds),
    //       )
    //     : const SliverFillRemaining(
    //         child: Align(
    //           alignment: Alignment.center,
    //           child: Text('No Feed Available'),
    //         ),
    //       );
  }
}

SliverChildDelegate _feedListDelegate(List<Feed> feeds) {
  return SliverChildBuilderDelegate((BuildContext context, int index) {
    final feed = feeds[index];
    return GestureDetector(
      onTap: () {
        ReportRoute(feed.feedId as int).go(context);
      },
      child: FeedListTile(feed: feed),
    );
  }, childCount: feeds.length);
}

class FeedListTile extends ConsumerWidget {
  final Feed? feed;
  const FeedListTile({super.key, this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Result> data = ref.watch(resultProvider).results;
    final myResult = data.firstWhere(
        (element) => element.feedId == feed!.feedId,
        orElse: () => Result());

    return Card(
      color: const Color(0xff87643E).withValues(alpha: .1),
      child: ListTile(
        leading: SizedBox(
          height: 48,
          width: 48,
          child: CircleAvatar(
            backgroundColor: const Color(0xff87643E).withValues(alpha: .5),
            // backgroundColor: Colors.transparent,
            child: Image.asset(
              feedImage(id: feed!.animalId as int),
              fit: BoxFit.fill,
              width: 48,
              height: 48,
              //  color: AppConstants.appCarrotColor,
            ),
          ),
        ),
        trailing: GridMenu(feed: feed),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: displayWidth(context) * .20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  feed!.feedName.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: displayWidth(context) * .15,
                  child: ContentCard(
                    title: 'Energy',
                    value: myResult.mEnergy ?? 0.0,
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * .15,
                  child: ContentCard(
                    title: 'cFiber',
                    value: myResult.cFibre ?? 0.0,
                  ),
                ),
              ],
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: displayWidth(context) * .20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${animalName(id: feed!.animalId as int)} Feed',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: displayWidth(context) * .15,
                  child: ContentCard(
                    title: 'cProtein',
                    value: myResult.cProtein ?? 0.0,
                  ),
                ),
                SizedBox(
                  width: displayWidth(context) * .15,
                  child: ContentCard(
                    title: 'cFat',
                    value: myResult.cFat ?? 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'footer_result_card.dart';

class FeedList extends ConsumerWidget {
  const FeedList({
    Key? key,
  }) : super(key: key);

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
        context.pushNamed("result",
            queryParameters: {'id': feed.feedId.toString()});
      },
      child: FeedListTile(feed: feed),
    );
  }, childCount: feeds.length);
}

class FeedListTile extends ConsumerWidget {
  final Feed? feed;
  const FeedListTile({Key? key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Result> data = ref.watch(resultProvider).results;
    final myResult = data.firstWhere(
        (element) => element.feedId == feed!.feedId,
        orElse: () => Result());

    return Card(
      color: const Color(0xff87643E).withOpacity(.1),
      child: ListTile(
        leading: SizedBox(
          height: 48,
          width: 48,
          child: CircleAvatar(
            backgroundColor: const Color(0xff87643E).withOpacity(.5),
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

///grid menu
///
///
class GridMenu extends ConsumerWidget {
  final Feed? feed;

  const GridMenu({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      //splashRadius: 50.0,
      icon: const Icon(
        Icons.more_vert,
        // size: 24.0,
        // color: Colors.white
      ),
//iconSize: 48.0,
      onSelected: (value) {
        //  print(value);
      },

      //padding: const EdgeInsets.all(0),
      itemBuilder: (context) => <PopupMenuItem<String>>[
        PopupMenuItem(
          //  padding: const EdgeInsets.all(0),
          value: "1",
          child: TextButton.icon(
            onPressed: () {
              context.pop();
              context.pushNamed("result",
                  queryParameters: {'id': feed!.feedId.toString()});
            },
            icon: const Icon(
              Icons.view_list,
              color: Colors.deepPurple,
            ),
            label: Text("View", style: menuTextStyle()),
          ),
        ),
        PopupMenuItem(
          value: "2",
          child: TextButton.icon(
              onPressed: () {
                ref.read(resultProvider.notifier).resetResult();
                ref.read(ingredientProvider.notifier).resetSelections();
                ref.read(feedProvider.notifier).resetProvider();

                ref.read(feedProvider.notifier).setFeed(feed!);

                context.pop();
                context.goNamed("newFeed",
                    queryParameters: {'id': feed!.feedId.toString()});
              },
              icon:
                  const Icon(Icons.update, color: AppConstants.appCarrotColor),
              label: Text("Update", style: menuTextStyle())),
        ),
        PopupMenuItem(
          value: "3",
          child: TextButton.icon(
              onPressed: () {
                context.pop();
                Navigator.of(context)
                    .restorablePush(_dialogBuilder, arguments: feed!.feedId);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: Text(
                "Delete",
                style: menuTextStyle(),
              )),
        ),
      ],
      // color: Commons.appBackgroundColor.withOpacity(.8),
    );
  }
}

/// Dialog Builder
///
///
///
Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
  num? feedId = arguments as num;
  return DialogRoute<void>(
    context: context,
    builder: (BuildContext context) => _DeleteFeed(feedId: feedId),
  );
}

/// delete
///
///
///
///
class _DeleteFeed extends ConsumerWidget {
  final num? feedId;

  const _DeleteFeed({
    Key? key,
    this.feedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeeds = ref.watch(asyncMainProvider);

    return asyncFeeds.when(
        data: (feeds) {
          final feed =
              feeds.firstWhere((f) => f.feedId == feedId, orElse: () => Feed());

          return CupertinoAlertDialog(
            title: Text(
              'Delete ${feed.feedName}.',
            ),
            content: const Text('Are You Sure?'),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Delete'),
                onPressed: () {
                  ref.read(asyncMainProvider.notifier).deleteFeed(feed.feedId!);
                  //  ref.read(mainViewProvider.notifier).loadFeeds();
                  Navigator.pop(context);
                  //  context.read(DBProviders.feedProvider).deleteFeed(feedId);
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
        },
        error: (er, stack) => Center(
              child: Text(er.toString()),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
    // final feed =
    //     data.feeds.firstWhere((f) => f.feedId == feedId, orElse: () => Feed());
  }
}

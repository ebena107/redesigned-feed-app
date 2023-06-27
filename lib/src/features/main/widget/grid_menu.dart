
import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/main_async_provider.dart';

///grid menu
///
///
class GridMenu extends ConsumerWidget {
  final Feed? feed;

  const GridMenu({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      constraints: const BoxConstraints(
          minWidth: 2.0 * 36.0,
           maxWidth: 4.0 * 36.0,
         ),
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
      itemBuilder: (context) =>
      <PopupMenuItem<String>>[

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
       color: AppConstants.appBackgroundColor.withOpacity(.9),
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

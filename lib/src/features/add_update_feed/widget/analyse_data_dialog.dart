import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnalyseDataDialog extends ConsumerWidget {
  final num? feedId;

  const AnalyseDataDialog({super.key, this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = feedId == null ? "Saving" : "Updating";
    final id = feedId ?? 9999;
    final name = ref.watch(feedProvider).feedName;
    final feed = ref.watch(feedProvider).newFeed;
    return CupertinoAlertDialog(
      title: Text(
        'See full Analysis of - ${name.toUpperCase()} - without ${action.toUpperCase()} it',
        style: const TextStyle(
            //color: feedId != null ? AppConstants.appCarrotColor : AppConstants.appBlueColor
            // color: Theme.of(context).colorScheme.error
            ),
      ),
      content: const Text('Are You Sure?'),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Analyse'),
          onPressed: () {
            ref.read(feedProvider.notifier).analyse();
            ReportRoute(id as int, type: feedId != null ? "" : "estimate")
                .go(context);

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
  }
}

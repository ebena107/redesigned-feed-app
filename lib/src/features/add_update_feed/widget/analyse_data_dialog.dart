import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'AnalyseDataDialog';

class AnalyseDataDialog extends ConsumerWidget {
  final num? feedId;
  final BuildContext parentContext;

  const AnalyseDataDialog({
    super.key,
    required this.parentContext,
    this.feedId,
  });

  Future<void> _handleAnalyse(BuildContext context, WidgetRef ref) async {
    try {
      final isNewFeed = feedId == null;
      final id = feedId ?? 9999;
      final feedName = ref.read(feedProvider).feedName;

      AppLogger.info(
        'Analysing feed: $feedName (id: $id, isNew: $isNewFeed)',
        tag: _tag,
      );

      // Close dialog immediately for responsiveness
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Use immediate analysis (no debounce) and await completion
      await ref.read(feedProvider.notifier).analyseImmediate();

      // Navigate using parent context (which has GoRouter access)
      if (!parentContext.mounted) return;

      ReportRoute(
        id as int,
        type: isNewFeed ? "estimate" : "",
      ).go(parentContext);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error analysing feed: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      if (context.mounted) {
        // Close dialog on error
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to analyse feed. Please try again.'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNewFeed = feedId == null;
    final feedName = ref.watch(feedProvider).feedName;
    final action = isNewFeed ? 'saving' : 'updating';

    return CupertinoAlertDialog(
      title: Text(
        'Analyse Feed Composition',
        style: TextStyle(
          color: isNewFeed
              ? AppConstants.appBlueColor
              : AppConstants.appCarrotColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: UIConstants.paddingSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View detailed nutritional analysis for "$feedName" without $action it.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              isNewFeed
                  ? 'This is a preview. You can save later.'
                  : 'Changes will not be saved.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () => _handleAnalyse(context, ref),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.chart_bar,
                size: UIConstants.iconSmall,
                color: isNewFeed
                    ? AppConstants.appBlueColor
                    : AppConstants.appCarrotColor,
              ),
              const SizedBox(width: UIConstants.paddingTiny),
              const Text('Analyse'),
            ],
          ),
        ),
      ],
    );
  }
}

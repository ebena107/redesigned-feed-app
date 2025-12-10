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

  const AnalyseDataDialog({super.key, this.feedId});

  Future<void> _handleAnalyse(BuildContext context, WidgetRef ref) async {
    try {
      final isNewFeed = feedId == null;
      final id = feedId ?? 9999;
      final feedName = ref.read(feedProvider).feedName;

      AppLogger.info(
        'Analysing feed: $feedName (id: $id, isNew: $isNewFeed)',
        tag: _tag,
      );

      // Save the root context before popping (dialog context will be invalid after pop)
      final rootContext = Navigator.of(context, rootNavigator: true).context;

      // Close dialog first for immediate feedback
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Use immediate analysis (no debounce) and await completion
      await ref.read(feedProvider.notifier).analyseImmediate();

      // Navigate using root context (which is still valid)
      if (!rootContext.mounted) return;

      ReportRoute(
        id as int,
        type: isNewFeed ? "estimate" : "",
      ).go(rootContext);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error analysing feed: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );

      // Try to find a valid context for error display
      final BuildContext? errorContext = context.mounted ? context : null;
      if (errorContext != null && errorContext.mounted) {
        ScaffoldMessenger.of(errorContext).showSnackBar(
          const SnackBar(
            content: Text('Failed to analyse feed. Please try again.'),
            backgroundColor: Colors.redAccent,
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

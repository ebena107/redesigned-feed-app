import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'AnalyseDataDialog';

class AnalyseDataDialog extends ConsumerWidget {
  final num? feedId;
  final BuildContext parentContext;
  final String feedName;
  final String analyseDialogTitle;
  final String analyseDialogMessage;
  final String analyseDialogNote;
  final String actionCancel;
  final String actionAnalyse;
  final String analyseDialogFailedMessage;

  const AnalyseDataDialog({
    super.key,
    required this.parentContext,
    this.feedId,
    required this.feedName,
    required this.analyseDialogTitle,
    required this.analyseDialogMessage,
    required this.analyseDialogNote,
    required this.actionCancel,
    required this.actionAnalyse,
    required this.analyseDialogFailedMessage,
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

      parentContext.go(
        '/report/${id as int}${isNewFeed ? '?type=estimate' : ''}',
      );
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
          SnackBar(
            content: Text(analyseDialogFailedMessage),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNewFeed = feedId == null;

    return CupertinoAlertDialog(
      title: Text(
        analyseDialogTitle,
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
              analyseDialogMessage,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              analyseDialogNote,
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
          child: Text(actionCancel),
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
              Text(actionAnalyse),
            ],
          ),
        ),
      ],
    );
  }
}

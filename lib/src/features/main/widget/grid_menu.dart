import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/main_async_provider.dart';

enum _MenuOption { view, update, delete }

class GridMenu extends ConsumerWidget {
  final Feed? feed;

  const GridMenu({super.key, required this.feed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If feed is null/invalid, hide menu or disable it
    if (feed == null || feed?.feedId == null) return const SizedBox.shrink();

    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: PopupMenuButton<_MenuOption>(
        icon: const Icon(Icons.more_horiz, size: 20, color: Colors.black87),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (option) => _handleMenuSelection(context, ref, option),
        itemBuilder: (context) => [
          _buildMenuItem(
            value: _MenuOption.view,
            icon: Icons.visibility_outlined,
            color: Colors.deepPurple,
            label: context.l10n.actionViewReport,
          ),
          _buildMenuItem(
            value: _MenuOption.update,
            icon: Icons.edit_outlined,
            color: AppConstants.appCarrotColor,
            label: context.l10n.actionUpdate,
          ),
          const PopupMenuDivider(),
          _buildMenuItem(
            value: _MenuOption.delete,
            icon: Icons.delete_outline,
            color: Colors.redAccent,
            label: context.l10n.actionDelete,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<_MenuOption> _buildMenuItem({
    required _MenuOption value,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _handleMenuSelection(
      BuildContext context, WidgetRef ref, _MenuOption option) {
    final feedId = feed!.feedId!.toInt(); // Safe due to check at start of build

    switch (option) {
      case _MenuOption.view:
        context.go('/report/$feedId');
        break;

      case _MenuOption.update:
        // Reset and Load
        ref.read(resultProvider.notifier).resetResult();
        ref.read(ingredientProvider.notifier).resetSelections();
        ref.read(feedProvider.notifier)
          ..resetProvider()
          ..setFeed(feed!);
        context.go('/feed/$feedId');
        break;

      case _MenuOption.delete:
        showCupertinoDialog(
          context: context,
          builder: (dialogContext) =>
              _DeleteConfirmDialog(feed: feed!, parentContext: context),
        );
        break;
    }
  }
}

class _DeleteConfirmDialog extends ConsumerWidget {
  final Feed feed;
  final BuildContext parentContext;

  const _DeleteConfirmDialog({
    required this.feed,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = parentContext.l10n;
    final title = l10n.feedDeleteTitle(feed.feedName ?? '');

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(l10n.confirmDeletionWarning),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => context.pop(),
          child: Text(l10n.actionCancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            ref.read(asyncMainProvider.notifier).deleteFeed(feed.feedId!);
            context.pop();
          },
          child: Text(l10n.actionDelete),
        ),
      ],
    );
  }
}

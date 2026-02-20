import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/main/widget/feed_grid.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';
import 'package:feed_estimator/src/utils/widgets/error_widget.dart';
import 'package:feed_estimator/src/utils/widgets/loading_widget.dart';
import 'package:feed_estimator/src/utils/widgets/unified_gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(asyncMainProvider);
    final compact = isCompactLayout(context);

    return ResponsiveScaffold(
      backgroundColor: AppConstants.appBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          // Modern SliverAppBar with Material Design 3
          UnifiedGradientHeader(
            title: context.l10n.appTitle,
            expandedHeight: compact
                ? UIConstants.fieldHeight * 2.5
                : UIConstants.fieldHeight * 2.0,
            gradientColors: [
              AppConstants.mainAppColor,
              AppConstants.mainAppColor.withValues(alpha: 0.8),
              const Color(0xff67C79F),
            ],
          ),

          // Spacing between app bar and content
          const SliverToBoxAdapter(
            child: SizedBox(height: UIConstants.paddingMedium),
          ),

          // Main content area
          data.when(
            data: (feeds) {
              if (feeds.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.feed_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.homeEmptyTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.homeEmptySubtitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade500,
                                  ),
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () {
                            ref.read(resultProvider.notifier).resetResult();
                            ref
                                .read(ingredientProvider.notifier)
                                .resetSelections();
                            ref.read(feedProvider.notifier).resetProvider();
                            context.go('/newFeed');
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.l10n.homeCreateFeed),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const FeedGrid();
            },
            error: (er, stack) => SliverFillRemaining(
              child: AppErrorWidget(
                message: context.l10n.homeLoadFailed(er.toString()),
                onRetry: () {
                  ref.invalidate(asyncMainProvider);
                },
              ),
            ),
            loading: () => SliverFillRemaining(
              child: AppLoadingWidget(
                message: context.l10n.homeLoadingFeeds,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: UIConstants.paddingLarge * 2),
          ),
        ],
      ),

      // Modern FAB with Material Design 3
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(resultProvider.notifier).resetResult();
          ref.read(ingredientProvider.notifier).resetSelections();
          ref.read(feedProvider.notifier).resetProvider();
          context.go('/newFeed');
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.homeAddFeed),
        backgroundColor: AppConstants.appCarrotColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}

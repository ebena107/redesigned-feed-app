import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/main/widget/tile_image.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'footer_result_card.dart';
import 'grid_menu.dart';

class FeedGrid extends ConsumerWidget {
  const FeedGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeeds = ref.watch(asyncMainProvider);

    return asyncFeeds.when(
      data: (feeds) {
        if (feeds.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyFeedState(),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.all(UIConstants.paddingSmall),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190.0,
              mainAxisSpacing: UIConstants.paddingMedium,
              crossAxisSpacing: UIConstants.paddingMedium,
              childAspectRatio: 0.68, // Optimized for text-heavy content
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => FeedGridCard(feed: feeds[index]),
              childCount: feeds.length,
            ),
          ),
        );
      },
      error: (error, stack) => SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorFeedState(onRetry: () => ref.refresh(asyncMainProvider)),
      ),
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class FeedGridCard extends StatelessWidget {
  final Feed feed;
  const FeedGridCard({required this.feed, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedId = feed.feedId ?? 0;
    final animalId = feed.animalId ?? 0;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap:
            feedId != 0 ? () => context.go('/report/${feedId.toInt()}') : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE SECTION with gradient overlay (65% height)
            Expanded(
              flex: 65,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstants.mainAppColor.withValues(alpha: 0.08),
                          AppConstants.mainAppColor.withValues(alpha: 0.12),
                        ],
                      ),
                    ),
                    child: FeedTileImage(id: animalId.toInt()),
                  ),
                  // Bottom gradient for better text contrast
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Menu button with better visibility
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GridMenu(feed: feed),
                    ),
                  ),
                ],
              ),
            ),
            // CONTENT SECTION (more height for text and chips)
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingSmall,
                  vertical: 6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Feed title and subtitle with flexible height
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              feed.feedName ?? context.l10n.feedNameUnknown,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Flexible(
                            child: Text(
                              context.l10n.feedSubtitle(
                                animalName(id: animalId.toInt()),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: theme.colorScheme.secondary,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Nutrition footer with constrained height
                    FooterResultCard(feedId: feedId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  const _EmptyFeedState();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(context.l10n.feedsEmptyStateTitle,
            style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _ErrorFeedState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorFeedState({required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(context.l10n.feedsLoadFailed),
          TextButton(onPressed: onRetry, child: Text(context.l10n.actionRetry)),
        ],
      ),
    );
  }
}

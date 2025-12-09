import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/main/widget/tile_image.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'footer_result_card.dart';
import 'grid_menu.dart';

class FeedGrid extends ConsumerWidget {
  const FeedGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncFeeds = ref.watch(asyncMainProvider);

    return asyncFeeds.when(
      data: (feeds) => feeds.isNotEmpty
          ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180.0,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.85,
                ),
                delegate: _feedGridDelegate(feeds),
              ),
            )
          : SliverFillRemaining(
              child: Align(
                alignment: Alignment.center,
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
                      'No Feeds Yet',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first feed formulation',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(resultProvider.notifier).resetResult();
                        ref.read(ingredientProvider.notifier).resetSelections();
                        ref.read(feedProvider.notifier).resetProvider();
                        const AddFeedRoute().go(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create Feed'),
                    ),
                  ],
                ),
              ),
            ),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              const Text('Failed to load feeds'),
            ],
          ),
        ),
      ),
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

SliverChildDelegate _feedGridDelegate(List<Feed> data) {
  return SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      final feed = data[index];
      return FeedGridCard(feed: feed);
    },
    childCount: data.length,
  );
}

/// Modern Material Design 3 feed card with ripple effect and elevation
class FeedGridCard extends ConsumerWidget {
  final Feed feed;

  const FeedGridCard({required this.feed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ReportRoute(feed.feedId as int).go(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with menu (70% of card height)
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  // Feed image
                  Container(
                    width: double.infinity,
                    color: AppConstants.mainAppColor.withValues(alpha: 0.1),
                    child: FeedTileImage(id: feed.animalId as int),
                  ),

                  // Menu button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: GridMenu(feed: feed),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom info section (30% of card height) - compact layout
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 2,
                  children: [
                    // Feed name - single line
                    Text(
                      feed.feedName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                    ),

                    // Animal type - single line
                    Text(
                      '${animalName(id: feed.animalId as int)} Feed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.2,
                          ),
                    ),

                    // Footer with nutrients - expand to fill remaining space
                    Expanded(
                      child: FooterResultCard(feedId: feed.feedId),
                    ),
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

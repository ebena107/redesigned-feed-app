import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/main/widget/feed_grid.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:feed_estimator/src/utils/widgets/error_widget.dart';
import 'package:feed_estimator/src/utils/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(asyncMainProvider);

    return Scaffold(
      drawer: const FeedAppDrawer(),
      backgroundColor: AppConstants.appBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          // Modern SliverAppBar with Material Design 3
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: true,
            expandedHeight: UIConstants.fieldHeight * 2.5,
            elevation: 0,
            backgroundColor: AppConstants.mainAppColor,
            foregroundColor: Colors.white,
            // Extend app bar color into status bar
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppConstants.mainAppColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Feed Estimator',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              expandedTitleScale: 1.3,
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.6, 1.0],
                    colors: [
                      AppConstants.mainAppColor,
                      AppConstants.mainAppColor.withValues(alpha: 0.8),
                      const Color(0xff67C79F),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        'assets/images/back.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                          'No Feeds Yet',
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
                          'Create your first feed formulation',
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
                            const AddFeedRoute().go(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Feed'),
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
                message: 'Failed to load feeds: ${er.toString()}',
                onRetry: () {
                  ref.invalidate(asyncMainProvider);
                },
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: AppLoadingWidget(
                message: 'Loading feeds...',
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
          const AddFeedRoute().go(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Feed'),
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

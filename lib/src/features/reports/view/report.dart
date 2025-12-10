import 'package:feed_estimator/src/core/constants/common.dart';

import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/features/reports/widget/ingredients_list.dart';
import 'package:feed_estimator/src/features/reports/widget/report_bottom_bar.dart';
import 'package:feed_estimator/src/features/reports/widget/result_card.dart'; // Extracted ResultCard
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisPage extends ConsumerWidget {
  final int? feedId;
  final String? type;

  const AnalysisPage({super.key, this.feedId, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEstimate = type == 'estimate';

    // 1. Safe Feed Retrieval Logic
    final Feed feed;
    if (isEstimate) {
      feed = ref.watch(feedProvider).newFeed ?? Feed();
    } else {
      final asyncFeeds = ref.watch(asyncMainProvider);
      // Handle loading/error or empty states gracefully
      if (!asyncFeeds.hasValue) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      feed = asyncFeeds.value!
          .firstWhere((f) => f.feedId == feedId, orElse: () => Feed());
    }

    // 2. View State (Analysis vs Ingredients)
    final showIngredients = ref.watch(resultProvider).toggle;

    return Scaffold(
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with integrated background
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.deepPurple,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            elevation: 0,
            pinned: true,
            expandedHeight: 200,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Back pattern background
                  const Image(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.deepPurple.withValues(alpha: 0.4),
                          Colors.deepPurple.withValues(alpha: 0.6),
                          Colors.deepPurple.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Title positioned at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Analysis Report",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined,
                    color: Colors.white),
                onPressed: () =>
                    PdfRoute(feedId ?? 0, type: type ?? '', $extra: feed)
                        .go(context),
              ),
            ],
          ),

          // Content with harmonized design
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.shade50,
                    Colors.white.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.15],
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Feed Image Avatar - stacked elegantly
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.deepPurple.shade50,
                          backgroundImage: AssetImage(
                            feedImage(id: feed.animalId?.toInt()),
                          ),
                        ),
                      ),
                    ),

                    // Feed Header Info
                    _FeedHeader(feed: feed),

                    const SizedBox(height: 24),

                    // Toggle Content
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: showIngredients
                          ? ReportIngredientList(
                              key: const ValueKey('ingredients'),
                              feed: feed,
                            )
                          : Padding(
                              key: const ValueKey('analysis'),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ResultCard(
                                feed: feed,
                                feedId: feedId,
                                type: type,
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Return Button (Only if "New Feed" / Magic Number 9999)
                    if (feedId == 9999) _ReturnButton(feedId: feedId),

                    const SizedBox(height: 80), // Bottom padding for nav bar
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ReportBottomBar(),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  final Feed feed;
  const _FeedHeader({required this.feed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            feed.feedName ?? 'Unknown Feed',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.deepPurple.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${animalName(id: (feed.animalId ?? 0).toInt())} Feed',
                  style: TextStyle(
                    color: Colors.deepPurple.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Modified: ${secondToDate(feed.timestampModified?.toInt())}',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnButton extends StatelessWidget {
  final int? feedId;
  const _ReturnButton({required this.feedId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.appCarrotColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () => FeedRoute(feedId: feedId!).go(context),
      icon: const Icon(Icons.edit),
      label: const Text("Return to Edit"),
    );
  }
}

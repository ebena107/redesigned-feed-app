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
    final size = MediaQuery.sizeOf(context);
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
      body: Stack(
        children: [
          // BACKGROUND GRADIENT
          Container(
            height: size.height * 0.45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
            ),
          ),

          // MAIN SCROLLABLE CONTENT
          CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.deepPurple,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "Analysis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Image(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover,
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

              // Spacer for the Image Area
              SliverToBoxAdapter(child: SizedBox(height: size.height * 0.10)),

              // The White Content Container
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(minHeight: size.height * 0.7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.purple.shade50.withValues(alpha: 0.3),
                        Colors.purple.shade50.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                          height: 60), // Space for the overlapping avatar

                      // Feed Header Info
                      _FeedHeader(feed: feed),

                      const SizedBox(height: 20),

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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ResultCard(
                                  feed: feed,
                                  feedId: feedId,
                                  type: type,
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      // Return Button (Only if "New Feed" / Magic Number 9999)
                      if (feedId == 9999) _ReturnButton(feedId: feedId),

                      const SizedBox(height: 80), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // FLOATING CIRCLE AVATAR (Positioned relative to screen)
          // We place this in the stack last so it floats above the white container
          Positioned(
            top: size.height * 0.20, // Adjust based on design preference
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5))
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage:
                      AssetImage(feedImage(id: feed.animalId?.toInt())),
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
    return Column(
      children: [
        Text(
          feed.feedName ?? 'Unknown Feed',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${animalName(id: (feed.animalId ?? 0).toInt())} Feed',
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        Text(
          'Modified: ${secondToDate(feed.timestampModified?.toInt())}',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
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

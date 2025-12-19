import 'package:feed_estimator/src/core/constants/common.dart';

import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/widget/amino_acid_profile_card.dart';
import 'package:feed_estimator/src/features/reports/widget/phosphorus_breakdown_card.dart';
import 'package:feed_estimator/src/features/reports/widget/energy_values_card.dart';
import 'package:feed_estimator/src/features/reports/widget/formulation_warnings_card.dart';
import 'package:feed_estimator/src/features/reports/widget/ingredients_list.dart';
import 'package:feed_estimator/src/features/reports/widget/report_bottom_bar.dart';
import 'package:feed_estimator/src/features/reports/widget/result_card.dart'; // Extracted ResultCard
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AnalysisPage extends ConsumerWidget {
  final int? feedId;
  final String? type;

  const AnalysisPage({super.key, this.feedId, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEstimate = type == 'estimate';

    // 1. Optimized Feed Retrieval - use pre-calculated data
    final Feed feed;
    if (isEstimate) {
      // For new (unsaved) feeds, use pre-calculated data from feedProvider
      // This data was already prepared by analyseImmediate() before navigation
      feed = ref.watch(feedProvider).newFeed ?? Feed();
    } else {
      // For existing feeds, fetch from database
      final asyncFeeds = ref.watch(asyncMainProvider);
      if (!asyncFeeds.hasValue) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      feed = asyncFeeds.value!
          .firstWhere((f) => f.feedId == feedId, orElse: () => Feed());
    }

    // 2. Watch result provider for reactive updates (pre-calculated by analyseImmediate)
    ref.watch(resultProvider).myResult;

    // 3. View State (Analysis vs Ingredients)
    final showIngredients = ref.watch(resultProvider).toggle;
    return Scaffold(
      drawer: const FeedAppDrawer(),
      backgroundColor: AppConstants.appBackgroundColor,
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
            //backgroundColor: Colors.transparent,
            backgroundColor: Colors.deepPurple,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              title: Text(
                feedId == 9999 ? 'Estimated Analysis' : 'Analysis Report',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
                // style: titleTextStyle(),
              ),
              background:
                  const Image(image: AssetImage('assets/images/back.png')),
              // background: Stack(
              //   fit: StackFit.expand,
              //   children: [
              //     // Back pattern background
              //     const Image(
              //       image: AssetImage('assets/images/back.png'),
              //       fit: BoxFit.cover,
              //     ),
              //     // Gradient overlay
              //     Container(
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter,
              //           colors: [
              //             Colors.deepPurple.withValues(alpha: 0.9),
              //             Colors.deepPurple.withValues(alpha: 0.6),
              //             Colors.deepPurple.withValues(alpha: 0.1),
              //           ],
              //           stops: const [0.0, 0.5, 1.0],
              //         ),
              //       ),
              //     ),
              //     // Title positioned at bottom
              //     Positioned(
              //       bottom: 16,
              //       left: 16,
              //       right: 16,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             "Analysis Report",
              //             style: Theme.of(context)
              //                 .textTheme
              //                 .headlineSmall
              //                 ?.copyWith(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w700,
              //                 ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined,
                    color: Colors.white),
                onPressed: () => context.push(
                  '/report/${feedId ?? 0}/pdf${type != null && type!.isNotEmpty ? '?type=$type' : ''}',
                  extra: feed,
                ),
              ),
            ],
          ),

          // Content with harmonized design
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(40),
              //     topRight: Radius.circular(40),
              //   ),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withValues(alpha: 0.08),
              //       blurRadius: 20,
              //       offset: const Offset(0, -5),
              //       spreadRadius: 1,
              //     ),
              //   ],
              // ),
              child: Column(
                children: [
                  // Feed Image Avatar - stacked elegantly
                  // Transform.translate(
                  //   offset: const Offset(0, -60),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       shape: BoxShape.circle,
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.deepPurple.withValues(alpha: 0.25),
                  //           blurRadius: 15,
                  //           offset: const Offset(0, 8),
                  //           spreadRadius: 2,
                  //         ),
                  //       ],
                  //     ),
                  //     child: CircleAvatar(
                  //       radius: 55,
                  //       backgroundColor: Colors.deepPurple.shade50,
                  //       backgroundImage: AssetImage(
                  //         feedImage(id: feed.animalId?.toInt()),
                  //       ),
                  //     ),
                  //   ),
                  // ),

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
                        : Column(
                            key: const ValueKey('analysis'),
                            children: [
                              // Main result card
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ResultCard(
                                  feed: feed,
                                  feedId: feedId,
                                  type: type,
                                ),
                              ),

                              // Enhanced nutrient cards
                              const SizedBox(height: 16),
                              _buildEnhancedNutrientCards(
                                  ref, feedId, type, feed),
                            ],
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
        ],
      ),
      bottomNavigationBar: const ReportBottomBar(),
    );
  }

  /// Build enhanced nutrient display cards
  Widget _buildEnhancedNutrientCards(
      WidgetRef ref, num? feedId, String? type, Feed feed) {
    final provider = ref.watch(resultProvider);

    // Get result based on type
    final result = type == 'estimate'
        ? provider.myResult
        : provider.results.firstWhere(
            (r) => r.feedId == feedId,
            orElse: () => Result(),
          );

    if (result == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Amino Acid Profile Card
        AminoAcidProfileCard(
          aminoAcidsSidJson: result.aminoAcidsSidJson,
          aminoAcidsTotalJson: result.aminoAcidsTotalJson,
        ),

        // Phosphorus Breakdown Card
        PhosphorusBreakdownCard(
          totalPhosphorus: result.totalPhosphorus,
          availablePhosphorus: result.availablePhosphorus,
          phytatePhosphorus: result.phytatePhosphorus,
        ),

        // Energy Values Card
        EnergyValuesCard(
          energyJson: result.energyJson,
          animalTypeId: feed.animalId as int? ?? 1,
        ),

        // Formulation Warnings Card
        FormulationWarningsCard(
          warningsJson: result.warningsJson,
        ),
      ],
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
      onPressed: () => context.go('/feed/$feedId'),
      icon: const Icon(Icons.edit),
      label: const Text("Return to Edit"),
    );
  }
}

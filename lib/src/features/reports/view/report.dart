import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/providers/main_async_provider.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/features/reports/widget/amino_acid_profile_card.dart';
import 'package:feed_estimator/src/features/reports/widget/energy_values_card.dart';
import 'package:feed_estimator/src/features/reports/widget/formulation_warnings_card.dart';
import 'package:feed_estimator/src/features/reports/widget/ingredients_list.dart';
import 'package:feed_estimator/src/features/reports/widget/phosphorus_breakdown_card.dart';

import 'package:feed_estimator/src/features/reports/widget/result_card.dart';
import 'package:feed_estimator/src/utils/widgets/unified_gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/core/router/routes.dart';

import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';

class AnalysisPage extends ConsumerStatefulWidget {
  final int? feedId;
  final String? type;

  const AnalysisPage({super.key, this.feedId, this.type});

  @override
  ConsumerState<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends ConsumerState<AnalysisPage> {
  @override
  void initState() {
    super.initState();
    // Trigger calculation data loading after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    // If it's not an estimate (i.e. viewing a saved feed), we need to trigger calculation
    if (widget.type != 'estimate' && widget.feedId != null) {
      final asyncFeeds = ref.read(asyncMainProvider);
      if (asyncFeeds.hasValue) {
        try {
          final feed = asyncFeeds.value!.firstWhere(
              (f) => f.feedId == widget.feedId,
              orElse: () => Feed());
          if (feed.feedId != null) {
            // Pass the feed object directly!
            ref
                .read(resultProvider.notifier)
                .estimatedResult(feed: feed, feedId: widget.feedId);
          } else {}
        } catch (e) {
          debugPrint('Error in _loadData: $e');
        }
      } else {}
    }
  }

  @override
  void didUpdateWidget(AnalysisPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feedId != widget.feedId) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for provider updates to trigger calculation if data arrives late
    ref.listen(asyncMainProvider, (prev, next) {
      if (widget.type != 'estimate' &&
          widget.feedId != null &&
          next.hasValue &&
          (prev == null || !prev.hasValue)) {
        _loadData();
      }
    });

    try {
      final isEstimate = widget.type == 'estimate';
      final showIngredients = ref.watch(resultProvider).toggle;

      // 1. Optimized Feed Retrieval
      final Feed feed;
      if (isEstimate) {
        feed = ref.watch(feedProvider).newFeed ?? Feed();
      } else {
        final asyncFeeds = ref.watch(asyncMainProvider);
        if (!asyncFeeds.hasValue) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        feed = asyncFeeds.value!
            .firstWhere((f) => f.feedId == widget.feedId, orElse: () => Feed());
      }

      // 2. Watch result provider
      final resultState = ref.watch(resultProvider);
      final result =
          resultState.myResult; //  <-- Correct: watch property from state

      final String subtitle = [
        '${animalName(id: (feed.animalId ?? 0).toInt())} Feed',
        if (feed.productionStage != null && feed.productionStage!.isNotEmpty)
          feed.productionStage!,
        secondToDate(feed.timestampModified?.toInt())
      ].join(' • ');

      return ResponsiveScaffold(
        backgroundColor: AppConstants.appBackgroundColor,
        // bottomNavigationBar: const ReportBottomBar(), // Removed as ResponsiveScaffold handles nav
        body: CustomScrollView(
          slivers: [
            UnifiedGradientHeader(
              title: feed.feedName ?? 'Report',
              subtitle: subtitle,
              gradientColors: [
                Colors.deepPurple,
                Colors.deepPurpleAccent,
              ],
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    if (feed.feedId != null) {
                      PdfRoute(feed.feedId!.toInt(),
                              type: widget.type, $extra: feed)
                          .push(context);
                    }
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 80),
                child: showIngredients
                    ? ReportIngredientList(feed: feed)
                    : Column(
                        children: [
                          // Main Result Card
                          _buildSafeWidget(
                            'ResultCard',
                            () => ResultCard(
                              feed: feed,
                              feedId: widget.feedId,
                              type: widget.type,
                            ),
                          ),

                          // Only show detailed cards if we have a valid result
                          if (result != null && result.mEnergy != null) ...[
                            // Formulation Warnings
                            _buildSafeWidget(
                              'FormulationWarningsCard',
                              () => FormulationWarningsCard(
                                warningsJson: result.warningsJson,
                              ),
                            ),

                            // Amino Acid Profile
                            _buildSafeWidget(
                              'AminoAcidProfileCard',
                              () => AminoAcidProfileCard(
                                aminoAcidsSidJson: result.aminoAcidsSidJson,
                                aminoAcidsTotalJson: result.aminoAcidsTotalJson,
                              ),
                            ),

                            // Energy Values
                            _buildSafeWidget(
                              'EnergyValuesCard',
                              () => EnergyValuesCard(
                                energyJson: result.energyJson,
                                animalTypeId: feed.animalId?.toInt() ?? 1,
                              ),
                            ),

                            // Phosphorus Breakdown
                            _buildSafeWidget(
                              'PhosphorusBreakdownCard',
                              () => PhosphorusBreakdownCard(
                                totalPhosphorus: result.totalPhosphorus,
                                availablePhosphorus: result.availablePhosphorus,
                                phytatePhosphorus: result.phytatePhosphorus,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error in AnalysisPage build: $e');
      debugPrint(stackTrace.toString());
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('An error occurred loading the report'),
              const SizedBox(height: 8),
              Text(
                '$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSafeWidget(String name, Widget Function() builder) {
    try {
      return builder();
    } catch (e, stackTrace) {
      debugPrint('ERROR rendering $name: $e');
      debugPrint(stackTrace.toString());
      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Error rendering $name',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('$e', style: const TextStyle(color: Colors.black87)),
          ],
        ),
      );
    }
  }
}

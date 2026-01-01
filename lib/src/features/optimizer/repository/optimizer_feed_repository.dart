import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main/model/feed.dart';
import '../../main/repository/feed_repository.dart';
import '../model/optimization_result.dart';
import '../model/optimization_request.dart';
import 'dart:convert';

/// Repository helper for optimizer-specific feed operations
class OptimizerFeedRepository {
  OptimizerFeedRepository(this._feedRepository);

  final FeedRepository _feedRepository;

  /// Save an optimized formulation as a Feed
  Future<int> saveOptimizedFormulation({
    required String feedName,
    required int animalId,
    required OptimizationResult result,
    required OptimizationRequest request,
    String? productionStage,
  }) async {
    // Convert ingredient proportions to FeedIngredients
    final feedIngredients = result.ingredientProportions.entries.map((entry) {
      return FeedIngredients(
        ingredientId: entry.key,
        quantity: entry.value / 100.0, // Convert percentage to decimal
        priceUnitKg: request.ingredientPrices[entry.key] ?? 0.0,
      );
    }).toList();

    // Serialize constraints to JSON
    final constraintsJson = jsonEncode(
      request.constraints.map((c) => c.toJson()).toList(),
    );

    // Create Feed object
    final feed = Feed(
      feedName: feedName,
      animalId: animalId,
      feedIngredients: feedIngredients,
      productionStage: productionStage,
      isOptimized: true,
      optimizationConstraintsJson: constraintsJson,
      optimizationScore: result.qualityScore,
      optimizationObjective: request.objective.name,
      timestampModified: DateTime.now().millisecondsSinceEpoch,
    );

    // Save to database
    return await _feedRepository.insertOne(feed);
  }

  /// Get all optimized feeds
  Future<List<Feed>> getOptimizedFeeds() async {
    final allFeeds = await _feedRepository.getAll();
    return allFeeds.where((feed) => feed.isOptimized == true).toList();
  }

  /// Get optimized feeds by animal type
  Future<List<Feed>> getOptimizedFeedsByAnimal(int animalId) async {
    final optimizedFeeds = await getOptimizedFeeds();
    return optimizedFeeds.where((feed) => feed.animalId == animalId).toList();
  }

  /// Get optimized feeds by objective
  Future<List<Feed>> getOptimizedFeedsByObjective(String objective) async {
    final optimizedFeeds = await getOptimizedFeeds();
    return optimizedFeeds
        .where((feed) => feed.optimizationObjective == objective)
        .toList();
  }

  /// Get top scoring optimized feeds
  Future<List<Feed>> getTopScoringFeeds({int limit = 10}) async {
    final optimizedFeeds = await getOptimizedFeeds();

    // Sort by score descending
    optimizedFeeds.sort((a, b) {
      final scoreA = a.optimizationScore ?? 0.0;
      final scoreB = b.optimizationScore ?? 0.0;
      return scoreB.compareTo(scoreA);
    });

    return optimizedFeeds.take(limit).toList();
  }

  /// Update an optimized feed
  Future<int> updateOptimizedFeed(Feed feed) async {
    if (feed.feedId == null) {
      throw ArgumentError('Feed ID cannot be null for update');
    }
    return await _feedRepository.update(feed.toJson(), feed.feedId!);
  }

  /// Delete an optimized feed
  Future<int> deleteOptimizedFeed(int feedId) async {
    return await _feedRepository.delete(feedId);
  }
}

/// Provider for OptimizerFeedRepository
final optimizerFeedRepositoryProvider =
    Provider<OptimizerFeedRepository>((ref) {
  final feedRepo = ref.watch(feedRepository);
  return OptimizerFeedRepository(feedRepo);
});

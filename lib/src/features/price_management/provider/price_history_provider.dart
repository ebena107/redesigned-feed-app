import 'dart:async';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'price_history_provider.g.dart';

/// Async provider for fetching price history for a specific ingredient
///
/// Automatically manages:
/// - Async loading state
/// - Error handling
/// - Caching with 5-minute invalidation
/// - Dependency on priceHistoryRepository
///
/// Usage:
/// ```dart
/// final history = ref.watch(priceHistoryProvider(ingredientId));
/// // AsyncValue<List<PriceHistory>>
/// ```
@Riverpod(keepAlive: true)
Future<List<PriceHistory>> priceHistory(
  Ref ref,
  int ingredientId,
) async {
  // Cache for 5 minutes to reduce database queries
  ref.cacheFor(const Duration(minutes: 5));

  final repository = ref.watch(priceHistoryRepository);
  return repository.getHistoryForIngredient(ingredientId);
}

/// Extension to add cacheFor helper
extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

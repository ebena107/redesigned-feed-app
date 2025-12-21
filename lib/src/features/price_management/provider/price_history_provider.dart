import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'price_history_provider.g.dart';

/// Async provider for fetching price history for a specific ingredient
///
/// Automatically manages:
/// - Async loading state
/// - Error handling
/// - Caching with invalidation support
/// - Dependency on priceHistoryRepository
///
/// Usage:
/// ```dart
/// final history = ref.watch(priceHistoryProvider(ingredientId));
/// // AsyncValue<List<PriceHistory>>
/// ```
@riverpod
Future<List<PriceHistory>> priceHistory(
  Ref ref,
  int ingredientId,
) async {
  final repository = ref.watch(priceHistoryRepository);
  return repository.getHistoryForIngredient(ingredientId);
}

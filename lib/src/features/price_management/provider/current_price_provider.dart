import 'dart:async';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_price_provider.g.dart';

const String _tag = 'CurrentPriceProvider';

/// Get the current (latest) price for an ingredient
///
/// Priority:
/// 1. Use latest price from price_history table (if available)
/// 2. Fallback to ingredient.priceKg (default price)
/// 3. Return 0 if neither available
///
/// This provider is used for:
/// - Displaying current price in ingredient selection
/// - Cost calculations based on most recent price
/// - Price trend awareness (compares with history)
///
/// Cached for 5 minutes to reduce database queries
@Riverpod(keepAlive: true)
Future<double> currentPrice(
  Ref ref, {
  required int ingredientId,
}) async {
  // Cache for 5 minutes to reduce database queries
  ref.cacheFor(const Duration(minutes: 5));
  try {
    final repository = ref.watch(priceHistoryRepository);

    // Get latest price from history
    final latestPrice = await repository.getLatestPrice(ingredientId);
    if (latestPrice != null) {
      AppLogger.info(
        'Current price for ingredient $ingredientId: ${latestPrice.price} ${latestPrice.currency}',
        tag: _tag,
      );
      return latestPrice.price;
    }

    // Fallback to ingredient default price
    final ingredients = ref.watch(ingredientProvider).ingredients;
    final ingredient =
        ingredients.firstWhere((ing) => ing.ingredientId == ingredientId);

    final defaultPrice = (ingredient.priceKg ?? 0).toDouble();
    AppLogger.debug(
      'Using default price for ingredient $ingredientId: $defaultPrice',
      tag: _tag,
    );
    return defaultPrice;
  } catch (e) {
    AppLogger.warning(
      'Error getting current price for ingredient $ingredientId: $e',
      tag: _tag,
    );
    return 0;
  }
}

/// Track price change from default
@riverpod
Future<PriceChange> priceChange(
  Ref ref, {
  required int ingredientId,
}) async {
  try {
    final ingredients = ref.watch(ingredientProvider).ingredients;
    final ingredient =
        ingredients.firstWhere((ing) => ing.ingredientId == ingredientId);
    final defaultPrice = (ingredient.priceKg ?? 0).toDouble();

    // Get current price value using repository directly
    final repository = ref.watch(priceHistoryRepository);
    final latestPrice = await repository.getLatestPrice(ingredientId);
    final currentPriceValue = latestPrice?.price ?? defaultPrice;

    if (defaultPrice == 0) {
      return const PriceChange(
        changeAmount: 0,
        changePercent: 0,
        isIncrease: false,
      );
    }

    final changeAmount = currentPriceValue - defaultPrice;
    final changePercent = (changeAmount / defaultPrice) * 100;

    return PriceChange(
      changeAmount: changeAmount,
      changePercent: changePercent,
      isIncrease: changeAmount > 0,
    );
  } catch (e) {
    AppLogger.warning(
      'Error calculating price change for ingredient $ingredientId: $e',
      tag: _tag,
    );
    return const PriceChange(
      changeAmount: 0,
      changePercent: 0,
      isIncrease: false,
    );
  }
}

/// Data class for price change info
class PriceChange {
  final double changeAmount;
  final double changePercent;
  final bool isIncrease;

  const PriceChange({
    required this.changeAmount,
    required this.changePercent,
    required this.isIncrease,
  });

  String get formattedChange =>
      '${isIncrease ? '+' : ''} ${changePercent.toStringAsFixed(1)}%';

  String get description {
    if (changePercent.abs() < 0.01) return 'No change';
    if (isIncrease) {
      return 'Increased ${changePercent.toStringAsFixed(1)}%';
    } else {
      return 'Decreased ${(changePercent.abs()).toStringAsFixed(1)}%';
    }
  }
}

/// Extension to add cacheFor helper
extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

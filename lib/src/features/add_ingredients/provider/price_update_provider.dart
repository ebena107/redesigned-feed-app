import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for updating ingredient prices
final priceUpdateProvider =
    NotifierProvider<PriceUpdateNotifier, AsyncValue<void>>(
        PriceUpdateNotifier.new);

class PriceUpdateNotifier extends Notifier<AsyncValue<void>> {
  late IngredientsRepository _ingredientsRepository;

  @override
  AsyncValue<void> build() {
    _ingredientsRepository = ref.watch(ingredientsRepository);
    return const AsyncData(null);
  }

  /// Update ingredient price with timestamp
  /// Returns the timestamp when the price was updated
  Future<int> updateIngredientPrice(num ingredientId, num newPrice) async {
    state = const AsyncLoading();
    try {
      await _ingredientsRepository.updatePrice(ingredientId, newPrice);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      state = const AsyncData(null);
      return timestamp;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }

  /// Get formatted timestamp string from Unix timestamp
  static String formatTimestamp(num? timestamp) {
    if (timestamp == null || timestamp == 0) {
      return 'Never updated';
    }

    try {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch((timestamp as int) * 1000);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

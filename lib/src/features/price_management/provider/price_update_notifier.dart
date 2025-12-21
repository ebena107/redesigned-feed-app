import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:feed_estimator/src/features/price_management/provider/price_history_provider.dart';
import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'PriceUpdateNotifier';

// Dummy datetime for default state (type requirement)
final _zeroDate = DateTime(2000, 1, 1);

/// State for price update operations
sealed class PriceUpdateState {
  const PriceUpdateState();
}

/// Initial state - no operation
class _PriceUpdateIdle extends PriceUpdateState {
  const _PriceUpdateIdle();
}

/// Loading - price update in progress
class _PriceUpdateLoading extends PriceUpdateState {
  const _PriceUpdateLoading();
}

/// Success - price updated
class PriceUpdateSuccess extends PriceUpdateState {
  final PriceHistory priceHistory;
  final String message;

  const PriceUpdateSuccess({
    required this.priceHistory,
    required this.message,
  });
}

/// Error - price update failed
class PriceUpdateError extends PriceUpdateState {
  final String message;
  final dynamic error;

  const PriceUpdateError({
    required this.message,
    required this.error,
  });
}

/// Notifier for managing price update operations
///
/// Handles:
/// - Recording new prices for ingredients
/// - Updating price records
/// - Invalidating related caches
/// - Error handling and user messaging
class PriceUpdateNotifier extends Notifier<PriceUpdateState> {
  late final PriceHistoryRepository _repository;

  @override
  PriceUpdateState build() {
    _repository = ref.read(priceHistoryRepository);
    return const _PriceUpdateIdle();
  }

  /// Record a new price for an ingredient
  Future<void> recordPrice({
    required int ingredientId,
    required double price,
    required String currency,
    required DateTime effectiveDate,
    String? source,
    String? notes,
  }) async {
    state = const _PriceUpdateLoading();

    try {
      // Validate price
      if (price < 0) {
        throw ValidationException(
          message: 'Price cannot be negative',
          field: 'price',
        );
      }

      if (price > 1000000) {
        throw ValidationException(
          message: 'Price exceeds maximum value (1,000,000)',
          field: 'price',
        );
      }

      // Record the price in price history
      final recordId = await _repository.recordPrice(
        ingredientId: ingredientId,
        price: price,
        currency: currency,
        effectiveDate: effectiveDate,
        source: source,
        notes: notes,
      );

      // PRICE SYNCHRONIZATION: Also update the ingredient's price_kg field
      // Note: We don't await this to avoid circular dependency issues
      // The ingredients_repository will try to create price history, but we catch that error
      try {
        // Use a flag or check to prevent infinite loop
        // We update directly without triggering price history creation again
        final db = ref.read(appDatabase);
        await db.update(
          IngredientsRepository.tableName,
          IngredientsRepository.colId,
          ingredientId,
          {IngredientsRepository.colPriceKg: price},
        );
        AppLogger.info(
          'Synced price to ingredient $ingredientId: $price',
          tag: _tag,
        );
      } catch (e) {
        // Log but don't fail - price history is still recorded
        AppLogger.warning(
          'Failed to sync price to ingredient: $e',
          tag: _tag,
        );
      }

      // Create success state with recorded data
      final priceHistory = PriceHistory(
        id: recordId,
        ingredientId: ingredientId,
        price: price,
        currency: currency,
        effectiveDate: effectiveDate,
        source: source ?? 'user',
        notes: notes,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      AppLogger.info(
        'Recorded price for ingredient $ingredientId: $price $currency',
        tag: _tag,
      );

      state = PriceUpdateSuccess(
        priceHistory: priceHistory,
        message: 'Price updated successfully',
      );

      // Invalidate price history cache for this ingredient
      ref.invalidate(priceHistoryProvider(ingredientId));
    } on ValidationException catch (e) {
      AppLogger.warning('Validation error: ${e.message}', tag: _tag);
      state = PriceUpdateError(
        message: e.message,
        error: e,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error recording price: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = PriceUpdateError(
        message: 'Failed to update price. Please try again.',
        error: e,
      );
    }
  }

  /// Update an existing price record
  Future<void> updatePrice({
    required int priceId,
    required double price,
    String? notes,
  }) async {
    state = const _PriceUpdateLoading();

    try {
      // Validate price
      if (price < 0) {
        throw ValidationException(
          message: 'Price cannot be negative',
          field: 'price',
        );
      }

      if (price > 1000000) {
        throw ValidationException(
          message: 'Price exceeds maximum value',
          field: 'price',
        );
      }

      // Get existing record to find ingredient
      final existing = await _repository.getSingle(priceId);
      if (existing == null) {
        throw RepositoryException(
          operation: 'update',
          message: 'Price record not found',
        );
      }

      // Update the record
      await _repository.update({
        'price': price,
        'notes': notes,
      }, priceId);

      AppLogger.info('Updated price record $priceId', tag: _tag);

      state = PriceUpdateSuccess(
        priceHistory: existing.copyWith(price: price, notes: notes),
        message: 'Price updated successfully',
      );

      // Invalidate cache
      ref.invalidate(priceHistoryProvider(existing.ingredientId));
    } on ValidationException catch (e) {
      AppLogger.warning('Validation error: ${e.message}', tag: _tag);
      state = PriceUpdateError(
        message: e.message,
        error: e,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating price: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = PriceUpdateError(
        message: 'Failed to update price. Please try again.',
        error: e,
      );
    }
  }

  /// Delete a price record
  Future<void> deletePrice({
    required int priceId,
    required int ingredientId,
  }) async {
    state = const _PriceUpdateLoading();

    try {
      await _repository.delete(priceId);

      AppLogger.info('Deleted price record $priceId', tag: _tag);

      state = PriceUpdateSuccess(
        priceHistory: PriceHistory(
          id: null,
          ingredientId: 0,
          price: 0,
          currency: 'NGN',
          effectiveDate: _zeroDate,
          source: 'system',
          createdAt: 0,
        ),
        message: 'Price record deleted',
      );

      // Invalidate cache
      ref.invalidate(priceHistoryProvider(ingredientId));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting price: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = PriceUpdateError(
        message: 'Failed to delete price record',
        error: e,
      );
    }
  }

  /// Reset state to idle
  void reset() {
    state = const _PriceUpdateIdle();
  }
}

/// Provider for price update notifier
final priceUpdateNotifier =
    NotifierProvider<PriceUpdateNotifier, PriceUpdateState>(
  PriceUpdateNotifier.new,
);

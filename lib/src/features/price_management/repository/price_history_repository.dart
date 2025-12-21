import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/core/exceptions/app_exceptions.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/core/repositories/repository.dart';
import 'package:feed_estimator/src/features/price_management/model/price_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final priceHistoryRepository = Provider((ref) {
  final db = ref.watch(appDatabase);
  return PriceHistoryRepository(db);
});

/// Repository for managing ingredient price history
///
/// Handles:
/// - Recording price changes over time
/// - Retrieving historical prices for trends
/// - Calculating price statistics
class PriceHistoryRepository implements Repository {
  PriceHistoryRepository(this.db);

  final AppDatabase db;

  static const String _tag = 'PriceHistoryRepository';
  static const String tableName = 'price_history';

  static const String colId = 'id';
  static const String colIngredientId = 'ingredient_id';
  static const String colPrice = 'price';
  static const String colCurrency = 'currency';
  static const String colEffectiveDate = 'effective_date';
  static const String colSource = 'source';
  static const String colNotes = 'notes';
  static const String colCreatedAt = 'created_at';

  @override
  Future<int> create(Map<String, Object?> data) async {
    try {
      final result = await db.insertOne(tableName, data);
      AppLogger.info('Created price history record ID: $result', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error creating price history: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'create',
        message: 'Failed to create price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Record a new price for an ingredient
  Future<int> recordPrice({
    required int ingredientId,
    required double price,
    required String currency,
    required DateTime effectiveDate,
    String? source,
    String? notes,
  }) async {
    return create({
      colIngredientId: ingredientId,
      colPrice: price,
      colCurrency: currency,
      colEffectiveDate: effectiveDate.millisecondsSinceEpoch,
      colSource: source ?? 'user',
      colNotes: notes,
      colCreatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  /// Get all price history for an ingredient
  Future<List<PriceHistory>> getHistoryForIngredient(int ingredientId) async {
    try {
      final raw = await db.selectByParam(
        tableName,
        query: colIngredientId,
        param: ingredientId,
      );
      // Convert to mutable list before sorting (QueryResultSet is read-only)
      final mutableList = List<Map<String, Object?>>.from(raw);
      // Sort by effective date descending (most recent first)
      mutableList.sort((a, b) =>
          (b[colEffectiveDate] as int).compareTo(a[colEffectiveDate] as int));
      AppLogger.debug(
        'Retrieved ${mutableList.length} price history records for ingredient $ingredientId',
        tag: _tag,
      );
      return mutableList.map((item) => PriceHistory.fromJson(item)).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting price history for ingredient $ingredientId: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'getHistoryForIngredient',
        message: 'Failed to retrieve price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get latest price for an ingredient
  Future<PriceHistory?> getLatestPrice(int ingredientId) async {
    try {
      final history = await getHistoryForIngredient(ingredientId);
      if (history.isEmpty) return null;
      return history.first; // Already sorted by date desc
    } catch (e) {
      AppLogger.warning(
        'Error getting latest price for ingredient $ingredientId: $e',
        tag: _tag,
      );
      return null;
    }
  }

  /// Get price history for a date range
  Future<List<PriceHistory>> getHistoryByDateRange({
    required int ingredientId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final all = await getHistoryForIngredient(ingredientId);
      final filtered = all
          .where((p) =>
              p.effectiveDate.isAfter(startDate) &&
              p.effectiveDate.isBefore(endDate.add(Duration(days: 1))))
          .toList();
      AppLogger.info(
        'Retrieved ${filtered.length} price records for ingredient $ingredientId between $startDate and $endDate',
        tag: _tag,
      );
      return filtered;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error getting price history by date range: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'getHistoryByDateRange',
        message: 'Failed to retrieve price history for date range',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Calculate average price over a period
  Future<double> calculateAveragePrice({
    required int ingredientId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final history = await getHistoryByDateRange(
        ingredientId: ingredientId,
        startDate: startDate,
        endDate: endDate,
      );
      if (history.isEmpty) return 0;
      final sum = history.fold<double>(0, (prev, curr) => prev + curr.price);
      return sum / history.length;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error calculating average price: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'calculateAveragePrice',
        message: 'Failed to calculate average price',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> update(Map<String, Object?> data, num id) async {
    try {
      final result = await db.update(tableName, colId, id, data);
      AppLogger.info('Updated price history ID: $id', tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error updating price history $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'update',
        message: 'Failed to update price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<PriceHistory?> getSingle(int id) async {
    try {
      final raw = await db.select(tableName, colId, id);
      if (raw.isEmpty) return null;
      return PriceHistory.fromJson(raw.first);
    } catch (e, stackTrace) {
      AppLogger.error('Error getting price history $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<List<PriceHistory>> getAll() async {
    try {
      final raw = await db.selectAll(tableName);
      AppLogger.debug('Retrieved ${raw.length} total price history records',
          tag: _tag);
      return raw.map((item) => PriceHistory.fromJson(item)).toList();
    } catch (e, stackTrace) {
      AppLogger.error('Error getting all price history: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'getAll',
        message: 'Failed to retrieve price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> delete(num id) async {
    try {
      final result = await db.delete(
        tableName: tableName,
        query: colId,
        param: id,
      );
      AppLogger.info('Deleted price history $id, rows affected: $result',
          tag: _tag);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error('Error deleting price history $id: $e',
          tag: _tag, error: e, stackTrace: stackTrace);
      throw RepositoryException(
        operation: 'delete',
        message: 'Failed to delete price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete all price history for an ingredient (cascades automatically)
  Future<int> deleteIngredientHistory(int ingredientId) async {
    try {
      final result = await db.deleteByParam(
        tableName: tableName,
        query: colIngredientId,
        param: ingredientId,
      ) as int;
      AppLogger.info(
        'Deleted price history for ingredient $ingredientId, rows affected: $result',
        tag: _tag,
      );
      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error deleting price history for ingredient $ingredientId: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'deleteIngredientHistory',
        message: 'Failed to delete ingredient price history',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(priceHistory)
final priceHistoryProvider = PriceHistoryFamily._();

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

final class PriceHistoryProvider extends $FunctionalProvider<
        AsyncValue<List<PriceHistory>>,
        List<PriceHistory>,
        FutureOr<List<PriceHistory>>>
    with
        $FutureModifier<List<PriceHistory>>,
        $FutureProvider<List<PriceHistory>> {
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
  PriceHistoryProvider._(
      {required PriceHistoryFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'priceHistoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$priceHistoryHash();

  @override
  String toString() {
    return r'priceHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PriceHistory>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<PriceHistory>> create(Ref ref) {
    final argument = this.argument as int;
    return priceHistory(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceHistoryHash() => r'32dcbc88469a7c8f404472ada666400c80b0f7d3';

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

final class PriceHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PriceHistory>>, int> {
  PriceHistoryFamily._()
      : super(
          retry: null,
          name: r'priceHistoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

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

  PriceHistoryProvider call(
    int ingredientId,
  ) =>
      PriceHistoryProvider._(argument: ingredientId, from: this);

  @override
  String toString() => r'priceHistoryProvider';
}

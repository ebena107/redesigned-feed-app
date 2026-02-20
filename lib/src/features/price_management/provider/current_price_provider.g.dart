// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(currentPrice)
final currentPriceProvider = CurrentPriceFamily._();

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

final class CurrentPriceProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
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
  CurrentPriceProvider._(
      {required CurrentPriceFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'currentPriceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentPriceHash();

  @override
  String toString() {
    return r'currentPriceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as int;
    return currentPrice(
      ref,
      ingredientId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentPriceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentPriceHash() => r'7960328da923a22528908f98e3c8b1873912ddfa';

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

final class CurrentPriceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, int> {
  CurrentPriceFamily._()
      : super(
          retry: null,
          name: r'currentPriceProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

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

  CurrentPriceProvider call({
    required int ingredientId,
  }) =>
      CurrentPriceProvider._(argument: ingredientId, from: this);

  @override
  String toString() => r'currentPriceProvider';
}

/// Track price change from default

@ProviderFor(priceChange)
final priceChangeProvider = PriceChangeFamily._();

/// Track price change from default

final class PriceChangeProvider extends $FunctionalProvider<
        AsyncValue<PriceChange>, PriceChange, FutureOr<PriceChange>>
    with $FutureModifier<PriceChange>, $FutureProvider<PriceChange> {
  /// Track price change from default
  PriceChangeProvider._(
      {required PriceChangeFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'priceChangeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$priceChangeHash();

  @override
  String toString() {
    return r'priceChangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PriceChange> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PriceChange> create(Ref ref) {
    final argument = this.argument as int;
    return priceChange(
      ref,
      ingredientId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceChangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$priceChangeHash() => r'9b4a229fd44784f295a79780daf48da5776fde18';

/// Track price change from default

final class PriceChangeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PriceChange>, int> {
  PriceChangeFamily._()
      : super(
          retry: null,
          name: r'priceChangeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Track price change from default

  PriceChangeProvider call({
    required int ingredientId,
  }) =>
      PriceChangeProvider._(argument: ingredientId, from: this);

  @override
  String toString() => r'priceChangeProvider';
}

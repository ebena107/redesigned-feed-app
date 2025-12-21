// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentPriceHash() => r'aa27405a1a32635ed0dd39a59db7aef49f39b548';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

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
/// Copied from [currentPrice].
@ProviderFor(currentPrice)
const currentPriceProvider = CurrentPriceFamily();

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
/// Copied from [currentPrice].
class CurrentPriceFamily extends Family<AsyncValue<double>> {
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
  /// Copied from [currentPrice].
  const CurrentPriceFamily();

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
  /// Copied from [currentPrice].
  CurrentPriceProvider call({
    required int ingredientId,
  }) {
    return CurrentPriceProvider(
      ingredientId: ingredientId,
    );
  }

  @override
  CurrentPriceProvider getProviderOverride(
    covariant CurrentPriceProvider provider,
  ) {
    return call(
      ingredientId: provider.ingredientId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currentPriceProvider';
}

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
/// Copied from [currentPrice].
class CurrentPriceProvider extends AutoDisposeFutureProvider<double> {
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
  /// Copied from [currentPrice].
  CurrentPriceProvider({
    required int ingredientId,
  }) : this._internal(
          (ref) => currentPrice(
            ref as CurrentPriceRef,
            ingredientId: ingredientId,
          ),
          from: currentPriceProvider,
          name: r'currentPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentPriceHash,
          dependencies: CurrentPriceFamily._dependencies,
          allTransitiveDependencies:
              CurrentPriceFamily._allTransitiveDependencies,
          ingredientId: ingredientId,
        );

  CurrentPriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ingredientId,
  }) : super.internal();

  final int ingredientId;

  @override
  Override overrideWith(
    FutureOr<double> Function(CurrentPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentPriceProvider._internal(
        (ref) => create(ref as CurrentPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ingredientId: ingredientId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _CurrentPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentPriceProvider && other.ingredientId == ingredientId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ingredientId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CurrentPriceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `ingredientId` of this provider.
  int get ingredientId;
}

class _CurrentPriceProviderElement
    extends AutoDisposeFutureProviderElement<double> with CurrentPriceRef {
  _CurrentPriceProviderElement(super.provider);

  @override
  int get ingredientId => (origin as CurrentPriceProvider).ingredientId;
}

String _$priceChangeHash() => r'9b4a229fd44784f295a79780daf48da5776fde18';

/// Track price change from default
///
/// Copied from [priceChange].
@ProviderFor(priceChange)
const priceChangeProvider = PriceChangeFamily();

/// Track price change from default
///
/// Copied from [priceChange].
class PriceChangeFamily extends Family<AsyncValue<PriceChange>> {
  /// Track price change from default
  ///
  /// Copied from [priceChange].
  const PriceChangeFamily();

  /// Track price change from default
  ///
  /// Copied from [priceChange].
  PriceChangeProvider call({
    required int ingredientId,
  }) {
    return PriceChangeProvider(
      ingredientId: ingredientId,
    );
  }

  @override
  PriceChangeProvider getProviderOverride(
    covariant PriceChangeProvider provider,
  ) {
    return call(
      ingredientId: provider.ingredientId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'priceChangeProvider';
}

/// Track price change from default
///
/// Copied from [priceChange].
class PriceChangeProvider extends AutoDisposeFutureProvider<PriceChange> {
  /// Track price change from default
  ///
  /// Copied from [priceChange].
  PriceChangeProvider({
    required int ingredientId,
  }) : this._internal(
          (ref) => priceChange(
            ref as PriceChangeRef,
            ingredientId: ingredientId,
          ),
          from: priceChangeProvider,
          name: r'priceChangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceChangeHash,
          dependencies: PriceChangeFamily._dependencies,
          allTransitiveDependencies:
              PriceChangeFamily._allTransitiveDependencies,
          ingredientId: ingredientId,
        );

  PriceChangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ingredientId,
  }) : super.internal();

  final int ingredientId;

  @override
  Override overrideWith(
    FutureOr<PriceChange> Function(PriceChangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceChangeProvider._internal(
        (ref) => create(ref as PriceChangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ingredientId: ingredientId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PriceChange> createElement() {
    return _PriceChangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceChangeProvider && other.ingredientId == ingredientId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ingredientId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceChangeRef on AutoDisposeFutureProviderRef<PriceChange> {
  /// The parameter `ingredientId` of this provider.
  int get ingredientId;
}

class _PriceChangeProviderElement
    extends AutoDisposeFutureProviderElement<PriceChange> with PriceChangeRef {
  _PriceChangeProviderElement(super.provider);

  @override
  int get ingredientId => (origin as PriceChangeProvider).ingredientId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

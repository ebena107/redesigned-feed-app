// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$priceHistoryHash() => r'32dcbc88469a7c8f404472ada666400c80b0f7d3';

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
///
/// Copied from [priceHistory].
@ProviderFor(priceHistory)
const priceHistoryProvider = PriceHistoryFamily();

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
///
/// Copied from [priceHistory].
class PriceHistoryFamily extends Family<AsyncValue<List<PriceHistory>>> {
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
  ///
  /// Copied from [priceHistory].
  const PriceHistoryFamily();

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
  ///
  /// Copied from [priceHistory].
  PriceHistoryProvider call(
    int ingredientId,
  ) {
    return PriceHistoryProvider(
      ingredientId,
    );
  }

  @override
  PriceHistoryProvider getProviderOverride(
    covariant PriceHistoryProvider provider,
  ) {
    return call(
      provider.ingredientId,
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
  String? get name => r'priceHistoryProvider';
}

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
///
/// Copied from [priceHistory].
class PriceHistoryProvider extends FutureProvider<List<PriceHistory>> {
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
  ///
  /// Copied from [priceHistory].
  PriceHistoryProvider(
    int ingredientId,
  ) : this._internal(
          (ref) => priceHistory(
            ref as PriceHistoryRef,
            ingredientId,
          ),
          from: priceHistoryProvider,
          name: r'priceHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceHistoryHash,
          dependencies: PriceHistoryFamily._dependencies,
          allTransitiveDependencies:
              PriceHistoryFamily._allTransitiveDependencies,
          ingredientId: ingredientId,
        );

  PriceHistoryProvider._internal(
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
    FutureOr<List<PriceHistory>> Function(PriceHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceHistoryProvider._internal(
        (ref) => create(ref as PriceHistoryRef),
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
  FutureProviderElement<List<PriceHistory>> createElement() {
    return _PriceHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryProvider && other.ingredientId == ingredientId;
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
mixin PriceHistoryRef on FutureProviderRef<List<PriceHistory>> {
  /// The parameter `ingredientId` of this provider.
  int get ingredientId;
}

class _PriceHistoryProviderElement
    extends FutureProviderElement<List<PriceHistory>> with PriceHistoryRef {
  _PriceHistoryProviderElement(super.provider);

  @override
  int get ingredientId => (origin as PriceHistoryProvider).ingredientId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

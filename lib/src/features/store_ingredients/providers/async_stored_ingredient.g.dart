// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_stored_ingredient.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncStoredIngredients)
const asyncStoredIngredientsProvider = AsyncStoredIngredientsProvider._();

final class AsyncStoredIngredientsProvider
    extends $AsyncNotifierProvider<AsyncStoredIngredients, List<Ingredient>> {
  const AsyncStoredIngredientsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncStoredIngredientsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$asyncStoredIngredientsHash();

  @$internal
  @override
  AsyncStoredIngredients create() => AsyncStoredIngredients();
}

String _$asyncStoredIngredientsHash() =>
    r'f19b32902c3a64c59b60bbc0c182eb204e106393';

abstract class _$AsyncStoredIngredients
    extends $AsyncNotifier<List<Ingredient>> {
  FutureOr<List<Ingredient>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Ingredient>>, List<Ingredient>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Ingredient>>, List<Ingredient>>,
        AsyncValue<List<Ingredient>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(quantityController)
const quantityControllerProvider = QuantityControllerProvider._();

final class QuantityControllerProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  const QuantityControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'quantityControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$quantityControllerHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return quantityController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$quantityControllerHash() =>
    r'8daae0f7b339c78d526bfc2efb7c3d82bd49b090';

@ProviderFor(storedIngredientFormKey)
const storedIngredientFormKeyProvider = StoredIngredientFormKeyProvider._();

final class StoredIngredientFormKeyProvider extends $FunctionalProvider<
    GlobalKey<FormState>,
    GlobalKey<FormState>,
    GlobalKey<FormState>> with $Provider<GlobalKey<FormState>> {
  const StoredIngredientFormKeyProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storedIngredientFormKeyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storedIngredientFormKeyHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<FormState>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GlobalKey<FormState> create(Ref ref) {
    return storedIngredientFormKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<FormState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<FormState>>(value),
    );
  }
}

String _$storedIngredientFormKeyHash() =>
    r'4106885a5961ec26e0dc3bed50ea271e1e6c4785';

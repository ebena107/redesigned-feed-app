// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_stored_ingredient.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncStoredIngredients)
final asyncStoredIngredientsProvider = AsyncStoredIngredientsProvider._();

final class AsyncStoredIngredientsProvider
    extends $AsyncNotifierProvider<AsyncStoredIngredients, List<Ingredient>> {
  AsyncStoredIngredientsProvider._()
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
    r'b6ee4ec46cb938e2b4161ffbe65ed27bd37970c3';

abstract class _$AsyncStoredIngredients
    extends $AsyncNotifier<List<Ingredient>> {
  FutureOr<List<Ingredient>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Ingredient>>, List<Ingredient>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Ingredient>>, List<Ingredient>>,
        AsyncValue<List<Ingredient>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(quantityController)
final quantityControllerProvider = QuantityControllerProvider._();

final class QuantityControllerProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  QuantityControllerProvider._()
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
    r'0bf3bdfb2466cfd8119b5be6b84b0c0d7be0e1f1';

@ProviderFor(storedIngredientFormKey)
final storedIngredientFormKeyProvider = StoredIngredientFormKeyProvider._();

final class StoredIngredientFormKeyProvider extends $FunctionalProvider<
    GlobalKey<FormState>,
    GlobalKey<FormState>,
    GlobalKey<FormState>> with $Provider<GlobalKey<FormState>> {
  StoredIngredientFormKeyProvider._()
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
    r'074f662434c31bddf73489ab618fc98d0959a074';

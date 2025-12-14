// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_stored_ingredient.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quantityControllerHash() =>
    r'0bf3bdfb2466cfd8119b5be6b84b0c0d7be0e1f1';

/// See also [quantityController].
@ProviderFor(quantityController)
final quantityControllerProvider = AutoDisposeProvider<String>.internal(
  quantityController,
  name: r'quantityControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quantityControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuantityControllerRef = AutoDisposeProviderRef<String>;
String _$storedIngredientFormKeyHash() =>
    r'074f662434c31bddf73489ab618fc98d0959a074';

/// See also [storedIngredientFormKey].
@ProviderFor(storedIngredientFormKey)
final storedIngredientFormKeyProvider =
    AutoDisposeProvider<GlobalKey<FormState>>.internal(
  storedIngredientFormKey,
  name: r'storedIngredientFormKeyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storedIngredientFormKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoredIngredientFormKeyRef
    = AutoDisposeProviderRef<GlobalKey<FormState>>;
String _$asyncStoredIngredientsHash() =>
    r'b6ee4ec46cb938e2b4161ffbe65ed27bd37970c3';

/// See also [AsyncStoredIngredients].
@ProviderFor(AsyncStoredIngredients)
final asyncStoredIngredientsProvider = AutoDisposeAsyncNotifierProvider<
    AsyncStoredIngredients, List<Ingredient>>.internal(
  AsyncStoredIngredients.new,
  name: r'asyncStoredIngredientsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$asyncStoredIngredientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncStoredIngredients = AutoDisposeAsyncNotifier<List<Ingredient>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

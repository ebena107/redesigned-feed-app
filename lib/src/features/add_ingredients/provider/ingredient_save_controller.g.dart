// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientSaveController)
final ingredientSaveControllerProvider = IngredientSaveControllerProvider._();

final class IngredientSaveControllerProvider
    extends $AsyncNotifierProvider<IngredientSaveController, void> {
  IngredientSaveControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ingredientSaveControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ingredientSaveControllerHash();

  @$internal
  @override
  IngredientSaveController create() => IngredientSaveController();
}

String _$ingredientSaveControllerHash() =>
    r'3abdc4a3aed45b8cf0ff6a79c35a23d665b93864';

abstract class _$IngredientSaveController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

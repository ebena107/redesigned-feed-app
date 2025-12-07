// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_update_feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SaveUpdateFeedController)
const saveUpdateFeedControllerProvider = SaveUpdateFeedControllerProvider._();

final class SaveUpdateFeedControllerProvider
    extends $AsyncNotifierProvider<SaveUpdateFeedController, void> {
  const SaveUpdateFeedControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'saveUpdateFeedControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$saveUpdateFeedControllerHash();

  @$internal
  @override
  SaveUpdateFeedController create() => SaveUpdateFeedController();
}

String _$saveUpdateFeedControllerHash() =>
    r'27397d5e27364a132aa2d654c861c7e9e42c3d07';

abstract class _$SaveUpdateFeedController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, null);
  }
}

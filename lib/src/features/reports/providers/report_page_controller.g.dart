// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportPageController)
final reportPageControllerProvider = ReportPageControllerProvider._();

final class ReportPageControllerProvider
    extends $AsyncNotifierProvider<ReportPageController, void> {
  ReportPageControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reportPageControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reportPageControllerHash();

  @$internal
  @override
  ReportPageController create() => ReportPageController();
}

String _$reportPageControllerHash() =>
    r'51021efa5a0a5a44583d6f08be6e1f61aede391b';

abstract class _$ReportPageController extends $AsyncNotifier<void> {
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

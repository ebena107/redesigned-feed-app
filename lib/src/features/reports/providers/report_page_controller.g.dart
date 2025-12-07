// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportPageController)
const reportPageControllerProvider = ReportPageControllerProvider._();

final class ReportPageControllerProvider
    extends $AsyncNotifierProvider<ReportPageController, void> {
  const ReportPageControllerProvider._()
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
    r'c6628b2ee8214715369612090cff380ad9bb82ac';

abstract class _$ReportPageController extends $AsyncNotifier<void> {
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

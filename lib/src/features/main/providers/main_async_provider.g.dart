// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_async_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncMain)
const asyncMainProvider = AsyncMainProvider._();

final class AsyncMainProvider
    extends $AsyncNotifierProvider<AsyncMain, List<Feed>> {
  const AsyncMainProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncMainProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$asyncMainHash();

  @$internal
  @override
  AsyncMain create() => AsyncMain();
}

String _$asyncMainHash() => r'150ad0e6b10ae305f9350894775de71b142adfad';

abstract class _$AsyncMain extends $AsyncNotifier<List<Feed>> {
  FutureOr<List<Feed>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Feed>>, List<Feed>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Feed>>, List<Feed>>,
        AsyncValue<List<Feed>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

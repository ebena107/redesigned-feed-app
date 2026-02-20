// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncFeed)
final asyncFeedProvider = AsyncFeedProvider._();

final class AsyncFeedProvider extends $AsyncNotifierProvider<AsyncFeed, void> {
  AsyncFeedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'asyncFeedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$asyncFeedHash();

  @$internal
  @override
  AsyncFeed create() => AsyncFeed();
}

String _$asyncFeedHash() => r'8308fb0ef8bd56118859c26297a8c63b468bf4d2';

abstract class _$AsyncFeed extends $AsyncNotifier<void> {
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

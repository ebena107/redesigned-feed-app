// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_async_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async provider for loading and managing feeds from repository
/// Handles loading, deletion, and updates with automatic state management

@ProviderFor(AsyncMain)
final asyncMainProvider = AsyncMainProvider._();

/// Async provider for loading and managing feeds from repository
/// Handles loading, deletion, and updates with automatic state management
final class AsyncMainProvider
    extends $AsyncNotifierProvider<AsyncMain, List<Feed>> {
  /// Async provider for loading and managing feeds from repository
  /// Handles loading, deletion, and updates with automatic state management
  AsyncMainProvider._()
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

String _$asyncMainHash() => r'93bf6076b77fd667b8d7eeddf4398ded669751cc';

/// Async provider for loading and managing feeds from repository
/// Handles loading, deletion, and updates with automatic state management

abstract class _$AsyncMain extends $AsyncNotifier<List<Feed>> {
  FutureOr<List<Feed>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Feed>>, List<Feed>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Feed>>, List<Feed>>,
        AsyncValue<List<Feed>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

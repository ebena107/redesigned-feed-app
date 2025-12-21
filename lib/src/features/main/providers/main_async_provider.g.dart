// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_async_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$asyncMainHash() => r'93bf6076b77fd667b8d7eeddf4398ded669751cc';

/// Async provider for loading and managing feeds from repository
/// Handles loading, deletion, and updates with automatic state management
///
/// Copied from [AsyncMain].
@ProviderFor(AsyncMain)
final asyncMainProvider =
    AutoDisposeAsyncNotifierProvider<AsyncMain, List<Feed>>.internal(
  AsyncMain.new,
  name: r'asyncMainProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$asyncMainHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AsyncMain = AutoDisposeAsyncNotifier<List<Feed>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

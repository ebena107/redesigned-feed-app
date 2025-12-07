// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeviceLocale)
const deviceLocaleProvider = DeviceLocaleProvider._();

final class DeviceLocaleProvider
    extends $AsyncNotifierProvider<DeviceLocale, String?> {
  const DeviceLocaleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deviceLocaleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deviceLocaleHash();

  @$internal
  @override
  DeviceLocale create() => DeviceLocale();
}

String _$deviceLocaleHash() => r'd04221415b0178ae8bc05a51e689a361712dd7de';

abstract class _$DeviceLocale extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<String?>, String?>,
        AsyncValue<String?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

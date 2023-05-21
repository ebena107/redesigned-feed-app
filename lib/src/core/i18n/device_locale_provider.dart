// import 'package:devicelocale/devicelocale.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'device_locale_provider.g.dart';
//
// @riverpod
// class DeviceLocale extends _$DeviceLocale {
//
//   Future<String?> _getDefaultLocale() async {
//     try {
//       return await Devicelocale.currentLocale;
//
//
//     } on PlatformException {
//       if (kDebugMode) {
//         print("Error obtaining default locale");
//       }
//     }
//   }
//
//   @override
//   FutureOr<String?> build() async {
//     return _getDefaultLocale();
//   }
// }

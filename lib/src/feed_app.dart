import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/feature_flags.dart';
import 'package:feed_estimator/src/core/router/router.dart';
import 'package:feed_estimator/src/core/localization/localization_provider.dart';
import 'package:feed_estimator/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedApp extends ConsumerWidget {
  const FeedApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localizationProvider);
    final appSupportedLocales = ref.watch(supportedLocalesProvider);
    // Filter to locales supported by both Material and Cupertino delegates to avoid runtime errors
    final materialDelegate = GlobalMaterialLocalizations.delegate;
    final cupertinoDelegate = GlobalCupertinoLocalizations.delegate;

    List<Locale> frameworkSupportedLocales = appSupportedLocales
        .where((l) =>
            materialDelegate.isSupported(l) && cupertinoDelegate.isSupported(l))
        .toList();

    if (frameworkSupportedLocales.isEmpty) {
      frameworkSupportedLocales = const [Locale('en', 'US')];
    }

    // Ensure MaterialApp receives a framework-supported locale even if user selects an unsupported one
    Locale effectiveLocale =
        frameworkSupportedLocales.first; // Default to first supported

    // Try to match by language code first
    for (final supportedLoc in frameworkSupportedLocales) {
      if (supportedLoc.languageCode == locale.locale.languageCode) {
        effectiveLocale = supportedLoc;
        break;
      }
    }

    // If no match found, use English as fallback
    if (!frameworkSupportedLocales.contains(effectiveLocale)) {
      effectiveLocale = const Locale('en', 'US');
    }

    // Log feature flag status on app startup
    FeatureFlags.logStatus();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // Enable edge-to-edge without invoking deprecated system bar color APIs
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return MaterialApp.router(
      locale: effectiveLocale,
      supportedLocales: frameworkSupportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Gracefully resolve system locales to closest supported by language code
      localeResolutionCallback: (systemLocale, supported) {
        if (systemLocale == null) return supported.first;
        for (final l in supported) {
          if (l.languageCode == systemLocale.languageCode) return l;
        }
        return supported.first;
      },
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Feed Estimator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.mainAppColor,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}

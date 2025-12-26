import 'dart:ui';

import 'package:feed_estimator/src/core/localization/localization_provider.dart';
import 'package:feed_estimator/src/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerErrorHandlers();

  // Initialize SharedPreferences for localization
  final sharedPreferences = await SharedPreferences.getInstance();

  // Show splash screen during initialization
  runApp(
    ProviderScope(
      overrides: [
        // Override localizationProvider with initialized SharedPreferences
        localizationProvider.overrideWith(
          (ref) => LocalizationNotifier(sharedPreferences),
        ),
      ],
      child: const AppWithSplash(),
    ),
  );
}

/// Wraps FeedApp with splash screen for initialization
class AppWithSplash extends StatelessWidget {
  const AppWithSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}

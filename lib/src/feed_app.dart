import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/router.dart';

class FeedApp extends ConsumerWidget {
  const FeedApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp.router(
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('en', 'NGR')
      // ],

      routerConfig: router,
      debugShowCheckedModeBanner: false,

      title: 'Feed Estimator',
      // routeInformationParser: router.routeInformationParser,
      // routeInformationProvider: router.routeInformationProvider,
      // routerDelegate: router.routerDelegate,
    );
  }
}

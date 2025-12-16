import 'package:feed_estimator/src/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(ref) {
  final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

  final router = GoRouter(
    navigatorKey: routerKey,
    initialLocation: '/',
    routes: $appRoutes,
    debugLogDiagnostics: true,
  );
  ref.onDispose(router.dispose);
  return router;
}

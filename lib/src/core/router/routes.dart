import 'package:feed_estimator/src/features/About/about.dart';
import 'package:feed_estimator/src/features/add_ingredients/view/new_ingredient.dart';
import 'package:feed_estimator/src/features/add_update_feed/view/add_update_feed.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/view/feed_ingredients_list.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/view/feed_home.dart';
import 'package:feed_estimator/src/features/reports/view/report.dart';
import 'package:feed_estimator/src/features/reports/widget/pdf_export/pdf_preview.dart';
import 'package:feed_estimator/src/features/settings/settings_screen.dart';
import 'package:feed_estimator/src/features/store_feeds/view/stored_feeds.dart';
import 'package:feed_estimator/src/features/store_ingredients/view/stored_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    // === SUB-FEATURES OF HOME ===
    TypedGoRoute<AddFeedRoute>(
      path: 'newFeed',
      routes: [TypedGoRoute<NewFeedIngredientsRoute>(path: 'ingredientList')],
    ),
    TypedGoRoute<ReportRoute>(
      path: 'report/:feedId',
      routes: [TypedGoRoute<PdfRoute>(path: 'pdf')],
    ),
    TypedGoRoute<FeedRoute>(
      path: "feed/:feedId",
      routes: [
        TypedGoRoute<EditFeedRoute>(path: 'editFeed'),
        TypedGoRoute<FeedIngredientsRoute>(path: 'feedIngredient'),
      ],
    ),

    // === TOP LEVEL SCREENS (Moved Inside) ===
    // Note: 'path' does not need the leading '/' when nested

    // 1. FEED STORE
    TypedGoRoute<FeedStoreRoute>(
      path: '/feedStore',
    ),

    // 2. INGREDIENT STORE
    TypedGoRoute<IngredientStoreRoute>(
      path: '/ingredientStore',
    ),

    // 3. NEW INGREDIENT
    TypedGoRoute<NewIngredientRoute>(
      path: '/newIngredient',
    ),

    // 4. SETTINGS
    TypedGoRoute<SettingsRoute>(
      path: '/settings',
    ),

    // 5. ABOUT
    TypedGoRoute<AboutRoute>(
      path: '/about',
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainView();
  }
}

// ==========================================
// ROUTE DATA CLASSES
// ==========================================

@immutable
class AboutRoute extends GoRouteData {
  const AboutRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const About();
}

@immutable
class FeedStoreRoute extends GoRouteData {
  const FeedStoreRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoredFeeds();
}

@immutable
class IngredientStoreRoute extends GoRouteData {
  const IngredientStoreRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoredIngredients();
}

@immutable
class NewIngredientRoute extends GoRouteData {
  const NewIngredientRoute({this.ingredientId});
  final String? ingredientId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = ingredientId ?? state.uri.queryParameters['ingredientId'];
    return NewIngredient(ingredientId: id);
  }
}

@immutable
class SettingsRoute extends GoRouteData {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

// ... [Keep AddFeedRoute, ReportRoute, PdfRoute, etc. exactly as they were]
@immutable
class AddFeedRoute extends GoRouteData {
  const AddFeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewFeedPage();
}

@immutable
class ReportRoute extends GoRouteData {
  const ReportRoute(this.feedId, {this.type});
  final int feedId;
  final String? type;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AnalysisPage(feedId: feedId, type: type);
}

@immutable
class PdfRoute extends GoRouteData {
  const PdfRoute(this.feedId, {this.type, this.$extra});
  final int feedId;
  final String? type;
  final Feed? $extra;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final extraFeed = $extra ??
        (state.extra is Feed ? state.extra as Feed : Feed(feedId: feedId));
    final reportType = type ?? '';
    return PdfPreviewPage(
      feedId: feedId,
      type: reportType,
      feed: extraFeed,
    );
  }
}

@immutable
class NewFeedIngredientsRoute extends GoRouteData {
  const NewFeedIngredientsRoute(this.feedId);
  final int? feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      IngredientList(feedId: feedId);
}

@immutable
class FeedRoute extends GoRouteData {
  const FeedRoute({required this.feedId});
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewFeedPage(feedId: feedId);
}

@immutable
class EditFeedRoute extends GoRouteData {
  const EditFeedRoute(this.feedId);
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewFeedPage(feedId: feedId);
}

@immutable
class FeedIngredientsRoute extends GoRouteData {
  const FeedIngredientsRoute(this.feedId);
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      IngredientList(feedId: feedId);
}

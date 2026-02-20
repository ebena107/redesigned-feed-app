import 'package:feed_estimator/src/features/About/about.dart';
import 'package:feed_estimator/src/features/add_ingredients/view/new_ingredient.dart';
import 'package:feed_estimator/src/features/add_update_feed/view/add_update_feed.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/view/feed_ingredients_list.dart';
import 'package:feed_estimator/src/features/feed_formulator/view/feed_formulator_screen.dart';
import 'package:feed_estimator/src/features/import_export/view/import_wizard_screen.dart';
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
    TypedGoRoute<FeedStoreRoute>(
      path: '/feedStore',
    ),
    TypedGoRoute<IngredientStoreRoute>(
      path: '/ingredientStore',
    ),
    TypedGoRoute<NewIngredientRoute>(
      path: '/newIngredient',
    ),
    TypedGoRoute<ImportWizardRoute>(
      path: '/importWizard',
    ),
    TypedGoRoute<FeedFormulatorRoute>(
      path: '/formulator',
    ),
    TypedGoRoute<SettingsRoute>(
      path: '/settings',
    ),
    TypedGoRoute<AboutRoute>(
      path: '/about',
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
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
class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const About();
}

@immutable
class FeedStoreRoute extends GoRouteData with $FeedStoreRoute {
  const FeedStoreRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoredFeeds();
}

@immutable
class IngredientStoreRoute extends GoRouteData with $IngredientStoreRoute {
  const IngredientStoreRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoredIngredients();
}

@immutable
class NewIngredientRoute extends GoRouteData with $NewIngredientRoute {
  const NewIngredientRoute({this.ingredientId});
  final String? ingredientId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = ingredientId ?? state.uri.queryParameters['ingredientId'];
    return NewIngredient(ingredientId: id);
  }
}

@immutable
class ImportWizardRoute extends GoRouteData with $ImportWizardRoute {
  const ImportWizardRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ImportWizardScreen();
}

@immutable
class FeedFormulatorRoute extends GoRouteData with $FeedFormulatorRoute {
  const FeedFormulatorRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FeedFormulatorScreen();
}

@immutable
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

// ... [Keep AddFeedRoute, ReportRoute, PdfRoute, etc. exactly as they were]
@immutable
class AddFeedRoute extends GoRouteData with $AddFeedRoute {
  const AddFeedRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewFeedPage();
}

@immutable
class ReportRoute extends GoRouteData with $ReportRoute {
  const ReportRoute(this.feedId, {this.type});
  final int feedId;
  final String? type;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AnalysisPage(feedId: feedId, type: type);
}

@immutable
class PdfRoute extends GoRouteData with $PdfRoute {
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
class NewFeedIngredientsRoute extends GoRouteData
    with $NewFeedIngredientsRoute {
  const NewFeedIngredientsRoute(this.feedId);
  final int? feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      IngredientList(feedId: feedId);
}

@immutable
class FeedRoute extends GoRouteData with $FeedRoute {
  const FeedRoute({required this.feedId});
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewFeedPage(feedId: feedId);
}

@immutable
class EditFeedRoute extends GoRouteData with $EditFeedRoute {
  const EditFeedRoute(this.feedId);
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NewFeedPage(feedId: feedId);
}

@immutable
class FeedIngredientsRoute extends GoRouteData with $FeedIngredientsRoute {
  const FeedIngredientsRoute(this.feedId);
  final int feedId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      IngredientList(feedId: feedId);
}

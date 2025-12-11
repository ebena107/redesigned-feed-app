import 'package:feed_estimator/src/features/About/about.dart';
import 'package:feed_estimator/src/features/add_update_feed/view/add_update_feed.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/view/feed_ingredients_list.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/view/feed_home.dart';
import 'package:feed_estimator/src/features/reports/view/report.dart';
import 'package:feed_estimator/src/features/reports/widget/pdf_export/pdf_preview.dart';
import 'package:feed_estimator/src/features/store_feeds/view/stored_feeds.dart';
import 'package:feed_estimator/src/features/store_ingredients/view/stored_ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/view/new_ingredient.dart';
import 'package:feed_estimator/src/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
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
        //  TypedGoRoute<ViewFeedReportRoute>(path: 'report{type}'),
      ],
    ),
  ],
)
@TypedGoRoute<AboutRoute>(path: '/about')
@TypedGoRoute<FeedStoreRoute>(path: '/feedStore')
@TypedGoRoute<IngredientStoreRoute>(path: '/ingredientStore')
@TypedGoRoute<NewIngredientRoute>(path: '/newIngredient')
@TypedGoRoute<SettingsRoute>(path: '/settings')
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainView();
  }
}

@immutable
class AboutRoute extends GoRouteData {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const About();
  }
}

@immutable
class FeedStoreRoute extends GoRouteData {
  const FeedStoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoredFeeds();
  }
}

@immutable
class IngredientStoreRoute extends GoRouteData {
  const IngredientStoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoredIngredients();
  }
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
class AddFeedRoute extends GoRouteData {
  const AddFeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewFeedPage();
  }
}

@immutable
class ReportRoute extends GoRouteData {
  const ReportRoute(this.feedId, {this.type});
  final int feedId;
  final String? type;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnalysisPage(
      feedId: feedId,
      type: type,
    );
  }
}

@immutable
class PdfRoute extends GoRouteData {
  const PdfRoute(this.feedId, {this.type, this.$extra});
  final int feedId;
  final String? type;
  final Feed? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    debugPrint('inside routes: pdfroute - ${$extra}');
    return PdfPreviewPage(
      feedId: feedId,
      type: type as String,
      feed: $extra as Feed,
    );
  }
}

@immutable
class NewFeedIngredientsRoute extends GoRouteData {
  const NewFeedIngredientsRoute(this.feedId);
  final int? feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return IngredientList(
      feedId: feedId,
    );
  }
}

@immutable
class FeedRoute extends GoRouteData {
  const FeedRoute({required this.feedId});
  final int feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewFeedPage(
      feedId: feedId,
    );
  }
}

@immutable
class FeedIngredientsRoute extends GoRouteData {
  const FeedIngredientsRoute(this.feedId);
  final int feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return IngredientList(
      feedId: feedId,
    );
  }
}

@immutable
class ViewFeedReportRoute extends GoRouteData {
  const ViewFeedReportRoute(this.feedId, this.type);
  final int feedId;
  final String type;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnalysisPage(
      feedId: feedId,
      type: type,
    );
  }
}

@immutable
class EditFeedRoute extends GoRouteData {
  const EditFeedRoute(this.feedId);
  final int feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewFeedPage(
      feedId: feedId,
    );
  }
}

@immutable
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

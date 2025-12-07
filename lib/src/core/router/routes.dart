import 'dart:async';

import 'package:feed_estimator/src/features/About/about.dart';
import 'package:feed_estimator/src/features/add_ingredients/view/new_ingredient.dart';
import 'package:feed_estimator/src/features/add_update_feed/view/add_update_feed.dart';
import 'package:feed_estimator/src/features/add_update_feed/widget/feed_ingredients/view/feed_ingredients_list.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/main/view/feed_home.dart';
import 'package:feed_estimator/src/features/reports/view/report.dart';
import 'package:feed_estimator/src/features/reports/widget/pdf_export/pdf_preview.dart';
import 'package:feed_estimator/src/features/store_feeds/view/stored_feeds.dart';
import 'package:feed_estimator/src/features/store_ingredients/view/stored_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

// --- ROUTE TREE DEFINITION ---

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    // 1. ADD NEW FEED FLOW
    TypedGoRoute<AddFeedRoute>(
      path: 'feed/new',
      routes: [
        TypedGoRoute<AddFeedIngredientsRoute>(path: 'ingredients'),
      ],
    ),

    // 2. EDIT EXISTING FEED FLOW
    TypedGoRoute<EditFeedRoute>(
      path: 'feed/:feedId',
      routes: [
        TypedGoRoute<EditFeedIngredientsRoute>(path: 'ingredients'),
      ],
    ),

    // 3. REPORT FLOW
    TypedGoRoute<ReportRoute>(
      path: 'report/:feedId',
      routes: [
        TypedGoRoute<PdfRoute>(path: 'pdf'),
      ],
    ),
  ],
)
@TypedGoRoute<AboutRoute>(path: '/about')
@TypedGoRoute<FeedStoreRoute>(path: '/store/feeds')
@TypedGoRoute<IngredientStoreRoute>(
  path: '/store/ingredients',
  routes: [
    TypedGoRoute<NewIngredientRoute>(path: 'new'),
  ],
)

// --- ROOT ROUTES ---

@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MainView();
  }
}

@immutable
class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const About();
  }
}

// --- STORE ROUTES ---

@immutable
class FeedStoreRoute extends GoRouteData with $FeedStoreRoute {
  const FeedStoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoredFeeds();
  }
}

@immutable
class IngredientStoreRoute extends GoRouteData with $IngredientStoreRoute {
  const IngredientStoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoredIngredients();
  }
}

@immutable
class NewIngredientRoute extends GoRouteData with $NewIngredientRoute {
  const NewIngredientRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewIngredient();
  }
}

// --- FEED MANAGEMENT ROUTES ---

/// Route for Creating a New Feed
@immutable
class AddFeedRoute extends GoRouteData with $AddFeedRoute {
  const AddFeedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NewFeedPage(); // Ensure NewFeedPage handles null ID as "New"
  }
}

/// Sub-route for adding ingredients to a NEW feed
@immutable
class AddFeedIngredientsRoute extends GoRouteData with $AddFeedIngredientsRoute {
  const AddFeedIngredientsRoute(this.feedId);

  final int? feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return IngredientList(feedId: feedId);
  }
}

/// Route for Editing an Existing Feed
@immutable
class EditFeedRoute extends GoRouteData with $EditFeedRoute {
  const EditFeedRoute({required this.feedId});
  final int feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewFeedPage(feedId: feedId);
  }
}

/// Sub-route for managing ingredients of an EXISTING feed
@immutable
class EditFeedIngredientsRoute extends GoRouteData with $EditFeedIngredientsRoute {
  const EditFeedIngredientsRoute(this.feedId);
  final int feedId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return IngredientList(feedId: feedId);
  }
}

// --- REPORT & PDF ROUTES ---

@immutable
class ReportRoute extends GoRouteData with $ReportRoute {
  const ReportRoute(this.feedId, {this.type});

  final int feedId;
  final String? type; // Optional Query Parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AnalysisPage(
      feedId: feedId,
      type: type,
    );
  }
}

@immutable
class PdfRoute extends GoRouteData with $PdfRoute {
  const PdfRoute(
    this.feedId, {
    this.type,
    this.$extra,
  });

  final int feedId;
  final String? type; // Inherited logic or query param
  final Feed? $extra; // Passed via `extra` object

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // Safety check: On web refresh, $extra might be null.
    // You should handle fetching data by ID if extra is null,
    // or show a loading/error state.
    if ($extra == null) {
      debugPrint('Warning: PDF Route accessed without Extra object (Feed).');
      // Ideally, return a widget that fetches the feed by feedId here
      // return PdfLoader(feedId: feedId);
    }

    return PdfPreviewPage(
      feedId: feedId,
      type: type ?? 'default', // Provide fallback
      feed: $extra!, // Assumes extra is passed; risky without check above
    );
  }
}

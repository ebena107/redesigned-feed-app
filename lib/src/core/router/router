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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

///
/// for getting routers that are present in the app
///
final routerProvider = Provider<GoRouter>(
  (ref) {
    List<GoRoute> routes = [
      GoRoute(
        name: "home",
        path: '/',
        builder: (context, state) => MainView(key: state.pageKey),
        routes: [
          GoRoute(
            name: "newFeed",
            path: 'newFeed',
            builder: (context, state) => NewFeedPage(
              id: state.pathParameters['id'],
            ),
            routes: [
              GoRoute(
                name: "ingredientList",
                path: 'ingredientList',
                builder: (context, state) => IngredientList(
                  feedId: state.pathParameters['id'],
                ),
              ),
              // GoRoute(
              //   name: "result",
              //   path: 'result',
              //   builder: (context, state) => AnalysisPage(
              //     feedId: state.extra as num,
              //   ),
              //   routes: [
              //     GoRoute(
              //       name: "pdfPreview",
              //       path: 'pdf',
              //       builder: (context, state) =>
              //           PdfPreviewPage(feed: state.extra! as Feed),
              //     ),
              //   ],
              // ),
            ],
          ),
          GoRoute(
            name: "newIngredient",
            path: 'newIngredient',
            builder: (context, state) =>
                NewIngredient(ingredientId: state.pathParameters ['id']),
          ),
          GoRoute(
            name: "result",
            path: 'result',
            builder: (context, state) => AnalysisPage(
              id: state.pathParameters['id'],
              type: state.pathParameters['type'],
            ),
            routes: [
              GoRoute(
                name: "pdfPreview",
                path: 'pdf',
                builder: (context, state) =>
                    PdfPreviewPage(feed: state.extra! as Feed, type: state.pathParameters['type'] as String,),
              ),
            ],
          ),
          GoRoute(
            name: "about",
            path: 'about',
            builder: (context, state) => const About(),
          ),
          GoRoute(
            name: "feedStore",
            path: 'feedStore',
            builder: (context, state) => const StoredFeeds(),
          ),
          GoRoute(
            name: "ingredientStore",
            path: 'ingredientStore',
            builder: (context, state) => const StoredIngredients(),
          ),
        ],
      ),
    ];

    return GoRouter(
      // debugLogDiagnostics: kDebugMode,
      initialLocation: '/',
      // debugLogDiagnostics: true, // For demo purposes
      routes: routes, //
      // All the routes can be found there
      errorPageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(state.error.toString()),
          ),
        ),
      ),
    );
  },
);

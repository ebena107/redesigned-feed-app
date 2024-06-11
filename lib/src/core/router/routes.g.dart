// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'newFeed',
          factory: $AddFeedRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'ingredientList',
              factory: $NewFeedIngredientsRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'report/:feedId',
          factory: $ReportRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'pdf',
              factory: $PdfRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'feed/:feedId',
          factory: $FeedRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'editFeed',
              factory: $EditFeedRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'feedIngredient',
              factory: $FeedIngredientsRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddFeedRouteExtension on AddFeedRoute {
  static AddFeedRoute _fromState(GoRouterState state) => const AddFeedRoute();

  String get location => GoRouteData.$location(
        '/newFeed',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NewFeedIngredientsRouteExtension on NewFeedIngredientsRoute {
  static NewFeedIngredientsRoute _fromState(GoRouterState state) =>
      NewFeedIngredientsRoute(
        _$convertMapValue('feed-id', state.uri.queryParameters, int.parse),
      );

  String get location => GoRouteData.$location(
        '/newFeed/ingredientList',
        queryParams: {
          if (feedId != null) 'feed-id': feedId!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ReportRouteExtension on ReportRoute {
  static ReportRoute _fromState(GoRouterState state) => ReportRoute(
        int.parse(state.pathParameters['feedId']!),
        type: state.uri.queryParameters['type'],
      );

  String get location => GoRouteData.$location(
        '/report/${Uri.encodeComponent(feedId.toString())}',
        queryParams: {
          if (type != null) 'type': type,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PdfRouteExtension on PdfRoute {
  static PdfRoute _fromState(GoRouterState state) => PdfRoute(
        int.parse(state.pathParameters['feedId']!),
        type: state.uri.queryParameters['type'],
        $extra: state.extra as Feed?,
      );

  String get location => GoRouteData.$location(
        '/report/${Uri.encodeComponent(feedId.toString())}/pdf',
        queryParams: {
          if (type != null) 'type': type,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $FeedRouteExtension on FeedRoute {
  static FeedRoute _fromState(GoRouterState state) => FeedRoute(
        feedId: int.parse(state.pathParameters['feedId']!),
      );

  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(feedId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditFeedRouteExtension on EditFeedRoute {
  static EditFeedRoute _fromState(GoRouterState state) => EditFeedRoute(
        int.parse(state.pathParameters['feedId']!),
      );

  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(feedId.toString())}/editFeed',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FeedIngredientsRouteExtension on FeedIngredientsRoute {
  static FeedIngredientsRoute _fromState(GoRouterState state) =>
      FeedIngredientsRoute(
        int.parse(state.pathParameters['feedId']!),
      );

  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(feedId.toString())}/feedIngredient',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

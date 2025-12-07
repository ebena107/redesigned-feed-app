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
      factory: $HomeRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'newFeed',
          factory: $AddFeedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'ingredientList',
              factory: $NewFeedIngredientsRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'report/:feedId',
          factory: $ReportRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'pdf',
              factory: $PdfRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'feed/:feedId',
          factory: $FeedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'editFeed',
              factory: $EditFeedRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'feedIngredient',
              factory: $FeedIngredientsRoute._fromState,
            ),
          ],
        ),
      ],
    );

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AddFeedRoute on GoRouteData {
  static AddFeedRoute _fromState(GoRouterState state) => const AddFeedRoute();

  @override
  String get location => GoRouteData.$location(
        '/newFeed',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NewFeedIngredientsRoute on GoRouteData {
  static NewFeedIngredientsRoute _fromState(GoRouterState state) =>
      NewFeedIngredientsRoute(
        _$convertMapValue('feed-id', state.uri.queryParameters, int.tryParse),
      );

  NewFeedIngredientsRoute get _self => this as NewFeedIngredientsRoute;

  @override
  String get location => GoRouteData.$location(
        '/newFeed/ingredientList',
        queryParams: {
          if (_self.feedId != null) 'feed-id': _self.feedId!.toString(),
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ReportRoute on GoRouteData {
  static ReportRoute _fromState(GoRouterState state) => ReportRoute(
        int.parse(state.pathParameters['feedId']!),
        type: state.uri.queryParameters['type'],
      );

  ReportRoute get _self => this as ReportRoute;

  @override
  String get location => GoRouteData.$location(
        '/report/${Uri.encodeComponent(_self.feedId.toString())}',
        queryParams: {
          if (_self.type != null) 'type': _self.type,
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PdfRoute on GoRouteData {
  static PdfRoute _fromState(GoRouterState state) => PdfRoute(
        int.parse(state.pathParameters['feedId']!),
        type: state.uri.queryParameters['type'],
        $extra: state.extra as Feed?,
      );

  PdfRoute get _self => this as PdfRoute;

  @override
  String get location => GoRouteData.$location(
        '/report/${Uri.encodeComponent(_self.feedId.toString())}/pdf',
        queryParams: {
          if (_self.type != null) 'type': _self.type,
        },
      );

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin $FeedRoute on GoRouteData {
  static FeedRoute _fromState(GoRouterState state) => FeedRoute(
        feedId: int.parse(state.pathParameters['feedId']!),
      );

  FeedRoute get _self => this as FeedRoute;

  @override
  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(_self.feedId.toString())}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EditFeedRoute on GoRouteData {
  static EditFeedRoute _fromState(GoRouterState state) => EditFeedRoute(
        int.parse(state.pathParameters['feedId']!),
      );

  EditFeedRoute get _self => this as EditFeedRoute;

  @override
  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(_self.feedId.toString())}/editFeed',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FeedIngredientsRoute on GoRouteData {
  static FeedIngredientsRoute _fromState(GoRouterState state) =>
      FeedIngredientsRoute(
        int.parse(state.pathParameters['feedId']!),
      );

  FeedIngredientsRoute get _self => this as FeedIngredientsRoute;

  @override
  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(_self.feedId.toString())}/feedIngredient',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

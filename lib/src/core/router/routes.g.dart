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
          path: 'feed/new',
          factory: $AddFeedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'ingredients',
              factory: $AddFeedIngredientsRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'feed/:feedId',
          factory: $EditFeedRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'ingredients',
              factory: $EditFeedIngredientsRoute._fromState,
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
        '/feed/new',
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

mixin $AddFeedIngredientsRoute on GoRouteData {
  static AddFeedIngredientsRoute _fromState(GoRouterState state) =>
      AddFeedIngredientsRoute(
        _$convertMapValue('feed-id', state.uri.queryParameters, int.tryParse),
      );

  AddFeedIngredientsRoute get _self => this as AddFeedIngredientsRoute;

  @override
  String get location => GoRouteData.$location(
        '/feed/new/ingredients',
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

mixin $EditFeedRoute on GoRouteData {
  static EditFeedRoute _fromState(GoRouterState state) => EditFeedRoute(
        feedId: int.parse(state.pathParameters['feedId']!),
      );

  EditFeedRoute get _self => this as EditFeedRoute;

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

mixin $EditFeedIngredientsRoute on GoRouteData {
  static EditFeedIngredientsRoute _fromState(GoRouterState state) =>
      EditFeedIngredientsRoute(
        int.parse(state.pathParameters['feedId']!),
      );

  EditFeedIngredientsRoute get _self => this as EditFeedIngredientsRoute;

  @override
  String get location => GoRouteData.$location(
        '/feed/${Uri.encodeComponent(_self.feedId.toString())}/ingredients',
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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

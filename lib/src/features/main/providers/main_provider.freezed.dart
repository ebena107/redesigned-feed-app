// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MainViewState implements DiagnosticableTreeMixin {
  List<Feed> get feeds;
  int get animalTypes;
  List<FeedIngredients> get feedIngredients;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MainViewStateCopyWith<MainViewState> get copyWith =>
      _$MainViewStateCopyWithImpl<MainViewState>(
          this as MainViewState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'MainViewState'))
      ..add(DiagnosticsProperty('feeds', feeds))
      ..add(DiagnosticsProperty('animalTypes', animalTypes))
      ..add(DiagnosticsProperty('feedIngredients', feedIngredients));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MainViewState &&
            const DeepCollectionEquality().equals(other.feeds, feeds) &&
            (identical(other.animalTypes, animalTypes) ||
                other.animalTypes == animalTypes) &&
            const DeepCollectionEquality()
                .equals(other.feedIngredients, feedIngredients));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(feeds),
      animalTypes,
      const DeepCollectionEquality().hash(feedIngredients));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MainViewState(feeds: $feeds, animalTypes: $animalTypes, feedIngredients: $feedIngredients)';
  }
}

/// @nodoc
abstract mixin class $MainViewStateCopyWith<$Res> {
  factory $MainViewStateCopyWith(
          MainViewState value, $Res Function(MainViewState) _then) =
      _$MainViewStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Feed> feeds,
      int animalTypes,
      List<FeedIngredients> feedIngredients});
}

/// @nodoc
class _$MainViewStateCopyWithImpl<$Res>
    implements $MainViewStateCopyWith<$Res> {
  _$MainViewStateCopyWithImpl(this._self, this._then);

  final MainViewState _self;
  final $Res Function(MainViewState) _then;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feeds = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
  }) {
    return _then(_self.copyWith(
      feeds: null == feeds
          ? _self.feeds
          : feeds // ignore: cast_nullable_to_non_nullable
              as List<Feed>,
      animalTypes: null == animalTypes
          ? _self.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as int,
      feedIngredients: null == feedIngredients
          ? _self.feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MainViewState].
extension MainViewStatePatterns on MainViewState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_MainViewState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MainViewState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_MainViewState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MainViewState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_MainViewState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MainViewState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<Feed> feeds, int animalTypes,
            List<FeedIngredients> feedIngredients)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MainViewState() when $default != null:
        return $default(_that.feeds, _that.animalTypes, _that.feedIngredients);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<Feed> feeds, int animalTypes,
            List<FeedIngredients> feedIngredients)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MainViewState():
        return $default(_that.feeds, _that.animalTypes, _that.feedIngredients);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<Feed> feeds, int animalTypes,
            List<FeedIngredients> feedIngredients)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MainViewState() when $default != null:
        return $default(_that.feeds, _that.animalTypes, _that.feedIngredients);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MainViewState extends MainViewState with DiagnosticableTreeMixin {
  const _MainViewState(
      {final List<Feed> feeds = const [],
      this.animalTypes = 0,
      final List<FeedIngredients> feedIngredients = const []})
      : _feeds = feeds,
        _feedIngredients = feedIngredients,
        super._();

  final List<Feed> _feeds;
  @override
  @JsonKey()
  List<Feed> get feeds {
    if (_feeds is EqualUnmodifiableListView) return _feeds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feeds);
  }

  @override
  @JsonKey()
  final int animalTypes;
  final List<FeedIngredients> _feedIngredients;
  @override
  @JsonKey()
  List<FeedIngredients> get feedIngredients {
    if (_feedIngredients is EqualUnmodifiableListView) return _feedIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedIngredients);
  }

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MainViewStateCopyWith<_MainViewState> get copyWith =>
      __$MainViewStateCopyWithImpl<_MainViewState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'MainViewState'))
      ..add(DiagnosticsProperty('feeds', feeds))
      ..add(DiagnosticsProperty('animalTypes', animalTypes))
      ..add(DiagnosticsProperty('feedIngredients', feedIngredients));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MainViewState &&
            const DeepCollectionEquality().equals(other._feeds, _feeds) &&
            (identical(other.animalTypes, animalTypes) ||
                other.animalTypes == animalTypes) &&
            const DeepCollectionEquality()
                .equals(other._feedIngredients, _feedIngredients));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_feeds),
      animalTypes,
      const DeepCollectionEquality().hash(_feedIngredients));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MainViewState(feeds: $feeds, animalTypes: $animalTypes, feedIngredients: $feedIngredients)';
  }
}

/// @nodoc
abstract mixin class _$MainViewStateCopyWith<$Res>
    implements $MainViewStateCopyWith<$Res> {
  factory _$MainViewStateCopyWith(
          _MainViewState value, $Res Function(_MainViewState) _then) =
      __$MainViewStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Feed> feeds,
      int animalTypes,
      List<FeedIngredients> feedIngredients});
}

/// @nodoc
class __$MainViewStateCopyWithImpl<$Res>
    implements _$MainViewStateCopyWith<$Res> {
  __$MainViewStateCopyWithImpl(this._self, this._then);

  final _MainViewState _self;
  final $Res Function(_MainViewState) _then;

  /// Create a copy of MainViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? feeds = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
  }) {
    return _then(_MainViewState(
      feeds: null == feeds
          ? _self._feeds
          : feeds // ignore: cast_nullable_to_non_nullable
              as List<Feed>,
      animalTypes: null == animalTypes
          ? _self.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as int,
      feedIngredients: null == feedIngredients
          ? _self._feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
    ));
  }
}

// dart format on

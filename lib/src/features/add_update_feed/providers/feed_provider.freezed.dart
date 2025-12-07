// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedState implements DiagnosticableTreeMixin {
  String get feedName;
  num get animalTypeId;
  List<AnimalTypes> get animalTypes;
  List<FeedIngredients> get feedIngredients;
  num get totalQuantity;
  Feed? get newFeed;
  String get message;
  String get status;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedStateCopyWith<FeedState> get copyWith =>
      _$FeedStateCopyWithImpl<FeedState>(this as FeedState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'FeedState'))
      ..add(DiagnosticsProperty('feedName', feedName))
      ..add(DiagnosticsProperty('animalTypeId', animalTypeId))
      ..add(DiagnosticsProperty('animalTypes', animalTypes))
      ..add(DiagnosticsProperty('feedIngredients', feedIngredients))
      ..add(DiagnosticsProperty('totalQuantity', totalQuantity))
      ..add(DiagnosticsProperty('newFeed', newFeed))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedState &&
            (identical(other.feedName, feedName) ||
                other.feedName == feedName) &&
            (identical(other.animalTypeId, animalTypeId) ||
                other.animalTypeId == animalTypeId) &&
            const DeepCollectionEquality()
                .equals(other.animalTypes, animalTypes) &&
            const DeepCollectionEquality()
                .equals(other.feedIngredients, feedIngredients) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.newFeed, newFeed) || other.newFeed == newFeed) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      feedName,
      animalTypeId,
      const DeepCollectionEquality().hash(animalTypes),
      const DeepCollectionEquality().hash(feedIngredients),
      totalQuantity,
      newFeed,
      message,
      status);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeedState(feedName: $feedName, animalTypeId: $animalTypeId, animalTypes: $animalTypes, feedIngredients: $feedIngredients, totalQuantity: $totalQuantity, newFeed: $newFeed, message: $message, status: $status)';
  }
}

/// @nodoc
abstract mixin class $FeedStateCopyWith<$Res> {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) _then) =
      _$FeedStateCopyWithImpl;
  @useResult
  $Res call(
      {String feedName,
      num animalTypeId,
      List<AnimalTypes> animalTypes,
      List<FeedIngredients> feedIngredients,
      num totalQuantity,
      Feed? newFeed,
      String message,
      String status});
}

/// @nodoc
class _$FeedStateCopyWithImpl<$Res> implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._self, this._then);

  final FeedState _self;
  final $Res Function(FeedState) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedName = null,
    Object? animalTypeId = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
    Object? totalQuantity = null,
    Object? newFeed = freezed,
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      feedName: null == feedName
          ? _self.feedName
          : feedName // ignore: cast_nullable_to_non_nullable
              as String,
      animalTypeId: null == animalTypeId
          ? _self.animalTypeId
          : animalTypeId // ignore: cast_nullable_to_non_nullable
              as num,
      animalTypes: null == animalTypes
          ? _self.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as List<AnimalTypes>,
      feedIngredients: null == feedIngredients
          ? _self.feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as num,
      newFeed: freezed == newFeed
          ? _self.newFeed
          : newFeed // ignore: cast_nullable_to_non_nullable
              as Feed?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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
    TResult Function(_FeedState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedState() when $default != null:
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
    TResult Function(_FeedState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedState():
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
    TResult? Function(_FeedState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedState() when $default != null:
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
    TResult Function(
            String feedName,
            num animalTypeId,
            List<AnimalTypes> animalTypes,
            List<FeedIngredients> feedIngredients,
            num totalQuantity,
            Feed? newFeed,
            String message,
            String status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedState() when $default != null:
        return $default(
            _that.feedName,
            _that.animalTypeId,
            _that.animalTypes,
            _that.feedIngredients,
            _that.totalQuantity,
            _that.newFeed,
            _that.message,
            _that.status);
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
    TResult Function(
            String feedName,
            num animalTypeId,
            List<AnimalTypes> animalTypes,
            List<FeedIngredients> feedIngredients,
            num totalQuantity,
            Feed? newFeed,
            String message,
            String status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedState():
        return $default(
            _that.feedName,
            _that.animalTypeId,
            _that.animalTypes,
            _that.feedIngredients,
            _that.totalQuantity,
            _that.newFeed,
            _that.message,
            _that.status);
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
    TResult? Function(
            String feedName,
            num animalTypeId,
            List<AnimalTypes> animalTypes,
            List<FeedIngredients> feedIngredients,
            num totalQuantity,
            Feed? newFeed,
            String message,
            String status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedState() when $default != null:
        return $default(
            _that.feedName,
            _that.animalTypeId,
            _that.animalTypes,
            _that.feedIngredients,
            _that.totalQuantity,
            _that.newFeed,
            _that.message,
            _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedState extends FeedState with DiagnosticableTreeMixin {
  _FeedState(
      {this.feedName = "",
      this.animalTypeId = 1,
      final List<AnimalTypes> animalTypes = const [],
      final List<FeedIngredients> feedIngredients = const [],
      this.totalQuantity = 0.0,
      this.newFeed,
      this.message = "",
      this.status = ""})
      : _animalTypes = animalTypes,
        _feedIngredients = feedIngredients,
        super._();

  @override
  @JsonKey()
  final String feedName;
  @override
  @JsonKey()
  final num animalTypeId;
  final List<AnimalTypes> _animalTypes;
  @override
  @JsonKey()
  List<AnimalTypes> get animalTypes {
    if (_animalTypes is EqualUnmodifiableListView) return _animalTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_animalTypes);
  }

  final List<FeedIngredients> _feedIngredients;
  @override
  @JsonKey()
  List<FeedIngredients> get feedIngredients {
    if (_feedIngredients is EqualUnmodifiableListView) return _feedIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedIngredients);
  }

  @override
  @JsonKey()
  final num totalQuantity;
  @override
  final Feed? newFeed;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String status;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedStateCopyWith<_FeedState> get copyWith =>
      __$FeedStateCopyWithImpl<_FeedState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'FeedState'))
      ..add(DiagnosticsProperty('feedName', feedName))
      ..add(DiagnosticsProperty('animalTypeId', animalTypeId))
      ..add(DiagnosticsProperty('animalTypes', animalTypes))
      ..add(DiagnosticsProperty('feedIngredients', feedIngredients))
      ..add(DiagnosticsProperty('totalQuantity', totalQuantity))
      ..add(DiagnosticsProperty('newFeed', newFeed))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('status', status));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedState &&
            (identical(other.feedName, feedName) ||
                other.feedName == feedName) &&
            (identical(other.animalTypeId, animalTypeId) ||
                other.animalTypeId == animalTypeId) &&
            const DeepCollectionEquality()
                .equals(other._animalTypes, _animalTypes) &&
            const DeepCollectionEquality()
                .equals(other._feedIngredients, _feedIngredients) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.newFeed, newFeed) || other.newFeed == newFeed) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      feedName,
      animalTypeId,
      const DeepCollectionEquality().hash(_animalTypes),
      const DeepCollectionEquality().hash(_feedIngredients),
      totalQuantity,
      newFeed,
      message,
      status);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeedState(feedName: $feedName, animalTypeId: $animalTypeId, animalTypes: $animalTypes, feedIngredients: $feedIngredients, totalQuantity: $totalQuantity, newFeed: $newFeed, message: $message, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$FeedStateCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory _$FeedStateCopyWith(
          _FeedState value, $Res Function(_FeedState) _then) =
      __$FeedStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String feedName,
      num animalTypeId,
      List<AnimalTypes> animalTypes,
      List<FeedIngredients> feedIngredients,
      num totalQuantity,
      Feed? newFeed,
      String message,
      String status});
}

/// @nodoc
class __$FeedStateCopyWithImpl<$Res> implements _$FeedStateCopyWith<$Res> {
  __$FeedStateCopyWithImpl(this._self, this._then);

  final _FeedState _self;
  final $Res Function(_FeedState) _then;

  /// Create a copy of FeedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? feedName = null,
    Object? animalTypeId = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
    Object? totalQuantity = null,
    Object? newFeed = freezed,
    Object? message = null,
    Object? status = null,
  }) {
    return _then(_FeedState(
      feedName: null == feedName
          ? _self.feedName
          : feedName // ignore: cast_nullable_to_non_nullable
              as String,
      animalTypeId: null == animalTypeId
          ? _self.animalTypeId
          : animalTypeId // ignore: cast_nullable_to_non_nullable
              as num,
      animalTypes: null == animalTypes
          ? _self._animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as List<AnimalTypes>,
      feedIngredients: null == feedIngredients
          ? _self._feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as num,
      newFeed: freezed == newFeed
          ? _self.newFeed
          : newFeed // ignore: cast_nullable_to_non_nullable
              as Feed?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

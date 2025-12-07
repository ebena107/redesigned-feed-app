// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResultsState implements DiagnosticableTreeMixin {
  List<Result> get results;
  Result? get myResult;
  bool get toggle;

  /// Create a copy of ResultsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResultsStateCopyWith<ResultsState> get copyWith =>
      _$ResultsStateCopyWithImpl<ResultsState>(
          this as ResultsState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ResultsState'))
      ..add(DiagnosticsProperty('results', results))
      ..add(DiagnosticsProperty('myResult', myResult))
      ..add(DiagnosticsProperty('toggle', toggle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResultsState &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.myResult, myResult) ||
                other.myResult == myResult) &&
            (identical(other.toggle, toggle) || other.toggle == toggle));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(results), myResult, toggle);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResultsState(results: $results, myResult: $myResult, toggle: $toggle)';
  }
}

/// @nodoc
abstract mixin class $ResultsStateCopyWith<$Res> {
  factory $ResultsStateCopyWith(
          ResultsState value, $Res Function(ResultsState) _then) =
      _$ResultsStateCopyWithImpl;
  @useResult
  $Res call({List<Result> results, Result? myResult, bool toggle});
}

/// @nodoc
class _$ResultsStateCopyWithImpl<$Res> implements $ResultsStateCopyWith<$Res> {
  _$ResultsStateCopyWithImpl(this._self, this._then);

  final ResultsState _self;
  final $Res Function(ResultsState) _then;

  /// Create a copy of ResultsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? myResult = freezed,
    Object? toggle = null,
  }) {
    return _then(_self.copyWith(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Result>,
      myResult: freezed == myResult
          ? _self.myResult
          : myResult // ignore: cast_nullable_to_non_nullable
              as Result?,
      toggle: null == toggle
          ? _self.toggle
          : toggle // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ResultsState].
extension ResultsStatePatterns on ResultsState {
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
    TResult Function(_ResultsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResultsState() when $default != null:
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
    TResult Function(_ResultsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResultsState():
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
    TResult? Function(_ResultsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResultsState() when $default != null:
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
    TResult Function(List<Result> results, Result? myResult, bool toggle)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ResultsState() when $default != null:
        return $default(_that.results, _that.myResult, _that.toggle);
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
    TResult Function(List<Result> results, Result? myResult, bool toggle)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResultsState():
        return $default(_that.results, _that.myResult, _that.toggle);
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
    TResult? Function(List<Result> results, Result? myResult, bool toggle)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ResultsState() when $default != null:
        return $default(_that.results, _that.myResult, _that.toggle);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ResultsState extends ResultsState with DiagnosticableTreeMixin {
  _ResultsState(
      {final List<Result> results = const [],
      this.myResult,
      this.toggle = false})
      : _results = results,
        super._();

  final List<Result> _results;
  @override
  @JsonKey()
  List<Result> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final Result? myResult;
  @override
  @JsonKey()
  final bool toggle;

  /// Create a copy of ResultsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ResultsStateCopyWith<_ResultsState> get copyWith =>
      __$ResultsStateCopyWithImpl<_ResultsState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ResultsState'))
      ..add(DiagnosticsProperty('results', results))
      ..add(DiagnosticsProperty('myResult', myResult))
      ..add(DiagnosticsProperty('toggle', toggle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ResultsState &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.myResult, myResult) ||
                other.myResult == myResult) &&
            (identical(other.toggle, toggle) || other.toggle == toggle));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_results), myResult, toggle);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResultsState(results: $results, myResult: $myResult, toggle: $toggle)';
  }
}

/// @nodoc
abstract mixin class _$ResultsStateCopyWith<$Res>
    implements $ResultsStateCopyWith<$Res> {
  factory _$ResultsStateCopyWith(
          _ResultsState value, $Res Function(_ResultsState) _then) =
      __$ResultsStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<Result> results, Result? myResult, bool toggle});
}

/// @nodoc
class __$ResultsStateCopyWithImpl<$Res>
    implements _$ResultsStateCopyWith<$Res> {
  __$ResultsStateCopyWithImpl(this._self, this._then);

  final _ResultsState _self;
  final $Res Function(_ResultsState) _then;

  /// Create a copy of ResultsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? results = null,
    Object? myResult = freezed,
    Object? toggle = null,
  }) {
    return _then(_ResultsState(
      results: null == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Result>,
      myResult: freezed == myResult
          ? _self.myResult
          : myResult // ignore: cast_nullable_to_non_nullable
              as Result?,
      toggle: null == toggle
          ? _self.toggle
          : toggle // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on

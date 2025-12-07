// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNavigationState {
  int get navIndex;

  /// Create a copy of AppNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppNavigationStateCopyWith<AppNavigationState> get copyWith =>
      _$AppNavigationStateCopyWithImpl<AppNavigationState>(
          this as AppNavigationState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppNavigationState &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @override
  String toString() {
    return 'AppNavigationState(navIndex: $navIndex)';
  }
}

/// @nodoc
abstract mixin class $AppNavigationStateCopyWith<$Res> {
  factory $AppNavigationStateCopyWith(
          AppNavigationState value, $Res Function(AppNavigationState) _then) =
      _$AppNavigationStateCopyWithImpl;
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class _$AppNavigationStateCopyWithImpl<$Res>
    implements $AppNavigationStateCopyWith<$Res> {
  _$AppNavigationStateCopyWithImpl(this._self, this._then);

  final AppNavigationState _self;
  final $Res Function(AppNavigationState) _then;

  /// Create a copy of AppNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_self.copyWith(
      navIndex: null == navIndex
          ? _self.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AppNavigationState].
extension AppNavigationStatePatterns on AppNavigationState {
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
    TResult Function(_AppNavigationState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState() when $default != null:
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
    TResult Function(_AppNavigationState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState():
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
    TResult? Function(_AppNavigationState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState() when $default != null:
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
    TResult Function(int navIndex)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState() when $default != null:
        return $default(_that.navIndex);
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
    TResult Function(int navIndex) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState():
        return $default(_that.navIndex);
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
    TResult? Function(int navIndex)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppNavigationState() when $default != null:
        return $default(_that.navIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AppNavigationState extends AppNavigationState {
  const _AppNavigationState({this.navIndex = 1}) : super._();

  @override
  @JsonKey()
  final int navIndex;

  /// Create a copy of AppNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppNavigationStateCopyWith<_AppNavigationState> get copyWith =>
      __$AppNavigationStateCopyWithImpl<_AppNavigationState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppNavigationState &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @override
  String toString() {
    return 'AppNavigationState(navIndex: $navIndex)';
  }
}

/// @nodoc
abstract mixin class _$AppNavigationStateCopyWith<$Res>
    implements $AppNavigationStateCopyWith<$Res> {
  factory _$AppNavigationStateCopyWith(
          _AppNavigationState value, $Res Function(_AppNavigationState) _then) =
      __$AppNavigationStateCopyWithImpl;
  @override
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class __$AppNavigationStateCopyWithImpl<$Res>
    implements _$AppNavigationStateCopyWith<$Res> {
  __$AppNavigationStateCopyWithImpl(this._self, this._then);

  final _AppNavigationState _self;
  final $Res Function(_AppNavigationState) _then;

  /// Create a copy of AppNavigationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_AppNavigationState(
      navIndex: null == navIndex
          ? _self.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'navigation_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppNavigationState {
  int get navIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppNavigationStateCopyWith<AppNavigationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNavigationStateCopyWith<$Res> {
  factory $AppNavigationStateCopyWith(
          AppNavigationState value, $Res Function(AppNavigationState) then) =
      _$AppNavigationStateCopyWithImpl<$Res, AppNavigationState>;
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class _$AppNavigationStateCopyWithImpl<$Res, $Val extends AppNavigationState>
    implements $AppNavigationStateCopyWith<$Res> {
  _$AppNavigationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_value.copyWith(
      navIndex: null == navIndex
          ? _value.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppNavigationStateCopyWith<$Res>
    implements $AppNavigationStateCopyWith<$Res> {
  factory _$$_AppNavigationStateCopyWith(_$_AppNavigationState value,
          $Res Function(_$_AppNavigationState) then) =
      __$$_AppNavigationStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class __$$_AppNavigationStateCopyWithImpl<$Res>
    extends _$AppNavigationStateCopyWithImpl<$Res, _$_AppNavigationState>
    implements _$$_AppNavigationStateCopyWith<$Res> {
  __$$_AppNavigationStateCopyWithImpl(
      _$_AppNavigationState _value, $Res Function(_$_AppNavigationState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_$_AppNavigationState(
      navIndex: null == navIndex
          ? _value.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AppNavigationState extends _AppNavigationState {
  const _$_AppNavigationState({this.navIndex = 1}) : super._();

  @override
  @JsonKey()
  final int navIndex;

  @override
  String toString() {
    return 'AppNavigationState(navIndex: $navIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppNavigationState &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppNavigationStateCopyWith<_$_AppNavigationState> get copyWith =>
      __$$_AppNavigationStateCopyWithImpl<_$_AppNavigationState>(
          this, _$identity);
}

abstract class _AppNavigationState extends AppNavigationState {
  const factory _AppNavigationState({final int navIndex}) =
      _$_AppNavigationState;
  const _AppNavigationState._() : super._();

  @override
  int get navIndex;
  @override
  @JsonKey(ignore: true)
  _$$_AppNavigationStateCopyWith<_$_AppNavigationState> get copyWith =>
      throw _privateConstructorUsedError;
}

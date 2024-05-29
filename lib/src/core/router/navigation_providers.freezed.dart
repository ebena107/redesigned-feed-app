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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$AppNavigationStateImplCopyWith<$Res>
    implements $AppNavigationStateCopyWith<$Res> {
  factory _$$AppNavigationStateImplCopyWith(_$AppNavigationStateImpl value,
          $Res Function(_$AppNavigationStateImpl) then) =
      __$$AppNavigationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int navIndex});
}

/// @nodoc
class __$$AppNavigationStateImplCopyWithImpl<$Res>
    extends _$AppNavigationStateCopyWithImpl<$Res, _$AppNavigationStateImpl>
    implements _$$AppNavigationStateImplCopyWith<$Res> {
  __$$AppNavigationStateImplCopyWithImpl(_$AppNavigationStateImpl _value,
      $Res Function(_$AppNavigationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navIndex = null,
  }) {
    return _then(_$AppNavigationStateImpl(
      navIndex: null == navIndex
          ? _value.navIndex
          : navIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AppNavigationStateImpl extends _AppNavigationState {
  const _$AppNavigationStateImpl({this.navIndex = 1}) : super._();

  @override
  @JsonKey()
  final int navIndex;

  @override
  String toString() {
    return 'AppNavigationState(navIndex: $navIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNavigationStateImpl &&
            (identical(other.navIndex, navIndex) ||
                other.navIndex == navIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNavigationStateImplCopyWith<_$AppNavigationStateImpl> get copyWith =>
      __$$AppNavigationStateImplCopyWithImpl<_$AppNavigationStateImpl>(
          this, _$identity);
}

abstract class _AppNavigationState extends AppNavigationState {
  const factory _AppNavigationState({final int navIndex}) =
      _$AppNavigationStateImpl;
  const _AppNavigationState._() : super._();

  @override
  int get navIndex;
  @override
  @JsonKey(ignore: true)
  _$$AppNavigationStateImplCopyWith<_$AppNavigationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

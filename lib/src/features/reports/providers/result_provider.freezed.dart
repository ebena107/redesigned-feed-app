// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResultsState {
  List<Result> get results => throw _privateConstructorUsedError;
  Result? get myResult => throw _privateConstructorUsedError;
  bool get toggle => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResultsStateCopyWith<ResultsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultsStateCopyWith<$Res> {
  factory $ResultsStateCopyWith(
          ResultsState value, $Res Function(ResultsState) then) =
      _$ResultsStateCopyWithImpl<$Res, ResultsState>;
  @useResult
  $Res call({List<Result> results, Result? myResult, bool toggle});
}

/// @nodoc
class _$ResultsStateCopyWithImpl<$Res, $Val extends ResultsState>
    implements $ResultsStateCopyWith<$Res> {
  _$ResultsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? myResult = freezed,
    Object? toggle = null,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Result>,
      myResult: freezed == myResult
          ? _value.myResult
          : myResult // ignore: cast_nullable_to_non_nullable
              as Result?,
      toggle: null == toggle
          ? _value.toggle
          : toggle // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResultsStateImplCopyWith<$Res>
    implements $ResultsStateCopyWith<$Res> {
  factory _$$ResultsStateImplCopyWith(
          _$ResultsStateImpl value, $Res Function(_$ResultsStateImpl) then) =
      __$$ResultsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Result> results, Result? myResult, bool toggle});
}

/// @nodoc
class __$$ResultsStateImplCopyWithImpl<$Res>
    extends _$ResultsStateCopyWithImpl<$Res, _$ResultsStateImpl>
    implements _$$ResultsStateImplCopyWith<$Res> {
  __$$ResultsStateImplCopyWithImpl(
      _$ResultsStateImpl _value, $Res Function(_$ResultsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? myResult = freezed,
    Object? toggle = null,
  }) {
    return _then(_$ResultsStateImpl(
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Result>,
      myResult: freezed == myResult
          ? _value.myResult
          : myResult // ignore: cast_nullable_to_non_nullable
              as Result?,
      toggle: null == toggle
          ? _value.toggle
          : toggle // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ResultsStateImpl extends _ResultsState with DiagnosticableTreeMixin {
  _$ResultsStateImpl(
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResultsState(results: $results, myResult: $myResult, toggle: $toggle)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$ResultsStateImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.myResult, myResult) ||
                other.myResult == myResult) &&
            (identical(other.toggle, toggle) || other.toggle == toggle));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_results), myResult, toggle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultsStateImplCopyWith<_$ResultsStateImpl> get copyWith =>
      __$$ResultsStateImplCopyWithImpl<_$ResultsStateImpl>(this, _$identity);
}

abstract class _ResultsState extends ResultsState {
  factory _ResultsState(
      {final List<Result> results,
      final Result? myResult,
      final bool toggle}) = _$ResultsStateImpl;
  _ResultsState._() : super._();

  @override
  List<Result> get results;
  @override
  Result? get myResult;
  @override
  bool get toggle;
  @override
  @JsonKey(ignore: true)
  _$$ResultsStateImplCopyWith<_$ResultsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

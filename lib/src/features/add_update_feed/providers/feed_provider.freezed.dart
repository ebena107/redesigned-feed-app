// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedState {
  String get feedName => throw _privateConstructorUsedError;
  num get animalTypeId => throw _privateConstructorUsedError;
  List<AnimalTypes> get animalTypes => throw _privateConstructorUsedError;
  List<FeedIngredients> get feedIngredients =>
      throw _privateConstructorUsedError;
  num get totalQuantity => throw _privateConstructorUsedError;
  Feed? get newFeed => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FeedStateCopyWith<FeedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedStateCopyWith<$Res> {
  factory $FeedStateCopyWith(FeedState value, $Res Function(FeedState) then) =
      _$FeedStateCopyWithImpl<$Res, FeedState>;
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
class _$FeedStateCopyWithImpl<$Res, $Val extends FeedState>
    implements $FeedStateCopyWith<$Res> {
  _$FeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      feedName: null == feedName
          ? _value.feedName
          : feedName // ignore: cast_nullable_to_non_nullable
              as String,
      animalTypeId: null == animalTypeId
          ? _value.animalTypeId
          : animalTypeId // ignore: cast_nullable_to_non_nullable
              as num,
      animalTypes: null == animalTypes
          ? _value.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as List<AnimalTypes>,
      feedIngredients: null == feedIngredients
          ? _value.feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as num,
      newFeed: freezed == newFeed
          ? _value.newFeed
          : newFeed // ignore: cast_nullable_to_non_nullable
              as Feed?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedStateImplCopyWith<$Res>
    implements $FeedStateCopyWith<$Res> {
  factory _$$FeedStateImplCopyWith(
          _$FeedStateImpl value, $Res Function(_$FeedStateImpl) then) =
      __$$FeedStateImplCopyWithImpl<$Res>;
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
class __$$FeedStateImplCopyWithImpl<$Res>
    extends _$FeedStateCopyWithImpl<$Res, _$FeedStateImpl>
    implements _$$FeedStateImplCopyWith<$Res> {
  __$$FeedStateImplCopyWithImpl(
      _$FeedStateImpl _value, $Res Function(_$FeedStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$FeedStateImpl(
      feedName: null == feedName
          ? _value.feedName
          : feedName // ignore: cast_nullable_to_non_nullable
              as String,
      animalTypeId: null == animalTypeId
          ? _value.animalTypeId
          : animalTypeId // ignore: cast_nullable_to_non_nullable
              as num,
      animalTypes: null == animalTypes
          ? _value._animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as List<AnimalTypes>,
      feedIngredients: null == feedIngredients
          ? _value._feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      totalQuantity: null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as num,
      newFeed: freezed == newFeed
          ? _value.newFeed
          : newFeed // ignore: cast_nullable_to_non_nullable
              as Feed?,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FeedStateImpl extends _FeedState with DiagnosticableTreeMixin {
  _$FeedStateImpl(
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeedState(feedName: $feedName, animalTypeId: $animalTypeId, animalTypes: $animalTypes, feedIngredients: $feedIngredients, totalQuantity: $totalQuantity, newFeed: $newFeed, message: $message, status: $status)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$FeedStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      __$$FeedStateImplCopyWithImpl<_$FeedStateImpl>(this, _$identity);
}

abstract class _FeedState extends FeedState {
  factory _FeedState(
      {final String feedName,
      final num animalTypeId,
      final List<AnimalTypes> animalTypes,
      final List<FeedIngredients> feedIngredients,
      final num totalQuantity,
      final Feed? newFeed,
      final String message,
      final String status}) = _$FeedStateImpl;
  _FeedState._() : super._();

  @override
  String get feedName;
  @override
  num get animalTypeId;
  @override
  List<AnimalTypes> get animalTypes;
  @override
  List<FeedIngredients> get feedIngredients;
  @override
  num get totalQuantity;
  @override
  Feed? get newFeed;
  @override
  String get message;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$FeedStateImplCopyWith<_$FeedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

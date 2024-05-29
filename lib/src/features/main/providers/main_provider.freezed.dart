// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainViewState {
  List<Feed> get feeds => throw _privateConstructorUsedError;
  int get animalTypes => throw _privateConstructorUsedError;
  List<FeedIngredients> get feedIngredients =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainViewStateCopyWith<MainViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainViewStateCopyWith<$Res> {
  factory $MainViewStateCopyWith(
          MainViewState value, $Res Function(MainViewState) then) =
      _$MainViewStateCopyWithImpl<$Res, MainViewState>;
  @useResult
  $Res call(
      {List<Feed> feeds,
      int animalTypes,
      List<FeedIngredients> feedIngredients});
}

/// @nodoc
class _$MainViewStateCopyWithImpl<$Res, $Val extends MainViewState>
    implements $MainViewStateCopyWith<$Res> {
  _$MainViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feeds = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
  }) {
    return _then(_value.copyWith(
      feeds: null == feeds
          ? _value.feeds
          : feeds // ignore: cast_nullable_to_non_nullable
              as List<Feed>,
      animalTypes: null == animalTypes
          ? _value.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as int,
      feedIngredients: null == feedIngredients
          ? _value.feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MainViewStateImplCopyWith<$Res>
    implements $MainViewStateCopyWith<$Res> {
  factory _$$MainViewStateImplCopyWith(
          _$MainViewStateImpl value, $Res Function(_$MainViewStateImpl) then) =
      __$$MainViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Feed> feeds,
      int animalTypes,
      List<FeedIngredients> feedIngredients});
}

/// @nodoc
class __$$MainViewStateImplCopyWithImpl<$Res>
    extends _$MainViewStateCopyWithImpl<$Res, _$MainViewStateImpl>
    implements _$$MainViewStateImplCopyWith<$Res> {
  __$$MainViewStateImplCopyWithImpl(
      _$MainViewStateImpl _value, $Res Function(_$MainViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feeds = null,
    Object? animalTypes = null,
    Object? feedIngredients = null,
  }) {
    return _then(_$MainViewStateImpl(
      feeds: null == feeds
          ? _value._feeds
          : feeds // ignore: cast_nullable_to_non_nullable
              as List<Feed>,
      animalTypes: null == animalTypes
          ? _value.animalTypes
          : animalTypes // ignore: cast_nullable_to_non_nullable
              as int,
      feedIngredients: null == feedIngredients
          ? _value._feedIngredients
          : feedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
    ));
  }
}

/// @nodoc

class _$MainViewStateImpl extends _MainViewState with DiagnosticableTreeMixin {
  const _$MainViewStateImpl(
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MainViewState(feeds: $feeds, animalTypes: $animalTypes, feedIngredients: $feedIngredients)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
            other is _$MainViewStateImpl &&
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MainViewStateImplCopyWith<_$MainViewStateImpl> get copyWith =>
      __$$MainViewStateImplCopyWithImpl<_$MainViewStateImpl>(this, _$identity);
}

abstract class _MainViewState extends MainViewState {
  const factory _MainViewState(
      {final List<Feed> feeds,
      final int animalTypes,
      final List<FeedIngredients> feedIngredients}) = _$MainViewStateImpl;
  const _MainViewState._() : super._();

  @override
  List<Feed> get feeds;
  @override
  int get animalTypes;
  @override
  List<FeedIngredients> get feedIngredients;
  @override
  @JsonKey(ignore: true)
  _$$MainViewStateImplCopyWith<_$MainViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

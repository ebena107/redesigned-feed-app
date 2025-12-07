// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_ingredient_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreIngredientState implements DiagnosticableTreeMixin {
  List<Ingredient> get ingredients;
  Ingredient? get selectedIngredient;
  bool get validate;
  num get id;
  num get priceKg;
  num get availableQty;
  num get favourite;
  String get status;
  String get message;

  /// Create a copy of StoreIngredientState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoreIngredientStateCopyWith<StoreIngredientState> get copyWith =>
      _$StoreIngredientStateCopyWithImpl<StoreIngredientState>(
          this as StoreIngredientState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'StoreIngredientState'))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('selectedIngredient', selectedIngredient))
      ..add(DiagnosticsProperty('validate', validate))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('priceKg', priceKg))
      ..add(DiagnosticsProperty('availableQty', availableQty))
      ..add(DiagnosticsProperty('favourite', favourite))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoreIngredientState &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients) &&
            (identical(other.selectedIngredient, selectedIngredient) ||
                other.selectedIngredient == selectedIngredient) &&
            (identical(other.validate, validate) ||
                other.validate == validate) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priceKg, priceKg) || other.priceKg == priceKg) &&
            (identical(other.availableQty, availableQty) ||
                other.availableQty == availableQty) &&
            (identical(other.favourite, favourite) ||
                other.favourite == favourite) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(ingredients),
      selectedIngredient,
      validate,
      id,
      priceKg,
      availableQty,
      favourite,
      status,
      message);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StoreIngredientState(ingredients: $ingredients, selectedIngredient: $selectedIngredient, validate: $validate, id: $id, priceKg: $priceKg, availableQty: $availableQty, favourite: $favourite, status: $status, message: $message)';
  }
}

/// @nodoc
abstract mixin class $StoreIngredientStateCopyWith<$Res> {
  factory $StoreIngredientStateCopyWith(StoreIngredientState value,
          $Res Function(StoreIngredientState) _then) =
      _$StoreIngredientStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Ingredient> ingredients,
      Ingredient? selectedIngredient,
      bool validate,
      num id,
      num priceKg,
      num availableQty,
      num favourite,
      String status,
      String message});
}

/// @nodoc
class _$StoreIngredientStateCopyWithImpl<$Res>
    implements $StoreIngredientStateCopyWith<$Res> {
  _$StoreIngredientStateCopyWithImpl(this._self, this._then);

  final StoreIngredientState _self;
  final $Res Function(StoreIngredientState) _then;

  /// Create a copy of StoreIngredientState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredients = null,
    Object? selectedIngredient = freezed,
    Object? validate = null,
    Object? id = null,
    Object? priceKg = null,
    Object? availableQty = null,
    Object? favourite = null,
    Object? status = null,
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      ingredients: null == ingredients
          ? _self.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      selectedIngredient: freezed == selectedIngredient
          ? _self.selectedIngredient
          : selectedIngredient // ignore: cast_nullable_to_non_nullable
              as Ingredient?,
      validate: null == validate
          ? _self.validate
          : validate // ignore: cast_nullable_to_non_nullable
              as bool,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      priceKg: null == priceKg
          ? _self.priceKg
          : priceKg // ignore: cast_nullable_to_non_nullable
              as num,
      availableQty: null == availableQty
          ? _self.availableQty
          : availableQty // ignore: cast_nullable_to_non_nullable
              as num,
      favourite: null == favourite
          ? _self.favourite
          : favourite // ignore: cast_nullable_to_non_nullable
              as num,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [StoreIngredientState].
extension StoreIngredientStatePatterns on StoreIngredientState {
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
    TResult Function(_StoreIngredientState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState() when $default != null:
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
    TResult Function(_StoreIngredientState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState():
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
    TResult? Function(_StoreIngredientState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState() when $default != null:
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
            List<Ingredient> ingredients,
            Ingredient? selectedIngredient,
            bool validate,
            num id,
            num priceKg,
            num availableQty,
            num favourite,
            String status,
            String message)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState() when $default != null:
        return $default(
            _that.ingredients,
            _that.selectedIngredient,
            _that.validate,
            _that.id,
            _that.priceKg,
            _that.availableQty,
            _that.favourite,
            _that.status,
            _that.message);
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
            List<Ingredient> ingredients,
            Ingredient? selectedIngredient,
            bool validate,
            num id,
            num priceKg,
            num availableQty,
            num favourite,
            String status,
            String message)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState():
        return $default(
            _that.ingredients,
            _that.selectedIngredient,
            _that.validate,
            _that.id,
            _that.priceKg,
            _that.availableQty,
            _that.favourite,
            _that.status,
            _that.message);
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
            List<Ingredient> ingredients,
            Ingredient? selectedIngredient,
            bool validate,
            num id,
            num priceKg,
            num availableQty,
            num favourite,
            String status,
            String message)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StoreIngredientState() when $default != null:
        return $default(
            _that.ingredients,
            _that.selectedIngredient,
            _that.validate,
            _that.id,
            _that.priceKg,
            _that.availableQty,
            _that.favourite,
            _that.status,
            _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StoreIngredientState extends StoreIngredientState
    with DiagnosticableTreeMixin {
  const _StoreIngredientState(
      {final List<Ingredient> ingredients = const [],
      this.selectedIngredient,
      this.validate = false,
      this.id = 0,
      this.priceKg = 0,
      this.availableQty = 0,
      this.favourite = 0,
      this.status = "",
      this.message = ""})
      : _ingredients = ingredients,
        super._();

  final List<Ingredient> _ingredients;
  @override
  @JsonKey()
  List<Ingredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  final Ingredient? selectedIngredient;
  @override
  @JsonKey()
  final bool validate;
  @override
  @JsonKey()
  final num id;
  @override
  @JsonKey()
  final num priceKg;
  @override
  @JsonKey()
  final num availableQty;
  @override
  @JsonKey()
  final num favourite;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String message;

  /// Create a copy of StoreIngredientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoreIngredientStateCopyWith<_StoreIngredientState> get copyWith =>
      __$StoreIngredientStateCopyWithImpl<_StoreIngredientState>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'StoreIngredientState'))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('selectedIngredient', selectedIngredient))
      ..add(DiagnosticsProperty('validate', validate))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('priceKg', priceKg))
      ..add(DiagnosticsProperty('availableQty', availableQty))
      ..add(DiagnosticsProperty('favourite', favourite))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StoreIngredientState &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.selectedIngredient, selectedIngredient) ||
                other.selectedIngredient == selectedIngredient) &&
            (identical(other.validate, validate) ||
                other.validate == validate) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.priceKg, priceKg) || other.priceKg == priceKg) &&
            (identical(other.availableQty, availableQty) ||
                other.availableQty == availableQty) &&
            (identical(other.favourite, favourite) ||
                other.favourite == favourite) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_ingredients),
      selectedIngredient,
      validate,
      id,
      priceKg,
      availableQty,
      favourite,
      status,
      message);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StoreIngredientState(ingredients: $ingredients, selectedIngredient: $selectedIngredient, validate: $validate, id: $id, priceKg: $priceKg, availableQty: $availableQty, favourite: $favourite, status: $status, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$StoreIngredientStateCopyWith<$Res>
    implements $StoreIngredientStateCopyWith<$Res> {
  factory _$StoreIngredientStateCopyWith(_StoreIngredientState value,
          $Res Function(_StoreIngredientState) _then) =
      __$StoreIngredientStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Ingredient> ingredients,
      Ingredient? selectedIngredient,
      bool validate,
      num id,
      num priceKg,
      num availableQty,
      num favourite,
      String status,
      String message});
}

/// @nodoc
class __$StoreIngredientStateCopyWithImpl<$Res>
    implements _$StoreIngredientStateCopyWith<$Res> {
  __$StoreIngredientStateCopyWithImpl(this._self, this._then);

  final _StoreIngredientState _self;
  final $Res Function(_StoreIngredientState) _then;

  /// Create a copy of StoreIngredientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ingredients = null,
    Object? selectedIngredient = freezed,
    Object? validate = null,
    Object? id = null,
    Object? priceKg = null,
    Object? availableQty = null,
    Object? favourite = null,
    Object? status = null,
    Object? message = null,
  }) {
    return _then(_StoreIngredientState(
      ingredients: null == ingredients
          ? _self._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      selectedIngredient: freezed == selectedIngredient
          ? _self.selectedIngredient
          : selectedIngredient // ignore: cast_nullable_to_non_nullable
              as Ingredient?,
      validate: null == validate
          ? _self.validate
          : validate // ignore: cast_nullable_to_non_nullable
              as bool,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as num,
      priceKg: null == priceKg
          ? _self.priceKg
          : priceKg // ignore: cast_nullable_to_non_nullable
              as num,
      availableQty: null == availableQty
          ? _self.availableQty
          : availableQty // ignore: cast_nullable_to_non_nullable
              as num,
      favourite: null == favourite
          ? _self.favourite
          : favourite // ignore: cast_nullable_to_non_nullable
              as num,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on

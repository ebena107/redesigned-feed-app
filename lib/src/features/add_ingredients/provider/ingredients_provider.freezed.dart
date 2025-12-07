// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ingredients_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IngredientState implements DiagnosticableTreeMixin {
  List<Ingredient> get ingredients;
  List<IngredientCategory> get categoryList;
  List<Ingredient> get filteredIngredients;
  List<FeedIngredients> get selectedIngredients;
  dynamic get count;
  bool get search;
  bool get sort;
  bool get showSearch;
  bool get showSort;
  String get query;
  num? get sortByCategory; //@Default(false) bool filter,
  bool get validate;
  Ingredient? get newIngredient;
  bool get singleEnergyValue;
  ValidationModel? get name;
  ValidationModel? get crudeProtein;
  ValidationModel? get crudeFiber;
  ValidationModel? get crudeFat;
  ValidationModel? get calcium;
  ValidationModel? get phosphorus;
  ValidationModel? get lysine;
  ValidationModel? get methionine;
  ValidationModel? get meGrowingPig;
  ValidationModel? get meAdultPig;
  ValidationModel? get mePoultry;
  ValidationModel? get meRuminant;
  ValidationModel? get meRabbit;
  ValidationModel? get deSalmonids;
  ValidationModel? get priceKg;
  ValidationModel? get availableQty;
  ValidationModel? get categoryId;
  num get favourite;
  String get status;
  String get message;

  /// Create a copy of IngredientState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IngredientStateCopyWith<IngredientState> get copyWith =>
      _$IngredientStateCopyWithImpl<IngredientState>(
          this as IngredientState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'IngredientState'))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('categoryList', categoryList))
      ..add(DiagnosticsProperty('filteredIngredients', filteredIngredients))
      ..add(DiagnosticsProperty('selectedIngredients', selectedIngredients))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('search', search))
      ..add(DiagnosticsProperty('sort', sort))
      ..add(DiagnosticsProperty('showSearch', showSearch))
      ..add(DiagnosticsProperty('showSort', showSort))
      ..add(DiagnosticsProperty('query', query))
      ..add(DiagnosticsProperty('sortByCategory', sortByCategory))
      ..add(DiagnosticsProperty('validate', validate))
      ..add(DiagnosticsProperty('newIngredient', newIngredient))
      ..add(DiagnosticsProperty('singleEnergyValue', singleEnergyValue))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('crudeProtein', crudeProtein))
      ..add(DiagnosticsProperty('crudeFiber', crudeFiber))
      ..add(DiagnosticsProperty('crudeFat', crudeFat))
      ..add(DiagnosticsProperty('calcium', calcium))
      ..add(DiagnosticsProperty('phosphorus', phosphorus))
      ..add(DiagnosticsProperty('lysine', lysine))
      ..add(DiagnosticsProperty('methionine', methionine))
      ..add(DiagnosticsProperty('meGrowingPig', meGrowingPig))
      ..add(DiagnosticsProperty('meAdultPig', meAdultPig))
      ..add(DiagnosticsProperty('mePoultry', mePoultry))
      ..add(DiagnosticsProperty('meRuminant', meRuminant))
      ..add(DiagnosticsProperty('meRabbit', meRabbit))
      ..add(DiagnosticsProperty('deSalmonids', deSalmonids))
      ..add(DiagnosticsProperty('priceKg', priceKg))
      ..add(DiagnosticsProperty('availableQty', availableQty))
      ..add(DiagnosticsProperty('categoryId', categoryId))
      ..add(DiagnosticsProperty('favourite', favourite))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IngredientState &&
            const DeepCollectionEquality()
                .equals(other.ingredients, ingredients) &&
            const DeepCollectionEquality()
                .equals(other.categoryList, categoryList) &&
            const DeepCollectionEquality()
                .equals(other.filteredIngredients, filteredIngredients) &&
            const DeepCollectionEquality()
                .equals(other.selectedIngredients, selectedIngredients) &&
            const DeepCollectionEquality().equals(other.count, count) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.showSearch, showSearch) ||
                other.showSearch == showSearch) &&
            (identical(other.showSort, showSort) ||
                other.showSort == showSort) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.sortByCategory, sortByCategory) ||
                other.sortByCategory == sortByCategory) &&
            (identical(other.validate, validate) ||
                other.validate == validate) &&
            (identical(other.newIngredient, newIngredient) ||
                other.newIngredient == newIngredient) &&
            (identical(other.singleEnergyValue, singleEnergyValue) ||
                other.singleEnergyValue == singleEnergyValue) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.crudeProtein, crudeProtein) ||
                other.crudeProtein == crudeProtein) &&
            (identical(other.crudeFiber, crudeFiber) ||
                other.crudeFiber == crudeFiber) &&
            (identical(other.crudeFat, crudeFat) ||
                other.crudeFat == crudeFat) &&
            (identical(other.calcium, calcium) || other.calcium == calcium) &&
            (identical(other.phosphorus, phosphorus) ||
                other.phosphorus == phosphorus) &&
            (identical(other.lysine, lysine) || other.lysine == lysine) &&
            (identical(other.methionine, methionine) ||
                other.methionine == methionine) &&
            (identical(other.meGrowingPig, meGrowingPig) ||
                other.meGrowingPig == meGrowingPig) &&
            (identical(other.meAdultPig, meAdultPig) ||
                other.meAdultPig == meAdultPig) &&
            (identical(other.mePoultry, mePoultry) ||
                other.mePoultry == mePoultry) &&
            (identical(other.meRuminant, meRuminant) ||
                other.meRuminant == meRuminant) &&
            (identical(other.meRabbit, meRabbit) ||
                other.meRabbit == meRabbit) &&
            (identical(other.deSalmonids, deSalmonids) ||
                other.deSalmonids == deSalmonids) &&
            (identical(other.priceKg, priceKg) || other.priceKg == priceKg) &&
            (identical(other.availableQty, availableQty) ||
                other.availableQty == availableQty) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.favourite, favourite) ||
                other.favourite == favourite) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(ingredients),
        const DeepCollectionEquality().hash(categoryList),
        const DeepCollectionEquality().hash(filteredIngredients),
        const DeepCollectionEquality().hash(selectedIngredients),
        const DeepCollectionEquality().hash(count),
        search,
        sort,
        showSearch,
        showSort,
        query,
        sortByCategory,
        validate,
        newIngredient,
        singleEnergyValue,
        name,
        crudeProtein,
        crudeFiber,
        crudeFat,
        calcium,
        phosphorus,
        lysine,
        methionine,
        meGrowingPig,
        meAdultPig,
        mePoultry,
        meRuminant,
        meRabbit,
        deSalmonids,
        priceKg,
        availableQty,
        categoryId,
        favourite,
        status,
        message
      ]);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IngredientState(ingredients: $ingredients, categoryList: $categoryList, filteredIngredients: $filteredIngredients, selectedIngredients: $selectedIngredients, count: $count, search: $search, sort: $sort, showSearch: $showSearch, showSort: $showSort, query: $query, sortByCategory: $sortByCategory, validate: $validate, newIngredient: $newIngredient, singleEnergyValue: $singleEnergyValue, name: $name, crudeProtein: $crudeProtein, crudeFiber: $crudeFiber, crudeFat: $crudeFat, calcium: $calcium, phosphorus: $phosphorus, lysine: $lysine, methionine: $methionine, meGrowingPig: $meGrowingPig, meAdultPig: $meAdultPig, mePoultry: $mePoultry, meRuminant: $meRuminant, meRabbit: $meRabbit, deSalmonids: $deSalmonids, priceKg: $priceKg, availableQty: $availableQty, categoryId: $categoryId, favourite: $favourite, status: $status, message: $message)';
  }
}

/// @nodoc
abstract mixin class $IngredientStateCopyWith<$Res> {
  factory $IngredientStateCopyWith(
          IngredientState value, $Res Function(IngredientState) _then) =
      _$IngredientStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Ingredient> ingredients,
      List<IngredientCategory> categoryList,
      List<Ingredient> filteredIngredients,
      List<FeedIngredients> selectedIngredients,
      dynamic count,
      bool search,
      bool sort,
      bool showSearch,
      bool showSort,
      String query,
      num? sortByCategory,
      bool validate,
      Ingredient? newIngredient,
      bool singleEnergyValue,
      ValidationModel? name,
      ValidationModel? crudeProtein,
      ValidationModel? crudeFiber,
      ValidationModel? crudeFat,
      ValidationModel? calcium,
      ValidationModel? phosphorus,
      ValidationModel? lysine,
      ValidationModel? methionine,
      ValidationModel? meGrowingPig,
      ValidationModel? meAdultPig,
      ValidationModel? mePoultry,
      ValidationModel? meRuminant,
      ValidationModel? meRabbit,
      ValidationModel? deSalmonids,
      ValidationModel? priceKg,
      ValidationModel? availableQty,
      ValidationModel? categoryId,
      num favourite,
      String status,
      String message});
}

/// @nodoc
class _$IngredientStateCopyWithImpl<$Res>
    implements $IngredientStateCopyWith<$Res> {
  _$IngredientStateCopyWithImpl(this._self, this._then);

  final IngredientState _self;
  final $Res Function(IngredientState) _then;

  /// Create a copy of IngredientState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ingredients = null,
    Object? categoryList = null,
    Object? filteredIngredients = null,
    Object? selectedIngredients = null,
    Object? count = freezed,
    Object? search = null,
    Object? sort = null,
    Object? showSearch = null,
    Object? showSort = null,
    Object? query = null,
    Object? sortByCategory = freezed,
    Object? validate = null,
    Object? newIngredient = freezed,
    Object? singleEnergyValue = null,
    Object? name = freezed,
    Object? crudeProtein = freezed,
    Object? crudeFiber = freezed,
    Object? crudeFat = freezed,
    Object? calcium = freezed,
    Object? phosphorus = freezed,
    Object? lysine = freezed,
    Object? methionine = freezed,
    Object? meGrowingPig = freezed,
    Object? meAdultPig = freezed,
    Object? mePoultry = freezed,
    Object? meRuminant = freezed,
    Object? meRabbit = freezed,
    Object? deSalmonids = freezed,
    Object? priceKg = freezed,
    Object? availableQty = freezed,
    Object? categoryId = freezed,
    Object? favourite = null,
    Object? status = null,
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      ingredients: null == ingredients
          ? _self.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      categoryList: null == categoryList
          ? _self.categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<IngredientCategory>,
      filteredIngredients: null == filteredIngredients
          ? _self.filteredIngredients
          : filteredIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      selectedIngredients: null == selectedIngredients
          ? _self.selectedIngredients
          : selectedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      count: freezed == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as dynamic,
      search: null == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearch: null == showSearch
          ? _self.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showSort: null == showSort
          ? _self.showSort
          : showSort // ignore: cast_nullable_to_non_nullable
              as bool,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      sortByCategory: freezed == sortByCategory
          ? _self.sortByCategory
          : sortByCategory // ignore: cast_nullable_to_non_nullable
              as num?,
      validate: null == validate
          ? _self.validate
          : validate // ignore: cast_nullable_to_non_nullable
              as bool,
      newIngredient: freezed == newIngredient
          ? _self.newIngredient
          : newIngredient // ignore: cast_nullable_to_non_nullable
              as Ingredient?,
      singleEnergyValue: null == singleEnergyValue
          ? _self.singleEnergyValue
          : singleEnergyValue // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeProtein: freezed == crudeProtein
          ? _self.crudeProtein
          : crudeProtein // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeFiber: freezed == crudeFiber
          ? _self.crudeFiber
          : crudeFiber // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeFat: freezed == crudeFat
          ? _self.crudeFat
          : crudeFat // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      calcium: freezed == calcium
          ? _self.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      phosphorus: freezed == phosphorus
          ? _self.phosphorus
          : phosphorus // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      lysine: freezed == lysine
          ? _self.lysine
          : lysine // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      methionine: freezed == methionine
          ? _self.methionine
          : methionine // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meGrowingPig: freezed == meGrowingPig
          ? _self.meGrowingPig
          : meGrowingPig // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meAdultPig: freezed == meAdultPig
          ? _self.meAdultPig
          : meAdultPig // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      mePoultry: freezed == mePoultry
          ? _self.mePoultry
          : mePoultry // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meRuminant: freezed == meRuminant
          ? _self.meRuminant
          : meRuminant // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meRabbit: freezed == meRabbit
          ? _self.meRabbit
          : meRabbit // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      deSalmonids: freezed == deSalmonids
          ? _self.deSalmonids
          : deSalmonids // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      priceKg: freezed == priceKg
          ? _self.priceKg
          : priceKg // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      availableQty: freezed == availableQty
          ? _self.availableQty
          : availableQty // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
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

/// Adds pattern-matching-related methods to [IngredientState].
extension IngredientStatePatterns on IngredientState {
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
    TResult Function(_IngredientState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IngredientState() when $default != null:
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
    TResult Function(_IngredientState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IngredientState():
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
    TResult? Function(_IngredientState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IngredientState() when $default != null:
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
            List<IngredientCategory> categoryList,
            List<Ingredient> filteredIngredients,
            List<FeedIngredients> selectedIngredients,
            dynamic count,
            bool search,
            bool sort,
            bool showSearch,
            bool showSort,
            String query,
            num? sortByCategory,
            bool validate,
            Ingredient? newIngredient,
            bool singleEnergyValue,
            ValidationModel? name,
            ValidationModel? crudeProtein,
            ValidationModel? crudeFiber,
            ValidationModel? crudeFat,
            ValidationModel? calcium,
            ValidationModel? phosphorus,
            ValidationModel? lysine,
            ValidationModel? methionine,
            ValidationModel? meGrowingPig,
            ValidationModel? meAdultPig,
            ValidationModel? mePoultry,
            ValidationModel? meRuminant,
            ValidationModel? meRabbit,
            ValidationModel? deSalmonids,
            ValidationModel? priceKg,
            ValidationModel? availableQty,
            ValidationModel? categoryId,
            num favourite,
            String status,
            String message)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _IngredientState() when $default != null:
        return $default(
            _that.ingredients,
            _that.categoryList,
            _that.filteredIngredients,
            _that.selectedIngredients,
            _that.count,
            _that.search,
            _that.sort,
            _that.showSearch,
            _that.showSort,
            _that.query,
            _that.sortByCategory,
            _that.validate,
            _that.newIngredient,
            _that.singleEnergyValue,
            _that.name,
            _that.crudeProtein,
            _that.crudeFiber,
            _that.crudeFat,
            _that.calcium,
            _that.phosphorus,
            _that.lysine,
            _that.methionine,
            _that.meGrowingPig,
            _that.meAdultPig,
            _that.mePoultry,
            _that.meRuminant,
            _that.meRabbit,
            _that.deSalmonids,
            _that.priceKg,
            _that.availableQty,
            _that.categoryId,
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
            List<IngredientCategory> categoryList,
            List<Ingredient> filteredIngredients,
            List<FeedIngredients> selectedIngredients,
            dynamic count,
            bool search,
            bool sort,
            bool showSearch,
            bool showSort,
            String query,
            num? sortByCategory,
            bool validate,
            Ingredient? newIngredient,
            bool singleEnergyValue,
            ValidationModel? name,
            ValidationModel? crudeProtein,
            ValidationModel? crudeFiber,
            ValidationModel? crudeFat,
            ValidationModel? calcium,
            ValidationModel? phosphorus,
            ValidationModel? lysine,
            ValidationModel? methionine,
            ValidationModel? meGrowingPig,
            ValidationModel? meAdultPig,
            ValidationModel? mePoultry,
            ValidationModel? meRuminant,
            ValidationModel? meRabbit,
            ValidationModel? deSalmonids,
            ValidationModel? priceKg,
            ValidationModel? availableQty,
            ValidationModel? categoryId,
            num favourite,
            String status,
            String message)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IngredientState():
        return $default(
            _that.ingredients,
            _that.categoryList,
            _that.filteredIngredients,
            _that.selectedIngredients,
            _that.count,
            _that.search,
            _that.sort,
            _that.showSearch,
            _that.showSort,
            _that.query,
            _that.sortByCategory,
            _that.validate,
            _that.newIngredient,
            _that.singleEnergyValue,
            _that.name,
            _that.crudeProtein,
            _that.crudeFiber,
            _that.crudeFat,
            _that.calcium,
            _that.phosphorus,
            _that.lysine,
            _that.methionine,
            _that.meGrowingPig,
            _that.meAdultPig,
            _that.mePoultry,
            _that.meRuminant,
            _that.meRabbit,
            _that.deSalmonids,
            _that.priceKg,
            _that.availableQty,
            _that.categoryId,
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
            List<IngredientCategory> categoryList,
            List<Ingredient> filteredIngredients,
            List<FeedIngredients> selectedIngredients,
            dynamic count,
            bool search,
            bool sort,
            bool showSearch,
            bool showSort,
            String query,
            num? sortByCategory,
            bool validate,
            Ingredient? newIngredient,
            bool singleEnergyValue,
            ValidationModel? name,
            ValidationModel? crudeProtein,
            ValidationModel? crudeFiber,
            ValidationModel? crudeFat,
            ValidationModel? calcium,
            ValidationModel? phosphorus,
            ValidationModel? lysine,
            ValidationModel? methionine,
            ValidationModel? meGrowingPig,
            ValidationModel? meAdultPig,
            ValidationModel? mePoultry,
            ValidationModel? meRuminant,
            ValidationModel? meRabbit,
            ValidationModel? deSalmonids,
            ValidationModel? priceKg,
            ValidationModel? availableQty,
            ValidationModel? categoryId,
            num favourite,
            String status,
            String message)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _IngredientState() when $default != null:
        return $default(
            _that.ingredients,
            _that.categoryList,
            _that.filteredIngredients,
            _that.selectedIngredients,
            _that.count,
            _that.search,
            _that.sort,
            _that.showSearch,
            _that.showSort,
            _that.query,
            _that.sortByCategory,
            _that.validate,
            _that.newIngredient,
            _that.singleEnergyValue,
            _that.name,
            _that.crudeProtein,
            _that.crudeFiber,
            _that.crudeFat,
            _that.calcium,
            _that.phosphorus,
            _that.lysine,
            _that.methionine,
            _that.meGrowingPig,
            _that.meAdultPig,
            _that.mePoultry,
            _that.meRuminant,
            _that.meRabbit,
            _that.deSalmonids,
            _that.priceKg,
            _that.availableQty,
            _that.categoryId,
            _that.favourite,
            _that.status,
            _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _IngredientState extends IngredientState with DiagnosticableTreeMixin {
  const _IngredientState(
      {final List<Ingredient> ingredients = const [],
      final List<IngredientCategory> categoryList = const [],
      final List<Ingredient> filteredIngredients = const [],
      final List<FeedIngredients> selectedIngredients = const [],
      this.count = 0,
      this.search = false,
      this.sort = false,
      this.showSearch = true,
      this.showSort = true,
      this.query = "",
      this.sortByCategory,
      this.validate = false,
      this.newIngredient,
      this.singleEnergyValue = false,
      this.name,
      this.crudeProtein,
      this.crudeFiber,
      this.crudeFat,
      this.calcium,
      this.phosphorus,
      this.lysine,
      this.methionine,
      this.meGrowingPig,
      this.meAdultPig,
      this.mePoultry,
      this.meRuminant,
      this.meRabbit,
      this.deSalmonids,
      this.priceKg,
      this.availableQty,
      this.categoryId,
      this.favourite = 0,
      this.status = "",
      this.message = ""})
      : _ingredients = ingredients,
        _categoryList = categoryList,
        _filteredIngredients = filteredIngredients,
        _selectedIngredients = selectedIngredients,
        super._();

  final List<Ingredient> _ingredients;
  @override
  @JsonKey()
  List<Ingredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<IngredientCategory> _categoryList;
  @override
  @JsonKey()
  List<IngredientCategory> get categoryList {
    if (_categoryList is EqualUnmodifiableListView) return _categoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryList);
  }

  final List<Ingredient> _filteredIngredients;
  @override
  @JsonKey()
  List<Ingredient> get filteredIngredients {
    if (_filteredIngredients is EqualUnmodifiableListView)
      return _filteredIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredIngredients);
  }

  final List<FeedIngredients> _selectedIngredients;
  @override
  @JsonKey()
  List<FeedIngredients> get selectedIngredients {
    if (_selectedIngredients is EqualUnmodifiableListView)
      return _selectedIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedIngredients);
  }

  @override
  @JsonKey()
  final dynamic count;
  @override
  @JsonKey()
  final bool search;
  @override
  @JsonKey()
  final bool sort;
  @override
  @JsonKey()
  final bool showSearch;
  @override
  @JsonKey()
  final bool showSort;
  @override
  @JsonKey()
  final String query;
  @override
  final num? sortByCategory;
//@Default(false) bool filter,
  @override
  @JsonKey()
  final bool validate;
  @override
  final Ingredient? newIngredient;
  @override
  @JsonKey()
  final bool singleEnergyValue;
  @override
  final ValidationModel? name;
  @override
  final ValidationModel? crudeProtein;
  @override
  final ValidationModel? crudeFiber;
  @override
  final ValidationModel? crudeFat;
  @override
  final ValidationModel? calcium;
  @override
  final ValidationModel? phosphorus;
  @override
  final ValidationModel? lysine;
  @override
  final ValidationModel? methionine;
  @override
  final ValidationModel? meGrowingPig;
  @override
  final ValidationModel? meAdultPig;
  @override
  final ValidationModel? mePoultry;
  @override
  final ValidationModel? meRuminant;
  @override
  final ValidationModel? meRabbit;
  @override
  final ValidationModel? deSalmonids;
  @override
  final ValidationModel? priceKg;
  @override
  final ValidationModel? availableQty;
  @override
  final ValidationModel? categoryId;
  @override
  @JsonKey()
  final num favourite;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String message;

  /// Create a copy of IngredientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$IngredientStateCopyWith<_IngredientState> get copyWith =>
      __$IngredientStateCopyWithImpl<_IngredientState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'IngredientState'))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('categoryList', categoryList))
      ..add(DiagnosticsProperty('filteredIngredients', filteredIngredients))
      ..add(DiagnosticsProperty('selectedIngredients', selectedIngredients))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('search', search))
      ..add(DiagnosticsProperty('sort', sort))
      ..add(DiagnosticsProperty('showSearch', showSearch))
      ..add(DiagnosticsProperty('showSort', showSort))
      ..add(DiagnosticsProperty('query', query))
      ..add(DiagnosticsProperty('sortByCategory', sortByCategory))
      ..add(DiagnosticsProperty('validate', validate))
      ..add(DiagnosticsProperty('newIngredient', newIngredient))
      ..add(DiagnosticsProperty('singleEnergyValue', singleEnergyValue))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('crudeProtein', crudeProtein))
      ..add(DiagnosticsProperty('crudeFiber', crudeFiber))
      ..add(DiagnosticsProperty('crudeFat', crudeFat))
      ..add(DiagnosticsProperty('calcium', calcium))
      ..add(DiagnosticsProperty('phosphorus', phosphorus))
      ..add(DiagnosticsProperty('lysine', lysine))
      ..add(DiagnosticsProperty('methionine', methionine))
      ..add(DiagnosticsProperty('meGrowingPig', meGrowingPig))
      ..add(DiagnosticsProperty('meAdultPig', meAdultPig))
      ..add(DiagnosticsProperty('mePoultry', mePoultry))
      ..add(DiagnosticsProperty('meRuminant', meRuminant))
      ..add(DiagnosticsProperty('meRabbit', meRabbit))
      ..add(DiagnosticsProperty('deSalmonids', deSalmonids))
      ..add(DiagnosticsProperty('priceKg', priceKg))
      ..add(DiagnosticsProperty('availableQty', availableQty))
      ..add(DiagnosticsProperty('categoryId', categoryId))
      ..add(DiagnosticsProperty('favourite', favourite))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _IngredientState &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._categoryList, _categoryList) &&
            const DeepCollectionEquality()
                .equals(other._filteredIngredients, _filteredIngredients) &&
            const DeepCollectionEquality()
                .equals(other._selectedIngredients, _selectedIngredients) &&
            const DeepCollectionEquality().equals(other.count, count) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.showSearch, showSearch) ||
                other.showSearch == showSearch) &&
            (identical(other.showSort, showSort) ||
                other.showSort == showSort) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.sortByCategory, sortByCategory) ||
                other.sortByCategory == sortByCategory) &&
            (identical(other.validate, validate) ||
                other.validate == validate) &&
            (identical(other.newIngredient, newIngredient) ||
                other.newIngredient == newIngredient) &&
            (identical(other.singleEnergyValue, singleEnergyValue) ||
                other.singleEnergyValue == singleEnergyValue) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.crudeProtein, crudeProtein) ||
                other.crudeProtein == crudeProtein) &&
            (identical(other.crudeFiber, crudeFiber) ||
                other.crudeFiber == crudeFiber) &&
            (identical(other.crudeFat, crudeFat) ||
                other.crudeFat == crudeFat) &&
            (identical(other.calcium, calcium) || other.calcium == calcium) &&
            (identical(other.phosphorus, phosphorus) ||
                other.phosphorus == phosphorus) &&
            (identical(other.lysine, lysine) || other.lysine == lysine) &&
            (identical(other.methionine, methionine) ||
                other.methionine == methionine) &&
            (identical(other.meGrowingPig, meGrowingPig) ||
                other.meGrowingPig == meGrowingPig) &&
            (identical(other.meAdultPig, meAdultPig) ||
                other.meAdultPig == meAdultPig) &&
            (identical(other.mePoultry, mePoultry) ||
                other.mePoultry == mePoultry) &&
            (identical(other.meRuminant, meRuminant) ||
                other.meRuminant == meRuminant) &&
            (identical(other.meRabbit, meRabbit) ||
                other.meRabbit == meRabbit) &&
            (identical(other.deSalmonids, deSalmonids) ||
                other.deSalmonids == deSalmonids) &&
            (identical(other.priceKg, priceKg) || other.priceKg == priceKg) &&
            (identical(other.availableQty, availableQty) ||
                other.availableQty == availableQty) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.favourite, favourite) ||
                other.favourite == favourite) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_ingredients),
        const DeepCollectionEquality().hash(_categoryList),
        const DeepCollectionEquality().hash(_filteredIngredients),
        const DeepCollectionEquality().hash(_selectedIngredients),
        const DeepCollectionEquality().hash(count),
        search,
        sort,
        showSearch,
        showSort,
        query,
        sortByCategory,
        validate,
        newIngredient,
        singleEnergyValue,
        name,
        crudeProtein,
        crudeFiber,
        crudeFat,
        calcium,
        phosphorus,
        lysine,
        methionine,
        meGrowingPig,
        meAdultPig,
        mePoultry,
        meRuminant,
        meRabbit,
        deSalmonids,
        priceKg,
        availableQty,
        categoryId,
        favourite,
        status,
        message
      ]);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IngredientState(ingredients: $ingredients, categoryList: $categoryList, filteredIngredients: $filteredIngredients, selectedIngredients: $selectedIngredients, count: $count, search: $search, sort: $sort, showSearch: $showSearch, showSort: $showSort, query: $query, sortByCategory: $sortByCategory, validate: $validate, newIngredient: $newIngredient, singleEnergyValue: $singleEnergyValue, name: $name, crudeProtein: $crudeProtein, crudeFiber: $crudeFiber, crudeFat: $crudeFat, calcium: $calcium, phosphorus: $phosphorus, lysine: $lysine, methionine: $methionine, meGrowingPig: $meGrowingPig, meAdultPig: $meAdultPig, mePoultry: $mePoultry, meRuminant: $meRuminant, meRabbit: $meRabbit, deSalmonids: $deSalmonids, priceKg: $priceKg, availableQty: $availableQty, categoryId: $categoryId, favourite: $favourite, status: $status, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$IngredientStateCopyWith<$Res>
    implements $IngredientStateCopyWith<$Res> {
  factory _$IngredientStateCopyWith(
          _IngredientState value, $Res Function(_IngredientState) _then) =
      __$IngredientStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Ingredient> ingredients,
      List<IngredientCategory> categoryList,
      List<Ingredient> filteredIngredients,
      List<FeedIngredients> selectedIngredients,
      dynamic count,
      bool search,
      bool sort,
      bool showSearch,
      bool showSort,
      String query,
      num? sortByCategory,
      bool validate,
      Ingredient? newIngredient,
      bool singleEnergyValue,
      ValidationModel? name,
      ValidationModel? crudeProtein,
      ValidationModel? crudeFiber,
      ValidationModel? crudeFat,
      ValidationModel? calcium,
      ValidationModel? phosphorus,
      ValidationModel? lysine,
      ValidationModel? methionine,
      ValidationModel? meGrowingPig,
      ValidationModel? meAdultPig,
      ValidationModel? mePoultry,
      ValidationModel? meRuminant,
      ValidationModel? meRabbit,
      ValidationModel? deSalmonids,
      ValidationModel? priceKg,
      ValidationModel? availableQty,
      ValidationModel? categoryId,
      num favourite,
      String status,
      String message});
}

/// @nodoc
class __$IngredientStateCopyWithImpl<$Res>
    implements _$IngredientStateCopyWith<$Res> {
  __$IngredientStateCopyWithImpl(this._self, this._then);

  final _IngredientState _self;
  final $Res Function(_IngredientState) _then;

  /// Create a copy of IngredientState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ingredients = null,
    Object? categoryList = null,
    Object? filteredIngredients = null,
    Object? selectedIngredients = null,
    Object? count = freezed,
    Object? search = null,
    Object? sort = null,
    Object? showSearch = null,
    Object? showSort = null,
    Object? query = null,
    Object? sortByCategory = freezed,
    Object? validate = null,
    Object? newIngredient = freezed,
    Object? singleEnergyValue = null,
    Object? name = freezed,
    Object? crudeProtein = freezed,
    Object? crudeFiber = freezed,
    Object? crudeFat = freezed,
    Object? calcium = freezed,
    Object? phosphorus = freezed,
    Object? lysine = freezed,
    Object? methionine = freezed,
    Object? meGrowingPig = freezed,
    Object? meAdultPig = freezed,
    Object? mePoultry = freezed,
    Object? meRuminant = freezed,
    Object? meRabbit = freezed,
    Object? deSalmonids = freezed,
    Object? priceKg = freezed,
    Object? availableQty = freezed,
    Object? categoryId = freezed,
    Object? favourite = null,
    Object? status = null,
    Object? message = null,
  }) {
    return _then(_IngredientState(
      ingredients: null == ingredients
          ? _self._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      categoryList: null == categoryList
          ? _self._categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<IngredientCategory>,
      filteredIngredients: null == filteredIngredients
          ? _self._filteredIngredients
          : filteredIngredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      selectedIngredients: null == selectedIngredients
          ? _self._selectedIngredients
          : selectedIngredients // ignore: cast_nullable_to_non_nullable
              as List<FeedIngredients>,
      count: freezed == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as dynamic,
      search: null == search
          ? _self.search
          : search // ignore: cast_nullable_to_non_nullable
              as bool,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearch: null == showSearch
          ? _self.showSearch
          : showSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      showSort: null == showSort
          ? _self.showSort
          : showSort // ignore: cast_nullable_to_non_nullable
              as bool,
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      sortByCategory: freezed == sortByCategory
          ? _self.sortByCategory
          : sortByCategory // ignore: cast_nullable_to_non_nullable
              as num?,
      validate: null == validate
          ? _self.validate
          : validate // ignore: cast_nullable_to_non_nullable
              as bool,
      newIngredient: freezed == newIngredient
          ? _self.newIngredient
          : newIngredient // ignore: cast_nullable_to_non_nullable
              as Ingredient?,
      singleEnergyValue: null == singleEnergyValue
          ? _self.singleEnergyValue
          : singleEnergyValue // ignore: cast_nullable_to_non_nullable
              as bool,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeProtein: freezed == crudeProtein
          ? _self.crudeProtein
          : crudeProtein // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeFiber: freezed == crudeFiber
          ? _self.crudeFiber
          : crudeFiber // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      crudeFat: freezed == crudeFat
          ? _self.crudeFat
          : crudeFat // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      calcium: freezed == calcium
          ? _self.calcium
          : calcium // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      phosphorus: freezed == phosphorus
          ? _self.phosphorus
          : phosphorus // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      lysine: freezed == lysine
          ? _self.lysine
          : lysine // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      methionine: freezed == methionine
          ? _self.methionine
          : methionine // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meGrowingPig: freezed == meGrowingPig
          ? _self.meGrowingPig
          : meGrowingPig // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meAdultPig: freezed == meAdultPig
          ? _self.meAdultPig
          : meAdultPig // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      mePoultry: freezed == mePoultry
          ? _self.mePoultry
          : mePoultry // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meRuminant: freezed == meRuminant
          ? _self.meRuminant
          : meRuminant // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      meRabbit: freezed == meRabbit
          ? _self.meRabbit
          : meRabbit // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      deSalmonids: freezed == deSalmonids
          ? _self.deSalmonids
          : deSalmonids // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      priceKg: freezed == priceKg
          ? _self.priceKg
          : priceKg // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      availableQty: freezed == availableQty
          ? _self.availableQty
          : availableQty // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as ValidationModel?,
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

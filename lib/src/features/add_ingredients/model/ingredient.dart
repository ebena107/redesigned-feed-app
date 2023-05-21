import 'dart:convert';

/// name : "Alfalfa, dehydrated, protein < 16% dry matter"
/// crude_protein : 14.1
/// crude_fiber : 28.0
/// crude_fat : 2.1
/// calcium : 20.1
/// phosphorus : 2.4
/// lysine : 5.6
/// methionine : 1.2
/// me_growing_pig : 1590
/// me_adult_pig : 1680
/// me_poultry : 1070
/// me_ruminant : 1910
/// me_rabbit : 1630
/// de_salmonids : 2160
/// price_kg : 0.01
/// available_qty : 0.01
/// category_id : 13

Ingredient ingredientFromJson(String str) =>
    Ingredient.fromJson(json.decode(str));
String ingredientToJson(Ingredient data) => json.encode(data.toJson());

List<Ingredient> ingredientListFromJson(String str) =>
    List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromJson(x)));

String ingredientListToJson(List<Ingredient> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingredient {
  Ingredient({
    this.ingredientId,
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
    this.favourite,
  });

  Ingredient.fromJson(dynamic json) {
    ingredientId = json['ingredient_id'];
    name = json['name'];
    crudeProtein = json['crude_protein'];
    crudeFiber = json['crude_fiber'];
    crudeFat = json['crude_fat'];
    calcium = json['calcium'];
    phosphorus = json['phosphorus'];
    lysine = json['lysine'];
    methionine = json['methionine'];
    meGrowingPig = json['me_growing_pig'];
    meAdultPig = json['me_adult_pig'];
    mePoultry = json['me_poultry'];
    meRuminant = json['me_ruminant'];
    meRabbit = json['me_rabbit'];
    deSalmonids = json['de_salmonids'];
    priceKg = json['price_kg'];
    availableQty = json['available_qty'];
    categoryId = json['category_id'];
    favourite = json['favourite'];
  }
  num? ingredientId;
  String? name;
  num? crudeProtein;
  num? crudeFiber;
  num? crudeFat;
  num? calcium;
  num? phosphorus;
  num? lysine;
  num? methionine;
  num? meGrowingPig;
  num? meAdultPig;
  num? mePoultry;
  num? meRuminant;
  num? meRabbit;
  num? deSalmonids;
  num? priceKg;
  num? availableQty;
  num? categoryId;
  num? favourite;

  Ingredient copyWith({
    num? ingredientId,
    String? name,
    num? crudeProtein,
    num? crudeFiber,
    num? crudeFat,
    num? calcium,
    num? phosphorus,
    num? lysine,
    num? methionine,
    num? meGrowingPig,
    num? meAdultPig,
    num? mePoultry,
    num? meRuminant,
    num? meRabbit,
    num? deSalmonids,
    num? priceKg,
    num? availableQty,
    num? categoryId,
    num? favourite,
  }) =>
      Ingredient(
        ingredientId: ingredientId ?? this.ingredientId,
        name: name ?? this.name,
        crudeProtein: crudeProtein ?? this.crudeProtein,
        crudeFiber: crudeFiber ?? this.crudeFiber,
        crudeFat: crudeFat ?? this.crudeFat,
        calcium: calcium ?? this.calcium,
        phosphorus: phosphorus ?? this.phosphorus,
        lysine: lysine ?? this.lysine,
        methionine: methionine ?? this.methionine,
        meGrowingPig: meGrowingPig ?? this.meGrowingPig,
        meAdultPig: meAdultPig ?? this.meAdultPig,
        mePoultry: mePoultry ?? this.mePoultry,
        meRuminant: meRuminant ?? this.meRuminant,
        meRabbit: meRabbit ?? this.meRabbit,
        deSalmonids: deSalmonids ?? this.deSalmonids,
        priceKg: priceKg ?? this.priceKg,
        availableQty: availableQty ?? this.availableQty,
        categoryId: categoryId ?? this.categoryId,
        favourite: favourite ?? this.favourite,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ingredient_id'] = ingredientId;
    map['name'] = name;
    map['crude_protein'] = crudeProtein;
    map['crude_fiber'] = crudeFiber;
    map['crude_fat'] = crudeFat;
    map['calcium'] = calcium;
    map['phosphorus'] = phosphorus;
    map['lysine'] = lysine;
    map['methionine'] = methionine;
    map['me_growing_pig'] = meGrowingPig;
    map['me_adult_pig'] = meAdultPig;
    map['me_poultry'] = mePoultry;
    map['me_ruminant'] = meRuminant;
    map['me_rabbit'] = meRabbit;
    map['de_salmonids'] = deSalmonids;
    map['price_kg'] = priceKg;
    map['available_qty'] = availableQty;
    map['category_id'] = categoryId;
    map['favourite'] = favourite;
    return map;
  }
}

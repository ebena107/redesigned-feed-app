import 'dart:convert';

/// name : "Alfalfa, dehydrated, protein < 16% dry matter"
/// crude_protein : 14.1 (% dry matter)
/// crude_fiber : 28.0 (% dry matter)
/// crude_fat : 2.1 (% dry matter)
/// calcium : 20.1 (g/kg or % - see notes)
/// phosphorus : 2.4 (g/kg or % - see notes)
/// lysine : 5.6 (g/kg or % - see notes)
/// methionine : 1.2 (g/kg or % - see notes)
/// me_growing_pig : 1590 (kcal/kg - metabolizable energy)
/// me_adult_pig : 1680 (kcal/kg)
/// me_poultry : 1070 (kcal/kg)
/// me_ruminant : 1910 (kcal/kg)
/// me_rabbit : 1630 (kcal/kg)
/// de_salmonids : 2160 (kcal/kg - digestible energy for fish)
/// price_kg : 0.01 (currency units)
/// available_qty : 0.01 (kg or tonnes)
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
    this.isCustom,
    this.createdBy,
    this.createdDate,
    this.notes,
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
    isCustom = json['is_custom'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    notes = json['notes'];
  }
  num? ingredientId;
  String? name;
  num? crudeProtein; // Units: % dry matter (DM)
  num? crudeFiber; // Units: % dry matter (DM)
  num? crudeFat; // Units: % dry matter (DM)
  num? calcium; // Units: g/kg (to be verified in next phase)
  num? phosphorus; // Units: g/kg (to be verified in next phase)
  num? lysine; // Units: g/kg (to be verified in next phase)
  num? methionine; // Units: g/kg (to be verified in next phase)
  num? meGrowingPig; // Units: kcal/kg (Metabolizable Energy for growing pigs)
  num? meAdultPig; // Units: kcal/kg (Metabolizable Energy for adult pigs)
  num? mePoultry; // Units: kcal/kg (Metabolizable Energy for poultry)
  num? meRuminant; // Units: kcal/kg (Metabolizable Energy for ruminants)
  num? meRabbit; // Units: kcal/kg (Metabolizable Energy for rabbits)
  num? deSalmonids; // Units: kcal/kg (Digestible Energy for salmonids/fish)
  num? priceKg; // Units: currency per kg
  num? availableQty; // Units: kg or tonnes
  num? categoryId;
  num? favourite;
  num? isCustom;
  String? createdBy;
  num? createdDate;
  String? notes;

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
    num? isCustom,
    String? createdBy,
    num? createdDate,
    String? notes,
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
        isCustom: isCustom ?? this.isCustom,
        createdBy: createdBy ?? this.createdBy,
        createdDate: createdDate ?? this.createdDate,
        notes: notes ?? this.notes,
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
    map['is_custom'] = isCustom;
    map['created_by'] = createdBy;
    map['created_date'] = createdDate;
    map['notes'] = notes;
    return map;
  }
}

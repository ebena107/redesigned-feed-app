import 'dart:convert';

/// category : "Cereal grains"
/// category_id : 1

IngredientCategory ingredientCategoryFromJson(String str) =>
    IngredientCategory.fromJson(json.decode(str));
String ingredientCategoryToJson(IngredientCategory data) =>
    json.encode(data.toJson());

List<IngredientCategory> ingredientCategoryListFromJson(String str) =>
    List<IngredientCategory>.from(
        json.decode(str).map((x) => IngredientCategory.fromJson(x)));

String ingredientCategoryListToJson(List<IngredientCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IngredientCategory {
  IngredientCategory({
    this.category,
    this.categoryId,
  });

  IngredientCategory.fromJson(dynamic json) {
    category = json['category'];
    categoryId = json['category_id'];
  }
  String? category;
  num? categoryId;

  IngredientCategory copyWith({
    String? category,
    num? categoryId,
  }) =>
      IngredientCategory(
        category: category ?? this.category,
        categoryId: categoryId ?? this.categoryId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = category;
    map['category_id'] = categoryId;
    return map;
  }
}

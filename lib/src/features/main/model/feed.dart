import 'dart:convert';

/// feed_id : 1
/// feed_name : "animal feed"
/// animal_id : 2
/// feedIngredients : [{"feed_id":1,"ingredient_id":1,"quantity":0.1,"priceUnitKg":25.2}]
/// timestamp_modified : 12222225666666

Feed feedFromJson(String str) => Feed.fromJson(json.decode(str));
String feedToJson(Feed data) => json.encode(data.toJson());

class Feed {
  num? feedId;
  String? feedName;
  num? animalId;
  List<FeedIngredients>? feedIngredients;
  num? timestampModified;

  Feed({
    this.feedId,
    this.feedName,
    this.animalId,
    this.feedIngredients,
    this.timestampModified,
  });

  Feed.fromJson(dynamic json) {
    feedId = json['feed_id'];
    feedName = json['feed_name'];
    animalId = json['animal_id'];
    if (json['feedIngredients'] != null) {
      feedIngredients = [];
      json['feedIngredients'].forEach((v) {
        feedIngredients?.add(FeedIngredients.fromJson(v));
      });
    }
    timestampModified = json['timestamp_modified'];
  }

  Feed copyWith({
    num? feedId,
    String? feedName,
    num? animalId,
    List<FeedIngredients>? feedIngredients,
    num? timestampModified,
  }) =>
      Feed(
        feedId: feedId ?? this.feedId,
        feedName: feedName ?? this.feedName,
        animalId: animalId ?? this.animalId,
        feedIngredients: feedIngredients ?? this.feedIngredients,
        timestampModified: timestampModified ?? this.timestampModified,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feed_id'] = feedId;
    map['feed_name'] = feedName;
    map['animal_id'] = animalId;
    if (feedIngredients != null) {
      map['feedIngredients'] = feedIngredients?.map((v) => v.toJson()).toList();
    }
    map['timestamp_modified'] = timestampModified;
    return map;
  }
}

/// feed_id : 1
/// ingredient_id : 1
/// quantity : 0.1
/// priceUnitKg : 25.2

FeedIngredients feedIngredientsFromJson(String str) =>
    FeedIngredients.fromJson(json.decode(str));
String feedIngredientsToJson(FeedIngredients data) =>
    json.encode(data.toJson());

class FeedIngredients {
  FeedIngredients({
    this.id,
    this.feedId,
    this.ingredientId,
    this.quantity,
    this.priceUnitKg,
    this.priceLastUpdated,
  });

  FeedIngredients.fromJson(dynamic json) {
    id = json['id'];
    feedId = json['feed_id'];
    ingredientId = json['ingredient_id'];
    quantity = json['quantity'];
    priceUnitKg = json['price_unit_kg'];
    priceLastUpdated = json['price_last_updated'];
  }
  num? id;
  num? feedId;
  num? ingredientId;
  num? quantity;
  num? priceUnitKg;
  num? priceLastUpdated;

  FeedIngredients copyWith({
    num? id,
    num? feedId,
    num? ingredientId,
    num? quantity,
    num? priceUnitKg,
    num? priceLastUpdated,
  }) =>
      FeedIngredients(
        id: id ?? this.id,
        feedId: feedId ?? this.feedId,
        ingredientId: ingredientId ?? this.ingredientId,
        quantity: quantity ?? this.quantity,
        priceUnitKg: priceUnitKg ?? this.priceUnitKg,
        priceLastUpdated: priceLastUpdated ?? this.priceLastUpdated,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['feed_id'] = feedId;
    map['ingredient_id'] = ingredientId;
    map['quantity'] = quantity;
    map['price_unit_kg'] = priceUnitKg;
    map['price_last_updated'] = priceLastUpdated;
    return map;
  }
}

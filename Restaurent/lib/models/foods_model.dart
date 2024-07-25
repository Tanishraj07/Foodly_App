// To parse this JSON data, do
//
//     final foodsModel = foodsModelFromJson(jsonString);

import 'dart:convert';

List<FoodsModel> foodsModelFromJson(String str) => List<FoodsModel>.from(json.decode(str).map((x) => FoodsModel.fromJson(x)));

String foodsModelToJson(List<FoodsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodsModel {
  String id;
  String title;
  String time;
  List<String> foodTags;
  String category;
  List<String> foodType;
  String code;
  bool isAvailable;
  String restaurant;
  double rating;
  String ratingCount;
  String description;
  double price;
  List<Additive> additives;
  List<String> imageUrl;
  int v;

  FoodsModel({
    required this.id,
    required this.title,
    required this.time,
    required this.foodTags,
    required this.category,
    required this.foodType,
    required this.code,
    required this.isAvailable,
    required this.restaurant,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.price,
    required this.additives,
    required this.imageUrl,
    required this.v,
  });

  factory FoodsModel.fromJson(Map<String, dynamic> json) => FoodsModel(
    id: json["_id"],
    title: json["title"],
    time: json["time"],
    foodTags: List<String>.from(json["foodTags"].map((x) => x)),
    category: json["category"],
    foodType: List<String>.from(json["foodType"].map((x) => x)),
    code: json["code"],
    isAvailable: json["isAvailable"],
    restaurant: json["restaurant"],
    rating: json["rating"]?.toDouble(),
    ratingCount: json["ratingCount"],
    description: json["description"],
    price: json["price"]?.toDouble(),
    additives: List<Additive>.from(json["additives"].map((x) => Additive.fromJson(x))),
    imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "time": time,
    "foodTags": List<dynamic>.from(foodTags.map((x) => x)),
    "category": category,
    "foodType": List<dynamic>.from(foodType.map((x) => x)),
    "code": code,
    "isAvailable": isAvailable,
    "restaurant": restaurant,
    "rating": rating,
    "ratingCount": ratingCount,
    "description": description,
    "price": price,
    "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
    "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    "__v": v,
  };
}

class Additive {
  int id;
  String title;
  String price;

  Additive({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Additive.fromJson(Map<String, dynamic> json) => Additive(
    id: json["id"],
    title: json["title"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
  };
}

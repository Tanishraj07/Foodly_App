import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) => List<CategoriesModel>.from(json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  String id;
  String title;
  String value;
  String imageUrl;
  int? v;

  CategoriesModel({
    required this.id,
    required this.title,
    required this.value,
    required this.imageUrl,
    this.v,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    id: json["_id"],
    title: json["title"],
    value: json["value"],
    imageUrl: json["imageUrl"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "value": value,
    "imageUrl": imageUrl,
    "__v": v,
  };
}

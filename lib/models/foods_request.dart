import 'dart:convert';

import 'package:rivus_supplier/models/items.dart';

AddItems addItemsFromJson(String str) => AddItems.fromJson(json.decode(str));

String addItemsToJson(AddItems data) => json.encode(data.toJson());

class AddItems {
  final String title;
  final List<String> itemTags;
  final String code;
  final String category;
  final bool isAvailable;
  final String supplier;
  final String description;
  final double? price;
  final List<String> imageUrl;
  final String unit;

  AddItems({
    required this.title,
    required this.itemTags,
    required this.code,
    required this.category,
    required this.isAvailable,
    required this.supplier,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.unit,
  });

  factory AddItems.fromJson(Map<String, dynamic> json) => AddItems(
        title: json["title"],
        itemTags: List<String>.from(json["itemTags"].map((x) => x)),
        code: json["code"],
        category: json["category"],
        isAvailable: json["isAvailable"],
        supplier: json["supplier"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "itemTags": List<dynamic>.from(itemTags.map((x) => x)),
        "code": code,
        "category": category,
        "isAvailable": isAvailable,
        "supplier": supplier,
        "description": description,
        "price": price,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "unit": unit,
      };
}

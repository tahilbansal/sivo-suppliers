// To parse this JSON data, do
//
//     final status = statusFromJson(jsonString);

import 'dart:convert';

PriceVisibility priceVisibilityFromJson(String str) =>
    PriceVisibility.fromJson(json.decode(str));

class PriceVisibility {
  final String message;
  final bool showItemPrice;

  PriceVisibility({
    required this.message,
    required this.showItemPrice,
  });

  factory PriceVisibility.fromJson(Map<String, dynamic> json) =>
      PriceVisibility(
        message: json["message"],
        showItemPrice: json["showItemPrice"],
      );
}

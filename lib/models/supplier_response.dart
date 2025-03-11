// To parse this JSON data, do
//
//     final supplierResponse = supplierResponseFromJson(jsonString);

import 'dart:convert';

SupplierResponse supplierResponseFromJson(String str) =>
    SupplierResponse.fromJson(json.decode(str));

String supplierResponseToJson(SupplierResponse data) =>
    json.encode(data.toJson());

class SupplierResponse {
  final String id;
  final Coords coords;
  final String title;
  final String time;
  final String imageUrl;
  final List<dynamic> items;
  final bool pickup;
  final bool delivery;
  final bool showItemPrice;
  final String owner;
  final bool isAvailable;
  final String code;
  final String logoUrl;
  final int rating;
  final String ratingCount;
  final String verification;
  final String verificationMessage;

  SupplierResponse({
    required this.coords,
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.items,
    required this.pickup,
    required this.delivery,
    required this.showItemPrice,
    required this.owner,
    required this.isAvailable,
    required this.code,
    required this.logoUrl,
    required this.rating,
    required this.ratingCount,
    required this.verification,
    required this.verificationMessage,
  });

  factory SupplierResponse.fromJson(Map<String, dynamic> json) =>
      SupplierResponse(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        items: List<dynamic>.from(json["items"].map((x) => x)),
        pickup: json["pickup"],
        delivery: json["delivery"],
        owner: json["owner"],
        isAvailable: json["isAvailable"],
        showItemPrice: json["showItemPrice"],
        code: json["code"],
        logoUrl: json["logoUrl"],
        rating: json["rating"],
        ratingCount: json["ratingCount"],
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
      );

  Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "items": List<dynamic>.from(items.map((x) => x)),
        "pickup": pickup,
        "delivery": delivery,
        "owner": owner,
        "isAvailable": isAvailable,
        "showItemPrice": showItemPrice,
        "code": code,
        "logoUrl": logoUrl,
        "rating": rating,
        "ratingCount": ratingCount,
        "verification": verification,
        "verificationMessage": verificationMessage,
      };
}

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String title;
  final double latitudeDelta;
  final double longitudeDelta;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
    required this.latitudeDelta,
    required this.longitudeDelta,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: (json["latitude"] is int)
            ? (json["latitude"] as int).toDouble()
            : json["latitude"]?.toDouble(),
        longitude: (json["longitude"] is int)
            ? (json["longitude"] as int).toDouble()
            : json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
        latitudeDelta: (json["latitudeDelta"] is int)
            ? (json["latitudeDelta"] as int).toDouble()
            : json["latitudeDelta"]?.toDouble(),
        longitudeDelta: (json["longitudeDelta"] is int)
            ? (json["longitudeDelta"] as int).toDouble()
            : json["longitudeDelta"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
      };
}

import 'dart:convert';

List<ReadyOrders> readyOrdersFromJson(String str) => List<ReadyOrders>.from(json.decode(str).map((x) => ReadyOrders.fromJson(x)));

String readyOrdersToJson(List<ReadyOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class ReadyOrders {
    final String id;
    final UserId? userId;
    final List<OrderItem> orderItems;
    final double? deliveryFee;
    final DeliveryAddress? deliveryAddress;
    final String orderStatus;
    final SupplierId? supplierId;
    final List<double>? supplierCoords;
    final List<double>? recipientCoords;
    final DateTime? orderDate; // Added field

    ReadyOrders({
        required this.id,
        this.userId,
        required this.orderItems,
        this.deliveryFee,
        this.deliveryAddress,
        required this.orderStatus,
        this.supplierId,
        this.supplierCoords,
        this.recipientCoords,
        this.orderDate, // Added field
    });

    factory ReadyOrders.fromJson(Map<String, dynamic> json) => ReadyOrders(
        id: json["_id"] ?? "",
        userId: json["userId"] != null ? UserId.fromJson(json["userId"]) : null,
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        deliveryAddress: json["deliveryAddress"] != null ? DeliveryAddress.fromJson(json["deliveryAddress"]) : null,
        orderStatus: json["orderStatus"] ?? "",
        supplierId: json["supplierId"] != null ? SupplierId.fromJson(json["supplierId"]) : null,
        supplierCoords: json["supplierCoords"] != null ? List<double>.from(json["supplierCoords"].map((x) => x?.toDouble())) : null,
        recipientCoords: json["recipientCoords"] != null ? List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())) : null,
        orderDate: json["orderDate"] != null ? DateTime.parse(json["orderDate"]) : null, // Parse date
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "deliveryFee": deliveryFee,
        "deliveryAddress": deliveryAddress?.toJson(),
        "orderStatus": orderStatus,
        "supplierId": supplierId?.toJson(),
        "supplierCoords": supplierCoords != null ? List<dynamic>.from(supplierCoords!.map((x) => x)) : null,
        "recipientCoords": recipientCoords != null ? List<dynamic>.from(recipientCoords!.map((x) => x)) : null,
        "orderDate": orderDate?.toIso8601String(), // Serialize date
    };
}

class DeliveryAddress {
    final String id;
    final String addressLine1;

    DeliveryAddress({
        required this.id,
        required this.addressLine1,
    });

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        addressLine1: json["addressLine1"] ?? "", id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "addressLine1": addressLine1,
    };
}

class OrderItem {
    final ItemId itemId;
    final int quantity;
    final double price;
    // final List<String> additives;
    // final String instructions;
    final String id;
    //final double unitPrice;

    OrderItem({
        required this.itemId,
        required this.quantity,
        required this.price,
        // required this.additives,
        // required this.instructions,
        required this.id,
       // required this.unitPrice,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: ItemId.fromJson(json["itemId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        // additives: List<String>.from(json["additives"].map((x) => x)),
        // instructions: json["instructions"] ?? "",
        id: json["_id"] ?? "",
        //unitPrice: json["unitPrice"]??0.0,
    );

    Map<String, dynamic> toJson() => {
        "itemId": itemId.toJson(),
        "quantity": quantity,
        "price": price,
        // "additives": List<dynamic>.from(additives.map((x) => x)),
        // "instructions": instructions,
        "_id": id,
       // "unitPrice":unitPrice
    };
}

class ItemId {
    final String id;
    final String title;
    final List<String> imageUrl;

    ItemId({
        required this.id,
        required this.title,
        required this.imageUrl,
    });

    factory ItemId.fromJson(Map<String, dynamic> json) => ItemId(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    };
}

class SupplierId {
    final String id;
    final String title;
    final String imageUrl;
    final String logoUrl;

    SupplierId({
        required this.id,
        required this.title,
        required this.imageUrl,
        required this.logoUrl,
    });

    factory SupplierId.fromJson(Map<String, dynamic> json) => SupplierId(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        logoUrl: json["logoUrl"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": imageUrl,
        "logoUrl": logoUrl,
    };
}

class UserId {
    final String id;
    final String phone;
    final String profile;
    final String? username;

    UserId({
        required this.id,
        required this.phone,
        required this.profile,
        required this.username,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"] ?? "",
        phone: json["phone"] ?? "",
        profile: json["profile"] ?? "",
        username: json["username"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "profile": profile,
        "username": username,
    };
}

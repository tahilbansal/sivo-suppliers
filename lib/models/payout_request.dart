// To parse this JSON data, do
//
//     final payoutRequest = payoutRequestFromJson(jsonString);

import 'dart:convert';

PayoutRequest payoutRequestFromJson(String str) => PayoutRequest.fromJson(json.decode(str));

String payoutRequestToJson(PayoutRequest data) => json.encode(data.toJson());

class PayoutRequest {
    final String supplier;
    final String amount;
    final String accountNumber;
    final String accountName;
    final String accountBank;
    final String method;

    PayoutRequest({
        required this.supplier,
        required this.amount,
        required this.accountNumber,
        required this.accountName,
        required this.accountBank,
        required this.method,
    });

    factory PayoutRequest.fromJson(Map<String, dynamic> json) => PayoutRequest(
        supplier: json["supplier"],
        amount: json["amount"],
        accountNumber: json["accountNumber"],
        accountName: json["accountName"],
        accountBank: json["accountBank"],
        method: json["method"],
    );

    Map<String, dynamic> toJson() => {
        "supplier": supplier,
        "amount": amount,
        "accountNumber": accountNumber,
        "accountName": accountName,
        "accountBank": accountBank,
        "method": method,
    };
}

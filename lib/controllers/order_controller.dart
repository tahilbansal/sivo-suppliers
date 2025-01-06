import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/entrypoint.dart';
import 'package:rivus_supplier/models/api_error.dart';
import 'package:rivus_supplier/models/environment.dart';
import 'package:rivus_supplier/models/ready_orders.dart';
import 'package:rivus_supplier/views/home/home_page.dart';
import 'package:rivus_supplier/views/order/active_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrdersController extends GetxController {
  final box = GetStorage();
  ReadyOrders? order;

  int tabIndex = 0;

  double _tripDistance = 0;

  // Getter
  double get tripDistance => _tripDistance;

  // Setter
  set setDistance(double newValue) {
    _tripDistance = newValue;
  }

  // Reactive state
  var _count = 0.obs;

  // Getter
  int get count => _count.value;

  // Setter
  set setCount(int newValue) {
    _count.value = newValue;
  }

  var _setLoading = false.obs;

  // Getter
  bool get setLoading => _setLoading.value;

  // Setter
  set setLoading(bool newValue) {
    _setLoading.value = newValue;
  }

  // Fetch a specific order by ID
  Future<void> getOrder(String orderId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/orders/$orderId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        // Successfully fetched the order
        setLoading = false;

        Map<String, dynamic> data = jsonDecode(response.body);
        order = ReadyOrders.fromJson(data);
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
          data.message,
          "Failed to fetch the order, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(
        e.toString(),
        "Failed to fetch the order, please try again",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error),
      );
    } finally {
      setLoading = false;
    }
  }

  void pickOrder(String orderId) async {
    String token = box.read('token');
    String driverId = box.read('driverId');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse(
        '${Environment.appBaseUrl}/api/orders/picked-orders/$orderId/$driverId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        Get.snackbar("Order picked successfully",
            "To view the order, go to the active tab",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(FontAwesome5Solid.shipping_fast));

        Map<String, dynamic> data = jsonDecode(response.body);
        order = ReadyOrders.fromJson(data);

        Get.off(() => const ActivePage(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
            data.message, "Failed to picking an order, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to picking an order, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void processOrder(String orderId, String status) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse(
        '${Environment.appBaseUrl}/api/orders/process/$orderId/$status');
    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        Get.off(() => MainScreen(),
            arguments: 2,
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message,
            "Failed to mark as delivered, please try again or contact support",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
        print("Status code is ${response.statusCode}");
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar(
          e.toString(), "Failed to mark order as delivered please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<bool> updateOrderItemsPrices(String orderId, List<Map<String, dynamic>> updatedOrderItems) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    var url = Uri.parse('${Environment.appBaseUrl}/api/orders/$orderId/update-prices');

    setLoading = true;

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "orderItems": updatedOrderItems,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        Get.snackbar(
          "Invoice Sent Successfully",
          "The invoice has been sent to the customer",
          colorText: kLightWhite,
          backgroundColor: kPrimary,
          icon: const Icon(Icons.check_circle),
        );
        return true;
      } else {
        // Handle errors
        var errorData = apiErrorFromJson(response.body);
        Get.snackbar(
          "Update Failed",
          errorData.message,
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error),
        );
        return false;
      }
    } catch (e) {
      // Log error and show message
      print("Error updating order items prices: $e");
      Get.snackbar(
        "Error",
        "An error occurred while updating the prices. Please try again.",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error),
      );
      return false;
    } finally {
      setLoading = false; // Reset loading state
    }
  }
}

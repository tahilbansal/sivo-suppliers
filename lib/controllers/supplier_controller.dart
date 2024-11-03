import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/models/api_error.dart';
import 'package:rivus_supplier/models/environment.dart';
import 'package:rivus_supplier/models/supplier_response.dart';
import 'package:rivus_supplier/models/status.dart';
import 'package:rivus_supplier/models/sucess_model.dart';
import 'package:rivus_supplier/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SupplierController extends GetxController {
  final box = GetStorage();
  SupplierResponse? supplier;

  RxBool _isAvailable = false.obs;

  bool get isAvailable => _isAvailable.value;

  set setAvailability(bool newValue) {
    _isAvailable.value = newValue;
  }

  RxBool _status = false.obs;

  bool get status => _status.value;

  set setStatus(bool newValue) {
    _status.value = newValue;
    refetch.value = newValue;
  }

  var refetch = false.obs;

  // Function to be called when status changes
  Function? onStatusChange;

  @override
  void onInit() {
    super.onInit();
    // Set up the listener
    ever(refetch, (_) async {
      if (refetch.isTrue && onStatusChange != null) {
        await Future.delayed(const Duration(seconds: 5));
        onStatusChange!();
      }
    });
  }

  void setOnStatusChangeCallback(Function callback) {
    onStatusChange = callback;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void supplierRegistration(String model) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/supplier');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar(data.message,
            "Thank you for registering, wait for the approval. We will notify you soon via email",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Icons.add_alert));

        Get.offAll(() => const Login(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to login, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void supplierStatus() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? supplierId = box.read('supplierId');
    if(supplierId==null){
      print("I am null...................");
    }
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/supplier/$supplierId');
    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Status data = statusFromJson(response.body);
        box.write("status", data.isAvailable);
        setStatus = data.isAvailable;
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to toggle status, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

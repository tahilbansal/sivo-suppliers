import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_suppliers/common/entities/user.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/login_response.dart';
import 'package:sivo_suppliers/controllers/notifications_controller.dart';
import 'package:sivo_suppliers/controllers/supplier_controller.dart';
import 'package:sivo_suppliers/entrypoint.dart';
import 'package:sivo_suppliers/main.dart';
import 'package:sivo_suppliers/models/api_error.dart';
import 'package:sivo_suppliers/models/environment.dart';
import 'package:sivo_suppliers/models/login_request.dart';
import 'package:sivo_suppliers/models/supplier_response.dart';
import 'package:sivo_suppliers/views/auth/supplier_registration.dart';
import 'package:sivo_suppliers/views/auth/login_page.dart';
import 'package:sivo_suppliers/views/auth/verification_page.dart';
import 'package:sivo_suppliers/views/auth/waiting_page.dart';
import 'package:sivo_suppliers/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final box = GetStorage();
  final controller = Get.put(NotificationsController());
  final supplierController = Get.put(SupplierController());
  RxBool _isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void loginFunc(String model, LoginRequest login) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);
        box.write(userId, userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("e-verification", data.verification);
        controller.updateUserToken(controller.fcmToken);

        if (data.userType == "Vendor") {
          getSupplier(data.userToken);
        } else if (data.verification == false) {
          Get.offAll(() => const VerificationPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.snackbar("Opps Error ",
              "You do not have a registered supplier, please register first",
              colorText: Colors.white,
              backgroundColor: kRed,
              icon: const Icon(Ionicons.fast_food_outline));

          defaultHome = const Login();
          Get.offAll(() => const SupplierRegistration(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
          defaultHome = const Login();
        }

        setLoading = false;

        Get.snackbar("Successfully logged in ", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        var userbase = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore(),
            )
            .where("id", isEqualTo: userId)
            .get();

        if (userbase.docs.isEmpty) {
          final data = UserData(
              id: userId,
              name: "",
              email: login.email,
              photourl: "",
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now());
          try {
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userdata, options) =>
                      userdata.toFirestore(),
                )
                .add(data);
          } catch (e) {
            print("Error adding document: $e");
          }
        } else {
          print("docs---exist");
        }
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

  void logout() {
    box.erase();
    defaultHome = const Login();
    Get.offAll(() => defaultHome,
        transition: Transition.fade, duration: const Duration(seconds: 2));
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void getSupplier(String token) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/supplier/profile');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        SupplierResponse supplier = supplierResponseFromJson(response.body);
        supplierController.supplier = supplier;
        box.write("supplierId", supplier.id);
        box.write("verification", supplier.verification);
        box.write("price_visibility", supplier.showItemPrice);
        box.write(supplier.id, json.encode(supplier));

        supplierController.supplier = getSupplierData(supplier.id)!;

        if (supplier.verification != "Verified") {
          Get.offAll(() => const WaitingPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.offAll(() => MainScreen(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        }
      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar("Opps Error ", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.offAll(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    }
  }

  SupplierResponse? getSupplierData(String supplierId) {
    String? data = box.read(supplierId);
    if (data != null) {
      return supplierResponseFromJson(data);
    }
    return null;
  }

  RxBool _payout = false.obs;

  bool get payout => _payout.value;

  set setRequest(bool newValue) {
    _payout.value = newValue;
  }
}

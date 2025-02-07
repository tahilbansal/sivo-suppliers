import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/login_controller.dart';
import 'package:sivo_suppliers/controllers/supplier_controller.dart';
import 'package:sivo_suppliers/controllers/updates_controllers/new_orders_controller.dart';
import 'package:sivo_suppliers/controllers/updates_controllers/picked_controller.dart';
import 'package:sivo_suppliers/controllers/updates_controllers/ready_for_pick_up_controller.dart';
import 'package:sivo_suppliers/views/profile/profile_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
    this.type,
    this.title,
    this.heading,
    this.onTap,
    this.onSupplierIdNull,
  });

  final bool? type;
  final String? title;
  final String? heading;
  final void Function()? onTap;
  final void Function()? onSupplierIdNull;

  Stream<Map<String, dynamic>> supplierStream(String supplierId) {
    DatabaseReference supplierRef = FirebaseDatabase.instance.ref(supplierId);

    return supplierRef.onValue.map((event) {
      final supplierData = event.snapshot.value as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(supplierData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final supplierController = Get.put(SupplierController());
    final outForDeliveryController = Get.put(ReadyForPickUpController());
    final pickedController = Get.put(PickedController());
    final newOrderController = Get.put(NewOrdersController());
    final controller = Get.put(LoginController());
    bool? status = box.read('status');
    String? id = box.read('supplierId');

    if (id == null) {
      if (onSupplierIdNull != null) {
        onSupplierIdNull!();
      }
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 0.h),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: kRed, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                "You did not set up the supplier or it is not approved yet.",
                style: TextStyle(
                  color: kRed,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    supplierController.supplier = controller.getSupplierData(id);
    supplierController.setStatus = status ?? false;

    return IgnorePointer(
      ignoring: id == null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        height: 100.h,
        color: kLightWhite,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: id != null
                          ? () {
                              Get.to(() => const ProfilePage(),
                                  transition: Transition.cupertino,
                                  duration: const Duration(milliseconds: 900));
                            }
                          : null,
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: kTertiary,
                        backgroundImage: NetworkImage(
                            supplierController.supplier == null
                                ? profile
                                : supplierController.supplier!.logoUrl),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                              text: heading != null
                                  ? heading!
                                  : supplierController.supplier == null
                                      ? ""
                                      : supplierController.supplier!.title,
                              style:
                                  appStyle(13.sp, kSecondary, FontWeight.w600)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: ReusableText(
                                text: title != null
                                    ? title!
                                    : supplierController.supplier == null
                                        ? ""
                                        : supplierController
                                            .supplier!.coords.address,
                                style:
                                    appStyle(11.sp, kGray, FontWeight.normal)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: id != null ? onTap : null,
                  child: Obx(
                    () => SvgPicture.asset(
                      supplierController.status
                          ? 'assets/icons/open_sign.svg'
                          : 'assets/icons/closed_sign.svg',
                      height: 35.h,
                      width: 35.w,
                    ),
                  ),
                ),
              ],
            ),
            type != true
                ? Positioned(
                    top: 45.h,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        AntDesign.closecircle,
                        color: kRed,
                        size: 18,
                      ),
                    ))
                : const SizedBox.shrink(),
            if (id != null)
              StreamBuilder<Map<String, dynamic>>(
                  stream: supplierStream(id),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(); // Show loading indicator while waiting for data
                    }
                    if (snapshot.hasError) {
                      return const SizedBox(); // Handle errors from the stream
                    }

                    // The stream has data, so display the appropriate UI
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    String lastOrder = 'updated';
                    String status = "none";

                    Map<String, dynamic> supplierData = snapshot.data!;

                    if (lastOrder != supplierData['order_id'] &&
                        status != supplierData['status']) {
                      lastOrder = supplierData['order_id'];
                      status = supplierData['status'];

                      if (supplierData['status'] == "Out_for_Delivery") {
                        outForDeliveryController.refetch.value = true;
                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            outForDeliveryController.refetch.value = false;
                          },
                        );
                      } else if (supplierData['status'] == "Delivered") {
                        pickedController.refetch.value = true;
                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            pickedController.refetch.value = false;
                          },
                        );
                      } else if (supplierData['status'] == "Placed") {
                        newOrderController.refetch.value = true;
                        Future.delayed(
                          const Duration(seconds: 5),
                          () {
                            newOrderController.refetch.value = false;
                          },
                        );
                      }
                    }

                    return const SizedBox.shrink();
                  })
          ],
        ),
      ),
    );
  }

  String profile =
      'https://d326fntlu7tb1e.cloudfront.net/uploads/51530ae8-32b8-4a04-89b3-17f40a2f4cc1-avatar.png';
}

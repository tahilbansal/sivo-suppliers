import 'package:flutter/material.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/supplier_controller.dart';
import 'package:get/get.dart';

class AvailableSwitch extends StatelessWidget {
  const AvailableSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final supplierController = Get.put(SupplierController());
    return SizedBox(
        height: 30,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: 'Food Availability',
              style: appStyle(
                14,
                kGray,
                FontWeight.w600,
              ),
            ),
            Obx(
              () => Switch(
                value: supplierController.isAvailable,
                onChanged: (value) {
                  supplierController.setAvailability =
                      !supplierController.isAvailable;
                },
                activeColor: kSecondary,
              ),
            )
          ],
        ));
  }
}

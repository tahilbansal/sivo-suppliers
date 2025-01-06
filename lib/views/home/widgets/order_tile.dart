// ignore_for_file: unrelated_type_equality_checks, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_supplier/common/app_style.dart';
import 'package:rivus_supplier/common/reusable_text.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/location_controller.dart';
import 'package:rivus_supplier/controllers/order_controller.dart';
import 'package:rivus_supplier/entrypoint.dart';
import 'package:rivus_supplier/models/distance_time.dart';
import 'package:rivus_supplier/models/ready_orders.dart';
import 'package:rivus_supplier/services/distance.dart';
import 'package:rivus_supplier/views/order/active_page.dart';
import 'package:get/get.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.active,
  });

  final ReadyOrders order;
  final String? active;

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());
    final controller = Get.put(OrdersController());
    DistanceTime distance = Distance().calculateDistanceTimePrice(
        location.currentLocation.latitude,
        location.currentLocation.longitude,
        order.supplierCoords![0],
        order.supplierCoords![1],
        5,
        5);

    DistanceTime distance2 = Distance().calculateDistanceTimePrice(
        order.supplierCoords![0],
        order.supplierCoords![1],
        order.recipientCoords![0],
        order.recipientCoords![1],
        15,
        5);

    double distanceToSupplier = distance.distance + 1;
    double distanceFromSupplierToClient = distance2.distance + 1;

    return GestureDetector(
      onTap: () {
        controller.order = order;
        controller.setDistance =
            distanceToSupplier + distanceFromSupplierToClient;
        Get.to(() => const ActivePage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500));
        activeOrder = const ActivePage();
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 90.h,
            width: width,
            decoration: BoxDecoration(
                color: controller.order == null
                    ? kOffWhite
                    : controller.order!.id == order.id
                        ? kSecondaryLight
                        : kOffWhite,
                borderRadius: const BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                        height: 70.h,
                        width: 60.h,
                        child: Image.network(
                          order.userId!.profile,
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      ReusableText(
                          text: order.userId?.username ?? 'Unknown User',
                          style: appStyle(
                              kFontSizeBodySmall, kGray, FontWeight.w500)),
                      OrderRowText(text: "🍲 Order :  ${order.id.substring(0, 6)}"),
                      Text(
                          "🏠 ${order.deliveryAddress!.addressLine1.substring(0,40)}",
                          style: appStyle(kFontSizeSubtext, kGray, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.symmetric(horizontal: 3.w),
                      //       margin: EdgeInsets.only(right: 2.w),
                      //       width: 90.w,
                      //       decoration: BoxDecoration(
                      //           color: active == 'ready'
                      //               ? kSecondary
                      //               : const Color(0xFFFFFFFF),
                      //           borderRadius: BorderRadius.circular(10)),
                      //       child: ReusableText(
                      //           text:
                      //               "To 📌 ${distanceToSupplier.toStringAsFixed(2)} km",
                      //           style: appStyle(
                      //               kFontSizeSubtext,
                      //               active == 'ready'
                      //                   ? const Color(0xFFFFFFFF)
                      //                   : kGray,
                      //               FontWeight.w400)),
                      //     ),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(horizontal: 3.w),
                      //       margin: EdgeInsets.only(right: 2.w),
                      //       decoration: BoxDecoration(
                      //           color: active == 'active'
                      //               ? kSecondary
                      //               : const Color(0xFFFFFFFF),
                      //           borderRadius: BorderRadius.circular(10)),
                      //       child: ReusableText(
                      //           text:
                      //               "From 📌 To 🏠 ${distanceFromSupplierToClient.toStringAsFixed(2)} km",
                      //           style: appStyle(
                      //               9,
                      //               active == 'active'
                      //                   ? const Color(0xFFFFFFFF)
                      //                   : kGray,
                      //               FontWeight.w400)),
                      //     ),
                      //     // Container(
                      //     //   padding: EdgeInsets.symmetric(horizontal: 3.w),
                      //     //   margin: EdgeInsets.only(right: 2.w),
                      //     //   decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(10)),
                      //     //   child: ReusableText(
                      //     //       text: "\$ ${order.deliveryFee}",
                      //     //       style: appStyle(9, kGray, FontWeight.w400)),
                      //     // ),
                      //   ],
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 10.h,
              top: 6.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: SizedBox(
                  width: 19.h,
                  height: 19.h,
                  child: Image.network(order.supplierId!.logoUrl,
                      fit: BoxFit.cover),
                ),
              ))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderRowText extends StatelessWidget {
  OrderRowText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width / 1.6,
        child: ReusableText(
            text: text,
            style: appStyle(kFontSizeSubtext, kGray, FontWeight.w400)));
  }
}

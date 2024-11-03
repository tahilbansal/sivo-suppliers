// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_supplier/common/app_style.dart';
import 'package:rivus_supplier/common/common_appbar.dart';
import 'package:rivus_supplier/common/custom_btn.dart';
import 'package:rivus_supplier/common/divida.dart';
import 'package:rivus_supplier/common/reusable_text.dart';
import 'package:rivus_supplier/common/row_text.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/order_controller.dart';
import 'package:rivus_supplier/hooks/fetchOrderById.dart';
import 'package:rivus_supplier/models/order_details.dart';
import 'package:rivus_supplier/views/home/widgets/back_ground_container.dart';
import 'package:rivus_supplier/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  String image = "https://d326fntlu7tb1e.cloudfront.net/uploads/5c2a9ca8-eb07-400b-b8a6-2acfab2a9ee2-image001.webp";
  final orderController = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    final String? orderId = Get.arguments;
    if (orderId != null) {
      // Fetch the order details using the orderId
      orderController.getOrder(orderId);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CommonAppBar(
          titleText: "Order Details",
        ),
        body: Obx(() {
          if (orderController.setLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // If order is null, display a message (optional)
          if (orderController.order == null) {
            return const Center(child: Text("Order not found"));
          }
        return BackGroundContainer(
          child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: orderController.order == null
              ? Center(child: CircularProgressIndicator())
          : ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: 10.h,
              ),
              OrderTile(
                order: orderController.order!,
                active: "",
              ),
              Container(
                width: width,
                height: hieght / 3,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: kOffWhite,
                      borderRadius: BorderRadius.circular(12.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderController.order!.orderItems.length,
                          itemBuilder: (context, index) {
                            final orderItem = orderController.order!.orderItems[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ReusableText(
                                    text: orderItem.itemId.title,
                                    style: appStyle(14, kGray, FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 8.w),
                                      ReusableText(
                                        text: "Qty: ${orderItem.quantity}",
                                        style: appStyle(14, kGray, FontWeight.w500),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 14,
                                      //   backgroundColor: kTertiary,
                                      //   backgroundImage: NetworkImage(orderItem.itemId.imageUrl[0]),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Divida(),
                      RowText(
                          first: "Recipient",
                          second:
                              orderController.order!.deliveryAddress!.addressLine1),
                      SizedBox(
                        height: 5.h,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: orderController.order!.userId==null?Text("No user found"): RowText(
                            first: "Phone ",
                            second: orderController.order!.userId!.phone),
                      ),
                      //const Divida(),
                      // ReusableText(
                      //     text: "Additives ",
                      //     style: appStyle(12, kGray, FontWeight.w500)),
                      // SizedBox(
                      //   height: 5.h,
                      // ),
                      // SizedBox(
                      //   height: 15.h,
                      //   child: ListView.builder(
                      //       itemCount: orderController
                      //           .order!.orderItems[0].additives.length,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (context, i) {
                      //         final addittive = orderController
                      //             .order!.orderItems[0].additives[i];
                      //         return Container(
                      //           margin: EdgeInsets.only(right: 5.h),
                      //           decoration: BoxDecoration(
                      //               color: kPrimary,
                      //               borderRadius: BorderRadius.all(
                      //                   Radius.circular(15.r))),
                      //           child: Center(
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 4.0),
                      //               child: ReusableText(
                      //                   text: addittive,
                      //                   style: appStyle(
                      //                       8, kLightWhite, FontWeight.w400)),
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      // ),
                      const Divida(),
                      SizedBox(
                        height: 5.h,
                      ),
                      orderController.order!.orderStatus == "Placed"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                    onTap: () {
                                      orderController.processOrder(
                                          orderController.order!.id,
                                          "Preparing");
                                      orderController.tabIndex = 1;
                                    },
                                    btnWidth: width / 2.5,
                                    radius: 9.r,
                                    color: kPrimary,
                                    text: "Accept"),
                                CustomButton(
                                    onTap: () {
                                      orderController.processOrder(
                                          orderController.order!.id,
                                          "Cancelled");
                                          orderController.tabIndex = 6;
                                    },
                                    color: kRed,
                                    radius: 9.r,
                                    btnWidth: width / 2.5,
                                    text: "Decline")
                              ],
                            )
                          : const SizedBox.shrink(),

                          orderController.order!.orderStatus == "Preparing"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                    onTap: () {
                                      orderController.processOrder(
                                          orderController.order!.id,
                                          "Ready");
                                      orderController.tabIndex = 2;
                                    },
                                    btnWidth: width / 2.5,
                                    radius: 9.r,
                                    color: kPrimary,
                                    text: "Push to Couriers"),
                                CustomButton(
                                    onTap: () {
                                      orderController.processOrder(
                                          orderController.order!.id,
                                          "Manual");
                                          orderController.tabIndex = 4;
                                    },
                                    color: kSecondary,
                                    radius: 9.r,
                                    btnWidth: width / 2.5,
                                    text: "Self Delivery")
                              ],
                            )
                          : const SizedBox.shrink(),

                          orderController.order!.orderStatus == "Manual"
                          ? CustomButton(
                              onTap: () {
                                orderController.processOrder(
                                    orderController.order!.id,
                                    "Delivered");
                                    orderController.tabIndex = 5;
                              },
                              color: kSecondary,
                              radius: 9.r,
                              btnWidth: width,
                              text: "Mark As Delivered")
                          : const SizedBox.shrink(),

                          orderController.order!.orderStatus == "Ready"
                          ? CustomButton(
                              onTap: () {
                                orderController.processOrder(
                                    orderController.order!.id,
                                    "Manual");
                                    orderController.tabIndex = 5;
                              },
                              color: kSecondary,
                              radius: 9.r,
                              btnWidth: width,
                              text: "Self Delivery")
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        )
        );
    }
        )
    );
  }
}

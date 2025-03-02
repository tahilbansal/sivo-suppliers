// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/common_appbar.dart';
import 'package:sivo_suppliers/common/custom_btn.dart';
import 'package:sivo_suppliers/common/divida.dart';
import 'package:sivo_suppliers/common/reusable_text.dart';
import 'package:sivo_suppliers/common/row_text.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/order_controller.dart';
import 'package:sivo_suppliers/views/home/widgets/back_ground_container.dart';
import 'package:sivo_suppliers/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  String image =
      "https://d326fntlu7tb1e.cloudfront.net/uploads/5c2a9ca8-eb07-400b-b8a6-2acfab2a9ee2-image001.webp";
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
            margin: EdgeInsets.symmetric(horizontal: 10.w),
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
                        height: hieght / 1.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r)),
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
                                  itemCount:
                                      orderController.order!.orderItems.length,
                                  itemBuilder: (context, index) {
                                    final orderItem = orderController
                                        .order!.orderItems[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Header row
                                          if (index == 0) ...[
                                            Table(
                                              //border: TableBorder.all(color: kGray, width: 0.5), // Optional border
                                              columnWidths: {
                                                0: FlexColumnWidth(3), // Adjust column width
                                                1: FlexColumnWidth(1),
                                                2: FlexColumnWidth(1),
                                                3: FlexColumnWidth(2),
                                              },
                                              children: [
                                                TableRow(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: ReusableText(
                                                        text: 'Title',
                                                        style: appStyle(14, kGray, FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: ReusableText(
                                                        text: 'Qty',
                                                        style: appStyle(14, kGray, FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: ReusableText(
                                                        text: 'Unit',
                                                        style: appStyle(14, kGray, FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(2),
                                                      child: ReusableText(
                                                        text: 'Amount',
                                                        style: appStyle(14, kGray, FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.h),
                                          ],
                                          // Values row
                                          // Values row for each item
                                          Table(
                                            //border: TableBorder.all(color: kGray, width: 0.5), // Optional border for items
                                            columnWidths: {
                                              0: FlexColumnWidth(3), // Adjust column width
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(1),
                                              3: FlexColumnWidth(2),
                                            },
                                            children: [
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(2),
                                                    child: Text(
                                                      orderItem.itemId.title,
                                                      style: appStyle(14, kGray, FontWeight.w500),
                                                      maxLines: 2, // Allows wrapping if title is long
                                                      overflow: TextOverflow.ellipsis, // Adds ellipsis if text overflows
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(2),
                                                    child: ReusableText(
                                                      text: orderItem.quantity.toString(),
                                                      style: appStyle(14, kGray, FontWeight.w500),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(2),
                                                    child: ReusableText(
                                                      text: orderItem.itemId.unit ?? "N/A",
                                                      style: appStyle(14, kGray, FontWeight.w500),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(2),
                                                    child: ReusableText(
                                                      text: orderItem.price.toStringAsFixed(2),
                                                      style: appStyle(14, kGray, FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h), // Space between items
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divida(),
                              RowText(
                                  first: "Recipient",
                                  second: orderController
                                      .order!.deliveryAddress!.addressLine1),
                              SizedBox(
                                height: 5.h,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: orderController.order!.userId == null
                                    ? Text("No user found")
                                    : RowText(
                                        first: "Phone ",
                                        second: orderController
                                            .order!.userId!.phone),
                              ),
                              const Divida(),
                              SizedBox(
                                height: 5.h,
                              ),
                              orderController.order!.orderStatus == "Placed"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              orderController.tabIndex = 3;
                                            },
                                            color: kRed,
                                            radius: 9.r,
                                            btnWidth: width / 2.5,
                                            text: "Decline")
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              // orderController.order!.orderStatus == "Preparing"
                              //     ? Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           CustomButton(
                              //               onTap: () {
                              //                 orderController.processOrder(
                              //                     orderController.order!.id,
                              //                     "Ready");
                              //                 orderController.tabIndex = 2;
                              //               },
                              //               btnWidth: width / 2.5,
                              //               radius: 9.r,
                              //               color: kPrimary,
                              //               text: "Push to Couriers"),
                              //           CustomButton(
                              //               onTap: () {
                              //                 orderController.processOrder(
                              //                     orderController.order!.id,
                              //                     "Manual");
                              //                 orderController.tabIndex = 4;
                              //               },
                              //               color: kSecondary,
                              //               radius: 9.r,
                              //               btnWidth: width / 2.5,
                              //               text: "Self Delivery")
                              //         ],
                              //       )
                              //     : const SizedBox.shrink(),
                              orderController.order!.orderStatus == "Preparing"
                                  ? CustomButton(
                                      onTap: () {
                                        orderController.processOrder(
                                            orderController.order!.id,
                                            "Delivered");
                                        orderController.tabIndex = 2;
                                      },
                                      color: kSecondary,
                                      radius: 9.r,
                                      btnWidth: width,
                                      text: "Mark As Delivered")
                                  : const SizedBox.shrink(),
                              // orderController.order!.orderStatus == "Ready"
                              //     ? CustomButton(
                              //         onTap: () {
                              //           orderController.processOrder(
                              //               orderController.order!.id,
                              //               "Manual");
                              //           orderController.tabIndex = 5;
                              //         },
                              //         color: kSecondary,
                              //         radius: 9.r,
                              //         btnWidth: width,
                              //         text: "Self Delivery")
                              //     : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
          ));
        }));
  }
}

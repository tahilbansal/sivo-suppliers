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

class SendInvoicePage extends StatefulWidget {
  const SendInvoicePage({super.key});

  @override
  State<SendInvoicePage> createState() => _SendInvoicePageState();
}

class _SendInvoicePageState extends State<SendInvoicePage> {
  final orderController = Get.put(OrdersController());
  final List<TextEditingController> priceControllers = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    final String? orderId = Get.arguments;
    if (orderId != null) {
      orderController.getOrder(orderId);
    }
  }

  void calculateTotalPrice() {
    setState(() {
      totalPrice = priceControllers.fold(0.0, (sum, controller) {
        final price = double.tryParse(controller.text) ?? 0.0;
        return sum + price;
      });
    });
  }

  @override
  void dispose() {
    for (var controller in priceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(titleText: "Send Invoice"),
      body: Obx(() {
        if (orderController.setLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.order == null) {
          return const Center(child: Text("Order not found"));
        }

        final orderItems = orderController.order!.orderItems;

        // Initialize price controllers
        if (priceControllers.isEmpty && orderItems.isNotEmpty) {
          for (var _ in orderItems) {
            priceControllers.add(TextEditingController());
          }
        }

        return BackGroundContainer(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            child: ListView(
              children: [
                SizedBox(height: 10.h),
                OrderTile(order: orderController.order!, active: ""),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: kOffWhite,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) {
                          final orderItem = orderItems[index];
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
                                    ReusableText(
                                      text: "Qty: ${orderItem.quantity}",
                                      style: appStyle(14, kGray, FontWeight.w500),
                                    ),
                                    SizedBox(width: 8.w),
                                    SizedBox(
                                      width: 80.w,
                                      child: TextField(
                                        controller: priceControllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "Price",
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) => calculateTotalPrice(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divida(),
                      RowText(first: "Recipient", second: orderController.order!.deliveryAddress!.addressLine1),
                      SizedBox(height: 5.h),
                      RowText(first: "Phone", second: orderController.order!.userId!.phone),
                      const Divida(),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price", style: appStyle(16, kGray, FontWeight.bold)),
                          Text("₹${totalPrice.toStringAsFixed(2)}", style: appStyle(16, kGray, FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

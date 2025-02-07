import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/common/app_style.dart';
import 'package:sivo_suppliers/common/common_appbar.dart';
import 'package:sivo_suppliers/common/custom_btn.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/order_controller.dart';
import 'package:get/get.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final orderController = Get.put(OrdersController());
  List<TextEditingController> priceControllers = [];
  double totalPrice = 0.0;
  String? orderIdInvoice;

  @override
  void initState() {
    super.initState();
    loadOrderData();
  }

  void loadOrderData() async {
    final String? orderId = Get.arguments;
    orderIdInvoice = orderId;
    if (orderId != null) {
      await orderController.getOrder(orderId);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderItems = orderController.order?.orderItems ?? [];
      if (orderItems.isNotEmpty) {
        for (var i = 0; i < orderItems.length; i++) {
          priceControllers.add(TextEditingController());
          final price = orderItems[i].price;
          priceControllers[i].text = (price != null && price != 0.0) ? price.toString() : '';
        }
        calculateTotalPrice();
      }
    });
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
      appBar: CommonAppBar(titleText: "Invoice Details"),
      body: Obx(() {
        if (orderController.setLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orderController.order == null) {
          return const Center(child: Text("Order not found"));
        }

        final orderItems = orderController.order!.orderItems;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: kOffWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3), // Title column is wider
                              1: FlexColumnWidth(1), // Qty column
                              2: FlexColumnWidth(1), // Qty column
                              3: FlexColumnWidth(2), // Price column
                            },
                            border: TableBorder.all(color: Colors.grey.shade300),
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      "Title",
                                      style: appStyle(14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      "Qty",
                                      style: appStyle(14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      "Unit",
                                      style: appStyle(14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      "Price",
                                      style: appStyle(14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              ...orderItems.map((orderItem) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Text(
                                        orderItem.itemId.title,
                                        style: appStyle(14, kGray, FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Text(
                                        orderItem.quantity.toString(),
                                        style: appStyle(14, kGray, FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Text(
                                        orderItem.itemId.unit.toString(),
                                        style: appStyle(14, kGray, FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Text(
                                        "₹${orderItem.price?.toStringAsFixed(2) ?? 'N/A'}",
                                        style: appStyle(14, kGray, FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Total Price and Button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price", style: appStyle(16, Colors.black, FontWeight.bold)),
                          Text("₹${totalPrice.toStringAsFixed(2)}", style: appStyle(17, Colors.black, FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // CustomButton(
                    //   text: "Edit Invoice",
                    //   onTap: () async {
                    //     // Handle button action
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

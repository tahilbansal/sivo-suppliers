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
import 'package:sivo_suppliers/views/message/chat/controller.dart';

class SendInvoicePage extends StatefulWidget {
  const SendInvoicePage({super.key});

  @override
  State<SendInvoicePage> createState() => _SendInvoicePageState();
}

class _SendInvoicePageState extends State<SendInvoicePage> {
  final orderController = Get.put(OrdersController());
  List<TextEditingController> priceControllers = [];
  final chatController = Get.put(ChatController());
  double totalPrice = 0.0;
  List<int> invalidPriceIndices = [];
  String? orderIdInvoice;

  bool isInvoiceSent = false;

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

    // Delayed initialization to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderItems = orderController.order?.orderItems ?? [];
      if (orderItems.isNotEmpty) {
        for (var i = 0; i < orderItems.length; i++) {
          priceControllers.add(TextEditingController());
          final price = orderItems[i].price;
          priceControllers[i].text =
          (price != null && price != 0.0) ? price.toString() : '';
        }

        // Calculate initial total price
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

  void validatePrices() {
    setState(() {
      invalidPriceIndices.clear();
      for (var i = 0; i < priceControllers.length; i++) {
        final priceText = priceControllers[i].text;
        if (priceText.isEmpty || double.tryParse(priceText) == null) {
          invalidPriceIndices.add(i);
        }
      }
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

        return BackGroundContainer(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              children: [
                // The scrollable content goes inside the Expanded widget
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(height: 10.h),
                      OrderTile(order: orderController.order!, active: ""),
                      DataTable(
                        showBottomBorder: false,
                        headingRowColor:
                        MaterialStateProperty.all(Colors.grey.shade200),
                        border: TableBorder.all(
                          color: Colors.transparent, //
                          width: 0,
                        ),
                        columnSpacing: 10.w,
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: 180.w, // Set a custom width for the Title column header
                              child: Text(
                                'Title',
                                style: appStyle(14, Colors.black, FontWeight.bold),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 30.w, // Set a narrower width for Qty column header
                              child: Text(
                                'Qty',
                                style: appStyle(14, Colors.black, FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 35.w, // Set a narrower width for Qty column header
                              child: Text(
                                'Unit',
                                style: appStyle(14, Colors.black, FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: 110.w, // Set a narrower width for Amount column header
                              child: Text(
                                'Amount',
                                style: appStyle(14, Colors.black, FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(orderItems.length, (index) {
                          final orderItem = orderItems[index];
                          final isInvalid = invalidPriceIndices.contains(index);
                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                              if (index % 2 == 0) {
                                return Colors.grey.shade100; // Alternate row color
                              }
                              return null; // Default color
                            }),
                            cells: [
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Text(orderItem.itemId.title, style: appStyle(14, Colors.black, FontWeight.w500)),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Text(orderItem.quantity.toString(), style: appStyle(14, Colors.black, FontWeight.w500)),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Text(orderItem.itemId.unit.toString(), style: appStyle(14, Colors.black, FontWeight.w500)),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 110.w,
                                  child: TextField(
                                    controller: priceControllers[index],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: isInvalid ? Colors.red : Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: isInvalid ? Colors.red : Colors.blue,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    onChanged: (value) => calculateTotalPrice(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Price", style: appStyle(16, Colors.black, FontWeight.bold)),
                      Text("₹${totalPrice.toStringAsFixed(2)}", style: appStyle(16, Colors.black, FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  // Adjust the space from bottom
                  child: CustomButton(
                    text: "Send Invoice",
                    onTap: () async {
                      validatePrices();

                      if (invalidPriceIndices.isNotEmpty) {
                        // If there are invalid prices, stop further execution
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                              Text("Please enter prices for all items")),
                        );
                        return;
                      }
                      // Map updated prices to their respective order items
                      final orderItems = orderController.order!.orderItems;
                      final updatedOrderItems =
                      List.generate(orderItems.length, (index) {
                        return {
                          "itemId": orderItems[index].itemId.id,
                          "price": double.parse(priceControllers[index].text),
                        };
                      });

                      // Call backend API to update prices
                      try {
                        final isUpdated =
                        await orderController.updateOrderItemsPrices(
                            orderIdInvoice!, updatedOrderItems);
                        if (isUpdated) {
                          setState(() {
                            isInvoiceSent = true;
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                        return;
                      }

                      // send the invoice message
                      chatController.sendInvoiceMessage(
                          "This is your invoice. Total is ${totalPrice.toStringAsFixed(2)} ",
                          orderIdInvoice!);

                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    }, // Call the sendInvoice function
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rivus_supplier/common/app_style.dart';
import 'package:rivus_supplier/common/common_appbar.dart';
import 'package:rivus_supplier/common/reusable_text.dart';
import 'package:rivus_supplier/common/statistics.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/login_controller.dart';
import 'package:rivus_supplier/controllers/updates_controllers/new_orders_controller.dart';
import 'package:rivus_supplier/hooks/fetchSupplierOrders.dart';
import 'package:rivus_supplier/hooks/fetch_supplier.dart';
import 'package:rivus_supplier/models/ready_orders.dart';
import 'package:rivus_supplier/models/supplier_response.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesData extends HookWidget {
  SalesData({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final logincontroller = Get.put(LoginController());
    final controller = Get.put(NewOrdersController());
    final hookResult = useFetchPicked("delivered");
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    String id = box.read('supplierId');
    final refetch = hookResult.refetch;
    final supplierData = fetchSupplier(id);
    SupplierResponse? supplier = logincontroller.getSupplierData(id);

    // State to track selected chart type
    final selectedChartType = useState<String>("Daily");

    if (isLoading) {
      return Scaffold(
        appBar: CommonAppBar(titleText: "Sales data"),
        body: const Center(child: CircularProgressIndicator(color: kPrimary,)),
      );
    }
    if(orders!.isEmpty){
      return Scaffold(
        appBar: CommonAppBar(titleText: "You don't have sales"),
        body: const Center(child: CircularProgressIndicator(color: kPrimary,)),
      );
    }

    List<DailySalesData> data;
    if (selectedChartType.value == "Daily") {
      data = prepareDailyData(orders!);
    } else if (selectedChartType.value == "Monthly") {
      data = prepareMonthlyData(orders!);
    } else {
      data = prepareYearlyData(orders!);
    }

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: CommonAppBar(
        titleText: "Sales data",
        appBarActions: [
          DropdownButton<String>(
            dropdownColor: kSecondary,
            value: selectedChartType.value,
            items: <String>['Daily', 'Monthly', 'Yearly']
                .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: kOffWhite),
              ),
            ))
                .toList(),
            onChanged: (String? newValue) {
              selectedChartType.value = newValue!;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: supplier!.title,
                      style: appStyle(
                          kFontSizeBodyLarge, kGray, FontWeight.w600)),
                  CircleAvatar(
                    radius: 15.r,
                    backgroundColor: kGray,
                    backgroundImage: NetworkImage(supplier.logoUrl),
                  ),
                ]),
          ),
          const Divider(),
          // Add the statistics widget to SalesPage
          Statistics(
            ordersTotal: supplierData.ordersTotal,
            cancelledOrders: supplierData.cancelledOrders,
            processingOrders: supplierData.processingOrders,
            revenueTotal: supplierData.revenueTotal,
          ),
          const Divider(),
          SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(
                text: selectedChartType.value == "Daily"
                    ? "---Timeline"
                    : selectedChartType.value == "Monthly"
                    ? "---Months"
                    : "---Years",
              ),
              dateFormat: selectedChartType.value == "Daily"
                  ? DateFormat('yyyy-MM-dd')
                  : selectedChartType.value == "Monthly"
                  ? DateFormat('yyyy-MM')
                  : DateFormat('yyyy'),
              // Change format based on selection
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              intervalType: selectedChartType.value == "Daily"
                  ? DateTimeIntervalType.days
                  : selectedChartType.value == "Monthly"
                  ? DateTimeIntervalType.months
                  : DateTimeIntervalType.years,
              // Change interval type based on selection
              interval: 1, // Set interval to 1 day, month, or year
            ),
            title: ChartTitle(
                text: selectedChartType.value == "Daily"
                    ? 'Daily Sales Analysis'
                    : selectedChartType.value == "Monthly"
                    ? 'Monthly Sales Analysis'
                    : 'Yearly Sales Analysis'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<DailySalesData, DateTime>>[
              LineSeries<DailySalesData, DateTime>(
                dataSource: data,
                xValueMapper: (DailySalesData sales, _) => sales.date,
                yValueMapper: (DailySalesData sales, _) => sales.sales,
                name: 'Sales',
                xAxisName: "Time",
                yAxisName: "Amount",
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailySalesData {
  DailySalesData(this.date, this.sales);

  final DateTime date;
  final double sales;
}

List<DailySalesData> prepareDailyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(
          order.orderDate!.year, order.orderDate!.month, order.orderDate!.day);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareMonthlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year, order.orderDate!.month);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareYearlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

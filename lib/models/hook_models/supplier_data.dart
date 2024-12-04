import 'package:rivus_supplier/models/api_error.dart';
import 'package:rivus_supplier/models/supplier_data.dart';

class FetchSupplierData {
  final Data? supplier;
  final int ordersTotal;
  final int cancelledOrders;
  final double revenueTotal;
  final int processingOrders;
  final String supplierToken;
  final ApiError? error;
  final bool isLoading;
  final List<LatestPayout> payout;
  final Function? refetch;

  FetchSupplierData(
      {required this.supplier,
      required this.ordersTotal,
      required this.cancelledOrders,
      required this.revenueTotal,
      required this.processingOrders,
      required this.supplierToken,
      required this.error,
      required this.payout,
      required this.isLoading,
      required this.refetch});
}

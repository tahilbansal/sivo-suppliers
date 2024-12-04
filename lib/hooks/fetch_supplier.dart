import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/models/api_error.dart';
import 'package:rivus_supplier/models/environment.dart';
import 'package:rivus_supplier/models/hook_models/supplier_data.dart';
import 'package:rivus_supplier/models/supplier_data.dart';
import 'package:http/http.dart' as http;

FetchSupplierData fetchSupplier(
  String id,
) {
  final supplier = useState<Data?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<ApiError?>(null);
  final ordersTotal = useState<int>(0);
  final cancelledOrders = useState<int>(0);
  final payout = useState<List<LatestPayout>>([]);
  final revenueTotal = useState<double>(0);
  final processingOrders = useState<int>(0);
  final supplierToken = useState<String>('');
  final appiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url =
          Uri.parse('${Environment.appBaseUrl}/api/supplier/statistics/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Statistics data = statisticsFromJson(response.body);
        supplier.value = data.data;
        ordersTotal.value = data.ordersTotal;
        cancelledOrders.value = data.cancelledOrders;
        revenueTotal.value = data.revenueTotal.toDouble();
        processingOrders.value = data.processingOrders;
        payout.value = data.latestPayout;
      } else {
        appiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchSupplierData(
    supplier: supplier.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    ordersTotal: ordersTotal.value,
    cancelledOrders: cancelledOrders.value,
    revenueTotal: revenueTotal.value,
    processingOrders: processingOrders.value,
    supplierToken: supplierToken.value,
    payout: payout.value,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/models/api_error.dart';
import 'package:rivus_supplier/models/environment.dart';
import 'package:rivus_supplier/models/hook_models/hook_result.dart';
import 'package:rivus_supplier/models/items.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;


// Custom Hook
FetchHook useFetchFood() {
  final box = GetStorage();
  final items = useState<List<Item>?>([]);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    String supplierId = box.read('supplierId');

    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse('${Environment.appBaseUrl}/api/items/supplier-items/$supplierId'));

      if (response.statusCode == 200) {
        items.value = itemFromJson(response.body);
      } else {
        var data = apiErrorFromJson(response.body);
        error.value = Exception(data.message);
        Get.snackbar(data.message, "Failed to get data, please try again",
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.fastfood_outlined));
      }
    } catch (e) {
      error.value = Exception('An error occurred: ${e.toString()}');
      Get.snackbar(e.toString(), "Failed to get data, please try again",
          snackPosition: SnackPosition.BOTTOM, icon: const Icon(Icons.error));
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: items.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

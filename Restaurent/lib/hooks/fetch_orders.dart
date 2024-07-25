

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/models/api_error.dart';
import 'package:restaurent/models/client_orders.dart';
import 'package:restaurent/models/hook_models/hook_result.dart';

FetchHook useFetchOrders(String orderStatus, String paymentStatus) {
  final box = GetStorage();
  final orders = useState<List<ClientOrders>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final appiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read("token");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    isLoading.value = true;

    try {
      Uri url = Uri.parse(
          '$appBaseUrl/api/orders?orderStatus=$orderStatus&paymentStatus=$paymentStatus');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        orders.value = clientOrdersFromJson(response.body);
      } else {
        appiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      error.value = e as Exception;
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

  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

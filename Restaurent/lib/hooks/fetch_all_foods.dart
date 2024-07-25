import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/constants/uidata.dart';
import 'package:restaurent/models/api_error.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchAllFoods(String code) {
  final foods = useState<List<FoodsModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/foods/byCode/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foods.value = foodsModelFromJson(response.body);
      } else {
        apiError.value = apiErrorFromJson(response.body);
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
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

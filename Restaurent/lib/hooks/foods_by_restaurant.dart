import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/category_controller.dart';
import 'package:restaurent/models/api_error.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/models/hook_models/foods_hook.dart';
import 'package:http/http.dart' as http;

FetchFoods useFetchRestaurantFoods(String id) {
  final controller=Get.put(CategoryController());
  final foods = useState<List<FoodsModel>>([]);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/foods/restaurant-foods/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foods.value = foodsModelFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    Future.delayed(const Duration(seconds: 3));
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchFoods(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

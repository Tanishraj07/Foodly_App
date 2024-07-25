import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/models/api_error.dart';
import 'package:restaurent/models/login_response.dart';
import 'package:restaurent/models/success_model.dart';

class RegistrationController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  void registrationFunction(String data) async {
    setLoading = true;

    Uri url = Uri.parse('$appBaseUrl/register');

    Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(url, headers: headers, body: data);


      if (response.statusCode == 201) {
        var data = successModelFromJson(response.body);
        setLoading = false;

        Get.back();

        Get.snackbar("You are successfully registered ", data.message,
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar("Failed to register ", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

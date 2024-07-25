import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/models/api_error.dart';
import 'package:restaurent/models/login_response.dart';
import 'package:restaurent/views/entrypoint.dart';

class VerificationController extends GetxController {
  final box = GetStorage();

  String _code = "";

  String get code => _code;

  set setCode(String value) {
    _code = value;
  }

  //loading
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  //login function

  void verificationFunction() async {
    setLoading = true;
    String accessToken = box.read("token");

    Uri url = Uri.parse('$appBaseUrl/api/users/verify/$code');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.get(url, headers: headers);

      print(response.statusCode);
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        box.write(userId, userData);
        box.write("token", data.userToken);
        box.write("userId", data.id);
        box.write("verification", data.verification);

        setLoading = false;

        Get.snackbar(
            "You are successfully verified ", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.offAll(() => MainScreen());
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar("Failed to verify ", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline));


      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

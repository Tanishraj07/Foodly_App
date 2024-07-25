import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/models/api_error.dart';


class CartController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  void addToCart(String cart) async {
    setLoading = true;

    String? accessToken = box.read("token");

    if (accessToken == null || accessToken.isEmpty) {
      print("Error: Access token is null or empty");
      setLoading = false;
      return;
    }

    var url = Uri.parse("$appBaseUrl/api/cart");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.post(url, headers: headers, body: cart);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        setLoading = false;

        Get.snackbar("Added to cart", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(
              Icons.check_circle_outline,
              color: kLightWhite,
            ));
      } else if (response.statusCode == 200) {
        // Handle the 200 status code as needed
        var responseBody = json.decode(response.body);

        if (responseBody['status'] == true) {
          setLoading = false;

          Get.snackbar("Added to cart", "Enjoy your awesome experience",
              colorText: kLightWhite,
              backgroundColor: kPrimary,
              icon: const Icon(
                Icons.check_circle_outline,
                color: kLightWhite,
              ));
        } else {
          Get.snackbar("Error", "Failed to add to cart",
              colorText: kLightWhite,
              backgroundColor: kRed,
              icon: const Icon(
                Icons.error_outline,
                color: kLightWhite,
              ));
        }
      } else {
        var error = apiErrorFromJson(response.body);
        print('Error: ${error.message}');

        Get.snackbar("Error", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(
              Icons.error_outline,
              color: kLightWhite,
            ));
      }
    } catch (e) {
      print('Exception: ${e.toString()}');
      Get.snackbar("Error", "An unexpected error occurred",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(
            Icons.error_outline,
            color: kLightWhite,
          ));
    } finally {
      setLoading = false;
    }
  }


  void removeFrom(String productId, Function refetch) async {
    setLoading = true;

    String accessToken = box.read("token");

    var url = Uri.parse("$appBaseUrl/api/cart/$productId");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        setLoading = false;
        refetch();
        Get.snackbar("Product removed successfully", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(
              Icons.check_circle_outline,
              color: kLightWhite,
            ));
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar("Error", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(
              Icons.error_outline,
              color: kLightWhite,
            ));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading = false;
    }
  }
}


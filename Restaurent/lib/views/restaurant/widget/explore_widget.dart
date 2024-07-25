import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/shimmers/foodlist_shimmer.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/constants/uidata.dart';
import 'package:restaurent/hooks/fetch_foods.dart';
import 'package:restaurent/hooks/foods_by_restaurant.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/views/home/widget/food_tile.dart';

class ExploreWidget extends HookWidget {
  const ExploreWidget({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchFoods(code);
    final foods = hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodsListShimmer()
          : SizedBox(
              height: height * 0.7,
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(foods!.length, (index) {
                  final FoodsModel food = foods[index];
                  return FoodTile(food: food);
                }),
              ),
            ),
    );
  }
}

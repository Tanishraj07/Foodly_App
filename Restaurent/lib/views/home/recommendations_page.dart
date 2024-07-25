import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/back_ground_container.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/common/shimmers/foodlist_shimmer.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/hooks/fetch_all_foods.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/views/home/widget/food_tile.dart';

class RecommendationsPage extends HookWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllFoods("41007428");
    List<FoodsModel>? foods = hookResults.data;
    final isLoading = hookResults.isLoading;

    return Scaffold(
      backgroundColor: kSecondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kSecondary,
        centerTitle: true,
        title: ReusableText(
          text: "Recommendations",
          style: appStyle(13, kLightWhite, FontWeight.w600),
        ),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: isLoading
            ? const FoodsListShimmer()
            : foods == null || foods.isEmpty
            ? const Center(child: Text('No nearby restaurants available'))
            : Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: foods.length,
            itemBuilder: (context, i) {
              FoodsModel food = foods[i];
              return FoodTile(food: food);
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/custom_appbar.dart';
import 'package:restaurent/common/custom_container.dart';
import 'package:restaurent/common/heading.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/category_controller.dart';
import 'package:restaurent/views/home/all_fastest_foods_page.dart';
import 'package:restaurent/views/home/all_nearby_restaurants.dart';
import 'package:restaurent/views/home/recommendations_page.dart';
import 'package:restaurent/views/home/widget/category_foods_list.dart';
import 'package:restaurent/views/home/widget/category_list.dart';
import 'package:restaurent/views/home/widget/food_list.dart';
import 'package:restaurent/views/home/widget/nearby_restaurants_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.h),
          child: const CustomAppbar(),
        ),
        body: SafeArea(
          child: CustomContainer(
            containerContent: Column(
              children: [
                const CategoryList(),
                Obx(
                  () => controller.categoryValue == ''
                      ? Column(
                          children: [
                            Heading(
                              text: "Try Something New",
                              onTap: () {
                                Get.to(() => const RecommendationsPage(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 900));
                              },
                            ),
                            const FoodList(),
                            Heading(
                              text: "Nearby Restaurants",
                              onTap: () {
                                Get.to(() => const AllNearbyRestaurants(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 900));
                              },
                            ),
                            const NearbyRestaurants(),
                            Heading(
                              text: "Food closer to you",
                              onTap: () {
                                Get.to(() => const AllFastestFoodsPage(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 900));
                              },
                            ),
                            const FoodList(),
                          ],
                        )
                      : CustomContainer(
                          containerContent: Column(
                          children: [
                            Heading(
                              more: true,
                              text: "Explore ${controller.titleValue} Category",
                                 onTap: () {
                                Get.to(() => const RecommendationsPage(),
                                    transition: Transition.cupertino,
                                    duration:
                                        const Duration(milliseconds: 900));
                              },
                            ),
                            const CategoryFoodsList()
                          ],
                        )),
                )
              ],
            ),
          ),
        ));
  }
}

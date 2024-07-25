import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/back_ground_container.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/common/shimmers/foodlist_shimmer.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/constants/uidata.dart';
import 'package:restaurent/hooks/fetch_all_restaurants.dart';
import 'package:restaurent/models/restaurants_model.dart';
import 'package:restaurent/views/home/widget/restaurant_tile.dart';

class AllNearbyRestaurants extends HookWidget {
  const AllNearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults=useFetchAllRestaurants("41007428");
    List<RestaurantsModel>? restaurants=hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
        backgroundColor: kSecondary,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kSecondary,
          centerTitle: true,
          title: ReusableText(
            text: "Nearby Restaurants",
            style: appStyle(13, kLightWhite, FontWeight.w600),
          ),
        ),
        body: BackGroundContainer(
          color: Colors.white,
          child:isLoading
              ?const FoodsListShimmer()
              : Padding(
            padding: EdgeInsets.all(12.w),
            child:
            ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(restaurants!.length, (i) {
                RestaurantsModel restaurant = restaurants[i];
                return RestaurantTile(
                  restaurant: restaurant,
                );
              }),
            ),
          ),
        ));
  }
}

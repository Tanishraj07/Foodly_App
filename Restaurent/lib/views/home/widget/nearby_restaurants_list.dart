import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/shimmers/nearby_shimmer.dart';
import 'package:restaurent/hooks/fetch_restaurants.dart';
import 'package:restaurent/models/restaurants_model.dart';
import 'package:restaurent/views/home/widget/restaurants_widget.dart';
import 'package:restaurent/views/restaurant/restaurant_page.dart';

class NearbyRestaurants extends HookWidget {
  const NearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchRestaurants("41007428");
    final List<RestaurantsModel>? restaurants = hookResults.data;
    final isLoading = hookResults.isLoading;
    final error = hookResults.error;

    return Container(
      height: 190.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: isLoading
          ? const NearbyShimmer()
          : error != null
              ? Center(child: Text('An error occurred: ${error.toString()}'))
              : restaurants == null || restaurants.isEmpty
                  ? const Center(child: Text('No nearby restaurants available'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurants.length,
                      itemBuilder: (context, i) {
                        RestaurantsModel restaurant = restaurants[i];
                        return RestaurantsWidget(
                          onTap: () {
                            Get.to(
                                () => RestaurantPage(restaurant: restaurant));
                          },
                          image: restaurant.imageUrl,
                          logo: restaurant.logoUrl,
                          title: restaurant.title,
                          time: restaurant.time,
                          rating: restaurant.ratingCount,
                        );
                      },
                    ),
    );
  }
}

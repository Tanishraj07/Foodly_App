import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/views/restaurant/rating_page.dart';
import 'package:restaurent/views/restaurant/restaurant_page.dart';


class RestaurantBottomBar extends StatelessWidget {
  const RestaurantBottomBar({super.key, required this.widget});

  final RestaurantPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: width,
      height: 40.h,
      decoration: BoxDecoration(
          color: kPrimary.withOpacity(0.4),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.r),
            topLeft: Radius.circular(8.r),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBarIndicator(
              itemCount: 5,
              itemSize: 25,
              rating: widget.restaurant!.rating.toDouble(),
              itemBuilder: (context, i) => const Icon(
                Icons.star,
                color: Colors.yellow,
              )),

          CustomButton(
              onTap: () {
                Get.to(() => const RatingPage());
              },
              btnwidth: width / 3,
              btnColor: kSecondary,
              text: "Rate Restaurant")
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/models/restaurants_model.dart';
import 'package:restaurent/views/restaurant/directions_page.dart';
import 'package:restaurent/views/restaurant/rating_page.dart';
import 'package:restaurent/views/restaurant/widget/explore_widget.dart';
import 'package:restaurent/views/restaurant/widget/restaurant_menu.dart';
import 'package:restaurent/views/restaurant/widget/row_text.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key, required this.restaurant});

  final RestaurantsModel? restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    with TickerProviderStateMixin {
  late TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: kLightWhite,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 230.h,
                    width: width,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.restaurant!.imageUrl,
                    ),
                  ),
                  Positioned(
                      bottom: 0, child: RestaurantBottomBar(widget: widget)),
                  Positioned(
                      top: 40.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Ionicons.chevron_back_circle,
                                size: 28,
                                color: kLightWhite,
                              ),
                            ),
                            ReusableText(
                                text: widget.restaurant!.title,
                                style: appStyle(13, kDark, FontWeight.w600)),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const DirectionsPage());
                              },
                              child: const Icon(
                                Ionicons.location,
                                size: 28,
                                color: kLightWhite,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    const RowText(
                        first: "Distance to Restaurant", second: "2.7 km"),
                    SizedBox(
                      height: 3.h,
                    ),
                    const RowText(first: "Estimated Price", second: "Rs 2.7"),
                    SizedBox(
                      height: 3.h,
                    ),
                    const RowText(first: "Estimated  time", second: "30 min"),
                    const Divider(
                      thickness: 0.7,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Container(
                  height: 25.h,
                  width: width,
                  decoration: BoxDecoration(
                    color: kOffWhite,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.circular(25.r)),
                    labelPadding: EdgeInsets.zero,
                    labelColor: kLightWhite,
                    labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                    unselectedLabelColor: kGrayLight,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: width / 2,
                          height: 25,
                          child: const Center(
                            child: Text("Menu"),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: width / 2,
                          height: 25,
                          child: const Center(
                            child: Text("Explore"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(

                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SizedBox(
                  height: height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      RestaurantMenuWidget(restaurantId: widget.restaurant!.id),
                      ExploreWidget(code: widget.restaurant!.code),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

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

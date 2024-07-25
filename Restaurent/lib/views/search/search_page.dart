import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/custom_text_field.dart';
import 'package:restaurent/common/shimmers/foodlist_shimmer.dart';
import 'package:restaurent/controller/search_controller.dart';
import 'package:restaurent/views/search/loading_widget.dart';
import 'package:restaurent/views/search/search_result.dart';

import '../../common/custom_container.dart';
import '../../constants/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchFoodController controller = Get.put(SearchFoodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        toolbarHeight: 90.h,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: CustomTextField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            hintText: "Search for Foods",
            suffixIcon: GestureDetector(
              onTap: () {
                if(controller.isTriggered==false) {
                  controller.searchFoods(_searchController.text);
                  controller.setTriggered=true;
                }else{
                  controller.searchResults=null;
                  controller.setTriggered=false;
                  _searchController.clear();
                }
              },
              child:controller.isTriggered==false
                  ? Icon(
                  Ionicons.search_circle,
                  size: 40.h,
                  color: kPrimary)
                  :Icon(
                Ionicons.close_circle,
                size: 40.h,
                color: kRed,
              ),
            ),
            obscureText: false,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const FoodsListShimmer();
          } else if (controller.searchResults == null) {
            return const LoadingWidget();
          } else if (controller.searchResults!.isEmpty) {
            return Center(child: Text("No results found."));
          } else {
            return SearchResult(searchResults: controller.searchResults!);
          }
        }),
      ),
    );
  }
}

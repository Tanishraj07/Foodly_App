import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent/common/custom_container.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/search_controller.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/views/home/widget/food_tile.dart';

class SearchResult extends StatelessWidget {
  final List<FoodsModel> searchResults;

  const SearchResult({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.h, 0),
      height: height,
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, i) {
          FoodsModel food = searchResults[i];
          return FoodTile(food: food);
        },
      ),
    );
  }
}

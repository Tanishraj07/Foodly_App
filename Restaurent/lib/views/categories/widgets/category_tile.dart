import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/category_controller.dart';
import 'package:restaurent/models/categories.dart';
import 'package:restaurent/views/categories/category_page.dart';

class CategoryTile extends StatelessWidget {
  CategoryTile({
    super.key,
    required this.category,
  });

  CategoriesModel category;

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(CategoryController());
    return ListTile(
      onTap:(){
        controller.updateCategory = category.id;
        controller.updateTitle = category.title;
        Get.to(() =>const CategoryPage(),
            transition:Transition.fadeIn,
            duration: const Duration(milliseconds: 900)
        );
      },
      leading: CircleAvatar(
        radius: 15.r,
        backgroundColor: kGrayLight,
        child: Image.asset(
          category.imageUrl,
          fit: BoxFit.contain,
        ),
      ),
      title: ReusableText(
        text: category.title,
        style: appStyle(12, kGray, FontWeight.normal),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: kGray,
        size: 14.r,
      ),
    );
  }
}
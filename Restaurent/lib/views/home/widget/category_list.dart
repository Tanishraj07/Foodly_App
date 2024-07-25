import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent/common/shimmers/categories_shimmer.dart';
import 'package:restaurent/hooks/fetch_categories.dart';
import 'package:restaurent/models/categories.dart';
import 'package:restaurent/views/home/widget/category_widget.dart';

class CategoryList extends HookWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCategories();
    final List<CategoriesModel>? categoriesList = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    return isLoading
        ? const CatergoriesShimmer()
        : Container(
            height: 80.h,
            padding: EdgeInsets.only(left: 12.w, top: 10.h),
            child: categoriesList == null || categoriesList.isEmpty
                ? const Center(child: Text('No categories available'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoriesList.length,
                    itemBuilder: (context, i) {
                      CategoriesModel category = categoriesList[i];
                      return CategoryWidget(category: category);
                    },
                  ),
          );
  }
}

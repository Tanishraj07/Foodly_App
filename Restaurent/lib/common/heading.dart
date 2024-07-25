import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text, this.onTap, this.more});

  final String text;
  final void Function()? onTap;
  final bool? more;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ReusableText(
              text: text,
              style: appStyle(16, kDark, FontWeight.bold),
            ),
          ),
          more == null
              ? GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.store,
                    color: kSecondary,
                    size: 20.sp,
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}

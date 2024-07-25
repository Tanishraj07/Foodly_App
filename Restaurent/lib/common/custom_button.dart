import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.onTap,
      this.btnwidth,
      this.btnHeight,
      this.btnColor,
      this.radius,
      required this.text});

  final void Function()? onTap;
  final double? btnwidth;
  final double? btnHeight;
  final Color? btnColor;
  final double? radius;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: btnwidth ?? width,
        height: btnHeight ?? 28.h,
        decoration: BoxDecoration(
            color: btnColor ?? kPrimary,
            borderRadius: BorderRadius.circular(radius ?? 9.r)),
        child: Center(
            child: ReusableText(
          text: text,
          style: appStyle(12, kLightWhite, FontWeight.w500),
        )),
      ),
    );
  }
}

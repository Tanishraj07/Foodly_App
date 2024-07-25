import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/common/custom_container.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/views/auth/login_page.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        title: Center(
        child:ReusableText(
        text: " Please Login to access this page",
        style: appStyle(15, kDark, FontWeight.w600),
    ),
    ),
    ),
     body: SafeArea(
       child: CustomContainer(
         containerContent: Column(
           children: [
             Container(
               width: width,
               height: height/2,
               color: Colors.white,
               child: LottieBuilder.asset(
                 "assets/anime/delivery.json",
                 width: width,
                 height: height/2,
               ),
             ),
             CustomButton(text: "L O G I N",
             onTap: (){
               Get.to(()=> const LoginPage(),
               transition: Transition.cupertino,
               duration: const Duration(milliseconds: 900));
             },
               btnHeight: 40.h,
               btnwidth: width - 20,
             )
           ],
         ),
       ),
     ),
    );
  }
}

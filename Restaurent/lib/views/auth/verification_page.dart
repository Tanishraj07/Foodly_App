import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/common/custom_container.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:restaurent/controller/verification_controller.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(VerificationController());
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        title: ReusableText(
          text: "Please Verify your Account",
          style: appStyle(12, kGray, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomContainer(
        color: Colors.white,
        containerContent: SizedBox(
          height: height,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // SizedBox(
              //   height: 100.h,
              // ),
              Lottie.asset("assets/anime/delivery.json"),
              SizedBox(
                height: 30.h,
              ),
              ReusableText(
                  text: "verify your Account",
                  style: appStyle(20, kPrimary, FontWeight.w600)),
              SizedBox(
                height: 10.h,
              ),
              Text(
                  "Enter the 6-digit code sent to your email, if you don't see the code,please check your spam folder. ",
                  textAlign: TextAlign.justify,
                  style: appStyle(10, kGray, FontWeight.normal)),
              SizedBox(
                height: 20.h,
              ),
              OtpTextField(
                numberOfFields: 6,
                borderColor: kPrimary,
                borderWidth: 2.0,
                textStyle: appStyle(17, kDark, FontWeight.w600),
                onCodeChanged: (String code) {},
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onSubmit: (String verificationCode) {
                 controller.setCode=verificationCode;
                }, // end onSubmit
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                text: "V E R I F Y  A C C O U N T",
                onTap: () {
                  controller.verificationFunction();
                },
                btnHeight: 35.h,
                btnwidth: width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

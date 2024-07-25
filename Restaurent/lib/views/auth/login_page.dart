import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/back_ground_container.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/login_controller.dart';
import 'package:restaurent/models/login_model.dart';
import 'package:restaurent/views/auth/registration_page.dart';
import 'package:restaurent/views/auth/widget/email_textfield.dart';
import 'package:restaurent/views/auth/widget/password_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
  TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        title: Center(
          child: ReusableText(
            text: "Startpi Family",
            style: appStyle(20, kLightWhite, FontWeight.bold),
          ),
        ),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Lottie.asset("assets/anime/delivery.json"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    EmailTextField(
                      hintText: " Email",
                      prefixIcon: Icon(
                        CupertinoIcons.mail,
                        size: 22,
                        color: kGrayLight,
                      ),
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                   PasswordTextfield(
                           controller: _passwordController,
                   ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.to(() => const RegistrationPage(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 1200));
                            },
                            child: ReusableText(
                              text: "Register",
                              style: appStyle(12, Colors.blue, FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    CustomButton(
                      text: "L O G I N",
                      onTap: () {
                        if(_emailController.text.isNotEmpty && _passwordController.text.length >= 8){
                          LoginModel model = LoginModel(
                              email: _emailController.text,
                              password: _passwordController.text);
                          String data = loginModelToJson(model);

                        //Login function
                          controller.loginFunction(data);
                        }
                       },
                      btnHeight: 35.h,
                      btnwidth: width,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

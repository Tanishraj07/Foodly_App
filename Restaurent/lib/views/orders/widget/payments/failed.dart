import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:get/get.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/controller/orders_controller.dart';
import 'package:restaurent/views/entrypoint.dart';

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({super.key});

  @override
  Widget build(BuildContext context) {
 final orderController = Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            orderController.setPaymentUrl = '';
            Get.off(() =>  MainScreen());
          },
          child: const Icon(
            AntDesign.closecircleo,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/No.png",
              color: Colors.red,
            ),
            ReusableText(
                text: "Payment Failed",
                style: appStyle(28, Colors.black, FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

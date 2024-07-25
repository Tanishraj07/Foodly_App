import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/back_ground_container.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/orders_controller.dart';
import 'package:restaurent/models/address_response.dart';
import 'package:restaurent/models/distance_time.dart';
import 'package:restaurent/models/foods_model.dart';
import 'package:restaurent/models/order_request.dart';
import 'package:restaurent/models/restaurants_model.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/services/distance.dart';
import 'package:restaurent/views/orders/payment.dart';
import 'package:restaurent/views/orders/widget/order_tile.dart';
import 'package:restaurent/views/restaurant/widget/row_text.dart';

class OrderPage extends StatefulWidget {


   const OrderPage(
      {super.key,
        this.restaurant,
        required this.food,
        required this.item,
        this.address});
  final RestaurantsModel? restaurant;
  final FoodsModel food;
  final OrderItem item;
  final AddressResponse? address;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Razorpay _razorpay;

  TextEditingController amtController=TextEditingController();
  void openCheckout(amount)async{

    var options={
      'key' : 'rzp_test_DLx5Y2KTpkcO0u',
      'amount' : 100,
      'name' : 'Foodly',
      'prefill': {'contact' : '1234567890','email':'test@gmail.com'},
      'external': {
        'wallets':['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg:"Payment Succesful"+ response.paymentId!,toastLength: Toast.LENGTH_SHORT);
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg:"Payment Fail"+ response.message!,toastLength: Toast.LENGTH_SHORT);
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg:"External Wallet"+ response.walletName!,toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose(){
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState(){
    super.initState();
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    DistanceTime data = Distance().calculateDistanceTimePrice(
        widget.restaurant!.coords.latitude,
        widget.restaurant!.coords.longitude,
        widget.address!.latitude,
        widget.address!.longitude,
        10,
        2);

    double totalPrice = widget.item.price + data.price;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(() => controller.paymentUrl.contains('https')
        ? const PaymentWebView()
        : Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: ReusableText(
            text: "Complete Ordering",
            style: appStyle(13, kLightWhite, FontWeight.w600)),
      ),
      body: BackGroundContainer(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              OrderTile(food: widget.food),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                width: width,
                height: height / 3.5,
                decoration: BoxDecoration(
                    color: kOffWhite,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text: widget.restaurant!.title,
                              style: appStyle(20, kGray, FontWeight.bold)),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: kPrimary,
                            backgroundImage: NetworkImage(widget.restaurant!.logoUrl),
                          ),
                        ]),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(first: "Business Hours", second: widget.restaurant!.time),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Distance from Restaurant",
                        second: "${data.distance.toStringAsFixed(2)} km"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Price from Restaurant",
                        second: "\$ ${data.price.toStringAsFixed(2)}"),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Order Total",
                        second: "\$ ${widget.item.price.toString()}"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Grand Total",
                        second: "\$ ${totalPrice.toStringAsFixed(2)}"),
                    SizedBox(
                      height: 10.h,
                    ),
                    ReusableText(
                        text: "Additives",
                        style: appStyle(20, kGray, FontWeight.bold)),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      width: width,
                      height: 15.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.item.additives.length,
                          itemBuilder: (context, i) {
                            String additive = widget.item.additives[i];
                            return Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                color: kSecondaryLight,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9.r),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(2.h),
                                  child: ReusableText(
                                      text: additive,
                                      style:
                                      appStyle(8, kGray, FontWeight.w400)),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                text: "Proceed to Payment",
                btnHeight: 45,
                onTap: () {
                  OrderRequest order = OrderRequest(
                      userId: widget.address!.userId,
                      orderItems: [widget.item],
                      orderTotal: widget.item.price,
                      deliveryFee: data.price.toStringAsFixed(2),
                      grandTotal: totalPrice,
                      deliveryAddress: widget.address!.id,
                      restaurantAddress: widget.restaurant!.coords.address,
                      restaurantId: widget.restaurant!.id,
                      restaurantCoords: [
                        widget.restaurant!.coords.latitude,
                        widget.restaurant!.coords.longitude
                      ],
                      recipientCoords: [widget.address!.latitude, widget.address!.longitude]);
                  print(widget.item.price);
                  setState(() {
                    openCheckout(widget.item.price);
                  });
                  // String orderData = orderRequestToJson(order);
                  //
                  // print("Order Data: $orderData");
                  //
                  // controller.createOrder(orderData, order);

                },
              )
            ],
          ),
        ),
      ),
    )
    );}
}
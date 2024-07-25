import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPayment extends StatefulWidget {
  const RazorpayPayment({super.key});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpay;
  TextEditingController amtController=TextEditingController();

  void openCheckout(amount)async{

    var options={
      'key' : 'rzp_test_DLx5Y2KTpkcO0u',
      'amount' : amount,
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
    return const Placeholder();
  }
}

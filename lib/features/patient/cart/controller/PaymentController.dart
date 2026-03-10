import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class PaymentController extends GetxController {
  var selectedMethod = 0.obs; // 0: Online, 1: Cash
  late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void changeMethod(int index) => selectedMethod.value = index;

  void startPayment(double amount) {
    if (selectedMethod.value == 1) {
      // Cash on Collection Logic
      Get.snackbar("Success", "Booking Confirmed via Cash", backgroundColor: Colors.green, colorText: Colors.white);
      return;
    }

    var options = {
      'key': 'rzp_test_S0W8O9t5VChhlA',
      'amount': amount * 100,
      'name': 'My Tezt Lab',
      'description': 'Diagnostic Test Payment',
      'prefill': {
        'contact': "9420844725",
        'email': "patil@gmail.com"
      },
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }


  final ApiClient _apiClient = ApiClient();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      final successResponse = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/confirm-booking"),
        body: {
          "payment_id": response.paymentId,
          "order_id": response.orderId ?? "",
          "cart_id": "yourCartId",
          "status": "Success"
        },
      );

      if (successResponse.statusCode == 200) {
        Get.back(); // Loading hatao
        // Get.offAll(() => const BookingSuccessPage()); // Success screen par bhejo
      } else {
        Get.back();
        Get.snackbar("Error", "Payment saved in Razorpay but failed in Database. Contact Support.");
      }
    } catch (e) {
      Get.back();
      print("API Error: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Unknown Error", backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", response.walletName ?? "");
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
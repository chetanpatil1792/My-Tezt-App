// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/apiUrls/api_urls.dart';
// import '../../../../core/utils/token_helper.dart';
//
// class PaymentController extends GetxController {
//   var selectedMethod = 0.obs; // 0: Online, 1: Cash
//   late Razorpay _razorpay;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   void changeMethod(int index) => selectedMethod.value = index;
//
//   void startPayment(double amount) {
//     if (selectedMethod.value == 1) {
//       // Cash on Collection Logic
//       Get.snackbar("Success", "Booking Confirmed via Cash", backgroundColor: Colors.green, colorText: Colors.white);
//       return;
//     }
//
//     var options = {
//       'key': 'rzp_test_S0W8O9t5VChhlA',
//       'amount': amount * 100,
//       'name': 'My Tezt Lab',
//       'description': 'Diagnostic Test Payment',
//       'prefill': {
//         'contact': "9420844725",
//         'email': "patil@gmail.com"
//       },
//       // 'external': {
//       //   'wallets': ['paytm']
//       // }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: e');
//     }
//   }
//
//
//   final ApiClient _apiClient = ApiClient();
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
//
//     try {
//       final successResponse = await _apiClient.post(
//         Uri.parse("${ApiUrls.baseUrl}patient/confirm-booking"),
//         body: {
//           "payment_id": response.paymentId,
//           "order_id": response.orderId ?? "",
//           "cart_id": "yourCartId",
//           "status": "Success"
//         },
//       );
//
//       if (successResponse.statusCode == 200) {
//         Get.back(); // Loading hatao
//         // Get.offAll(() => const BookingSuccessPage()); // Success screen par bhejo
//       } else {
//         Get.back();
//         Get.snackbar("Error", "Payment saved in Razorpay but failed in Database. Contact Support.");
//       }
//     } catch (e) {
//       Get.back();
//       print("API Error: $e");
//     }
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     Get.snackbar("Payment Failed", response.message ?? "Unknown Error", backgroundColor: Colors.red, colorText: Colors.white);
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Get.snackbar("External Wallet", response.walletName ?? "");
//   }
//
//   @override
//   void onClose() {
//     _razorpay.clear();
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:my_tezt/routes/app_routes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class PaymentController extends GetxController {
  var selectedMethod = 0.obs; // 0: Online, 1: Cash
  late Razorpay _razorpay;

  Map<String, dynamic>? currentOrderData;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void changeMethod(int index) => selectedMethod.value = index;

  final ApiClient _apiClient = ApiClient();

  void startPayment(double amount, Map<String, dynamic> orderData) {
    currentOrderData = orderData; // Save for later

    if (selectedMethod.value == 1) {
      // Cash on Collection Logic
      _confirmCashBooking(orderData['paymentId']);
      return;
    }

    // Using keys exactly as they come in your API response
    var options = {
      'key': orderData['key'],
      'amount': (orderData['amount'] * 100).toInt(),
      'name': 'My Tezt Lab',
      'order_id': orderData['orderId'],
      'description': 'Diagnostic Test Payment',
      'prefill': {
        'contact': "9420844725",
        'email': "patil@gmail.com"
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Open Error: $e');
    }
  }

  // --- Verify Payment API Call ---
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // Body as per your requirement
      Map<String, dynamic> verifyBody = {
        "razorpayOrderId": response.orderId,
        "razorpayPaymentId": response.paymentId,
        "razorpaySignature": response.signature,
        "paymentId": currentOrderData?['paymentId'] // from the first API response
      };

      final verifyResponse = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/cart/verify-payment"),
        body: jsonEncode(verifyBody),
      );

      Get.back(); // Close loading

      final data = verifyResponse.body;
      print("!!!!!!!!!!!!!!!!!!!!$data");
      if (verifyResponse.statusCode == 200) {
        Get.snackbar("Success", "Booking Confirmed!", backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(AppRoutes.DashboardView);
      } else {
        Get.snackbar("Error", "Verification failed. Please contact support.");
      }
    } catch (e) {
      Get.back();
      debugPrint("Verify API Error: $e");
      Get.snackbar("Error", "Something went wrong during verification.");
    }
  }

  void _confirmCashBooking(dynamic paymentId) {
    // Logic for Cash on Collection if required by another API
    Get.snackbar("Success", "Booking Confirmed via Cash", backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Unknown Error", backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }
}
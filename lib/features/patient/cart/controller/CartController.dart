import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import 'package:my_tezt/core/utils/token_helper.dart';

import '../view/PaymentPage.dart';

class CartController extends GetxController {
  var cartItems = [].obs;
  var isLoading = true.obs;
  final ApiClient _apiClient = ApiClient();

  var selectedTestIds = <int>[].obs;
  var selectedPackageIds = <int>[].obs;
  var selectedSlots = <int, Map<String, String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  void toggleItemSelection(int itemId, String type) {
    if (type == "test") {
      if (selectedTestIds.contains(itemId)) {
        selectedTestIds.remove(itemId);
      } else {
        selectedTestIds.add(itemId);
      }
    } else {
      if (selectedPackageIds.contains(itemId)) {
        selectedPackageIds.remove(itemId);
      } else {
        selectedPackageIds.add(itemId);
      }
    }
    print(selectedTestIds);
    print(selectedPackageIds);
  }

  double get grandTotal {
    double total = 0;
    for (var lab in cartItems) {
      if (lab['tests'] != null) {
        for (var test in lab['tests']) {
          if (selectedTestIds.contains(test['labTestId'])) {
            total += (test['price'] ?? 0).toDouble();
          }
        }
      }
      if (lab['packages'] != null) {
        for (var package in lab['packages']) {
          var pId = package['labPackageMasterId'] ?? package['labTestId'];
          if (pId != null && selectedPackageIds.contains(pId)) {
            total += (package['price'] ?? 0).toDouble();
          }
        }
      }
    }
    return total;
  }

  bool get isAnyItemSelected => selectedTestIds.isNotEmpty || selectedPackageIds.isNotEmpty;

  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(Uri.parse("${ApiUrls.baseUrl}patient/cart"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        cartItems.assignAll(data);

        for (var item in data) {
          int cartId = item['id'];
          String apiDate = item['bookingDate'] ?? "";
          String apiFrom = item['slotFrom'] ?? "";
          String apiTo = item['slotTo'] ?? "";

          String displayDate = "dd/mm/yyyy";
          if (apiDate.isNotEmpty) {
            DateTime dt = DateTime.parse(apiDate);
            displayDate = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
          }

          String displayFrom = apiFrom.length > 5 ? apiFrom.substring(0, 5) : "--:--";
          String displayTo = apiTo.length > 5 ? apiTo.substring(0, 5) : "--:--";

          selectedSlots[cartId] = {
            "date": displayDate,
            "from": displayFrom,
            "to": displayTo
          };
        }
      }
    } catch (e) {
      print("Cart Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateSlot(int cartId, String key, String value) {
    if (!selectedSlots.containsKey(cartId)) {
      selectedSlots[cartId] = {"date": "dd/mm/yyyy", "from": "--:--", "to": "--:--"};
    }
    selectedSlots[cartId]![key] = value;
    selectedSlots.refresh();
  }

  Future<void> removeItemFromCart({required int cartId, required String type, required int itemId}) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      Map<String, dynamic> body = {
        "cartId": cartId,
        "type": type,
        "id": itemId
      };

      final response = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/cart/remove-item"),
        body: jsonEncode(body),
      );

      Get.back();

      if (response.statusCode == 200) {
        if (type == "test") {
          selectedTestIds.remove(itemId);
        } else {
          selectedPackageIds.remove(itemId);
        }

        for (var lab in cartItems) {
          if (lab['id'] == cartId) {
            if (type == "test") {
              lab['tests'].removeWhere((t) => t['labTestId'] == itemId);
            } else {
              lab['packages'].removeWhere((p) => (p['labPackageMasterId'] ?? p['labTestId']) == itemId);
            }
          }
        }
        cartItems.removeWhere((lab) => (lab['tests'] as List).isEmpty && (lab['packages'] as List).isEmpty);
        cartItems.refresh();
        Get.snackbar("Success", "Item removed", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to remove item", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      print("Remove Error: $e");
    }
  }


  var sampleCollectionType = "LabVisit".obs; // Default value
  Future<void> createPaymentOrder() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.blue)),
        barrierDismissible: false,
      );

      final Map<String, dynamic> body = {
        "amount": grandTotal,
        "bookingType": sampleCollectionType.value,
        "selectedTestIds": selectedTestIds.toList(),
        "selectedPackageIds": selectedPackageIds.toList(),
      };

      final response = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/cart/create-payment-order"),
        body: jsonEncode(body),
      );

      Get.back(); // Loading band karein

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Direct decode karein
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        print("API SUCCESS: $responseData");

        // PaymentPage pe navigate karein aur pura map pass karein
        Get.to(() => PaymentPage(
            totalAmount: grandTotal,
            orderData: responseData
        ));

      } else {
        Get.snackbar("Error", "Failed to create order",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      print("Create Order Error: $e");
      Get.snackbar("Error", "Connection error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}
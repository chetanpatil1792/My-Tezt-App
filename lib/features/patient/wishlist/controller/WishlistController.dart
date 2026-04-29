import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class WishlistController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  var isLoading = false.obs;
  RxList wishlist = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {


    try {
      isLoading(true);
      var url = Uri.parse("${ApiUrls.baseUrl}patient/WishList/GetWishListData");
      var body = jsonEncode({"patientId": 34, "userLatitude": 0, "userLongitude": 0});

      final response = await _apiClient.post(url, body: body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        wishlist.assignAll(data);
      }
    } catch (e) {
      print("Wishlist Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Individual Remove Logic with Loader
  Future<void> removeWishlistItem({required int labId, int? testId, int? packageId}) async {
    try {
      // 1. Show Loader Dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFF2A5C82))),
        barrierDismissible: false,
      );

      var url = Uri.parse("${ApiUrls.baseUrl}patient/WishList/remove");
      var body = jsonEncode({
        "labId": labId,
        "labTestId": testId ?? 0,
        "labPackageMasterId": packageId ?? 0
      });

      final response = await _apiClient.post(url, body: body);

      // 2. Close Loader Dialog
      Get.back();

      if (response.statusCode == 200) {
        int labIndex = wishlist.indexWhere((element) => element['labId'] == labId);

        if (labIndex != -1) {
          if (testId != null) {
            (wishlist[labIndex]['tests'] as List).removeWhere((t) => t['labTestId'] == testId);
          } else if (packageId != null) {
            (wishlist[labIndex]['packages'] as List).removeWhere((p) => p['labPackageMasterId'] == packageId);
          }

          if ((wishlist[labIndex]['tests'] as List).isEmpty &&
              (wishlist[labIndex]['packages'] as List).isEmpty) {
            wishlist.removeAt(labIndex);
          } else {
            wishlist.refresh();
          }
        }
        Get.snackbar("Removed", "Item removed from wishlist",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // Error ke case mein bhi loader band karein
      Get.snackbar("Error", "Failed to remove item");
    }
  }

  void bookNow(Map data) {
    print("Booking Lab: ${data['labName']}");
  }
}
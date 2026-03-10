
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import 'package:my_tezt/core/utils/token_helper.dart';
import '../model/LabSearchModel.dart';

class LabsSearchController extends GetxController {
  var searchQuery = "".obs;
  var allLabs = <LabSearchModel>[].obs;
  var isLoading = true.obs;
  var isAddingToCart = <int, bool>{}.obs;
  var labCart = <int, Map<String, dynamic>>{}.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchLabs();
  }

  Future<void> fetchLabs() async {
    try {
      isLoading(true);
      final Map<String, dynamic> searchBody = {
        "location": null, "homeCollectionOnly": null, "onlineReportOnly": null,
        "emergencyOnly": null, "testIds": [], "tatRanges": [],
        "userLatitude": 18.549248673519894, "userLongitude": 73.79426539395915, "priceSort": null
      };
      final response = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/bookings/search"),
        body: jsonEncode(searchBody),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        print("----------------");
        print(jsonEncode(data));
        allLabs.assignAll(data.map((e) => LabSearchModel.fromJson(e)).toList());
      }
    } catch (e) { print("Fetch Error: $e"); } finally { isLoading(false); }
  }



  Future<void> addToCart(int labId) async {
    final cart = labCart[labId];
    if (cart == null || (cart['items'] as List).isEmpty) return;

    try {
      isAddingToCart[labId] = true;
      isAddingToCart.refresh();

      // 1. Date formatting logic with Null Safety
      String? finalBookingDate;
      if (cart['date'] != null && cart['date'].toString().trim().isNotEmpty) {
        // Input: "2026-03-09" -> Output: "2026-03-09T00:00:00"
        finalBookingDate = "${cart['date']}T00:00:00";
      } else {
        finalBookingDate = null; // Select nahi kiya toh null jayega
      }

      // 2. Time slots logic with Null Safety
      String? slotFrom = (cart['fromTime'] != null && cart['fromTime'].toString().isNotEmpty)
          ? cart['fromTime'] : null;
      String? slotTo = (cart['toTime'] != null && cart['toTime'].toString().isNotEmpty)
          ? cart['toTime'] : null;

      final Map<String, dynamic> body = {
        "labId": labId,
        "bookingDate": finalBookingDate, // null bhejega agar selected nahi hai
        "slotFrom": slotFrom,            // null bhejega agar selected nahi hai
        "slotTo": slotTo,                // null bhejega agar selected nahi hai

        "tests": (cart['items'] as List)
            .whereType<TestModel>()
            .map((t) => {
          "id": 0,
          "labTestId": t.labTestId,
          "testName": t.testName,
          "price": t.price,
          "isAvailable": true,
          "description": ""
        })
            .toList(),

        "packages": (cart['items'] as List)
            .whereType<PackageModel>()
            .map((p) => {
          "id": 0,
          "packageId": p.labPackageMasterId,
          "categoryId": 0,
          "packageName": p.packageName,
          "price": p.price,
          "isAvailable": true,
          "description": ""
        })
            .toList(),
      };

      print("Sending Body: ${jsonEncode(body)}");

      final res = await _apiClient.post(
          Uri.parse("${ApiUrls.baseUrl}patient/cart/add"),
          body: jsonEncode(body),
          headers: {"Content-Type": "application/json"}
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("Success", "Added to cart!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        print("API Error: ${res.body}");
        // Backend error message dikhane ke liye
        Get.snackbar("Error", "Server returned ${res.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isAddingToCart[labId] = false;
      isAddingToCart.refresh();
    }
  }

  void toggleItem(int labId, dynamic item) {
    _initCart(labId);
    var items = labCart[labId]!['items'] as List;
    items.contains(item) ? items.remove(item) : items.add(item);
    labCart.refresh();
  }

  void updateDetail(int labId, String key, String? val) {
    _initCart(labId); labCart[labId]![key] = val ?? ""; labCart.refresh();
  }

  void _initCart(int labId) {
    labCart.putIfAbsent(labId, () => {"items": <dynamic>[].obs, "date": "", "fromTime": "", "toTime": ""});
  }

  double getLabTotal(int labId) => (labCart[labId]?['items'] as List?)?.fold(0.0, (sum, item) => sum! + item.price) ?? 0.0;

  List<LabSearchModel> get filteredLabs => searchQuery.isEmpty ? allLabs : allLabs.where((l) => l.labName.toLowerCase().contains(searchQuery.value.toLowerCase()) || l.city.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
}
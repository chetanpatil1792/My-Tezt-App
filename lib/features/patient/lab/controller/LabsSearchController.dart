import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import 'package:my_tezt/core/utils/token_helper.dart';
import '../model/LabSearchModel.dart';
import 'package:geolocator/geolocator.dart';

class LabsSearchController extends GetxController {
  var searchQuery = "".obs;
  var allLabs = <LabSearchModel>[].obs;
  var isLoading = true.obs;

  var isAddingToCart = <int, bool>{}.obs;
  var isAddingToWishlist = <int, bool>{}.obs;

  var labCart = <int, Map<String, dynamic>>{}.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchLabs();
    fetchTests(); // 👈 add this

  }



  var selectedPriceSort = "".obs;
  var homeCollection = false.obs;
  var onlineReport = false.obs;
  var emergencyOnly = false.obs;
  var selectedTatRanges = <String>[].obs;

  var isFilterLoading = false.obs;

  Future<void> applyFilters() async {
    isFilterLoading(true);

    await fetchLabs();

    isFilterLoading(false);
    await Future.delayed(const Duration(milliseconds: 300));
    Get.back();
  }

  void resetFilters() {
    selectedPriceSort.value = "";
    homeCollection.value = false;
    onlineReport.value = false;
    emergencyOnly.value = false;
    selectedTatRanges.clear();
    selectedTestIds.clear();
    fetchLabs();
  }

  Future<void> fetchLabs() async {
    final position = await getCurrentLocation();

    try {
      isLoading(true);
      final Map<String, dynamic> searchBody = {
        "location": null,
        "homeCollectionOnly": homeCollection.value ? true : null,
        "onlineReportOnly": onlineReport.value ? true : null,
        "emergencyOnly": emergencyOnly.value ? true : null,
        "testIds": selectedTestIds,
        "tatRanges": selectedTatRanges,
        "userLatitude": position?.latitude,
        "userLongitude": position?.longitude,
        "priceSort": getPriceSortValue(),
      };
      const encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(searchBody);
      print(prettyJson);

       final response = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}patient/bookings/search"),
        body: jsonEncode(searchBody),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        allLabs.assignAll(data.map((e) => LabSearchModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  String? getPriceSortValue() {
    if (selectedPriceSort.value == "low") return "asc";
    if (selectedPriceSort.value == "high") return "desc";
    return null;
  }


  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permanently denied");
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> addToCart(int labId, {bool isWishlist = false}) async {
    final cart = labCart[labId];
    // Check if items are selected
    if (cart == null || (cart['items'] as List).isEmpty) {
      Get.snackbar("Selection Required", "Please select at least one test or package",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      // Start specific loader
      if (isWishlist) {
        isAddingToWishlist[labId] = true;
        isAddingToWishlist.refresh();
      } else {
        isAddingToCart[labId] = true;
        isAddingToCart.refresh();
      }

      String? finalBookingDate;
      if (cart['date'] != null && cart['date'].toString().trim().isNotEmpty) {
        finalBookingDate = "${cart['date']}T00:00:00";
      }

      final body = {
        "labId": labId,
        "bookingDate": finalBookingDate,
        "slotFrom": cart['fromTime']?.toString().isEmpty ?? true ? null : cart['fromTime'],
        "slotTo": cart['toTime']?.toString().isEmpty ?? true ? null : cart['toTime'],
        "tests": (cart['items'] as List)
            .whereType<TestModel>()
            .map((t) => {"labTestId": t.labTestId})
            .toList(),
        "packages": (cart['items'] as List)
            .whereType<PackageModel>()
            .map((p) => {"labPackageMasterId": p.labPackageMasterId})
            .toList(),
      };

      final endpoint = isWishlist ? "patient/WishList/add" : "patient/cart/add";
      final res = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}$endpoint"),
        body: jsonEncode(body),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.snackbar("Success", isWishlist ? "Added to Wishlist!" : "Added to Cart!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Server Error: ${res.statusCode}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Stop specific loader
      if (isWishlist) {
        isAddingToWishlist[labId] = false;
        isAddingToWishlist.refresh();
      } else {
        isAddingToCart[labId] = false;
        isAddingToCart.refresh();
      }
    }
  }

  void toggleItem(int labId, dynamic item) {
    _initCart(labId);
    var items = labCart[labId]!['items'] as List;
    if (items.contains(item)) {
      items.remove(item);
    } else {
      items.add(item);
    }
    labCart.refresh();
  }

  void updateDetail(int labId, String key, String? val) {
    _initCart(labId);
    labCart[labId]![key] = val ?? "";
    labCart.refresh();
  }

  void _initCart(int labId) {
    labCart.putIfAbsent(labId, () => {"items": <dynamic>[].obs, "date": "", "fromTime": "", "toTime": ""});
  }

  double getLabTotal(int labId) => (labCart[labId]?['items'] as List?)?.fold(0.0, (sum, item) => sum! + item.price) ?? 0.0;

  List<LabSearchModel> get filteredLabs => searchQuery.isEmpty
      ? allLabs
      : allLabs.where((l) => l.labName.toLowerCase().contains(searchQuery.value.toLowerCase()) || l.city.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();




  var allTests = <TestFilterModel>[].obs;
  var selectedTestIds = <int>[].obs;
  var isTestLoading = false.obs;
  var testSearch = "".obs;

  List<TestFilterModel> get filteredTests {
    if (testSearch.value.isEmpty) return allTests;

    return allTests.where((t) =>
        t.testName.toLowerCase().contains(testSearch.value.toLowerCase())
    ).toList();
  }

  Future<void> fetchTests() async {
    try {
      isTestLoading(true);

      final res = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}patient/bookings/GetTest"),
      );

      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        allTests.assignAll(data.map((e) => TestFilterModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Test Fetch Error: $e");
    } finally {
      isTestLoading(false);
    }
  }

}



class TestFilterModel {
  final int id;
  final String testName;

  TestFilterModel({
    required this.id,
    required this.testName,
  });

  factory TestFilterModel.fromJson(Map<String, dynamic> json) {
    return TestFilterModel(
      id: json['id'],
      testName: json['testName'] ?? "",
    );
  }
}
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:my_tezt/core/utils/token_helper.dart';

import '../../../../core/apiUrls/api_urls.dart';

class DashboardController extends GetxController {
  final storage = GetStorage();

  // User Info - Reactive
  var userName = ''.obs;
  var profileUrl = ''.obs;
  var userLocation = 'Mumbai, India'.obs;

  // Stats
  RxInt totalTests = 12.obs;
  RxInt upcomingAppointments = 2.obs;
  RxInt reportsAvailable = 8.obs;
  RxDouble healthScore = 0.78.obs;

  // Toggles (Functional)
  RxBool medicineReminder = true.obs;
  RxInt wishlistCount = 0.obs;
  RxInt cartCount = 0.obs;
  RxInt notificationCount = 0.obs; // Naya variable

    @override
  void onInit() {
    super.onInit();
    _loadSettings();
    fetchProfileData();
    fetchWishlistCount();
    fetchCartCount();
    fetchNotificationCount(); // Initial call
  }

  Future<void> refreshData() async {
    await fetchProfileData();
    await fetchWishlistCount();
    await fetchCartCount();
    await fetchNotificationCount(); // Refresh call
  }

  Future<void> fetchNotificationCount() async {
    try {
      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}notifications"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        int unread = data.where((item) => item['isRead'] == false).length;

        notificationCount.value = unread;
      }
    } catch (e) {
      print("Notification Count Error: $e");
    }
  }

  Future<void> fetchCartCount() async {
    try {
      final response = await _apiClient.get(Uri.parse("${ApiUrls.baseUrl}patient/cart"));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        int total = 0;

        for (var item in data) {
          // Tests count + Packages count ka sum
          int testsLen = (item['tests'] as List?)?.length ?? 0;
          int packagesLen = (item['packages'] as List?)?.length ?? 0;
          total += (testsLen + packagesLen);
        }

        cartCount.value = total;
      }
    } catch (e) {
      print("Cart Count Error: $e");
    }
  }

  void _loadSettings() {
    // Load toggle state from local storage
    medicineReminder.value = storage.read('med_reminder') ?? true;
  }

  void toggleMedicine(bool value) {
    medicineReminder.value = value;
    storage.write('med_reminder', value);
    Get.snackbar(
      "Reminder ${value ? 'Enabled' : 'Disabled'}",
      "You will ${value ? 'now' : 'no longer'} receive medicine alerts.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) return (parts[0][0] + parts.last[0]).toUpperCase();
    return parts[0][0].toUpperCase();
  }

  var profile = {}.obs;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  ApiClient _apiClient = ApiClient();



  Future<void> fetchProfileData() async {
    try {
      final response = await _apiClient.get(Uri.parse(ApiUrls.patientProfileDetails));

      if (response.statusCode == 200) {
        var detailsJson = json.decode(response.body);
        profile.value = detailsJson;
        userName.value = "${detailsJson['firstName'] ?? ''} ${detailsJson['lastName'] ?? ''}";
        profileUrl.value = "${ApiUrls.baseUrlImage}${detailsJson['profileImage'] ?? ''}";
      }
    } catch (e) {
      print("Profile Fetch Error: $e");
    }
  }

  Future<void> fetchWishlistCount() async {
    try {
      // final response = await _apiClient.get(Uri.parse("${ApiUrls.baseUrl}patient/WishList/GetWishListData"));

      // var url = Uri.parse("${ApiUrls.baseUrl}patient/bookings/WishListsearch");
      var url = Uri.parse("${ApiUrls.baseUrl}patient/WishList/GetWishListData");
      var body = jsonEncode({"patientId": 34, "userLatitude": 0, "userLongitude": 0});

      final response = await _apiClient.post(url, body: body);


      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        int total = 0;

        for (var item in data) {
          // Tests count + Packages count ka sum
          int testsLen = (item['tests'] as List?)?.length ?? 0;
          int packagesLen = (item['packages'] as List?)?.length ?? 0;
          total += (testsLen + packagesLen);
        }

        wishlistCount.value = total;
      }
    } catch (e) {
      print("Wishlist Count Error: $e");
    }
  }


 }
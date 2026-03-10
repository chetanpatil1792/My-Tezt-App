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

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    fetchProfileData();
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



  void fetchProfileData() async {
    try {

      final response =
      await _apiClient.get(Uri.parse(ApiUrls.patientProfileDetails));

      if (response.statusCode == 200) {
        var detailsJson = json.decode(response.body);
        profile.value = detailsJson;
        userName.value = "${detailsJson['firstName'] ?? ''} ${detailsJson['lastName'] ?? ''}";
        profileUrl.value = "${ApiUrls.baseUrlImage}${detailsJson['profileImage'] ?? ''}";
        print(profileUrl.value);
      }
    } catch (e) {
      Get.snackbar("Error", "Fetch failed: $e");
    }
  }


 }
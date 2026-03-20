import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';

import '../../../../core/utils/token_helper.dart';

class BookingController extends GetxController {
  var selectedTab = 0.obs; // 0 for Tracking, 1 for History
  var isLoading = true.obs;
  var allBookings = [].obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}Phlebotomisttracking/GetPatientBookingTracking"),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        allBookings.assignAll(data);
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading(false);
    }
  }

  // Filter logic based on isReportGenerated
  List get filteredBookings {
    if (selectedTab.value == 0) {
      // Tracking: Report not generated yet
      return allBookings.where((b) => b['isReportGenerated'] != true).toList();
    } else {
      // History: Report generated
      return allBookings.where((b) => b['isReportGenerated'] == true).toList();
    }
  }

  String formatTo12Hour(String? dateStr) {
    if (dateStr == null) return "--:--";
    DateTime dt = DateTime.parse(dateStr);
    return DateFormat('hh:mm a').format(dt);
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    DateTime dt = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy').format(dt);
  }
}
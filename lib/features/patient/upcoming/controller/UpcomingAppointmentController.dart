import 'package:get/get.dart';
import 'dart:convert';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart'; // Assuming your ApiClient location

class UpcomingAppointmentController extends GetxController {
  var appointments = [].obs;
  var isLoading = true.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingAppointments();
  }

  Future<void> fetchUpcomingAppointments() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}patient/profile/GetUpcomingNotification"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        appointments.assignAll(data['result']);
      }
    } catch (e) {
      print("Error fetching appointments: $e");
    } finally {
      isLoading(false);
    }
  }
}
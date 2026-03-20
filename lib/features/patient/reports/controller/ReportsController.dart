import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_tezt/core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class ReportsController extends GetxController {
  var isLoading = true.obs;
  var allReports = [].obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  // Fetch Reports List
  Future<void> fetchReports() async {
    try {
      isLoading(true);

      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}patient/profile/GetPatientReports"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        allReports.assignAll(data);
      }
    } catch (e) {
      print("Error fetching reports: $e");
    } finally {
      isLoading(false);
    }
  }

  // Date Format
  String formatDate(String? dateStr) {
    if (dateStr == null) return "";
    DateTime dt = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy').format(dt);
  }

  // Extract File Name
  String getFileName(String path) {
    return path.split('\\').last;
  }

  // VIEW REPORT
  Future<void> viewReport(String reportPath) async {
    try {
      String encodedPath = Uri.encodeComponent(reportPath);

      final response = await _apiClient.get(
        Uri.parse(
            "${ApiUrls.baseUrl}patient/profile/ViewReport?path=$encodedPath"),
      );

      if (response.statusCode == 200) {
        List<int> bytes = response.bodyBytes;

        final dir = await getTemporaryDirectory();

        final file = File("${dir.path}/${getFileName(reportPath)}");

        await file.writeAsBytes(bytes);

        // open pdf
        OpenFilex.open(file.path);
      } else {
        Get.snackbar("Error", "Report not found");
      }
    } catch (e) {
      print("View error: $e");
      Get.snackbar("Error", "Failed to open report");
    }
  }

  // DOWNLOAD REPORT
  Future<void> downloadReport(String reportPath) async {
    try {
      await Permission.storage.request();

      String encodedPath = Uri.encodeComponent(reportPath);

      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}patient/profile/ViewReport?path=$encodedPath"),
      );

      if (response.statusCode == 200) {
        List<int> bytes = response.bodyBytes;

        final directory = Directory("/storage/emulated/0/Download/MYTEZT");

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final filePath = "${directory.path}/${getFileName(reportPath)}";

        final file = File(filePath);

        await file.writeAsBytes(bytes);

        Get.snackbar(
          "Download Complete",
          "Saved in Download/MYTEZT",
          snackPosition: SnackPosition.BOTTOM,
        );

      } else {
        Get.snackbar("Error", "Download failed");
      }
    } catch (e) {
      print("Download error: $e");
      Get.snackbar("Error", "Download failed");
    }
  }
}
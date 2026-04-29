import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_tezt/core/apiUrls/api_urls.dart';

import '../../../../core/utils/token_helper.dart';

class UploadReportController extends GetxController {
  var isUploading = false.obs;
  var selectedFileName = "".obs;
  PlatformFile? pickedFile;


  final ApiClient _apiClient = ApiClient();
  final _storage = const FlutterSecureStorage();

  Future<void> pickReport() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      pickedFile = result.files.first;
      selectedFileName.value = pickedFile!.name;
    }
  }

  Future<void> uploadReport() async {
    if (pickedFile == null || pickedFile!.path == null) {
      Get.snackbar("Error", "Please select a file first");
      return;
    }

    try {
      isUploading(true);

      String? storedUserId = await _storage.read(key: 'userId');
      int patientId = storedUserId != null ? int.parse(storedUserId) : 0;

      if (patientId == 0) {
        Get.snackbar("Error", "User session not found. Please login again.");
        return;
      }

      var uri = Uri.parse("${ApiUrls.baseUrl}PatientUploadReport/UploadReport");
      var request = http.MultipartRequest('POST', uri);

      request.fields['PatientId'] = patientId.toString();
      request.files.add(await http.MultipartFile.fromPath(
        'File',
        pickedFile!.path!,
        filename: pickedFile!.name,
      ));

      final streamedResponse = await _apiClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        String successMsg = responseData['message'] ?? "Report uploaded successfully";

        Get.snackbar(
          "Success",
          successMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[800],
        );

        selectedFileName.value = "";
        pickedFile = null;
      } else {
        String errorMsg = responseData['message'] ?? "Server Error: ${response.statusCode}";
        Get.snackbar("Upload Failed", errorMsg);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please check your connection.");
    } finally {
      isUploading(false);
    }
  }
}
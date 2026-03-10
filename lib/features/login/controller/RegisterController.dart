// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:my_tezt/core/apiUrls/api_urls.dart';
//
// class RegisterController extends GetxController {
//   // Patient Controllers
//   final pFirstName = TextEditingController();
//   final pLastName = TextEditingController();
//   final pPhone = TextEditingController();
//   final pEmail = TextEditingController();
//   final pPassword = TextEditingController();
//   final pConfirmPassword = TextEditingController();
//
//   // Lab Controllers
//   final lName = TextEditingController();
//   final lPhone = TextEditingController();
//   final lUserEmail = TextEditingController();
//   final lAddress = TextEditingController();
//   final lPincode = TextEditingController();
//   final lLocation = TextEditingController();
//   final lPassword = TextEditingController();
//   final lCertNo = TextEditingController();
//   final lCity = TextEditingController();
//   final lState = TextEditingController();
//
//   // Observables
//   var isHomeCollection = false.obs;
//   var isOnlineReports = false.obs;
//   var isEmergencyTests = false.obs;
//   var selectedFile = Rxn<File>();
//   var isLoading = false.obs;
//
//   Future<void> pickCertificate() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'png'],
//     );
//     if (result != null) {
//       selectedFile.value = File(result.files.single.path!);
//     }
//   }
//
//   // --- Lab Registration API (Multipart) ---
//   Future<void> registerLab() async {
//     if (selectedFile.value == null) {
//       Get.snackbar("Error", "Please upload a Lab Certificate", backgroundColor: Colors.red.withOpacity(0.1));
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       // Replace with your actual URL if ApiUrls is not defined
//       var request = http.MultipartRequest('POST', Uri.parse("${ApiUrls.baseUrl}auth/register-lab"));
//
//       // API expects numeric types. Even in multipart, strings must be "parseable" numbers.
//       request.fields.addAll({
//         'LabId': '0',
//         'LabName': lName.text.trim(),
//         'Phone': lPhone.text.trim(),
//         'UserName': lUserEmail.text.trim(),
//         'Address': lAddress.text.trim(),
//         'PinCode': lPincode.text.isEmpty ? '0' : lPincode.text.trim(),
//         'Location': lLocation.text.trim(),
//         'City': lCity.text.trim().isEmpty ? "N/A" : lCity.text.trim(),
//         'State': lState.text.trim().isEmpty ? "N/A" : lState.text.trim(),
//         'Latitude': '0.0', // Must be valid double string
//         'Longitude': '0.0', // Must be valid double string
//         'Password': lPassword.text,
//         'IsHomeCollectionAvailable': isHomeCollection.value.toString(),
//         'OnlineReports': isOnlineReports.value.toString(),
//         'EmergencyTest': isEmergencyTests.value.toString(),
//         'CertificateNo': lCertNo.text.isEmpty ? '0' : lCertNo.text.trim(),
//         'LabCertificatePath': '',
//       });
//
//       // Add File
//       request.files.add(await http.MultipartFile.fromPath(
//           'CertificateFile',
//           selectedFile.value!.path
//       ));
//
//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Get.snackbar("Success", "Laboratory Registered Successfully");
//       } else {
//         // Detailed error for debugging
//         print("API Error: ${response.body}");
//         var errorData = jsonDecode(response.body);
//         Get.snackbar("Error", errorData['title'] ?? "Registration failed");
//       }
//     } catch (e) {
//       print("Exception: $e");
//       Get.snackbar("Error", "Connection failed. Please check your internet.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // --- Patient Registration API ---
//   Future<void> registerPatient() async {
//     if (pPassword.text != pConfirmPassword.text) {
//       Get.snackbar("Error", "Passwords do not match");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       final body = {
//         "id": 0,
//         "firstName": pFirstName.text,
//         "lastName": pLastName.text,
//         "phone": pPhone.text,
//         "userName": pEmail.text,
//         "password": pPassword.text,
//         "dob": DateTime.now().toIso8601String(),
//         "gender": "MALE",
//         "bloodGroup": "N/A"
//       };
//
//       final response = await http.post(
//         Uri.parse("${ApiUrls.baseUrl}auth/register-patient"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Patient Registered Successfully");
//       } else {
//         Get.snackbar("Error", "Registration failed");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import 'package:my_tezt/routes/app_routes.dart';

class RegisterController extends GetxController {
  // Patient Controllers
  final pFirstName = TextEditingController();
  final pLastName = TextEditingController();
  final pPhone = TextEditingController();
  final pEmail = TextEditingController();
  final pPassword = TextEditingController();
  final pConfirmPassword = TextEditingController();

  // Lab Controllers
  final lName = TextEditingController();
  final lPhone = TextEditingController();
  final lUserEmail = TextEditingController();
  final lAddress = TextEditingController();
  final lPincode = TextEditingController();
  final lLocation = TextEditingController();
  final lPassword = TextEditingController();
  final lCertNo = TextEditingController();
  final lCity = TextEditingController();
  final lState = TextEditingController();

  // Observables
  var isHomeCollection = false.obs;
  var isOnlineReports = false.obs;
  var isEmergencyTests = false.obs;
  var selectedFile = Rxn<File>();
  var isLoading = false.obs;
  var loadingMessage = "".obs;

  // File Picker
  Future<void> pickCertificate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  // --- Success Dialog ---
  void _showSuccessPopup(String role) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text(
                "Registration Successful!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Your $role account has been created successfully. You can now log in to your dashboard.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2A5C82),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.offAllNamed(AppRoutes.LOGIN);
                  },
                  child: const Text("GO TO LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Lab Registration API ---
  Future<void> registerLab() async {
    if (lName.text.isEmpty || lPhone.text.isEmpty || lPassword.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all mandatory fields", backgroundColor: Colors.red.withOpacity(0.1));
      return;
    }
    if (selectedFile.value == null) {
      Get.snackbar("Required", "Please upload the Lab Certificate", backgroundColor: Colors.orange.withOpacity(0.1));
      return;
    }

    try {
      isLoading.value = true;
      loadingMessage.value = "Uploading Certificate & Registering...";

      var request = http.MultipartRequest('POST', Uri.parse("${ApiUrls.baseUrl}auth/register-lab"));

      request.fields.addAll({
        'LabId': '0',
        'LabName': lName.text.trim(),
        'Phone': lPhone.text.trim(),
        'UserName': lUserEmail.text.trim(),
        'Address': lAddress.text.trim(),
        'PinCode': lPincode.text.isEmpty ? '0' : lPincode.text.trim(),
        'Location': lLocation.text.trim(),
        'City': lCity.text.isEmpty ? "N/A" : lCity.text.trim(),
        'State': lState.text.isEmpty ? "N/A" : lState.text.trim(),
        'Latitude': '0.0',
        'Longitude': '0.0',
        'Password': lPassword.text,
        'IsHomeCollectionAvailable': isHomeCollection.value.toString(),
        'OnlineReports': isOnlineReports.value.toString(),
        'EmergencyTest': isEmergencyTests.value.toString(),
        'CertificateNo': lCertNo.text.isEmpty ? '0' : lCertNo.text.trim(),
        'LabCertificatePath': '',
      });

      request.files.add(await http.MultipartFile.fromPath('CertificateFile', selectedFile.value!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessPopup("Laboratory");
      } else {
        var errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['title'] ?? "Registration failed", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Connection error. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // --- Patient Registration API ---
  Future<void> registerPatient() async {
    if (pFirstName.text.isEmpty || pPhone.text.isEmpty || pEmail.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }
    if (pPassword.text != pConfirmPassword.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;
      loadingMessage.value = "Creating your account...";

      final body = {
        "id": 0,
        "firstName": pFirstName.text,
        "lastName": pLastName.text,
        "phone": pPhone.text,
        "userName": pEmail.text,
        "password": pPassword.text,
        "dob": DateTime.now().toIso8601String(),
        "gender": "MALE",
        "bloodGroup": "N/A"
      };

      final response = await http.post(
        Uri.parse("${ApiUrls.baseUrl}auth/register-patient"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _showSuccessPopup("Patient");
      } else {
        Get.snackbar("Error", "Registration failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
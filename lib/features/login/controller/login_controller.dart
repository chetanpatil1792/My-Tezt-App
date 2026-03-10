import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_device/safe_device.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../routes/app_routes.dart';

enum LoginStatus { idle, loading, success, error }

class LoginController extends GetxController {
  // Reactive variables
  var userName = ''.obs;
  var password = ''.obs;
  var loginStatus = LoginStatus.idle.obs;
  var message = ''.obs;

  // Text controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Password visibility
  var isPasswordVisible = false.obs;

  // Secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final storage = GetStorage();

  // Passcode Controller instance

  @override
  void onInit() {
    super.onInit();

  }



  /// ✅ Check if already logged in (based on secure token)
  Future<void> checkLoginStatus() async {
    final accessToken = await secureStorage.read(key: 'access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      Get.offAllNamed(AppRoutes.DashboardView);

    } else {
      // 🚪 No token found → Go to Login screen
      Get.offAllNamed(AppRoutes.LOGIN);
      print('🔒 No token found, redirecting to Login screen...');
    }
  }




  /// 🔐 Login API integration
  Future<void> login() async {
    if (userName.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
      return;
    }

    loginStatus.value = LoginStatus.loading;

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "UserName": userName.value.trim(),
          "Password": password.value.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🎯 Direct check: Agar token hai, toh login success
        if (data['token'] != null) {

          // Sab kuch string mein convert karke save karo (Secure Storage requirement)
          await secureStorage.write(key: 'access_token', value: data['token'].toString());
          await secureStorage.write(key: 'userName', value: data['userName'].toString());
          await secureStorage.write(key: 'role', value: data['role'].toString());
          await secureStorage.write(key: 'userId', value: data['id'].toString());

          // labId null ho sakta hai, isliye safety check
          if (data['labId'] != null) {
            await secureStorage.write(key: 'labId', value: data['labId'].toString());
          }

          loginStatus.value = LoginStatus.success;
          Get.snackbar('Succes', 'Login Success');

          Get.offAllNamed(AppRoutes.DashboardView);
        } else {
          loginStatus.value = LoginStatus.error;
          Get.snackbar('Error', 'Invalid Response from Server');
        }
      } else {
        loginStatus.value = LoginStatus.error;
        Get.snackbar('Error', 'Invalid Username or Password');
      }
    } catch (e) {
      loginStatus.value = LoginStatus.error;
      Get.snackbar('Error', 'Connection failed: $e');
    } finally {
      if (loginStatus.value != LoginStatus.success) {
        loginStatus.value = LoginStatus.idle;
      }
    }
  }

  /// 🚪 Logout method (secure clear)
  Future<void> logout() async {
    final storage = GetStorage();
    storage.erase();
    await secureStorage.deleteAll();
    Get.offAllNamed(AppRoutes.LOGIN);
    print('🔒 Logged out and cleared secure storage');
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:my_tezt/routes/app_routes.dart';
import '../apiUrls/api_urls.dart';

class ApiClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // -------------------- Get Token --------------------
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // -------------------- Logout Handler --------------------
  Future<void> _handleLogout() async {
    await _storage.deleteAll();
    Get.offAllNamed(AppRoutes.LOGIN);

    Get.snackbar(
      "Session Expired",
      "Please login again to continue.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // -------------------- Send Override --------------------
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final String? token = await getAccessToken();

    // ---------- Common Headers ----------
    request.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    // ---------- Authorization ----------
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }



    final http.StreamedResponse response = await _inner.send(request);

    // -------------------- 401 : Unauthorized --------------------
    if (response.statusCode == 401) {
      await response.stream.drain();
      await _handleLogout();

      return http.StreamedResponse(
        Stream.fromIterable([
          utf8.encode(jsonEncode({'message': 'Session expired'}))
        ]),
        401,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    }

    // -------------------- 403 : Forbidden --------------------
    if (response.statusCode == 403) {
      await response.stream.drain();

      Get.snackbar(
        "Access Denied",
        "You don’t have permission to access this feature.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return http.StreamedResponse(
        Stream.fromIterable([
          utf8.encode(jsonEncode({'message': 'Forbidden'}))
        ]),
        403,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    }

    // -------------------- Success / Other Errors --------------------
    return response;
  }
}
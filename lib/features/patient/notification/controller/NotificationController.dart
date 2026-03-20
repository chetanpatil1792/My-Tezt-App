import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class NotificationsController extends GetxController {
  var isLoading = true.obs;
  var notifications = [].obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}notifications"),
      );
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        notifications.assignAll(data);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> markAsRead(int notificationId, int index) async {
    try {
      if (notifications[index]['isRead'] == true) return;

      final response = await _apiClient.post(
        Uri.parse("${ApiUrls.baseUrl}notifications/$notificationId/read"),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        var updatedItem = Map<String, dynamic>.from(notifications[index]);
        updatedItem['isRead'] = true;
        notifications[index] = updatedItem;
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String formatDateTime(String? dateStr) {
    if (dateStr == null) return "";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM, hh:mm a').format(dt);
    } catch (e) {
      return "";
    }
  }

  Map<String, dynamic> getStyle(String type) {
    switch (type) {
      case 'Assignment': return {'icon': Icons.person_pin_rounded, 'color': 0xFF2196F3};
      case 'Booking Confirmation': return {'icon': Icons.check_circle_rounded, 'color': 0xFF4CAF50};
      case 'Report': return {'icon': Icons.analytics_rounded, 'color': 0xFFFF9800};
      case 'Sample Recieved': return {'icon': Icons.biotech_rounded, 'color': 0xFF9C27B0};
      case 'Payment': return {'icon': Icons.account_balance_wallet_rounded, 'color': 0xFFE91E63};
      default: return {'icon': Icons.notifications_active_rounded, 'color': 0xFF607D8B};
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/NotificationController.dart';

class NotificationPage extends StatelessWidget {
  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Colors.blueAccent, size: 22),
            onPressed: () {
              // Mark all as read logic can go here
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchNotifications(),
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        edgeOffset: 10,
        child: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (controller.notifications.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none_rounded, size: 70, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      const Text("All caught up!", style: TextStyle(color: Colors.grey, fontSize: 15)),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              final style = controller.getStyle(item['type'] ?? "");

              return Obx(() {
                final bool isRead = controller.notifications[index]['isRead'];

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isRead
                            ? Colors.black.withOpacity(0.02)
                            : Color(style['color']).withOpacity(0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: isRead ? Colors.transparent : Color(style['color']).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => controller.markAsRead(item['id'], index),
                      splashColor: Color(style['color']).withOpacity(0.05),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNotificationIcon(style, isRead),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['type']?.toUpperCase() ?? "INFO",
                                        style: TextStyle(
                                          fontSize: 10,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                          color: Color(style['color']).withOpacity(0.8),
                                        ),
                                      ),
                                      Text(
                                        controller.formatDateTime(item['createdOn']),
                                        style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['title'] ?? "",
                                    style: TextStyle(
                                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                                      fontSize: 15,
                                      color: isRead ? Colors.black54 : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['message'] ?? "",
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: isRead ? Colors.grey[500] : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          );
        }),
      ),
    );
  }

  Widget _buildNotificationIcon(Map<String, dynamic> style, bool isRead) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(style['color']).withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(style['icon'], color: Color(style['color']), size: 24),
        ),
        if (!isRead)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
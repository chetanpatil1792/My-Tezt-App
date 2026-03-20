import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/UpcomingAppointmentController.dart';

class UpcomingAppointmentsPage extends StatelessWidget {
  final controller = Get.put(UpcomingAppointmentController());

  String formatTo12Hour(String time) {
    try {
      DateTime tempDate = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(tempDate); // e.g. 9:00 AM
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD), // Ultra light grey
      appBar: AppBar(
        title: const Text("Appointments",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false, // Left aligned for premium feel
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded, color: Colors.black))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            return _buildCompactPremiumCard(controller.appointments[index]);
          },
        );
      }),
    );
  }

  Widget _buildCompactPremiumCard(Map<String, dynamic> item) {
    DateTime dt = DateTime.parse(item['bookingDate']);
    bool isConfirmed = item['isBookingConfirm'] ?? false;
    Color themeColor = isConfirmed ? const Color(0xFF27AE60) : const Color(0xFFF2994A);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Status Indicator Line
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 16),
            // Date Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('dd').format(dt),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1)),
                Text(DateFormat('MMM').format(dt).toUpperCase(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(width: 16),
            // Divider
            VerticalDivider(color: Colors.grey.withOpacity(0.2), indent: 12, endIndent: 12, width: 1),
            const SizedBox(width: 16),
            // Info Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['labName'] ?? "Lab",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1C1E))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined, size: 13, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "${formatTo12Hour(item['slotFrom'])} - ${formatTo12Hour(item['slotTo'])}",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Status Tag (Compact)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isConfirmed ? "Confirmed" : "Pending",
                  style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/BookingController.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Map orderData;
  OrderTrackingScreen({required this.orderData});

  final Color primaryGold = const Color(0xFFC5A358);
  final Color darkNavy = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Tracking Detail",
            style: GoogleFonts.alice(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 12),
            _orderedItemsSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text("Booking Status",
                  style: GoogleFonts.alice(fontSize: 16, fontWeight: FontWeight.bold, color: darkNavy)),
            ),
            const SizedBox(height: 12),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("CODE: ${orderData['bookingCode']}",
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(orderData['labName'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alice(color: primaryGold, fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const Icon(Icons.qr_code_2_rounded, color: Colors.white70, size: 28),
        ],
      ),
    );
  }

  Widget _orderedItemsSection() {
    List tests = orderData['tests'] ?? [];
    List packages = orderData['packages'] ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          iconColor: primaryGold,
          title: Text("View Items (${tests.length + packages.length})",
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: darkNavy)),
          leading: Icon(Icons.shopping_bag_outlined, color: primaryGold, size: 18),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  if (tests.isNotEmpty) ...[
                    _itemHeader("Tests"),
                    ...tests.map((t) => _itemBullet(t['testName'])).toList(),
                  ],
                  if (packages.isNotEmpty) ...[
                    if (tests.isNotEmpty) const SizedBox(height: 8),
                    _itemHeader("Packages"),
                    ...packages.map((p) => _itemBullet(p['packageName'])).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemHeader(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGold)),
    );
  }

  Widget _itemBullet(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text("• $name", style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
    );
  }

  Widget _buildTimeline() {
    final controller = Get.find<BookingController>();
    bool isHome = orderData['bookingType'] == "HomeCollection";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _step("Booking Confirmed", controller.formatTo12Hour(orderData['bookingConfirmedDate']), orderData['isBookingConfirm'] == true),
          _step("Phlebotomist Assigned", controller.formatTo12Hour(orderData['assignedDate']), orderData['isAssigned'] == true),
          _step("Accepted by Phlebotomist", controller.formatTo12Hour(orderData['acceptedByPhlebotomistDate']), orderData['isAcceptedByPhlebotomist'] == true),
          if (isHome) ...[
            _step("On the Way", controller.formatTo12Hour(orderData['ontheWayDate']), orderData['isOntheWay'] == true),
            _step("Reached Location", controller.formatTo12Hour(orderData['reachedAtLocationDate']), orderData['isReachedAtLocation'] == true),
          ],
          _step("Sample Collected", controller.formatTo12Hour(orderData['sampleCollectedDate']), orderData['isSampleCollected'] == true),
          _step("Sample Received at Lab", controller.formatTo12Hour(orderData['sampleRecivedDate']), orderData['isSampleRecived'] == true),
          _step("Report Generated", controller.formatTo12Hour(orderData['reportGeneratedDate']), orderData['isReportGenerated'] == true, isLast: true),
        ],
      ),
    );
  }

  Widget _step(String title, String time, bool isDone, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? Colors.green : Colors.white,
                  border: Border.all(color: isDone ? Colors.green : Colors.grey.shade300, width: 1.5),
                ),
                child: isDone ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
              ),
              if (!isLast) Expanded(child: VerticalDivider(thickness: 1.5, color: isDone ? Colors.green : Colors.grey.shade100)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
                          color: isDone ? darkNavy : Colors.grey)),
                  if (isDone && time != "--:--")
                    Text(time, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
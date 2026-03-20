import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/BookingController.dart';
import 'OrderTrackingScreen.dart';

class MyBookingsScreen extends StatelessWidget {
  final controller = Get.put(BookingController());

  final Color darkNavy = const Color(0xFF1A1C1E);
  final Color primaryGold = const Color(0xFFC5A358);
  final Color bgPearl = const Color(0xFFF8F9FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPearl,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("My Appointments",
            style: GoogleFonts.alice(fontSize: 24, color: darkNavy, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildPremiumTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              var list = controller.filteredBookings;
              if (list.isEmpty) {
                return Center(child: Text("No bookings found", style: GoogleFonts.poppins(color: Colors.grey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _orderCard(list[index]),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildPremiumTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Obx(() => Row(
        children: [
          _tabButton("Tracking", 0),
          _tabButton("History", 1),
        ],
      )),
    );
  }

  Widget _tabButton(String title, int index) {
    bool isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? darkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                )),
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map booking) {
    bool isHistory = booking['isReportGenerated'] == true;
    String testsText = "";
    if (booking['tests'].isNotEmpty) testsText = booking['tests'][0]['testName'];
    if (booking['packages'].isNotEmpty) testsText = booking['packages'][0]['packageName'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(color: primaryGold.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.biotech_rounded, color: primaryGold),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking['labName'], style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(testsText, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                _statusTag(booking),
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => OrderTrackingScreen(orderData: booking)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color:   darkNavy,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Center(
                child: Text(isHistory ? "VIEW REPORT" : "TRACK BOOKING",
                    style: GoogleFonts.poppins(
                        color:  Colors.white,
                        fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _statusTag(Map booking) {
    bool done = booking['isReportGenerated'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (done ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(done ? "COMPLETED" : "IN-PROGRESS",
          style: TextStyle(color: done ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
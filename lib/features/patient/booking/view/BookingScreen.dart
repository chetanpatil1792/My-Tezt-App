import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/BookingController.dart';

class MyBookingsScreen extends StatelessWidget {
  final controller = Get.put(BookingController());

  final Color darkNavy = const Color(0xFF1E293B);
  final Color primaryGold = const Color(0xFFC5A358);
  final Color bgPearl = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPearl,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("My Appointments",
            style: GoogleFonts.alice(fontSize: 26, color: darkNavy, fontWeight: FontWeight.w500)),
      ),
      body: Column(
        children: [
          _premiumTabs(),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: controller.orders.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => _orderCard(controller.orders[index]),
            )),
          )
        ],
      ),
    );
  }

  Widget _premiumTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Obx(() => Row(
        children: ["All", "Pending", "Completed"].map((tab) => _tabItem(tab)).toList(),
      )),
    );
  }

  Widget _tabItem(String title) {
    bool isSelected = controller.selectedTab.value == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected ? darkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
          ),
        ),
      ),
    );
  }

  Widget _orderCard(Map order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFFE2E8F0), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // UNIQUE HERO TAG TO FIX THE EXCEPTION
                Hero(
                  tag: 'avatar_${order['id']}',
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: primaryGold.withOpacity(0.1),
                    child: Icon(Icons.biotech_outlined, color: primaryGold),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['labName'], style: GoogleFonts.alice(fontSize: 18, fontWeight: FontWeight.bold, color: darkNavy)),
                      Text(order['tests'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                _statusChip(order['status']),
              ],
            ),
          ),
          Material(
            color: darkNavy,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            child: InkWell(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              onTap: () => Get.to(() => OrderTrackingScreen(orderData: order), transition: Transition.cupertino),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text("TRACK APPOINTMENT",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == "Completed" ? Colors.teal : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// --- ORDER TRACKING SCREEN ---
class OrderTrackingScreen extends StatelessWidget {
  final Map orderData;
  OrderTrackingScreen({required this.orderData});

  final Color darkNavy = const Color(0xFF1E293B);
  final Color primaryGold = const Color(0xFFC5A358);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 18, color: darkNavy), onPressed: () => Get.back()),
        title: Text("Track Order", style: GoogleFonts.alice(fontSize: 22, color: darkNavy)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _infoCard(),
          const SizedBox(height: 30),
          _timeline(),
          const SizedBox(height: 30),
          _agentCard(),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: darkNavy,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: darkNavy.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ID: ${orderData['id']}",
                  style: GoogleFonts.poppins(color: primaryGold, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
              // HERO MATCHING THE SOURCE TAG
              Hero(
                tag: 'avatar_${orderData['id']}',
                child: Icon(Icons.biotech, color: primaryGold, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(orderData['labName'], style: GoogleFonts.alice(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 5),
          Text("Agent is 5 mins away from your location",
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _timeline() {
    return Column(
      children: [
        _step("Booking Confirmed", "Request received", true, true),
        _step("Agent Assigned", "Rohit Sharma (Phlebotomist)", true, true),
        _step("Sample Collection", "Arriving soon", false, true),
        _step("Lab Processing", "Awaiting sample", false, true),
        _step("Report Ready", "Soft copy via Email/WhatsApp", false, false),
      ],
    );
  }

  Widget _step(String title, String sub, bool done, bool line) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(done ? Icons.check_circle : Icons.radio_button_off,
                color: done ? Colors.teal : Colors.grey.shade300, size: 22),
            if (line) Container(width: 2, height: 40, color: done ? Colors.teal : Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: done ? FontWeight.w600 : FontWeight.w400, color: darkNavy)),
              Text(sub, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 15),
            ],
          ),
        )
      ],
    );
  }

  Widget _agentCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, backgroundColor: Color(0xFFF1F5F9), child: Icon(Icons.person_pin, color: Color(0xFF64748B))),
          const SizedBox(width: 15),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Rohit Sharma", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: darkNavy)),
              Text("Verified Collection Agent", style: GoogleFonts.poppins(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w600)),
            ]),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.teal)),
        ],
      ),
    );
  }
}
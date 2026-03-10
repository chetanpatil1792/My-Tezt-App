import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/BookingController.dart';

class OrderTrackingScreen extends StatelessWidget {
  final controller = Get.find<BookingController>();

  // Premium Palette matching the My Bookings Screen
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: darkNavy),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Track Order",
          style: GoogleFonts.alice(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: darkNavy,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          _premiumOrderInfoCard(),
          const SizedBox(height: 25),
          _premiumTimelineSection(),
          const SizedBox(height: 25),
          _premiumAgentCard(),
          const SizedBox(height: 25),
          _premiumHelpSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// 1. TOP INFO CARD (High Contrast)
  Widget _premiumOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: darkNavy,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: darkNavy.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("SAHYADRI LABS",
                  style: GoogleFonts.poppins(color: primaryGold, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
              _statusChip("In Transit", Colors.orange),
            ],
          ),
          const SizedBox(height: 12),
          Text("Full Body Checkup",
              style: GoogleFonts.alice(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 8),
          Text("ID: MT102343 • Mar 12, 09:00 AM",
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }

  /// 2. TRACKING TIMELINE (Clean & Editorial)
  Widget _premiumTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Booking Status", style: GoogleFonts.alice(fontSize: 18, color: darkNavy)),
        const SizedBox(height: 20),
        _buildStep("Order Confirmed", "Your request has been received", true, true),
        _buildStep("Agent Assigned", "Rohit Sharma is on the way", true, true),
        _buildStep("Sample Collection", "Expected by 10:30 AM", false, true),
        _buildStep("Lab Processing", "Waiting for sample", false, true),
        _buildStep("Report Generation", "Usually takes 24 hours", false, false),
      ],
    );
  }

  Widget _buildStep(String title, String subtitle, bool isDone, bool hasLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.teal : Colors.white,
                border: Border.all(color: isDone ? Colors.teal : Colors.grey.shade300, width: 2),
              ),
              child: isDone ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (hasLine)
              Container(
                width: 2,
                height: 45,
                color: isDone ? Colors.teal : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isDone ? FontWeight.w600 : FontWeight.w400, color: darkNavy)),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  /// 3. AGENT CARD (Minimalist)
  Widget _premiumAgentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Replace with actual or placeholder
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Rohit Sharma", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                Text("Phlebotomist • 4.9 ★", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.call, color: Colors.teal, size: 20),
            ),
          )
        ],
      ),
    );
  }

  /// 4. HELP SECTION (Soft Card)
  Widget _premiumHelpSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: primaryGold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.help_outline, color: primaryGold, size: 20),
          const SizedBox(width: 12),
          Text("Facing issues?", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text("CHAT SUPPORT", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: primaryGold)),
        ],
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
      child: Text(text.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/PaymentController.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;
  final controller = Get.put(PaymentController());

  PaymentPage({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text("Checkout",
            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        children: [
          _buildCompactTotalCard(),
          _buildPaymentSection(),
        ],
      ),
      bottomNavigationBar: _buildPayNowButton(),
    );
  }

  Widget _buildCompactTotalCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark Midnight
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Payable", style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 4),
              Text("₹$totalAmount",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 30),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payment Methods",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: [
                _buildMethodTile(0, Icons.bolt, "Online Payment", "Razorpay, UPI, Cards, Netbanking"),
                _buildMethodTile(1, Icons.handshake_outlined, "Pay on Collection", "Pay cash when technician arrives"),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodTile(int index, IconData icon, String title, String sub) {
    bool isSelected = controller.selectedMethod.value == index;
    return GestureDetector(
      onTap: () => controller.changeMethod(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : Colors.black54, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade300,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPayNowButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Obx(() => ElevatedButton(
        onPressed: () => controller.startPayment(totalAmount),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(
          controller.selectedMethod.value == 0 ? "Proceed to Pay ₹$totalAmount" : "Confirm Booking",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      )),
    );
  }
}
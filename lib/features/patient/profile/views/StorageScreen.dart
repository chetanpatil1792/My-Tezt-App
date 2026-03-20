import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/StorageController.dart';

class StorageScreen extends StatelessWidget {
  final controller = Get.put(StorageController());
  final Color primaryColor = const Color(0xFF1E293B);
  final Color accentColor = const Color(0xFFC5A358);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text("Cloud Storage", style: GoogleFonts.alice(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildMainStorageCard(),
              const SizedBox(height: 25),
              _buildDetailList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMainStorageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: controller.percentage,
                  strokeWidth: 12,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              Column(
                children: [
                  Text(
                    "${(controller.percentage * 100).toStringAsFixed(2)}%",
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text("Used", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _storageInfoTile("Used Space", controller.usedStorageDisplay.value),
              Container(width: 1, height: 30, color: Colors.white24),
              _storageInfoTile("Remaining", "${controller.remainingMB.toStringAsFixed(2)} MB"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _storageInfoTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDetailList() {
    return Column(
      children: [
        _detailItem(Icons.cloud_done_rounded, "Total Capacity", "1.0 GB", Colors.blue),
        _detailItem(Icons.pie_chart_rounded, "Current Usage", controller.usedStorageDisplay.value, accentColor),
        _detailItem(Icons.info_outline_rounded, "Storage Type", "Patient Documents", Colors.grey),
      ],
    );
  }

  Widget _detailItem(IconData icon, String title, String value, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 15),
          Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
          const Spacer(),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
        ],
      ),
    );
  }
}
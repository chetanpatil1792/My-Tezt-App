import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/ReportsController.dart';
import 'ReportDetailScreen.dart';

class ReportsListPage extends StatelessWidget {
  final controller = Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "My Reports",
          style: GoogleFonts.poppins(
            color: primaryDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: controller.allReports.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var report = controller.allReports[index];
          return _reportListItem(report);
        },
      ),
    );
  }

  Widget _reportListItem(Map<String, dynamic> report) {
    return GestureDetector(
      onTap: () {
        controller.selectReport(report);
        Get.to(() =>   ReportDetailScreen(), arguments: report);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: primaryPink, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report['labName'],
                    style: const TextStyle(fontSize: 12, color: primaryTeal, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        report['date'],
                        style: const TextStyle(fontSize: 11, color: secondaryText),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report['status'],
                          style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: secondaryText),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, curve: Curves.easeOut),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controller/ReportsController.dart';
import '../controller/SelfReportsController.dart';

class SelfReportsListPage extends StatelessWidget {
  final controller = Get.put(SelfReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Self Uploaded Reports",
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allReports.isEmpty) {
          return const Center(child: Text("No reports found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: controller.allReports.length,
          itemBuilder: (context, index) {
            var report = controller.allReports[index];
            return _reportListItem(report);
          },
        );
      }),
    );
  }

  Widget _reportListItem(Map report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP ROW (ICON + DETAILS)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getFileName(report['fileName']),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            controller.formatDate(report['createdOn']),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ACTION BUTTONS (NICHE)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.viewReport(report['reportPath']);
                  },
                  icon: const Icon(Icons.visibility_outlined,
                      size: 18, color: Colors.blueGrey),
                  label: const Text("View"),
                ),

                const SizedBox(width: 8),

                TextButton.icon(
                  onPressed: () {
                    controller.downloadReport(report['reportPath']);
                  },
                  icon: const Icon(Icons.download_for_offline_rounded,
                      size: 18, color: Colors.green),
                  label: const Text("Download"),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05);
  }}
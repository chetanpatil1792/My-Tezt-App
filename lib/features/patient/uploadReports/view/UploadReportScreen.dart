
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import '../controller/UploadReportController.dart';

class UploadReportScreen extends StatelessWidget {
  final controller = Get.put(UploadReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Upload Report",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // 🌈 Background Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFEAF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Upload Medical Report",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "PDF, Images supported",
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 30),

              // 📦 Upload Card
              GestureDetector(
                onTap: () => controller.pickReport(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: DottedBorder(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: Obx(() {
                          final file = controller.selectedFileName.value;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // 🎯 Icon with Glow
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withOpacity(0.1),
                                ),
                                child: Icon(
                                  file.isEmpty
                                      ? Icons.cloud_upload_rounded
                                      : file.toLowerCase().endsWith('.pdf')
                                      ? Icons.picture_as_pdf
                                      : Icons.image,
                                  size: 40,
                                  color: Colors.blueAccent,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                file.isEmpty
                                    ? "Tap to Upload"
                                    : file,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: file.isEmpty
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),

                              if (file.isNotEmpty)
                                TextButton(
                                  onPressed: () =>
                                  controller.selectedFileName.value = "",
                                  child: const Text(
                                    "Remove",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 📊 Upload Status
              Obx(() {
                if (!controller.isUploading.value) return const SizedBox();

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text(
                            "Uploading...",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Spacer(),

              // 🚀 Premium Button
              Obx(() {
                final disabled = controller.selectedFileName.value.isEmpty ||
                    controller.isUploading.value;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: disabled
                        ? LinearGradient(
                        colors: [Colors.grey[300]!, Colors.grey[400]!])
                        : const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                    ),
                    boxShadow: disabled
                        ? []
                        : [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: disabled
                        ? null
                        : () => controller.uploadReport(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      controller.isUploading.value
                          ? "PROCESSING..."
                          : "UPLOAD REPORT",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
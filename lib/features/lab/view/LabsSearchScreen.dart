import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/LabsSearchController.dart';
import 'LabDetailScreen.dart';

class LabsSearchScreen extends StatelessWidget {
  final controller = Get.put(LabsSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Search Labs",
          style: GoogleFonts.poppins(
            color: primaryDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              height: 45, // Compact height for search bar
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: "Search for ShobiLab, Apollo...",
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: primaryTeal, size: 20),
                  filled: true,
                  fillColor: lightBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.filteredLabs.isEmpty) {
          return _noLabsFound();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: controller.filteredLabs.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var lab = controller.filteredLabs[index];
            return _labListItem(lab);
          },
        );
      }),
    );
  }

  Widget _labListItem(Map<String, dynamic> lab) {
    return GestureDetector(
        onTap: () {
          Get.to(
                () => LabDetailScreen(),
            arguments: lab, //
            preventDuplicates: false,
          );
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10), // Reduced padding for compactness
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
          crossAxisAlignment: CrossAxisAlignment.center, // Center aligned for better look
          children: [
            // Lab Logo (Responsive Size)
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: secondaryBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  lab['image'],
                  errorBuilder: (c, e, s) => const Icon(Icons.science, color: primaryTeal),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Lab Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lab['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryDarkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "⭐ ${lab['rating']}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: warningYellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lab['address'],
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Distance and Price Info
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: primaryTeal),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          lab['distance'],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.payments_outlined, size: 12, color: primaryPink),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          lab['priceRange'],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Trust Badges Tags (Using Wrap to prevent Overflow)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: (lab['tags'] as List).map<Widget>((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryTeal.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9,
                            color: primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, curve: Curves.easeOut),
    );
  }

  Widget _noLabsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            "No labs found near you",
            style: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
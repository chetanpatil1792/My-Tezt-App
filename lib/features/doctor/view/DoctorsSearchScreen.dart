import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DoctorsSearchController.dart';
import 'DoctorDetailScreen.dart';

class DoctorsSearchScreen extends StatelessWidget {
  final controller = Get.put(DoctorsSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Search Doctors",
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
              height: 45,
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: "Search for doctors or specialty...",
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
        if (controller.filteredDoctors.isEmpty) {
          return _noDoctorsFound();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: controller.filteredDoctors.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            var doctor = controller.filteredDoctors[index];
            return _doctorListItem(doctor);
          },
        );
      }),
    );
  }

  Widget _doctorListItem(Map<String, dynamic> doctor) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => DoctorDetailScreen(),
          arguments: doctor,
          preventDuplicates: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: secondaryBg,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(doctor['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          doctor['name'],
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
                        "⭐ ${doctor['rating']}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: warningYellow,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    doctor['specialization'],
                    style: const TextStyle(fontSize: 12, color: primaryTeal, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor['experience'],
                    style: const TextStyle(fontSize: 11, color: secondaryText),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: primaryTeal),
                      const SizedBox(width: 2),
                      Text(
                        doctor['distance'],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.payments_outlined, size: 12, color: primaryPink),
                      const SizedBox(width: 2),
                      Text(
                        doctor['priceRange'],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.05, curve: Curves.easeOut),
    );
  }

  Widget _noDoctorsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_rounded, size: 60, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            "No doctors found",
            style: GoogleFonts.poppins(color: secondaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
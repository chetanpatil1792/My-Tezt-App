import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/appcolors.dart';
import '../controller/DoctorController.dart';
import 'dart:math';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String docTag = Get.arguments?['name'] ?? 'default';
    final controller = Get.put(DoctorController(), tag: docTag);
    var data = controller.doctorData;

    return Scaffold(
      backgroundColor: lightBg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(data),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(data),
                      const SizedBox(height: 20),
                      _sectionTitle("About Doctor"),
                      Text(
                        data['about'] ?? "",
                        style: const TextStyle(fontSize: 13, color: secondaryText, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      _sectionTitle("Select Date"),
                      _buildDateSelector(controller),
                      const SizedBox(height: 20),
                      _sectionTitle("Available Slots"),
                      _buildSlotGrid(data, controller),
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildStickyFooter(controller),
        ],
      ),
    );
  }

  Widget _buildHeader(Map data) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: primaryDarkBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 48, bottom: 14),
        title: Text(
          data['name'] ?? "Doctor Details",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              data['image'] ?? "https://cdn.pixabay.com/photo/2017/01/29/21/16/nurse-2019420_1280.jpg",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['specialization'], style: const TextStyle(color: primaryTeal, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(data['education'] ?? "", style: const TextStyle(fontSize: 12, color: secondaryText)),
                  ],
                ),
              ),
              _badge("${data['rating']} ⭐", Icons.star, warningYellow),
            ],
          ),
          const Divider(height: 30),
          _infoRow(Icons.business_rounded, data['hospital'] ?? "", primaryDarkBlue),
          _infoRow(Icons.history_rounded, data['experience'], primaryLightBlue),
          _infoRow(Icons.translate_rounded, (data['languages'] as List).join(", "), primaryPink),
        ],
      ),
    );
  }

  Widget _buildDateSelector(DoctorController controller) {
    List<String> dates = ["Today", "Tomorrow", "24 Oct", "25 Oct", "26 Oct"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (c, i) => Obx(() => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ChoiceChip(
            label: Text(dates[i]),
            selected: controller.selectedDate.value == dates[i],
            onSelected: (val) => controller.selectedDate.value = dates[i],
            selectedColor: primaryDarkBlue,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: controller.selectedDate.value == dates[i] ? Colors.white : primaryDarkBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Colors.grey.shade200),
            showCheckmark: false,
          ),
        )),
      ),
    );
  }

  Widget _buildSlotGrid(Map data, DoctorController controller) {
    List slots = data['slots'] ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 2.2, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (c, i) => Obx(() {
        bool isSelected = controller.selectedTimeSlot.value == slots[i];
        return GestureDetector(
          onTap: () => controller.selectedTimeSlot.value = slots[i],
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isSelected ? primaryTeal : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSelected ? primaryTeal : Colors.grey.shade200)),
            child: Text(slots[i], style: TextStyle(color: isSelected ? Colors.white : primaryText, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        );
      }),
    );
  }

  Widget _buildStickyFooter(DoctorController controller) {
    final List<int> amounts =
    List.generate(40, (index) => (index + 1) * 50); // 50 to 2000

    final int randomAmount = amounts[Random().nextInt(amounts.length)];
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -4))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Consultation Fee", style: TextStyle(color: secondaryText, fontSize: 11)),
                // Text("₹800", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDarkBlue)),

                Text(
                  "₹$randomAmount",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryDarkBlue,
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryLightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Book Appointment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDarkBlue)));

  Widget _infoRow(IconData icon, String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: primaryText, fontWeight: FontWeight.w500)))]),
  );

  Widget _badge(String text, IconData icon, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold))]));
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/appcolors.dart';
import '../controller/LabController.dart';

class LabDetailScreen extends StatelessWidget {
  const LabDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String labTag = Get.arguments?['name'] ?? 'default';
    final controller = Get.put(LabController(), tag: labTag);
    var data = controller.labData;

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
                  padding: const EdgeInsets.all(14.0), // Slightly more compact padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTrustBadges(data),
                      const SizedBox(height: 16),
                      _sectionTitle("Service Options"),
                      _buildBookingTypeSelector(controller),
                      const SizedBox(height: 16),
                      _sectionTitle("Lab Gallery & Facilities"),
                      _buildGallery(data),
                      const SizedBox(height: 10),
                      _buildFacilities(data),
                      const SizedBox(height: 20),
                      _sectionTitle("Search & Categories"),
                      _searchAndCategories(data, controller),
                      const SizedBox(height: 20),
                      _sectionTitle("Available Tests"),
                      _buildTestList(data, controller),
                      const SizedBox(height: 110), // Space for compact footer
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

  // --- PREMIUM HEADER WITH BACKGROUND IMAGE ---
  Widget _buildHeader(Map data) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      elevation: 0,
      backgroundColor: primaryDarkBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 48, bottom: 14),
        title: Text(
          data['name'] ?? "Lab Details",
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Lab Image
            Image.network(
              data['image'] ?? "https://cdn.pixabay.com/photo/2024/07/08/16/28/ai-generated-8881545_1280.jpg",
              fit: BoxFit.cover,
            ),
            // Dark Gradient Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- COMPACT TRUST & RATINGS ---
  Widget _buildTrustBadges(Map data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                children: [
                  if (data['isNabl'] == true) _badge("NABL", Icons.verified, Colors.green),
                  _badge("ISO", Icons.security, primaryTeal),
                ],
              ),
              _badge("${data['rating']} ⭐", Icons.star, warningYellow),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const CircleAvatar(radius: 15, backgroundColor: secondaryBg, child: Icon(Icons.location_on, color: primaryLightBlue, size: 15)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(data['address'] ?? "Address not available", style: const TextStyle(fontSize: 12, color: primaryText, fontWeight: FontWeight.w500), maxLines: 2),
                  Text("${data['distance']} from your location", style: const TextStyle(fontSize: 11, color: secondaryText)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const CircleAvatar(radius: 15, backgroundColor: secondaryBg, child: Icon(Icons.access_time_filled, color: primaryTeal, size: 15)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Open: ${data['timing']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const Text("Mon - Sun", style: TextStyle(fontSize: 11, color: secondaryText)),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  // --- COMPACT SERVICE SELECTOR ---
  Widget _buildBookingTypeSelector(LabController controller) {
    return Obx(() => Row(
      children: [
        _compactTypeCard("Home Collection", Icons.home_filled, controller.isHomeCollection.value, () => controller.toggleBookingType(true)),
        const SizedBox(width: 10),
        _compactTypeCard("Lab Visit", Icons.apartment, !controller.isHomeCollection.value, () => controller.toggleBookingType(false)),
      ],
    ));
  }

  Widget _compactTypeCard(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryTeal : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primaryTeal : Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : secondaryText, size: 18),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: isSelected ? Colors.white : primaryDarkBlue, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  // --- PREMIUM SEARCH & CATEGORIES ---
  Widget _searchAndCategories(Map data, LabController controller) {
    List cats = data['categories'] ?? ["All"];
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search for tests...",
              hintStyle: const TextStyle(fontSize: 13),
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cats.length,
            itemBuilder: (c, i) => Obx(() => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(cats[i]),
                selected: controller.selectedCategory.value == cats[i],
                onSelected: (val) => controller.selectedCategory.value = cats[i],
                selectedColor: primaryDarkBlue,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                    color: controller.selectedCategory.value == cats[i] ? Colors.white : primaryDarkBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide(color: Colors.grey.shade200),
                showCheckmark: false,
              ),
            )),
          ),
        )
      ],
    );
  }

  // --- COMPACT FOOTER ---
  Widget _buildStickyFooter(LabController controller) {
    return Obx(() => controller.cartItems.isEmpty
        ? const SizedBox.shrink()
        : Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                Text("${controller.cartItems.length} Test Selected", style: const TextStyle(color: secondaryText, fontSize: 11)),
                Text("₹${controller.totalPrice.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDarkBlue)),
              ],
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryLightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Book Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            )
          ],
        ),
      ).animate().slideY(begin: 1, duration: 300.ms),
    ));
  }

  // (Saki functions like _buildGallery, _buildFacilities, _buildTestList are same, just padding/font adjustments)
  Widget _buildGallery(Map data) {
    List imgs = data['images'] ?? [];
    return SizedBox(
      height: 100, // Compact height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imgs.length,
        itemBuilder: (c, i) => Container(
          width: 160,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: NetworkImage(imgs[i]), fit: BoxFit.cover)
          ),
        ),
      ),
    );
  }

  Widget _buildFacilities(Map data) {
    List fac = data['facilities'] ?? [];
    return Wrap(
      spacing: 6,
      children: fac.map((f) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade200)),
        child: Text(f, style: const TextStyle(fontSize: 9, color: secondaryText)),
      )).toList(),
    );
  }

  Widget _buildTestList(Map data, LabController controller) {
    List tests = data['tests'] ?? [];
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        var test = tests[index];
        return Obx(() {
          bool isInCart = controller.cartItems.any((item) => item['name'] == test['name']);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isInCart ? primaryTeal.withOpacity(0.5) : Colors.transparent),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(test['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14))),
                    Text("₹${test['discountPrice']}", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryDarkBlue, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Report in ${test['tat']}", style: const TextStyle(fontSize: 10, color: secondaryText)),
                    GestureDetector(
                      onTap: () => controller.toggleTestInCart(test),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isInCart ? Colors.grey.shade100 : primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(isInCart ? "Remove" : "Add", style: TextStyle(color: isInCart ? Colors.red : primaryTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDarkBlue)));

  Widget _badge(String text, IconData icon, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 4), Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold))]));
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import '../../../core/constants/appcolors.dart';
// import '../controller/LabController.dart';
//
// class LabDetailScreen extends StatelessWidget {
//   const LabDetailScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final String labTag = Get.arguments?['name'] ?? 'default';
//     final controller = Get.put(LabController(), tag: labTag);
//     var data = controller.labData;
//
//     return Scaffold(
//       backgroundColor: lightBg,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildHeader(data),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTrustBadges(data),
//                       const SizedBox(height: 20),
//                       _sectionTitle("Service Options"),
//                       _buildBookingTypeSelector(controller),
//                       const SizedBox(height: 20),
//                       _sectionTitle("Lab Gallery & Facilities"),
//                       _buildGallery(data),
//                       const SizedBox(height: 12),
//                       _buildFacilities(data),
//                       const SizedBox(height: 25),
//                       _sectionTitle("Search & Categories"),
//                       _searchAndCategories(data, controller),
//                       const SizedBox(height: 20),
//                       _sectionTitle("Available Tests & Packages"),
//                       _buildTestList(data, controller),
//                       const SizedBox(height: 130),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           _buildStickyFooter(controller),
//         ],
//       ),
//     );
//   }
//
//   // --- HEADER SECTION ---
//   Widget _buildHeader(Map data) {
//     return SliverAppBar(
//       expandedHeight: 180,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: primaryDarkBlue,
//       iconTheme: const IconThemeData(color: Colors.white),
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: false,
//         titlePadding: const EdgeInsets.only(left: 50, bottom: 16),
//         title: Text(data['name'] ?? "Lab Details",
//             style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryDarkBlue, primaryLightBlue]))),
//             Opacity(opacity: 0.1, child: Image.network("https://www.transparenttextures.com/patterns/cubes.png", repeat: ImageRepeat.repeat)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- TRUST & RATINGS ---
//   Widget _buildTrustBadges(Map data) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               if (data['isNabl'] == true) _badge("NABL Accredited", Icons.verified, Colors.green),
//               const SizedBox(width: 8),
//               _badge("ISO Certified", Icons.security, primaryTeal),
//               const Spacer(),
//               _badge("${data['rating']} ⭐", Icons.star, warningYellow),
//             ],
//           ),
//           const Divider(height: 30),
//           Row(
//             children: [
//               const CircleAvatar(radius: 20, backgroundColor: secondaryBg, child: Icon(Icons.location_on, color: primaryLightBlue, size: 20)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(data['address'] ?? "Address not available", style: const TextStyle(fontSize: 12, color: primaryText, fontWeight: FontWeight.w500), maxLines: 2),
//                   Text("${data['distance']} from your location", style: const TextStyle(fontSize: 11, color: secondaryText)),
//                 ]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               const CircleAvatar(radius: 20, backgroundColor: secondaryBg, child: Icon(Icons.access_time_filled, color: primaryTeal, size: 20)),
//               const SizedBox(width: 12),
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text("Open: ${data['timing']}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//                 const Text("Mon - Sun", style: TextStyle(fontSize: 11, color: secondaryText)),
//               ]),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // --- SERVICE SELECTOR ---
//   Widget _buildBookingTypeSelector(LabController controller) {
//     return Obx(() => Row(
//       children: [
//         _typeCard("Home Collection", Icons.home_repair_service_rounded, controller.isHomeCollection.value, () => controller.toggleBookingType(true)),
//         const SizedBox(width: 12),
//         _typeCard("Lab Visit", Icons.apartment_rounded, !controller.isHomeCollection.value, () => controller.toggleBookingType(false)),
//       ],
//     ));
//   }
//
//   // --- GALLERY & FACILITIES ---
//   Widget _buildGallery(Map data) {
//     List imgs = data['images'] ?? [];
//     return SizedBox(
//       height: 120,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         itemCount: imgs.length,
//         itemBuilder: (c, i) => Container(
//           width: 200,
//           margin: const EdgeInsets.only(right: 12),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               image: DecorationImage(image: NetworkImage(imgs[i]), fit: BoxFit.cover)
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFacilities(Map data) {
//     List fac = data['facilities'] ?? [];
//     return Wrap(
//       spacing: 8,
//       children: fac.map((f) => Chip(
//         label: Text(f, style: const TextStyle(fontSize: 10, color: secondaryText)),
//         backgroundColor: Colors.white,
//         side: BorderSide(color: Colors.grey.shade200),
//       )).toList(),
//     );
//   }
//
//   // --- TEST LIST ---
//   Widget _buildTestList(Map data, LabController controller) {
//     List tests = data['tests'] ?? [];
//     return ListView.builder(
//       shrinkWrap: true,
//       padding: EdgeInsets.zero,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: tests.length,
//       itemBuilder: (context, index) {
//         var test = tests[index];
//         return Obx(() {
//           bool isInCart = controller.cartItems.any((item) => item['name'] == test['name']);
//           int discount = ((1 - (test['discountPrice'] / test['originalPrice'])) * 100).toInt();
//
//           return Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: isInCart ? primaryTeal : Colors.transparent, width: 1.5),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: Text(test['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16))),
//                     Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: primaryPink.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text("$discount% OFF", style: const TextStyle(color: primaryPink, fontSize: 10, fontWeight: FontWeight.bold))),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(test['description'], style: const TextStyle(fontSize: 12, color: secondaryText)),
//                 const SizedBox(height: 15),
//                 _infoRow(Icons.timer_outlined, "Report in ${test['tat']}", primaryTeal),
//                 _infoRow(Icons.info_outline, test['preInstructions'], warningYellow),
//                 _infoRow(Icons.biotech_outlined, "Sample: ${test['sample']}", primaryLightBlue),
//                 const Divider(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                       Text("₹${test['discountPrice']}", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDarkBlue)),
//                       Text("₹${test['originalPrice']}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 13)),
//                     ]),
//                     ElevatedButton(
//                       onPressed: () => controller.toggleTestInCart(test),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: isInCart ? Colors.grey.shade400 : primaryTeal,
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
//                       ),
//                       child: Text(isInCart ? "Remove" : "Add to Cart", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                     )
//                   ],
//                 ),
//                 if (test['coins'] != null) ...[
//                   const SizedBox(height: 10),
//                   Text("🪙 Earn ${test['coins']} Health Coins", style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.w600)),
//                 ]
//               ],
//             ),
//           ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
//         });
//       },
//     );
//   }
//
//   // --- FOOTER ---
//   Widget _buildStickyFooter(LabController controller) {
//     return Obx(() => controller.cartItems.isEmpty
//         ? const SizedBox.shrink()
//         : Positioned(
//       bottom: 0, left: 0, right: 0,
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))],
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("${controller.cartItems.length} Test Selected", style: const TextStyle(color: secondaryText, fontSize: 12, fontWeight: FontWeight.w600)),
//                 Text("Total: ₹${controller.totalPrice.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDarkBlue)),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryLightBlue,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               ),
//               child: const Text("Book Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//             )
//           ],
//         ),
//       ).animate().slideY(begin: 1),
//     ));
//   }
//
//   // --- WIDGET HELPERS ---
//   Widget _infoRow(IconData icon, String text, Color color) => Padding(
//     padding: const EdgeInsets.only(bottom: 6),
//     child: Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontSize: 11, color: secondaryText)))]),
//   );
//
//   Widget _badge(String text, IconData icon, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(icon, size: 14, color: color), const SizedBox(width: 5), Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold))]));
//
//   Widget _typeCard(String title, IconData icon, bool isSelected, VoidCallback onTap) => Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 20), decoration: BoxDecoration(color: isSelected ? primaryTeal : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? primaryTeal : Colors.grey.shade200)), child: Column(children: [Icon(icon, color: isSelected ? Colors.white : secondaryText, size: 28), const SizedBox(height: 8), Text(title, style: TextStyle(color: isSelected ? Colors.white : primaryDarkBlue, fontWeight: FontWeight.bold, fontSize: 13))]))));
//
//   Widget _searchAndCategories(Map data, LabController controller) {
//     List cats = data['categories'] ?? ["All"];
//     return Column(children: [
//       TextField(decoration: InputDecoration(hintText: "Search for tests...", prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
//       const SizedBox(height: 15),
//       SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: cats.length, itemBuilder: (c, i) => Obx(() => Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: ActionChip(label: Text(cats[i]), onPressed: () => controller.selectedCategory.value = cats[i], backgroundColor: controller.selectedCategory.value == cats[i] ? primaryDarkBlue : Colors.white, labelStyle: TextStyle(color: controller.selectedCategory.value == cats[i] ? Colors.white : primaryDarkBlue, fontSize: 12, fontWeight: FontWeight.w600), side: BorderSide(color: Colors.grey.shade200), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
//       )))
//     ]);
//   }
//
//   Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: primaryDarkBlue)));
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/appcolors.dart';
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
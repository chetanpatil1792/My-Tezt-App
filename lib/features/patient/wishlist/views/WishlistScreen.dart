import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/WishlistController.dart';

class WishlistScreen extends StatelessWidget {
  final controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text("Wishlist",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 18)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.wishlist.isEmpty) return _emptyWishlist();

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) => _buildWishlistLabCard(controller.wishlist[index]),
        );
      }),
    );
  }

  // --- Confirmation Popup Logic ---
  void _showDeleteConfirmation({required int labId, int? testId, int? packageId, required String itemName}) {
    Get.defaultDialog(
      title: "Remove Item?",
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
      middleText: "Are you sure you want to remove '$itemName' from your wishlist?",
      middleTextStyle: GoogleFonts.poppins(fontSize: 13),
      backgroundColor: Colors.white,
      radius: 15,
      contentPadding: const EdgeInsets.all(20),
      textCancel: "Cancel",
      textConfirm: "Remove",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.back(); // Close Dialog
        controller.removeWishlistItem(labId: labId, testId: testId, packageId: packageId);
      },
    );
  }

  Widget _buildWishlistLabCard(Map lab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF2A5C82).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.science_outlined, color: Color(0xFF2A5C82)),
            ),
            title: Text(lab['labName'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Text("${lab['location']}, ${lab['city']}", style: GoogleFonts.poppins(fontSize: 11)),
          ),
          const Divider(height: 1),
          _buildExpandableSection(labId: lab['labId'], title: "Wishlisted Tests", items: lab['tests'] ?? [], isPackage: false),
          _buildExpandableSection(labId: lab['labId'], title: "Wishlisted Packages", items: lab['packages'] ?? [], isPackage: true),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.bookNow(lab),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A5C82),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("PROCEED TO BOOKING", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpandableSection({required int labId, required String title, required List items, required bool isPackage}) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text("$title (${items.length})", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
        children: items.map((item) {
          String name = isPackage ? item['packageName'] : item['testName'];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                      Text("₹${item['price']}", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF059669))),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _showDeleteConfirmation(
                      labId: labId,
                      testId: isPackage ? null : item['labTestId'],
                      packageId: isPackage ? item['labPackageMasterId'] : null,
                      itemName: name
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _emptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("Wishlist is empty", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => Get.back(), child: const Text("Go Back"))
        ],
      ),
    );
  }
}
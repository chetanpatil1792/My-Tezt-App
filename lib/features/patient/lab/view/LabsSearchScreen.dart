// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../controller/LabsSearchController.dart';
// import '../model/LabSearchModel.dart';
//
// class LabsSearchScreen extends StatelessWidget {
//   final controller = Get.put(LabsSearchController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC), // Ultra light blue-grey background
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         title: Text("Choose Laboratory",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 20)),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(80),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
//               ),
//               child: TextField(
//                 onChanged: (v) => controller.searchQuery.value = v,
//                 style: GoogleFonts.poppins(fontSize: 14),
//                 decoration: InputDecoration(
//                   hintText: "Search lab name, location or city...",
//                   hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
//                   prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2A5C82)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 15),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF2A5C82)));
//
//         final labs = controller.filteredLabs;
//         if (labs.isEmpty) return _buildEmptyState();
//
//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//           itemCount: labs.length,
//           itemBuilder: (context, index) => _buildLabCard(labs[index]),
//         );
//       }),
//     );
//   }
//
//   Widget _buildLabCard(LabSearchModel lab) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.grey.shade100),
//         boxShadow: [BoxShadow(color: const Color(0xFF2A5C82).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
//       ),
//       child: Column(
//         children: [
//           // Lab Header Info
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 _buildLabIcon(),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(lab.labName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF1E293B))),
//                       const SizedBox(height: 2),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on_rounded, size: 14, color: Colors.blueGrey),
//                           const SizedBox(width: 4),
//                           Expanded(child: Text("${lab.location}, ${lab.city}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey), overflow: TextOverflow.ellipsis)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildTATBadge(lab.tatTime),
//               ],
//             ),
//           ),
//
//           // Action Buttons (Directions)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => _openMap(lab.latitude, lab.longitude),
//                     icon: const Icon(Icons.directions_rounded, size: 16),
//                     label: Text("Directions • ${lab.distanceKm.toStringAsFixed(1)} km", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0,
//                       backgroundColor: const Color(0xFFEFF6FF),
//                       foregroundColor: const Color(0xFF2563EB),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 _iconActionButton(
//                   Icons.favorite_border_rounded,
//                   Colors.pinkAccent,
//                       () {
//                     controller.addToCart(lab.labId, isWishlist: true);
//                   },
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 12),
//           const Divider(height: 1, thickness: 0.5),
//
//           // Separate Expansion for Tests
//           _buildExpansionSection(
//             lab: lab,
//             title: "Available Tests",
//             count: lab.tests.length,
//             icon: Icons.biotech_rounded,
//             items: lab.tests,
//           ),
//
//           const Divider(height: 1, thickness: 0.5),
//
//           // Separate Expansion for Packages
//           _buildExpansionSection(
//             lab: lab,
//             title: "Health Packages",
//             count: lab.packages.length,
//             icon: Icons.inventory_2_rounded,
//             items: lab.packages,
//           ),
//
//           // Slot Booking UI
//           _buildBookingArea(lab.labId),
//
//           // Premium Footer (Cart)
//           _buildCartFooter(lab.labId),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExpansionSection({required LabSearchModel lab, required String title, required int count, required IconData icon, required List items}) {
//     if (count == 0) return const SizedBox.shrink();
//     return Theme(
//       data: ThemeData().copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         leading: Icon(icon, size: 20, color: const Color(0xFF2A5C82)),
//         title: Text("$title ($count)", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
//         childrenPadding: const EdgeInsets.only(bottom: 10),
//         children: items.map((item) => _itemRow(lab.labId, item)).toList(),
//       ),
//     );
//   }
//
//   Widget _itemRow(int labId, dynamic item) {
//     return Obx(() {
//       final isSelected = (controller.labCart[labId]?['items'] as List?)?.contains(item) ?? false;
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFF0F7FF) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent),
//         ),
//         child: CheckboxListTile(
//           value: isSelected,
//           onChanged: (_) => controller.toggleItem(labId, item),
//           title: Text(item is TestModel ? item.testName : item.packageName, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
//           secondary: Text("₹${item.price.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF059669))),
//           controlAffinity: ListTileControlAffinity.leading,
//           activeColor: const Color(0xFF2A5C82),
//           dense: true,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     });
//   }
//
//   Widget _buildBookingArea(int labId) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(0)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Preferred Booking Slot", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               _pickerBtn(labId, "date", Icons.calendar_today_rounded, "Date"),
//               const SizedBox(width: 8),
//               _pickerBtn(labId, "fromTime", Icons.login_rounded, "From"),
//               const SizedBox(width: 8),
//               _pickerBtn(labId, "toTime", Icons.logout_rounded, "To"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _pickerBtn(int labId, String key, IconData icon, String label) {
//     return Expanded(
//       child: InkWell(
//         onTap: () async {
//           if (key == "date") {
//             DateTime? d = await showDatePicker(
//                 context: Get.context!,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(30.days)
//             );
//             if (d != null) {
//               // Yahan hum YYYY-MM-DD save kar rahe hain (Controller isse format kar lega)
//               String formatted = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
//               controller.updateDetail(labId, key, formatted);
//             }
//           } else {
//             // --- TIME PICKER CHANGE STARTS HERE ---
//             TimeOfDay? t = await showTimePicker(
//                 context: Get.context!,
//                 initialTime: TimeOfDay.now()
//             );
//
//             if (t != null) {
//               // Isse format hamesha "HH:mm" (24-hour) rahega, chahe phone ki setting kuch bhi ho
//               final String hour = t.hour.toString().padLeft(2, '0');
//               final String minute = t.minute.toString().padLeft(2, '0');
//               String formattedTime = "$hour:$minute";
//
//               controller.updateDetail(labId, key, formattedTime);
//             }
//             // --- TIME PICKER CHANGE ENDS HERE ---
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Obx(() {
//             String val = controller.labCart[labId]?[key] ?? "";
//             return Column(
//               children: [
//                 Icon(icon, size: 14, color: const Color(0xFF2A5C82)),
//                 const SizedBox(height: 4),
//                 Text(
//                     val.isEmpty ? label : val,
//                     style: GoogleFonts.poppins(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: val.isEmpty ? Colors.grey : Colors.black87
//                     )
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCartFooter(int labId) {
//     return Obx(() {
//       double total = controller.getLabTotal(labId);
//       int count = (controller.labCart[labId]?['items'] as List?)?.length ?? 0;
//       bool isAdding = controller.isAddingToCart[labId] ?? false;
//
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: const BoxDecoration(
//           color: Color(0xFF1E293B), // Dark Slate footer
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("$count Items Selected", style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 11)),
//                 Text("₹${total.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: (count > 0 && !isAdding) ? () => controller.addToCart(labId) : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF3B82F6),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 disabledBackgroundColor: Colors.grey.shade700,
//               ),
//               child: isAdding
//                   ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                   : Text("ADD TO CART", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _buildLabIcon() {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
//       child: const Icon(Icons.science_rounded, color: Color(0xFF2A5C82), size: 24),
//     );
//   }
//
//   Widget _buildTATBadge(int time) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         children: [
//           Text("$time hrs", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
//           Text("TAT", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.orange.shade800)),
//         ],
//       ),
//     );
//   }
//
//   Widget _iconActionButton(IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(icon, size: 18, color: color),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           Text("No laboratories found", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
//         ],
//       ),
//     );
//   }
//
//   void _openMap(double lat, double lng) async {
//     final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
//     final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";
//
//     try {
//       if (GetPlatform.isAndroid) {
//         final Uri intentUri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");
//         if (await canLaunchUrl(intentUri)) {
//           await launchUrl(intentUri);
//         } else {
//           await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
//         }
//       } else if (GetPlatform.isIOS) {
//         if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
//           await launchUrl(Uri.parse(appleMapsUrl));
//         } else {
//           await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
//         }
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Could not open maps application");
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/LabsSearchController.dart';
import '../model/LabSearchModel.dart';

class LabsSearchScreen extends StatelessWidget {
  final controller = Get.put(LabsSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text("Choose Laboratory",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 20)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
              ),
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search lab name, location or city...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2A5C82)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: Color(0xFF2A5C82)));

        final labs = controller.filteredLabs;
        if (labs.isEmpty) return _buildEmptyState();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          itemCount: labs.length,
          itemBuilder: (context, index) => _buildLabCard(labs[index]),
        );
      }),
    );
  }

  Widget _buildLabCard(LabSearchModel lab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: const Color(0xFF2A5C82).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          // Lab Header Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildLabIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lab.labName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF1E293B))),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 14, color: Colors.blueGrey),
                          const SizedBox(width: 4),
                          Expanded(child: Text("${lab.location}, ${lab.city}", style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueGrey), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildTATBadge(lab.tatTime),
              ],
            ),
          ),

          // Action Buttons (Directions & Wishlist)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openMap(lab.latitude, lab.longitude),
                    icon: const Icon(Icons.directions_rounded, size: 16),
                    label: Text("Directions • ${lab.distanceKm.toStringAsFixed(1)} km", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFEFF6FF),
                      foregroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // --- WISHLIST BUTTON WITH OBX LOADER ---
                Obx(() {
                  bool isWishlisting = controller.isAddingToWishlist[lab.labId] ?? false;
                  return _iconActionButton(
                    isWishlisting ? Icons.hourglass_empty_rounded : Icons.favorite_border_rounded,
                    isWishlisting ? Colors.grey : Colors.pinkAccent,
                        () => controller.addToCart(lab.labId, isWishlist: true),
                    isLoading: isWishlisting,
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 0.5),

          _buildExpansionSection(
            lab: lab,
            title: "Available Tests",
            count: lab.tests.length,
            icon: Icons.biotech_rounded,
            items: lab.tests,
          ),

          const Divider(height: 1, thickness: 0.5),

          _buildExpansionSection(
            lab: lab,
            title: "Health Packages",
            count: lab.packages.length,
            icon: Icons.inventory_2_rounded,
            items: lab.packages,
          ),

          _buildBookingArea(lab.labId),

          _buildCartFooter(lab.labId),
        ],
      ),
    );
  }

  Widget _buildExpansionSection({required LabSearchModel lab, required String title, required int count, required IconData icon, required List items}) {
    if (count == 0) return const SizedBox.shrink();
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, size: 20, color: const Color(0xFF2A5C82)),
        title: Text("$title ($count)", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: items.map((item) => _itemRow(lab.labId, item)).toList(),
      ),
    );
  }

  Widget _itemRow(int labId, dynamic item) {
    return Obx(() {
      final isSelected = (controller.labCart[labId]?['items'] as List?)?.contains(item) ?? false;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F7FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent),
        ),
        child: CheckboxListTile(
          value: isSelected,
          onChanged: (_) => controller.toggleItem(labId, item),
          title: Text(item is TestModel ? item.testName : item.packageName, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
          secondary: Text("₹${item.price.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF059669))),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF2A5C82),
          dense: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    });
  }

  Widget _buildBookingArea(int labId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Preferred Booking Slot", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          Row(
            children: [
              _pickerBtn(labId, "date", Icons.calendar_today_rounded, "Date"),
              const SizedBox(width: 8),
              _pickerBtn(labId, "fromTime", Icons.login_rounded, "From"),
              const SizedBox(width: 8),
              _pickerBtn(labId, "toTime", Icons.logout_rounded, "To"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickerBtn(int labId, String key, IconData icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (key == "date") {
            DateTime? d = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(30.days)
            );
            if (d != null) {
              String formatted = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
              controller.updateDetail(labId, key, formatted);
            }
          } else {
            TimeOfDay? t = await showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now()
            );
            if (t != null) {
              final String hour = t.hour.toString().padLeft(2, '0');
              final String minute = t.minute.toString().padLeft(2, '0');
              controller.updateDetail(labId, key, "$hour:$minute");
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Obx(() {
            String val = controller.labCart[labId]?[key] ?? "";
            return Column(
              children: [
                Icon(icon, size: 14, color: const Color(0xFF2A5C82)),
                const SizedBox(height: 4),
                Text(
                    val.isEmpty ? label : val,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: val.isEmpty ? Colors.grey : Colors.black87
                    )
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCartFooter(int labId) {
    return Obx(() {
      double total = controller.getLabTotal(labId);
      int count = (controller.labCart[labId]?['items'] as List?)?.length ?? 0;
      bool isAdding = controller.isAddingToCart[labId] ?? false;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$count Items Selected", style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 11)),
                Text("₹${total.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            ElevatedButton(
              onPressed: (count > 0 && !isAdding) ? () => controller.addToCart(labId) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: Colors.grey.shade700,
              ),
              child: isAdding
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("ADD TO CART", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      );
    });
  }

  Widget _iconActionButton(IconData icon, Color color, VoidCallback onTap, {bool isLoading = false}) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: color))
            : Icon(icon, size: 18, color: color),
      ),
    );
  }

  Widget _buildLabIcon() => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
    child: const Icon(Icons.science_rounded, color: Color(0xFF2A5C82), size: 24),
  );

  Widget _buildTATBadge(int time) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
    child: Column(
      children: [
        Text("$time hrs", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
        Text("TAT", style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.orange.shade800)),
      ],
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text("No laboratories found", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey)),
      ],
    ),
  );

  void _openMap(double lat, double lng) async {
    final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

    if (GetPlatform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
      }
    } else {
      if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        await launchUrl(Uri.parse(appleMapsUrl));
      }
    }
  }
}
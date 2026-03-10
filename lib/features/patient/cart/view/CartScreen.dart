// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controller/CartController.dart';
// import 'PaymentPage.dart';
//
// class CartScreen extends StatelessWidget {
//   final controller = Get.put(CartController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F5F9),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 18),
//           onPressed: () => Get.back(),
//         ),
//         title: Text("My Cart",
//             style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 18)),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
//         if (controller.cartItems.isEmpty) return _buildEmptyCart();
//
//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: controller.cartItems.length,
//                 itemBuilder: (context, index) => _buildCartCard(controller.cartItems[index]),
//               ),
//             ),
//             _buildTotalBottomBar(),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildCartCard(Map<String, dynamic> data) {
//     final lab = data['lab'] ?? {};
//     final tests = data['tests'] as List? ?? [];
//     final packages = data['packages'] as List? ?? [];
//     final int cartId = data['id'] ?? 0;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(lab['labName']?.toString() ?? "Unknown Lab",
//                           style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF0F172A))),
//                       Text("Lab ID: ${lab['labId'] ?? 'N/A'}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                       Text(lab['address'] ?? "", style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(20)),
//                   child: const Text("LAB", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
//                 )
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
//             child: Text("Tests & Packages", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6))),
//           ),
//           const Divider(),
//           ...tests.map((t) => _buildTestItem(t, cartId, "test")),
//           ...packages.map((p) => _buildTestItem(p, cartId, "package")),
//           _buildScheduleSection(cartId),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTestItem(Map<String, dynamic> item, int cartId, String type) {
//     final dynamic rawId = item['labTestId'] ?? item['labPackageMasterId'];
//     final int? itemId = rawId is int ? rawId : int.tryParse(rawId.toString());
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Obx(() => Checkbox(
//                 value: itemId != null ? controller.selectedItemIds.contains(itemId) : false,
//                 activeColor: const Color(0xFF3B82F6),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                 onChanged: (bool? checked) {
//                   if (itemId != null) {
//                     controller.toggleItemSelection(itemId);
//                   }
//                 },
//               )),
//               Expanded(
//                 child: Text(item['testName'] ?? item['packageName'] ?? "Unnamed Item",
//                     style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF475569))),
//               ),
//               Text("₹${item['price'] ?? 0}",
//                   style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3B82F6), fontSize: 13)),
//               const SizedBox(width: 8),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
//                 onPressed: () {
//                   if (itemId != null) {
//                     _showDeleteConfirmation(cartId, type, itemId, item['testName'] ?? item['packageName'] ?? "Item");
//                   }
//                 },
//               ),
//             ],
//           ),
//           if (item['description'] != null && item['description'].toString().isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(top: 2, left: 48, right: 12, bottom: 8),
//               padding: const EdgeInsets.all(8),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8FAFC),
//                 border: Border(left: BorderSide(color: Color(0xFF3B82F6), width: 3)),
//               ),
//               child: Text("${item['description']}", style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(int cartId, String type, int itemId, String itemName) {
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Remove Item"),
//         content: Text("Are you sure you want to remove '$itemName' test from your cart?"),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               Get.back();
//               controller.removeItemFromCart(cartId: cartId, type: type, itemId: itemId);
//             },
//             child: const Text("Remove", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget  _buildScheduleSection(int cartId) {
//   //   return Container(
//   //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   //     padding: const EdgeInsets.all(10),
//   //     decoration: BoxDecoration(
//   //       border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
//   //       borderRadius: BorderRadius.circular(8),
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         Row(
//   //           children: [
//   //             const Icon(Icons.calendar_month, size: 14, color: Color(0xFF475569)),
//   //             const SizedBox(width: 6),
//   //             Text("Schedule Collection", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold)),
//   //             const Text(" (Required)", style: TextStyle(color: Colors.red, fontSize: 10)),
//   //           ],
//   //         ),
//   //         const SizedBox(height: 10),
//   //         Obx(() {
//   //           var slots = controller.selectedSlots[cartId] ??
//   //               {"date": "dd/mm/yyyy", "from": "--:-- --", "to": "--:-- --"};
//   //           return Row(
//   //             children: [
//   //               _timeField("Date", slots['date']!, Icons.calendar_today, () async {
//   //                 DateTime? d = await showDatePicker(
//   //                     context: Get.context!,
//   //                     initialDate: DateTime.now(),
//   //                     firstDate: DateTime.now(),
//   //                     lastDate: DateTime.now().add(const Duration(days: 30))
//   //                 );
//   //                 if (d != null) controller.updateSlot(cartId, "date", "${d.day}/${d.month}/${d.year}");
//   //               }),
//   //               const SizedBox(width: 6),
//   //               _timeField("From", slots['from']!, Icons.access_time, () async {
//   //                 TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
//   //                 if (t != null) controller.updateSlot(cartId, "from", t.format(Get.context!));
//   //               }),
//   //               const SizedBox(width: 6),
//   //               _timeField("To", slots['to']!, Icons.access_time, () async {
//   //                 TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
//   //                 if (t != null) controller.updateSlot(cartId, "to", t.format(Get.context!));
//   //               }),
//   //             ],
//   //           );
//   //         }),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildScheduleSection(int cartId) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0F7FF), // Light blue background for visibility
//         border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.event_available, size: 16, color: Color(0xFF1E293B)),
//               const SizedBox(width: 6),
//               Text("Current Schedule", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Obx(() {
//             var slots = controller.selectedSlots[cartId] ??
//                 {"date": "dd/mm/yyyy", "from": "--:--", "to": "--:--"};
//             return Row(
//               children: [
//                 _timeField("Date", slots['date']!, Icons.calendar_today, () async {
//                   DateTime? d = await showDatePicker(
//                       context: Get.context!,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 30))
//                   );
//                   if (d != null) {
//                     String formatted = "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
//                     controller.updateSlot(cartId, "date", formatted);
//                   }
//                 }),
//                 const SizedBox(width: 6),
//                 _timeField("From", slots['from']!, Icons.access_time, () async {
//                   TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
//                   if (t != null) {
//                     final String formattedTime = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//                     controller.updateSlot(cartId, "from", formattedTime);
//                   }
//                 }),
//                 const SizedBox(width: 6),
//                 _timeField("To", slots['to']!, Icons.access_time, () async {
//                   TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
//                   if (t != null) {
//                     final String formattedTime = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
//                     controller.updateSlot(cartId, "to", formattedTime);
//                   }
//                 }),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _timeField(String label, String value, IconData icon, VoidCallback onTap) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//               Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//               decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
//               child: Row(
//                 children: [
//                   Expanded(child: Text(value, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
//                   Icon(icon, size: 10, color: Colors.black54),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalBottomBar() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 11)),
//               Obx(() => Text("₹${controller.grandTotal.toStringAsFixed(2)}",
//                   style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6)))),
//             ],
//           ),
//           Obx(() => ElevatedButton(
//             onPressed: controller.selectedItemIds.isEmpty
//                 ? null
//                 : () => Get.to(() => PaymentPage(totalAmount: controller.grandTotal)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF66BB6A),
//               disabledBackgroundColor: Colors.grey.shade300,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyCart() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           const Text("Cart is empty"),
//           TextButton(onPressed: () => Get.back(), child: const Text("Add Tests")),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/CartController.dart';
import 'PaymentPage.dart';

class CartScreen extends StatelessWidget {
  final controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text("My Cart",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A), fontSize: 18)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.cartItems.isEmpty) return _buildEmptyCart();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) => _buildCartCard(controller.cartItems[index]),
              ),
            ),
            _buildTotalBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildCartCard(Map<String, dynamic> data) {
    final lab = data['lab'] ?? {};
    final tests = data['tests'] as List? ?? [];
    final packages = data['packages'] as List? ?? [];
    final int cartId = data['id'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lab['labName']?.toString() ?? "Unknown Lab",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF0F172A))),
                      Text("Lab ID: ${lab['labId'] ?? 'N/A'}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(lab['address'] ?? "", style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF3B82F6), borderRadius: BorderRadius.circular(20)),
                  child: const Text("LAB", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Text("Tests & Packages", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6))),
          ),
          const Divider(),
          ...tests.map((t) => _buildTestItem(t, cartId, "test")),
          ...packages.map((p) => _buildTestItem(p, cartId, "package")),
          _buildScheduleSection(cartId),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTestItem(Map<String, dynamic> item, int cartId, String type) {
    final dynamic rawId = (type == "test") ? item['labTestId'] : item['labPackageMasterId'];
    final int? itemId = rawId is int ? rawId : int.tryParse(rawId.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(() {
                bool isChecked = (type == "test")
                    ? controller.selectedTestIds.contains(itemId)
                    : controller.selectedPackageIds.contains(itemId);

                return Checkbox(
                  value: itemId != null ? isChecked : false,
                  activeColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (bool? checked) {
                    if (itemId != null) {
                      controller.toggleItemSelection(itemId, type);
                    }
                  },
                );
              }),
              Expanded(
                child: Text(item['testName'] ?? item['packageName'] ?? "Unnamed Item",
                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF475569))),
              ),
              Text("₹${item['price'] ?? 0}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3B82F6), fontSize: 13)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                onPressed: () {
                  if (itemId != null) {
                    _showDeleteConfirmation(cartId, type, itemId, item['testName'] ?? item['packageName'] ?? "Item");
                  }
                },
              ),
            ],
          ),
          if (item['description'] != null && item['description'].toString().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 2, left: 48, right: 12, bottom: 8),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(left: BorderSide(color: Color(0xFF3B82F6), width: 3)),
              ),
              child: Text("${item['description']}", style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int cartId, String type, int itemId, String itemName) {
    Get.dialog(
      AlertDialog(
        title: const Text("Remove Item"),
        content: Text("Are you sure you want to remove '$itemName' from your cart?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeItemFromCart(cartId: cartId, type: type, itemId: itemId);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(int cartId) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_available, size: 16, color: Color(0xFF1E293B)),
              const SizedBox(width: 6),
              Text("Current Schedule", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            var slots = controller.selectedSlots[cartId] ??
                {"date": "dd/mm/yyyy", "from": "--:--", "to": "--:--"};
            return Row(
              children: [
                _timeField("Date", slots['date']!, Icons.calendar_today, () async {
                  DateTime? d = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30))
                  );
                  if (d != null) {
                    String formatted = "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
                    controller.updateSlot(cartId, "date", formatted);
                  }
                }),
                const SizedBox(width: 6),
                _timeField("From", slots['from']!, Icons.access_time, () async {
                  TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
                  if (t != null) {
                    final String formattedTime = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                    controller.updateSlot(cartId, "from", formattedTime);
                  }
                }),
                const SizedBox(width: 6),
                _timeField("To", slots['to']!, Icons.access_time, () async {
                  TimeOfDay? t = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());
                  if (t != null) {
                    final String formattedTime = "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                    controller.updateSlot(cartId, "to", formattedTime);
                  }
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _timeField(String label, String value, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Expanded(child: Text(value, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                  Icon(icon, size: 10, color: Colors.black54),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 11)),
              Obx(() => Text("₹${controller.grandTotal.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6)))),
            ],
          ),
          Obx(() => ElevatedButton(
            onPressed: !controller.isAnyItemSelected
                ? null
                : () => Get.to(() => PaymentPage(totalAmount: controller.grandTotal)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Cart is empty"),
          TextButton(onPressed: () => Get.back(), child: const Text("Add Tests")),
        ],
      ),
    );
  }
}
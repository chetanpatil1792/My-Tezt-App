import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_tezt/routes/app_routes.dart';
import '../../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});
  final controller = Get.put(DashboardController());
  final storage = GetStorage();
  final secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: Scaffold(
        backgroundColor: lightBg,
        body: RefreshIndicator(
          onRefresh: () async => await controller.refreshData(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _sliverPremiumAppBar(controller),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 22),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _healthAnalytics().animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 10),
                    _healthScore().animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 16),
                    _sectionTitle("Our Services"),
                    _quickActions().animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                    const SizedBox(height: 20),
                    _medicineReminder(),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Exit App", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to exit?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () => GetPlatform.isAndroid ? SystemNavigator.pop() : exit(0),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sliverPremiumAppBar(DashboardController controller) {
    const double expandedH = 180;
    const double collapsedH = kToolbarHeight + 10;
    return SliverAppBar(
      pinned: true, expandedHeight: expandedH, collapsedHeight: collapsedH,
      backgroundColor: Colors.transparent, elevation: 0, automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          double t = ((constraints.maxHeight - collapsedH) / (expandedH - collapsedH)).clamp(0.0, 1.0);
          return ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(t * 24)),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [accentText, gradientSkyFaint], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Obx(() => InkWell(
                                onTap: () => Get.toNamed(AppRoutes.profile),
                                child: Hero(
                                  tag: "user_profile_avatar",
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: controller.profileUrl.value,
                                      width: 44, height: 44, fit: BoxFit.cover,
                                      placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                      errorWidget: (_, __, ___) => Container(width: 44, height: 44, color: primaryLightBlue, child: const Icon(Icons.person, color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(() => Text(
                                  "Hi, ${controller.userName.value}",
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: primaryDarkBlue),
                                )),
                              ),
                              _iconBadge(Icons.login),
                            ],
                          ),
                        ),
                        if (t >= 0.3) Opacity(
                          opacity: t,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text("Welcome back to your health hub", style: GoogleFonts.poppins(fontSize: 12, color: secondaryText)),
                              const SizedBox(height: 12),
                              _searchBar(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconBadge(IconData icon) => InkWell(onTap: _showLogoutConfirmation, child: Icon(icon, color: primaryDarkBlue, size: 28));

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async { await storage.erase(); await secureStorage.deleteAll(); Get.offAllNamed(AppRoutes.LOGIN); },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() => Container(
    height: 50, padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
    child: Row(children: [
      const Icon(Icons.search, color: secondaryText, size: 22),
      const SizedBox(width: 10),
      Expanded(child: InkWell(onTap: (){Get.toNamed(AppRoutes.searchLabsScreen);},child: Text("Search tests, labs...", style: GoogleFonts.poppins(color: secondaryText, fontSize: 13)))),
    ]),
  );

  Widget _quickActions() => LayoutBuilder(builder: (context, constraints) {
    return GridView.count(
      padding: EdgeInsets.zero, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: constraints.maxWidth > 600 ? 6 : 4, mainAxisSpacing: 12, crossAxisSpacing: 12,
      children: [
        _actionTile(Icons.biotech, "Labs", primaryTeal, onTap: () => Get.toNamed(AppRoutes.searchLabsScreen)),
        // _actionTile(Icons.video_call, "Doctor", primaryLightBlue, onTap: () => Get.toNamed(AppRoutes.searchDoctorsScreen)),
        _actionTile(Icons.description, "Lab Reports", warningYellow, onTap: () => Get.toNamed(AppRoutes.reportsListPage)),
        _actionTile(Icons.description, "Self Reports", Colors.green, onTap: () => Get.toNamed(AppRoutes.selfReports)),
        _actionTile(Icons.description, "Upload Rep", Colors.blue, onTap: () => Get.toNamed(AppRoutes.uploadReports)),
        Obx(() => _actionTile(Icons.calendar_month, "Cart", accentTeal, badgeCount: controller.cartCount.value, onTap: () => Get.toNamed(AppRoutes.cartScreen))),
        Obx(() => _actionTile(Icons.favorite_border, "Wishlist", errorRed, badgeCount: controller.wishlistCount.value, onTap: () => Get.toNamed(AppRoutes.wishlistScreen))),
        _actionTile(Icons.shopping_cart, "Bookings", primaryLight, onTap: () => Get.toNamed(AppRoutes.bookingScreen)),
        _actionTile(Icons.upcoming, "Upcoming", primaryLight, onTap: () => Get.toNamed(AppRoutes.UpcomingAppointmentsPage)),
        _actionTile(Icons.storage, "Storage", primaryLight, onTap: () => Get.toNamed(AppRoutes.StorageScreen)),
        Obx(() => _actionTile(
            Icons.notification_add, "Notification", primaryLight,
            badgeCount: controller.notificationCount.value,
            onTap: () async {
              await Get.toNamed(AppRoutes.NotificationPage);
              controller.fetchNotificationCount();
            }
        )),
      ],
    );
  });

  Widget _actionTile(IconData icon, String label, Color color, {VoidCallback? onTap, int badgeCount = 0}) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(12),
    child: Stack(
      children: [
        Container(
          width: double.infinity, decoration: _cardStyle(),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 5, top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                badgeCount > 99 ? "99+" : badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ),
  );

  Widget _healthAnalytics() => Obx(() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      _metricCard(icon: Icons.biotech_rounded, label: "Tests", value: controller.totalTests.value, color: primaryTeal),
      _metricCard(icon: Icons.history_rounded, label: "Pending", value: controller.upcomingAppointments.value, color: const Color(0xFFF59E0B)),
      _metricCard(icon: Icons.assignment_rounded, label: "Reports", value: controller.reportsAvailable.value, color: const Color(0xFF6366F1), onTap: () => Get.toNamed(AppRoutes.reportsListPage)),
    ]),
  ));

  Widget _metricCard({required IconData icon, required String label, required int value, required Color color, VoidCallback? onTap}) => Expanded(
    child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 90, margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.1), width: 1.5), boxShadow: [BoxShadow(color: color.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.08), shape: BoxShape.circle), child: Icon(icon, size: 20, color: color)),
          const SizedBox(height: 6),
          Text(value.toString(), style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B), height: 1)),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF64748B))),
        ]),
      ),
    ),
  );

  Widget _healthScore() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: primaryTeal.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      border: Border.all(color: Colors.white.withOpacity(0.5)),
    ),
    child: Row(children: [
      Stack(alignment: Alignment.center, children: [
        SizedBox(width: 55, height: 55, child: CircularProgressIndicator(value: 0.78, strokeWidth: 6, strokeCap: StrokeCap.round, color: primaryTeal, backgroundColor: primaryTeal.withOpacity(0.12))),
        Text("78", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: primaryDarkBlue)),
      ]),
      const SizedBox(width: 20),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Overall Health Score", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: primaryDarkBlue, letterSpacing: -0.2)),
        const SizedBox(height: 2),
        Text("Better than 80% of users", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: secondaryText.withOpacity(0.8))),
      ])),
      Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle), child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryTeal)),
    ]),
  );

  Widget _medicineReminder() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    _sectionTitle("Medication Tracker"),
    Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardStyle().copyWith(gradient: const LinearGradient(colors: [Colors.white, Color(0xFFF8FAFC)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(children: [
        _medicineItem(icon: Icons.wb_twilight_rounded, name: "Vitamin D3 (60K IU)", schedule: "Weekly • After Dinner", time: "08:00 PM", statusColor: const Color(0xFF64748B), isToggleable: true),
        _customDivider(),
        _medicineItem(icon: Icons.light_mode_rounded, name: "Omega 3 Capsule", schedule: "Daily • With Breakfast", time: "09:30 AM", statusColor: primaryTeal.withOpacity(0.7), isDone: true),
        _customDivider(),
        _medicineItem(icon: Icons.grain_rounded, name: "Metformin (500mg)", schedule: "Daily • Before Meals", time: "01:30 PM", statusColor: const Color(0xFF94A3B8)),
        const SizedBox(height: 20),
        _dailyAdherenceProgress(),
      ]),
    ),
  ]);

  Widget _medicineItem({required IconData icon, required String name, required String schedule, required String time, required Color statusColor, bool isToggleable = false, bool isDone = false}) => Row(
    children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: statusColor.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: statusColor, size: 20)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF1E293B))),
        const SizedBox(height: 2),
        Text("$schedule • $time", style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B), letterSpacing: 0.2)),
      ])),
      if (isToggleable) Obx(() => SizedBox(height: 24, child: Switch.adaptive(value: controller.medicineReminder.value, activeColor: primaryTeal, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, onChanged: controller.toggleMedicine)))
      else isDone ? const Icon(Icons.check_circle_rounded, color: Colors.teal, size: 22) : const Icon(Icons.access_time_rounded, color: Color(0xFFCBD5E1), size: 20),
    ],
  );

  Widget _dailyAdherenceProgress() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFFF1F5F9).withOpacity(0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5)),
    child: Row(children: [
      const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(value: 0.33, strokeWidth: 3, color: primaryTeal, backgroundColor: Colors.white)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Today's Progress", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
        Text("1 of 3 doses taken", style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF64748B))),
      ])),
      Text("33%", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTeal)),
    ]),
  );

  Widget _customDivider() => const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, thickness: 0.5, color: Color(0xFFF1F5F9)));
  BoxDecoration _cardStyle() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))]);
  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 10, left: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: primaryDarkBlue)), const Icon(Icons.more_horiz, color: Colors.grey, size: 20)]));
}
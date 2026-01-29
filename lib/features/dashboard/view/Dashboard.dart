import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_tezt/routes/app_routes.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';


class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  Widget _gradientDivider() {
    return Container(
      height: 1.5, // Divider ki thickness
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryTeal.withOpacity(0.1), // Shuruat faint teal se
            primaryTeal,                  // Beech mein dark teal
            primaryLightBlue,             // Phir light blue
            primaryLightBlue.withOpacity(0.1), // Khatam faint blue par
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
  Widget _gradientDivider2() {
    return Container(
      height: 1.5, // Divider ki thickness
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryPink.withOpacity(0.1), // Shuruat faint teal se
            primaryPink,                  // Beech mein dark teal
            primaryTeal,             // Phir light blue
            primaryTeal.withOpacity(0.1), // Khatam faint blue par
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _sliverPremiumAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 22),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _healthAnalytics().animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  _quickActions().animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                  const SizedBox(height: 8),
                  _gradientDivider(),
                  const SizedBox(height: 8),

                  _healthScore().animate().scale(delay: 300.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 16),
                  _vitalsRow().animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 8),
                  _gradientDivider2(),
                  const SizedBox(height: 15),
                  _sectionTitle("Upcoming Appointment"),
                  _upcomingAppointment().animate().slideX(delay: 500.ms),
                  const SizedBox(height: 20),
                  _sectionTitle("Recommended for you"),
                  _recommendedTest(),
                  const SizedBox(height: 20),
                  _sectionTitle("Consult Doctors"),
                  _doctorCards(),
                  const SizedBox(height: 20),
                  _sectionTitle("Medicines & Reminders"),
                  _medicineReminder(),
                  const SizedBox(height: 20),
                  _sectionTitle("Reports & Records"),
                  _reportList(),
                  const SizedBox(height: 25),
                  _emergencyCTA()
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(duration: Duration(seconds: 3), color: Colors.white30)
                      .shake(hz: 1, curve: Curves.easeInOut),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _sliverPremiumAppBar() {
    const double expandedH = 220;
    const double collapsedH = kToolbarHeight + 20; // Sahi pinned height

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedH,
      collapsedHeight: collapsedH,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // t = 1.0 (Poora khula hai), t = 0.0 (Collapse ho gaya hai)
          double t = (constraints.maxHeight - collapsedH) / (expandedH - collapsedH);
          t = t.clamp(0.0, 1.0);

          return ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(t * 24), // Scroll pe radius kam hoga
              bottomRight: Radius.circular(t * 24),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [gradientPinkFaint, gradientSkyFaint],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: SingleChildScrollView( // Overflow rokne ke liye
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: Column(
                      children: [
                        // ================= HEADER (Hamesha visible rahega)
                        SizedBox(
                          height: 50, // Fixed height taaki pinned state mein sahi dikhe
                          child: Row(
                            children: [
                              Hero(
                                tag: "user_profile_avatar",
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: primaryLightBlue,
                                  backgroundImage: const NetworkImage(
                                    "https://cdn.pixabay.com/photo/2017/09/09/14/47/mens-face-2732206_1280.jpg",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(() => Text(
                                  "Hi, ${controller.userName.value}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: primaryDarkBlue,
                                  ),
                                )),
                              ),
                              _iconBadge(Icons.notifications_none_rounded),
                            ],
                          ),
                        ),

                        // ================= EXPANDABLE AREA (Scroll hone pe fade/hide hoga)
                        // Hum yahan 't' check karenge taaki content smoothly hide ho
                        Opacity(
                          opacity: t < 0.3 ? 0 : t, // Smooth fade out logic
                          child: t < 0.3
                              ? const SizedBox.shrink()
                              : Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "Welcome back to your health hub",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: secondaryText,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _searchBar(),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _contextChip(Icons.video_call, "Online Doctor"),
                                    const SizedBox(width: 8),
                                    _contextChip(Icons.science, "Lab Tests"),
                                    const SizedBox(width: 8),
                                    _contextChip(Icons.home, "Home Sample"),
                                  ],
                                ),
                              ),
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
  Widget _iconBadge(IconData icon) {
    return Stack(
      children: [
        Icon(icon, color: primaryDarkBlue, size: 28),
        Positioned(
          right: 4,
          top: 4,
          child: Container(height: 8, width: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
        )
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: secondaryText, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text("Search tests, doctors...", style: GoogleFonts.poppins(color: secondaryText, fontSize: 13))),
          const Icon(Icons.tune_rounded, color: primaryTeal, size: 20),
        ],
      ),
    );
  }

  Widget _quickActions() {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;
      return GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _actionTile(Icons.biotech, "Labs", primaryTeal,onTap: () {Get.toNamed(AppRoutes.searchLabsScreen);}),
          _actionTile(Icons.video_call, "Doctor", primaryLightBlue, onTap: () {Get.toNamed(AppRoutes.searchDoctorsScreen);}),
          _actionTile(Icons.description, "Reports", primaryPink, onTap: () {Get.toNamed(AppRoutes.reportsListPage);}),
          _actionTile(Icons.calendar_month, "Book", warningYellow),
        ],
      );
    });
  }

  // Widget _actionTile(IconData icon, String label, Color color) {
  //   return Container(
  //     decoration: _cardStyle(),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(icon, color: color, size: 28),
  //         const SizedBox(height: 6),
  //         Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
  //       ],
  //     ),
  //   );
  // }
  Widget _actionTile(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap, // Optional: if null, the tile won't be clickable
      borderRadius: BorderRadius.circular(12), // Match this to your _cardStyle radius
      child: Container(
        decoration: _cardStyle(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
                label,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)
            ),
          ],
        ),
      ),
    );
  }
  Widget _metricCard({
    required IconData icon,
    required String label,
    required int value,
    required Color color,
    VoidCallback? onTap, // ⬅️ optional
  }) {
    Widget cardContent = Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color)
              .animate(onPlay: (c) => c.repeat())
              .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.25, 1.25),
            duration: 600.ms,
            curve: Curves.easeInOut,
          )
              .rotate(
            begin: -0.05,
            end: 0.05,
            duration: 600.ms,
            curve: Curves.easeInOut,
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.12, 1.12),
            duration: 800.ms,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );

    // optional onTap ke liye GestureDetector wrap
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: cardContent.animate(
          onPlay: (c) => c.repeat(reverse: true),
        ).slideX(
          begin: -0.03,
          end: 0.03,
          duration: 2200.ms,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }


  Widget _healthAnalytics() {
    return Obx(() => Row(
      children: [
        _metricCard(
          icon: Icons.science_outlined,
          label: "Tests",
          value: controller.totalTests.value,
          color: primaryTeal,
        ),
        _metricCard(
          icon: Icons.schedule_outlined,
          label: "Pending",
          value: controller.upcomingAppointments.value,
          color: warningYellow,
        ),
         _metricCard(
          icon: Icons.description_outlined,
          label: "Reports",
          value: controller.reportsAvailable.value,
          color: primaryPink,
          onTap: (){Get.toNamed(AppRoutes.reportsListPage);}
        ),
      ],
    ));
  }


  Widget _healthScore() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardStyle(),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 0.78,
                strokeWidth: 4,
                color: primaryTeal,
                backgroundColor: primaryTeal.withOpacity(0.1),
              ),
              const Text("78%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overall Health Score", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              Text("Your health is better than 80% of users", style: GoogleFonts.poppins(fontSize: 11, color: secondaryText)),
            ],
          )
        ],
      ),
    );
  }

  Widget _medicineReminder() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardStyle(),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: gradientPinkFaint, child: Icon(Icons.medication, color: primaryPink)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vitamin D3 (Daily)", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                Text("Next dose: 08:00 PM", style: GoogleFonts.poppins(fontSize: 11, color: secondaryText)),
              ],
            ),
          ),
          Obx(() => Switch.adaptive(
            value: controller.medicineReminder.value,
            activeColor: primaryTeal,
            onChanged: (val) => controller.toggleMedicine(val),
          )),
        ],
      ),
    );
  }

  // ============= UTILS & REUSABLE =============

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDarkBlue)),
          const Text("See All", style: TextStyle(color: primaryLightBlue, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
  Widget _contextChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cardBackground.withOpacity(.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primaryLightBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Simplified stubs for remaining UI to keep code clean but functional
  Widget _vitalsRow() => Row(children: [_vital("BP", "120/80"), _vital("Sugar", "98mg"), _vital("BMI", "22.4")]);
  Widget _vital(String l, String v) => Expanded(child: Container(margin: const EdgeInsets.all(4), padding: const EdgeInsets.all(12), decoration: _cardStyle(), child: Column(children: [Text(v, style: const TextStyle(fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(fontSize: 10, color: secondaryText))])));
  Widget _upcomingAppointment() => Container(padding: const EdgeInsets.all(15), decoration: _cardStyle(), child: const Row(children: [Icon(Icons.calendar_today, color: primaryLightBlue), SizedBox(width: 15), Expanded(child: Text("Dr. Sharma - 5:30 PM Today")), Icon(Icons.arrow_forward_ios, size: 14)]));
  Widget _recommendedTest() => Container(padding: const EdgeInsets.all(15), decoration: _cardStyle(), child: const Row(children: [Icon(Icons.science_outlined, color: primaryTeal), SizedBox(width: 15), Expanded(child: Text("Full Body Checkup")), Text("₹999", style: TextStyle(fontWeight: FontWeight.bold, color: primaryTeal))]));
  Widget _doctorCards() => SizedBox(height: 100, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: 5, itemBuilder: (c, i) => Container(width: 90, margin: const EdgeInsets.only(right: 10), decoration: _cardStyle(), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Hero(
      tag: "user_profile_avatar",
      child: CircleAvatar(
        radius: 25,
        backgroundColor: primaryLightBlue,
        backgroundImage: const NetworkImage(
          "https://cdn.pixabay.com/photo/2016/03/27/21/33/woman-1284347_1280.jpg",
        ),
      ),
    ),

    Text("Dr. Avi", style: TextStyle(fontSize: 11))]))));
  Widget _reportList() => Column(children: List.generate(2, (i) => GestureDetector(onTap: () => Get.toNamed(AppRoutes.reportsListPage), child: Container(margin: const EdgeInsets.only(bottom: 8), decoration: _cardStyle(), child: const ListTile(leading: Icon(Icons.picture_as_pdf, color: Colors.red), title: Text("Blood Report"), trailing: Icon(Icons.download))))));
  Widget _emergencyCTA() => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: errorRed, borderRadius: BorderRadius.circular(15)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.emergency, color: Colors.white), SizedBox(width: 10), Text("EMERGENCY CONSULTATION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]));
}
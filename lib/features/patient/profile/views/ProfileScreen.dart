import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import '../../../../core/constants/appcolors.dart';
import '../controller/ProfileController.dart';
import '../models/PatientProfile.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final ProfileController controller = Get.put(ProfileController());
//
//   ProfileScreen({super.key});
//
//   TextStyle aliceStyle({double size = 14, FontWeight weight = FontWeight.normal, Color? color}) {
//     return GoogleFonts.alice(fontSize: size, fontWeight: weight, color: color ?? primaryDarkBlue);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightBg,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [gradientPinkFaint, gradientSkyFaint],
//               begin: Alignment.topLeft, end: Alignment.bottomRight,
//             ),
//           ),
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: primaryDarkBlue, size: 20),
//               onPressed: () => Get.back(),
//             ),
//             title: Text("My Profile", style: aliceStyle(size: 20, weight: FontWeight.bold)),
//             centerTitle: false,
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator(color: primaryTeal));
//         }
//         final user = controller.profile.value;
//         final bool isComplete = (user.completionPercentage ?? 0) >= 100;
//
//         return SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (!isComplete) ...[
//                 if (user.isProfileCompleted == false)
//                   _buildAlertBanner(user.completionPercentage ?? 0)
//                       .animate().fadeIn().slideY(begin: 0.1),
//
//                 const SizedBox(height: 20),
//                 Text("Account Health", style: aliceStyle(size: 18, weight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//
//                 Container(
//                   decoration: _cardStyle(),
//                   child: Column(
//                     children: [
//                       _buildProgressHeader(user.completionPercentage ?? 0),
//                       _gradientDivider(),
//                       _buildStepItem("Basic Profile", "Personal identity details", user.basicProfileCompleted ?? false, Icons.person_outline),
//                       _buildStepItem("Date of Birth", "Required for age-based records", user.dobCompleted ?? false, Icons.calendar_today_outlined),
//                       _buildStepItem("Address Details", "For home sample collection", user.addressCompleted ?? false, Icons.map_outlined),
//                       _buildStepItem("Body Vitals", "Height, Weight & BMI", user.bodyCompleted ?? false, Icons.monitor_weight_outlined),
//                       _buildStepItem("Profile Photo", "Verification for doctors", user.photoCompleted ?? false, Icons.camera_alt_outlined, isLast: true),
//                     ],
//                   ),
//                 ).animate().fadeIn(delay: 200.ms),
//               ] else
//                 _buildFullProfileDetails(user).animate().scale(curve: Curves.easeOutBack),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildFullProfileDetails(dynamic user) {
//     final photoUrl = "${ApiUrls.baseUrlImage}${user.profileImage}";
//
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(20),
//           decoration: _cardStyle(),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [primaryTeal, primaryLightBlue])),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.white,
//                   backgroundImage: (user.profileImage != null && user.profileImage!.isNotEmpty)
//                       ? NetworkImage(photoUrl)
//                       : null,
//                   child: (user.profileImage == null || user.profileImage!.isEmpty)
//                       ? const Icon(Icons.person, size: 50, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Text("${user.firstName} ${user.lastName}", style: aliceStyle(size: 22, weight: FontWeight.bold)),
//               // PATIENT CODE + CARD BUTTON
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(user.patientCode ?? "", style: aliceStyle(size: 14, color: primaryTeal, weight: FontWeight.w600)),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () => controller.fetchMyTeztCard(),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(colors: [primaryTeal, primaryLightBlue]),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text("MY TEZT CARD", style: aliceStyle(size: 10, color: Colors.white, weight: FontWeight.bold)),
//                     ),
//                   ),
//                 ],
//               ),
//               Text(user.patientCode ?? "", style: aliceStyle(size: 14, color: primaryTeal, weight: FontWeight.w600)),
//               const SizedBox(height: 20),
//
//               _buildDetailRow(Icons.phone_iphone, "Mobile", user.mobile ?? "N/A"),
//               _buildDetailRow(Icons.email_outlined, "Username", user.userName ?? "N/A"),
//               _buildDetailRow(Icons.cake_outlined, "DOB", user.dob?.split('T')[0] ?? "N/A"),
//               _buildDetailRow(Icons.wc, "Gender / Blood", "${user.gender} (${user.bloodGroup})"),
//               _buildDetailRow(Icons.height, "Vitals", "H: ${user.height}cm | W: ${user.weight}kg"),
//               _buildDetailRow(Icons.location_on_outlined, "Address", "${user.address1}, ${user.city}"),
//
//               const SizedBox(height: 10),
//               TextButton.icon(
//                 onPressed: () => _showBasicProfilePopup(), // Allow editing
//                 icon: const Icon(Icons.edit, size: 16, color: primaryTeal),
//                 label: Text("Edit Profile", style: aliceStyle(color: primaryTeal, weight: FontWeight.bold)),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: primaryLightBlue),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label, style: aliceStyle(size: 11, color: secondaryText)),
//                 Text(value, style: aliceStyle(size: 14, weight: FontWeight.w500)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildStepItem(String title, String subtitle, bool isDone, IconData icon, {bool isLast = false}) {
//     return Column(
//       children: [
//         ListTile(
//           dense: true,
//           leading: Obx(() {
//             final photoUrl = "${ApiUrls.baseUrlImage}${controller.profile.value.profileImage}";
//             final isPhotoStep = title == "Profile Photo";
//             final hasPhoto = controller.profile.value.profileImage != null && controller.profile.value.profileImage!.isNotEmpty;
//
//             return Hero(
//               tag: "user_profile_avatar_$title",
//               child: CircleAvatar(
//                 radius: 18,
//                 backgroundColor: isDone ? primaryTeal.withOpacity(0.1) : Colors.grey.shade100,
//                 backgroundImage: (isPhotoStep && hasPhoto) ? NetworkImage(photoUrl) : null,
//                 child: (isPhotoStep && hasPhoto) ? null : Icon(icon, color: isDone ? primaryTeal : Colors.grey, size: 18),
//               ),
//             );
//           }),
//           title: Text(title, style: aliceStyle(size: 14, weight: FontWeight.bold)),
//           subtitle: Text(subtitle, style: aliceStyle(size: 11, color: secondaryText)),
//           trailing: isDone
//               ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
//               : SizedBox(
//             height: 28,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (title == "Basic Profile") _showBasicProfilePopup();
//                 if (title == "Date of Birth") _showDOBPopup();
//                 if (title == "Address Details") _showAddressPopup();
//                 if (title == "Body Vitals") _showBodyPopup();
//                 if (title == "Profile Photo") controller.uploadProfilePhoto();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryLightBlue,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//               ),
//               child: Text("Add", style: aliceStyle(size: 11, color: Colors.white, weight: FontWeight.bold)),
//             ),
//           ),
//         ),
//         if (!isLast) Divider(height: 1, indent: 60, color: Colors.grey.shade100),
//       ],
//     );
//   }
//
//   void _showBasicProfilePopup() {
//     final fName = TextEditingController(text: controller.profile.value.firstName);
//     final lName = TextEditingController(text: controller.profile.value.lastName);
//     String? gender = controller.profile.value.gender;
//     String? blood = controller.profile.value.bloodGroup;
//
//     _openBottomSheet("Update Profile", [
//       Row(children: [
//         Expanded(child: _buildCompactField("First Name", fName)),
//         const SizedBox(width: 10),
//         Expanded(child: _buildCompactField("Last Name", lName)),
//       ]),
//       Row(children: [
//         Expanded(child: _buildPremiumDropdown("Gender", ["Male", "Female", "Other"], (v) => gender = v)),
//         const SizedBox(width: 10),
//         Expanded(child: _buildPremiumDropdown("Blood Group", ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"], (v) => blood = v)),
//       ]),
//       _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileBasic, {
//         "firstName": fName.text, "lastName": lName.text,
//         "gender": gender ?? "", "bloodGroup": blood ?? ""
//       })),
//     ]);
//   }
//
//   void _showDOBPopup() {
//     var selectedDateStr = "".obs;
//     DateTime? finalDate;
//     _openBottomSheet("Date of Birth", [
//       Obx(() => _buildActionTile(Icons.calendar_today_outlined, selectedDateStr.value.isEmpty ? "Select Date" : selectedDateStr.value, () async {
//         final DateTime? picked = await showDatePicker(context: Get.context!, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
//         if (picked != null) { finalDate = picked; selectedDateStr.value = "${picked.day}-${picked.month}-${picked.year}"; }
//       })),
//       _buildSaveButton(() {
//         if (finalDate != null) controller.updateProfileSection(ApiUrls.patientProfileDob, {"dob": finalDate!.toIso8601String()});
//       }),
//     ]);
//   }
//
//   void _showAddressPopup() {
//     final a1 = TextEditingController(), city = TextEditingController(), state = TextEditingController(), pin = TextEditingController();
//     _openBottomSheet("Address Details", [
//       _buildCompactField("Address", a1),
//       Row(children: [Expanded(child: _buildCompactField("City", city)), const SizedBox(width: 10), Expanded(child: _buildCompactField("State", state))]),
//       _buildCompactField("Pin Code", pin, type: TextInputType.number),
//       _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileAddress, {"address1": a1.text, "city": city.text, "state": state.text, "country": "India", "pinCode": pin.text})),
//     ]);
//   }
//
//   void _showBodyPopup() {
//     final h = TextEditingController(), w = TextEditingController();
//     String? skin;
//     _openBottomSheet("Body Vitals", [
//       Row(children: [Expanded(child: _buildCompactField("Height (cm)", h, type: TextInputType.number)), const SizedBox(width: 10), Expanded(child: _buildCompactField("Weight (kg)", w, type: TextInputType.number))]),
//       _buildPremiumDropdown("Skin Color", ["Very Fair", "Fair", "Light Brown", "Medium Brown", "Dark Brown", "Deep Dark"], (v) => skin = v),
//       _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileBody, {"height": int.tryParse(h.text) ?? 0, "weight": int.tryParse(w.text) ?? 0, "skinColor": skin ?? ""})),
//     ]);
//   }
//
//   void _openBottomSheet(String title, List<Widget> children) {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//         child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Center(child: Container(width: 35, height: 4, margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
//           Text(title, style: aliceStyle(size: 20, weight: FontWeight.bold)),
//           const SizedBox(height: 15), ...children,
//         ])),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   Widget _buildSaveButton(VoidCallback onTap) {
//     return Obx(() => GestureDetector(
//       onTap: controller.isSubmitting.value ? null : onTap,
//       child: Container(
//         height: 48, width: double.infinity, margin: const EdgeInsets.only(top: 10),
//         decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryTeal, primaryLightBlue]), borderRadius: BorderRadius.circular(12)),
//         child: Center(child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text("Save Details", style: aliceStyle(size: 15, weight: FontWeight.bold, color: Colors.white))),
//       ),
//     ));
//   }
//
//   Widget _buildCompactField(String label, TextEditingController ctr, {TextInputType type = TextInputType.text, bool enabled = true}) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(label, style: aliceStyle(size: 12, weight: FontWeight.bold)), const SizedBox(height: 5),
//       TextField(controller: ctr, keyboardType: type, enabled: enabled, style: aliceStyle(size: 13), decoration: InputDecoration(isDense: true, filled: true, fillColor: enabled ? Colors.grey[50] : Colors.grey[200], contentPadding: const EdgeInsets.all(12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)))),
//       const SizedBox(height: 12),
//     ]);
//   }
//
//   Widget _buildPremiumDropdown(String label, List<String> items, Function(String?) onChanged) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(label, style: aliceStyle(size: 12, weight: FontWeight.bold)), const SizedBox(height: 5),
//       DropdownButtonFormField<String>(icon: const Icon(Icons.expand_more, size: 18, color: primaryTeal), style: aliceStyle(size: 13), decoration: InputDecoration(isDense: true, filled: true, fillColor: Colors.grey[50], contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200))), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: aliceStyle(size: 13)))).toList(), onChanged: onChanged),
//       const SizedBox(height: 12),
//     ]);
//   }
//
//   Widget _buildActionTile(IconData icon, String label, VoidCallback onTap) {
//     return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)), child: Row(children: [Icon(icon, size: 20, color: primaryTeal), const SizedBox(width: 10), Text(label, style: aliceStyle())])));
//   }
//
//   Widget _buildProgressHeader(int percentage) {
//     return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Profile Completion", style: aliceStyle(size: 15, weight: FontWeight.w600)), Text("$percentage%", style: aliceStyle(size: 16, weight: FontWeight.bold, color: primaryTeal))]),
//       const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: percentage / 100, minHeight: 6, backgroundColor: primaryTeal.withOpacity(0.1), color: primaryTeal)),
//     ]));
//   }
//
//   Widget _buildAlertBanner(int percentage) {
//     return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: errorRed.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: errorRed.withOpacity(0.1))), child: Row(children: [const Icon(Icons.error_outline, color: errorRed, size: 18), const SizedBox(width: 10), Expanded(child: Text("Profile $percentage% complete. Add missing info.", style: aliceStyle(size: 11, color: errorRed, weight: FontWeight.w500)))]));
//   }
//
//   Widget _gradientDivider() => Container(height: 1.2, width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryTeal, primaryLightBlue])));
//   BoxDecoration _cardStyle() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]);
// }


class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({super.key});

  TextStyle aliceStyle({double size = 14, FontWeight weight = FontWeight.normal, Color? color}) {
    return GoogleFonts.alice(fontSize: size, fontWeight: weight, color: color ?? primaryDarkBlue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientPinkFaint, gradientSkyFaint],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: primaryDarkBlue, size: 20),
              onPressed: () => Get.back(),
            ),
            title: Text("My Profile", style: aliceStyle(size: 20, weight: FontWeight.bold)),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryTeal));
        }

        final user = controller.profile.value;
        final int completion = user.completionPercentage ?? 0;
        final bool isComplete = completion >= 100;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alert Banner - Dikhao agar incomplete hai
              if (!isComplete)
                _buildAlertBanner(completion).animate().fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 20),

              // Account Health Section (Steps) - Hamesha dikhao jab tak 100% na ho
              if (!isComplete) ...[
                Text("Account Health", style: aliceStyle(size: 18, weight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  decoration: _cardStyle(),
                  child: Column(
                    children: [
                      _buildProgressHeader(completion),
                      _gradientDivider(),
                      _buildStepItem("Basic Profile", "Name, Gender, Blood Group", user.basicProfileCompleted ?? false, Icons.person_outline),
                      _buildStepItem("Date of Birth", "Required for records", user.dobCompleted ?? false, Icons.calendar_today_outlined),
                      _buildStepItem("Address Details", "City, State, Pincode", user.addressCompleted ?? false, Icons.map_outlined),
                      _buildStepItem("Body Vitals", "Height, Weight & Skin", user.bodyCompleted ?? false, Icons.monitor_weight_outlined),
                      _buildStepItem("Profile Photo", "Verification photo", user.photoCompleted ?? false, Icons.camera_alt_outlined, isLast: true),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 25),
              ],

              // Personal Details Section - Sirf 100% hone par dikhega
              if (isComplete) ...[
                Text("Personal Details", style: aliceStyle(size: 18, weight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildFullProfileDetails(user).animate().fadeIn(),
              ],
            ],
          ),
        );
      }),
    );
  }

  // --- Step Items for Single Updates ---
  Widget _buildStepItem(String title, String subtitle, bool isDone, IconData icon, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: isDone ? primaryTeal.withOpacity(0.1) : Colors.grey.shade100,
            child: Icon(icon, color: isDone ? primaryTeal : Colors.grey, size: 18),
          ),
          title: Text(title, style: aliceStyle(size: 14, weight: FontWeight.bold)),
          subtitle: Text(subtitle, style: aliceStyle(size: 11, color: secondaryText)),
          trailing: isDone
              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
              : ElevatedButton(
            onPressed: () {
              // Yahan aapke purane individual popups call honge
              if (title == "Basic Profile") _showBasicProfilePopup();
              if (title == "Date of Birth") _showDOBPopup();
              if (title == "Address Details") _showAddressPopup();
              if (title == "Body Vitals") _showBodyPopup();
              if (title == "Profile Photo") controller.uploadProfilePhoto();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryLightBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 12)
            ),
            child: Text("Add", style: aliceStyle(size: 11, color: Colors.white)),
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 60, color: Colors.grey.shade100),
      ],
    );
  }

  // --- Full Profile View (Only for 100% complete) ---
  Widget _buildFullProfileDetails(PatientProfile user) {
    final photoUrl = "${ApiUrls.baseUrlImage}${user.profileImage}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: primaryTeal.withOpacity(0.1),
            backgroundImage: (user.profileImage != null && user.profileImage!.isNotEmpty)
                ? NetworkImage(photoUrl) : null,
            child: (user.profileImage == null || user.profileImage!.isEmpty)
                ? const Icon(Icons.person, size: 50, color: primaryTeal) : null,
          ),
          const SizedBox(height: 15),
          Text("${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
              style: aliceStyle(size: 20, weight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user.patientCode ?? "NO-ID", style: aliceStyle(size: 14, color: primaryTeal, weight: FontWeight.w600)),
              const SizedBox(width: 10),
              _buildMiniCardButton(),
            ],
          ),
          const Divider(height: 30),
          _buildDetailRow(Icons.phone_android, "Mobile", user.mobile ?? "N/A"),
          _buildDetailRow(Icons.contact_phone_outlined, "Emergency", user.emergencyNumber ?? "N/A"),
          _buildDetailRow(Icons.cake_outlined, "DOB", user.dob?.split('T')[0] ?? "N/A"),
          _buildDetailRow(Icons.wc, "Gender & Blood", "${user.gender} | ${user.bloodGroup}"),
          _buildDetailRow(Icons.height, "Vitals", "H: ${user.height}cm | W: ${user.weight}kg"),
          _buildDetailRow(Icons.location_on_outlined, "Address", "${user.address1}, ${user.city}"),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _showFullUpdatePopup(),
            icon: const Icon(Icons.edit_note),
            label: const Text("Update Full Profile"),
            style: OutlinedButton.styleFrom(foregroundColor: primaryTeal, side: const BorderSide(color: primaryTeal)),
          )
        ],
      ),
    );
  }

  // --- POPUPS (Individual) ---
  void _showBasicProfilePopup() {
    final user = controller.profile.value;
    final fName = TextEditingController(text: user.firstName);
    final lName = TextEditingController(text: user.lastName);
    String? gender = user.gender;
    String? blood = user.bloodGroup;

    _openBottomSheet("Update Basic Info", [
      Row(children: [
        Expanded(child: _buildCompactField("First Name", fName)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("Last Name", lName)),
      ]),
      _buildPremiumDropdown("Gender", ["Male", "Female", "Other"], (v) => gender = v, initialValue: gender),
      _buildPremiumDropdown("Blood Group", ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"], (v) => blood = v, initialValue: blood),
      _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileBasic, {
        "firstName": fName.text, "lastName": lName.text, "gender": gender, "bloodGroup": blood
      })),
    ]);
  }

  void _showDOBPopup() {
    var selectedDateStr = "".obs;
    DateTime? finalDate;
    _openBottomSheet("Date of Birth", [
      Obx(() => _buildActionTile(Icons.calendar_today_outlined, selectedDateStr.value.isEmpty ? "Select Date" : selectedDateStr.value, () async {
        final DateTime? picked = await showDatePicker(context: Get.context!, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
        if (picked != null) { finalDate = picked; selectedDateStr.value = "${picked.day}-${picked.month}-${picked.year}"; }
      })),
      _buildSaveButton(() {
        if (finalDate != null) controller.updateProfileSection(ApiUrls.patientProfileDob, {"dob": finalDate!.toIso8601String()});
      }),
    ]);
  }

  void _showAddressPopup() {
    final user = controller.profile.value;
    final a1 = TextEditingController(text: user.address1);
    final city = TextEditingController(text: user.city);
    final state = TextEditingController(text: user.state);
    final pin = TextEditingController(text: user.pinCode);

    _openBottomSheet("Address Details", [
      _buildCompactField("Address", a1),
      Row(children: [
        Expanded(child: _buildCompactField("City", city)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("State", state)),
      ]),
      _buildCompactField("Pin Code", pin, type: TextInputType.number),
      _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileAddress, {
        "address1": a1.text, "city": city.text, "state": state.text, "country": "India", "pinCode": pin.text
      })),
    ]);
  }

  void _showBodyPopup() {
    final user = controller.profile.value;
    final h = TextEditingController(text: user.height?.toString());
    final w = TextEditingController(text: user.weight?.toString());
    String? skin = user.skinColor;

    _openBottomSheet("Body Vitals", [
      Row(children: [
        Expanded(child: _buildCompactField("Height (cm)", h, type: TextInputType.number)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("Weight (kg)", w, type: TextInputType.number)),
      ]),
      _buildPremiumDropdown("Skin Color", ["Very Fair", "Fair", "Light Brown", "Medium Brown", "Dark Brown"], (v) => skin = v, initialValue: skin),
      _buildSaveButton(() => controller.updateProfileSection(ApiUrls.patientProfileBody, {
        "height": int.tryParse(h.text) ?? 0, "weight": int.tryParse(w.text) ?? 0, "skinColor": skin
      })),
    ]);
  }

  // --- FULL UPDATE POPUP (17 Fields) ---
// --- FULL UPDATE POPUP (17 Fields Included) ---
  void _showFullUpdatePopup() {
    final user = controller.profile.value;

    // Controllers
    final fName = TextEditingController(text: user.firstName);
    final lName = TextEditingController(text: user.lastName);
    final mobile = TextEditingController(text: user.mobile);
    final userName = TextEditingController(text: user.userName);
    final emergency = TextEditingController(text: user.emergencyNumber);
    final addr1 = TextEditingController(text: user.address1);
    final addr2 = TextEditingController(text: user.address2);
    final city = TextEditingController(text: user.city);
    final state = TextEditingController(text: user.state);
    final pin = TextEditingController(text: user.pinCode);
    final height = TextEditingController(text: user.height?.toString());
    final weight = TextEditingController(text: user.weight?.toString());

    // Observables
    var gender = (user.gender ?? "Male").obs;
    var blood = (user.bloodGroup ?? "O+").obs;
    var skin = (user.skinColor ?? "Fair").obs;
    var dob = (user.dob ?? DateTime.now().toIso8601String()).obs;

    _openBottomSheet("Edit Full Profile", [
      // 1. Identity & Contact
      Text("Identity & Contact", style: aliceStyle(weight: FontWeight.bold, color: primaryTeal)),
      const Divider(),
      Row(children: [
        Expanded(child: _buildCompactField("First Name", fName)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("Last Name", lName)),
      ]),
      _buildCompactField("Email / Username", userName, enabled: false),
      Row(children: [
        Expanded(child: _buildCompactField("Mobile No.", mobile, type: TextInputType.phone)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("Emergency No.", emergency, type: TextInputType.phone)),
      ]),
      Obx(() => _buildActionTile(Icons.cake, "DOB: ${dob.value.split('T')[0]}", () async {
        final picked = await showDatePicker(context: Get.context!, initialDate: DateTime.tryParse(dob.value) ?? DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
        if (picked != null) dob.value = picked.toIso8601String();
      })),
      Row(children: [
        Expanded(child: _buildPremiumDropdown("Gender", ["Male", "Female", "Other"], (v) => gender.value = v!, initialValue: gender.value)),
        const SizedBox(width: 10),
        Expanded(child: _buildPremiumDropdown("Blood Group", ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"], (v) => blood.value = v!, initialValue: blood.value)),
      ]),

      const SizedBox(height: 20),
      // 2. Address Details
      Text("Address Details", style: aliceStyle(weight: FontWeight.bold, color: primaryTeal)),
      const Divider(),
      _buildCompactField("Address Line 1", addr1),
      _buildCompactField("Address Line 2 (Optional)", addr2),
      Row(children: [
        Expanded(child: _buildCompactField("City", city)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("State", state)),
      ]),
      _buildCompactField("Pin Code", pin, type: TextInputType.number),

      const SizedBox(height: 20),
      // 3. Body Vitals (Yahan hain height aur weight)
      Text("Body Vitals", style: aliceStyle(weight: FontWeight.bold, color: primaryTeal)),
      const Divider(),
      Row(children: [
        Expanded(child: _buildCompactField("Height (cm)", height, type: TextInputType.number)),
        const SizedBox(width: 10),
        Expanded(child: _buildCompactField("Weight (kg)", weight, type: TextInputType.number)),
      ]),
      _buildPremiumDropdown("Skin Color", ["Very Fair", "Fair", "Light Brown", "Medium Brown", "Dark Brown", "Deep Dark"], (v) => skin.value = v!, initialValue: skin.value),

      const SizedBox(height: 30),
      _buildSaveButton(() {
        controller.updateFullProfile({
          "userName": userName.text,
          "mobile": mobile.text,
          "emergencyNumber": emergency.text,
          "address1": addr1.text,
          "address2": addr2.text,
          "city": city.text,
          "state": state.text,
          "country": "India",
          "pinCode": pin.text,
          "height": int.tryParse(height.text) ?? 0,
          "weight": int.tryParse(weight.text) ?? 0,
          "skinColor": skin.value,
          "firstName": fName.text,
          "lastName": lName.text,
          "bloodGroup": blood.value,
          "gender": gender.value,
          "dob": dob.value
        });
      }),
      const SizedBox(height: 50),
    ]);
  }

  // --- Helper Widgets (UI) ---
  void _openBottomSheet(String title, List<Widget> children) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          Text(title, style: aliceStyle(size: 18, weight: FontWeight.bold)),
          const SizedBox(height: 15),
          Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children))),
        ]),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    return Obx(() => InkWell(
      onTap: controller.isSubmitting.value ? null : onTap,
      child: Container(
        height: 48, width: double.infinity, margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryTeal, primaryLightBlue]), borderRadius: BorderRadius.circular(10)),
        child: Center(child: controller.isSubmitting.value ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text("Save Changes", style: aliceStyle(size: 14, weight: FontWeight.bold, color: Colors.white))),
      ),
    ));
  }

  Widget _buildCompactField(String label, TextEditingController ctr, {TextInputType type = TextInputType.text, bool enabled = true}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: aliceStyle(size: 12, weight: FontWeight.bold)), const SizedBox(height: 5),
      TextField(controller: ctr, keyboardType: type, enabled: enabled, style: aliceStyle(size: 13), decoration: InputDecoration(isDense: true, filled: true, fillColor: enabled ? Colors.grey[50] : Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)))),
      const SizedBox(height: 12),
    ]);
  }

  Widget _buildPremiumDropdown(String label, List<String> items, Function(String?) onChanged, {String? initialValue}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: aliceStyle(size: 12, weight: FontWeight.bold)), const SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: items.contains(initialValue) ? initialValue : null,
        style: aliceStyle(size: 13),
        decoration: InputDecoration(isDense: true, filled: true, fillColor: Colors.grey[50], border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200))),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: aliceStyle(size: 13)))).toList(),
        onChanged: onChanged,
      ),
      const SizedBox(height: 12),
    ]);
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Icon(icon, size: 18, color: primaryLightBlue),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: aliceStyle(size: 10, color: secondaryText)),
          Text(value, style: aliceStyle(size: 13, weight: FontWeight.w600)),
        ])),
      ]),
    );
  }

  Widget _buildActionTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)), child: Row(children: [Icon(icon, size: 20, color: primaryTeal), const SizedBox(width: 10), Text(label, style: aliceStyle())])));
  }

  Widget _buildProgressHeader(int percentage) {
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Completion", style: aliceStyle(size: 14, weight: FontWeight.w600)), Text("$percentage%", style: aliceStyle(size: 14, weight: FontWeight.bold, color: primaryTeal))]),
      const SizedBox(height: 8), ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: percentage / 100, minHeight: 6, backgroundColor: primaryTeal.withOpacity(0.1), color: primaryTeal)),
    ]));
  }

  Widget _buildAlertBanner(int percentage) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))), child: Row(children: [const Icon(Icons.info_outline, color: Colors.orange, size: 20), const SizedBox(width: 10), Expanded(child: Text("Your profile is only $percentage% complete. Fill all details for better services.", style: aliceStyle(size: 12, color: Colors.orange[800], weight: FontWeight.w500)))]));
  }

  Widget _buildMiniCardButton() {
    return GestureDetector(
      onTap: () => controller.fetchMyTeztCard(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryTeal, primaryLightBlue]), borderRadius: BorderRadius.circular(20)),
        child: Text("MY CARD", style: aliceStyle(size: 9, color: Colors.white, weight: FontWeight.bold)),
      ),
    );
  }

  Widget _gradientDivider() => Container(height: 1, width: double.infinity, color: Colors.grey.shade100);
  BoxDecoration _cardStyle() => BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]);
}
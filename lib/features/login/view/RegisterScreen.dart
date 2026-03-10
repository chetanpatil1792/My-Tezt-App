// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/RegisterController.dart';
//
// const kPrimary = Color(0xff2A5C82);
// const kScaffoldBg = Color(0xffFDFDFD);
// const kTextFieldBg = Color(0xffF4F7F9);
// const kTextGrey = Color(0xff64748B);
// const kDarkSlate = Color(0xff1E293B);
//
// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});
//   final controller = Get.put(RegisterController());
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: kScaffoldBg,
//         appBar: AppBar(
//           backgroundColor: kScaffoldBg,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: kDarkSlate),
//             onPressed: () => Get.back(),
//           ),
//           centerTitle: true,
//           title: const Text("Create Account", style: TextStyle(color: kDarkSlate, fontSize: 17, fontWeight: FontWeight.w700)),
//         ),
//         body: Obx(() => Stack(
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 8),
//                 _buildTabToggle(),
//                 const SizedBox(height: 6),
//                 Expanded(
//                   child: TabBarView(
//                     children: [
//                       _buildWrapper(_patientForm()),
//                       _buildWrapper(_labForm()),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (controller.isLoading.value)
//               const Center(child: CircularProgressIndicator(color: kPrimary)),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildTabToggle() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 28),
//       padding: const EdgeInsets.all(4),
//       height: 40,
//       decoration: BoxDecoration(color: kTextFieldBg, borderRadius: BorderRadius.circular(30)),
//       child: TabBar(
//         indicatorSize: TabBarIndicatorSize.tab,
//         indicator: BoxDecoration(borderRadius: BorderRadius.circular(24), color: kPrimary),
//         labelColor: Colors.white,
//         unselectedLabelColor: kTextGrey,
//         labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//         tabs: const [Tab(text: "Patient"), Tab(text: "Laboratory")],
//       ),
//     );
//   }
//
//   Widget _buildWrapper(Widget child) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
//       physics: const BouncingScrollPhysics(),
//       child: child,
//     );
//   }
//
//   Widget _patientForm() {
//     return Column(
//       children: [
//         _input("First Name", Icons.person_outline, controller.pFirstName),
//         const SizedBox(height: 14),
//         _input("Last Name", Icons.person_outline, controller.pLastName),
//         const SizedBox(height: 14),
//         _verifyField("Phone Number", Icons.phone_android_outlined, controller.pPhone, isNumeric: true),
//         const SizedBox(height: 14),
//         _verifyField("Email Address", Icons.alternate_email, controller.pEmail),
//         const SizedBox(height: 14),
//         _input("Password", Icons.lock_outline, controller.pPassword, password: true),
//         const SizedBox(height: 14),
//         _input("Confirm Password", Icons.lock_outline, controller.pConfirmPassword, password: true),
//         const SizedBox(height: 28),
//         _primaryButton("REGISTER AS PATIENT", controller.registerPatient),
//       ],
//     );
//   }
//
//   Widget _labForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _section("LABORATORY INFO"),
//         _input("Laboratory Name", Icons.science_outlined, controller.lName),
//         const SizedBox(height: 14),
//         _verifyField("Phone Number", Icons.phone_outlined, controller.lPhone, isNumeric: true),
//         const SizedBox(height: 14),
//         _verifyField("Email / Username", Icons.email_outlined, controller.lUserEmail),
//         const SizedBox(height: 14),
//         _input("Full Address", Icons.location_on_outlined, controller.lAddress),
//         const SizedBox(height: 14),
//         Row(
//           children: [
//             Expanded(child: _input("Area/Location", Icons.map_outlined, controller.lLocation)),
//             const SizedBox(width: 10),
//             Expanded(child: _input("Pincode", Icons.pin_drop_outlined, controller.lPincode, isNumeric: true)),
//           ],
//         ),
//         const SizedBox(height: 22),
//         _section("SECURITY & COMPLIANCE"),
//         _input("Password", Icons.lock_outline, controller.lPassword, password: true),
//         const SizedBox(height: 14),
//         _input("NABL / Certificate No", Icons.verified_user_outlined, controller.lCertNo, isNumeric: true),
//         const SizedBox(height: 14),
//
//         /// File Upload
//         GestureDetector(
//           onTap: controller.pickCertificate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//             decoration: BoxDecoration(color: kTextFieldBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
//             child: Row(
//               children: [
//                 const Icon(Icons.upload_file_outlined, size: 18, color: kTextGrey),
//                 const SizedBox(width: 10),
//                 Expanded(child: Text(controller.selectedFile.value?.path.split('/').last ?? "Upload Lab Certificate", style: TextStyle(fontSize: 13, color: controller.selectedFile.value != null ? kDarkSlate : Colors.grey))),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 22),
//         _section("SERVICES"),
//         Wrap(
//           spacing: 8,
//           children: [
//             _serviceChip("Home Collection", controller.isHomeCollection),
//             _serviceChip("Online Reports", controller.isOnlineReports),
//             _serviceChip("Emergency", controller.isEmergencyTests),
//           ],
//         ),
//         const SizedBox(height: 28),
//         _primaryButton("REGISTER LABORATORY", controller.registerLab),
//       ],
//     );
//   }
//
//   // --- REUSABLE COMPONENTS ---
//
//   Widget _section(String title) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextGrey, letterSpacing: 1)));
//
//   Widget _input(String hint, IconData icon, TextEditingController ctrl, {bool password = false, bool isNumeric = false}) {
//     return TextFormField(
//       controller: ctrl,
//       obscureText: password,
//       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//       style: const TextStyle(fontSize: 14.5),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
//         prefixIcon: Icon(icon, size: 18, color: kTextGrey),
//         filled: true,
//         fillColor: kTextFieldBg,
//         contentPadding: const EdgeInsets.symmetric(vertical: 14),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
//         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kPrimary)),
//       ),
//     );
//   }
//
//   Widget _verifyField(String hint, IconData icon, TextEditingController ctrl, {bool isNumeric = false}) {
//     return Row(
//       children: [
//         Expanded(child: _input(hint, icon, ctrl, isNumeric: isNumeric)),
//         const SizedBox(width: 8),
//         TextButton(onPressed: () {}, child: const Text("Verify", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
//       ],
//     );
//   }
//
//   Widget _primaryButton(String text, VoidCallback onTap) {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(backgroundColor: kPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//         child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
//       ),
//     );
//   }
//
//   Widget _serviceChip(String label, RxBool value) {
//     return Obx(() => FilterChip(
//       label: Text(label),
//       selected: value.value,
//       onSelected: (v) => value.value = v,
//       selectedColor: kPrimary.withOpacity(0.12),
//       checkmarkColor: kPrimary,
//       labelStyle: TextStyle(fontSize: 11.5, color: value.value ? kPrimary : kTextGrey),
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/RegisterController.dart';

const kPrimary = Color(0xff2A5C82);
const kScaffoldBg = Color(0xffFDFDFD);
const kTextFieldBg = Color(0xffF4F7F9);
const kTextGrey = Color(0xff64748B);
const kDarkSlate = Color(0xff1E293B);

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kScaffoldBg,
        appBar: AppBar(
          backgroundColor: kScaffoldBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: kDarkSlate),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text("Create Account", style: TextStyle(color: kDarkSlate, fontSize: 17, fontWeight: FontWeight.w700)),
        ),
        body: Obx(() => Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                _buildTabToggle(),
                const SizedBox(height: 6),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildWrapper(_patientForm()),
                      _buildWrapper(_labForm()),
                    ],
                  ),
                ),
              ],
            ),

            // Full Screen Loader Overlay
            if (controller.isLoading.value) _buildLoadingOverlay(),
          ],
        )),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: kPrimary),
              const SizedBox(height: 16),
              Text(
                controller.loadingMessage.value,
                style: const TextStyle(fontWeight: FontWeight.w600, color: kDarkSlate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(4),
      height: 40,
      decoration: BoxDecoration(color: kTextFieldBg, borderRadius: BorderRadius.circular(30)),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(borderRadius: BorderRadius.circular(24), color: kPrimary),
        labelColor: Colors.white,
        unselectedLabelColor: kTextGrey,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: const [Tab(text: "Patient"), Tab(text: "Laboratory")],
      ),
    );
  }

  Widget _buildWrapper(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }

  Widget _patientForm() {
    return Column(
      children: [
        _input("First Name", Icons.person_outline, controller.pFirstName),
        const SizedBox(height: 14),
        _input("Last Name", Icons.person_outline, controller.pLastName),
        const SizedBox(height: 14),
        _verifyField("Phone Number", Icons.phone_android_outlined, controller.pPhone, isNumeric: true),
        const SizedBox(height: 14),
        _verifyField("Email Address", Icons.alternate_email, controller.pEmail),
        const SizedBox(height: 14),
        _input("Password", Icons.lock_outline, controller.pPassword, password: true),
        const SizedBox(height: 14),
        _input("Confirm Password", Icons.lock_outline, controller.pConfirmPassword, password: true),
        const SizedBox(height: 28),
        _primaryButton("REGISTER AS PATIENT", controller.registerPatient),
      ],
    );
  }

  Widget _labForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("LABORATORY INFO"),
        _input("Laboratory Name", Icons.science_outlined, controller.lName),
        const SizedBox(height: 14),
        _verifyField("Phone Number", Icons.phone_outlined, controller.lPhone, isNumeric: true),
        const SizedBox(height: 14),
        _verifyField("Email / Username", Icons.email_outlined, controller.lUserEmail),
        const SizedBox(height: 14),
        _input("Full Address", Icons.location_on_outlined, controller.lAddress),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _input("Area/Location", Icons.map_outlined, controller.lLocation)),
            const SizedBox(width: 10),
            Expanded(child: _input("Pincode", Icons.pin_drop_outlined, controller.lPincode, isNumeric: true)),
          ],
        ),
        const SizedBox(height: 22),
        _section("SECURITY & COMPLIANCE"),
        _input("Password", Icons.lock_outline, controller.lPassword, password: true),
        const SizedBox(height: 14),
        _input("NABL / Certificate No", Icons.verified_user_outlined, controller.lCertNo, isNumeric: true),
        const SizedBox(height: 14),

        /// File Upload UI
        GestureDetector(
          onTap: controller.pickCertificate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
                color: kTextFieldBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: controller.selectedFile.value != null ? kPrimary : Colors.grey.shade200)
            ),
            child: Row(
              children: [
                Icon(Icons.upload_file_outlined, size: 18, color: controller.selectedFile.value != null ? kPrimary : kTextGrey),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                        controller.selectedFile.value?.path.split('/').last ?? "Upload Lab Certificate",
                        style: TextStyle(fontSize: 13, color: controller.selectedFile.value != null ? kDarkSlate : Colors.grey, fontWeight: controller.selectedFile.value != null ? FontWeight.w600 : FontWeight.normal)
                    )
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        _section("SERVICES"),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _serviceChip("Home Collection", controller.isHomeCollection),
            _serviceChip("Online Reports", controller.isOnlineReports),
            _serviceChip("Emergency", controller.isEmergencyTests),
          ],
        ),
        const SizedBox(height: 32),
        _primaryButton("REGISTER LABORATORY", controller.registerLab),
      ],
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _section(String title) => Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: kTextGrey, letterSpacing: 1)));

  Widget _input(String hint, IconData icon, TextEditingController ctrl, {bool password = false, bool isNumeric = false}) {
    return TextFormField(
      controller: ctrl,
      obscureText: password,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(icon, size: 18, color: kTextGrey),
        filled: true,
        fillColor: kTextFieldBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kPrimary, width: 1.5)),
      ),
    );
  }

  Widget _verifyField(String hint, IconData icon, TextEditingController ctrl, {bool isNumeric = false}) {
    return Row(
      children: [
        Expanded(child: _input(hint, icon, ctrl, isNumeric: isNumeric)),
        const SizedBox(width: 8),
        TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: kPrimary),
            child: const Text("Verify", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
        ),
      ],
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            elevation: 4,
            shadowColor: kPrimary.withOpacity(0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _serviceChip(String label, RxBool value) {
    return Obx(() => FilterChip(
      label: Text(label),
      selected: value.value,
      onSelected: (v) => value.value = v,
      selectedColor: kPrimary,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: value.value ? Colors.white : kTextGrey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: value.value ? kPrimary : Colors.grey.shade300)),
    ));
  }
}
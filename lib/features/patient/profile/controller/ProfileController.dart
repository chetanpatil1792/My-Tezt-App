import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import 'package:path_provider/path_provider.dart';
import '../models/PatientProfile.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  var profile = PatientProfile().obs;

  void fetchProfileData() async {
    try {
      isLoading(true);
      String? token = await getAccessToken();
      var headers = {'Authorization': 'Bearer $token'};

      // Dono API ko parallel call karna
      final responses = await Future.wait([
        http.get(Uri.parse(ApiUrls.patientProfileDetails), headers: headers),
        http.get(Uri.parse(ApiUrls.patientProfileComplettion), headers: headers),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        var detailsJson = json.decode(responses[0].body);
        var completionJson = json.decode(responses[1].body);
        profile.value = PatientProfile.fromJson(detailsJson, completionJson);
      }
    } catch (e) {
      Get.snackbar("Error", "Fetch failed: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfileSection(String url, Map<String, dynamic> data) async {
    try {
      isSubmitting(true);
      String? token = await getAccessToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        if (Get.isBottomSheetOpen ?? false) Get.back();
        fetchProfileData();
        Get.snackbar("Success", "Updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      isSubmitting(false);
    }
  }

  Future<File?> compressImage(String path) async {
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      path, targetPath, quality: 35, minWidth: 1024, minHeight: 1024,
    );
    return result != null ? File(result.path) : null;
  }

  Future<void> uploadProfilePhoto({String? userId, String? userName}) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      isSubmitting(true);

      File? compressedFile = await compressImage(pickedImage.path);
      if (compressedFile == null) return;

      String? token = await getAccessToken();
      var request = http.MultipartRequest('POST', Uri.parse(ApiUrls.patientProfilePhoto));

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });


      request.files.add(await http.MultipartFile.fromPath(
        'Photo',
        compressedFile.path,
        filename: compressedFile.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        fetchProfileData();
        Get.snackbar("Success", "Photo uploaded successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print("Error body: ${response.body}");
        Get.snackbar("Error", "Upload failed: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Upload Exception: $e");
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }


  // ProfileController ke andar ye add karein:
  var cardDetails = {}.obs;
  var isCardLoading = false.obs;

  Future<void> fetchMyTeztCard() async {
    try {
      isCardLoading(true);
      String? token = await getAccessToken();
      final response = await http.get(
        Uri.parse("https://web.swifthrm.in/api/patient/profile/get-mytezt-card"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        cardDetails.value = json.decode(response.body);
        _showCardDialog(); // Fetch hone ke baad dialog dikhao
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load card details");
    } finally {
      isCardLoading(false);
    }
  }


  var isCardFlipped = false.obs;
  var cardRotationX = 0.0.obs;
  var cardRotationY = 0.0.obs;


  void _showCardDialog() {
    final data = cardDetails;
    final user = profile.value;
    String rawId = data['myTeztNumber'] ?? "";
    String formattedId = rawId.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}  ");

    // Reset values on open
    isCardFlipped.value = false;
    cardRotationX.value = 0.0;
    cardRotationY.value = 0.0;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 3D Interactive Card
            GestureDetector(
              // Kisi bhi angle pe ghumane ke liye
              onPanUpdate: (details) {
                cardRotationY.value += details.delta.dx * 0.01;
                cardRotationX.value -= details.delta.dy * 0.01;
              },
              // Pan khatam hone pe auto-flip logic (optional)
              onPanEnd: (details) {
                // Agar user ne tezi se swipe kiya toh flip toggle kar do
                if (details.velocity.pixelsPerSecond.dx.abs() > 500) {
                  isCardFlipped.toggle();
                }
                // Reset rotation to neutral for clean look
                cardRotationX.value = 0.0;
              },
              onTap: () => isCardFlipped.toggle(),
              child: Obx(() {
                // Flip Logic + Interactive rotation
                double finalRotationY = cardRotationY.value + (isCardFlipped.value ? 3.14159 : 0.0);

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Depth perspective
                    ..rotateX(cardRotationX.value)
                    ..rotateY(finalRotationY),
                  alignment: Alignment.center,
                  child: _buildCardContent(data, formattedId, user, finalRotationY),
                );
              }),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 30),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.cancel, color: Colors.white, size: 40),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  // Card Content Switcher (Handles Mirror Text)
  Widget _buildCardContent(Map data, String formattedId, dynamic user, double currentY) {
    // Check if the card is showing its back based on rotation angle
    // (PI/2 se 3PI/2 ke beech back side hoti hai)
    bool isShowingBack = (currentY.abs() % (2 * 3.14159) > 1.57) && (currentY.abs() % (2 * 3.14159) < 4.71);

    if (isShowingBack) {
      // BACK SIDE: Mirror effect fix karne ke liye hum khud text ko rotate karte hain
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(3.14159),
        child: _buildCardBack(user),
      );
    } else {
      // FRONT SIDE
      return _buildCardFront(data, formattedId);
    }
  }

  // --- FRONT SIDE ---
  Widget _buildCardFront(Map data, String formattedId) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: _cardDecoration(),
      child: Stack(
        children: [
          Positioned(top: 15, left: 15, child: _cardIconBadge()),
          Positioned(top: 18, right: 15, child: _cardTitleText()),
          Positioned(left: 15, top: 60, child: _qrBadge()),
          Positioned(
            top: 75, left: 80,
            child: _cardDetailColumn("UNIQUE PATIENT ID", formattedId, isId: true),
          ),
          Positioned(
              bottom: 15, left: 15,
              child: _cardDetailColumn("PATIENT NAME", "${data['firstName']} ${data['lastName']}".toUpperCase())
          ),
          Positioned(bottom: 18, right: 18, child: _activeBadge()),
        ],
      ),
    );
  }

  // --- BACK SIDE ---
  Widget _buildCardBack(dynamic user) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("CONTACT DETAILS", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const Divider(color: Colors.white24, thickness: 1),
          const SizedBox(height: 10),
          _backDetailRow(Icons.phone, user.mobile ?? "N/A"),
          _backDetailRow(Icons.location_on, "${user.address1 ?? 'N/A'}, ${user.city ?? ''}"),
          _backDetailRow(Icons.pin_drop, "PIN: ${user.pinCode ?? 'N/A'}"),
          const Spacer(),
          Center(child: Text("www.mytezt.in", style: GoogleFonts.poppins(color: Colors.white30, fontSize: 10))),
        ],
      ),
    );
  }

  // --- STYLES (Keep existing or update) ---
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFF0000).withOpacity(0.95),
          const Color(0xFF5A4FCF).withOpacity(0.9),
          const Color(0xFF1A95D1).withOpacity(0.95),
        ],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12))
      ],
    );
  }



  Widget _cardIconBadge() => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
    child: const Icon(Icons.health_and_safety, color: Color(0xFFFF0000), size: 20),
  );

  Widget _cardTitleText() => Text("MyTezt Card",
      style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600));

  Widget _qrBadge() => Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
    child: const Icon(Icons.qr_code_2, size: 48, color: Colors.black87),
  );

  Widget _activeBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.8), borderRadius: BorderRadius.circular(6)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified, color: Colors.white, size: 10),
        const SizedBox(width: 4),
        Text("ACTIVE", style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _cardDetailColumn(String label, String value, {bool isId = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w500)),
        Text(value, style: isId
            ? GoogleFonts.sourceCodePro(color: const Color(0xFF001A4B).withOpacity(0.8), fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 1.5)
            : GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _backDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400))),
        ],
      ),
    );
  }



  Future<void> updateFullProfile(Map<String, dynamic> data) async {
    try {
      isSubmitting(true);
      String? token = await getAccessToken();

      // PUT Request as per your requirement
      final response = await http.put(
        Uri.parse("${ApiUrls.baseUrl}patient/profile/update"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (Get.isBottomSheetOpen ?? false) Get.back();
        fetchProfileData();
        Get.snackbar("Success", "Profile updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Update failed: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isSubmitting(false);
    }
  }

}
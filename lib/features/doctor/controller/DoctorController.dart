import 'package:get/get.dart';

class DoctorController extends GetxController {
  var selectedDate = "Today".obs;
  var selectedTimeSlot = "".obs;
  
  late Map<String, dynamic> doctorData;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    var defaultData = _getDummyData();

    if (args != null) {
      doctorData = Map<String, dynamic>.from(args);
      doctorData['about'] ??= defaultData['about'];
      doctorData['specialization'] ??= defaultData['specialization'];
      doctorData['experience'] ??= defaultData['experience'];
      doctorData['rating'] ??= defaultData['rating'];
      doctorData['reviewCount'] ??= "1.2k+";
      doctorData['hospital'] ??= "City Health Hospital, Delhi";
      doctorData['education'] ??= "MBBS, MD - Cardiology";
      doctorData['languages'] ??= ["English", "Hindi"];
      doctorData['slots'] ??= defaultData['slots'];
    } else {
      doctorData = defaultData;
    }
  }

  Map<String, dynamic> _getDummyData() {
    return {
      "name": "Dr. Aarav Sharma",
      "specialization": "Cardiologist",
      "experience": "12 years exp.",
      "rating": 4.9,
      "about": "Dr. Aarav Sharma is a highly experienced Cardiologist with over 12 years of practice. He specializes in interventional cardiology and has performed numerous successful procedures.",
      "hospital": "City Health Hospital, Delhi",
      "education": "MBBS, MD - Cardiology",
      "languages": ["English", "Hindi"],
      "slots": [
        "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", 
        "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM"
      ]
    };
  }
}
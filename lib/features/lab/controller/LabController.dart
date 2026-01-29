import 'package:get/get.dart';

class LabController extends GetxController {
  var isHomeCollection = true.obs;
  var selectedCategory = "All".obs;
  var cartItems = <Map<String, dynamic>>[].obs;

  late Map<String, dynamic> labData;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    var defaultData = _getDummyData();

    if (args != null) {
      labData = Map<String, dynamic>.from(args);
      // Merging: Jo data Search se nahi aaya, wo dummy se uthao
      labData['tests'] ??= defaultData['tests'];
      labData['images'] ??= defaultData['images'];
      labData['categories'] ??= defaultData['categories'];
      labData['reviewCount'] ??= "2.5k+";
      labData['timing'] ??= "06:00 AM - 10:00 PM";
      labData['isNabl'] ??= true;
      labData['facilities'] ??= defaultData['facilities'];
    } else {
      labData = defaultData;
    }
  }

  void toggleBookingType(bool value) => isHomeCollection.value = value;

  void toggleTestInCart(Map<String, dynamic> test) {
    bool exists = cartItems.any((item) => item['name'] == test['name']);
    if (exists) {
      cartItems.removeWhere((item) => item['name'] == test['name']);
    } else {
      cartItems.add(test);
    }
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item['discountPrice'] as num).toDouble());

  Map<String, dynamic> _getDummyData() {
    return {
      "name": "ShobiLab Diagnostics & Research Center",
      "isNabl": true,
      "rating": 4.9,
      "reviewCount": "2,450",
      "distance": "1.2 km",
      "timing": "06:00 AM - 10:00 PM",
      "address": "B-402, Medical Hub, Near Metro Station, Delhi",
      "facilities": ["AC Waiting Room", "Home Collection", "Parking", "Wheelchair Accessible"],
      "images": [
        "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=500",
        "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=500",
        "https://cdn.pixabay.com/photo/2018/11/20/16/44/laboratory-3827738_1280.jpg",
        "https://cdn.pixabay.com/photo/2018/06/26/05/06/lab-3498582_1280.jpg",
        "https://cdn.pixabay.com/photo/2024/07/08/16/28/ai-generated-8881545_1280.jpg"

      ],
      "categories": ["All", "Popular", "Full Body", "Diabetes", "Heart", "Vitamin", "Radiology"],
      "tests": [
        {
          "name": "Executive Full Body Checkup",
          "category": "Full Body",
          "description": "85 Tests included. Comprehensive screening of Liver, Kidney, Heart & Thyroid.",
          "originalPrice": 4999.0,
          "discountPrice": 1999.0,
          "preInstructions": "10-12 hours strict fasting required. Water is allowed.",
          "tat": "24 Hours",
          "sample": "Blood, Urine",
          "coins": 200
        },
        {
          "name": "Vitamin D & B12 Combo",
          "category": "Vitamin",
          "description": "Essential for bone strength, nerve health and immunity levels.",
          "originalPrice": 2200.0,
          "discountPrice": 999.0,
          "preInstructions": "No special preparation required.",
          "tat": "12 Hours",
          "sample": "Blood",
          "coins": 100
        },
        {
          "name": "Diabetes Screening (HbA1c + Fasting)",
          "category": "Diabetes",
          "description": "Accurate monitoring of your 3-month average blood sugar levels.",
          "originalPrice": 800.0,
          "discountPrice": 349.0,
          "preInstructions": "Overnight fasting (8-10 hours) mandatory.",
          "tat": "8 Hours",
          "sample": "Blood",
          "coins": 50
        },
        {
          "name": "Lipid Profile (Heart Health)",
          "category": "Heart",
          "description": "Measures Cholesterol, HDL, LDL, and Triglycerides levels.",
          "originalPrice": 1200.0,
          "discountPrice": 499.0,
          "preInstructions": "12 hours fasting required.",
          "tat": "12 Hours",
          "sample": "Blood",
          "coins": 80
        },
        {
          "name": "CBC (Complete Blood Count)",
          "category": "Popular",
          "description": "Basic test to check for Anemia, Infection, and general health.",
          "originalPrice": 500.0,
          "discountPrice": 199.0,
          "preInstructions": "No fasting required.",
          "tat": "6 Hours",
          "sample": "Blood",
          "coins": 20
        },
        {
          "name": "Iron Studies Profile",
          "category": "Popular",
          "description": "To check Iron deficiency and Ferritin levels in the body.",
          "originalPrice": 1500.0,
          "discountPrice": 799.0,
          "preInstructions": "Fasting recommended.",
          "tat": "24 Hours",
          "sample": "Blood",
          "coins": 70
        }
      ]
    };
  }
}
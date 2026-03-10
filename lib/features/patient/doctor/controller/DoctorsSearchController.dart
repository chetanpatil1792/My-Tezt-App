import 'package:get/get.dart';

class DoctorsSearchController extends GetxController {
  var searchQuery = "".obs;

  // Real-world dummy doctors data
  final List<Map<String, dynamic>> allDoctors = [
    {
      "name": "Dr. Aarav Sharma",
      "specialization": "Cardiologist",
      "experience": "12 years exp.",
      "rating": 4.9,
      "distance": "1.2 km",
      "tags": ["Heart Specialist", "MBBS, MD"],
      "image": "https://cdn.pixabay.com/photo/2020/06/13/09/06/coronavirus-5293556_1280.jpg",
      "priceRange": "900 - ₹1200",
    },
    {
      "name": "Dr. Ishani Verma",
      "specialization": "Dermatologist",
      "experience": "8 years exp.",
      "rating": 4.8,
      "distance": "2.5 km",
      "tags": ["Skin Expert", "MBBS, DVD"],
      "image": "https://cdn.pixabay.com/photo/2023/06/22/04/15/ai-generated-8080457_1280.jpg",
      "priceRange": "₹600 - 900",
    },
    {
      "name": "Dr. Rohan Gupta",
      "specialization": "Pediatrician",
      "experience": "15 years exp.",
      "rating": 4.7,
      "distance": "4.2 km",
      "tags": ["Child Specialist", "MBBS, DCH"],
      "image": "https://cdn.pixabay.com/photo/2016/03/27/21/33/woman-1284347_1280.jpg",
      "priceRange": "300 - 500",
    },
  ];

  // Filtered list based on search
  List<Map<String, dynamic>> get filteredDoctors => allDoctors
      .where((doc) => doc['name'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                      doc['specialization'].toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();
}
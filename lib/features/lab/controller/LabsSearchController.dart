import 'package:get/get.dart';

class LabsSearchController extends GetxController {
  var searchQuery = "".obs;

  // Real-world dummy labs data
  final List<Map<String, dynamic>> allLabs = [
    {
      "name": "ShobiLab Diagnostics",
      "address": "Sector 45, Gurgaon, Delhi",
      "rating": 4.9,
      "distance": "0.8 km",
      "tags": ["NABL", "ISO"],
      "image": "https://cdn.pixabay.com/photo/2024/07/08/16/28/ai-generated-8881545_1280.jpg",
      "priceRange": "₹299 - ₹4999",
    },
    {
      "name": "Apollo PathLabs",
      "address": "Malviya Nagar, South Delhi",
      "rating": 4.7,
      "distance": "2.5 km",
      "tags": ["NABL"],
      "image": "https://cdn.pixabay.com/photo/2018/06/26/05/06/lab-3498582_1280.jpg",
      "priceRange": "₹499 - ₹8999",
    },
    {
      "name": "Dr. Lal PathLabs",
      "address": "Dwarka Sector 12, Delhi",
      "rating": 4.5,
      "distance": "4.2 km",
      "tags": ["NABL", "CAP"],
      "image": "https://cdn.pixabay.com/photo/2018/11/20/16/44/laboratory-3827738_1280.jpg",
      "priceRange": "₹199 - ₹6000",
    },
  ];

  // Filtered list based on search
  List<Map<String, dynamic>> get filteredLabs => allLabs
      .where((lab) => lab['name'].toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();
}
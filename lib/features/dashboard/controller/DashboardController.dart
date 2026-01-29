import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  final storage = GetStorage();

  // User Info - Reactive
  var userName = 'Chetan Patil'.obs;
  var userLocation = 'Mumbai, India'.obs;

  // Stats
  RxInt totalTests = 12.obs;
  RxInt upcomingAppointments = 2.obs;
  RxInt reportsAvailable = 8.obs;
  RxDouble healthScore = 0.78.obs;

  // Toggles (Functional)
  RxBool medicineReminder = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    // Load toggle state from local storage
    medicineReminder.value = storage.read('med_reminder') ?? true;
  }

  void toggleMedicine(bool value) {
    medicineReminder.value = value;
    storage.write('med_reminder', value);
    Get.snackbar(
      "Reminder ${value ? 'Enabled' : 'Disabled'}",
      "You will ${value ? 'now' : 'no longer'} receive medicine alerts.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) return (parts[0][0] + parts.last[0]).toUpperCase();
    return parts[0][0].toUpperCase();
  }
}
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'controller/DashboardController.dart';
import 'controller/NotificationController.dart';



 class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}


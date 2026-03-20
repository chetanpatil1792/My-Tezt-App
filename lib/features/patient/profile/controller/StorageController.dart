import 'package:get/get.dart';
import 'dart:convert';
import 'package:my_tezt/core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class StorageController extends GetxController {
  var isLoading = true.obs;
  var usedStorageMB = 0.0.obs;
  var usedStorageDisplay = "0 MB".obs;

  final double totalStorageMB = 1024.0;

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchStorageData();
  }

  Future<void> fetchStorageData() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(
        Uri.parse("${ApiUrls.baseUrl}patient/profile/GetStorage"),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          String sizeStr = jsonResponse['data']['result']['totalStorageSize'];

          usedStorageDisplay.value = sizeStr;
          usedStorageMB.value = double.parse(sizeStr.split(' ')[0]);
        }
      }
    } catch (e) {
      print("Error fetching storage data: $e");
    } finally {
      isLoading(false);
    }
  }

  double get percentage => (usedStorageMB.value / totalStorageMB);
  double get remainingMB => totalStorageMB - usedStorageMB.value;
}
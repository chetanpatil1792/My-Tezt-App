import 'dart:convert';

import 'package:get/get.dart';

import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/utils/token_helper.dart';

class WishlistController extends GetxController {

  var isLoading = false.obs;

  RxList wishlist = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  final ApiClient _apiClient = ApiClient();

  Future<void> fetchWishlist() async {
    try {
      isLoading(true);
      final response = await _apiClient.get(Uri.parse("${ApiUrls.baseUrl}patient/cart"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        wishlist.assignAll(data);
      }
    } catch (e) {
      print("Cart Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }



  void removeWishlist(id){
    wishlist.removeWhere((e)=> e['id'] == id);
  }

  void moveToCart(data){

    /// API CALL yaha karega
    print("Move to cart");

  }

}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/WishlistController.dart';

class WishlistScreen extends StatelessWidget {

  final controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,color: Color(0xFF1E293B),size: 18),
          onPressed: ()=> Get.back(),
        ),
        title: Text("Wishlist",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
                fontSize: 18)),
      ),

      body: Obx(() {

        if(controller.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }

        if(controller.wishlist.isEmpty){
          return _emptyWishlist();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.wishlist.length,
          itemBuilder: (context,index){
            return _wishlistCard(controller.wishlist[index]);
          },
        );

      }),
    );
  }

  Widget _wishlistCard(Map data){

    final lab = data['lab'];
    final tests = data['tests'];

    return Container(
      margin: const EdgeInsets.only(bottom:16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow:[
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 10
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LAB HEADER
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [

                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Icon(Icons.biotech,color: Color(0xFF0284C7)),
                ),

                const SizedBox(width:10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        lab['labName'],
                        style: GoogleFonts.poppins(
                            fontSize:14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A)
                        ),
                      ),

                      Text(
                        lab['address'] ?? "",
                        style: const TextStyle(
                            fontSize:10,
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal:8,vertical:4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: const Text(
                      "LAB",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:9,
                          fontWeight: FontWeight.bold
                      )),
                )
              ],
            ),
          ),

          /// TEST LIST
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(tests.length, (i){

                var t = tests[i];

                return Container(
                  margin: const EdgeInsets.only(bottom:10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200)
                  ),

                  child: Row(
                    children: [

                      const Icon(Icons.favorite,color: Colors.red,size:18),

                      const SizedBox(width:8),

                      Expanded(
                        child: Text(
                          t['testName'],
                          style: GoogleFonts.poppins(
                              fontSize:12,
                              color: const Color(0xFF334155)
                          ),
                        ),
                      ),

                      Text(
                        "₹${t['price']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6)
                        ),
                      )
                    ],
                  ),
                );

              }),
            ),
          ),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.fromLTRB(12,0,12,12),
            child: Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(

                      onPressed: (){
                        controller.removeWishlist(data['id']);
                      },

                      icon: const Icon(Icons.delete_outline,size:16,color: Colors.red),

                      label: const Text("Remove",
                          style: TextStyle(
                              fontSize:12,
                              color: Colors.red
                          )),

                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red)
                      )
                  ),
                ),

                const SizedBox(width:10),

                Expanded(
                  child: ElevatedButton.icon(

                    onPressed: (){
                      controller.moveToCart(data);
                    },

                    icon: const Icon(Icons.shopping_cart_checkout,size:16),

                    label: const Text("Book Now",
                        style: TextStyle(fontSize:12)),

                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A)
                    ),
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }


  Widget _emptyWishlist(){

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(Icons.favorite_border,
              size:70,
              color: Colors.grey.shade300),

          const SizedBox(height:16),

          Text(
            "Wishlist is Empty",
            style: GoogleFonts.poppins(
                fontSize:16,
                fontWeight: FontWeight.w500
            ),
          ),

          const SizedBox(height:8),

          const Text("Save tests for later booking"),

          const SizedBox(height:16),

          ElevatedButton(
              onPressed: ()=> Get.back(),
              child: const Text("Browse Tests")
          )
        ],
      ),
    );
  }

}
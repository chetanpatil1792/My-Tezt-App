import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.05,
                        child: Image.asset("assets/images/bargraph2.png",width: 130,),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Opacity(
                        opacity: 0.09,
                        child: SvgPicture.asset(
                          "assets/images/onbard6.svg",
                          width: 130,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 380),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.07,
                        child: SvgPicture.asset(
                          "assets/images/graph3.svg",
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(-0.6, -0.5),
              child:  Opacity(
                opacity: 0.06,
                child: SvgPicture.asset("assets/images/svg1.svg",width: 120,),),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff202a44),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 270,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "UserName",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            color: Color(0xff202a44),
                            fontFamily: "Poppins",
                          ),
                          prefixIcon: Icon(Icons.person, color: Color(0xff202a44)),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          fillColor: Colors.white,filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(
                            color: Color(0xff202a44),
                            fontFamily: "Poppins",
                          ),
                          prefixIcon: Icon(Icons.email, color: Color(0xff202a44)),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Color(0xff202a44),
                          ),
                          onPressed: () {
                            // Functionality from forgot_screen.dart
                            final username = _usernameController.text;
                            final email = _emailController.text;

                            if (username.isNotEmpty && email.isNotEmpty) {
                              // Call API or handle forgot password logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password reset request sent')),
                              );
                              // Optionally, navigate to another screen if needed
                              // Navigator.pop(context); // Example: go back after sending request
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill in all fields')),
                              );
                            }
                          },
                          child: Text("Send Request",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w500),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.9,0.7),
              child:  Opacity(
                opacity: 0.05,
                child: SvgPicture.asset(
                  "assets/images/graph6.svg",
                  width: 150,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0,0.9),
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  "assets/images/barchart.png",
                  width: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

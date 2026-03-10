import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_tezt/routes/app_routes.dart';
import '../controller/login_controller.dart';

/// 🎨 Clean & Minimal Lab Colors
const kPrimary = Color(0xff2A5C82); // Professional Blue
const kScaffoldBg = Color(0xffFDFDFD); // Off White
const kTextFieldBg = Color(0xffF4F7F9);
const kTextGrey = Color(0xff64748B);

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔬 Minimal Icon
                const Icon(
                  Icons.biotech_outlined,
                  size: 60,
                  color: kPrimary,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Lab Booking",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Color(0xff1E293B),
                  ),
                ),
                const Text(
                  "Please login to your account",
                  style: TextStyle(color: kTextGrey, fontSize: 14),
                ),
                const SizedBox(height: 50),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // User ID Field
                      _simpleTextField(
                        hint: "Patient or Staff ID",
                        icon: Icons.person_outline,
                        controller: controller.usernameController,
                        onChanged: (val) => controller.userName.value = val,
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      Obx(() => _simpleTextField(
                        hint: "Password",
                        icon: Icons.lock_open_rounded,
                        isPassword: true,
                        obscureText: !controller.isPasswordVisible.value,
                        controller: controller.passwordController,
                        onChanged: (val) => controller.password.value = val,
                        togglePassword: () => controller.isPasswordVisible.toggle(),
                        validator: (val) => val!.isEmpty ? 'Required' : null,
                      )),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.register);
                          },
                          child: const Text("Don’t have an account? Create account",
                              style: TextStyle(color: kPrimary, fontSize: 13)),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🚀 Simple Login Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: controller.loginStatus.value == LoginStatus.loading
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              await controller.login();
                            }
                          },
                          child: controller.loginStatus.value == LoginStatus.loading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Text("LOGIN",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📝 Helper for Simple Text Fields
  Widget _simpleTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: kTextGrey, size: 20),
        suffixIcon: isPassword
            ? IconButton(
            icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: kTextGrey, size: 20),
            onPressed: togglePassword)
            : null,
        filled: true,
        fillColor: kTextFieldBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimary, width: 1),
        ),
      ),
    );
  }
}
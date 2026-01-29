import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../controller/PasscodeController.dart';

class PasscodeLoginScreen extends GetView<PasscodeController> {
  const PasscodeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PasscodeController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE4EC), // pink faint
              Color(0xFFE8F3FF), // sky faint
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "My Tezt",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F2A44),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Enter your passcode",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// 🔐 PIN DOTS
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              bool filled =
                                  index < controller.enteredPin.value.length;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: filled
                                      ? (controller.isPinError.isTrue
                                      ? Colors.redAccent
                                      : const Color(0xFF4FB6C7))
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              );
                            }),
                          )),

                          /// ❌ ERROR
                          Obx(() => controller.isPinError.isTrue
                              ? Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Text(
                              "Invalid Passcode",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          )
                              : const SizedBox(height: 28)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔢 KEYPAD
              _buildKeypad(context),

              /// 🔁 FORGOT
              TextButton(
                onPressed: () =>
                    Get.toNamed(AppRoutes.ForgotPasscodeView),
                child: Text(
                  "Forgot Passcode?",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= KEYPAD =================

  Widget _buildKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          _buildKeypadRow(['4', '5', '6']),
          _buildKeypadRow(['7', '8', '9']),
          _buildKeypadRow(['fingerprint', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key == 'delete') {
          return _keypadButton(
            icon: Icons.backspace_outlined,
            onPressed: controller.clearLastDigit,
          );
        }

        if (key == 'fingerprint') {
          return _keypadButton(
            icon: Icons.fingerprint,
            color: const Color(0xFF4FB6C7),
            onPressed: controller.authenticateWithBiometrics,
          );
        }

        return _keypadButton(
          text: key,
          onPressed: () => controller.handlePinInput(key),
        );
      }).toList(),
    );
  }

  Widget _keypadButton({
    String? text,
    IconData? icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onPressed,
        child: Center(
          child: text != null
              ? Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F2A44),
            ),
          )
              : Icon(
            icon,
            size: 28,
            color: color ?? const Color(0xFF0F2A44),
          ),
        ),
      ),
    );
  }
}

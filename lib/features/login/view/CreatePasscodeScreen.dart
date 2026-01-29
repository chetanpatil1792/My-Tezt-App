import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/PasscodeController.dart';

class CreatePasscodeScreen extends GetView<PasscodeController> {
  const CreatePasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Obx(() {
                      final currentPin = controller.isConfirming.isFalse
                          ? controller.newPasscode1.value
                          : controller.newPasscode2.value;

                      return Container(
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
                              controller.creationMessage.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 28),

                            /// 🔐 PIN DOTS (same as login)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                final filled = index < currentPin.length;

                                return AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filled
                                        ? const Color(0xFF4FB6C7)
                                        : Colors.grey.withOpacity(0.3),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),

              /// 🔢 KEYPAD (same buttons)
              _buildKeypad(),

              /// ❌ Cancel (only when changing)
              if (controller.isPasscodeSet.isTrue)
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
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

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _row(['1', '2', '3']),
          _row(['4', '5', '6']),
          _row(['7', '8', '9']),
          _row(['', '0', 'delete']),
        ],
      ),
    );
  }

  Widget _row(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) {
          return const SizedBox(width: 72);
        }

        if (key == 'delete') {
          return _key(
            icon: Icons.backspace_outlined,
            onTap: controller.clearCreationLastDigit,
          );
        }

        return _key(
          text: key,
          onTap: () => controller.handleCreationPinInput(key),
        );
      }).toList(),
    );
  }

  Widget _key({
    String? text,
    IconData? icon,
    required VoidCallback onTap,
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

        onTap: onTap,
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
            color: const Color(0xFF0F2A44),
          ),
        ),
      ),
    );
  }
}

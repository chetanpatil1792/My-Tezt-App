import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/PasscodeController.dart';

class ForgotPasscodeScreen extends GetView<PasscodeController> {
  const ForgotPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is already initialized
    // Get.put(PasscodeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Passcode'),
        backgroundColor: Colors.red.shade900,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to reset your local Passcode?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This will clear your local login session and require you to log in with your username and password again to set a new Passcode.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: controller.forgotPasscode,
                icon: const Icon(Icons.logout),
                label: const Text('Reset Passcode & Logout'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
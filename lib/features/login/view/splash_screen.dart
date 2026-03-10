import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../controller/login_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final LoginController loginController = Get.put(LoginController());

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final accessToken = await secureStorage.read(key: 'access_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      Get.offAllNamed(AppRoutes.DashboardView,);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE4EC), // gradientPinkFaint
              Color(0xFFE8F3FF), // gradientSkyFaint
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 🏷️ APP NAME ONLY
                  Text(
                    "My Tezt",
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F2A44), // primaryDarkBlue feel
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Smart Health Management",
                    style: GoogleFonts.poppins(
                      fontSize: size.width * 0.045,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

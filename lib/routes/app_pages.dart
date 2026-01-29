import 'package:get/get_navigation/src/routes/get_route.dart';

import '../features/dashboard/binding.dart';
import '../features/dashboard/view/AboutUsPage.dart';
import '../features/dashboard/view/ContactUsPage.dart';
import '../features/dashboard/view/Dashboard.dart';
import '../features/dashboard/view/HelpPage.dart';
import '../features/lab/view/LabDetailScreen.dart';
import '../features/lab/view/LabsSearchScreen.dart';
import '../features/doctor/view/DoctorsSearchScreen.dart';
import '../features/doctor/view/DoctorDetailScreen.dart';
import '../features/reports/view/ReportsListPage.dart';
import '../features/reports/view/ReportDetailScreen.dart';
import '../features/login/Binding.dart';
import '../features/login/view/CreatePasscodeScreen.dart';
import '../features/login/view/ForgotPasscodeScreen.dart';
import '../features/login/view/PasscodeLoginScreen.dart';
import '../features/login/view/login_page.dart';
import '../features/login/view/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [

     GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
      // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.CreatePasscodeView,
      page: () => CreatePasscodeScreen(),
      binding: PasscodeBinding(),
    ),
    GetPage(
      name: AppRoutes.PasscodeLoginView,
      page: () => PasscodeLoginScreen(),
      binding: PasscodeBinding(),
    ),
    GetPage(
      name: AppRoutes.ForgotPasscodeView,
      page: () => ForgotPasscodeScreen(),
      binding: PasscodeBinding(),
    ),



    GetPage(
      name: AppRoutes.DashboardView,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),



    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsPage(),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
    ),
    GetPage(
      name: AppRoutes.searchLabsScreen,
      page: () =>   LabsSearchScreen(),
    ),
    GetPage(
      name: AppRoutes.searchDoctorsScreen,
      page: () => DoctorsSearchScreen(),
    ),
    GetPage(
      name: AppRoutes.doctorDetailScreen,
      page: () => const DoctorDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.reportsListPage,
      page: () => ReportsListPage(),
    ),
    GetPage(
      name: AppRoutes.reportDetailScreen,
      page: () =>   ReportDetailScreen(),
    ),


  ];
}

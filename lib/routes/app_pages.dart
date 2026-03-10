import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/login/view/RegisterScreen.dart';
import '../features/patient/booking/view/BookingScreen.dart';
import '../features/patient/cart/view/CartScreen.dart';
import '../features/patient/dashboard/binding.dart';
import '../features/patient/dashboard/view/Dashboard.dart';
import '../features/patient/doctor/view/DoctorDetailScreen.dart';
import '../features/patient/doctor/view/DoctorsSearchScreen.dart';
import '../features/patient/lab/view/LabsSearchScreen.dart';
import '../features/patient/profile/views/ProfileScreen.dart';
import '../features/patient/wishlist/views/WishlistScreen.dart';
import '../features/reports/view/ReportsListPage.dart';
import '../features/reports/view/ReportDetailScreen.dart';
import '../features/login/Binding.dart';
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
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.DashboardView,
      page: () => Dashboard(),
      binding: DashboardBinding(),
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


    /// patient pages
    GetPage(
      name: AppRoutes.profile,
      page: () =>   ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.cartScreen,
      page: () =>   CartScreen(),
    ),
    GetPage(
      name: AppRoutes.wishlistScreen,
      page: () =>   WishlistScreen(),
    ),
    GetPage(
      name: AppRoutes.bookingScreen,
      page: () => MyBookingsScreen(),
    ),


  ];
}

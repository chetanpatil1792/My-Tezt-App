/// API URLs configuration file for Flutter app

class ApiUrls {
  /// 🔹 Base URL
  static const String baseUrl = "https://web.swifthrm.in/api/";
  static const String baseUrlImage = "https://web.swifthrm.in";

  /// 🔹 Auth Endpoints
  static const String login = "${baseUrl}auth/login";
  static const String patientProfileDetails = "${baseUrl}patient/profile/details";
  static const String patientProfileComplettion = "${baseUrl}patient/profile/completion";
  static const String patientProfileBasic = "${baseUrl}patient/profile/basic";
  static const String patientProfileDob = "${baseUrl}patient/profile/dob";
  static const String patientProfileAddress = "${baseUrl}patient/profile/address";
  static const String patientProfileBody = "${baseUrl}patient/profile/body";
  static const String patientProfilePhoto = "${baseUrl}patient/profile/photo";
  static const String createPaymentOrder = "${baseUrl}patient/cart/create-payment-order";

}
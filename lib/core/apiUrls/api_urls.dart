/// API URLs configuration file for Flutter app

class ApiUrls {
  /// 🔹 Base URL
  // static const String baseUrl = "https://android.auditscore.in/api/";
  static const String baseUrl = "https://seedsfincap.auditcalculus.com:8889/api/";

  /// 🔹 Auth Endpoints
  static const String login = "${baseUrl}LoginAPI/submitLogin";

  /// 🔹 functions Endpoints
  static const String getUserData = "${baseUrl}API/";
  static const String refreshToken = "${baseUrl}LoginAPI/refresh-token";
  static const String getRegionMasterList = "${baseUrl}API/GetRegionMasterList";
  static const String getBranchListByRegion = "${baseUrl}API/RegionWiseBranchList/";
  static const String getBranchList = "${baseUrl}AuditorDocketListApi/GetBranchMasterNameListDetails/";
  static const String productListForAuditor = "${baseUrl}API/ProductListForAuditor";
  static const String postBlockAudit = "${baseUrl}API/CrudOperationAssignAuditeeMaster";
  static const String monthWiseAuditList = "${baseUrl}API/GetAssignAuditMonthWiseList?auditStartDate=";
  static const String docketAuditorList = "${baseUrl}AuditorDocketListApi/GetDocketAuditorListByMonth";
  static const String inProcessList = "${baseUrl}AuditorDocketListApi/InProcessList";
  static const String iadProcessHeadMasterDetailsList = "${baseUrl}API/GetIadProcessHeadMasterDetailsList";
  static const String getIadHeaderQuestionMasterListDetails = "${baseUrl}API/GetIadHeaderQuestionMasterListDetails";
  static const String getRiskAssessmentQuestionMasterDetails = "${baseUrl}API/GetRiskAssessmentQuestionMasterDetails";
  static const String annextureSubmit = "${baseUrl}AuditAPI/CrudOpertaionAnnexure";
  static const String getAnnexureHeaders = "${baseUrl}AuditAPI/GetAnnexureHeaders";
  static const String getAnnextureSavedata = "${baseUrl}AuditAPI/GetAnnextureSavedata";
  static const String crudOpertaionAnnexure = "${baseUrl}AuditAPI/CrudOpertaionAnnexure";
  static const String saveCapturedPhoto = "${baseUrl}AuditAPI/SaveCapturedPhoto";
  static const String startAudit = "${baseUrl}API/StartAudit";
  static const String saveAnnexureSubmit = "${baseUrl}AuditAPI/SaveAnnexure";
  static const String auditSubmitSuccessfullyMail = "${baseUrl}AuditAPI/AuditSubmitSuccessfullyMail";
  static const String dynamicTableAnnexure = "${baseUrl}AuditAPI/SaveAssetDetails";
  static const String SaveAudit = "${baseUrl}AuditAPI/SaveAudit";
  static const String saveAuditImages = "${baseUrl}AuditAPI/SaveImages";

}

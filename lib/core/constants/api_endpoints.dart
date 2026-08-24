/// API Endpoints for RUDRA Officer App
/// Based on Android API.java migration
class ApiEndpoints {
  ApiEndpoints._();

  // Base URLs
  static const String baseUrl = 'https://rudra.assam.gov.in/';
  static const String baseUrlImage = 'https://rudra.assam.gov.in';

  // ==================== COMMON APIs ====================
  static const String login = '${baseUrl}api/v1/login/login-officer';
  static const String forgotPassword = '${baseUrl}api/v1/login/forgot-password';
  static const String resetPassword = '${baseUrl}api/v1/login/reset-password';
  static const String otpVerification = '${baseUrl}api/v1/auth/verify-otp';
  static const String resendOtp = '${baseUrl}api/v1/auth/resend-otp';
  static const String refreshToken = '${baseUrl}api/v1/auth/refresh-token';
  static const String rejectMaster = '${baseUrl}api/v1/admin/fetch-master-rejected-remarks';
  static const String getUsers = '${baseUrl}api/v1/admin/get-users-in-division';
  static const String trackAssignedCase = '${baseUrl}api/v1/admin/case-proceedings?case_id=';
  static const String reAssignReason = '${baseUrl}api/v1/admin/get-re-assign-master-data';
  static const String getNotification = '${baseUrl}api/v1/admin/notifications';
  static const String sendFcmToken = '${baseUrl}api/v1/admin/fcm-tokens';
  static const String sendComment = '${baseUrl}api/v1/admin/create-case-proceeding';
  static const String updateProfile = '${baseUrl}api/v1/profile/create';

  // ==================== SE (Superintending Engineer) APIs ====================
  static const String getReportSummaryCountsSe = '${baseUrl}api/v1/se/report-summary-count';
  static const String reviewInspectionReportSe = '${baseUrl}api/v1/se/review-inspections';
  static String caseDetailsSe(int caseId) => '${baseUrl}api/v1/se/case/$caseId';
  static const String approveCase = '${baseUrl}api/v1/se/approve-case';
  static const String completedCaseSe = '${baseUrl}api/v1/se/completed-reports';
  static const String reassignToEe = '${baseUrl}api/v1/se/reassign-case';
  static const String reassignedCasesSe = '${baseUrl}api/v1/se/returned-reports';
  static const String potholeActivityMapSe = '${baseUrl}api/v1/se/activity-map';

  // ==================== EE (Executive Engineer) APIs ====================
  static const String getReportSummaryCountsEe = '${baseUrl}api/v1/ee/report-summary-count';
  static const String pendingReassignEe = '${baseUrl}api/v2/ee/quick-action-assign-to-ee';
  static const String acceptPendingCasesEe = '${baseUrl}api/v1/ee/accept-case';
  static const String rejectCaseEe = '${baseUrl}api/v1/ee/reject-case';
  static const String assignToAee = '${baseUrl}api/v1/ee/assign-case';
  static const String allAssignedCompletedRejectedCasesEe = '${baseUrl}api/v2/ee/my-reports';
  static String caseDetailsEe(int caseId) => '${baseUrl}api/v1/ee/case/$caseId';
  static const String reviewInspectionReportEe = '${baseUrl}api/v2/ee/review-inspections';
  static const String forwardToSe = '${baseUrl}api/v1/ee/forward-to-se';
  static const String reassignToAee = '${baseUrl}api/v1/ee/reassign-case';
  static const String potholeActivityMapEe = '${baseUrl}api/v1/ee/activity-map';

  // ==================== AEE (Assistant Executive Engineer) APIs ====================
  static const String getReportSummaryCountsAee = '${baseUrl}api/v1/aee/report-summary-count';
  static const String pendingReassignAee = '${baseUrl}api/v1/aee/quick-action-assign-to-field-engineers';
  static const String acceptPendingCasesAee = '${baseUrl}api/v1/aee/accept-case';
  static const String rejectCaseAee = '${baseUrl}api/v1/aee/reject-case';
  static const String assignToSelfAee = '${baseUrl}api/v1/aee/assign-to-self';
  static const String assignToFieldEng = '${baseUrl}api/v1/aee/assign-case';
  static const String transferToAee = '${baseUrl}api/v1/aee/case-transfer';
  static const String assignedCasesToSelfAee = '${baseUrl}api/v1/aee/self-assigned-reports';
  static const String allAssignedCompletedRejectedCasesAee = '${baseUrl}api/v1/aee/my-reports';
  static String caseDetailsAee(int caseId) => '${baseUrl}api/v1/aee/case/$caseId';
  static const String reviewInspectionReportAee = '${baseUrl}api/v2/aee/review-inspections';
  static const String forwardToEe = '${baseUrl}api/v1/aee/forward-to-ee';
  static const String reassignToAeJe = '${baseUrl}api/v1/aee/reassign-case';
  static String deletePotholeAee(int potholeId) => '${baseUrl}api/v1/aee/delete-pothole/$potholeId';
  static const String potholeActivityMapAee = '${baseUrl}api/v1/aee/activity-map';
  static const String selfCapturedCasesAee = '${baseUrl}api/v1/aee/capture-nearby-pothole-cases';
  static const String assignVendorAee = '${baseUrl}api/v1/aee/send-to-vendor';

  // ==================== JE (Junior Engineer) APIs ====================
  static const String getCountsJe = '${baseUrl}api/v1/je/report-summary-counts';
  static const String pendingReassignJe = '${baseUrl}api/v1/je/quick-action-assign';
  static const String acceptPendingCasesJe = '${baseUrl}api/v1/je/accept-case';
  static const String assignedCasesJe = '${baseUrl}api/v1/je/my-reports?filter=assigned';
  static String caseDetailsJe(int caseId) => '${baseUrl}api/v1/je/case/$caseId';
  static const String inspectionCompletedCasesJe = '${baseUrl}api/v1/je/completed-inspections';
  static const String allInspectedCompletedRejectedCasesJe = '${baseUrl}api/v1/je/my-reports';
  static const String rejectCaseJe = '${baseUrl}api/v1/je/reject-case';
  static String deletePotholeJe(int potholeId) => '${baseUrl}api/v1/je/delete-pothole/$potholeId';
  static const String potholeActivityMapJe = '${baseUrl}api/v1/je/activity-map';
  static const String assignVendorJe = '${baseUrl}api/v1/je/send-to-vendor';
  static const String selfCapturedCasesJe = '${baseUrl}api/v1/je/capture-nearby-pothole-cases';

  // ==================== AE (Assistant Engineer) APIs ====================
  static const String getCountsAe = '${baseUrl}api/v1/ae/report-summary-counts';
  static const String pendingReassignAe = '${baseUrl}api/v1/ae/quick-action-assign';
  static const String acceptPendingCasesAe = '${baseUrl}api/v1/ae/accept-case';
  static const String assignedCasesAe = '${baseUrl}api/v1/ae/my-reports?filter=assigned';
  static String caseDetailsAe(int caseId) => '${baseUrl}api/v1/ae/case/$caseId';
  static const String inspectionCompletedCasesAe = '${baseUrl}api/v1/ae/completed-inspections';
  static const String allInspectedCompletedRejectedCasesAe = '${baseUrl}api/v1/ae/my-reports';
  static const String rejectCaseAe = '${baseUrl}api/v1/ae/reject-case';
  static String deletePotholeAe(int potholeId) => '${baseUrl}api/v1/ae/delete-pothole/$potholeId';
  static const String potholeActivityMapAe = '${baseUrl}api/v1/ae/activity-map';
  static const String assignVendorAe = '${baseUrl}api/v1/ae/send-to-vendor';
  static const String selfCapturedCasesAe = '${baseUrl}api/v1/ae/capture-nearby-pothole-cases';

  // ==================== VENDOR APIs ====================
  static const String getReportSummaryCountsVendor = '${baseUrl}api/v1/vendor/report-summary-counts';
  static const String pendingReassignVendor = '${baseUrl}api/v1/vendor/pending-cases';
  static String caseDetailsVendor(int caseId) => '${baseUrl}api/v1/vendor/case/$caseId';
  static const String arrivedLocationVendor = '${baseUrl}api/v1/vendor/arrived-at-location';
  static const String allInspectedCompletedCasesVendor = '${baseUrl}api/v1/vendor/my-reports';
  static const String finalUpdateCasesVendor = '${baseUrl}api/v1/vendor/final-submit-cases';
  static const String taskCompletedVendor = '${baseUrl}api/v1/vendor/confirm-fix';
  static const String potholeActivityMapVendor = '${baseUrl}api/v1/vendor/activity-map';
}

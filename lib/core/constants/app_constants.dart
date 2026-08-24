/// App-wide constants for RUDRA Officer
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'RUDRA Officer';
  static const String packageName = 'com.pwd.rudraofficer';

  // Storage Keys (from UserManagement.java)
  static const String prefName = 'User_Login';
  static const String keyLogin = 'is_user_login';
  static const String keyUserName = 'userName';
  static const String keyUserType = 'userType';
  static const String keyName = 'name';
  static const String keyDivision = 'division';
  static const String keyProfilePic = 'profilePic';
  static const String keyRefreshToken = 'refreshToken';
  static const String keyToken = 'token';
  static const String keyUserId = 'id';
  static const String keyMobileNo = 'mobile';
  static const String keyDesignation = 'designation';
  static const String keyAddress = 'address';

  // User Types/Roles
  static const String roleSe = 'se';
  static const String roleEe = 'ee';
  static const String roleAee = 'aee';
  static const String roleJe = 'je';
  static const String roleAe = 'ae';
  static const String roleVendor = 'vendor';

  // Role Display Names
  static const Map<String, String> roleDisplayNames = {
    roleSe: 'Superintending Engineer',
    roleEe: 'Executive Engineer',
    roleAee: 'Assistant Executive Engineer',
    roleJe: 'Junior Engineer',
    roleAe: 'Assistant Engineer',
    roleVendor: 'Vendor',
  };

  // Case Status
  static const String statusPending = 'pending';
  static const String statusAssigned = 'assigned';
  static const String statusInspected = 'inspected';
  static const String statusCompleted = 'completed';
  static const String statusRejected = 'rejected';
  static const String statusReassigned = 'reassigned';

  // Pagination
  static const int defaultPageSize = 20;

  // Image
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;

  // ML Model
  static const String tfliteModelPath = 'assets/models/best_float32.tflite';
  static const int tfliteInputSize = 640;
  static const double tfliteConfidenceThreshold = 0.7;

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}

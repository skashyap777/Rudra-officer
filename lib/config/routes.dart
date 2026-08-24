import 'dart:io';
import 'package:go_router/go_router.dart';

import '../presentation/screens/auth/complete_profile_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/otp_verification_screen.dart';
import '../presentation/screens/auth/reset_password_screen.dart';
import '../presentation/screens/auth/role_selection_screen.dart';
import '../presentation/screens/main/main_screen.dart';
import '../presentation/screens/report/create_report_screen.dart';
import '../presentation/screens/report/report_detail_screen.dart';
import '../data/models/pothole_model.dart';
import '../presentation/screens/report/report_list_screen.dart';
import '../presentation/screens/report/pothole_map_screen.dart';
import '../presentation/pages/role_specific/se/take_action_se_screen.dart';
import '../presentation/pages/role_specific/ee/take_action_ee_screen.dart';
import '../presentation/pages/role_specific/ee/assign_report_ee_screen.dart';
import '../presentation/pages/role_specific/aee/capture_pothole_screen.dart';
import '../presentation/pages/role_specific/aee/report_captured_pothole_screen.dart';
import '../presentation/pages/role_specific/aee/take_action_aee_screen.dart';
import '../presentation/pages/role_specific/aee/assign_to_field_engineers_screen.dart';
import '../presentation/pages/role_specific/aee/assign_report_details_screen.dart';
import '../presentation/pages/role_specific/aee/self_inspection_aee_screen.dart';
import '../presentation/pages/role_specific/aee/my_reports_aee_screen.dart';
import '../presentation/pages/role_specific/aee/self_captured_aee_screen.dart';
import '../presentation/pages/role_specific/aee/review_inspections_aee_screen.dart';
import '../presentation/pages/role_specific/je_ae/field_inspection_screen.dart';
import '../presentation/pages/role_specific/je_ae/submit_final_report_screen.dart';
import '../presentation/pages/role_specific/vendor/vendor_fix_screen.dart';
import '../presentation/screens/report/track_report_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../data/models/models.dart';

/// App Router - GoRouter configuration for navigation
class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Flow
      GoRoute(
        path: '/role-selection',
        name: 'roleSelection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LoginScreen(
            roleName: extra?['role_name'] ?? '',
            roleLabel: extra?['role_label'] ?? '',
            roleDesc: extra?['role_desc'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) {
          final role = state.extra as String?;
          return ForgotPasswordScreen(role: role ?? '');
        },
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otpVerification',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OTPVerificationScreen(
            username: extra?['username'] ?? '',
            role: extra?['role'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: 'resetPassword',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResetPasswordScreen(
            username: extra?['username'] ?? '',
            role: extra?['role'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/complete-profile',
        name: 'completeProfile',
        builder: (context, state) => const CompleteProfileScreen(),
      ),

      // Main App with Bottom Navigation
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),

      // Report Routes
      GoRoute(
        path: '/report/:id',
        name: 'reportDetail',
        builder: (context, state) {
          final caseId = state.pathParameters['id'] ?? '';
          final extras = state.extra as Map<String, dynamic>?;
          return ReportDetailScreen(
            caseId: caseId,
            filterType: extras?['filterType'],
            initialReport: extras?['report'] as PotholeModel?,
          );
        },
      ),
      GoRoute(
        path: '/create-report',
        name: 'createReport',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CreateReportScreen(
            initialImages: extra?['preCapturedImages'] as List<File>?,
            initialLat: extra?['preLatitude'] as double?,
            initialLng: extra?['preLongitude'] as double?,
            initialAccuracy: extra?['preAccuracy'] as double?,
          );
        },
      ),
      GoRoute(
        path: '/report-list',
        name: 'reportList',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReportListScreen(
            title: extra?['title'] ?? 'Reports',
            filterType: extra?['filterType'] ?? 'all',
          );
        },
      ),
      GoRoute(
        path: '/pothole-map',
        name: 'potholeMap',
        builder: (context, state) {
          final pothole = state.extra as PotholeModel?;
          return PotholeMapScreen(pothole: pothole);
        },
      ),
      GoRoute(
        path: '/capture-pothole',
        name: 'capturePothole',
        builder: (context, state) => const CapturePotholeScreen(),
      ),
      GoRoute(
        path: '/track-report/:id',
        name: 'trackReport',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return TrackReportScreen(caseId: id);
        },
      ),
      GoRoute(
        path: '/report-captured-pothole',
        name: 'reportCapturedPothole',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReportCapturedPotholeScreen(
            images: extra?['preCapturedImages'] as List<File>,
            latitude: extra?['preLatitude'] as double,
            longitude: extra?['preLongitude'] as double,
            accuracy: extra?['preAccuracy'] as double,
            coordinates: extra?['preCoordinates'] as List<Map<String, double>>,
          );
        },
      ),
      GoRoute(
        path: '/take-action-aee',
        name: 'takeActionAee',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TakeActionAeeScreen(
            caseId: extra?['caseId'] as String? ?? '',
            reportId: extra?['reportId'] as String? ?? '',
            fromFragment: extra?['fromFragment'] as String? ?? 'review_aee',
          );
        },
      ),
      GoRoute(
        path: '/take-action-se',
        name: 'takeActionSe',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TakeActionSeScreen(
            caseId: extra?['caseId'] as String? ?? '',
            reportId: extra?['reportId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/take-action-ee',
        name: 'takeActionEe',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return TakeActionEeScreen(
            caseId: extras?['caseId'] ?? '',
            reportId: extras?['reportId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/assign-report-ee',
        name: 'assignReportEe',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return AssignReportEeScreen(
            caseId: extras?['caseId'] ?? '',
            reportId: extras?['reportId'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/assign-to-field-engineers',
        name: 'assignToFieldEngineers',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AssignToFieldEngineersScreen(initialTab: extra?['initialTab'] ?? 0);
        },
      ),
      GoRoute(
        path: '/self-inspection-aee',
        name: 'selfInspectionAee',
        builder: (context, state) => const SelfInspectionAeeScreen(),
      ),
      GoRoute(
        path: '/assign-report-details',
        name: 'assignReportDetails',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AssignReportDetailsScreen(
            caseId: extra?['caseId'] as String? ?? '',
            reportId: extra?['reportId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/my-reports-aee',
        name: 'myReportsAee',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return MyReportsAeeScreen(initialTab: extra?['initialTab']);
        },
      ),
      GoRoute(
        path: '/self-captured-aee',
        name: 'selfCapturedAee',
        builder: (context, state) => const SelfCapturedAeeScreen(),
      ),
      GoRoute(
        path: '/review-inspections-aee',
        name: 'reviewInspectionsAee',
        builder: (context, state) => const ReviewInspectionsAeeScreen(),
      ),
      GoRoute(
        path: '/field-inspection',
        name: 'fieldInspection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return FieldInspectionScreen(
            caseId: extra['caseId'] as String? ?? '',
            reportId: extra['reportId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/submit-final-je-ae',
        name: 'submitFinalReport',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SubmitFinalReportScreen(
            caseId: extra['caseId'] as String? ?? '',
            reportId: extra['reportId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/vendor-fix',
        name: 'vendorFix',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VendorFixScreen(
            caseId: extra?['caseId'] as String? ?? '',
            reportId: extra?['reportId'] as String? ?? '',
            alreadyArrived: extra?['alreadyArrived'] as bool? ?? false,
            repairOnly: extra?['repairOnly'] as bool? ?? false,
            report: extra?['report'],
          );
        },
      ),
    ],
  );
}

/// Route names for type-safe navigation
class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String completeProfile = '/complete-profile';
  static const String main = '/main';
  static const String reportDetail = '/report';
  static const String createReport = '/create-report';
  static const String reportList = '/report-list';
  static const String potholeMap = '/pothole-map';
  static const String capturePothole = '/capture-pothole';
  static const String trackReport = '/track-report';
  static const String takeActionSe = '/take-action-se';
  static const String takeActionEe = '/take-action-ee';
  static const String takeActionAee = '/take-action-aee';
  static const String assignToFieldEngineers = '/assign-to-field-engineers';
  static const String selfInspectionAee = '/self-inspection-aee';
  static const String assignReportDetails = '/assign-report-details';
  static const String fieldInspection = '/field-inspection';
  static const String vendorFix = '/vendor-fix';
}

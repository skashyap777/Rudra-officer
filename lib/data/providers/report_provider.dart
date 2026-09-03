import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';
import '../repositories/report_repository.dart';
import 'auth_provider.dart';

/// Report Notifier - Manages report state
class ReportNotifier extends StateNotifier<AsyncValue<List<PotholeModel>>> {
  final Ref _ref;
  ReportRepository? _reportRepository;

  ReportNotifier({required Ref ref})
    : _ref = ref,
      super(const AsyncValue.data([]));

  Future<ReportRepository> _getRepo() async {
    _reportRepository ??= await _ref.read(reportRepositoryProvider.future);
    return _reportRepository!;
  }

  int _currentPage = 1;
  bool _hasMore = true;

  /// Load reports with pagination
  Future<void> loadReports({required String type, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    state = const AsyncValue.loading();

    try {
      final repo = await _getRepo();
      List<PotholeModel> reports = [];

      String endpoint = '';
      String? filterParam;
      int pageLimit = 20;
      final user = _ref.read(currentUserProvider);
      final userRole = type.endsWith('_ae')
          ? 'ae'
          : type.endsWith('_je')
          ? 'je'
          : user?.userType.toLowerCase();

      switch (type) {
        // SE endpoints
        case 'pending_se':
          endpoint = ApiEndpoints.reviewInspectionReportSe;
          break;
        case 'returned_se':
          endpoint = ApiEndpoints.reassignedCasesSe;
          break;
        case 'completed_se':
          endpoint = ApiEndpoints.completedCaseSe;
          break;

        // EE endpoints
        case 'pending_ee':
          endpoint = ApiEndpoints.pendingReassignEe;
          filterParam = 'pending';
          break;
        case 'assign_aee_ee':
          endpoint = ApiEndpoints.pendingReassignEe;
          filterParam = 'reassigned';
          break;
        case 'review_ee':
          endpoint = ApiEndpoints.reviewInspectionReportEe;
          break;
        case 'assigned_ee':
        case 'in_progress_ee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          filterParam = 'assigned';
          break;
        case 'reassigned_ee':
        case 'reassigned_aee_ee':
          endpoint = ApiEndpoints.pendingReassignEe;
          filterParam = 'reassigned';
          pageLimit = 5;
          break;
        case 'completed_ee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          filterParam = 'completed';
          break;
        case 'rejected_ee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          filterParam = 'rejected';
          break;

        // AEE endpoints
        case 'pending_aee':
          endpoint = ApiEndpoints.pendingReassignAee;
          filterParam = 'pending';
          break;
        case 'assign_fe_aee':
          endpoint = ApiEndpoints.pendingReassignAee;
          filterParam = 'reassigned';
          break;
        case 'self_captured_aee':
          endpoint = ApiEndpoints.selfCapturedCasesAee;
          break;
        case 'review_aee':
          endpoint = ApiEndpoints.reviewInspectionReportAee;
          break;
        case 'self_inspection_aee':
          endpoint = ApiEndpoints.assignedCasesToSelfAee;
          break;
        case 'assigned_aee':
        case 'in_progress_aee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          filterParam = 'assigned';
          break;
        case 'reassigned_aee':
          endpoint = ApiEndpoints.pendingReassignAee;
          filterParam = 'reassigned';
          pageLimit = 5;
          break;
        case 'completed_aee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          filterParam = 'completed';
          break;
        case 'rejected_aee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          filterParam = 'rejected';
          break;

        // JE / AE endpoints
        case 'assigned_ae':
        case 'assigned_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.assignedCasesAe
              : ApiEndpoints.assignedCasesJe;
          break;
        case 'pending_ae':
        case 'pending_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.pendingReassignAe
              : ApiEndpoints.pendingReassignJe;
          filterParam = 'pending';
          break;
        case 'self_captured_ae':
        case 'self_captured_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.selfCapturedCasesAe
              : ApiEndpoints.selfCapturedCasesJe;
          break;
        case 'submit_final_ae':
        case 'submit_final_je':
          // Java: API.inspection_completed_cases_je/ae → api/v1/je/completed-inspections
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.inspectionCompletedCasesAe
              : ApiEndpoints.inspectionCompletedCasesJe;
          filterParam = null; // No filter param — dedicated endpoint
          break;
        case 'vendor_assigned_ae':
        case 'vendor_assigned_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.allInspectedCompletedRejectedCasesAe
              : ApiEndpoints.allInspectedCompletedRejectedCasesJe;
          filterParam = 'assigned';
          break;
        case 'completed_ae':
        case 'completed_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.allInspectedCompletedRejectedCasesAe
              : ApiEndpoints.allInspectedCompletedRejectedCasesJe;
          filterParam = 'completed';
          break;
        case 'review_ae':
        case 'review_je':
        case 'inspected_ae':
        case 'inspected_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.allInspectedCompletedRejectedCasesAe
              : ApiEndpoints.allInspectedCompletedRejectedCasesJe;
          filterParam = 'inspected';
          break;
        case 'reassigned_ae':
        case 'reassigned_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.pendingReassignAe
              : ApiEndpoints.pendingReassignJe;
          filterParam = 're-inspect';
          pageLimit = 5;
          break;
        case 'rejected_ae':
        case 'rejected_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.allInspectedCompletedRejectedCasesAe
              : ApiEndpoints.allInspectedCompletedRejectedCasesJe;
          filterParam = 'rejected';
          break;

        // Vendor endpoints
        case 'assigned_vendor':
        case 'pending_vendor':
          endpoint = ApiEndpoints.pendingReassignVendor;
          filterParam = 'pending';
          pageLimit = 5;
          break;
        case 'submit_update_vendor':
          endpoint = ApiEndpoints.finalUpdateCasesVendor;
          pageLimit = 5;
          break;
        case 'reassigned_vendor':
          endpoint = ApiEndpoints.pendingReassignVendor;
          filterParam = 're-assigned';
          pageLimit = 5;
          break;
        case 'review_vendor':
        case 'inspected_vendor':
          endpoint = ApiEndpoints.allInspectedCompletedCasesVendor;
          filterParam = 'sent-for-review';
          break;
        case 'completed_vendor':
          endpoint = ApiEndpoints.allInspectedCompletedCasesVendor;
          filterParam = 'completed';
          break;

        // All Endpoints
        case 'all_ee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          filterParam = 'all';
          break;
        case 'all_aee':
          endpoint = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          filterParam = 'all';
          break;
        case 'all_ae':
        case 'all_je':
          endpoint = (userRole == 'ae')
              ? ApiEndpoints.allInspectedCompletedRejectedCasesAe
              : ApiEndpoints.allInspectedCompletedRejectedCasesJe;
          filterParam = 'all';
          break;
        case 'all_vendor':
          endpoint = ApiEndpoints.allInspectedCompletedCasesVendor;
          filterParam = 'all';
          break;

        default:
          reports = [];
      }

      if (endpoint.isNotEmpty) {
        reports = await repo.getReportsByEndpoint(
          endpoint,
          page: _currentPage,
          limit: pageLimit,
          filter: filterParam,
        );
      }

      _hasMore = reports.length == pageLimit;
      _currentPage++;

      if (refresh) {
        state = AsyncValue.data(reports);
      } else {
        final currentData = state.value ?? [];
        state = AsyncValue.data([...currentData, ...reports]);
      }
    } catch (e, stackTrace) {
      // Clear data to force UI to render error
      state = AsyncValue<List<PotholeModel>>.error(e, stackTrace);
    }
  }
}

/// Report Summary Notifier
class ReportSummaryNotifier
    extends StateNotifier<AsyncValue<ReportSummaryModel?>> {
  final Ref _ref;
  ReportRepository? _reportRepository;

  ReportSummaryNotifier({required Ref ref})
    : _ref = ref,
      super(const AsyncValue.data(null));

  Future<ReportRepository> _getRepo() async {
    _reportRepository ??= await _ref.read(reportRepositoryProvider.future);
    return _reportRepository!;
  }

  Future<void> loadSummary(String role) async {
    state = const AsyncValue.loading();

    try {
      final repo = await _getRepo();
      ReportSummaryModel summary;

      switch (role) {
        case 'se':
          summary = await repo.getReportSummarySe();
          break;
        case 'ee':
          summary = await repo.getReportSummaryEe();
          break;
        case 'aee':
          summary = await repo.getReportSummaryAee();
          break;
        case 'je':
          summary = await repo.getReportSummaryJe();
          break;
        case 'ae':
          summary = await repo.getReportSummaryAe();
          break;
        case 'vendor':
          summary = await repo.getReportSummaryVendor();
          break;
        default:
          summary = const ReportSummaryModel();
      }

      state = AsyncValue.data(summary);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// ==================== PROVIDERS ====================

/// Report Repository Provider - Async because it depends on API service
final reportRepositoryProvider = FutureProvider<ReportRepository>((ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  return ReportRepository(apiService: apiService);
});

/// Report Notifier Provider
final reportProvider =
    StateNotifierProvider<ReportNotifier, AsyncValue<List<PotholeModel>>>((
      ref,
    ) {
      return ReportNotifier(ref: ref);
    });

/// Report Summary Provider
final reportSummaryProvider =
    StateNotifierProvider<
      ReportSummaryNotifier,
      AsyncValue<ReportSummaryModel?>
    >((ref) {
      return ReportSummaryNotifier(ref: ref);
    });

/// Case Detail Provider - Fetches individual case details
final caseDetailProvider = FutureProvider.family<PotholeModel, String>((
  ref,
  caseId,
) async {
  final repository = await ref.watch(reportRepositoryProvider.future);
  return repository.getCaseDetails(caseId);
});

/// Case Proceedings Provider - Fetches history of a case
final caseProceedingsProvider =
    FutureProvider.autoDispose.family<List<CaseProceedingModel>, String>((
      ref,
      caseId,
    ) async {
      final repository = await ref.watch(reportRepositoryProvider.future);
      return repository.getCaseProceedings(caseId);
    });

/// Send Contractor Reminder Action
final sendContractorReminderProvider = Provider.autoDispose((ref) {
  return ({
    required String caseId,
    required String vendorName,
    String? officerName,
    String? remarks,
  }) async {
    final repository = await ref.read(reportRepositoryProvider.future);
    final success = await repository.sendContractorReminder(
      caseId: caseId,
      vendorName: vendorName,
      officerName: officerName,
      remarks: remarks,
    );
    ref.invalidate(caseProceedingsProvider(caseId));
    return success;
  };
});


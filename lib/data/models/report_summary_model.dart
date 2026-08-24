import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_summary_model.freezed.dart';
part 'report_summary_model.g.dart';

/// Report Summary Model - Dashboard counts for each role
@freezed
class ReportSummaryModel with _$ReportSummaryModel {
  const factory ReportSummaryModel({
    // SE specific
    @JsonKey(name: 'pending_reviews') @Default(0) int pendingReviews,
    @JsonKey(name: 'unsatisfied') @Default(0) int unsatisfied,
    @JsonKey(name: 'satisfied') @Default(0) int satisfied,

    // EE / AEE specific
    @JsonKey(name: 'pending_reports') @Default(0) int pendingReports,
    @JsonKey(name: 're_assigned_cases') @Default(0) int reAssignedCases,
    @JsonKey(name: 'assigned_cases') @Default(0) int assignedCases,
    @JsonKey(name: 'in_progress_cases') @Default(0) int inProgressCases,
    @JsonKey(name: 'completed_cases') @Default(0) int completedCases,
    @JsonKey(name: 'review_inspection_count') @Default(0) int reviewInspectionCount,
    
    // AEE specific
    @JsonKey(name: 'self_inspection_report_count') @Default(0) int selfInspectionReportCount,

    // JE / AE specific
    @JsonKey(name: 'pending_inspection_count') @Default(0) int pendingInspectionCount,
    @JsonKey(name: 'assigned_count') @Default(0) int assignedCount,
    @JsonKey(name: 'capture_nearby_pothole_count') @Default(0) int captureNearbyPotholeCount,
    @JsonKey(name: 'sent_for_review') @Default(0) int sentForReview,
    @JsonKey(name: 'completed_count') @Default(0) int completedCount,
    @JsonKey(name: 'submit_final_report_count') @Default(0) int submitFinalReportCount,

    // Vendor specific
    @JsonKey(name: 'pending_count') @Default(0) int pendingCount,
    @JsonKey(name: 'reassigned_count') @Default(0) int reassignedCountVendor,
    @JsonKey(name: 'final_submit_cases_count') @Default(0) int finalSubmitCasesCount,
  }) = _ReportSummaryModel;

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryModelFromJson(json);
}

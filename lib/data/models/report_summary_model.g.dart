// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportSummaryModelImpl _$$ReportSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ReportSummaryModelImpl(
  pendingReviews: (json['pending_reviews'] as num?)?.toInt() ?? 0,
  unsatisfied: (json['unsatisfied'] as num?)?.toInt() ?? 0,
  satisfied: (json['satisfied'] as num?)?.toInt() ?? 0,
  pendingReports: (json['pending_reports'] as num?)?.toInt() ?? 0,
  reAssignedCases: (json['re_assigned_cases'] as num?)?.toInt() ?? 0,
  assignedCases: (json['assigned_cases'] as num?)?.toInt() ?? 0,
  inProgressCases: (json['in_progress_cases'] as num?)?.toInt() ?? 0,
  completedCases: (json['completed_cases'] as num?)?.toInt() ?? 0,
  reviewInspectionCount:
      (json['review_inspection_count'] as num?)?.toInt() ?? 0,
  selfInspectionReportCount:
      (json['self_inspection_report_count'] as num?)?.toInt() ?? 0,
  pendingInspectionCount:
      (json['pending_inspection_count'] as num?)?.toInt() ?? 0,
  assignedCount: (json['assigned_count'] as num?)?.toInt() ?? 0,
  captureNearbyPotholeCount:
      (json['capture_nearby_pothole_count'] as num?)?.toInt() ?? 0,
  sentForReview: (json['sent_for_review'] as num?)?.toInt() ?? 0,
  completedCount: (json['completed_count'] as num?)?.toInt() ?? 0,
  submitFinalReportCount:
      (json['submit_final_report_count'] as num?)?.toInt() ?? 0,
  pendingCount: (json['pending_count'] as num?)?.toInt() ?? 0,
  reassignedCountVendor: (json['reassigned_count'] as num?)?.toInt() ?? 0,
  finalSubmitCasesCount:
      (json['final_submit_cases_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$ReportSummaryModelImplToJson(
  _$ReportSummaryModelImpl instance,
) => <String, dynamic>{
  'pending_reviews': instance.pendingReviews,
  'unsatisfied': instance.unsatisfied,
  'satisfied': instance.satisfied,
  'pending_reports': instance.pendingReports,
  're_assigned_cases': instance.reAssignedCases,
  'assigned_cases': instance.assignedCases,
  'in_progress_cases': instance.inProgressCases,
  'completed_cases': instance.completedCases,
  'review_inspection_count': instance.reviewInspectionCount,
  'self_inspection_report_count': instance.selfInspectionReportCount,
  'pending_inspection_count': instance.pendingInspectionCount,
  'assigned_count': instance.assignedCount,
  'capture_nearby_pothole_count': instance.captureNearbyPotholeCount,
  'sent_for_review': instance.sentForReview,
  'completed_count': instance.completedCount,
  'submit_final_report_count': instance.submitFinalReportCount,
  'pending_count': instance.pendingCount,
  'reassigned_count': instance.reassignedCountVendor,
  'final_submit_cases_count': instance.finalSubmitCasesCount,
};

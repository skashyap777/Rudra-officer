// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportSummaryModel _$ReportSummaryModelFromJson(Map<String, dynamic> json) {
  return _ReportSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ReportSummaryModel {
  // SE specific
  @JsonKey(name: 'pending_reviews')
  int get pendingReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsatisfied')
  int get unsatisfied => throw _privateConstructorUsedError;
  @JsonKey(name: 'satisfied')
  int get satisfied => throw _privateConstructorUsedError; // EE / AEE specific
  @JsonKey(name: 'pending_reports')
  int get pendingReports => throw _privateConstructorUsedError;
  @JsonKey(name: 're_assigned_cases')
  int get reAssignedCases => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_cases')
  int get assignedCases => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_progress_cases')
  int get inProgressCases => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_cases')
  int get completedCases => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_inspection_count')
  int get reviewInspectionCount => throw _privateConstructorUsedError; // AEE specific
  @JsonKey(name: 'self_inspection_report_count')
  int get selfInspectionReportCount => throw _privateConstructorUsedError; // JE / AE specific
  @JsonKey(name: 'pending_inspection_count')
  int get pendingInspectionCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_count')
  int get assignedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'capture_nearby_pothole_count')
  int get captureNearbyPotholeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_for_review')
  int get sentForReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_count')
  int get completedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'submit_final_report_count')
  int get submitFinalReportCount => throw _privateConstructorUsedError; // Vendor specific
  @JsonKey(name: 'pending_count')
  int get pendingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reassigned_count')
  int get reassignedCountVendor => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_submit_cases_count')
  int get finalSubmitCasesCount => throw _privateConstructorUsedError;

  /// Serializes this ReportSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportSummaryModelCopyWith<ReportSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportSummaryModelCopyWith<$Res> {
  factory $ReportSummaryModelCopyWith(
    ReportSummaryModel value,
    $Res Function(ReportSummaryModel) then,
  ) = _$ReportSummaryModelCopyWithImpl<$Res, ReportSummaryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'pending_reviews') int pendingReviews,
    @JsonKey(name: 'unsatisfied') int unsatisfied,
    @JsonKey(name: 'satisfied') int satisfied,
    @JsonKey(name: 'pending_reports') int pendingReports,
    @JsonKey(name: 're_assigned_cases') int reAssignedCases,
    @JsonKey(name: 'assigned_cases') int assignedCases,
    @JsonKey(name: 'in_progress_cases') int inProgressCases,
    @JsonKey(name: 'completed_cases') int completedCases,
    @JsonKey(name: 'review_inspection_count') int reviewInspectionCount,
    @JsonKey(name: 'self_inspection_report_count')
    int selfInspectionReportCount,
    @JsonKey(name: 'pending_inspection_count') int pendingInspectionCount,
    @JsonKey(name: 'assigned_count') int assignedCount,
    @JsonKey(name: 'capture_nearby_pothole_count')
    int captureNearbyPotholeCount,
    @JsonKey(name: 'sent_for_review') int sentForReview,
    @JsonKey(name: 'completed_count') int completedCount,
    @JsonKey(name: 'submit_final_report_count') int submitFinalReportCount,
    @JsonKey(name: 'pending_count') int pendingCount,
    @JsonKey(name: 'reassigned_count') int reassignedCountVendor,
    @JsonKey(name: 'final_submit_cases_count') int finalSubmitCasesCount,
  });
}

/// @nodoc
class _$ReportSummaryModelCopyWithImpl<$Res, $Val extends ReportSummaryModel>
    implements $ReportSummaryModelCopyWith<$Res> {
  _$ReportSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingReviews = null,
    Object? unsatisfied = null,
    Object? satisfied = null,
    Object? pendingReports = null,
    Object? reAssignedCases = null,
    Object? assignedCases = null,
    Object? inProgressCases = null,
    Object? completedCases = null,
    Object? reviewInspectionCount = null,
    Object? selfInspectionReportCount = null,
    Object? pendingInspectionCount = null,
    Object? assignedCount = null,
    Object? captureNearbyPotholeCount = null,
    Object? sentForReview = null,
    Object? completedCount = null,
    Object? submitFinalReportCount = null,
    Object? pendingCount = null,
    Object? reassignedCountVendor = null,
    Object? finalSubmitCasesCount = null,
  }) {
    return _then(
      _value.copyWith(
            pendingReviews: null == pendingReviews
                ? _value.pendingReviews
                : pendingReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            unsatisfied: null == unsatisfied
                ? _value.unsatisfied
                : unsatisfied // ignore: cast_nullable_to_non_nullable
                      as int,
            satisfied: null == satisfied
                ? _value.satisfied
                : satisfied // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingReports: null == pendingReports
                ? _value.pendingReports
                : pendingReports // ignore: cast_nullable_to_non_nullable
                      as int,
            reAssignedCases: null == reAssignedCases
                ? _value.reAssignedCases
                : reAssignedCases // ignore: cast_nullable_to_non_nullable
                      as int,
            assignedCases: null == assignedCases
                ? _value.assignedCases
                : assignedCases // ignore: cast_nullable_to_non_nullable
                      as int,
            inProgressCases: null == inProgressCases
                ? _value.inProgressCases
                : inProgressCases // ignore: cast_nullable_to_non_nullable
                      as int,
            completedCases: null == completedCases
                ? _value.completedCases
                : completedCases // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewInspectionCount: null == reviewInspectionCount
                ? _value.reviewInspectionCount
                : reviewInspectionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            selfInspectionReportCount: null == selfInspectionReportCount
                ? _value.selfInspectionReportCount
                : selfInspectionReportCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingInspectionCount: null == pendingInspectionCount
                ? _value.pendingInspectionCount
                : pendingInspectionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            assignedCount: null == assignedCount
                ? _value.assignedCount
                : assignedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            captureNearbyPotholeCount: null == captureNearbyPotholeCount
                ? _value.captureNearbyPotholeCount
                : captureNearbyPotholeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sentForReview: null == sentForReview
                ? _value.sentForReview
                : sentForReview // ignore: cast_nullable_to_non_nullable
                      as int,
            completedCount: null == completedCount
                ? _value.completedCount
                : completedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            submitFinalReportCount: null == submitFinalReportCount
                ? _value.submitFinalReportCount
                : submitFinalReportCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingCount: null == pendingCount
                ? _value.pendingCount
                : pendingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            reassignedCountVendor: null == reassignedCountVendor
                ? _value.reassignedCountVendor
                : reassignedCountVendor // ignore: cast_nullable_to_non_nullable
                      as int,
            finalSubmitCasesCount: null == finalSubmitCasesCount
                ? _value.finalSubmitCasesCount
                : finalSubmitCasesCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportSummaryModelImplCopyWith<$Res>
    implements $ReportSummaryModelCopyWith<$Res> {
  factory _$$ReportSummaryModelImplCopyWith(
    _$ReportSummaryModelImpl value,
    $Res Function(_$ReportSummaryModelImpl) then,
  ) = __$$ReportSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'pending_reviews') int pendingReviews,
    @JsonKey(name: 'unsatisfied') int unsatisfied,
    @JsonKey(name: 'satisfied') int satisfied,
    @JsonKey(name: 'pending_reports') int pendingReports,
    @JsonKey(name: 're_assigned_cases') int reAssignedCases,
    @JsonKey(name: 'assigned_cases') int assignedCases,
    @JsonKey(name: 'in_progress_cases') int inProgressCases,
    @JsonKey(name: 'completed_cases') int completedCases,
    @JsonKey(name: 'review_inspection_count') int reviewInspectionCount,
    @JsonKey(name: 'self_inspection_report_count')
    int selfInspectionReportCount,
    @JsonKey(name: 'pending_inspection_count') int pendingInspectionCount,
    @JsonKey(name: 'assigned_count') int assignedCount,
    @JsonKey(name: 'capture_nearby_pothole_count')
    int captureNearbyPotholeCount,
    @JsonKey(name: 'sent_for_review') int sentForReview,
    @JsonKey(name: 'completed_count') int completedCount,
    @JsonKey(name: 'submit_final_report_count') int submitFinalReportCount,
    @JsonKey(name: 'pending_count') int pendingCount,
    @JsonKey(name: 'reassigned_count') int reassignedCountVendor,
    @JsonKey(name: 'final_submit_cases_count') int finalSubmitCasesCount,
  });
}

/// @nodoc
class __$$ReportSummaryModelImplCopyWithImpl<$Res>
    extends _$ReportSummaryModelCopyWithImpl<$Res, _$ReportSummaryModelImpl>
    implements _$$ReportSummaryModelImplCopyWith<$Res> {
  __$$ReportSummaryModelImplCopyWithImpl(
    _$ReportSummaryModelImpl _value,
    $Res Function(_$ReportSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingReviews = null,
    Object? unsatisfied = null,
    Object? satisfied = null,
    Object? pendingReports = null,
    Object? reAssignedCases = null,
    Object? assignedCases = null,
    Object? inProgressCases = null,
    Object? completedCases = null,
    Object? reviewInspectionCount = null,
    Object? selfInspectionReportCount = null,
    Object? pendingInspectionCount = null,
    Object? assignedCount = null,
    Object? captureNearbyPotholeCount = null,
    Object? sentForReview = null,
    Object? completedCount = null,
    Object? submitFinalReportCount = null,
    Object? pendingCount = null,
    Object? reassignedCountVendor = null,
    Object? finalSubmitCasesCount = null,
  }) {
    return _then(
      _$ReportSummaryModelImpl(
        pendingReviews: null == pendingReviews
            ? _value.pendingReviews
            : pendingReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        unsatisfied: null == unsatisfied
            ? _value.unsatisfied
            : unsatisfied // ignore: cast_nullable_to_non_nullable
                  as int,
        satisfied: null == satisfied
            ? _value.satisfied
            : satisfied // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingReports: null == pendingReports
            ? _value.pendingReports
            : pendingReports // ignore: cast_nullable_to_non_nullable
                  as int,
        reAssignedCases: null == reAssignedCases
            ? _value.reAssignedCases
            : reAssignedCases // ignore: cast_nullable_to_non_nullable
                  as int,
        assignedCases: null == assignedCases
            ? _value.assignedCases
            : assignedCases // ignore: cast_nullable_to_non_nullable
                  as int,
        inProgressCases: null == inProgressCases
            ? _value.inProgressCases
            : inProgressCases // ignore: cast_nullable_to_non_nullable
                  as int,
        completedCases: null == completedCases
            ? _value.completedCases
            : completedCases // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewInspectionCount: null == reviewInspectionCount
            ? _value.reviewInspectionCount
            : reviewInspectionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        selfInspectionReportCount: null == selfInspectionReportCount
            ? _value.selfInspectionReportCount
            : selfInspectionReportCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingInspectionCount: null == pendingInspectionCount
            ? _value.pendingInspectionCount
            : pendingInspectionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        assignedCount: null == assignedCount
            ? _value.assignedCount
            : assignedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        captureNearbyPotholeCount: null == captureNearbyPotholeCount
            ? _value.captureNearbyPotholeCount
            : captureNearbyPotholeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sentForReview: null == sentForReview
            ? _value.sentForReview
            : sentForReview // ignore: cast_nullable_to_non_nullable
                  as int,
        completedCount: null == completedCount
            ? _value.completedCount
            : completedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        submitFinalReportCount: null == submitFinalReportCount
            ? _value.submitFinalReportCount
            : submitFinalReportCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingCount: null == pendingCount
            ? _value.pendingCount
            : pendingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reassignedCountVendor: null == reassignedCountVendor
            ? _value.reassignedCountVendor
            : reassignedCountVendor // ignore: cast_nullable_to_non_nullable
                  as int,
        finalSubmitCasesCount: null == finalSubmitCasesCount
            ? _value.finalSubmitCasesCount
            : finalSubmitCasesCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportSummaryModelImpl implements _ReportSummaryModel {
  const _$ReportSummaryModelImpl({
    @JsonKey(name: 'pending_reviews') this.pendingReviews = 0,
    @JsonKey(name: 'unsatisfied') this.unsatisfied = 0,
    @JsonKey(name: 'satisfied') this.satisfied = 0,
    @JsonKey(name: 'pending_reports') this.pendingReports = 0,
    @JsonKey(name: 're_assigned_cases') this.reAssignedCases = 0,
    @JsonKey(name: 'assigned_cases') this.assignedCases = 0,
    @JsonKey(name: 'in_progress_cases') this.inProgressCases = 0,
    @JsonKey(name: 'completed_cases') this.completedCases = 0,
    @JsonKey(name: 'review_inspection_count') this.reviewInspectionCount = 0,
    @JsonKey(name: 'self_inspection_report_count')
    this.selfInspectionReportCount = 0,
    @JsonKey(name: 'pending_inspection_count') this.pendingInspectionCount = 0,
    @JsonKey(name: 'assigned_count') this.assignedCount = 0,
    @JsonKey(name: 'capture_nearby_pothole_count')
    this.captureNearbyPotholeCount = 0,
    @JsonKey(name: 'sent_for_review') this.sentForReview = 0,
    @JsonKey(name: 'completed_count') this.completedCount = 0,
    @JsonKey(name: 'submit_final_report_count') this.submitFinalReportCount = 0,
    @JsonKey(name: 'pending_count') this.pendingCount = 0,
    @JsonKey(name: 'reassigned_count') this.reassignedCountVendor = 0,
    @JsonKey(name: 'final_submit_cases_count') this.finalSubmitCasesCount = 0,
  });

  factory _$ReportSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportSummaryModelImplFromJson(json);

  // SE specific
  @override
  @JsonKey(name: 'pending_reviews')
  final int pendingReviews;
  @override
  @JsonKey(name: 'unsatisfied')
  final int unsatisfied;
  @override
  @JsonKey(name: 'satisfied')
  final int satisfied;
  // EE / AEE specific
  @override
  @JsonKey(name: 'pending_reports')
  final int pendingReports;
  @override
  @JsonKey(name: 're_assigned_cases')
  final int reAssignedCases;
  @override
  @JsonKey(name: 'assigned_cases')
  final int assignedCases;
  @override
  @JsonKey(name: 'in_progress_cases')
  final int inProgressCases;
  @override
  @JsonKey(name: 'completed_cases')
  final int completedCases;
  @override
  @JsonKey(name: 'review_inspection_count')
  final int reviewInspectionCount;
  // AEE specific
  @override
  @JsonKey(name: 'self_inspection_report_count')
  final int selfInspectionReportCount;
  // JE / AE specific
  @override
  @JsonKey(name: 'pending_inspection_count')
  final int pendingInspectionCount;
  @override
  @JsonKey(name: 'assigned_count')
  final int assignedCount;
  @override
  @JsonKey(name: 'capture_nearby_pothole_count')
  final int captureNearbyPotholeCount;
  @override
  @JsonKey(name: 'sent_for_review')
  final int sentForReview;
  @override
  @JsonKey(name: 'completed_count')
  final int completedCount;
  @override
  @JsonKey(name: 'submit_final_report_count')
  final int submitFinalReportCount;
  // Vendor specific
  @override
  @JsonKey(name: 'pending_count')
  final int pendingCount;
  @override
  @JsonKey(name: 'reassigned_count')
  final int reassignedCountVendor;
  @override
  @JsonKey(name: 'final_submit_cases_count')
  final int finalSubmitCasesCount;

  @override
  String toString() {
    return 'ReportSummaryModel(pendingReviews: $pendingReviews, unsatisfied: $unsatisfied, satisfied: $satisfied, pendingReports: $pendingReports, reAssignedCases: $reAssignedCases, assignedCases: $assignedCases, inProgressCases: $inProgressCases, completedCases: $completedCases, reviewInspectionCount: $reviewInspectionCount, selfInspectionReportCount: $selfInspectionReportCount, pendingInspectionCount: $pendingInspectionCount, assignedCount: $assignedCount, captureNearbyPotholeCount: $captureNearbyPotholeCount, sentForReview: $sentForReview, completedCount: $completedCount, submitFinalReportCount: $submitFinalReportCount, pendingCount: $pendingCount, reassignedCountVendor: $reassignedCountVendor, finalSubmitCasesCount: $finalSubmitCasesCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportSummaryModelImpl &&
            (identical(other.pendingReviews, pendingReviews) ||
                other.pendingReviews == pendingReviews) &&
            (identical(other.unsatisfied, unsatisfied) ||
                other.unsatisfied == unsatisfied) &&
            (identical(other.satisfied, satisfied) ||
                other.satisfied == satisfied) &&
            (identical(other.pendingReports, pendingReports) ||
                other.pendingReports == pendingReports) &&
            (identical(other.reAssignedCases, reAssignedCases) ||
                other.reAssignedCases == reAssignedCases) &&
            (identical(other.assignedCases, assignedCases) ||
                other.assignedCases == assignedCases) &&
            (identical(other.inProgressCases, inProgressCases) ||
                other.inProgressCases == inProgressCases) &&
            (identical(other.completedCases, completedCases) ||
                other.completedCases == completedCases) &&
            (identical(other.reviewInspectionCount, reviewInspectionCount) ||
                other.reviewInspectionCount == reviewInspectionCount) &&
            (identical(
                  other.selfInspectionReportCount,
                  selfInspectionReportCount,
                ) ||
                other.selfInspectionReportCount == selfInspectionReportCount) &&
            (identical(other.pendingInspectionCount, pendingInspectionCount) ||
                other.pendingInspectionCount == pendingInspectionCount) &&
            (identical(other.assignedCount, assignedCount) ||
                other.assignedCount == assignedCount) &&
            (identical(
                  other.captureNearbyPotholeCount,
                  captureNearbyPotholeCount,
                ) ||
                other.captureNearbyPotholeCount == captureNearbyPotholeCount) &&
            (identical(other.sentForReview, sentForReview) ||
                other.sentForReview == sentForReview) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.submitFinalReportCount, submitFinalReportCount) ||
                other.submitFinalReportCount == submitFinalReportCount) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.reassignedCountVendor, reassignedCountVendor) ||
                other.reassignedCountVendor == reassignedCountVendor) &&
            (identical(other.finalSubmitCasesCount, finalSubmitCasesCount) ||
                other.finalSubmitCasesCount == finalSubmitCasesCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    pendingReviews,
    unsatisfied,
    satisfied,
    pendingReports,
    reAssignedCases,
    assignedCases,
    inProgressCases,
    completedCases,
    reviewInspectionCount,
    selfInspectionReportCount,
    pendingInspectionCount,
    assignedCount,
    captureNearbyPotholeCount,
    sentForReview,
    completedCount,
    submitFinalReportCount,
    pendingCount,
    reassignedCountVendor,
    finalSubmitCasesCount,
  ]);

  /// Create a copy of ReportSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportSummaryModelImplCopyWith<_$ReportSummaryModelImpl> get copyWith =>
      __$$ReportSummaryModelImplCopyWithImpl<_$ReportSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportSummaryModelImplToJson(this);
  }
}

abstract class _ReportSummaryModel implements ReportSummaryModel {
  const factory _ReportSummaryModel({
    @JsonKey(name: 'pending_reviews') final int pendingReviews,
    @JsonKey(name: 'unsatisfied') final int unsatisfied,
    @JsonKey(name: 'satisfied') final int satisfied,
    @JsonKey(name: 'pending_reports') final int pendingReports,
    @JsonKey(name: 're_assigned_cases') final int reAssignedCases,
    @JsonKey(name: 'assigned_cases') final int assignedCases,
    @JsonKey(name: 'in_progress_cases') final int inProgressCases,
    @JsonKey(name: 'completed_cases') final int completedCases,
    @JsonKey(name: 'review_inspection_count') final int reviewInspectionCount,
    @JsonKey(name: 'self_inspection_report_count')
    final int selfInspectionReportCount,
    @JsonKey(name: 'pending_inspection_count') final int pendingInspectionCount,
    @JsonKey(name: 'assigned_count') final int assignedCount,
    @JsonKey(name: 'capture_nearby_pothole_count')
    final int captureNearbyPotholeCount,
    @JsonKey(name: 'sent_for_review') final int sentForReview,
    @JsonKey(name: 'completed_count') final int completedCount,
    @JsonKey(name: 'submit_final_report_count')
    final int submitFinalReportCount,
    @JsonKey(name: 'pending_count') final int pendingCount,
    @JsonKey(name: 'reassigned_count') final int reassignedCountVendor,
    @JsonKey(name: 'final_submit_cases_count') final int finalSubmitCasesCount,
  }) = _$ReportSummaryModelImpl;

  factory _ReportSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ReportSummaryModelImpl.fromJson;

  // SE specific
  @override
  @JsonKey(name: 'pending_reviews')
  int get pendingReviews;
  @override
  @JsonKey(name: 'unsatisfied')
  int get unsatisfied;
  @override
  @JsonKey(name: 'satisfied')
  int get satisfied; // EE / AEE specific
  @override
  @JsonKey(name: 'pending_reports')
  int get pendingReports;
  @override
  @JsonKey(name: 're_assigned_cases')
  int get reAssignedCases;
  @override
  @JsonKey(name: 'assigned_cases')
  int get assignedCases;
  @override
  @JsonKey(name: 'in_progress_cases')
  int get inProgressCases;
  @override
  @JsonKey(name: 'completed_cases')
  int get completedCases;
  @override
  @JsonKey(name: 'review_inspection_count')
  int get reviewInspectionCount; // AEE specific
  @override
  @JsonKey(name: 'self_inspection_report_count')
  int get selfInspectionReportCount; // JE / AE specific
  @override
  @JsonKey(name: 'pending_inspection_count')
  int get pendingInspectionCount;
  @override
  @JsonKey(name: 'assigned_count')
  int get assignedCount;
  @override
  @JsonKey(name: 'capture_nearby_pothole_count')
  int get captureNearbyPotholeCount;
  @override
  @JsonKey(name: 'sent_for_review')
  int get sentForReview;
  @override
  @JsonKey(name: 'completed_count')
  int get completedCount;
  @override
  @JsonKey(name: 'submit_final_report_count')
  int get submitFinalReportCount; // Vendor specific
  @override
  @JsonKey(name: 'pending_count')
  int get pendingCount;
  @override
  @JsonKey(name: 'reassigned_count')
  int get reassignedCountVendor;
  @override
  @JsonKey(name: 'final_submit_cases_count')
  int get finalSubmitCasesCount;

  /// Create a copy of ReportSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportSummaryModelImplCopyWith<_$ReportSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

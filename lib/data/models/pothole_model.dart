import 'package:freezed_annotation/freezed_annotation.dart';

part 'pothole_model.freezed.dart';
part 'pothole_model.g.dart';

String? _parseNullableString(dynamic value) => value?.toString();
Object? _readPhotoUrl(Map json, String key) => json[key] ?? json['photo_url'];

String? _parseAssignedBy(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map) {
    return value['display']?.toString() ?? value['name']?.toString() ?? value.toString();
  }
  return value.toString();
}

/// Pothole/Case Model - Main data structure for pothole reports
@freezed
class PotholeModel with _$PotholeModel {
  const factory PotholeModel({
    required int id,
    @JsonKey(name: 'case_id') required String caseId,
    required String status,
    String? description,
    double? latitude,
    double? longitude,
    double? accuracy,
    @JsonKey(name: 'location_name') String? location,
    String? address,
    String? category,
    @JsonKey(name: 'road_name') String? roadName,
    @JsonKey(name: 'image_urls') List<String>? imageUrls,
    @JsonKey(name: 'image') List<String>? image,
    @JsonKey(name: 'pothole_images') List<PotholePhoto>? potholeImages,
    @JsonKey(name: 'officer_reports') List<OfficerReportModel>? officerReports,
    @JsonKey(name: 'reported_by') ReportedBy? reportedBy,
    @JsonKey(name: 'inspected_by') InspectedBy? inspectedBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'report_date') DateTime? reportDate,
    @JsonKey(name: 'assigned_date') DateTime? assignedDate,
    @JsonKey(name: 'completed_date') DateTime? completedDate,
    @JsonKey(name: 'assigned_to') dynamic assignedTo,
    @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
    String? assignedToName,
    @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy)
    String? assignedBy,
    @JsonKey(name: 'pending_at', fromJson: _parseNullableString)
    String? pendingAt,
    @JsonKey(name: 'remarks') String? remarks,
    @JsonKey(name: 'severity') String? severity,
    @JsonKey(name: 'division_name') String? divisionName,
    @JsonKey(name: 'priority') String? priority,
    @JsonKey(name: 'district') String? district,
    @JsonKey(name: 'division') String? division,
    @JsonKey(name: 'circle', fromJson: _parseNullableString) String? circle,
    @JsonKey(name: 'pincode', fromJson: _parseNullableString) String? pincode,
    @JsonKey(name: 'estimated_cost') double? estimatedCost,
    @JsonKey(name: 'actual_cost') double? actualCost,
    @JsonKey(name: 'vendor_name') String? vendorName,
    @JsonKey(name: 'vendor_user_id') int? vendorUserId,
    @JsonKey(name: 'vendor_acc_confirmed')
    @Default(false)
    bool vendorAccConfirmed,
    @JsonKey(name: 'inspection_date') DateTime? inspectionDate,
    @JsonKey(name: 'completion_date') DateTime? completionDate,
    @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
    String? rejectedReason,
    @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
    String? rejectedBy,
    @JsonKey(name: 'check_if_send_to_vendor') @Default(false) bool checkIfSendToVendor,
  }) = _PotholeModel;

  const PotholeModel._();

  factory PotholeModel.fromJson(Map<String, dynamic> json) =>
      _$PotholeModelFromJson(json);

  bool get isPending => status == 'pending';
  bool get isAssigned => status == 'assigned';
  bool get isInspected => status == 'inspected';
  bool get isCompleted => status == 'completed';
  bool get isRejected => status == 'rejected';

  // Helper getters for AEE self-inspection state
  bool get hasNothing => officerReports == null || officerReports!.isEmpty;
  bool get hasOnlyBefore => !hasNothing && officerReports!.first.status?.toLowerCase() == 'saved';
  bool get hasBeforeAndAfter => !hasNothing && officerReports!.first.status?.toLowerCase() != 'saved';
}

@freezed
class ReportedBy with _$ReportedBy {
  const factory ReportedBy({
    String? name,
    String? time,
    String? remark,
    String? designation,
  }) = _ReportedBy;

  factory ReportedBy.fromJson(Map<String, dynamic> json) =>
      _$ReportedByFromJson(json);
}

@freezed
class InspectedBy with _$InspectedBy {
  const factory InspectedBy({
    String? name,
    String? date,
    String? designation,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  }) = _InspectedBy;

  factory InspectedBy.fromJson(Map<String, dynamic> json) =>
      _$InspectedByFromJson(json);
}

@freezed
class OfficerReportModel with _$OfficerReportModel {
  const factory OfficerReportModel({
    String? status,
    @JsonKey(name: 'after_fix_photos') List<PotholePhoto>? afterFixPhotos,
    @JsonKey(name: 'potholes_data') List<PotholeDimension>? potholesData,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  }) = _OfficerReportModel;

  factory OfficerReportModel.fromJson(Map<String, dynamic> json) =>
      _$OfficerReportModelFromJson(json);
}

@freezed
class PotholeDimension with _$PotholeDimension {
  const factory PotholeDimension({
    @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
    String? beforeSurfaceArea,
    @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
    String? beforeDepth,
    @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
    String? afterSurfaceArea,
    @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
    String? afterDepth,
    @JsonKey(name: 'photos') List<PotholePhoto>? photos,
  }) = _PotholeDimension;

  factory PotholeDimension.fromJson(Map<String, dynamic> json) =>
      _$PotholeDimensionFromJson(json);
}

@freezed
class PotholePhoto with _$PotholePhoto {
  const factory PotholePhoto({
    @JsonKey(name: 'image_url', readValue: _readPhotoUrl) String? photoUrl,
    @JsonKey(name: 'photo_type') String? photoType,
    double? accuracy,
    double? latitude,
    double? longitude,
  }) = _PotholePhoto;

  factory PotholePhoto.fromJson(Map<String, dynamic> json) =>
      _$PotholePhotoFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pothole_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PotholeModelImpl _$$PotholeModelImplFromJson(Map<String, dynamic> json) =>
    _$PotholeModelImpl(
      id: (json['id'] as num).toInt(),
      caseId: json['case_id'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      location: json['location_name'] as String?,
      address: json['address'] as String?,
      category: json['category'] as String?,
      roadName: json['road_name'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      potholeImages: (json['pothole_images'] as List<dynamic>?)
          ?.map((e) => PotholePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      officerReports: (json['officer_reports'] as List<dynamic>?)
          ?.map((e) => OfficerReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportedBy: json['reported_by'] == null
          ? null
          : ReportedBy.fromJson(json['reported_by'] as Map<String, dynamic>),
      inspectedBy: json['inspected_by'] == null
          ? null
          : InspectedBy.fromJson(json['inspected_by'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      reportDate: json['report_date'] == null
          ? null
          : DateTime.parse(json['report_date'] as String),
      assignedDate: json['assigned_date'] == null
          ? null
          : DateTime.parse(json['assigned_date'] as String),
      completedDate: json['completed_date'] == null
          ? null
          : DateTime.parse(json['completed_date'] as String),
      assignedTo: json['assigned_to'],
      assignedToName: _parseNullableString(json['assigned_to_name']),
      assignedBy: _parseAssignedBy(json['assigned_by']),
      pendingAt: _parseNullableString(json['pending_at']),
      remarks: json['remarks'] as String?,
      severity: json['severity'] as String?,
      divisionName: json['division_name'] as String?,
      priority: json['priority'] as String?,
      district: json['district'] as String?,
      division: json['division'] as String?,
      circle: _parseNullableString(json['circle']),
      pincode: _parseNullableString(json['pincode']),
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble(),
      actualCost: (json['actual_cost'] as num?)?.toDouble(),
      vendorName: json['vendor_name'] as String?,
      vendorUserId: (json['vendor_user_id'] as num?)?.toInt(),
      vendorAccConfirmed: json['vendor_acc_confirmed'] as bool? ?? false,
      inspectionDate: json['inspection_date'] == null
          ? null
          : DateTime.parse(json['inspection_date'] as String),
      completionDate: json['completion_date'] == null
          ? null
          : DateTime.parse(json['completion_date'] as String),
      rejectedReason: _parseNullableString(json['rejected_reason']),
      rejectedBy: _parseNullableString(json['rejected_by']),
      checkIfSendToVendor: json['check_if_send_to_vendor'] as bool? ?? false,
    );

Map<String, dynamic> _$$PotholeModelImplToJson(_$PotholeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'case_id': instance.caseId,
      'status': instance.status,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'location_name': instance.location,
      'address': instance.address,
      'category': instance.category,
      'road_name': instance.roadName,
      'image_urls': instance.imageUrls,
      'image': instance.image,
      'pothole_images': instance.potholeImages,
      'officer_reports': instance.officerReports,
      'reported_by': instance.reportedBy,
      'inspected_by': instance.inspectedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'report_date': instance.reportDate?.toIso8601String(),
      'assigned_date': instance.assignedDate?.toIso8601String(),
      'completed_date': instance.completedDate?.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'assigned_to_name': instance.assignedToName,
      'assigned_by': instance.assignedBy,
      'pending_at': instance.pendingAt,
      'remarks': instance.remarks,
      'severity': instance.severity,
      'division_name': instance.divisionName,
      'priority': instance.priority,
      'district': instance.district,
      'division': instance.division,
      'circle': instance.circle,
      'pincode': instance.pincode,
      'estimated_cost': instance.estimatedCost,
      'actual_cost': instance.actualCost,
      'vendor_name': instance.vendorName,
      'vendor_user_id': instance.vendorUserId,
      'vendor_acc_confirmed': instance.vendorAccConfirmed,
      'inspection_date': instance.inspectionDate?.toIso8601String(),
      'completion_date': instance.completionDate?.toIso8601String(),
      'rejected_reason': instance.rejectedReason,
      'rejected_by': instance.rejectedBy,
      'check_if_send_to_vendor': instance.checkIfSendToVendor,
    };

_$ReportedByImpl _$$ReportedByImplFromJson(Map<String, dynamic> json) =>
    _$ReportedByImpl(
      name: json['name'] as String?,
      time: json['time'] as String?,
      remark: json['remark'] as String?,
      designation: json['designation'] as String?,
    );

Map<String, dynamic> _$$ReportedByImplToJson(_$ReportedByImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'time': instance.time,
      'remark': instance.remark,
      'designation': instance.designation,
    };

_$InspectedByImpl _$$InspectedByImplFromJson(Map<String, dynamic> json) =>
    _$InspectedByImpl(
      name: json['name'] as String?,
      date: json['date'] as String?,
      designation: json['designation'] as String?,
      inspectionRemark: json['inspection_remark'] as String?,
      consumptionMaterial: json['consumption_material'] as String?,
    );

Map<String, dynamic> _$$InspectedByImplToJson(_$InspectedByImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
      'designation': instance.designation,
      'inspection_remark': instance.inspectionRemark,
      'consumption_material': instance.consumptionMaterial,
    };

_$OfficerReportModelImpl _$$OfficerReportModelImplFromJson(
  Map<String, dynamic> json,
) => _$OfficerReportModelImpl(
  status: json['status'] as String?,
  afterFixPhotos: (json['after_fix_photos'] as List<dynamic>?)
      ?.map((e) => PotholePhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
  potholesData: (json['potholes_data'] as List<dynamic>?)
      ?.map((e) => PotholeDimension.fromJson(e as Map<String, dynamic>))
      .toList(),
  inspectionRemark: json['inspection_remark'] as String?,
  consumptionMaterial: json['consumption_material'] as String?,
);

Map<String, dynamic> _$$OfficerReportModelImplToJson(
  _$OfficerReportModelImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'after_fix_photos': instance.afterFixPhotos,
  'potholes_data': instance.potholesData,
  'inspection_remark': instance.inspectionRemark,
  'consumption_material': instance.consumptionMaterial,
};

_$PotholeDimensionImpl _$$PotholeDimensionImplFromJson(
  Map<String, dynamic> json,
) => _$PotholeDimensionImpl(
  beforeSurfaceArea: _parseNullableString(json['before_surface_area']),
  beforeDepth: _parseNullableString(json['before_depth']),
  afterSurfaceArea: _parseNullableString(json['after_surface_area']),
  afterDepth: _parseNullableString(json['after_depth']),
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => PotholePhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PotholeDimensionImplToJson(
  _$PotholeDimensionImpl instance,
) => <String, dynamic>{
  'before_surface_area': instance.beforeSurfaceArea,
  'before_depth': instance.beforeDepth,
  'after_surface_area': instance.afterSurfaceArea,
  'after_depth': instance.afterDepth,
  'photos': instance.photos,
};

_$PotholePhotoImpl _$$PotholePhotoImplFromJson(Map<String, dynamic> json) =>
    _$PotholePhotoImpl(
      photoUrl: _readPhotoUrl(json, 'image_url') as String?,
      photoType: json['photo_type'] as String?,
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PotholePhotoImplToJson(_$PotholePhotoImpl instance) =>
    <String, dynamic>{
      'image_url': instance.photoUrl,
      'photo_type': instance.photoType,
      'accuracy': instance.accuracy,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

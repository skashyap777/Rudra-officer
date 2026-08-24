// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pothole_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PotholeModel _$PotholeModelFromJson(Map<String, dynamic> json) {
  return _PotholeModel.fromJson(json);
}

/// @nodoc
mixin _$PotholeModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'case_id')
  String get caseId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get location => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_name')
  String? get roadName => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'image')
  List<String>? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'pothole_images')
  List<PotholePhoto>? get potholeImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'officer_reports')
  List<OfficerReportModel>? get officerReports =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'reported_by')
  ReportedBy? get reportedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspected_by')
  InspectedBy? get inspectedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_date')
  DateTime? get reportDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_date')
  DateTime? get assignedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_date')
  DateTime? get completedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  dynamic get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
  String? get assignedToName => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy)
  String? get assignedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_at', fromJson: _parseNullableString)
  String? get pendingAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'remarks')
  String? get remarks => throw _privateConstructorUsedError;
  @JsonKey(name: 'severity')
  String? get severity => throw _privateConstructorUsedError;
  @JsonKey(name: 'division_name')
  String? get divisionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority')
  String? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'district')
  String? get district => throw _privateConstructorUsedError;
  @JsonKey(name: 'division')
  String? get division => throw _privateConstructorUsedError;
  @JsonKey(name: 'circle', fromJson: _parseNullableString)
  String? get circle => throw _privateConstructorUsedError;
  @JsonKey(name: 'pincode', fromJson: _parseNullableString)
  String? get pincode => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_cost')
  double? get estimatedCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_cost')
  double? get actualCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_name')
  String? get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_user_id')
  int? get vendorUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_acc_confirmed')
  bool get vendorAccConfirmed => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_date')
  DateTime? get inspectionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_date')
  DateTime? get completionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
  String? get rejectedReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
  String? get rejectedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_if_send_to_vendor')
  bool get checkIfSendToVendor => throw _privateConstructorUsedError;

  /// Serializes this PotholeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PotholeModelCopyWith<PotholeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PotholeModelCopyWith<$Res> {
  factory $PotholeModelCopyWith(
    PotholeModel value,
    $Res Function(PotholeModel) then,
  ) = _$PotholeModelCopyWithImpl<$Res, PotholeModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'case_id') String caseId,
    String status,
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
    @JsonKey(name: 'vendor_acc_confirmed') bool vendorAccConfirmed,
    @JsonKey(name: 'inspection_date') DateTime? inspectionDate,
    @JsonKey(name: 'completion_date') DateTime? completionDate,
    @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
    String? rejectedReason,
    @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
    String? rejectedBy,
    @JsonKey(name: 'check_if_send_to_vendor') bool checkIfSendToVendor,
  });

  $ReportedByCopyWith<$Res>? get reportedBy;
  $InspectedByCopyWith<$Res>? get inspectedBy;
}

/// @nodoc
class _$PotholeModelCopyWithImpl<$Res, $Val extends PotholeModel>
    implements $PotholeModelCopyWith<$Res> {
  _$PotholeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caseId = null,
    Object? status = null,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? accuracy = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? category = freezed,
    Object? roadName = freezed,
    Object? imageUrls = freezed,
    Object? image = freezed,
    Object? potholeImages = freezed,
    Object? officerReports = freezed,
    Object? reportedBy = freezed,
    Object? inspectedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reportDate = freezed,
    Object? assignedDate = freezed,
    Object? completedDate = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? assignedBy = freezed,
    Object? pendingAt = freezed,
    Object? remarks = freezed,
    Object? severity = freezed,
    Object? divisionName = freezed,
    Object? priority = freezed,
    Object? district = freezed,
    Object? division = freezed,
    Object? circle = freezed,
    Object? pincode = freezed,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? vendorName = freezed,
    Object? vendorUserId = freezed,
    Object? vendorAccConfirmed = null,
    Object? inspectionDate = freezed,
    Object? completionDate = freezed,
    Object? rejectedReason = freezed,
    Object? rejectedBy = freezed,
    Object? checkIfSendToVendor = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            caseId: null == caseId
                ? _value.caseId
                : caseId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            roadName: freezed == roadName
                ? _value.roadName
                : roadName // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: freezed == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            potholeImages: freezed == potholeImages
                ? _value.potholeImages
                : potholeImages // ignore: cast_nullable_to_non_nullable
                      as List<PotholePhoto>?,
            officerReports: freezed == officerReports
                ? _value.officerReports
                : officerReports // ignore: cast_nullable_to_non_nullable
                      as List<OfficerReportModel>?,
            reportedBy: freezed == reportedBy
                ? _value.reportedBy
                : reportedBy // ignore: cast_nullable_to_non_nullable
                      as ReportedBy?,
            inspectedBy: freezed == inspectedBy
                ? _value.inspectedBy
                : inspectedBy // ignore: cast_nullable_to_non_nullable
                      as InspectedBy?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reportDate: freezed == reportDate
                ? _value.reportDate
                : reportDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedDate: freezed == assignedDate
                ? _value.assignedDate
                : assignedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedDate: freezed == completedDate
                ? _value.completedDate
                : completedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            assignedToName: freezed == assignedToName
                ? _value.assignedToName
                : assignedToName // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedBy: freezed == assignedBy
                ? _value.assignedBy
                : assignedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            pendingAt: freezed == pendingAt
                ? _value.pendingAt
                : pendingAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            remarks: freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                      as String?,
            severity: freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String?,
            divisionName: freezed == divisionName
                ? _value.divisionName
                : divisionName // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String?,
            district: freezed == district
                ? _value.district
                : district // ignore: cast_nullable_to_non_nullable
                      as String?,
            division: freezed == division
                ? _value.division
                : division // ignore: cast_nullable_to_non_nullable
                      as String?,
            circle: freezed == circle
                ? _value.circle
                : circle // ignore: cast_nullable_to_non_nullable
                      as String?,
            pincode: freezed == pincode
                ? _value.pincode
                : pincode // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedCost: freezed == estimatedCost
                ? _value.estimatedCost
                : estimatedCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            actualCost: freezed == actualCost
                ? _value.actualCost
                : actualCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            vendorName: freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendorUserId: freezed == vendorUserId
                ? _value.vendorUserId
                : vendorUserId // ignore: cast_nullable_to_non_nullable
                      as int?,
            vendorAccConfirmed: null == vendorAccConfirmed
                ? _value.vendorAccConfirmed
                : vendorAccConfirmed // ignore: cast_nullable_to_non_nullable
                      as bool,
            inspectionDate: freezed == inspectionDate
                ? _value.inspectionDate
                : inspectionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completionDate: freezed == completionDate
                ? _value.completionDate
                : completionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rejectedReason: freezed == rejectedReason
                ? _value.rejectedReason
                : rejectedReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectedBy: freezed == rejectedBy
                ? _value.rejectedBy
                : rejectedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkIfSendToVendor: null == checkIfSendToVendor
                ? _value.checkIfSendToVendor
                : checkIfSendToVendor // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportedByCopyWith<$Res>? get reportedBy {
    if (_value.reportedBy == null) {
      return null;
    }

    return $ReportedByCopyWith<$Res>(_value.reportedBy!, (value) {
      return _then(_value.copyWith(reportedBy: value) as $Val);
    });
  }

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InspectedByCopyWith<$Res>? get inspectedBy {
    if (_value.inspectedBy == null) {
      return null;
    }

    return $InspectedByCopyWith<$Res>(_value.inspectedBy!, (value) {
      return _then(_value.copyWith(inspectedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PotholeModelImplCopyWith<$Res>
    implements $PotholeModelCopyWith<$Res> {
  factory _$$PotholeModelImplCopyWith(
    _$PotholeModelImpl value,
    $Res Function(_$PotholeModelImpl) then,
  ) = __$$PotholeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'case_id') String caseId,
    String status,
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
    @JsonKey(name: 'vendor_acc_confirmed') bool vendorAccConfirmed,
    @JsonKey(name: 'inspection_date') DateTime? inspectionDate,
    @JsonKey(name: 'completion_date') DateTime? completionDate,
    @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
    String? rejectedReason,
    @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
    String? rejectedBy,
    @JsonKey(name: 'check_if_send_to_vendor') bool checkIfSendToVendor,
  });

  @override
  $ReportedByCopyWith<$Res>? get reportedBy;
  @override
  $InspectedByCopyWith<$Res>? get inspectedBy;
}

/// @nodoc
class __$$PotholeModelImplCopyWithImpl<$Res>
    extends _$PotholeModelCopyWithImpl<$Res, _$PotholeModelImpl>
    implements _$$PotholeModelImplCopyWith<$Res> {
  __$$PotholeModelImplCopyWithImpl(
    _$PotholeModelImpl _value,
    $Res Function(_$PotholeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caseId = null,
    Object? status = null,
    Object? description = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? accuracy = freezed,
    Object? location = freezed,
    Object? address = freezed,
    Object? category = freezed,
    Object? roadName = freezed,
    Object? imageUrls = freezed,
    Object? image = freezed,
    Object? potholeImages = freezed,
    Object? officerReports = freezed,
    Object? reportedBy = freezed,
    Object? inspectedBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reportDate = freezed,
    Object? assignedDate = freezed,
    Object? completedDate = freezed,
    Object? assignedTo = freezed,
    Object? assignedToName = freezed,
    Object? assignedBy = freezed,
    Object? pendingAt = freezed,
    Object? remarks = freezed,
    Object? severity = freezed,
    Object? divisionName = freezed,
    Object? priority = freezed,
    Object? district = freezed,
    Object? division = freezed,
    Object? circle = freezed,
    Object? pincode = freezed,
    Object? estimatedCost = freezed,
    Object? actualCost = freezed,
    Object? vendorName = freezed,
    Object? vendorUserId = freezed,
    Object? vendorAccConfirmed = null,
    Object? inspectionDate = freezed,
    Object? completionDate = freezed,
    Object? rejectedReason = freezed,
    Object? rejectedBy = freezed,
    Object? checkIfSendToVendor = null,
  }) {
    return _then(
      _$PotholeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        caseId: null == caseId
            ? _value.caseId
            : caseId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        roadName: freezed == roadName
            ? _value.roadName
            : roadName // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: freezed == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        image: freezed == image
            ? _value._image
            : image // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        potholeImages: freezed == potholeImages
            ? _value._potholeImages
            : potholeImages // ignore: cast_nullable_to_non_nullable
                  as List<PotholePhoto>?,
        officerReports: freezed == officerReports
            ? _value._officerReports
            : officerReports // ignore: cast_nullable_to_non_nullable
                  as List<OfficerReportModel>?,
        reportedBy: freezed == reportedBy
            ? _value.reportedBy
            : reportedBy // ignore: cast_nullable_to_non_nullable
                  as ReportedBy?,
        inspectedBy: freezed == inspectedBy
            ? _value.inspectedBy
            : inspectedBy // ignore: cast_nullable_to_non_nullable
                  as InspectedBy?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reportDate: freezed == reportDate
            ? _value.reportDate
            : reportDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedDate: freezed == assignedDate
            ? _value.assignedDate
            : assignedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedDate: freezed == completedDate
            ? _value.completedDate
            : completedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        assignedToName: freezed == assignedToName
            ? _value.assignedToName
            : assignedToName // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedBy: freezed == assignedBy
            ? _value.assignedBy
            : assignedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        pendingAt: freezed == pendingAt
            ? _value.pendingAt
            : pendingAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        remarks: freezed == remarks
            ? _value.remarks
            : remarks // ignore: cast_nullable_to_non_nullable
                  as String?,
        severity: freezed == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String?,
        divisionName: freezed == divisionName
            ? _value.divisionName
            : divisionName // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String?,
        district: freezed == district
            ? _value.district
            : district // ignore: cast_nullable_to_non_nullable
                  as String?,
        division: freezed == division
            ? _value.division
            : division // ignore: cast_nullable_to_non_nullable
                  as String?,
        circle: freezed == circle
            ? _value.circle
            : circle // ignore: cast_nullable_to_non_nullable
                  as String?,
        pincode: freezed == pincode
            ? _value.pincode
            : pincode // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedCost: freezed == estimatedCost
            ? _value.estimatedCost
            : estimatedCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        actualCost: freezed == actualCost
            ? _value.actualCost
            : actualCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        vendorName: freezed == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendorUserId: freezed == vendorUserId
            ? _value.vendorUserId
            : vendorUserId // ignore: cast_nullable_to_non_nullable
                  as int?,
        vendorAccConfirmed: null == vendorAccConfirmed
            ? _value.vendorAccConfirmed
            : vendorAccConfirmed // ignore: cast_nullable_to_non_nullable
                  as bool,
        inspectionDate: freezed == inspectionDate
            ? _value.inspectionDate
            : inspectionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completionDate: freezed == completionDate
            ? _value.completionDate
            : completionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rejectedReason: freezed == rejectedReason
            ? _value.rejectedReason
            : rejectedReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectedBy: freezed == rejectedBy
            ? _value.rejectedBy
            : rejectedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkIfSendToVendor: null == checkIfSendToVendor
            ? _value.checkIfSendToVendor
            : checkIfSendToVendor // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PotholeModelImpl extends _PotholeModel {
  const _$PotholeModelImpl({
    required this.id,
    @JsonKey(name: 'case_id') required this.caseId,
    required this.status,
    this.description,
    this.latitude,
    this.longitude,
    this.accuracy,
    @JsonKey(name: 'location_name') this.location,
    this.address,
    this.category,
    @JsonKey(name: 'road_name') this.roadName,
    @JsonKey(name: 'image_urls') final List<String>? imageUrls,
    @JsonKey(name: 'image') final List<String>? image,
    @JsonKey(name: 'pothole_images') final List<PotholePhoto>? potholeImages,
    @JsonKey(name: 'officer_reports')
    final List<OfficerReportModel>? officerReports,
    @JsonKey(name: 'reported_by') this.reportedBy,
    @JsonKey(name: 'inspected_by') this.inspectedBy,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(name: 'report_date') this.reportDate,
    @JsonKey(name: 'assigned_date') this.assignedDate,
    @JsonKey(name: 'completed_date') this.completedDate,
    @JsonKey(name: 'assigned_to') this.assignedTo,
    @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
    this.assignedToName,
    @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy) this.assignedBy,
    @JsonKey(name: 'pending_at', fromJson: _parseNullableString) this.pendingAt,
    @JsonKey(name: 'remarks') this.remarks,
    @JsonKey(name: 'severity') this.severity,
    @JsonKey(name: 'division_name') this.divisionName,
    @JsonKey(name: 'priority') this.priority,
    @JsonKey(name: 'district') this.district,
    @JsonKey(name: 'division') this.division,
    @JsonKey(name: 'circle', fromJson: _parseNullableString) this.circle,
    @JsonKey(name: 'pincode', fromJson: _parseNullableString) this.pincode,
    @JsonKey(name: 'estimated_cost') this.estimatedCost,
    @JsonKey(name: 'actual_cost') this.actualCost,
    @JsonKey(name: 'vendor_name') this.vendorName,
    @JsonKey(name: 'vendor_user_id') this.vendorUserId,
    @JsonKey(name: 'vendor_acc_confirmed') this.vendorAccConfirmed = false,
    @JsonKey(name: 'inspection_date') this.inspectionDate,
    @JsonKey(name: 'completion_date') this.completionDate,
    @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
    this.rejectedReason,
    @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
    this.rejectedBy,
    @JsonKey(name: 'check_if_send_to_vendor') this.checkIfSendToVendor = false,
  }) : _imageUrls = imageUrls,
       _image = image,
       _potholeImages = potholeImages,
       _officerReports = officerReports,
       super._();

  factory _$PotholeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PotholeModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'case_id')
  final String caseId;
  @override
  final String status;
  @override
  final String? description;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? accuracy;
  @override
  @JsonKey(name: 'location_name')
  final String? location;
  @override
  final String? address;
  @override
  final String? category;
  @override
  @JsonKey(name: 'road_name')
  final String? roadName;
  final List<String>? _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _image;
  @override
  @JsonKey(name: 'image')
  List<String>? get image {
    final value = _image;
    if (value == null) return null;
    if (_image is EqualUnmodifiableListView) return _image;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PotholePhoto>? _potholeImages;
  @override
  @JsonKey(name: 'pothole_images')
  List<PotholePhoto>? get potholeImages {
    final value = _potholeImages;
    if (value == null) return null;
    if (_potholeImages is EqualUnmodifiableListView) return _potholeImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<OfficerReportModel>? _officerReports;
  @override
  @JsonKey(name: 'officer_reports')
  List<OfficerReportModel>? get officerReports {
    final value = _officerReports;
    if (value == null) return null;
    if (_officerReports is EqualUnmodifiableListView) return _officerReports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'reported_by')
  final ReportedBy? reportedBy;
  @override
  @JsonKey(name: 'inspected_by')
  final InspectedBy? inspectedBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'report_date')
  final DateTime? reportDate;
  @override
  @JsonKey(name: 'assigned_date')
  final DateTime? assignedDate;
  @override
  @JsonKey(name: 'completed_date')
  final DateTime? completedDate;
  @override
  @JsonKey(name: 'assigned_to')
  final dynamic assignedTo;
  @override
  @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
  final String? assignedToName;
  @override
  @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy)
  final String? assignedBy;
  @override
  @JsonKey(name: 'pending_at', fromJson: _parseNullableString)
  final String? pendingAt;
  @override
  @JsonKey(name: 'remarks')
  final String? remarks;
  @override
  @JsonKey(name: 'severity')
  final String? severity;
  @override
  @JsonKey(name: 'division_name')
  final String? divisionName;
  @override
  @JsonKey(name: 'priority')
  final String? priority;
  @override
  @JsonKey(name: 'district')
  final String? district;
  @override
  @JsonKey(name: 'division')
  final String? division;
  @override
  @JsonKey(name: 'circle', fromJson: _parseNullableString)
  final String? circle;
  @override
  @JsonKey(name: 'pincode', fromJson: _parseNullableString)
  final String? pincode;
  @override
  @JsonKey(name: 'estimated_cost')
  final double? estimatedCost;
  @override
  @JsonKey(name: 'actual_cost')
  final double? actualCost;
  @override
  @JsonKey(name: 'vendor_name')
  final String? vendorName;
  @override
  @JsonKey(name: 'vendor_user_id')
  final int? vendorUserId;
  @override
  @JsonKey(name: 'vendor_acc_confirmed')
  final bool vendorAccConfirmed;
  @override
  @JsonKey(name: 'inspection_date')
  final DateTime? inspectionDate;
  @override
  @JsonKey(name: 'completion_date')
  final DateTime? completionDate;
  @override
  @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
  final String? rejectedReason;
  @override
  @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
  final String? rejectedBy;
  @override
  @JsonKey(name: 'check_if_send_to_vendor')
  final bool checkIfSendToVendor;

  @override
  String toString() {
    return 'PotholeModel(id: $id, caseId: $caseId, status: $status, description: $description, latitude: $latitude, longitude: $longitude, accuracy: $accuracy, location: $location, address: $address, category: $category, roadName: $roadName, imageUrls: $imageUrls, image: $image, potholeImages: $potholeImages, officerReports: $officerReports, reportedBy: $reportedBy, inspectedBy: $inspectedBy, createdAt: $createdAt, updatedAt: $updatedAt, reportDate: $reportDate, assignedDate: $assignedDate, completedDate: $completedDate, assignedTo: $assignedTo, assignedToName: $assignedToName, assignedBy: $assignedBy, pendingAt: $pendingAt, remarks: $remarks, severity: $severity, divisionName: $divisionName, priority: $priority, district: $district, division: $division, circle: $circle, pincode: $pincode, estimatedCost: $estimatedCost, actualCost: $actualCost, vendorName: $vendorName, vendorUserId: $vendorUserId, vendorAccConfirmed: $vendorAccConfirmed, inspectionDate: $inspectionDate, completionDate: $completionDate, rejectedReason: $rejectedReason, rejectedBy: $rejectedBy, checkIfSendToVendor: $checkIfSendToVendor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PotholeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.roadName, roadName) ||
                other.roadName == roadName) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            const DeepCollectionEquality().equals(other._image, _image) &&
            const DeepCollectionEquality().equals(
              other._potholeImages,
              _potholeImages,
            ) &&
            const DeepCollectionEquality().equals(
              other._officerReports,
              _officerReports,
            ) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
            (identical(other.inspectedBy, inspectedBy) ||
                other.inspectedBy == inspectedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate) &&
            (identical(other.assignedDate, assignedDate) ||
                other.assignedDate == assignedDate) &&
            (identical(other.completedDate, completedDate) ||
                other.completedDate == completedDate) &&
            const DeepCollectionEquality().equals(
              other.assignedTo,
              assignedTo,
            ) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.assignedBy, assignedBy) ||
                other.assignedBy == assignedBy) &&
            (identical(other.pendingAt, pendingAt) ||
                other.pendingAt == pendingAt) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.divisionName, divisionName) ||
                other.divisionName == divisionName) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.division, division) ||
                other.division == division) &&
            (identical(other.circle, circle) || other.circle == circle) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.estimatedCost, estimatedCost) ||
                other.estimatedCost == estimatedCost) &&
            (identical(other.actualCost, actualCost) ||
                other.actualCost == actualCost) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.vendorUserId, vendorUserId) ||
                other.vendorUserId == vendorUserId) &&
            (identical(other.vendorAccConfirmed, vendorAccConfirmed) ||
                other.vendorAccConfirmed == vendorAccConfirmed) &&
            (identical(other.inspectionDate, inspectionDate) ||
                other.inspectionDate == inspectionDate) &&
            (identical(other.completionDate, completionDate) ||
                other.completionDate == completionDate) &&
            (identical(other.rejectedReason, rejectedReason) ||
                other.rejectedReason == rejectedReason) &&
            (identical(other.rejectedBy, rejectedBy) ||
                other.rejectedBy == rejectedBy) &&
            (identical(other.checkIfSendToVendor, checkIfSendToVendor) ||
                other.checkIfSendToVendor == checkIfSendToVendor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    caseId,
    status,
    description,
    latitude,
    longitude,
    accuracy,
    location,
    address,
    category,
    roadName,
    const DeepCollectionEquality().hash(_imageUrls),
    const DeepCollectionEquality().hash(_image),
    const DeepCollectionEquality().hash(_potholeImages),
    const DeepCollectionEquality().hash(_officerReports),
    reportedBy,
    inspectedBy,
    createdAt,
    updatedAt,
    reportDate,
    assignedDate,
    completedDate,
    const DeepCollectionEquality().hash(assignedTo),
    assignedToName,
    assignedBy,
    pendingAt,
    remarks,
    severity,
    divisionName,
    priority,
    district,
    division,
    circle,
    pincode,
    estimatedCost,
    actualCost,
    vendorName,
    vendorUserId,
    vendorAccConfirmed,
    inspectionDate,
    completionDate,
    rejectedReason,
    rejectedBy,
    checkIfSendToVendor,
  ]);

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PotholeModelImplCopyWith<_$PotholeModelImpl> get copyWith =>
      __$$PotholeModelImplCopyWithImpl<_$PotholeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PotholeModelImplToJson(this);
  }
}

abstract class _PotholeModel extends PotholeModel {
  const factory _PotholeModel({
    required final int id,
    @JsonKey(name: 'case_id') required final String caseId,
    required final String status,
    final String? description,
    final double? latitude,
    final double? longitude,
    final double? accuracy,
    @JsonKey(name: 'location_name') final String? location,
    final String? address,
    final String? category,
    @JsonKey(name: 'road_name') final String? roadName,
    @JsonKey(name: 'image_urls') final List<String>? imageUrls,
    @JsonKey(name: 'image') final List<String>? image,
    @JsonKey(name: 'pothole_images') final List<PotholePhoto>? potholeImages,
    @JsonKey(name: 'officer_reports')
    final List<OfficerReportModel>? officerReports,
    @JsonKey(name: 'reported_by') final ReportedBy? reportedBy,
    @JsonKey(name: 'inspected_by') final InspectedBy? inspectedBy,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(name: 'report_date') final DateTime? reportDate,
    @JsonKey(name: 'assigned_date') final DateTime? assignedDate,
    @JsonKey(name: 'completed_date') final DateTime? completedDate,
    @JsonKey(name: 'assigned_to') final dynamic assignedTo,
    @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
    final String? assignedToName,
    @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy)
    final String? assignedBy,
    @JsonKey(name: 'pending_at', fromJson: _parseNullableString)
    final String? pendingAt,
    @JsonKey(name: 'remarks') final String? remarks,
    @JsonKey(name: 'severity') final String? severity,
    @JsonKey(name: 'division_name') final String? divisionName,
    @JsonKey(name: 'priority') final String? priority,
    @JsonKey(name: 'district') final String? district,
    @JsonKey(name: 'division') final String? division,
    @JsonKey(name: 'circle', fromJson: _parseNullableString)
    final String? circle,
    @JsonKey(name: 'pincode', fromJson: _parseNullableString)
    final String? pincode,
    @JsonKey(name: 'estimated_cost') final double? estimatedCost,
    @JsonKey(name: 'actual_cost') final double? actualCost,
    @JsonKey(name: 'vendor_name') final String? vendorName,
    @JsonKey(name: 'vendor_user_id') final int? vendorUserId,
    @JsonKey(name: 'vendor_acc_confirmed') final bool vendorAccConfirmed,
    @JsonKey(name: 'inspection_date') final DateTime? inspectionDate,
    @JsonKey(name: 'completion_date') final DateTime? completionDate,
    @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
    final String? rejectedReason,
    @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
    final String? rejectedBy,
    @JsonKey(name: 'check_if_send_to_vendor') final bool checkIfSendToVendor,
  }) = _$PotholeModelImpl;
  const _PotholeModel._() : super._();

  factory _PotholeModel.fromJson(Map<String, dynamic> json) =
      _$PotholeModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'case_id')
  String get caseId;
  @override
  String get status;
  @override
  String? get description;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get accuracy;
  @override
  @JsonKey(name: 'location_name')
  String? get location;
  @override
  String? get address;
  @override
  String? get category;
  @override
  @JsonKey(name: 'road_name')
  String? get roadName;
  @override
  @JsonKey(name: 'image_urls')
  List<String>? get imageUrls;
  @override
  @JsonKey(name: 'image')
  List<String>? get image;
  @override
  @JsonKey(name: 'pothole_images')
  List<PotholePhoto>? get potholeImages;
  @override
  @JsonKey(name: 'officer_reports')
  List<OfficerReportModel>? get officerReports;
  @override
  @JsonKey(name: 'reported_by')
  ReportedBy? get reportedBy;
  @override
  @JsonKey(name: 'inspected_by')
  InspectedBy? get inspectedBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'report_date')
  DateTime? get reportDate;
  @override
  @JsonKey(name: 'assigned_date')
  DateTime? get assignedDate;
  @override
  @JsonKey(name: 'completed_date')
  DateTime? get completedDate;
  @override
  @JsonKey(name: 'assigned_to')
  dynamic get assignedTo;
  @override
  @JsonKey(name: 'assigned_to_name', fromJson: _parseNullableString)
  String? get assignedToName;
  @override
  @JsonKey(name: 'assigned_by', fromJson: _parseAssignedBy)
  String? get assignedBy;
  @override
  @JsonKey(name: 'pending_at', fromJson: _parseNullableString)
  String? get pendingAt;
  @override
  @JsonKey(name: 'remarks')
  String? get remarks;
  @override
  @JsonKey(name: 'severity')
  String? get severity;
  @override
  @JsonKey(name: 'division_name')
  String? get divisionName;
  @override
  @JsonKey(name: 'priority')
  String? get priority;
  @override
  @JsonKey(name: 'district')
  String? get district;
  @override
  @JsonKey(name: 'division')
  String? get division;
  @override
  @JsonKey(name: 'circle', fromJson: _parseNullableString)
  String? get circle;
  @override
  @JsonKey(name: 'pincode', fromJson: _parseNullableString)
  String? get pincode;
  @override
  @JsonKey(name: 'estimated_cost')
  double? get estimatedCost;
  @override
  @JsonKey(name: 'actual_cost')
  double? get actualCost;
  @override
  @JsonKey(name: 'vendor_name')
  String? get vendorName;
  @override
  @JsonKey(name: 'vendor_user_id')
  int? get vendorUserId;
  @override
  @JsonKey(name: 'vendor_acc_confirmed')
  bool get vendorAccConfirmed;
  @override
  @JsonKey(name: 'inspection_date')
  DateTime? get inspectionDate;
  @override
  @JsonKey(name: 'completion_date')
  DateTime? get completionDate;
  @override
  @JsonKey(name: 'rejected_reason', fromJson: _parseNullableString)
  String? get rejectedReason;
  @override
  @JsonKey(name: 'rejected_by', fromJson: _parseNullableString)
  String? get rejectedBy;
  @override
  @JsonKey(name: 'check_if_send_to_vendor')
  bool get checkIfSendToVendor;

  /// Create a copy of PotholeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PotholeModelImplCopyWith<_$PotholeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportedBy _$ReportedByFromJson(Map<String, dynamic> json) {
  return _ReportedBy.fromJson(json);
}

/// @nodoc
mixin _$ReportedBy {
  String? get name => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  String? get designation => throw _privateConstructorUsedError;

  /// Serializes this ReportedBy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportedByCopyWith<ReportedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportedByCopyWith<$Res> {
  factory $ReportedByCopyWith(
    ReportedBy value,
    $Res Function(ReportedBy) then,
  ) = _$ReportedByCopyWithImpl<$Res, ReportedBy>;
  @useResult
  $Res call({String? name, String? time, String? remark, String? designation});
}

/// @nodoc
class _$ReportedByCopyWithImpl<$Res, $Val extends ReportedBy>
    implements $ReportedByCopyWith<$Res> {
  _$ReportedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? time = freezed,
    Object? remark = freezed,
    Object? designation = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String?,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
            designation: freezed == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportedByImplCopyWith<$Res>
    implements $ReportedByCopyWith<$Res> {
  factory _$$ReportedByImplCopyWith(
    _$ReportedByImpl value,
    $Res Function(_$ReportedByImpl) then,
  ) = __$$ReportedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? time, String? remark, String? designation});
}

/// @nodoc
class __$$ReportedByImplCopyWithImpl<$Res>
    extends _$ReportedByCopyWithImpl<$Res, _$ReportedByImpl>
    implements _$$ReportedByImplCopyWith<$Res> {
  __$$ReportedByImplCopyWithImpl(
    _$ReportedByImpl _value,
    $Res Function(_$ReportedByImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? time = freezed,
    Object? remark = freezed,
    Object? designation = freezed,
  }) {
    return _then(
      _$ReportedByImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String?,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
        designation: freezed == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportedByImpl implements _ReportedBy {
  const _$ReportedByImpl({this.name, this.time, this.remark, this.designation});

  factory _$ReportedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportedByImplFromJson(json);

  @override
  final String? name;
  @override
  final String? time;
  @override
  final String? remark;
  @override
  final String? designation;

  @override
  String toString() {
    return 'ReportedBy(name: $name, time: $time, remark: $remark, designation: $designation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportedByImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.designation, designation) ||
                other.designation == designation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, time, remark, designation);

  /// Create a copy of ReportedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportedByImplCopyWith<_$ReportedByImpl> get copyWith =>
      __$$ReportedByImplCopyWithImpl<_$ReportedByImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportedByImplToJson(this);
  }
}

abstract class _ReportedBy implements ReportedBy {
  const factory _ReportedBy({
    final String? name,
    final String? time,
    final String? remark,
    final String? designation,
  }) = _$ReportedByImpl;

  factory _ReportedBy.fromJson(Map<String, dynamic> json) =
      _$ReportedByImpl.fromJson;

  @override
  String? get name;
  @override
  String? get time;
  @override
  String? get remark;
  @override
  String? get designation;

  /// Create a copy of ReportedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportedByImplCopyWith<_$ReportedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InspectedBy _$InspectedByFromJson(Map<String, dynamic> json) {
  return _InspectedBy.fromJson(json);
}

/// @nodoc
mixin _$InspectedBy {
  String? get name => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  String? get designation => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_remark')
  String? get inspectionRemark => throw _privateConstructorUsedError;
  @JsonKey(name: 'consumption_material')
  String? get consumptionMaterial => throw _privateConstructorUsedError;

  /// Serializes this InspectedBy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InspectedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InspectedByCopyWith<InspectedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InspectedByCopyWith<$Res> {
  factory $InspectedByCopyWith(
    InspectedBy value,
    $Res Function(InspectedBy) then,
  ) = _$InspectedByCopyWithImpl<$Res, InspectedBy>;
  @useResult
  $Res call({
    String? name,
    String? date,
    String? designation,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  });
}

/// @nodoc
class _$InspectedByCopyWithImpl<$Res, $Val extends InspectedBy>
    implements $InspectedByCopyWith<$Res> {
  _$InspectedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InspectedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? date = freezed,
    Object? designation = freezed,
    Object? inspectionRemark = freezed,
    Object? consumptionMaterial = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            designation: freezed == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String?,
            inspectionRemark: freezed == inspectionRemark
                ? _value.inspectionRemark
                : inspectionRemark // ignore: cast_nullable_to_non_nullable
                      as String?,
            consumptionMaterial: freezed == consumptionMaterial
                ? _value.consumptionMaterial
                : consumptionMaterial // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InspectedByImplCopyWith<$Res>
    implements $InspectedByCopyWith<$Res> {
  factory _$$InspectedByImplCopyWith(
    _$InspectedByImpl value,
    $Res Function(_$InspectedByImpl) then,
  ) = __$$InspectedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? name,
    String? date,
    String? designation,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  });
}

/// @nodoc
class __$$InspectedByImplCopyWithImpl<$Res>
    extends _$InspectedByCopyWithImpl<$Res, _$InspectedByImpl>
    implements _$$InspectedByImplCopyWith<$Res> {
  __$$InspectedByImplCopyWithImpl(
    _$InspectedByImpl _value,
    $Res Function(_$InspectedByImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InspectedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? date = freezed,
    Object? designation = freezed,
    Object? inspectionRemark = freezed,
    Object? consumptionMaterial = freezed,
  }) {
    return _then(
      _$InspectedByImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        designation: freezed == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String?,
        inspectionRemark: freezed == inspectionRemark
            ? _value.inspectionRemark
            : inspectionRemark // ignore: cast_nullable_to_non_nullable
                  as String?,
        consumptionMaterial: freezed == consumptionMaterial
            ? _value.consumptionMaterial
            : consumptionMaterial // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InspectedByImpl implements _InspectedBy {
  const _$InspectedByImpl({
    this.name,
    this.date,
    this.designation,
    @JsonKey(name: 'inspection_remark') this.inspectionRemark,
    @JsonKey(name: 'consumption_material') this.consumptionMaterial,
  });

  factory _$InspectedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$InspectedByImplFromJson(json);

  @override
  final String? name;
  @override
  final String? date;
  @override
  final String? designation;
  @override
  @JsonKey(name: 'inspection_remark')
  final String? inspectionRemark;
  @override
  @JsonKey(name: 'consumption_material')
  final String? consumptionMaterial;

  @override
  String toString() {
    return 'InspectedBy(name: $name, date: $date, designation: $designation, inspectionRemark: $inspectionRemark, consumptionMaterial: $consumptionMaterial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InspectedByImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.inspectionRemark, inspectionRemark) ||
                other.inspectionRemark == inspectionRemark) &&
            (identical(other.consumptionMaterial, consumptionMaterial) ||
                other.consumptionMaterial == consumptionMaterial));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    date,
    designation,
    inspectionRemark,
    consumptionMaterial,
  );

  /// Create a copy of InspectedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InspectedByImplCopyWith<_$InspectedByImpl> get copyWith =>
      __$$InspectedByImplCopyWithImpl<_$InspectedByImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InspectedByImplToJson(this);
  }
}

abstract class _InspectedBy implements InspectedBy {
  const factory _InspectedBy({
    final String? name,
    final String? date,
    final String? designation,
    @JsonKey(name: 'inspection_remark') final String? inspectionRemark,
    @JsonKey(name: 'consumption_material') final String? consumptionMaterial,
  }) = _$InspectedByImpl;

  factory _InspectedBy.fromJson(Map<String, dynamic> json) =
      _$InspectedByImpl.fromJson;

  @override
  String? get name;
  @override
  String? get date;
  @override
  String? get designation;
  @override
  @JsonKey(name: 'inspection_remark')
  String? get inspectionRemark;
  @override
  @JsonKey(name: 'consumption_material')
  String? get consumptionMaterial;

  /// Create a copy of InspectedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InspectedByImplCopyWith<_$InspectedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OfficerReportModel _$OfficerReportModelFromJson(Map<String, dynamic> json) {
  return _OfficerReportModel.fromJson(json);
}

/// @nodoc
mixin _$OfficerReportModel {
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_fix_photos')
  List<PotholePhoto>? get afterFixPhotos => throw _privateConstructorUsedError;
  @JsonKey(name: 'potholes_data')
  List<PotholeDimension>? get potholesData =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_remark')
  String? get inspectionRemark => throw _privateConstructorUsedError;
  @JsonKey(name: 'consumption_material')
  String? get consumptionMaterial => throw _privateConstructorUsedError;

  /// Serializes this OfficerReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfficerReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfficerReportModelCopyWith<OfficerReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfficerReportModelCopyWith<$Res> {
  factory $OfficerReportModelCopyWith(
    OfficerReportModel value,
    $Res Function(OfficerReportModel) then,
  ) = _$OfficerReportModelCopyWithImpl<$Res, OfficerReportModel>;
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'after_fix_photos') List<PotholePhoto>? afterFixPhotos,
    @JsonKey(name: 'potholes_data') List<PotholeDimension>? potholesData,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  });
}

/// @nodoc
class _$OfficerReportModelCopyWithImpl<$Res, $Val extends OfficerReportModel>
    implements $OfficerReportModelCopyWith<$Res> {
  _$OfficerReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfficerReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? afterFixPhotos = freezed,
    Object? potholesData = freezed,
    Object? inspectionRemark = freezed,
    Object? consumptionMaterial = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            afterFixPhotos: freezed == afterFixPhotos
                ? _value.afterFixPhotos
                : afterFixPhotos // ignore: cast_nullable_to_non_nullable
                      as List<PotholePhoto>?,
            potholesData: freezed == potholesData
                ? _value.potholesData
                : potholesData // ignore: cast_nullable_to_non_nullable
                      as List<PotholeDimension>?,
            inspectionRemark: freezed == inspectionRemark
                ? _value.inspectionRemark
                : inspectionRemark // ignore: cast_nullable_to_non_nullable
                      as String?,
            consumptionMaterial: freezed == consumptionMaterial
                ? _value.consumptionMaterial
                : consumptionMaterial // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OfficerReportModelImplCopyWith<$Res>
    implements $OfficerReportModelCopyWith<$Res> {
  factory _$$OfficerReportModelImplCopyWith(
    _$OfficerReportModelImpl value,
    $Res Function(_$OfficerReportModelImpl) then,
  ) = __$$OfficerReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    @JsonKey(name: 'after_fix_photos') List<PotholePhoto>? afterFixPhotos,
    @JsonKey(name: 'potholes_data') List<PotholeDimension>? potholesData,
    @JsonKey(name: 'inspection_remark') String? inspectionRemark,
    @JsonKey(name: 'consumption_material') String? consumptionMaterial,
  });
}

/// @nodoc
class __$$OfficerReportModelImplCopyWithImpl<$Res>
    extends _$OfficerReportModelCopyWithImpl<$Res, _$OfficerReportModelImpl>
    implements _$$OfficerReportModelImplCopyWith<$Res> {
  __$$OfficerReportModelImplCopyWithImpl(
    _$OfficerReportModelImpl _value,
    $Res Function(_$OfficerReportModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OfficerReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? afterFixPhotos = freezed,
    Object? potholesData = freezed,
    Object? inspectionRemark = freezed,
    Object? consumptionMaterial = freezed,
  }) {
    return _then(
      _$OfficerReportModelImpl(
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        afterFixPhotos: freezed == afterFixPhotos
            ? _value._afterFixPhotos
            : afterFixPhotos // ignore: cast_nullable_to_non_nullable
                  as List<PotholePhoto>?,
        potholesData: freezed == potholesData
            ? _value._potholesData
            : potholesData // ignore: cast_nullable_to_non_nullable
                  as List<PotholeDimension>?,
        inspectionRemark: freezed == inspectionRemark
            ? _value.inspectionRemark
            : inspectionRemark // ignore: cast_nullable_to_non_nullable
                  as String?,
        consumptionMaterial: freezed == consumptionMaterial
            ? _value.consumptionMaterial
            : consumptionMaterial // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OfficerReportModelImpl implements _OfficerReportModel {
  const _$OfficerReportModelImpl({
    this.status,
    @JsonKey(name: 'after_fix_photos') final List<PotholePhoto>? afterFixPhotos,
    @JsonKey(name: 'potholes_data') final List<PotholeDimension>? potholesData,
    @JsonKey(name: 'inspection_remark') this.inspectionRemark,
    @JsonKey(name: 'consumption_material') this.consumptionMaterial,
  }) : _afterFixPhotos = afterFixPhotos,
       _potholesData = potholesData;

  factory _$OfficerReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfficerReportModelImplFromJson(json);

  @override
  final String? status;
  final List<PotholePhoto>? _afterFixPhotos;
  @override
  @JsonKey(name: 'after_fix_photos')
  List<PotholePhoto>? get afterFixPhotos {
    final value = _afterFixPhotos;
    if (value == null) return null;
    if (_afterFixPhotos is EqualUnmodifiableListView) return _afterFixPhotos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PotholeDimension>? _potholesData;
  @override
  @JsonKey(name: 'potholes_data')
  List<PotholeDimension>? get potholesData {
    final value = _potholesData;
    if (value == null) return null;
    if (_potholesData is EqualUnmodifiableListView) return _potholesData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'inspection_remark')
  final String? inspectionRemark;
  @override
  @JsonKey(name: 'consumption_material')
  final String? consumptionMaterial;

  @override
  String toString() {
    return 'OfficerReportModel(status: $status, afterFixPhotos: $afterFixPhotos, potholesData: $potholesData, inspectionRemark: $inspectionRemark, consumptionMaterial: $consumptionMaterial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfficerReportModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._afterFixPhotos,
              _afterFixPhotos,
            ) &&
            const DeepCollectionEquality().equals(
              other._potholesData,
              _potholesData,
            ) &&
            (identical(other.inspectionRemark, inspectionRemark) ||
                other.inspectionRemark == inspectionRemark) &&
            (identical(other.consumptionMaterial, consumptionMaterial) ||
                other.consumptionMaterial == consumptionMaterial));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    const DeepCollectionEquality().hash(_afterFixPhotos),
    const DeepCollectionEquality().hash(_potholesData),
    inspectionRemark,
    consumptionMaterial,
  );

  /// Create a copy of OfficerReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfficerReportModelImplCopyWith<_$OfficerReportModelImpl> get copyWith =>
      __$$OfficerReportModelImplCopyWithImpl<_$OfficerReportModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OfficerReportModelImplToJson(this);
  }
}

abstract class _OfficerReportModel implements OfficerReportModel {
  const factory _OfficerReportModel({
    final String? status,
    @JsonKey(name: 'after_fix_photos') final List<PotholePhoto>? afterFixPhotos,
    @JsonKey(name: 'potholes_data') final List<PotholeDimension>? potholesData,
    @JsonKey(name: 'inspection_remark') final String? inspectionRemark,
    @JsonKey(name: 'consumption_material') final String? consumptionMaterial,
  }) = _$OfficerReportModelImpl;

  factory _OfficerReportModel.fromJson(Map<String, dynamic> json) =
      _$OfficerReportModelImpl.fromJson;

  @override
  String? get status;
  @override
  @JsonKey(name: 'after_fix_photos')
  List<PotholePhoto>? get afterFixPhotos;
  @override
  @JsonKey(name: 'potholes_data')
  List<PotholeDimension>? get potholesData;
  @override
  @JsonKey(name: 'inspection_remark')
  String? get inspectionRemark;
  @override
  @JsonKey(name: 'consumption_material')
  String? get consumptionMaterial;

  /// Create a copy of OfficerReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfficerReportModelImplCopyWith<_$OfficerReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PotholeDimension _$PotholeDimensionFromJson(Map<String, dynamic> json) {
  return _PotholeDimension.fromJson(json);
}

/// @nodoc
mixin _$PotholeDimension {
  @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
  String? get beforeSurfaceArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
  String? get beforeDepth => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
  String? get afterSurfaceArea => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
  String? get afterDepth => throw _privateConstructorUsedError;
  @JsonKey(name: 'photos')
  List<PotholePhoto>? get photos => throw _privateConstructorUsedError;

  /// Serializes this PotholeDimension to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PotholeDimension
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PotholeDimensionCopyWith<PotholeDimension> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PotholeDimensionCopyWith<$Res> {
  factory $PotholeDimensionCopyWith(
    PotholeDimension value,
    $Res Function(PotholeDimension) then,
  ) = _$PotholeDimensionCopyWithImpl<$Res, PotholeDimension>;
  @useResult
  $Res call({
    @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
    String? beforeSurfaceArea,
    @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
    String? beforeDepth,
    @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
    String? afterSurfaceArea,
    @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
    String? afterDepth,
    @JsonKey(name: 'photos') List<PotholePhoto>? photos,
  });
}

/// @nodoc
class _$PotholeDimensionCopyWithImpl<$Res, $Val extends PotholeDimension>
    implements $PotholeDimensionCopyWith<$Res> {
  _$PotholeDimensionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PotholeDimension
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beforeSurfaceArea = freezed,
    Object? beforeDepth = freezed,
    Object? afterSurfaceArea = freezed,
    Object? afterDepth = freezed,
    Object? photos = freezed,
  }) {
    return _then(
      _value.copyWith(
            beforeSurfaceArea: freezed == beforeSurfaceArea
                ? _value.beforeSurfaceArea
                : beforeSurfaceArea // ignore: cast_nullable_to_non_nullable
                      as String?,
            beforeDepth: freezed == beforeDepth
                ? _value.beforeDepth
                : beforeDepth // ignore: cast_nullable_to_non_nullable
                      as String?,
            afterSurfaceArea: freezed == afterSurfaceArea
                ? _value.afterSurfaceArea
                : afterSurfaceArea // ignore: cast_nullable_to_non_nullable
                      as String?,
            afterDepth: freezed == afterDepth
                ? _value.afterDepth
                : afterDepth // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: freezed == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<PotholePhoto>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PotholeDimensionImplCopyWith<$Res>
    implements $PotholeDimensionCopyWith<$Res> {
  factory _$$PotholeDimensionImplCopyWith(
    _$PotholeDimensionImpl value,
    $Res Function(_$PotholeDimensionImpl) then,
  ) = __$$PotholeDimensionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
    String? beforeSurfaceArea,
    @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
    String? beforeDepth,
    @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
    String? afterSurfaceArea,
    @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
    String? afterDepth,
    @JsonKey(name: 'photos') List<PotholePhoto>? photos,
  });
}

/// @nodoc
class __$$PotholeDimensionImplCopyWithImpl<$Res>
    extends _$PotholeDimensionCopyWithImpl<$Res, _$PotholeDimensionImpl>
    implements _$$PotholeDimensionImplCopyWith<$Res> {
  __$$PotholeDimensionImplCopyWithImpl(
    _$PotholeDimensionImpl _value,
    $Res Function(_$PotholeDimensionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PotholeDimension
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beforeSurfaceArea = freezed,
    Object? beforeDepth = freezed,
    Object? afterSurfaceArea = freezed,
    Object? afterDepth = freezed,
    Object? photos = freezed,
  }) {
    return _then(
      _$PotholeDimensionImpl(
        beforeSurfaceArea: freezed == beforeSurfaceArea
            ? _value.beforeSurfaceArea
            : beforeSurfaceArea // ignore: cast_nullable_to_non_nullable
                  as String?,
        beforeDepth: freezed == beforeDepth
            ? _value.beforeDepth
            : beforeDepth // ignore: cast_nullable_to_non_nullable
                  as String?,
        afterSurfaceArea: freezed == afterSurfaceArea
            ? _value.afterSurfaceArea
            : afterSurfaceArea // ignore: cast_nullable_to_non_nullable
                  as String?,
        afterDepth: freezed == afterDepth
            ? _value.afterDepth
            : afterDepth // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: freezed == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<PotholePhoto>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PotholeDimensionImpl implements _PotholeDimension {
  const _$PotholeDimensionImpl({
    @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
    this.beforeSurfaceArea,
    @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
    this.beforeDepth,
    @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
    this.afterSurfaceArea,
    @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
    this.afterDepth,
    @JsonKey(name: 'photos') final List<PotholePhoto>? photos,
  }) : _photos = photos;

  factory _$PotholeDimensionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PotholeDimensionImplFromJson(json);

  @override
  @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
  final String? beforeSurfaceArea;
  @override
  @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
  final String? beforeDepth;
  @override
  @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
  final String? afterSurfaceArea;
  @override
  @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
  final String? afterDepth;
  final List<PotholePhoto>? _photos;
  @override
  @JsonKey(name: 'photos')
  List<PotholePhoto>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PotholeDimension(beforeSurfaceArea: $beforeSurfaceArea, beforeDepth: $beforeDepth, afterSurfaceArea: $afterSurfaceArea, afterDepth: $afterDepth, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PotholeDimensionImpl &&
            (identical(other.beforeSurfaceArea, beforeSurfaceArea) ||
                other.beforeSurfaceArea == beforeSurfaceArea) &&
            (identical(other.beforeDepth, beforeDepth) ||
                other.beforeDepth == beforeDepth) &&
            (identical(other.afterSurfaceArea, afterSurfaceArea) ||
                other.afterSurfaceArea == afterSurfaceArea) &&
            (identical(other.afterDepth, afterDepth) ||
                other.afterDepth == afterDepth) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    beforeSurfaceArea,
    beforeDepth,
    afterSurfaceArea,
    afterDepth,
    const DeepCollectionEquality().hash(_photos),
  );

  /// Create a copy of PotholeDimension
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PotholeDimensionImplCopyWith<_$PotholeDimensionImpl> get copyWith =>
      __$$PotholeDimensionImplCopyWithImpl<_$PotholeDimensionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PotholeDimensionImplToJson(this);
  }
}

abstract class _PotholeDimension implements PotholeDimension {
  const factory _PotholeDimension({
    @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
    final String? beforeSurfaceArea,
    @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
    final String? beforeDepth,
    @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
    final String? afterSurfaceArea,
    @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
    final String? afterDepth,
    @JsonKey(name: 'photos') final List<PotholePhoto>? photos,
  }) = _$PotholeDimensionImpl;

  factory _PotholeDimension.fromJson(Map<String, dynamic> json) =
      _$PotholeDimensionImpl.fromJson;

  @override
  @JsonKey(name: 'before_surface_area', fromJson: _parseNullableString)
  String? get beforeSurfaceArea;
  @override
  @JsonKey(name: 'before_depth', fromJson: _parseNullableString)
  String? get beforeDepth;
  @override
  @JsonKey(name: 'after_surface_area', fromJson: _parseNullableString)
  String? get afterSurfaceArea;
  @override
  @JsonKey(name: 'after_depth', fromJson: _parseNullableString)
  String? get afterDepth;
  @override
  @JsonKey(name: 'photos')
  List<PotholePhoto>? get photos;

  /// Create a copy of PotholeDimension
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PotholeDimensionImplCopyWith<_$PotholeDimensionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PotholePhoto _$PotholePhotoFromJson(Map<String, dynamic> json) {
  return _PotholePhoto.fromJson(json);
}

/// @nodoc
mixin _$PotholePhoto {
  @JsonKey(name: 'image_url', readValue: _readPhotoUrl)
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_type')
  String? get photoType => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this PotholePhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PotholePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PotholePhotoCopyWith<PotholePhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PotholePhotoCopyWith<$Res> {
  factory $PotholePhotoCopyWith(
    PotholePhoto value,
    $Res Function(PotholePhoto) then,
  ) = _$PotholePhotoCopyWithImpl<$Res, PotholePhoto>;
  @useResult
  $Res call({
    @JsonKey(name: 'image_url', readValue: _readPhotoUrl) String? photoUrl,
    @JsonKey(name: 'photo_type') String? photoType,
    double? accuracy,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class _$PotholePhotoCopyWithImpl<$Res, $Val extends PotholePhoto>
    implements $PotholePhotoCopyWith<$Res> {
  _$PotholePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PotholePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoUrl = freezed,
    Object? photoType = freezed,
    Object? accuracy = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoType: freezed == photoType
                ? _value.photoType
                : photoType // ignore: cast_nullable_to_non_nullable
                      as String?,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PotholePhotoImplCopyWith<$Res>
    implements $PotholePhotoCopyWith<$Res> {
  factory _$$PotholePhotoImplCopyWith(
    _$PotholePhotoImpl value,
    $Res Function(_$PotholePhotoImpl) then,
  ) = __$$PotholePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'image_url', readValue: _readPhotoUrl) String? photoUrl,
    @JsonKey(name: 'photo_type') String? photoType,
    double? accuracy,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class __$$PotholePhotoImplCopyWithImpl<$Res>
    extends _$PotholePhotoCopyWithImpl<$Res, _$PotholePhotoImpl>
    implements _$$PotholePhotoImplCopyWith<$Res> {
  __$$PotholePhotoImplCopyWithImpl(
    _$PotholePhotoImpl _value,
    $Res Function(_$PotholePhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PotholePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoUrl = freezed,
    Object? photoType = freezed,
    Object? accuracy = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _$PotholePhotoImpl(
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoType: freezed == photoType
            ? _value.photoType
            : photoType // ignore: cast_nullable_to_non_nullable
                  as String?,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PotholePhotoImpl implements _PotholePhoto {
  const _$PotholePhotoImpl({
    @JsonKey(name: 'image_url', readValue: _readPhotoUrl) this.photoUrl,
    @JsonKey(name: 'photo_type') this.photoType,
    this.accuracy,
    this.latitude,
    this.longitude,
  });

  factory _$PotholePhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PotholePhotoImplFromJson(json);

  @override
  @JsonKey(name: 'image_url', readValue: _readPhotoUrl)
  final String? photoUrl;
  @override
  @JsonKey(name: 'photo_type')
  final String? photoType;
  @override
  final double? accuracy;
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'PotholePhoto(photoUrl: $photoUrl, photoType: $photoType, accuracy: $accuracy, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PotholePhotoImpl &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.photoType, photoType) ||
                other.photoType == photoType) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    photoUrl,
    photoType,
    accuracy,
    latitude,
    longitude,
  );

  /// Create a copy of PotholePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PotholePhotoImplCopyWith<_$PotholePhotoImpl> get copyWith =>
      __$$PotholePhotoImplCopyWithImpl<_$PotholePhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PotholePhotoImplToJson(this);
  }
}

abstract class _PotholePhoto implements PotholePhoto {
  const factory _PotholePhoto({
    @JsonKey(name: 'image_url', readValue: _readPhotoUrl)
    final String? photoUrl,
    @JsonKey(name: 'photo_type') final String? photoType,
    final double? accuracy,
    final double? latitude,
    final double? longitude,
  }) = _$PotholePhotoImpl;

  factory _PotholePhoto.fromJson(Map<String, dynamic> json) =
      _$PotholePhotoImpl.fromJson;

  @override
  @JsonKey(name: 'image_url', readValue: _readPhotoUrl)
  String? get photoUrl;
  @override
  @JsonKey(name: 'photo_type')
  String? get photoType;
  @override
  double? get accuracy;
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of PotholePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PotholePhotoImplCopyWith<_$PotholePhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/constants/api_endpoints.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

/// Report Repository - Handles all report/pothole operations
class ReportRepository {
  final ApiService _apiService;
  Map<String, dynamic>? lastCaseDetailsData;

  ReportRepository({required ApiService apiService}) : _apiService = apiService;

  // result class for aee assignment reports
  Future<AeeAssignmentResult> getAeeAssignmentReports({
    required String filter,
    int page = 1,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.pendingReassignAee,
      queryParameters: {'filter': filter, 'page': page, 'limit': 10},
    );
    final data = response.data;

    if (data['status'] == 'success') {
      final List<dynamic> reportsData = data['data'] ?? [];
      final reports = reportsData.map((e) {
        final map = Map<String, dynamic>.from(e);
        if (map['case_id'] == null && map['case_no'] != null) {
          map['case_id'] = map['case_no'].toString();
        }
        return PotholeModel.fromJson(map);
      }).toList();

      final counts = data['counts'] ?? {};
      return AeeAssignmentResult(
        reports: reports,
        pendingCount: counts['pending_count'] ?? 0,
        reassignedCount: counts['reassigned_count'] ?? 0,
      );
    }
    return const AeeAssignmentResult(
      reports: [],
      pendingCount: 0,
      reassignedCount: 0,
    );
  }

  // ==================== SUMMARY COUNTS ====================

  ReportSummaryModel _parseSummary(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return ReportSummaryModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );
    }
    return ReportSummaryModel.fromJson(responseData as Map<String, dynamic>);
  }

  Future<ReportSummaryModel> getReportSummarySe() async {
    final response = await _apiService.get(
      ApiEndpoints.getReportSummaryCountsSe,
    );
    return _parseSummary(response.data);
  }

  Future<ReportSummaryModel> getReportSummaryEe() async {
    final response = await _apiService.get(
      ApiEndpoints.getReportSummaryCountsEe,
    );
    return _parseSummary(response.data);
  }

  Future<ReportSummaryModel> getReportSummaryAee() async {
    final response = await _apiService.get(
      ApiEndpoints.getReportSummaryCountsAee,
    );
    return _parseSummary(response.data);
  }

  Future<ReportSummaryModel> getReportSummaryJe() async {
    final response = await _apiService.get(ApiEndpoints.getCountsJe);
    return _parseSummary(response.data);
  }

  Future<ReportSummaryModel> getReportSummaryAe() async {
    final response = await _apiService.get(ApiEndpoints.getCountsAe);
    return _parseSummary(response.data);
  }

  Future<ReportSummaryModel> getReportSummaryVendor() async {
    final response = await _apiService.get(
      ApiEndpoints.getReportSummaryCountsVendor,
    );
    return _parseSummary(response.data);
  }

  // ==================== GET REPORTS ====================

  Future<List<PotholeModel>> getReportsByEndpoint(
    String endpoint, {
    int page = 1,
    int limit = 20,
    String? query,
    String? filter,
  }) async {
    final response = await _apiService.get(
      endpoint,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'search': query,
        if (filter != null && filter.isNotEmpty) 'filter': filter,
      },
    );
    final data = response.data;

    if (data['status'] == 'success' && data['data'] != null) {
      final dynamic rawData = data['data'];
      List<dynamic> reportsList = [];

      if (rawData is List) {
        reportsList = rawData;
      } else if (rawData is Map) {
        if (rawData.containsKey('cases') && rawData['cases'] is List) {
          reportsList = rawData['cases'];
        } else if (rawData.containsKey('reports') &&
            rawData['reports'] is List) {
          reportsList = rawData['reports'];
        } else {
          reportsList = [rawData];
        }
      }

      return reportsList.map((report) {
        try {
          final Map<String, dynamic> map = Map<String, dynamic>.from(report);

          if (map['case_id'] == null && map['case_no'] != null) {
            map['case_id'] = map['case_no'].toString();
          }

          map['status'] ??= 'completed';
          map['id'] ??= int.tryParse(map['case_no']?.toString() ?? '') ?? 0;

          map['location_name'] ??= map['area_details'];
          if (map['assigned_date'] == null && map['referred_by'] is Map) {
            map['assigned_date'] = map['referred_by']['time'];
          }
          if (map['assigned_by'] == null && map['referred_by'] is Map) {
            map['assigned_by'] =
                map['referred_by']['display'] ?? map['referred_by']['name'];
          }
          map['remarks'] ??= map['citizen_remark'] ?? map['pothole_remarks'];

          if (map['report_date'] == null) {
            if (map['reported_by'] is Map &&
                map['reported_by']['time'] != null) {
              map['report_date'] = map['reported_by']['time'];
            } else if (map['created_at'] != null) {
              map['report_date'] = map['created_at'];
            }
          }
          final List<String> extractedImages = [];

          // Map pothole_images relation
          if (map['pothole_images'] is List) {
            for (final img in map['pothole_images']) {
              if (img is Map) {
                String? path =
                    img['image_url']?.toString() ??
                    img['image']?.toString() ??
                    img['photo_url']?.toString() ??
                    img['path']?.toString();
                if (path != null) {
                  if (path.startsWith('/')) {
                    path = path.substring(1);
                  }
                  if (!path.startsWith('http')) {
                    path = '${ApiEndpoints.baseUrl}$path';
                  }
                  extractedImages.add(path);
                }
              } else if (img is String) {
                String path = img;
                if (path.startsWith('/')) {
                  path = path.substring(1);
                }
                if (!path.startsWith('http')) {
                  path = '${ApiEndpoints.baseUrl}$path';
                }
                extractedImages.add(path);
              }
            }
          }

          // Check for image_urls/image at root
          if (map['image_urls'] is List) {
            for (var img in map['image_urls']) {
              String path = img.toString();
              if (path.startsWith('/')) {
                path = path.substring(1);
              }
              if (!path.startsWith('http')) {
                path = '${ApiEndpoints.baseUrl}$path';
              }
              if (!extractedImages.contains(path)) {
                extractedImages.add(path);
              }
            }
          } else if (map['image'] != null) {
            if (map['image'] is String && map['image'].toString().isNotEmpty) {
              String path = map['image'].toString();
              if (path.startsWith('/')) {
                path = path.substring(1);
              }
              if (!path.startsWith('http')) {
                path = '${ApiEndpoints.baseUrl}$path';
              }
              if (!extractedImages.contains(path)) {
                extractedImages.add(path);
              }
            } else if (map['image'] is List) {
              for (var img in map['image']) {
                String path = img.toString();
                if (path.startsWith('/')) {
                  path = path.substring(1);
                }
                if (!path.startsWith('http')) {
                  path = '${ApiEndpoints.baseUrl}$path';
                }
                if (!extractedImages.contains(path)) {
                  extractedImages.add(path);
                }
              }
            }
          }

          if (extractedImages.isNotEmpty) {
            map['image_urls'] = extractedImages;
            map['image'] = extractedImages;
          }

          if (map['report_date'] == null) {
            map['report_date'] =
                map['reported_at'] ??
                map['created_at'] ??
                (map['reported_by'] is Map ? map['reported_by']['time'] : null);
          }

          final model = PotholeModel.fromJson(map);

          return model;
        } catch (err) {
          rethrow;
        }
      }).toList();
    }
    return [];
  }

  Future<List<PotholeModel>> getPendingEe({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.pendingReassignEe, page: page);

  Future<List<PotholeModel>> getPendingAee({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.pendingReassignAee, page: page);
  Future<List<PotholeModel>> getPendingJe({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.pendingReassignJe, page: page);
  Future<List<PotholeModel>> getPendingAe({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.pendingReassignAe, page: page);

  Future<List<PotholeModel>> getAssignedJe({int page = 1}) async =>
      getReportsByEndpoint(
        '${ApiEndpoints.baseUrl}api/v1/je/assigned-cases',
        page: page,
      );
  Future<List<PotholeModel>> getCompletedJe({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.inspectionCompletedCasesJe, page: page);

  Future<List<PotholeModel>> getReviewInspectionsEe({int page = 1}) async =>
      getReportsByEndpoint(ApiEndpoints.reviewInspectionReportEe, page: page);
  Future<List<PotholeModel>> getAllReportsEe({int page = 1}) async =>
      getReportsByEndpoint(
        ApiEndpoints.allAssignedCompletedRejectedCasesEe,
        page: page,
      );

  // ==================== CASE ACTIONS ====================

  Future<void> acceptCaseEe(int caseId) async {
    await _apiService.post(
      ApiEndpoints.acceptPendingCasesEe,
      data: {'case_id': caseId},
    );
  }

  Future<void> acceptCaseAee(int caseId) async {
    await _apiService.post(
      ApiEndpoints.acceptPendingCasesAee,
      data: {'case_id': caseId},
    );
  }

  Future<void> rejectCaseEe({
    required int caseId,
    required List<int> rejectMasterIds,
    required String otherReason,
  }) async {
    await _apiService.post(
      ApiEndpoints.rejectCaseEe,
      data: {
        'case_id': caseId,
        'reject_master_ids': rejectMasterIds,
        'other_reason': otherReason,
      },
    );
  }

  Future<void> reassignToAee({
    required String caseId,
    required String otherReason,
  }) async {
    await _apiService.post(
      ApiEndpoints.reassignToAee,
      data: {
        'case_id': caseId,
        'reassign_master_ids': [6], // default reason id for return
        'other_reason': otherReason,
      },
    );
  }

  Future<void> assignToAee(int caseId, int aeeId, [String? remark]) async {
    // Matches Android Volley StringRequest.getParams().
    await _apiService.post(
      ApiEndpoints.assignToAee,
      data: {
        'caseId': caseId.toString(),
        'aeeId': aeeId.toString(),
        'remark': remark ?? '',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  Future<void> assignToFieldEng({
    required int caseId,
    required int engineerId,
    required String engineerType,
    String? remark,
  }) async {
    await _apiService.post(
      ApiEndpoints.assignToFieldEng,
      data: {
        'caseId': caseId.toString(),
        'assigneeId': engineerId.toString(),
        'assigneeType': engineerType,
        'remark': remark ?? '',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  Future<void> assignToSelfAee({required int caseId, String? remark}) async {
    // According to Java legacy code (PendingAeeViewDetailsFragment.java:380-381):
    // It uses snake_case keys 'case_id' and sends as JSON.
    await _apiService.post(
      ApiEndpoints.assignToSelfAee,
      data: {'case_id': caseId, 'remark': remark ?? ''},
    );
  }

  Future<void> transferToAee({
    required int caseId,
    required int aeeId,
    String? remark,
  }) async {
    await _apiService.post(
      ApiEndpoints.transferToAee,
      data: {
        'case_id': caseId.toString(),
        'aee_id': aeeId.toString(),
        'remark': remark ?? '',
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  Future<void> forwardToSe(int caseId, int seUserId, String remarks) async {
    await _apiService.post(
      ApiEndpoints.forwardToSe,
      data: {'case_id': caseId, 'se_user_id': seUserId, 'remarks': remarks},
    );
  }


  // NOTE: forwardToEe is defined in the AEE TAKE ACTION section below with named parameters.

  // ==================== CASE DETAILS ====================

  Future<PotholeModel> getCaseDetails(String caseId) async {
    final storage = StorageService();
    final role = storage.userType ?? '';
    final roleStr = role.toLowerCase();

    if (roleStr.isEmpty) {
      throw Exception(
        'User role not found in storage. Cannot fetch case details.',
      );
    }

    String endpoint;
    final idInt = int.tryParse(caseId);
    if (idInt == null) {
      throw Exception(
        'Invalid case ID format: must be numeric. Provided string was instead: $caseId',
      );
    }
    if (roleStr == 'se') {
      endpoint = ApiEndpoints.caseDetailsSe(idInt);
    } else if (roleStr == 'ee') {
      endpoint = ApiEndpoints.caseDetailsEe(idInt);
    } else if (roleStr == 'aee') {
      endpoint = ApiEndpoints.caseDetailsAee(idInt);
    } else if (roleStr == 'ae') {
      endpoint = ApiEndpoints.caseDetailsAe(idInt);
    } else if (roleStr == 'je') {
      endpoint = ApiEndpoints.caseDetailsJe(idInt);
    } else if (roleStr == 'vendor') {
      endpoint = ApiEndpoints.caseDetailsVendor(idInt);
    } else {
      endpoint = ApiEndpoints.caseDetailsAee(idInt);
    }

    if (kDebugMode) print('DEBUG: Fetching case details from: $endpoint');

    final response = await _apiService.get(endpoint);

    if (response.data == null || response.data['data'] == null) {
      throw Exception('Server returned empty data for this case.');
    }

    var resData = response.data['data'];
    Map<String, dynamic> map;

    if (resData is List && resData.isNotEmpty) {
      map = Map<String, dynamic>.from(resData.first);
    } else if (resData is Map) {
      map = Map<String, dynamic>.from(resData);
    } else {
      throw Exception('Unexpected data format from server.');
    }

    if (map['case_id'] == null && map['case_no'] != null) {
      map['case_id'] = map['case_no'].toString();
    }
    map['location_name'] ??= map['area_details'];
    lastCaseDetailsData = Map<String, dynamic>.from(map);

    if (map['report_date'] == null && map['reported_by'] is Map) {
      map['report_date'] = map['reported_by']['time'];
    }
    if (map['assigned_date'] == null) {
      map['assigned_date'] =
          map['aee_assigned_at'] ??
          map['ee_assigned_at'] ??
          map['je_assigned_at'] ??
          map['ae_assigned_at'] ??
          map['vendor_assigned_at'];
    }
    if (map['assigned_by'] == null && map['referred_by'] is Map) {
      map['assigned_by'] =
          map['referred_by']['display'] ?? map['referred_by']['name'];
    }
    map['remarks'] ??= map['citizen_remark'] ?? map['pothole_remarks'];

    // Map pothole_images relation into imageUrls
    if (map['pothole_images'] is List) {
      final List<String> extractedImages = [];
      for (final img in map['pothole_images']) {
        if (img is Map && img.containsKey('image_url')) {
          var url = img['image_url'].toString();
          if (url.startsWith('/')) url = url.substring(1);
          if (!url.startsWith('http')) url = '${ApiEndpoints.baseUrl}$url';
          extractedImages.add(url);
        }
      }
      if (extractedImages.isNotEmpty) {
        map['image_urls'] = extractedImages;
        map['image'] = extractedImages;
      }
    }

    return PotholeModel.fromJson(map);
  }

  Future<List<CaseProceedingModel>> getCaseProceedings(String caseId) async {
    final response = await _apiService.get(
      '${ApiEndpoints.trackAssignedCase}$caseId',
    );
    final resData = response.data['data'] as List;
    return resData
        .map((e) => CaseProceedingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ==================== POTHOLE ACTIVITY MAP ====================
  Future<ActivityMapData> getActivityMap(String userRole) async {
    String endpoint = '';
    final role = userRole.toLowerCase();
    switch (role) {
      case 'je':
        endpoint = ApiEndpoints.potholeActivityMapJe;
        break;
      case 'ae':
        endpoint = ApiEndpoints.potholeActivityMapAe;
        break;
      case 'vendor':
        endpoint = ApiEndpoints.potholeActivityMapVendor;
        break;
      case 'aee':
        endpoint = ApiEndpoints.potholeActivityMapAee;
        break;
      case 'ee':
        endpoint = ApiEndpoints.potholeActivityMapEe;
        break;
      case 'se':
        endpoint = ApiEndpoints.potholeActivityMapSe;
        break;
    }

    if (endpoint.isEmpty) return const ActivityMapData();

    final response = await _apiService.get(endpoint);
    final data = response.data;
    if (data['status'] == 'success') {
      final dataMap = data['data'] as Map<String, dynamic>;

      List<ActivityMapPoint> extractPoints(String key) {
        if (dataMap.containsKey(key) &&
            dataMap[key] != null &&
            dataMap[key] is Map) {
          final obj = dataMap[key] as Map<String, dynamic>;
          if (obj.containsKey('coordinates') && obj['coordinates'] is List) {
            final arr = obj['coordinates'] as List;
            return arr
                .map(
                  (e) => ActivityMapPoint.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
        }
        return [];
      }

      return ActivityMapData(
        inProgress: extractPoints('in_progress'),
        rejected: extractPoints('rejected'),
        completed: extractPoints('completed'),
      );
    }
    return const ActivityMapData();
  }
  // ==================== CREATE REPORT ====================

  Future<void> createReport({
    required String address,
    required String description,
    required double latitude,
    required double longitude,
    required String category,
    required String priority,
    String? district,
    String? pincode,
    String? landmark,
    double? accuracy,
    List<File>? images,
  }) async {
    final data = {
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'priority': priority,
      if (district != null) 'district': district,
      if (pincode != null) 'pincode': pincode,
      if (landmark != null) 'landmark': landmark,
      if (accuracy != null) 'accuracy': accuracy,
    };

    await _apiService.post('/api/v1/create-report', data: data);
  }

  // ==================== CAPTURE NEARBY POTHOLE ====================
  Future<void> captureNearbyPothole({
    required String areaDetails,
    required String landmark,
    required String remarks,
    required double accuracy,
    required List<File> images,
    required List<Map<String, double>> coordinates,
  }) async {
    final storage = StorageService();
    final role = storage.userType?.toLowerCase();
    if (role == null) throw Exception('User role not found in storage.');

    String url = '';
    if (role == 'ae') {
      url = 'api/v1/ae/capture-nearby-pothole';
    } else if (role == 'je') {
      url = 'api/v1/je/capture-nearby-pothole';
    } else {
      url = 'api/v1/$role/capture-nearby-pothole'; // Fallback
    }

    final formData = FormData.fromMap({
      'severity': 'Medium',
      'area_details': areaDetails,
      'landmark': landmark,
      'remarks': remarks,
      'accuracy': accuracy.toString(),
      'coordinates': jsonEncode(coordinates),
    });

    for (int i = 0; i < images.length; i++) {
      var file = images[i];
      formData.files.add(
        MapEntry(
          'potholeImages',
          await MultipartFile.fromFile(
            file.path,
            filename:
                'image_$i.jpeg', // Some servers clash if files have the exact same name, adding index.
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    await _apiService.postMultipart(
      '${ApiEndpoints.baseUrl}$url',
      formData: formData,
    );
  }

  // ==================== AEE TAKE ACTION ====================

  /// Forward a review-inspection case to EE (Satisfied path)
  /// Android: API.forward_to_ee → api/v1/aee/forward-to-ee
  Future<void> forwardToEe({required String caseId, String? remarks}) async {
    final body = <String, dynamic>{'case_id': caseId};
    if (remarks != null && remarks.isNotEmpty) body['remarks'] = remarks;
    await _apiService.post(ApiEndpoints.forwardToEe, data: body);
  }

  /// Reassign a case back to AE/JE (Unsatisfied path)
  /// Android: API.reassign_to_ae_je → api/v1/aee/reassign-case
  Future<void> reassignToAeJe({
    required String caseId,
    required String otherReason,
  }) async {
    await _apiService.post(
      ApiEndpoints.reassignToAeJe,
      data: {
        'case_id': caseId,
        'reassign_master_ids': [6], // default reason id as used in Android
        'other_reason': otherReason,
      },
    );
  }

  // ==================== SE TAKE ACTION ====================

  /// Approve a case (Satisfied path)
  /// Android: API.approve_case → api/v1/se/approve-case
  Future<void> approveCaseSe({required String caseId, String? remarks}) async {
    final body = <String, dynamic>{'case_id': caseId};
    if (remarks != null && remarks.isNotEmpty) body['remarks'] = remarks;
    await _apiService.post(ApiEndpoints.approveCase, data: body);
  }

  /// Reassign a case to EE (Unsatisfied path)
  /// Android: API.reassign_to_ee → api/v1/se/reassign-case
  Future<void> reassignToEe({
    required String caseId,
    required String otherReason,
  }) async {
    await _apiService.post(
      ApiEndpoints.reassignToEe,
      data: {
        'case_id': caseId,
        'reassign_master_ids': [6], // default reason id
        'other_reason': otherReason,
      },
    );
  }

  // ==================== JE / AE ACTIONS ====================

  Future<void> acceptCaseJeAe(int caseId, String userType) async {
    final endpoint = (userType.toLowerCase() == 'ae')
        ? ApiEndpoints.acceptPendingCasesAe
        : ApiEndpoints.acceptPendingCasesJe;
    await _apiService.post(endpoint, data: {'case_id': caseId});
  }

  Future<void> rejectCaseJeAe({
    required int caseId,
    required String userType,
    required List<int> rejectMasterIds,
    String? otherReason,
  }) async {
    final endpoint = (userType.toLowerCase() == 'ae')
        ? ApiEndpoints.rejectCaseAe
        : ApiEndpoints.rejectCaseJe;
    await _apiService.post(
      endpoint,
      data: {
        'case_id': caseId,
        'reject_master_ids': rejectMasterIds,
        if (otherReason != null && otherReason.isNotEmpty)
          'other_reason': otherReason,
      },
    );
  }

  Future<void> assignVendor({
    required int caseId,
    required int vendorUserId,
    required String userType,
    required String remark,
  }) async {
    final role = userType.toLowerCase();
    final endpoint = role == 'aee'
        ? ApiEndpoints.assignVendorAee
        : (role == 'ae' ? ApiEndpoints.assignVendorAe : ApiEndpoints.assignVendorJe);

    await _apiService.post(
      endpoint,
      data: {
        'case_id': caseId,
        'vendor_user_id': vendorUserId.toString(),
        if (role == 'aee') 'aee_remark': remark,
        if (role == 'ae') 'ae_remark': remark,
        if (role == 'je') 'je_remark': remark,
      },
    );
  }

  /// Submit field inspection — mirrors Java InspectFragment.sendPotholeData().
  /// Accepts pre-built arrays so before/after images and dimensions
  /// are correctly separated (the old method tagged everything as 'before').
  Future<void> submitFieldInspectionJeAe({
    required int potholeId,
    required String remarks,
    required String material,
    required List<File> images,
    required List<Map<String, dynamic>> potholes,
    required List<String> photoTypes,
    required List<int> photoIndexes,
    required List<double> photoLatitudes,
    required List<double> photoLongitudes,
  }) async {
    final storage = StorageService();
    final role = storage.userType?.toLowerCase();
    final endpoint = role == 'aee'
        ? '${ApiEndpoints.baseUrl}api/v1/aee/inspect-pothole'
        : (role == 'ae'
              ? '${ApiEndpoints.baseUrl}api/v1/ae/inspect-pothole'
              : '${ApiEndpoints.baseUrl}api/v1/je/inspect-pothole');

    final formData = FormData.fromMap({
      'case_id': potholeId,
      'total_potholes': potholes.length,
      'potholes': jsonEncode(potholes),
      'photo_pothole_index': jsonEncode(photoIndexes),
      'photo_type': jsonEncode(photoTypes),
      'photo_latitudes': jsonEncode(photoLatitudes),
      'photo_longitudes': jsonEncode(photoLongitudes),
      'inspection_remark': remarks,
      'consumption_material': material,
    });

    for (int i = 0; i < images.length; i++) {
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            images[i].path,
            filename: 'inspection_$i.jpg',
          ),
        ),
      );
    }

    await _apiService.postMultipart(endpoint, formData: formData);
  }

  double _parseDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  // ==================== VENDOR ACTIONS ====================

  Future<void> vendorArriveAtLocation({
    required int caseId,
  }) async {
    await _apiService.post(
      ApiEndpoints.arrivedLocationVendor,
      data: {'case_id': caseId.toString()},
    );
  }

  Future<void> vendorConfirmFix({
    required int potholeId,
    required String remarks,
  }) async {
    await _apiService.post(
      ApiEndpoints.taskCompletedVendor,
      data: {
        'case_id': potholeId.toString(),
        'vendor_remark': remarks.trim(),
      },
    );
  }

  // ==================== CASE ACTIONS (Generic) ====================

  Future<void> acceptCase(String caseId) async {
    await _apiService.post('/api/v1/accept-case', data: {'case_id': caseId});
  }

  Future<void> rejectCase(String caseId, String reason) async {
    await _apiService.post(
      '/api/v1/reject-case',
      data: {'case_id': caseId, 'reason': reason},
    );
  }

  Future<void> verifyCompletion(String caseId) async {
    await _apiService.post(
      '/api/v1/verify-completion',
      data: {'case_id': caseId},
    );
  }

  Future<List<UserModel>> getUsersInDivision([String? userType]) async {
    String url = ApiEndpoints.getUsers;
    if (userType != null) {
      url += '?user_type=$userType';
    }
    final response = await _apiService.get(url);
    final data = response.data;
    if (data['status'] == 'success') {
      final List<dynamic> usersData = data['data'] ?? [];
      return usersData
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getReassignReasons() async {
    final response = await _apiService.get(ApiEndpoints.reAssignReason);
    final data = response.data;
    if (data['status'] == 'success') {
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getRejectReasons() async {
    final response = await _apiService.get(ApiEndpoints.rejectMaster);
    final data = response.data;
    if (data['status'] == 'success') {
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return [];
  }

  Future<void> rejectCaseAee({
    required int caseId,
    required List<int> rejectMasterIds,
    String? otherReason,
  }) async {
    await _apiService.post(
      ApiEndpoints.rejectCaseAee,
      data: {
        'case_id': caseId,
        'reject_master_ids': rejectMasterIds,
        if (otherReason != null) 'other_reason': otherReason,
      },
    );
  }

  // ==================== IMAGE UPLOAD ====================

  Future<void> uploadCaseImage({
    required int caseId,
    required int potholeId,
    required String imagePath,
    String? remarks,
  }) async {
    final formData = FormData.fromMap({
      'case_id': caseId,
      'pothole_id': potholeId,
      'image': await MultipartFile.fromFile(imagePath),
      'remarks': remarks,
    });

    await _apiService.postMultipart(
      '${ApiEndpoints.baseUrl}api/v1/admin/upload-case-image',
      formData: formData,
    );
  }

  Future<void> uploadFixImage({
    required int caseId,
    required int potholeId,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'case_id': caseId,
      'pothole_id': potholeId,
      'image': await MultipartFile.fromFile(imagePath),
    });

    await _apiService.postMultipart(
      '${ApiEndpoints.baseUrl}api/v1/admin/upload-fix-image',
      formData: formData,
    );
  }

  Future<void> submitFinalReportJeAe({
    required String role,
    required String caseId,
    required String fieldNote,
    required String materialConsumption,
    required List<File> images,
  }) async {
    final position = await LocationService().getCurrentPosition();
    final formData = FormData.fromMap({
      'field_note': fieldNote,
      'material_consumption_kg': materialConsumption,
      'inspection_date': DateTime.now().toUtc().toIso8601String(),
      'latitude': (position?.latitude ?? 0).toString(),
      'longitude': (position?.longitude ?? 0).toString(),
    });

    for (int i = 0; i < images.length; i++) {
      formData.files.add(
        MapEntry(
          'afterFixImages',
          await MultipartFile.fromFile(
            images[i].path,
            filename: 'image_$i.jpeg',
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    await _apiService.postMultipart(
      '${ApiEndpoints.baseUrl}api/v1/$role/inspect-pothole/add-after-fix-photos/$caseId',
      formData: formData,
    );
  }
}

class AeeAssignmentResult {
  final List<PotholeModel> reports;
  final int pendingCount;
  final int reassignedCount;

  const AeeAssignmentResult({
    required this.reports,
    required this.pendingCount,
    required this.reassignedCount,
  });
}

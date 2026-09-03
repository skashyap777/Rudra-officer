import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/date_formatter.dart';


// ── Constants ────────────────────────────────────────────────────────────────
const _kGreen = Color(0xFF3D9A7E);
const _kBg = Color(0xFFF5F7FA);
const _kBorder = Color(0xFFEEEEEE);

String _getImageUrl(String url) {
  if (url.startsWith('http')) return url;
  final clean = url.startsWith('/') ? url.substring(1) : url;
  return '${ApiEndpoints.baseUrl}$clean';
}

class ReportDetailScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String? filterType;

  final PotholeModel? initialReport;

  const ReportDetailScreen({
    super.key, 
    required this.caseId, 
    this.filterType,
    this.initialReport,
  });

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends ConsumerState<ReportDetailScreen> {
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final caseDetailAsync = ref.watch(caseDetailProvider(widget.caseId));
    final userType = StorageService().userType?.toLowerCase() ?? '';

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _screenTitle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(child: caseDetailAsync.when(
        data: (p) => _buildContent(p, userType),
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => _ErrorState(
          message: e.toString(),
          onRetry: () => ref.refresh(caseDetailProvider(widget.caseId)),
        ),
      )),
    );
  }

  Widget _buildContent(PotholeModel p, String userType) {
    if (_isAssignedFieldEngineerCase(p)) {
      return _buildAssignedFieldEngineerContent(p, userType);
    }
    if (_isCompletedCase(p)) {
      return _buildCompletedContent(p, userType);
    }
    if (_isReturnedCase(p)) {
      return _buildReturnedContent(p, userType);
    }

    final images = p.imageUrls ?? [];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Case ID & Status ────────────────────────────────────
                _StatusHeader(pothole: p),
                const SizedBox(height: 10),

                // ── Images ────────────────────────────────────────────────
                if (images.isNotEmpty) ...[
                  _ImageGallery(
                    urls: images,
                    selectedIndex: _selectedImageIndex,
                    onSelect: (i) => setState(() => _selectedImageIndex = i),
                    onFullscreen: _showFullImage,
                  ),
                  const SizedBox(height: 10),
                ],

                // ── Info sections ─────────────────────────────────────────
                _Section(
                  title: 'Core Information',
                  icon: Icons.assignment_outlined,
                  children: [
                    _row2(
                      'Case ID',
                      p.caseId,
                      'Reported On',
                      _fmtDate(p.reportDate ?? p.createdAt),
                    ),
                    const SizedBox(height: 10),
                    _row2(
                      'Division',
                      p.divisionName ?? p.division ?? '---',
                      'Accuracy',
                      _fmtAccuracy(p),
                    ),
                    if (p.remarks != null && p.remarks!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _field('Remarks', p.remarks!),
                    ],
                  ],
                ),
                const SizedBox(height: 10),

                _Section(
                  title: 'Location Detail',
                  icon: Icons.location_on_outlined,
                  trailing: InkWell(
                    onTap: () => context.pushNamed('potholeMap', extra: p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: _kGreen.withValues(alpha: 0.1),
                      child: const Text(
                        'VIEW ON MAP',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: _kGreen,
                        ),
                      ),
                    ),
                  ),
                  children: [
                    _field(
                      'Physical Address',
                      p.location ??
                          p.address ??
                          p.roadName ??
                          'Coordinate recorded only',
                    ),
                    const SizedBox(height: 12),
                    _MapPreview(
                      lat: p.latitude ?? p.potholeImages?.firstOrNull?.latitude,
                      lng:
                          p.longitude ??
                          p.potholeImages?.firstOrNull?.longitude,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (p.officerReports != null &&
                    p.officerReports!.isNotEmpty &&
                    p.status.toLowerCase() != 'requested') ...[
                  _Section(
                    title: 'Inspection Progress',
                    icon: Icons.fact_check_outlined,
                    children: [
                      _row2(
                        'Material',
                        p.officerReports!.first.consumptionMaterial ?? '---',
                        'Remark',
                        p.officerReports!.first.inspectionRemark ?? '---',
                      ),
                      if (p.inspectedBy != null) ...[
                        const SizedBox(height: 10),
                        _row2(
                          'Inspector',
                          p.inspectedBy!.name ?? '---',
                          'Date',
                          p.inspectedBy!.date ?? '---',
                        ),
                        const SizedBox(height: 10),
                        _field(
                          'Designation',
                          p.inspectedBy!.designation ?? '---',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                if (_hasDimensions(p)) ...[
                  _Section(
                    title: 'Measurements',
                    icon: Icons.straighten_rounded,
                    children: [
                      for (
                        int i = 0;
                        i < p.officerReports!.first.potholesData!.length;
                        i++
                      )
                        _DimensionItem(
                          index: i,
                          data: p.officerReports!.first.potholesData![i],
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],

                // ── Tracking ────────────────────────────────────────────
                InkWell(
                  onTap: () => context.pushNamed(
                    'trackReport',
                    pathParameters: {'id': p.id.toString()},
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _kBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.history_rounded, size: 16, color: _kGreen),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'VIEW REPORT TIMELINE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (_shouldShowActionPanel(p, userType))
          _ActionPanel(
            label: _getActionLabel(p, userType),
            onTap: () => _openTakeAction(p, userType),
          ),
      ],
    );
  }

  bool _hasDimensions(PotholeModel p) {
    if (p.officerReports == null || p.officerReports!.isEmpty) return false;
    final d = p.officerReports!.first.potholesData;
    return d != null && d.isNotEmpty;
  }

  bool _isAssignedFieldEngineerCase(PotholeModel p) {
    final f = widget.filterType?.toLowerCase() ?? '';
    return f == 'assigned_ae' ||
        f == 'assigned_je' ||
        f == 'assigned_aee' ||
        f == 'self_inspection_aee' ||
        f == 'self_captured_aee';
  }

  bool _isCompletedCase(PotholeModel p) {
    final f = widget.filterType?.toLowerCase() ?? '';
    final status = p.status.toLowerCase();
    final raw = _rawDetails;
    return status == 'completed' ||
        status == 'closed' ||
        status == 'satisfied' ||
        status == 'approved' ||
        status == 'inspected' ||
        status.contains('review') ||
        f.contains('completed') ||
        f.contains('closed') ||
        f.contains('submit_final') ||
        f.contains('review') ||
        _hasValue(raw['completed_by']) ||
        _hasValue(raw['completed_date']) ||
        _hasValue(raw['completion_date']);
  }

  bool _isReturnedCase(PotholeModel p) {
    final f = widget.filterType?.toLowerCase() ?? '';
    // Vendor re-assigned cases are active work items, not returned/rejected
    if (f.contains('vendor')) return false;
    final status = p.status.toLowerCase();
    final raw = _rawDetails;
    return status == 'rejected' ||
        status == 'returned' ||
        status == 'reassigned' ||
        f.contains('rejected') ||
        f.contains('returned') ||
        f.contains('reassigned') ||
        _hasValue(raw['rejected_by']) ||
        _hasValue(raw['rejected_reason']) ||
        _hasValue(raw['rejection_reason']) ||
        _hasValue(raw['returned_by']) ||
        _hasValue(raw['return_reason']) ||
        _hasValue(raw['reassigned_by']);
  }

  String get _screenTitle {
    final f = widget.filterType?.toLowerCase() ?? '';
    if (f == 'assigned_ae' || f == 'assigned_je' || f == 'assigned_aee') {
      return 'Assigned Report Details';
    }
    if (f.contains('completed') || f.contains('closed')) {
      return 'Completed Report Details';
    }
    if (f.contains('review')) {
      return 'Inspected Report Details';
    }
    if (f.contains('rejected')) return 'Rejected Report Details';
    if (f.contains('returned') || f.contains('reassigned')) {
      return 'Returned Report Details';
    }
    if (f == 'self_inspection_aee') {
      return 'Self Assigned Report Details';
    }
    if (f == 'self_captured_aee') {
      return 'Self Captured Report Details';
    }
    return 'Case Details';
  }

  Map<String, dynamic> get _rawDetails {
    final raw = ref.read(reportRepositoryProvider).value?.lastCaseDetailsData;
    return raw == null ? <String, dynamic>{} : Map<String, dynamic>.from(raw);
  }

  Widget _buildAssignedFieldEngineerContent(PotholeModel p, String userType) {
    final raw = _rawDetails;
    final initial = widget.initialReport;
    final fallbackOfficer = initial?.officerReports?.isNotEmpty == true ? initial!.officerReports!.first : null;
    final reportedBy = _asMap(raw['reported_by']);
    final referredBy = _asMap(raw['referred_by']);
    final inspectedBy = _asMap(raw['inspected_by']);
    final officerReport = _firstMap(raw['officer_reports']);
    final potholeImages = _asList(raw['pothole_images']);
    final originalImages = _urlsFromObjects(potholeImages, 'image_url');
    final dimensions = _asList(officerReport['potholes_data']);
    final location = _clean(
      raw['area_details'] ?? p.location ?? p.address ?? p.roadName,
    );

    final assignedByName = _clean(referredBy['display'] ?? p.assignedBy);
    final assignedRemark = _clean(
      referredBy['remark'] ??
          raw['aee_remark'] ??
          raw['ee_remark'] ??
          raw['ae_remark'] ??
          raw['je_remark'],
    );
    final currentUser = ref.watch(currentUserProvider);
    final referredTo = _asMap(raw['referred_to']);
    final assignedTo = _asMap(raw['assigned_to']);

    String resolvedName = _clean(
      raw['vendor_name'] ??
          p.vendorName ??
          referredTo['display'] ??
          referredTo['name'] ??
          assignedTo['display'] ??
          assignedTo['name'] ??
          raw['assigned_to_name'] ??
          p.assignedToName,
    );

    // Fallback to current user if assigned to them and name is missing
    if (resolvedName == '---') {
      final myId = currentUser?.id;
      final isAssignedToMe = (myId != null) &&
          (raw['ae_user_id'] == myId ||
              raw['je_user_id'] == myId ||
              raw['aee_user_id'] == myId ||
              raw['vendor_user_id'] == myId);

      if (isAssignedToMe && currentUser?.name != null) {
        resolvedName = currentUser!.name!;
      }
    }

    final isVendor = _clean(raw['vendor_name'] ?? p.vendorName) != '---';
    final displayAssignedTo = resolvedName;
    final displayRole = isVendor ? 'Vendor' : 'Officer';

    final vendorSent = _isSentToVendor(p);
    final vendorConfirmed = p.vendorAccConfirmed;
    final hasOfficerReport = p.officerReports?.isNotEmpty ?? false;
    final hasOnlyBefore =
        hasOfficerReport &&
        p.officerReports!.first.status?.toLowerCase() == 'saved';
    final showInspect = vendorConfirmed && !hasOnlyBefore;
    final showContinue = vendorConfirmed && hasOnlyBefore;
    final showInspectedCard = showContinue;
    final showCitizenDetails = !showContinue;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showCitizenDetails) ...[
                  _Section(
                    title: 'Report Summary',
                    icon: Icons.assignment_outlined,
                    children: [
                      _kvRow('Report ID', _clean(raw['case_no'] ?? p.caseId)),
                      _kvRow(
                        'Date Reported',
                        _fmtApiDate(
                          reportedBy['time'] ?? p.reportDate ?? p.createdAt,
                        ),
                      ),
                      if (vendorSent || referredBy.isNotEmpty || raw.containsKey('assigned_by')) ...[
                        _kvRow(
                          'Date Assigned',
                          _fmtApiDate(raw['assigned_date'] ?? p.assignedDate ?? referredBy['time']),
                        ),
                        _kvRow('Assigned By', () {
                          final abMap = _asMap(raw['assigned_by']);
                          final abName = _clean(abMap['name'] ?? p.assignedBy);
                          final abDes = _clean(abMap['designation']);
                          return abDes.isNotEmpty ? '$abName ($abDes)' : abName;
                        }()),
                      ],
                      _kvRow(
                        'Division/Zone',
                        _clean(
                          raw['division_name'] ?? p.divisionName ?? p.division,
                        ),
                      ),
                      _kvRow(
                        'Location Accuracy',
                        _fmtAccuracy(p),
                      ),
                      const SizedBox(height: 8),
                      _field(
                        'Remarks from Citizen',
                        _clean(
                          raw['citizen_remark'] ??
                              reportedBy['remark'] ??
                              p.remarks,
                        ),
                      ),
                      if (vendorSent || referredBy.isNotEmpty || raw.containsKey('assigned_by')) ...[
                        const SizedBox(height: 8),
                        _field(
                          'Remarks from ${_asMap(raw['assigned_by'])['designation'] ?? referredBy['designation'] ?? 'Assistant Executive Engineer'}',
                          assignedRemark,
                        ),
                        if (vendorSent) ...[
                          const SizedBox(height: 12),
                          _textLink('Track your assigned report', () {
                            context.pushNamed('activityMap', extra: p);
                          }),
                        ],
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),

                  _Section(
                    title: 'Location & Map',
                    icon: Icons.location_on_outlined,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              location,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _MapPreview(
                        lat: p.latitude ?? p.potholeImages?.firstOrNull?.latitude,
                        lng: p.longitude ?? p.potholeImages?.firstOrNull?.longitude,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => context.pushNamed('potholeMap', extra: p),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.amber,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Open in Maps',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (originalImages.isNotEmpty) ...[
                    _Section(
                      title: 'Images',
                      icon: Icons.image_outlined,
                      children: [
                        _AfterFixPreview(
                          urls: originalImages,
                          onTap: _showImageGallery,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                if (showInspectedCard && hasOnlyBefore) ...[
                  _Section(
                    title: 'Inspected Details',
                    icon: Icons.fact_check_outlined,
                    children: [
                      _row2(
                        'Inspected By',
                        _clean(
                          inspectedBy['display'] ??
                              inspectedBy['name'] ??
                              p.inspectedBy?.name,
                        ),
                        'Inspected On',
                        _fmtApiDate(inspectedBy['date'] ?? p.inspectionDate ?? initial?.inspectedBy?.date ?? initial?.inspectionDate),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < dimensions.length; i++)
                        _CompletedDimensionItem(
                          index: i,
                          data: _asMap(dimensions[i]),
                          onOpenImages: _showImageGallery,
                        ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => context.pushNamed(
                          'fieldInspection',
                          extra: {
                            'caseId': p.id.toString(),
                            'reportId': p.caseId,
                          },
                        ),
                        child: const Text(
                          'Update Current Status',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        if (!vendorConfirmed && (userType == 'ae' || userType == 'je' || userType == 'aee'))
          _DualActionPanel(
            label1: 'Assign Vendor',
            onTap1: () => _showAssignVendorDialog(p, userType),
            label2: 'Reject',
            onTap2: () => _showRejectDialog(p, userType),
          )
        else if (showInspect)
          _ActionPanel(
            label: 'INSPECT',
            onTap: () => context.pushNamed(
              'fieldInspection',
              extra: {'caseId': p.id.toString(), 'reportId': p.caseId},
            ),
          )
        else if (showContinue)
          _ActionPanel(
            label: 'CONTINUE',
            onTap: () => context.pushNamed(
              'fieldInspection',
              extra: {'caseId': p.id.toString(), 'reportId': p.caseId},
            ),
          ),
      ],
    );
  }

  Widget _buildCompletedContent(PotholeModel p, String userType) {
    final raw = _rawDetails;
    final reportedBy = _asMap(raw['reported_by']);
    final inspectedBy = _asMap(raw['inspected_by']);
    final completedBy = _asMap(raw['completed_by']);
    final officerReport = _firstMap(raw['officer_reports']);
    final potholeImages = _asList(raw['pothole_images']);
    final dimensions = _asList(officerReport['potholes_data']);
    final afterFixPhotos = _asList(officerReport['after_fix_photos']);
    final originalImages = _urlsFromObjects(potholeImages, 'image_url');
    final afterFixImages = _urlsFromObjects(afterFixPhotos, 'photo_url');
    final location = _clean(raw['area_details']) != '---'
        ? _clean(raw['area_details'])
        : _clean(raw['road_name'] ?? p.location ?? p.address ?? p.roadName);

final initial = widget.initialReport;
    final fallbackOfficer = initial?.officerReports?.isNotEmpty == true ? initial!.officerReports!.first : null;
    
    final inspectorName = _clean(inspectedBy['name'] ?? p.inspectedBy?.name ?? initial?.inspectedBy?.name);
    final inspectorDesignation = _clean(
      inspectedBy['designation'] ?? p.inspectedBy?.designation ?? initial?.inspectedBy?.designation,
    );
    final inspectedByText = inspectorDesignation == '---'
        ? inspectorName
        : '$inspectorName ($inspectorDesignation)';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Section(
                  title: 'Report Summary',
                  icon: Icons.assignment_outlined,
                  children: [
                    _kvRow('Report ID', _clean(raw['case_no'] ?? p.caseId)),
                    _kvRow(
                      'Date Reported',
                      _fmtApiDate(
                        reportedBy['time'] ?? p.reportDate ?? p.createdAt,
                      ),
                    ),
                    _kvRow(
                      'Reported By',
                      _clean(reportedBy['display'] ?? reportedBy['name']),
                    ),
                    _kvRow(
                      'Division/Zone',
                      _clean(
                        raw['division_name'] ?? p.divisionName ?? p.division,
                      ),
                    ),
                    _linkRow(
                      'Images',
                      originalImages.isEmpty ? '---' : 'View image',
                      originalImages,
                    ),
                    _mapRow('Location', location, p),
                    _kvRow(
                      'Location Accuracy',
                      _fmtAccuracy(p),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      'Remarks from Citizen',
                      _clean(reportedBy['remark'] ?? p.remarks),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      'Remarks from Vendor',
                      _clean(raw['vendor_remark'] ?? '---'),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => context.pushNamed(
                        'trackReport',
                        pathParameters: {'id': p.id.toString()},
                      ),
                      child: const Text(
                        'Track your inspected report',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _Section(
                  title: 'Inspected Details',
                  icon: Icons.fact_check_outlined,
                  children: [
                    _row2(
                      'Inspected By',
                      inspectedByText,
                      'Inspected On',
                      _fmtApiDate(inspectedBy['date'] ?? p.inspectionDate ?? initial?.inspectedBy?.date ?? initial?.inspectionDate),
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < dimensions.length; i++)
                      _CompletedDimensionItem(
                        index: i,
                        data: _asMap(dimensions[i]),
                        onOpenImages: _showImageGallery,
                      ),
                    if (dimensions.isEmpty && fallbackOfficer?.potholesData != null)
                      for (int i = 0; i < fallbackOfficer!.potholesData!.length; i++)
                        _CompletedDimensionItem(
                          index: i,
                          data: fallbackOfficer.potholesData![i].toJson(),
                          onOpenImages: _showImageGallery,
                        ),
                    _field(
                      'Inspection Remark',
                      _clean(
                        inspectedBy['inspection_remark'] ??
                            officerReport['inspection_remark'] ??
                            initial?.inspectedBy?.inspectionRemark ??
                            fallbackOfficer?.inspectionRemark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _field(
                      'Consumption of Material in Kg',
                      _clean(
                        inspectedBy['consumption_material'] ??
                            officerReport['consumption_material'] ??
                            initial?.inspectedBy?.consumptionMaterial ??
                            fallbackOfficer?.consumptionMaterial,
                      ),
                    ),
                    if (afterFixImages.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _field('Uploaded Image After Fixing Pothole', ''),
                      const SizedBox(height: 6),
                      _AfterFixPreview(
                        urls: afterFixImages,
                        onTap: _showImageGallery,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _field(
                      'Assistant Executive Engineer Remarks',
                      _clean(inspectedBy['aee_remark']),
                    ),
                    const SizedBox(height: 10),
                    _field(
                      'Executive Engineer Remarks',
                      _clean(inspectedBy['ee_remark']),
                    ),
                    const SizedBox(height: 10),
                    _field(
                      'Superintending Engineer Remarks',
                      _clean(completedBy['remark']),
                    ),
                    const SizedBox(height: 10),
                    _row2(
                      'Completed By',
                      _clean(completedBy['display']),
                      'Completed On',
                      _fmtApiDate(
                        completedBy['completion_date'] ??
                            p.completedDate ??
                            p.completionDate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_shouldShowActionPanel(p, userType))
          _ActionPanel(
            label: _getActionLabel(p, userType),
            onTap: () => _openTakeAction(p, userType),
          ),
      ],
    );
  }

  Widget _buildReturnedContent(PotholeModel p, String userType) {
    final raw = _rawDetails;
    final reportedBy = _asMap(raw['reported_by']);
    final rejectedBy = _asMap(raw['rejected_by']);
    final returnedBy = _asMap(raw['returned_by']);
    final reassignedBy = _asMap(raw['reassigned_by']);
    final decisionBy = rejectedBy.isNotEmpty
        ? rejectedBy
        : (returnedBy.isNotEmpty ? returnedBy : reassignedBy);
    final potholeImages = _asList(raw['pothole_images']);
    final originalImages = _urlsFromObjects(potholeImages, 'image_url');
    final location = _clean(
      raw['area_details'] ?? p.location ?? p.address ?? p.roadName,
    );
    final reason = _clean(
      raw['rejected_reason'] ??
          raw['rejection_reason'] ??
          raw['return_reason'] ??
          raw['reason'] ??
          decisionBy['remark'] ??
          p.remarks,
    );
    final decisionLabel = _isRejectedCase(p) ? 'Rejected By' : 'Returned By';
    final dateLabel = _isRejectedCase(p) ? 'Rejected On' : 'Returned On';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Section(
                  title: 'Report Summary',
                  icon: Icons.assignment_outlined,
                  children: [
                    _kvRow('Report ID', _clean(raw['case_no'] ?? p.caseId)),
                    _kvRow(
                      'Date Reported',
                      _fmtApiDate(
                        reportedBy['time'] ?? p.reportDate ?? p.createdAt,
                      ),
                    ),
                    _kvRow(
                      'Reported By',
                      _clean(reportedBy['display'] ?? reportedBy['name']),
                    ),
                    _kvRow(
                      'Division/Zone',
                      _clean(
                        raw['division_name'] ?? p.divisionName ?? p.division,
                      ),
                    ),
                    _linkRow(
                      'Images',
                      originalImages.isEmpty ? '---' : 'View image',
                      originalImages,
                    ),
                    _mapRow('Location', location, p),
                    _kvRow('Location Accuracy', _fmtAccuracy(p)),
                    const SizedBox(height: 8),
                    _field(
                      'Remarks from Citizen',
                      _clean(reportedBy['remark'] ?? p.remarks),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _Section(
                  title: _isRejectedCase(p)
                      ? 'Rejected Details'
                      : 'Returned Details',
                  icon: Icons.assignment_return_outlined,
                  children: [
                    _row2(
                      decisionLabel,
                      _clean(decisionBy['display'] ?? decisionBy['name']),
                      dateLabel,
                      _fmtApiDate(
                        decisionBy['date'] ??
                            raw['rejected_date'] ??
                            raw['returned_date'] ??
                            p.updatedAt,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _field(
                      _isRejectedCase(p) ? 'Rejection Reason' : 'Return Reason',
                      reason,
                    ),
                    const SizedBox(height: 10),
                    _field('Current Status', p.status.toUpperCase()),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => context.pushNamed(
                        'trackReport',
                        pathParameters: {'id': p.id.toString()},
                      ),
                      child: const Text(
                        'Track your report',
                        style: TextStyle(
                          color: _kGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_shouldShowActionPanel(p, userType))
          _ActionPanel(
            label: _getActionLabel(p, userType),
            onTap: () => _openTakeAction(p, userType),
          ),
      ],
    );
  }

  bool _isRejectedCase(PotholeModel p) {
    final f = widget.filterType?.toLowerCase() ?? '';
    return p.status.toLowerCase() == 'rejected' ||
        f.contains('rejected') ||
        _rawDetails.containsKey('rejected_by');
  }

  String _fmtDate(DateTime? dt) => AppDateFormatters.formatIndianDateTime(dt);

  String _fmtApiDate(dynamic value) => AppDateFormatters.formatDynamic(value, includeTime: true);


  String _fmtAccuracy(PotholeModel p) {
    try {
      final potholeImages = _asList(_rawDetails['pothole_images']);
      if (potholeImages.isNotEmpty) {
        final rawAcc = _asMap(potholeImages.first)['accuracy'];
        if (rawAcc != null && rawAcc.toString().trim().isNotEmpty) {
          return '±${rawAcc.toString().trim()} m';
        }
      }
    } catch (_) {}

    if (p.accuracy != null) return '±${p.accuracy!.toStringAsFixed(2)} m';
    final loc = p.location ?? '';
    final m = RegExp(r'\[Accuracy:\s*(.*?)\]').firstMatch(loc);
    if (m != null) return '±${m.group(1)} m';
    return '---';
  }

  Widget _field(String label, String val) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
      if (val.isNotEmpty) ...[
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    ],
  );

  Widget _row2(String l1, String v1, String l2, String v2) => Row(
    children: [
      Expanded(child: _field(l1, v1)),
      const SizedBox(width: 10),
      Expanded(child: _field(l2, v2)),
    ],
  );

  Widget _kvRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _linkRow(String label, String value, List<String> urls) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        InkWell(
          onTap: urls.isEmpty ? null : () => _showImageGallery(urls),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: urls.isEmpty ? Colors.black87 : _kGreen,
              decoration: urls.isEmpty ? null : TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _mapRow(String label, String value, PotholeModel p) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  _shortLocation(value),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed('potholeMap', extra: p),
                child: const Text(
                  ' (+ Map View)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _kGreen,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  String _shortLocation(String value) =>
      value.length > 10 ? '${value.substring(0, 10)}...' : '$value...';

  String _clean(dynamic value) {
    if (value == null) return '---';
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '---';
    return text;
  }

  bool _hasValue(dynamic value) {
    if (value == null) return false;
    if (value is Map || value is List) return value.isNotEmpty;
    return _clean(value) != '---';
  }

  bool _isSentToVendor(PotholeModel p) {
    final raw = _rawDetails;
    return p.pendingAt?.toLowerCase() == 'vendor' ||
        p.vendorUserId != null ||
        p.vendorName != null ||
        _hasValue(raw['vendor_user_id']) ||
        _clean(raw['pending_at']).toLowerCase() == 'vendor';
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Map<String, dynamic> _firstMap(dynamic value) {
    final list = _asList(value);
    if (list.isEmpty) return <String, dynamic>{};
    return _asMap(list.first);
  }

  List<dynamic> _asList(dynamic value) => value is List ? value : const [];

  List<String> _urlsFromObjects(List<dynamic> items, String key) {
    return items
        .map((e) => _asMap(e)[key])
        .where((e) => e != null && e.toString().trim().isNotEmpty)
        .map((e) => _getImageUrl(e.toString()))
        .toList();
  }

  bool _shouldShowActionPanel(PotholeModel p, String userType) {
    final f = widget.filterType;
    if (f == null) return false;
    return {
      'pending_ee',
      'assign_aee_ee',
      'reassigned_aee_ee',
      'reassigned_ee',
      'review_ee',
      'pending_aee',
      'assign_fe_aee',
      'reassigned_aee',
      'review_aee',
      'self_inspection_aee',
      'pending_se',
      'assigned_je',
      'assigned_ae',
      'in_progress_je',
      'in_progress_ae',
      'assigned_vendor',
      'pending_vendor',
      'reassigned_vendor',
      'submit_update_vendor',
      'submit_final_je',
      'submit_final_ae',
    }.contains(f);
  }

  String _getActionLabel(PotholeModel p, String userType) {
    final f = widget.filterType ?? '';
    if (f == 'pending_ee' ||
        f == 'assign_aee_ee' ||
        f == 'reassigned_aee_ee' ||
        f == 'reassigned_ee') {
      return 'ASSIGN TO AEE';
    }
    if (f == 'review_ee' || f == 'review_aee' || f == 'pending_se') {
      return 'TAKE ACTION';
    }
    if (f == 'pending_aee' || f == 'assign_fe_aee' || f == 'reassigned_aee') {
      return 'ASSIGN TO FIELD ENGINEER';
    }
    if (f == 'assigned_je' ||
        f == 'assigned_ae' ||
        f == 'self_inspection_aee') {
      return 'CONDUCT INSPECTION';
    }
    if (f == 'in_progress_je' || f == 'in_progress_ae' || f == 'submit_final_je' || f == 'submit_final_ae') {
      return 'SUBMIT FINAL REPORT';
    }
    if (f == 'assigned_vendor' || f == 'pending_vendor') {
      return 'ARRIVED AT LOCATION';
    }
    if (f == 'reassigned_vendor' || f == 'submit_update_vendor') {
      return f == 'reassigned_vendor' ? 'REPAIR COMPLETED' : 'FINAL SUBMIT';
    }
    return 'TAKE ACTION';
  }

  void _openTakeAction(PotholeModel p, String userType) {
    final f = widget.filterType ?? '';
    final extra = {'caseId': p.id.toString(), 'reportId': p.caseId};
    if (f == 'pending_se') {
      context.pushNamed('takeActionSe', extra: extra);
    } else if (f == 'review_ee') {
      context.pushNamed('takeActionEe', extra: extra);
    } else if ({
      'pending_ee',
      'assign_aee_ee',
      'reassigned_aee_ee',
      'reassigned_ee',
    }.contains(f)) {
      context.pushNamed('assignReportEe', extra: extra);
    } else if (f == 'review_aee') {
      context.pushNamed(
        'takeActionAee',
        extra: {...extra, 'fromFragment': 'detail'},
      );
    } else if ({'pending_aee', 'assign_fe_aee', 'reassigned_aee'}.contains(f)) {
      context.pushNamed('assignReportDetails', extra: extra);
    } else if (f == 'self_inspection_aee') {
      context.pushNamed('fieldInspection', extra: extra);
    } else if (f == 'assigned_je' || f == 'assigned_ae') {
      context.pushNamed('fieldInspection', extra: extra);
    } else if (f == 'in_progress_je' || f == 'in_progress_ae' || f == 'submit_final_je' || f == 'submit_final_ae') {
      context.pushNamed('submitFinalReport', extra: extra);
    } else if ({
      'assigned_vendor',
      'pending_vendor',
      'reassigned_vendor',
      'submit_update_vendor',
    }.contains(f)) {
      context.pushNamed(
        'vendorFix',
        extra: {
          ...extra,
          'report': p,
          'repairOnly': f == 'reassigned_vendor',
          'alreadyArrived':
              f == 'reassigned_vendor' || f == 'submit_update_vendor',
        },
      );
    }
  }

  void _showFullImage(String url) {
    _showImageGallery([url]);
  }

  void _showImageGallery(List<String> urls) {
    if (urls.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) => _ImageDialog(urls: urls),
    );
  }

  Future<void> _showRejectDialog(PotholeModel p, String userType) async {
    int? selectedReasonId;
    String? selectedReasonText;
    final remarkController = TextEditingController();
    bool isSubmitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'REJECTION REASON',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  FutureBuilder<dynamic>(
                    future: ref.read(apiServiceProvider.future).then((api) => api.get(ApiEndpoints.rejectMaster)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: LoadingIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('Failed to load reasons'),
                        );
                      }
                      
                      final data = snapshot.data.data;
                      if (data['status'] != 'success') {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No reasons available'),
                        );
                      }
                      
                      final reasons = (data['data'] as List);
                      
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reasons.length,
                          itemBuilder: (context, index) {
                            final reason = reasons[index];
                            final id = reason['id'] as int;
                            final text = reason['reason'] as String;
                            
                            return RadioListTile<int>(
                              value: id,
                              groupValue: selectedReasonId,
                              title: Text(text, style: const TextStyle(fontSize: 13)),
                              onChanged: (val) {
                                setState(() {
                                  selectedReasonId = val;
                                  selectedReasonText = text;
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  if (selectedReasonText?.contains('Others') == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: remarkController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter rejection reason',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: (selectedReasonId == null || isSubmitting) 
                        ? null 
                        : () async {
                            if (selectedReasonText?.contains('Others') == true && remarkController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter other reason')),
                              );
                              return;
                            }
                            
                            setState(() => isSubmitting = true);
                            try {
                              final repo = await ref.read(reportRepositoryProvider.future);
                              await repo.rejectCaseJeAe(
                                caseId: p.id!,
                                userType: userType,
                                rejectMasterIds: [selectedReasonId!],
                                otherReason: remarkController.text.trim(),
                              );
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(content: Text('Report rejected successfully')),
                                );
                                ref.refresh(caseDetailProvider(p.id.toString()));
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text('Failed: $e')),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => isSubmitting = false);
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8C300),
                        minimumSize: const Size(double.infinity, 48),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: isSubmitting 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('SUBMIT REJECTION'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAssignVendorDialog(PotholeModel p, String userType) async {
    int? selectedVendorId;
    final remarkController = TextEditingController();
    bool isSubmitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'ASSIGN VENDOR',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  FutureBuilder<dynamic>(
                    future: ref.read(apiServiceProvider.future).then((api) => api.get('${ApiEndpoints.getUsers}?user_type=vendor')),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: LoadingIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('Failed to load vendors'),
                        );
                      }
                      
                      final data = snapshot.data.data;
                      if (data['status'] != 'success') {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('No vendors available in this division'),
                        );
                      }
                      
                      final vendors = (data['data'] as List);
                      
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: vendors.length,
                          itemBuilder: (context, index) {
                            final vendor = vendors[index];
                            final id = vendor['id'] as int;
                            final name = vendor['display'] ?? vendor['name'];
                            
                            return RadioListTile<int>(
                              value: id,
                              groupValue: selectedVendorId,
                              title: Text(name, style: const TextStyle(fontSize: 13)),
                              subtitle: Text(vendor['designation'] ?? 'Vendor', style: const TextStyle(fontSize: 11)),
                              onChanged: (val) {
                                setState(() {
                                  selectedVendorId = val;
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: remarkController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Remarks (Optional)',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: (selectedVendorId == null || isSubmitting) 
                        ? null 
                        : () async {
                            setState(() => isSubmitting = true);
                            try {
                              final repo = await ref.read(reportRepositoryProvider.future);
                              await repo.assignVendor(
                                caseId: p.id!,
                                vendorUserId: selectedVendorId!,
                                userType: userType,
                                remark: remarkController.text.trim(),
                              );
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  const SnackBar(content: Text('Vendor assigned successfully')),
                                );
                                ref.refresh(caseDetailProvider(p.id.toString()));
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text('Failed: $e')),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => isSubmitting = false);
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8C300),
                        minimumSize: const Size(double.infinity, 48),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      child: isSubmitting 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('ASSIGN VENDOR'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _kvRowBlue(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Text(
              k,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                v,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _textLink(String text, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4CAF50),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
          ),
        ),
      );
}

class _StatusHeader extends StatelessWidget {
  final PotholeModel pothole;
  const _StatusHeader({required this.pothole});

  @override
  Widget build(BuildContext context) {
    final s = pothole.status.toLowerCase();
    final color = _sColor(s);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pothole.caseId,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: color.withValues(alpha: 0.1),
            child: Text(
              _getDisplayText(s),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _sColor(String s) {
    final status = s.toLowerCase();
    if (status == 'assigned' || status == 'requested' || status == 'pending') {
      return Colors.orange[800]!;
    }
    if (status == 'accepted' || status == 'in_progress') {
      return Colors.blue[700]!;
    }
    if (status == 'completed') return _kGreen;
    if (status == 'rejected') return Colors.red;
    return Colors.grey;
  }

  String _getDisplayText(String s) {
    final status = s.toLowerCase();
    if (status == 'assigned' || status == 'requested' || status == 'pending') {
      return 'REQUESTED';
    }
    if (status == 'accepted' || status == 'in_progress') return 'IN PROGRESS';
    return s.toUpperCase();
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: [
                Icon(icon, size: 14, color: _kGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Container(height: 1, color: _kBorder),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> urls;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ValueChanged<String> onFullscreen;
  const _ImageGallery({
    required this.urls,
    required this.selectedIndex,
    required this.onSelect,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onFullscreen(urls[selectedIndex]),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _kBorder),
            ),
            child: CachedNetworkImage(
              imageUrl: _getImageUrl(urls[selectedIndex]),
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(child: LoadingIndicator()),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          ),
        ),
        if (urls.length > 1) ...[
          const SizedBox(height: 6),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: urls.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: i == selectedIndex ? _kGreen : _kBorder,
                      width: 2,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(urls[i]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AfterFixPreview extends StatelessWidget {
  final List<String> urls;
  final ValueChanged<List<String>> onTap;
  const _AfterFixPreview({required this.urls, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(urls),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 94,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: urls.first,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: _kBg,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          if (urls.length > 1)
            Container(
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                '+${urls.length - 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompletedDimensionItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final ValueChanged<List<String>> onOpenImages;
  const _CompletedDimensionItem({
    required this.index,
    required this.data,
    required this.onOpenImages,
  });

  @override
  Widget build(BuildContext context) {
    final beforeArea = _text(data['before_surface_area']);
    final beforeDepth = _text(data['before_depth']);
    final afterArea = _text(data['after_surface_area']);
    final afterDepth = _text(data['after_depth']);
    final beforeVolume = _volume(beforeArea, beforeDepth);
    final afterVolume = _volume(afterArea, afterDepth);
    final photos = data['photos'] is List ? data['photos'] as List : const [];
    final beforeImages = _photosByType(photos, 'before');
    final afterImages = _photosByType(photos, 'after');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pothole ${index + 1}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _kGreen,
            ),
          ),
          const SizedBox(height: 8),
          _dimensionLine(
            'Dimension of Original Pothole (Before Digging)',
            beforeArea,
            beforeDepth,
            beforeVolume,
            beforeImages,
          ),
          const SizedBox(height: 6),
          _dimensionLine(
            'Dimension of After Digging Pothole',
            afterArea,
            afterDepth,
            afterVolume,
            afterImages,
          ),
        ],
      ),
    );
  }

  Widget _dimensionLine(
    String label,
    String area,
    String depth,
    String volume,
    List<String> images,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
              ),
              if (images.isNotEmpty)
                InkWell(
                  onTap: () => onOpenImages(images),
                  child: const Text(
                    'View Image',
                    style: TextStyle(
                      color: Color(0xFFE0C341),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFE0C341),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Surface Area: $area m², Average Depth: $depth m, Total Volume: $volume m³',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  static String _text(dynamic value) {
    if (value == null) return '0';
    final text = value.toString().trim();
    return text.isEmpty || text.toLowerCase() == 'null' ? '0' : text;
  }

  static String _volume(String area, String depth) {
    final a = double.tryParse(area) ?? 0;
    final d = double.tryParse(depth) ?? 0;
    return (a * d).toStringAsFixed(2);
  }

  static List<String> _photosByType(List<dynamic> photos, String type) {
    return photos
        .whereType<Map>()
        .where((e) => e['photo_type']?.toString().toLowerCase() == type)
        .map((e) => e['photo_url'])
        .where((e) => e != null && e.toString().trim().isNotEmpty)
        .map((e) => _getImageUrl(e.toString()))
        .toList();
  }
}

class _ImageDialog extends StatefulWidget {
  final List<String> urls;
  const _ImageDialog({required this.urls});

  @override
  State<_ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<_ImageDialog> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final url = widget.urls[_index];
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: _getImageUrl(url),
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (_index > 0)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () => setState(() => _index--),
              ),
            ),
          if (_index < widget.urls.length - 1)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () => setState(() => _index++),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  final double? lat;
  final double? lng;
  const _MapPreview({this.lat, this.lng});

  @override
  Widget build(BuildContext context) {
    if (lat == null || lng == null) {
      return Container(
        height: 100,
        color: _kBg,
        child: const Center(
          child: Text(
            'COORD UNAVAILABLE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    return Container(
      height: 140,
      decoration: BoxDecoration(border: Border.all(color: _kBorder)),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 15,
        ),
        markers: {
          Marker(markerId: const MarkerId('p'), position: LatLng(lat!, lng!)),
        },
        liteModeEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}

class _DimensionItem extends StatelessWidget {
  final int index;
  final dynamic data;
  const _DimensionItem({required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      color: _kBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POTHOLE #${index + 1}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: _kGreen,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _cell('BEFORE AREA', '${data.beforeSurfaceArea ?? 0}m²'),
              _cell('DEPTH', '${data.beforeDepth ?? 0}m'),
              _cell('AFTER AREA', '${data.afterSurfaceArea ?? 0}m²'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(String l, String v) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
        Text(
          v,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _ActionPanel extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionPanel({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 48,
          color: _kGreen,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _DualActionPanel extends StatelessWidget {
  final String label1;
  final VoidCallback onTap1;
  final String label2;
  final VoidCallback onTap2;
  final Color? color2;

  const _DualActionPanel({
    required this.label1,
    required this.onTap1,
    required this.label2,
    required this.onTap2,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap1,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _kGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  label1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onTap2,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: color2 ?? Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  label2,
                  style: TextStyle(
                    color: color2 ?? Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8C300),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}

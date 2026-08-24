import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../data/providers/providers.dart';
import '../../../../data/models/models.dart';
import '../../../../core/constants/api_endpoints.dart';

class VendorFixScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;
  final bool alreadyArrived;
  final bool repairOnly;
  final PotholeModel? report;

  const VendorFixScreen({
    super.key,
    required this.caseId,
    required this.reportId,
    this.alreadyArrived = false,
    this.repairOnly = false,
    this.report,
  });

  @override
  ConsumerState<VendorFixScreen> createState() => _VendorFixScreenState();
}

class _VendorFixScreenState extends ConsumerState<VendorFixScreen> {
  final _remarksController = TextEditingController();
  
  bool _isArriving = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _handleArrival() async {
    setState(() => _isArriving = true);
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      
      await repo.vendorArriveAtLocation(
        caseId: int.parse(widget.caseId),
      );

      if (mounted) {
        setState(() => _isArriving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submitted successfully')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isArriving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_extractError(e))),
        );
      }
    }
  }

  Future<void> _submitFix() async {
    if (_remarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remark is required')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      await repo.vendorConfirmFix(
        potholeId: int.parse(widget.caseId),
        remarks: _remarksController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Repair completed successfully')));
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_extractError(e))),
        );
      }
    }
  }

  String _extractError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'] ?? data['error'];
        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = widget.report?.status.toLowerCase() ?? '';
    final inspection = widget.report?.officerReports?.isNotEmpty ?? false
        ? widget.report!.officerReports!.first
        : null;
    final canSubmit =
        widget.alreadyArrived &&
        status != 'completed' &&
        status != 'rejected' &&
        (widget.repairOnly || _allHaveAfterImages(inspection));
    final screenTitle = !widget.alreadyArrived
        ? 'Assigned Report Details'
        : widget.repairOnly
            ? 'Report Details'
            : 'Final Submission';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(screenTitle,
          style: const TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.report != null) _buildReportDetails(widget.report!),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (!widget.alreadyArrived) 
                    _buildArrivalCard()
                  else ...[
                    if (!widget.repairOnly && inspection != null)
                      _buildInspectionData(inspection)
                    else if (!widget.repairOnly)
                      _buildNoInspectionDetails(),
                    
                    if (canSubmit) ...[
                      const SizedBox(height: 24),
                      _buildFixForm(theme),
                    ] else if (status == 'completed') ...[
                      const SizedBox(height: 32),
                      _buildCompletedBadge(),
                    ] else ...[
                      const SizedBox(height: 24),
                      _buildDisabledSubmitNotice(),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
          const SizedBox(height: 12),
          const Text('WORK COMPLETED', 
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 16)),
          const SizedBox(height: 4),
          Text('This repair report has already been successfully submitted.', 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green[800], fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildReportDetails(PotholeModel report) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailItem('REPORT ID', report.caseId),
              _detailItem('STATUS', report.status.toUpperCase(), 
                color: _getStatusColor(report.status)),
            ],
          ),
          const Divider(height: 32),
          _detailItem('REPORTED ON', 
            report.reportDate != null ? DateFormat('dd MMM yyyy').format(report.reportDate!) : 'N/A'),
          _detailItem('LOCATION', report.location ?? 'N/A'),
          const SizedBox(height: 16),
          _detailItem('DIVISION', report.divisionName ?? 'N/A'),
          if (report.inspectedBy != null) ...[
            const Divider(height: 32),
            Row(
              children: [
                Expanded(child: _detailItem('INSPECTED BY', report.inspectedBy?.name ?? 'N/A')),
                Expanded(child: _detailItem('INSPECTED ON', report.inspectedBy?.date ?? 'N/A')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInspectionData(OfficerReportModel inspection) {
    final potholes = inspection.potholesData ?? [];
    if (potholes.isEmpty) return _buildNoInspectionDetails();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('POTHOLE DETAILS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
            Text('Total: ${potholes.length}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: potholes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final pothole = potholes[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pothole ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.blue, fontSize: 13)),
                  const SizedBox(height: 12),
                  _buildDiggingSection(
                    title: 'Before Digging',
                    surface: pothole.beforeSurfaceArea,
                    depth: pothole.beforeDepth,
                    photos: _photosByType(pothole.photos, 'before'),
                  ),
                  if (_photosByType(pothole.photos, 'after').isNotEmpty) ...[
                    const Divider(height: 24),
                    _buildDiggingSection(
                      title: 'After Digging',
                      surface: pothole.afterSurfaceArea,
                      depth: pothole.afterDepth,
                      photos: _photosByType(pothole.photos, 'after'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoInspectionDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Text(
        'No pothole inspection details available.',
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),
      ),
    );
  }

  Widget _buildDisabledSubmitNotice() {
    return Opacity(
      opacity: 0.55,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: Colors.black54),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Final submit is enabled only after every inspected pothole has an after-digging photo.',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiggingSection({
    required String title,
    required String? surface,
    required String? depth,
    required List<PotholePhoto> photos,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDimensionRow(title, surface, depth),
        if (photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showImageGallery(photos.map(_fullImageUrl).toList()),
            child: Text(
              '$title Image',
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDimensionRow(String title, String? surface, String? depth) {
    double s = double.tryParse(surface ?? '0') ?? 0;
    double d = double.tryParse(depth ?? '0') ?? 0;
    double volume = s * d;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(height: 4),
        Text('Area: ${surface ?? "0"} m², Depth: ${depth ?? "0"} m', 
          style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        Text('Total Volume: ${volume.toStringAsFixed(3)} m³', 
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.blue)),
      ],
    );
  }

  void _showImageGallery(List<String> urls) {
    if (urls.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: _ImagePager(urls: urls),
            ),
            Positioned(
              top: 0, right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _allHaveAfterImages(OfficerReportModel? inspection) {
    final potholes = inspection?.potholesData ?? [];
    if (potholes.isEmpty) return false;

    for (final pothole in potholes) {
      final photos = pothole.photos ?? [];
      final hasBefore = _photosByType(photos, 'before').isNotEmpty;
      final hasAfter = _photosByType(photos, 'after').isNotEmpty;
      if (hasBefore && !hasAfter) return false;
    }
    return true;
  }

  List<PotholePhoto> _photosByType(List<PotholePhoto>? photos, String type) {
    return (photos ?? [])
        .where(
          (p) =>
              p.photoUrl != null &&
              p.photoUrl!.isNotEmpty &&
              p.photoType?.toLowerCase() == type,
        )
        .toList();
  }

  String _fullImageUrl(PotholePhoto photo) {
    final url = photo.photoUrl ?? '';
    if (url.startsWith('http')) return url;
    return '${ApiEndpoints.baseUrlImage}$url';
  }

  Widget _detailItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color ?? Colors.black87)),
      ],
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      case 'rejected': return Colors.red;
      default: return Colors.blue;
    }
  }

  Widget _buildArrivalCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        children: [
          const Icon(Icons.location_on_outlined, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text('At Work Site?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(
            'Please confirm your arrival at the pothole location to start repair work. Note: The case must be inspected by an officer before you can submit the final report.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], height: 1.5, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isArriving ? null : _handleArrival,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            child: _isArriving 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('CONFIRM ARRIVAL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildFixForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ACTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            controller: _remarksController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Remark is required',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitFix,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            backgroundColor: const Color(0xFFF8C300),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: _isSubmitting 
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                widget.repairOnly ? 'REPAIR COMPLETED' : 'FINAL SUBMIT',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
        ),
      ],
    );
  }
}

class _ImagePager extends StatefulWidget {
  final List<String> urls;

  const _ImagePager({required this.urls});

  @override
  State<_ImagePager> createState() => _ImagePagerState();
}

class _ImagePagerState extends State<_ImagePager> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.urls.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.urls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.white, size: 36),
                ),
              );
            },
          ),
          if (_index > 0)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 36),
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),
              ),
            ),
          if (_index < widget.urls.length - 1)
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 36),
                onPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

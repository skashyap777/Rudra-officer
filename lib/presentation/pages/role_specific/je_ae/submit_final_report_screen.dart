import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../data/providers/providers.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/services/location_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import 'package:intl/intl.dart';

class SubmitFinalReportScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;

  const SubmitFinalReportScreen({
    super.key,
    required this.caseId,
    required this.reportId,
  });

  @override
  ConsumerState<SubmitFinalReportScreen> createState() => _SubmitFinalReportScreenState();
}

class _SubmitFinalReportScreenState extends ConsumerState<SubmitFinalReportScreen> {
  final _remarksController = TextEditingController();
  final _materialController = TextEditingController();
  final List<File> _images = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _remarksController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  String _getImageUrl(String url) {
    if (url.startsWith('http')) return url;
    final clean = url.startsWith('/') ? url.substring(1) : url;
    return '${ApiEndpoints.baseUrl}$clean';
  }

  Future<void> _pickImage() async {
    final locationService = LocationService();
    // 1. Check if location services are enabled
    final serviceEnabled = await locationService.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services (GPS) on your phone')),
        );
      }
      return;
    }

    // 2. Check and request permission
    final permission = await locationService.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text('Camera capture requires location (GPS) permissions to tag images. Please enable it in app settings.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  locationService.openAppSettings();
                },
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // 3. Show a loading dialog while obtaining high-accuracy location coordinates
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Obtaining precise GPS location...'),
              ],
            ),
          ),
        ),
      );
    }

    // 4. Get high-accuracy position
    final position = await locationService.getCurrentPosition();
    if (mounted) Navigator.pop(context); // Close location loading dialog

    if (position == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to obtain high-accuracy GPS coordinates. Please ensure you have a clear sky view.')),
        );
      }
      return;
    }

    // 5. Trigger Camera (Without scaling inside pickImage to prevent scaled_ file path deletion bugs)
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      try {
        // Copy the ephemeral image file to our secure Application Documents directory
        // to guarantee it remains persistent and never gets garbage-collected/deleted.
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'after_fix_${widget.caseId}_${DateTime.now().millisecondsSinceEpoch}_${_images.length}.jpg';
        final targetPath = '${appDir.path}/$fileName';
        final savedFile = await File(image.path).copy(targetPath);

        setState(() => _images.add(savedFile));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image captured and saved securely at GPS: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to persist captured image file: $e')),
          );
        }
      }
    }
  }

  Future<void> _submitReport() async {
    if (_remarksController.text.trim().isEmpty || _materialController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remarks and material consumption are required')));
      return;
    }

    // Final safety check to make sure all files exist on disk before sending
    for (final img in _images) {
      if (!await img.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Captured image file could not be found at path: ${img.path}')),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);
    try {
      final user = ref.read(currentUserProvider);
      final role = user?.userType.toLowerCase() ?? 'je';
      
      final repo = await ref.read(reportRepositoryProvider.future);
      await repo.submitFinalReportJeAe(
        role: role,
        caseId: widget.caseId,
        fieldNote: _remarksController.text.trim(),
        materialConsumption: _materialController.text.trim(),
        images: _images,
      );

      // Clean up our copied local images to free up sandbox disk space
      for (final img in _images) {
        try {
          if (await img.exists()) {
            await img.delete();
          }
        } catch (_) {}
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Final report submitted successfully')));
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caseDetailAsync = ref.watch(caseDetailProvider(widget.caseId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Submit Final Report', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: caseDetailAsync.when(
        data: (pothole) {
          final officerReport = pothole.officerReports?.firstOrNull;
          final potholes = officerReport?.potholesData ?? [];
          final requiredImages = potholes.isNotEmpty ? potholes.length * 2 : 2;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── CASE DETAILS ─────────────────────────────────────────────
                _buildCaseDetails(pothole),
                const SizedBox(height: 24),

                // ── POTHOLE DETAILS SECTION ──────────────────────────────────
                if (potholes.isNotEmpty) ...[
                  const Text('POTHOLE DETAIL METRICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: potholes.length,
                    itemBuilder: (context, index) {
                      final pItem = potholes[index];
                      final beforeArea = pItem.beforeSurfaceArea ?? '0';
                      final beforeDepth = pItem.beforeDepth ?? '0';
                      final beforeVolume = (double.parse(beforeArea) * double.parse(beforeDepth)).toStringAsFixed(2);
                      final photos = pItem.photos ?? [];
                      final beforeImages = photos
                          .where((ph) => ph.photoType?.toLowerCase() == 'before')
                          .map((ph) => ph.photoUrl)
                          .whereType<String>()
                          .toList();

                      final afterArea = pItem.afterSurfaceArea ?? '0';
                      final afterDepth = pItem.afterDepth ?? '0';
                      final afterVolume = (double.parse(afterArea) * double.parse(afterDepth)).toStringAsFixed(2);
                      
                      final afterImages = photos
                          .where((ph) => ph.photoType?.toLowerCase() == 'after')
                          .map((ph) => ph.photoUrl)
                          .whereType<String>()
                          .toList();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pothole ${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF3D9A7E)),
                                ),
                                if (beforeImages.isNotEmpty)
                                  InkWell(
                                    onTap: () => _showImageDialog(beforeImages.first),
                                    child: const Text(
                                      'View Before Image',
                                      style: TextStyle(
                                        color: Color(0xFF3D9A7E),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('Before Digging', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(
                              'Surface Area: $beforeArea m², Average Depth: $beforeDepth m, Total Volume: $beforeVolume m³',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                            ),
                            
                            if (afterArea != '0' || afterDepth != '0') ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(height: 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('After Digging', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey)),
                                  if (afterImages.isNotEmpty)
                                    InkWell(
                                      onTap: () => _showImageDialog(afterImages.first),
                                      child: const Text(
                                        'View After Image',
                                        style: TextStyle(
                                          color: Color(0xFF3D9A7E),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Surface Area: $afterArea m², Average Depth: $afterDepth m, Total Volume: $afterVolume m³',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // ── AFTER REPAIR EVIDENCE ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('AFTER REPAIR EVIDENCE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                    Text(
                      'REQUIRED: $requiredImages',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: _images.length == requiredImages ? const Color(0xFF3D9A7E) : Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Capture exactly 2 post-repair photos for each of the ${potholes.isEmpty ? 1 : potholes.length} potholes.',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                _buildPhotoGrid(requiredImages),
                const SizedBox(height: 32),

                const Text('MATERIAL CONSUMPTION (KG)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                  child: TextField(
                    controller: _materialController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'E.g. 500',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text('FIELD REMARKS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                  child: TextField(
                    controller: _remarksController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter field observations...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                ElevatedButton(
                  onPressed: (_isSubmitting || _images.length != requiredImages) ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    backgroundColor: const Color(0xFFF8C300),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('SUBMIT FINAL REPORT (${_images.length} / $requiredImages)', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error loading case details: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
      )),
    );
  }

  Widget _buildPhotoGrid(int requiredImages) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _images.length < requiredImages ? _images.length + 1 : requiredImages,
      itemBuilder: (context, index) {
        if (index == _images.length && _images.length < requiredImages) {
          return GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blue[100]!)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: Colors.blue, size: 32),
                  SizedBox(height: 8),
                  Text('Capture', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 12)),
                ],
              ),
            ),
          );
        }
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(_images[index], width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            ),
            Positioned(
              right: 8, top: 8,
              child: GestureDetector(
                onTap: () => setState(() => _images.removeAt(index)),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: _getImageUrl(imageUrl),
                placeholder: (_, __) => const SizedBox(height: 300, child: Center(child: CircularProgressIndicator())),
                errorWidget: (_, __, ___) => const SizedBox(height: 300, child: Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey))),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, shadows: [Shadow(blurRadius: 4, color: Colors.black87)]),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCaseDetails(PotholeModel pothole) {
    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('REPORT DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
              Text('#${pothole.caseId}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF3D9A7E))),
            ],
          ),
          const SizedBox(height: 16),
          _detailRow('Division', pothole.divisionName ?? 'N/A'),
          _detailRow('Date Assigned', formatDate(pothole.assignedDate)),
          _detailRow('Citizen Remarks', pothole.remarks ?? pothole.reportedBy?.remark ?? 'N/A'),
          _detailRow('Assigned By', pothole.assignedBy ?? 'N/A'),
          _detailRow('Inspected By', pothole.inspectedBy?.name ?? 'N/A'),
          _detailRow('Inspected On', pothole.inspectedBy?.date ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }
}

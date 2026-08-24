import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/providers/providers.dart';
import '../../../../data/services/location_service.dart';

/// Data model for a single pothole's dimension + images (mirrors Java's potholeJson)
class _PotholeData {
  // Before digging
  String beforeSurface = '';
  String beforeDepth = '';
  List<_ImageData> beforeImages = [];

  // After digging (optional)
  String afterSurface = '';
  String afterDepth = '';
  List<_ImageData> afterImages = [];

  bool get hasAfterContent =>
      afterSurface.isNotEmpty ||
      afterDepth.isNotEmpty ||
      afterImages.isNotEmpty;
}

class _ImageData {
  final File file;
  final double latitude;
  final double longitude;
  _ImageData({required this.file, required this.latitude, required this.longitude});
}

class FieldInspectionScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;

  const FieldInspectionScreen({
    super.key,
    required this.caseId,
    required this.reportId,
  });

  @override
  ConsumerState<FieldInspectionScreen> createState() => _FieldInspectionScreenState();
}

class _FieldInspectionScreenState extends ConsumerState<FieldInspectionScreen> {
  final _remarksController = TextEditingController();
  final _materialController = TextEditingController();
  bool _isLoading = false;

  // Pothole list (matches Java's potholeArray)
  final List<_PotholeData> _potholes = [];

  String _selectedMaterial = 'Bitumen';
  final List<String> _materials = ['Bitumen', 'Cold Mix', 'Ready Mix Concrete', 'WMM', 'Others'];

  @override
  void dispose() {
    _remarksController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  // ── Bottom Sheet Dialog (matches Java openPotholeDialog) ──

  void _openPotholeDialog({_PotholeData? existing, int editIndex = -1}) {
    final isEdit = existing != null;
    final data = existing ?? _PotholeData();

    final surfBefCtrl = TextEditingController(text: data.beforeSurface);
    final depthBefCtrl = TextEditingController(text: data.beforeDepth);
    final surfAftCtrl = TextEditingController(text: data.afterSurface);
    final depthAftCtrl = TextEditingController(text: data.afterDepth);

    List<_ImageData> beforeImgs = List.from(data.beforeImages);
    List<_ImageData> afterImgs = List.from(data.afterImages);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            // Validation (matches Java validateSaveButton)
            bool hasTwoBefore = beforeImgs.length >= 2;
            bool hasTwoAfter = afterImgs.length >= 2;
            bool beforeFilled = surfBefCtrl.text.trim().isNotEmpty && depthBefCtrl.text.trim().isNotEmpty;
            bool afterFilled = surfAftCtrl.text.trim().isNotEmpty && depthAftCtrl.text.trim().isNotEmpty;
            bool afterEmpty = surfAftCtrl.text.trim().isEmpty && depthAftCtrl.text.trim().isEmpty;

            // CASE 1: Only before | CASE 2: Before + After
            bool canSave = (hasTwoBefore && beforeFilled && afterImgs.isEmpty && afterEmpty) ||
                (hasTwoBefore && hasTwoAfter && beforeFilled && afterFilled);

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // ── BEFORE DIGGING ──
                    _sheetSectionLabel('Dimension of Original Pothole (Before Digging)', true),
                    const SizedBox(height: 4),
                    Text('2 images required', style: TextStyle(fontSize: 12, color: Colors.red[400])),
                    const SizedBox(height: 10),
                    _buildUploadRow(beforeImgs, 'before', setSheetState),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _sheetField(surfBefCtrl, 'Surface Area', 'cm²', setSheetState)),
                      const SizedBox(width: 12),
                      Expanded(child: _sheetField(depthBefCtrl, 'Average Depth', 'cm', setSheetState)),
                    ]),

                    const SizedBox(height: 28),

                    // ── AFTER DIGGING ──
                    _sheetSectionLabel('Dimension of After Digging Pothole', true),
                    const SizedBox(height: 4),
                    Text('2 images required', style: TextStyle(fontSize: 12, color: Colors.red[400])),
                    const SizedBox(height: 10),
                    _buildUploadRow(afterImgs, 'after', setSheetState, requireBefore: beforeImgs),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: _sheetField(surfAftCtrl, 'Surface Area', 'cm²', setSheetState)),
                      const SizedBox(width: 12),
                      Expanded(child: _sheetField(depthAftCtrl, 'Average Depth', 'cm', setSheetState)),
                    ]),

                    const SizedBox(height: 28),

                    // ── Save Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: canSave
                            ? () {
                                data.beforeSurface = surfBefCtrl.text.trim();
                                data.beforeDepth = depthBefCtrl.text.trim();
                                data.beforeImages = beforeImgs;
                                data.afterSurface = surfAftCtrl.text.trim();
                                data.afterDepth = depthAftCtrl.text.trim();
                                data.afterImages = afterImgs;

                                setState(() {
                                  if (isEdit) {
                                    _potholes[editIndex] = data;
                                  } else {
                                    _potholes.add(data);
                                  }
                                });
                                Navigator.pop(ctx);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          disabledBackgroundColor: const Color(0xFFFFC107).withValues(alpha: 0.3),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sheetSectionLabel(String text, bool required) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        children: required ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red))] : [],
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String label, String suffix, StateSetter setSheetState) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setSheetState(() {}),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildUploadRow(List<_ImageData> images, String type, StateSetter setSheetState, {List<_ImageData>? requireBefore}) {
    return Column(
      children: [
        if (images.isNotEmpty)
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(images[i].file, width: 72, height: 72, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 2, top: 2,
                    child: GestureDetector(
                      onTap: () => setSheetState(() => images.removeAt(i)),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (images.isNotEmpty) const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            if (requireBefore != null && requireBefore.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please upload image of before digging pothole first')),
              );
              return;
            }
            if (images.length >= 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Can't upload more than 2 images")),
              );
              return;
            }
            final picker = ImagePicker();
            final img = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
            if (img == null) return;

            // Get GPS location (matches Java's GPSTracker)
            double lat = 0, lng = 0;
            try {
              final pos = await LocationService().getCurrentPosition();
              if (pos != null) {
                lat = pos.latitude;
                lng = pos.longitude;
              }
            } catch (_) {}

            setSheetState(() {
              images.add(_ImageData(file: File(img.path), latitude: lat, longitude: lng));
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[50],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_rounded, size: 20, color: Colors.teal[700]),
                const SizedBox(width: 8),
                Text('Upload Image', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal[800])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Submit (matches Java's saveDetCard click → sendPotholeData) ──

  Future<void> _submit() async {
    if (_potholes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add Dimension')),
      );
      return;
    }
    if (_remarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter inspection remarks')),
      );
      return;
    }

    // Show confirmation dialog (matches Java's final_submit_layout)
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: Text('Report ID: ${widget.reportId}\n\nAre you sure you want to submit this inspection?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final repo = await ref.read(reportRepositoryProvider.future);

      // Build structured pothole data (matches Java's resultArray + image arrays)
      final List<Map<String, dynamic>> potholesPayload = [];
      final List<File> allFiles = [];
      final List<String> photoTypes = [];
      final List<int> photoIndexes = [];
      final List<double> photoLats = [];
      final List<double> photoLngs = [];

      for (int i = 0; i < _potholes.length; i++) {
        final p = _potholes[i];
        final potholeObj = <String, dynamic>{
          'pothole_index': i,
          'before_surface_area': double.tryParse(p.beforeSurface) ?? 0,
          'before_depth': double.tryParse(p.beforeDepth) ?? 0,
        };

        // Before images
        for (final img in p.beforeImages) {
          allFiles.add(img.file);
          photoTypes.add('before');
          photoIndexes.add(i);
          photoLats.add(img.latitude);
          photoLngs.add(img.longitude);
        }

        // After digging (optional — matches Java: if inputObj.has("after_digging"))
        if (p.hasAfterContent) {
          potholeObj['after_surface_area'] = double.tryParse(p.afterSurface) ?? 0;
          potholeObj['after_depth'] = double.tryParse(p.afterDepth) ?? 0;

          for (final img in p.afterImages) {
            allFiles.add(img.file);
            photoTypes.add('after');
            photoIndexes.add(i);
            photoLats.add(img.latitude);
            photoLngs.add(img.longitude);
          }
        }

        potholesPayload.add(potholeObj);
      }

      await repo.submitFieldInspectionJeAe(
        potholeId: int.parse(widget.caseId),
        remarks: _remarksController.text.trim(),
        material: _selectedMaterial == 'Others' ? _materialController.text : _selectedMaterial,
        images: allFiles,
        potholes: potholesPayload,
        photoTypes: photoTypes,
        photoIndexes: photoIndexes,
        photoLatitudes: photoLats,
        photoLongitudes: photoLngs,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved as draft')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Main Screen Build ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Inspect Report', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Potholes Tracked
                  Text(
                    'Total Potholes Tracked: ${_potholes.length}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Update Dimension and Images *',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'Record the approximate size of the pothole.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Pothole Cards
                  ..._potholes.asMap().entries.map((e) => _buildPotholeCard(e.key, e.value)),

                  // Add Dimension Button
                  if (_potholes.length < 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: OutlinedButton.icon(
                        onPressed: () => _openPotholeDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Dimension'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                  const Divider(height: 32),

                  // Material
                  _sectionHeader('REPAIR PLAN'),
                  const SizedBox(height: 8),
                  _buildMaterialDropdown(),
                  if (_selectedMaterial == 'Others') ...[
                    const SizedBox(height: 8),
                    _inputField(_materialController, 'Specify Material', TextInputType.text),
                  ],

                  const SizedBox(height: 24),
                  _sectionHeader('REMARKS *'),
                  const SizedBox(height: 8),
                  _inputField(_remarksController, 'Detailed inspection report...', TextInputType.multiline, maxLines: 4),

                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: const Color(0xFFFFC107),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),
    );
  }

  Widget _buildPotholeCard(int index, _PotholeData p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Pothole ${index + 1}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.purple[700])),
              const Spacer(),
              // Edit
              InkWell(
                onTap: () => _openPotholeDialog(existing: p, editIndex: index),
                child: Row(children: [
                  Icon(Icons.edit, size: 14, color: Colors.teal[700]),
                  const SizedBox(width: 4),
                  Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.teal[700])),
                ]),
              ),
              const SizedBox(width: 16),
              // Delete
              InkWell(
                onTap: () => _confirmDelete(index),
                child: Row(children: [
                  Icon(Icons.delete_outline, size: 14, color: Colors.red[400]),
                  const SizedBox(width: 4),
                  Text('Delete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red[400])),
                ]),
              ),
            ],
          ),
          const Divider(height: 16),
          // Before Digging info
          Row(
            children: [
              const Expanded(
                child: Text('Dimension of Original Pothole\n(Before Digging)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              Text('View Image', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.teal[700], decoration: TextDecoration.underline)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Surface Area: ${p.beforeSurface} cm², Average Depth: ${p.beforeDepth} cm',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          // After Digging info
          Row(
            children: [
              const Expanded(
                child: Text('Dimension of After Digging\nPothole', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              if (p.hasAfterContent)
                Text('View Image', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.teal[700], decoration: TextDecoration.underline))
              else
                Text('Update', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.orange[700])),
            ],
          ),
          if (p.hasAfterContent)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Surface Area: ${p.afterSurface} cm², Average Depth: ${p.afterDepth} cm',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Pothole'),
        content: const Text('Are you sure you want to delete this pothole dimension?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _potholes.removeAt(index));
            },
            child: Text('Delete', style: TextStyle(color: Colors.red[600])),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1));
  }

  Widget _inputField(TextEditingController ctrl, String hint, TextInputType type, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildMaterialDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMaterial,
          isExpanded: true,
          items: _materials.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: (val) => setState(() => _selectedMaterial = val!),
        ),
      ),
    );
  }
}

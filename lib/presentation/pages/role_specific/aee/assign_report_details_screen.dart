import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/providers.dart';

const _green = Color(0xFF4A9079);
const _yellow = Color(0xFFECA311);
const _red = Color(0xFFE53935);
const _bg = Color(0xFFF5F5F5);
const _line = Color(0xFFE0E0E0);

class AssignReportDetailsScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;

  const AssignReportDetailsScreen({
    super.key,
    required this.caseId,
    required this.reportId,
  });

  @override
  ConsumerState<AssignReportDetailsScreen> createState() => _AssignReportDetailsScreenState();
}

class _AssignReportDetailsScreenState extends ConsumerState<AssignReportDetailsScreen> {
  bool _isLoading = true;
  bool _summaryExpanded = true;
  bool _actionExpanded = true;
  bool _selfAssign = false;
  bool _transfer = false;
  bool _isSubmitting = false;

  PotholeModel? _pothole;
  Map<String, dynamic>? _caseData;
  List<UserModel> _divisionUsers = [];
  UserModel? _selectedFieldEngineer;
  UserModel? _selectedAee;

  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      final results = await Future.wait<dynamic>([
        repository.getCaseDetails(widget.caseId),
        repository.getUsersInDivision('je_ae'),
        repository.getUsersInDivision('aee'),
      ]);

      if (!mounted) return;
      final fieldEngineers = results[1] as List<UserModel>;
      final aees = results[2] as List<UserModel>;
      setState(() {
        _pothole = results[0] as PotholeModel;
        _caseData = repository.lastCaseDetailsData;
        _divisionUsers = [...fieldEngineers, ...aees];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${_extractErrorMessage(e)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: _appBar(),
        body: SafeArea(child: const Center(child: LoadingIndicator())),
      );
    }

    if (_pothole == null) {
      return Scaffold(
        appBar: _appBar(),
        body: SafeArea(child: const Center(child: Text('Failed to load case details'))),
      );
    }

    return Scaffold(
      backgroundColor: _bg,
      appBar: _appBar(),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _PanelCard(
              title: 'Report Summary',
              expanded: _summaryExpanded,
              onToggle: () => setState(() => _summaryExpanded = !_summaryExpanded),
              child: _buildReportSummary(),
            ),
            const SizedBox(height: 8),
            _PanelCard(
              title: 'Action Panel',
              expanded: _actionExpanded,
              onToggle: () => setState(() => _actionExpanded = !_actionExpanded),
              child: _buildActionPanel(),
            ),
          ],
        ),
      )),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Assign Report Details',
        style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white),
      ),
      backgroundColor: const Color(0xFF3D9A7E),
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildReportSummary() {
    final p = _pothole!;
    final images = p.potholeImages ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: _line),
        const SizedBox(height: 10),
        _summaryRow('Report ID', p.caseId),
        _summaryRow('Date Reported', _formatDate(p.reportDate ?? p.createdAt)),
        _summaryRow('Date Assigned', _formatDate(p.assignedDate)),
        _summaryRow('Assigned By', p.assignedBy ?? '---'),
        _summaryRow('Division/Zone', p.divisionName ?? p.division ?? '---'),
        _summaryRowLink(
          'Images',
          images.isNotEmpty ? 'View image' : 'No image',
          images.isNotEmpty ? () => _showImage(images.first.photoUrl ?? '') : null,
        ),
        _summaryRowLocation(p),
        _summaryRow('Location Accuracy', _accuracyText(p)),
        const SizedBox(height: 10),
        _summaryBlock('Remarks from Citizen', p.remarks ?? p.reportedBy?.remark ?? '---'),
        const SizedBox(height: 10),
        _summaryBlock('Remarks from Executive Engineer', _eeRemarkText()),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: _line),
        const SizedBox(height: 5),
        _checkboxRow(
          value: _transfer,
          label: 'Transfer this case to another officer',
          onChanged: (value) {
            setState(() {
              _transfer = value;
              if (_transfer) {
                _selfAssign = false;
                _selectedFieldEngineer = null;
              } else {
                _selectedAee = null;
              }
            });
          },
        ),
        if (_transfer) ...[
          _label('Assign to Assistant Executive Engineer', required: true),
                _selectorField(
                  hint: 'Select Assistant Executive Engineer',
                  value: _selectedAee == null ? null : _userLabel(_selectedAee!),
                  onTap: () => _openUserBottomSheet(
                    title: 'Assistant Executive Engineer',
                    users: _divisionUsers.where((u) => u.isAEE).toList(),
                    selectedUser: _selectedAee,
                    onSelected: (user) => setState(() => _selectedAee = user),
                  ),
                ),
        ],
        Opacity(
          opacity: (_selfAssign || _transfer) ? 0.3 : 1,
          child: IgnorePointer(
            ignoring: _selfAssign || _transfer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Assign to Field Engineer', required: true),
                _selectorField(
                  hint: 'Select Field Engineer',
                  value: _selectedFieldEngineer == null ? null : _userLabel(_selectedFieldEngineer!),
                  onTap: () => _openUserBottomSheet(
                    title: 'Field Engineer',
                    users: _divisionUsers.where((u) => u.isFieldEngineer).toList(),
                    selectedUser: _selectedFieldEngineer,
                    groupFieldEngineers: true,
                    onSelected: (user) => setState(() => _selectedFieldEngineer = user),
                  ),
                ),
              ],
            ),
          ),
        ),
        _checkboxRow(
          value: _selfAssign,
          label: 'Self-Assign this Report (I will inspect it myself)',
          onChanged: (value) {
            setState(() {
              _selfAssign = value;
              if (_selfAssign) {
                _transfer = false;
                _selectedAee = null;
                _selectedFieldEngineer = null;
              }
            });
          },
        ),
        _label('Date', required: true),
        Container(
          width: double.infinity,
          height: 44,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9E9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(DateFormat('dd/MM/yyyy').format(DateTime.now()), style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(height: 10),
        const Text('Remarks', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
        const SizedBox(height: 5),
        TextField(
          controller: _remarkController,
          maxLines: 4,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: _line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: _line)),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: _actionButton('Reject Assignment', _red, _showRejectDialog),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionButton('Confirm Assignment', _yellow, _isSubmitting ? null : _submitAssignment),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '---' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRowLink(String label, String value, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: onTap == null ? Colors.black : _yellow,
                  decoration: onTap == null ? TextDecoration.none : TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRowLocation(PotholeModel p) {
    final lat = p.latitude ?? p.potholeImages?.firstOrNull?.latitude;
    final lng = p.longitude ?? p.potholeImages?.firstOrNull?.longitude;
    final hasMap = lat != null && lng != null;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(
                  p.location ?? p.address ?? p.roadName ?? '---',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                if (hasMap)
                  InkWell(
                    onTap: () => launchUrl(Uri.parse('https://maps.google.com/?q=$lat,$lng')),
                    child: const Text(
                      ' (+ Map View)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _yellow,
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
  }

  Widget _summaryBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value.isEmpty ? '---' : value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black)),
      ],
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
          if (required) const Text(' *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _red)),
        ],
      ),
    );
  }

  Widget _checkboxRow({
    required bool value,
    required String label,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Checkbox(value: value, activeColor: _green, onChanged: (v) => onChanged(v ?? false)),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black))),
          ],
        ),
      ),
    );
  }

  Widget _selectorField({
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: value == null ? Colors.grey : Colors.black),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Future<void> _openUserBottomSheet({
    required String title,
    required List<UserModel> users,
    required UserModel? selectedUser,
    required ValueChanged<UserModel> onSelected,
    bool groupFieldEngineers = false,
  }) async {
    if (users.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, no $title is available in this division.')),
      );
      return;
    }

    UserModel? pendingSelection = selectedUser;
    final selected = await showModalBottomSheet<UserModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final aeUsers = users.where((u) => u.isAE).toList();
            final jeUsers = users.where((u) => u.isJE).toList();
            return SafeArea(
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.82),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 64, height: 3, margin: const EdgeInsets.only(top: 10), color: const Color(0xFFD9D9D9)),
                    ),
                    const SizedBox(height: 30),
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black)),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: _line),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: groupFieldEngineers
                              ? [
                                  if (aeUsers.isNotEmpty) ..._userSection('Assistant Engineer', aeUsers, pendingSelection, setSheetState, (u) => pendingSelection = u),
                                  if (jeUsers.isNotEmpty) ..._userSection('Junior Engineer', jeUsers, pendingSelection, setSheetState, (u) => pendingSelection = u),
                                ]
                              : users.map((u) => _userTile(u, pendingSelection, setSheetState, (user) => pendingSelection = user)).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _sheetButton('Cancel', const Color(0xFFD9D9D9), Colors.black, () => Navigator.pop(context)),
                        const SizedBox(width: 15),
                        Opacity(
                          opacity: pendingSelection == null ? 0.3 : 1,
                          child: _sheetButton(
                            'Submit',
                            _yellow,
                            Colors.white,
                            pendingSelection == null ? null : () => Navigator.pop(context, pendingSelection),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) onSelected(selected);
  }

  List<Widget> _userSection(
    String title,
    List<UserModel> users,
    UserModel? selected,
    StateSetter setSheetState,
    ValueChanged<UserModel> setPending,
  ) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 5, 16, 16),
        child: Divider(height: 2, color: _line),
      ),
      ...users.map((u) => _userTile(u, selected, setSheetState, setPending)),
    ];
  }

  Widget _userTile(
    UserModel user,
    UserModel? selected,
    StateSetter setSheetState,
    ValueChanged<UserModel> setPending,
  ) {
    final checked = selected?.id == user.id;
    final imageUrl = user.profilePhotoLink == null ? null : _imageUrl(user.profilePhotoLink!);
    return InkWell(
      onTap: () => setSheetState(() => setPending(user)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE9E9E9),
              backgroundImage: imageUrl == null ? null : CachedNetworkImageProvider(imageUrl),
              child: imageUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_userLabel(user), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
                  const SizedBox(height: 3),
                  Text(user.divisionName ?? '---', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            _radioMark(
              selected: checked,
              onTap: () => setSheetState(() => setPending(user)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioMark({required bool selected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selected ? _green : Colors.grey, width: 2),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: _green),
                ),
              )
            : null,
      ),
    );
  }

  Widget _sheetButton(String label, Color bg, Color fg, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
        child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: fg)),
      ),
    );
  }

  String _userLabel(UserModel user) => '${user.name} (${user.userType.toUpperCase()})';

  Widget _actionButton(String label, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: onTap == null ? color.withValues(alpha: 0.55) : color, borderRadius: BorderRadius.circular(6)),
        child: _isSubmitting && label == 'Confirm Assignment'
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _submitAssignment() async {
    if (!_selfAssign && !_transfer && _selectedFieldEngineer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Field Engineer or Self Assign or Transfer')),
      );
      return;
    }
    if (_transfer && _selectedAee == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an Assistant Executive Engineer')));
      return;
    }
    if (_transfer && _remarkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remark is required')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      final caseId = int.parse(widget.caseId);
      final remark = _remarkController.text.trim();

      if (_selfAssign) {
        await repository.assignToSelfAee(caseId: caseId, remark: remark);
      } else if (_transfer) {
        await repository.transferToAee(caseId: caseId, aeeId: _selectedAee!.id, remark: remark);
      } else {
        await repository.assignToFieldEng(
          caseId: caseId,
          engineerId: _selectedFieldEngineer!.id,
          engineerType: _selectedFieldEngineer!.userType,
          remark: remark,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action completed successfully')));
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${_extractErrorMessage(e)}')));
    }
  }

  Future<void> _showRejectDialog() async {
    final repository = await ref.read(reportRepositoryProvider.future);
    final reasons = await repository.getRejectReasons();
    if (!mounted) return;

    int? selectedReasonId;
    final otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isOthers = reasons.any((r) => r['id'] == selectedReasonId && r['reason'].toString().contains('Others'));
            return AlertDialog(
              title: const Text('Reject Assignment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...reasons.map(
                      (r) => InkWell(
                        onTap: () => setDialogState(() => selectedReasonId = r['id'] as int),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              _radioMark(
                                selected: selectedReasonId == r['id'],
                                onTap: () => setDialogState(() => selectedReasonId = r['id'] as int),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(r['reason'].toString())),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isOthers)
                      TextField(
                        controller: otherReasonController,
                        decoration: const InputDecoration(labelText: 'Specify Reason'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: selectedReasonId == null
                      ? null
                      : () async {
                          try {
                            await repository.rejectCaseAee(
                              caseId: int.parse(widget.caseId),
                              rejectMasterIds: [selectedReasonId!],
                              otherReason: otherReasonController.text,
                            );
                            if (!context.mounted) return;
                            context.pop();
                            context.pop(true);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${_extractErrorMessage(e)}')));
                          }
                        },
                  child: const Text('Reject'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImage(String url) {
    final imageUrl = _imageUrl(url);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _imageUrl(String url) {
    if (url.startsWith('http')) return url;
    return '${ApiEndpoints.baseUrlImage}${url.startsWith('/') ? url : '/$url'}';
  }

  String _accuracyText(PotholeModel p) {
    final accuracy = p.accuracy ?? p.potholeImages?.firstOrNull?.accuracy;
    if (accuracy == null) return '---';
    return '$accuracy m';
  }

  String _eeRemarkText() {
    final data = _caseData;
    if (data == null) return '---';
    final value = data['ee_remark'];
    if (value == null || value.toString().trim().isEmpty || value.toString() == 'null') {
      return '---';
    }
    return value.toString();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '---';
    return DateFormat('yyyy-MM-dd, hh:mm a').format(date);
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) return data['message'].toString();
      if (data is Map && data['errors'] != null) return data['errors'].toString();
      return error.message ?? 'Request failed';
    }
    return error.toString();
  }
}

class _PanelCard extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const _PanelCard({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            InkWell(
              onTap: onToggle,
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: _yellow, size: 28),
                ],
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 10),
              child,
            ],
          ],
        ),
      ),
    );
  }
}

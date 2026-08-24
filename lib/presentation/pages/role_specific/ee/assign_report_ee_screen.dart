import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';

class AssignReportEeScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;

  const AssignReportEeScreen({
    super.key,
    required this.caseId,
    required this.reportId,
  });

  @override
  ConsumerState<AssignReportEeScreen> createState() => _AssignReportEeScreenState();
}

class _AssignReportEeScreenState extends ConsumerState<AssignReportEeScreen> {
  bool _isLoading = true;
  PotholeModel? _pothole;
  List<UserModel> _divisionUsers = [];
  UserModel? _selectedAee;
  final TextEditingController _remarkController = TextEditingController();
  bool _isSubmitting = false;

  bool _isSummaryExpanded = true;
  bool _isActionPanelExpanded = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      final results = await Future.wait<dynamic>([
        repository.getCaseDetails(widget.caseId),
        repository.getUsersInDivision('aee'),
      ]);

      if (mounted) {
        setState(() {
          _pothole = results[0] as PotholeModel;
          _divisionUsers = results[1] as List<UserModel>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return 'N/A';
    try {
      if (dateString is int) {
        final date = DateTime.fromMillisecondsSinceEpoch(dateString * 1000);
        return DateFormat('yyyy-MM-dd, hh:mm a').format(date);
      }
      final date = DateTime.parse(dateString.toString());
      return DateFormat('yyyy-MM-dd, hh:mm a').format(date);
    } catch (e) {
      return dateString.toString();
    }
  }

  String _getImageUrl(String url) {
    if (url.startsWith('http')) return url;
    final cleanUrl = url.startsWith('/') ? url.substring(1) : url;
    return '${ApiEndpoints.baseUrl}$cleanUrl';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
        body: SafeArea(child: const Center(child: LoadingIndicator())),
      );
    }

    if (_pothole == null) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
        body: SafeArea(child: const Center(child: Text('Failed to load case details'))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildReportSummary(),
            const SizedBox(height: 12),
            _buildActionPanel(),
          ],
        ),
      )),
    );
  }

  Widget _buildReportSummary() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isSummaryExpanded,
          onExpansionChanged: (v) => setState(() => _isSummaryExpanded = v),
          title: const Text(
            'Report Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          iconColor: const Color(0xFFECA311),
          collapsedIconColor: const Color(0xFFECA311),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(color: Color(0xFFE0E0E0), thickness: 1),
            const SizedBox(height: 12),
            _buildDetailRow('Report ID', _pothole!.caseId, isBold: true),
            _buildDetailRow('Date Reported', _formatDate(_pothole!.reportDate), isBold: true),
            _buildDetailRow('Reported By', '${_pothole!.reportedBy?.name ?? 'Unknown'} (${_pothole!.reportedBy?.designation ?? 'Citizen'})', isBold: true),
            _buildDetailRow('Division/Zone', _pothole!.division ?? 'N/A', isBold: true),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 2, child: Text('Images', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.normal))),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        if (_pothole!.imageUrls != null && _pothole!.imageUrls!.isNotEmpty) {
                          _showFullImage(_pothole!.imageUrls!.first);
                        }
                      },
                      child: const Text(
                        'View image',
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 13, color: Color(0xFFECA311), decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 2, child: Text('Location', style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.normal))),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _pothole!.address ?? '',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_pothole!.latitude != null && _pothole!.longitude != null) {
                              launchUrl(Uri.parse('https://maps.google.com/?q=${_pothole!.latitude},${_pothole!.longitude}'));
                            }
                          },
                          child: const Text(
                            ' (+ Map View)',
                            style: TextStyle(fontSize: 13, color: Color(0xFFECA311), decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_pothole!.accuracy != null)
              _buildDetailRow('Location Accuracy', '±${_pothole!.accuracy} m', isBold: true),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: const Text('Remarks from Citizen', style: TextStyle(fontSize: 13, color: Colors.black54)),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                _pothole!.remarks?.isNotEmpty == true ? _pothole!.remarks! : 'No remarks',
                style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.normal)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: isBold ? FontWeight.w600 : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isActionPanelExpanded,
          onExpansionChanged: (v) => setState(() => _isActionPanelExpanded = v),
          title: const Text(
            'Action Panel',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          iconColor: const Color(0xFFECA311),
          collapsedIconColor: const Color(0xFFECA311),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const Divider(color: Color(0xFFE0E0E0), thickness: 1),
            const SizedBox(height: 16),
            
            // AEE Dropdown
            const Row(
              children: [
                Text('Refer to Assistant Executive Engineer ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                Text('*', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UserModel>(
                  isExpanded: true,
                  hint: const Text('Select Assistant Executive Engineer', style: TextStyle(color: Colors.black38, fontSize: 14)),
                  value: _selectedAee,
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A9079)),
                  items: _divisionUsers.map((user) {
                    return DropdownMenuItem<UserModel>(
                      value: user,
                      child: Text('${user.name} (${user.userType.toUpperCase()})', style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedAee = val),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Date Field
            const Row(
              children: [
                Text('Date ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                Text('*', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            // Remarks Field
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Remarks', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remarkController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showRejectDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Reject Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: _isSubmitting ? null : _submitAssignment,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECA311),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: _isSubmitting 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Confirm Assignment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            CachedNetworkImage(imageUrl: _getImageUrl(url), fit: BoxFit.contain),
            Positioned(
              right: 8, top: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAssignment() async {
    if (_selectedAee == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an Assistant Executive Engineer')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      final caseId = int.parse(widget.caseId);
      if (_pothole?.status.toLowerCase() == 'requested') {
        await repository.acceptCaseEe(caseId);
      }
      await repository.assignToAee(caseId, _selectedAee!.id, _remarkController.text);
      if (mounted) {
        // Force refresh of the report list when navigated back
        ref.invalidate(reportProvider);
        
        // Explicitly refresh the dashboard summary counters
        final userRole = ref.read(authProvider.notifier).currentUser?.userType ?? 'ee';
        ref.read(reportSummaryProvider.notifier).loadSummary(userRole);
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Case assigned to AEE successfully')));
        
        // Bring the user back to the Home Dashboard immediately
        context.go('/main');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${_extractErrorMessage(e)}')),
        );
      }
    }
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is Map && data['errors'] != null) {
        return data['errors'].toString();
      }
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'Request failed with status code $statusCode';
      }
      return error.message ?? 'Network request failed';
    }
    return error.toString();
  }

  void _showRejectDialog() async {
    final repository = await ref.read(reportRepositoryProvider.future);
    final reasons = await repository.getRejectReasons();
    if (!mounted) return;

    int? selectedReasonId;
    final TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Reject Assignment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...reasons.map((r) => RadioListTile<int>(
                      title: Text(r['reason']),
                      value: r['id'],
                      groupValue: selectedReasonId,
                      onChanged: (val) => setDialogState(() => selectedReasonId = val),
                    )),
                    if (reasons.any((r) => r['id'] == selectedReasonId && r['reason'].toString().contains('Others')))
                      TextField(controller: otherReasonController, decoration: const InputDecoration(labelText: 'Specify Reason')),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: selectedReasonId == null ? null : () async {
                    try {
                      String remark = '';
                      final isOthers = reasons.any((r) => r['id'] == selectedReasonId && r['reason'].toString().contains('Others'));
                      remark = isOthers ? otherReasonController.text : reasons.firstWhere((r) => r['id'] == selectedReasonId)['reason'];
                      await repository.rejectCaseEe(caseId: int.parse(widget.caseId), rejectMasterIds: [selectedReasonId!], otherReason: remark);
                      if (context.mounted) {
                        context.pop();
                        context.pop(true);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: const Text('Reject'),
                ),
              ],
            );
          }
        );
      }
    );
  }
}

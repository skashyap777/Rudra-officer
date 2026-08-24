import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../widgets/report/report_card.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/report/assign_vendor_sheet.dart';
import '../../../../data/models/user_model.dart';
import '../../../widgets/report/assign_vendor_sheet.dart';

class SelfInspectionAeeScreen extends ConsumerStatefulWidget {
  const SelfInspectionAeeScreen({super.key});

  @override
  ConsumerState<SelfInspectionAeeScreen> createState() => _SelfInspectionAeeScreenState();
}

class _SelfInspectionAeeScreenState extends ConsumerState<SelfInspectionAeeScreen> {
  bool _isLoading = true;
  List<PotholeModel> _reports = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      // Fetch self assigned reports for AEE
      final reports = await repository.getReportsByEndpoint(
        ApiEndpoints.assignedCasesToSelfAee
      );
      
      if (mounted) {
        setState(() {
          _reports = reports;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Self Inspections', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)));
    }

    if (_reports.isEmpty) {
      return const Center(child: EmptyState(message: 'No reports assigned to you'));
    }

    return RefreshIndicator(
      onRefresh: _fetchReports,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReportCard(
              report: report,
              onTap: () {
                context.pushNamed(
                  'reportDetail',
                  pathParameters: {'id': report.id.toString()},
                  extra: {'filterType': 'self_inspection_aee'},
                );
              },
              actionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!report.vendorAccConfirmed)
                    ElevatedButton(
                      onPressed: () => _handleAssignVendor(report),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        minimumSize: const Size(110, 34),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                      child: const Text('ASSIGN VENDOR'),
                    ),
                  if (report.vendorAccConfirmed) ...[
                    if (report.checkIfSendToVendor) ...[
                      ElevatedButton(
                        onPressed: () => _handleAssignVendor(report),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          minimumSize: const Size(110, 34),
                          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                        child: const Text('RE-ASSIGN VENDOR'),
                      ),
                    ] else ...[
                      if (report.hasBeforeAndAfter) ...[
                        ElevatedButton(
                          onPressed: () => _finalSubmit(report),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8C300),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            minimumSize: const Size(90, 34),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                          child: const Text('FINAL SUBMIT'),
                        ),
                      ] else if (report.hasOnlyBefore) ...[
                        ElevatedButton(
                          onPressed: () => _inspectCase(report),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            minimumSize: const Size(80, 34),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                          child: const Text('CONTINUE'),
                        ),
                      ] else if (report.hasNothing) ...[
                        ElevatedButton(
                          onPressed: () => _inspectCase(report),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            minimumSize: const Size(80, 34),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                          ),
                          child: const Text('INSPECT'),
                        ),
                      ]
                    ]
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _inspectCase(PotholeModel report) {
    context.pushNamed(
      'fieldInspection',
      extra: {'caseId': report.id.toString(), 'reportId': report.caseId},
    ).then((result) {
      if (result == true) _fetchReports();
    });
  }

  void _finalSubmit(PotholeModel report) {
    context.pushNamed(
      'submitFinalReport',
      extra: {'caseId': report.id.toString(), 'reportId': report.caseId},
    ).then((result) {
      if (result == true) _fetchReports();
    });
  }

  Future<void> _handleAssignVendor(PotholeModel report) async {
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      final vendors = await repo.getUsersInDivision('vendor');

      if (!mounted) return;
      if (vendors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sorry, no Vendor is available in this division'),
          ),
        );
        return;
      }

      final result =
          await showModalBottomSheet<({UserModel vendor, String remark})>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            builder: (ctx) => AssignVendorSheet(vendors: vendors),
          );

      if (result == null) return;

      await repo.assignVendor(
        caseId: report.id,
        vendorUserId: result.vendor.id,
        userType: 'aee',
        remark: result.remark,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF3D9A7E),
            content: Text('Report assigned successfully'),
          ),
        );
        _fetchReports();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

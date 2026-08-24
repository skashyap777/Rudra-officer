import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../widgets/report/report_card.dart';

class ReviewInspectionsAeeScreen extends ConsumerStatefulWidget {
  const ReviewInspectionsAeeScreen({super.key});

  @override
  ConsumerState<ReviewInspectionsAeeScreen> createState() => _ReviewInspectionsAeeScreenState();
}

class _ReviewInspectionsAeeScreenState extends ConsumerState<ReviewInspectionsAeeScreen> {
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
      // Fetch review inspection reports for AEE
      final reports = await repository.getReportsByEndpoint(
        ApiEndpoints.reviewInspectionReportAee
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
        title: const Text('Review Inspections', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchReports,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return const Center(child: EmptyState(message: 'No inspections found for review'));
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
                  extra: {'filterType': 'review_aee'},
                );
              },
              actionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await context.pushNamed(
                        'takeActionAee',
                        extra: {
                          'caseId': report.id.toString(),
                          'reportId': report.caseId,
                          'fromFragment': 'review_aee',
                        },
                      );
                      if (result == true) {
                        _fetchReports();
                      }
                    },
                    icon: const Icon(Icons.flash_on_rounded, size: 14),
                    label: const Text('Take Action', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../widgets/report/report_card.dart';

class SelfCapturedAeeScreen extends ConsumerStatefulWidget {
  const SelfCapturedAeeScreen({super.key});

  @override
  ConsumerState<SelfCapturedAeeScreen> createState() => _SelfCapturedAeeScreenState();
}

class _SelfCapturedAeeScreenState extends ConsumerState<SelfCapturedAeeScreen> {
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
      // Fetch self captured reports for AEE
      final reports = await repository.getReportsByEndpoint(
        ApiEndpoints.selfCapturedCasesAee,
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
      appBar: AppBar(
        title: const Text('Self Captured Reports', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
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
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchReports,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return const Center(child: EmptyState(message: 'No reports found.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchReports,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return ReportCard(
            report: report,
            onTap: () {
              context.pushNamed(
                'reportDetail',
                pathParameters: {'id': report.id.toString()},
                extra: {'filterType': 'self_captured_aee'},
              );
            },
          );
        },
      ),
    );
  }
}

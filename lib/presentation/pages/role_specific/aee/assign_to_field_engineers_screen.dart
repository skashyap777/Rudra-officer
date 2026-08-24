import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../widgets/report/report_card.dart';

class AssignToFieldEngineersScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const AssignToFieldEngineersScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<AssignToFieldEngineersScreen> createState() => _AssignToFieldEngineersScreenState();
}

class _AssignToFieldEngineersScreenState extends ConsumerState<AssignToFieldEngineersScreen> {
  late int _currentIndex;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      Future.microtask(() => ref.read(reportSummaryProvider.notifier).loadSummary('aee'));
    }
  }

  Widget _buildTab(String title, int count, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFECA311) : const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isActive ? const Color(0xFFECA311) : const Color(0xFFF3F3F3)),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'inter_semibold',
                    fontSize: 12,
                    color: isActive ? Colors.white : const Color(0xFF666768),
                  ),
                ),
                Text(
                  ' ($count)',
                  style: TextStyle(
                    fontFamily: 'inter_semibold',
                    fontSize: 12,
                    color: isActive ? Colors.white : const Color(0xFF666768),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(reportSummaryProvider);
    int pendingCount = 0;
    int reassignedCount = 0;

    summaryState.whenData((summary) {
      if (summary != null) {
        pendingCount = summary.pendingReports;
        reassignedCount = summary.reAssignedCases;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assign Report', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs mimicking Java's AssignedToFragment
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 20, // To mimic match_parent in HorizontalScrollView
                  child: Row(
                    children: [
                      _buildTab(
                        'Pending',
                        pendingCount,
                        _currentIndex == 0,
                        () => setState(() => _currentIndex = 0),
                      ),
                      _buildTab(
                        'Re-Assigned',
                        reassignedCount,
                        _currentIndex == 1,
                        () => setState(() => _currentIndex = 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _ReportListTab(
                key: ValueKey(_currentIndex),
                filter: _currentIndex == 0 ? 'pending' : 'reassigned',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportListTab extends ConsumerStatefulWidget {
  final String filter;

  const _ReportListTab({super.key, required this.filter});

  @override
  ConsumerState<_ReportListTab> createState() => _ReportListTabState();
}

class _ReportListTabState extends ConsumerState<_ReportListTab> {
  bool _isInit = false;
  String get type => widget.filter == 'pending' ? 'pending_aee' : 'reassigned_aee';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      Future.microtask(() => ref.read(reportProvider.notifier).loadReports(type: type, refresh: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportProvider);

    return state.when(
      data: (reports) {
        if (reports.isEmpty) {
          return EmptyState(message: 'No ${widget.filter} reports found.');
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(reportProvider.notifier).loadReports(type: type, refresh: true);
            ref.read(reportSummaryProvider.notifier).loadSummary('aee');
          },
          color: const Color(0xFF3D9A7E),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ReportCard(
                report: report,
                onTap: () {
                  context.push('/assign-report-details', extra: {
                    'caseId': report.id.toString(),
                    'reportId': report.caseId
                  });
                },
              );
            },
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(reportProvider.notifier).loadReports(type: type, refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

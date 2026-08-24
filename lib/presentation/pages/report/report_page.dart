import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/models/pothole_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/report_provider.dart';
import '../../widgets/report/report_card.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, int> _counts = {};

  final Color _kGreen = const Color(0xFF3D9A7E);
  final Color _kBorder = const Color(0xFFEEEEEE);

  void _updateCount(String type, int count) {
    if (_counts[type] != count) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _counts[type] = count);
      });
    }
  }

  List<String> _getTabs(String? role) {
    if (role == 'vendor') return ['All', 'Repaired', 'Completed'];
    if (role == 'je' || role == 'ae') return ['All', 'Inspected', 'Assigned', 'Rejected', 'Completed'];
    if (role == 'aee' || role == 'ee') return ['All', 'Assigned', 'Rejected', 'Completed'];
    if (role == 'se') return ['All', 'Review', 'Rejected', 'Completed'];
    return ['All'];
  }

  String _getReportType(String tab, String? role) {
    final s = role ?? 'aee';
    switch (tab) {
      case 'All': return 'all_$s';
      case 'Repaired': return 'review_vendor';
      case 'Inspected': return 'inspected_$s';
      case 'Assigned': return s == 'ee' ? 'assigned_ee' : 'assigned_$s';
      case 'Review': return 'review_inspection_se';
      case 'Rejected': return 'rejected_$s';
      case 'Completed': return 'completed_$s';
      default: return 'all_$s';
    }
  }

  @override
  void initState() {
    super.initState();
    final role = ref.read(currentUserProvider)?.userType.toLowerCase();
    _tabController = TabController(length: _getTabs(role).length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(currentUserProvider);
    final role = auth?.userType.toLowerCase();
    final tabs = _getTabs(role);
    final types = tabs.map((t) => _getReportType(t, role)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Reports', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 52,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(88),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Search input
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.grey[100], 
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _kBorder)
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Search case ID or location...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400], size: 16),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        isDense: true,
                      ),
                      onSubmitted: (v) => setState(() => _searchQuery = v),
                      onChanged: (v) { if (v.isEmpty) setState(() => _searchQuery = ''); },
                    ),
                  ),
                ),
                // Filter Tabs
                Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: _kBorder))),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    indicatorColor: _kGreen,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: _kGreen,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.3),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
                    tabs: List.generate(tabs.length, (i) {
                      final c = _counts[types[i]];
                      return Tab(
                        height: 40,
                        child: Row(
                          children: [
                            Text(tabs[i].toUpperCase()),
                            if (c != null && c > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(color: _kGreen.withOpacity(0.1), border: Border.all(color: _kGreen.withOpacity(0.2))),
                                child: Text('$c', style: TextStyle(fontSize: 9, color: _kGreen, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: TabBarView(
        controller: _tabController,
        children: List.generate(tabs.length, (i) => _ReportList(
          type: types[i],
          searchQuery: _searchQuery,
          onCountLoaded: (c) => _updateCount(types[i], c),
        )),
      )),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class _ReportList extends ConsumerWidget {
  final String type;
  final String searchQuery;
  final void Function(int count) onCountLoaded;

  const _ReportList({required this.type, required this.searchQuery, required this.onCountLoaded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<PotholeModel>>(
      future: _fetchReports(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: LoadingIndicator());
        if (snapshot.hasError) return _ErrorView(message: snapshot.error.toString());

        final all = snapshot.data ?? [];
        final items = searchQuery.isEmpty ? all : all.where((r) => r.caseId.toLowerCase().contains(searchQuery.toLowerCase()) || (r.location?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)).toList();

        onCountLoaded(items.length);

        if (items.isEmpty) return const _EmptyView();

        return RefreshIndicator(
          color: const Color(0xFF3D9A7E),
          strokeWidth: 2,
          onRefresh: () async { (context as Element).markNeedsBuild(); },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
            itemCount: items.length,
            itemBuilder: (context, index) => ReportCard(
              report: items[index],
              onTap: () => context.pushNamed('reportDetail', pathParameters: {'id': items[index].id.toString()}, extra: {'filterType': type}),
            ),
          ),
        );
      },
    );
  }

  Future<List<PotholeModel>> _fetchReports(WidgetRef ref) async {
    final repo = await ref.read(reportRepositoryProvider.future);
    String ep = '';
    String? filter;
    final role = ref.read(currentUserProvider)?.userType.toLowerCase();

    switch (type) {
      case 'all_ee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe; break;
      case 'all_aee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee; break;
      case 'all_ae': ep = ApiEndpoints.allInspectedCompletedRejectedCasesAe; break;
      case 'all_je': ep = ApiEndpoints.allInspectedCompletedRejectedCasesJe; break;
      case 'all_vendor': ep = ApiEndpoints.allInspectedCompletedCasesVendor; break;
      case 'assign_fe_aee':
      case 'reassigned_aee':
        ep = ApiEndpoints.pendingReassignAee;
        filter = 'reassigned';
        break;
      case 'assign_aee_ee':
      case 'reassigned_ee':
      case 'reassigned_aee_ee':
        ep = ApiEndpoints.pendingReassignEe;
        filter = 'reassigned';
        break;
      case 'review_inspection_se': ep = ApiEndpoints.reviewInspectionReportSe; break;
      case 'assigned_ee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe; break;
      case 'rejected_ee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe; break;
      case 'completed_ee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe; break;
      case 'rejected_aee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee; break;
      case 'completed_aee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee; break;
      case 'assigned_aee': ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee; break;
      case 'review_vendor': ep = ApiEndpoints.finalUpdateCasesVendor; break;
      case 'completed_je': ep = ApiEndpoints.inspectionCompletedCasesJe; break;
      case 'completed_ae': ep = ApiEndpoints.inspectionCompletedCasesAe; break;
      case 'assigned_je': ep = ApiEndpoints.assignedCasesJe; break;
      case 'assigned_ae': ep = ApiEndpoints.assignedCasesAe; break;
      case 'pending_se': ep = ApiEndpoints.reviewInspectionReportSe; break;
      case 'completed_se': ep = ApiEndpoints.completedCaseSe; break;
      case 'pending_ee': ep = ApiEndpoints.pendingReassignEe; break;
      case 'review_ee': ep = ApiEndpoints.reviewInspectionReportEe; break;
      case 'reassigned_ae':
        ep = ApiEndpoints.pendingReassignAe;
        filter = 're-inspect';
        break;
      case 'reassigned_je':
        ep = ApiEndpoints.pendingReassignJe;
        filter = 're-inspect';
        break;
      default:
        if (type.contains('completed')) {
          if (role == 'aee') ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          else if (role == 'ee') ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          else if (role == 'se') ep = ApiEndpoints.completedCaseSe;
          else if (role == 'ae') ep = ApiEndpoints.allInspectedCompletedRejectedCasesAe;
          else if (role == 'je') ep = ApiEndpoints.allInspectedCompletedRejectedCasesJe;
        } else if (type.contains('inspected')) {
          if (role == 'ae') ep = ApiEndpoints.allInspectedCompletedRejectedCasesAe;
          else if (role == 'je') ep = ApiEndpoints.allInspectedCompletedRejectedCasesJe;
        } else if (type.contains('rejected')) {
          if (role == 'aee') ep = ApiEndpoints.allAssignedCompletedRejectedCasesAee;
          else if (role == 'ee') ep = ApiEndpoints.allAssignedCompletedRejectedCasesEe;
          else if (role == 'se') ep = ApiEndpoints.reassignedCasesSe;
          else if (role == 'ae') ep = ApiEndpoints.allInspectedCompletedRejectedCasesAe;
          else if (role == 'je') ep = ApiEndpoints.allInspectedCompletedRejectedCasesJe;
        }
    }

    if (ep.isEmpty) return [];
    final reports = await repo.getReportsByEndpoint(ep, filter: filter);

    if (type == 'assign_fe_aee') return reports;
    if (type == 'assigned_aee') return reports.where((r) {
      final status = r.status.toLowerCase();
      return status == 'assigned' || status == 'in_progress' || status == 'requested' || status == 'accepted';
    }).toList();
    if (type == 'assigned_ee') return reports.where((r) => r.status.toLowerCase() == 'assigned' || r.status.toLowerCase() == 'in_progress' || r.status.toLowerCase() == 'requested').toList();
    if (type.contains('completed')) return reports.where(_isCompletedReport).toList();
    if (type.contains('inspected')) return reports.where((r) => r.status.toLowerCase() == 'inspected' || r.status.toLowerCase() == 're-inspected').toList();
    if (type.contains('rejected')) return reports.where((r) => r.status.toLowerCase() == 'rejected').toList();

    return reports;
  }

  bool _isCompletedReport(PotholeModel report) {
    final status = report.status.toLowerCase().trim();
    return status == 'completed' ||
        status == 'closed' ||
        status == 'satisfied' ||
        status == 'approved' ||
        status == 'resolved' ||
        status.contains('completed') ||
        report.completedDate != null ||
        report.completionDate != null;
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text('No records found', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

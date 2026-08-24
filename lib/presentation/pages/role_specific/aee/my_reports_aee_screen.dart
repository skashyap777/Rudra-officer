import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../data/models/pothole_model.dart';
import '../../../../data/providers/providers.dart';
import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../widgets/report/report_card.dart';

class MyReportsAeeScreen extends ConsumerStatefulWidget {
  final String? initialTab;
  
  const MyReportsAeeScreen({super.key, this.initialTab});

  @override
  ConsumerState<MyReportsAeeScreen> createState() => _MyReportsAeeScreenState();
}

class _MyReportsAeeScreenState extends ConsumerState<MyReportsAeeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<String> _tabs = ['All', 'Assigned', 'Rejected', 'Completed'];
  final List<String> _filters = ['all', 'assigned', 'rejected', 'completed'];

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;
    if (widget.initialTab != null) {
      initialIndex = _filters.indexOf(widget.initialTab!);
      if (initialIndex == -1) initialIndex = 0;
    }
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Report', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) => setState(() => _searchQuery = value.trim()),
                            style: const TextStyle(fontFamily: 'inter_semibold', fontSize: 13, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Search by Report ID',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'inter_semibold'),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () => setState(() => _searchQuery = _searchController.text.trim()),
                            child: Image.asset('assets/images/frame_1575.png', width: 30, height: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      final isActive = _tabController.index == index;
                      return GestureDetector(
                        onTap: () {
                          _tabController.animateTo(index);
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5, bottom: 10, top: 5),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFF8C300) : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: isActive ? null : Border.all(color: const Color(0xFFD9D9D9), width: 1),
                            boxShadow: isActive ? [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
                            ] : [],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              fontFamily: 'inter_semibold',
                              fontSize: 12,
                              color: isActive ? Colors.white : const Color(0xFF666768),
                            ),
                          ),
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
        physics: const NeverScrollableScrollPhysics(), // Since tabs are custom, disabling swipe to avoid state sync issues, or we can add listener
        controller: _tabController,
        children: _filters.map((filter) => _ReportListTab(
          filter: filter, 
          searchQuery: _searchQuery,
        )).toList(),
      )),
    );
  }
}

class _ReportListTab extends ConsumerStatefulWidget {
  final String filter;
  final String searchQuery;

  const _ReportListTab({
    required this.filter,
    required this.searchQuery,
  });

  @override
  ConsumerState<_ReportListTab> createState() => _ReportListTabState();
}

class _ReportListTabState extends ConsumerState<_ReportListTab> {
  bool _isLoading = true;
  List<PotholeModel> _reports = [];
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  @override
  void didUpdateWidget(_ReportListTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _fetchReports(refresh: true);
    }
  }

  Future<void> _fetchReports({bool refresh = false}) async {
    if (!mounted) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = await ref.read(reportRepositoryProvider.future);
      final results = await repository.getReportsByEndpoint(
        ApiEndpoints.allAssignedCompletedRejectedCasesAee,
        filter: widget.filter,
        query: widget.searchQuery,
        page: _currentPage,
      );
      
      if (mounted) {
        setState(() {
          if (refresh) {
            _reports = results;
          } else {
            _reports.addAll(results);
          }
          _isLoading = false;
          _hasMore = results.length == 20;
          _currentPage++;
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
    if (_isLoading && _reports.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    if (_errorMessage != null && _reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchReports(refresh: true),
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
      return Center(child: EmptyState(message: 'No ${widget.filter} reports found'));
    }

    return RefreshIndicator(
      onRefresh: () => _fetchReports(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _reports.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _reports.length) {
            return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 2)));
          }

          final report = _reports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReportCard(
              report: report,
              onTap: () {
                context.pushNamed(
                  'reportDetail',
                  pathParameters: {'id': report.id.toString()},
                  extra: {'filterType': '${widget.filter}_aee'},
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/models/report_summary_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/report_provider.dart';

// ── Design tokens ────────────────────────────────────────────────────────────
const _green = Color(0xFF3D9A7E);
const _bg    = Color(0xFFF5F7FA);
const _border = Color(0xFFE4E9E6);

class DashboardCard {
  final String title;
  final int count;
  final String bgImage;
  final VoidCallback onTap;
  DashboardCard({required this.title, required this.count, required this.bgImage, required this.onTap});
}

class DashboardAction {
  final String title;
  final String description;
  final int? count;
  final String iconImage;
  final VoidCallback onTap;
  DashboardAction({required this.title, required this.description, this.count, required this.iconImage, required this.onTap});
}

// ═════════════════════════════════════════════════════════════════════════════
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _userRole = AppConstants.roleJe;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDashboardData());
  }

  Future<void> _loadDashboardData() async {
    final user = ref.read(authProvider.notifier).currentUser;
    if (user != null) setState(() => _userRole = user.userType);
    await ref.read(reportSummaryProvider.notifier).loadSummary(_userRole);
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(reportSummaryProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: summaryAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 36, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error: $e', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _loadDashboardData,
                icon: const Icon(Icons.refresh, size: 14),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF8C300), foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
        data: (summary) {
          if (summary == null) return const SizedBox();
          return RefreshIndicator(
            color: _green,
            onRefresh: _loadDashboardData,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverHeader(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _sectionLabel('Summary'),
                      const SizedBox(height: 6),
                      _buildQuickStats(summary),
                      const SizedBox(height: 12),
                      _sectionLabel('Quick Actions'),
                      const SizedBox(height: 6),
                      _buildQuickActions(summary),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    final user = ref.watch(currentUserProvider);
    final topPad = MediaQuery.of(context).padding.top;
    String photoUrl = user?.profilePhotoLink ?? '';
    if (photoUrl.isNotEmpty && !photoUrl.startsWith('http')) {
      photoUrl = '${ApiEndpoints.baseUrlImage}$photoUrl';
    }

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: EdgeInsets.fromLTRB(14, topPad + 12, 14, 14),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF8C300).withValues(alpha: 0.10),
              backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty ? const Icon(Icons.person_rounded, color: _green, size: 22) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  Text(
                    user?.name ?? 'Officer',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.3),
                  ),
                ],
              ),
            ),
            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _green.withValues(alpha: 0.24)),
              ),
              child: Text(
                AppConstants.roleDisplayNames[_userRole] ?? _userRole.toUpperCase(),
                style: const TextStyle(color: _green, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.3),
              ),
            ),
            const SizedBox(width: 8),

          ],
        ),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter_semibold', color: Colors.black),
  );

  final List<String> _summaryBgs = const [
    'whatsapp_image_2025_06_11_at_10_35_05_am.jpeg',
    'whatsapp_image_2025_06_11_at_10_38_44_am.jpeg',
    'whatsapp_image_2025_06_11_at_10_38_44_am__1_.jpeg',
    'whatsapp_image_2025_06_11_at_10_38_44_am__2_.jpeg',
    'whatsapp_image_2025_08_21_at_11_25_53_pm.jpeg',
    'whatsapp_image_2025_09_06_at_3_42_24_pm.jpeg',
    'whatsapp_image_2026_01_20_at_9_45_59_pm.jpeg',
  ];

  Widget _buildQuickStats(ReportSummaryModel summary) {
    final cards = _getCards(summary);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.0,
      ),
      itemCount: cards.length,
      itemBuilder: (_, i) {
        final c = cards[i];
        final bg = _summaryBgs[i % _summaryBgs.length];
        return InkWell(
          onTap: c.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage('assets/images/$bg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  c.title,
                  style: const TextStyle(
                    fontFamily: 'inter_medium',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${c.count}',
                  style: const TextStyle(
                    fontFamily: 'inter_semibold',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Action list ───────────────────────────────────────────────────────────
  Widget _buildQuickActions(ReportSummaryModel summary) {
    final actions = _getActions(summary);
    return Column(
      children: actions.map((a) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: InkWell(
            onTap: a.onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/${a.iconImage}',
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                a.title,
                                style: const TextStyle(
                                  fontFamily: 'inter_semibold',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (a.count != null)
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                ),
                                child: Text(
                                  '${a.count}',
                                  style: const TextStyle(
                                    fontFamily: 'inter_semibold',
                                    fontSize: 10,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          a.description,
                          style: const TextStyle(
                            fontFamily: 'inter_medium',
                            fontSize: 12,
                            color: Color(0xFF666768),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Data builders (unchanged logic) ──────────────────────────────────────
  List<DashboardCard> _getCards(ReportSummaryModel s) {
    final role = _userRole.toLowerCase();
    if (role == 'se') return [
      DashboardCard(title: 'Pending Reviews', count: s.pendingReviews, bgImage: '', onTap: () => _toList('Pending Reviews', 'pending_se')),
      DashboardCard(title: 'Returned', count: s.unsatisfied, bgImage: '', onTap: () => _toList('Returned', 'returned_se')),
      DashboardCard(title: 'Completed', count: s.satisfied, bgImage: '', onTap: () => _toList('Completed', 'completed_se')),
    ];
    if (role == 'ee') return [
      DashboardCard(title: 'Pending Cases', count: s.pendingReports, bgImage: '', onTap: () => _toList('Pending Cases', 'pending_ee')),
      DashboardCard(title: 'Assigned Cases', count: s.assignedCases, bgImage: '', onTap: () => _toList('Assigned Cases', 'assigned_ee')),
      DashboardCard(title: 'In-Progress', count: s.inProgressCases, bgImage: '', onTap: () => _toList('In-Progress', 'in_progress_ee')),
      DashboardCard(title: 'Pending Reviews', count: s.reviewInspectionCount, bgImage: '', onTap: () => _toList('Pending Reviews', 'review_ee')),
      DashboardCard(title: 'Re-Assigned Cases', count: s.reAssignedCases, bgImage: '', onTap: () => _toList('Re-Assigned', 'reassigned_ee')),
      DashboardCard(title: 'Completed', count: s.completedCases, bgImage: '', onTap: () => _toList('Completed', 'completed_ee')),
    ];
    if (role == 'aee') return [
      DashboardCard(title: 'Pending Cases', count: s.pendingReports, bgImage: '', onTap: () => context.pushNamed('assignToFieldEngineers', extra: {'initialTab': 0})),
      DashboardCard(title: 'Self Captured Cases', count: s.captureNearbyPotholeCount, bgImage: '', onTap: () => context.pushNamed('selfCapturedAee')),
      DashboardCard(title: 'Assigned Cases', count: s.assignedCases, bgImage: '', onTap: () => context.pushNamed('myReportsAee', extra: {'initialTab': 'assigned'})),
      DashboardCard(title: 'In-Progress', count: s.inProgressCases, bgImage: '', onTap: () => context.pushNamed('myReportsAee', extra: {'initialTab': 'assigned'})),
      DashboardCard(title: 'Pending Reviews', count: s.reviewInspectionCount, bgImage: '', onTap: () => context.pushNamed('reviewInspectionsAee')),
      DashboardCard(title: 'Re-Assigned Cases', count: s.reAssignedCases, bgImage: '', onTap: () => context.pushNamed('assignToFieldEngineers', extra: {'initialTab': 1})),
      DashboardCard(title: 'Completed', count: s.completedCases, bgImage: '', onTap: () => context.pushNamed('myReportsAee', extra: {'initialTab': 'completed'})),
    ];
    if (role == 'je' || role == 'ae') {
      final sfx = role == 'ae' ? 'ae' : 'je';
      return [
        DashboardCard(title: 'Pending Cases', count: s.pendingInspectionCount, bgImage: '', onTap: () => _toList('Pending Cases', 'pending_$sfx')),
        DashboardCard(title: 'Self Captured Cases', count: s.captureNearbyPotholeCount, bgImage: '', onTap: () => _toList('Self Captured Cases', 'self_captured_$sfx')),
        DashboardCard(title: 'Assigned Cases', count: s.assignedCount, bgImage: '', onTap: () => _toList('Assigned Cases', 'assigned_$sfx')),
        DashboardCard(title: 'Sent for review', count: s.sentForReview, bgImage: '', onTap: () => _toList('Sent for review', 'review_$sfx')),
        DashboardCard(title: 'Re-Assigned Cases', count: s.reAssignedCases, bgImage: '', onTap: () => _toList('Re-Assigned Cases', 'reassigned_$sfx')),
        DashboardCard(title: 'Completed', count: s.completedCount, bgImage: '', onTap: () => _toList('Completed', 'completed_$sfx')),
      ];
    }
    if (role == 'vendor') return [
      DashboardCard(title: 'Pending Cases', count: s.pendingCount, bgImage: '', onTap: () => _toList('Pending Cases', 'pending_vendor')),
      DashboardCard(title: 'Sent for review', count: s.sentForReview, bgImage: '', onTap: () => _toList('Sent for review', 'review_vendor')),
      DashboardCard(title: 'Re-Assigned Cases', count: s.reassignedCountVendor, bgImage: '', onTap: () => _toList('Re-Assigned Cases', 'reassigned_vendor')),
      DashboardCard(title: 'Completed', count: s.completedCases, bgImage: '', onTap: () => _toList('Completed', 'completed_vendor')),
    ];
    return [];
  }

  List<DashboardAction> _getActions(ReportSummaryModel s) {
    final role = _userRole.toLowerCase();
    if (role == 'se') return [
      DashboardAction(title: 'Review Inspections', description: 'Reports needing your final approval', iconImage: 'frame_1107_.png', onTap: () => _handleActionTap(context, 'Review Inspections')),
      DashboardAction(title: 'Returned Reports', description: 'Reports returned for correction', iconImage: 'frame_1107__.png', onTap: () => _handleActionTap(context, 'Returned Reports')),
      DashboardAction(title: 'Completed Reports', description: 'History of approved reports', iconImage: 'frame_1107__4_.png', onTap: () => _handleActionTap(context, 'Completed Reports')),
    ];
    if (role == 'ee') return [
      DashboardAction(title: 'Assign to AEE', description: 'Dispatch reports to sub-division officers', count: s.pendingReports + s.reAssignedCases, iconImage: 'frame_1107_.png', onTap: () => _handleActionTap(context, 'Assign to AEE')),
      DashboardAction(title: 'Pothole Activity Map', description: 'Live tracking of work progress', iconImage: 'frame_1107__.png', onTap: () => _handleActionTap(context, 'Pothole Activity Map')),
      DashboardAction(title: 'Review Inspections', description: 'Verify field inspection quality', count: s.reviewInspectionCount, iconImage: 'frame_1107__4_.png', onTap: () => _handleActionTap(context, 'Review Inspections')),
    ];
    if (role == 'aee') return [
      DashboardAction(title: 'Assign to Field Engineers', description: 'Dispatch reports to JE/AE officers', count: s.pendingReports, iconImage: 'frame_1107_.png', onTap: () => _handleActionTap(context, 'Assign to Field Engineers')),
      DashboardAction(title: 'Pothole Activity Map', description: 'Live tracking of your area potholes', iconImage: 'frame_1107__.png', onTap: () => _handleActionTap(context, 'Pothole Activity Map')),
      DashboardAction(title: 'Review Inspections', description: 'Verify engineer reports & photos', count: s.reviewInspectionCount, iconImage: 'frame_1107__4_.png', onTap: () => _handleActionTap(context, 'Review Inspections')),
      DashboardAction(title: 'Self Inspection Report', description: 'Create and submit direct inspections', count: s.selfInspectionReportCount, iconImage: 'frame_1107__5_.png', onTap: () => _handleActionTap(context, 'Self Inspection Report')),
      DashboardAction(title: 'Capture Nearby Pothole', description: 'Direct AI-assisted pothole reporting', iconImage: 'frame_1107__6_.png', onTap: () => _handleActionTap(context, 'Capture Nearby Pothole')),
    ];
    if (role == 'je' || role == 'ae') return [
      DashboardAction(title: 'Case assigned', description: 'Conduct new fieldwork inspections', count: s.pendingInspectionCount + s.reAssignedCases, iconImage: 'frame_1107_.png', onTap: () => _handleActionTap(context, 'Case assigned')),
      DashboardAction(title: 'Pothole Activity Map', description: 'Navigate to assigned pothole sites', iconImage: 'frame_1107__.png', onTap: () => _handleActionTap(context, 'Pothole Activity Map')),
      DashboardAction(title: 'Submit Final Report', description: 'Record work completion details', count: s.submitFinalReportCount, iconImage: 'frame_1107__4_.png', onTap: () => _handleActionTap(context, 'Submit Final Report')),
      DashboardAction(title: 'Capture Nearby Pothole', description: 'Report new potholes found on-site', iconImage: 'frame_1107__5_.png', onTap: () => _handleActionTap(context, 'Capture Nearby Pothole')),
    ];
    if (role == 'vendor') return [
      DashboardAction(title: 'Case assigned', description: 'View and start repair operations', count: s.pendingCount + s.reassignedCountVendor, iconImage: 'frame_1107_.png', onTap: () => _handleActionTap(context, 'Case assigned')),
      DashboardAction(title: 'Pothole Activity Map', description: 'Locate site & team locations', iconImage: 'frame_1107__.png', onTap: () => _handleActionTap(context, 'Pothole Activity Map')),
      DashboardAction(title: 'Submit Final Update', description: 'Submit completion photos for review', count: s.finalSubmitCasesCount, iconImage: 'frame_1107__4_.png', onTap: () => _handleActionTap(context, 'Submit Final Update')),
    ];
    return [];
  }

  void _toList(String title, String filterType) =>
    context.pushNamed('reportList', extra: {'title': title, 'filterType': filterType});

  void _handleActionTap(BuildContext context, String actionTitle) {
    if (actionTitle == 'Pothole Activity Map') { context.pushNamed('potholeMap'); return; }
    if (actionTitle == 'Capture Nearby Pothole') { context.pushNamed('capturePothole'); return; }

    String filterType = 'all';
    final role = _userRole.toLowerCase();

    if (role == 'se') {
      if (actionTitle == 'Review Inspections') filterType = 'pending_se';
      if (actionTitle == 'Returned Reports') filterType = 'returned_se';
      if (actionTitle == 'Completed Reports') filterType = 'completed_se';
    } else if (role == 'ee') {
      if (actionTitle == 'Assign to AEE') filterType = 'pending_ee';
      if (actionTitle == 'Review Inspections') filterType = 'review_ee';
    } else if (role == 'aee') {
      if (actionTitle == 'Assign to Field Engineers') { context.pushNamed('assignToFieldEngineers'); return; }
      if (actionTitle == 'Review Inspections') { context.pushNamed('reviewInspectionsAee'); return; }
      if (actionTitle == 'Self Inspection Report') { context.pushNamed('selfInspectionAee'); return; }
    } else if (role == 'je' || role == 'ae') {
      final sfx = role == 'ae' ? 'ae' : 'je';
      if (actionTitle == 'Case assigned') filterType = 'assigned_$sfx';
      if (actionTitle == 'Submit Final Report') filterType = 'submit_final_$sfx';
    } else if (role == 'vendor') {
      if (actionTitle == 'Case assigned') filterType = 'assigned_vendor';
      if (actionTitle == 'Submit Final Update') filterType = 'submit_update_vendor';
    }

    _toList(actionTitle, filterType);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../../widgets/report/assign_vendor_sheet.dart';
import '../../widgets/report/report_card.dart';

// ── Color palette ──────────────────────────────────────────────────
const _kGreen = Color(0xFF3D9A7E);
const _kBg = Color(0xFFF5F7FA);

class ReportListScreen extends ConsumerStatefulWidget {
  final String title;
  final String filterType;

  const ReportListScreen({
    super.key,
    required this.title,
    required this.filterType,
  });

  @override
  ConsumerState<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends ConsumerState<ReportListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(reportProvider.notifier)
          .loadReports(type: widget.filterType, refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D9A7E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'inter_medium',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: SafeArea(child: reportsAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => _buildError(error),
        data: (reports) {
          if (reports.isEmpty) return _buildEmpty();
          return RefreshIndicator(
            color: _kGreen,
            onRefresh: () => ref
                .read(reportProvider.notifier)
                .loadReports(type: widget.filterType, refresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
              itemCount: reports.length,
              itemBuilder: (ctx, i) {
                final report = reports[i];
                return ReportCard(
                  report: report,
                  onTap: () {
                    final ft = widget.filterType;
                    if (ft == 'pending_ee') {
                      context.pushNamed(
                        'assignReportEe',
                        extra: {
                          'caseId': report.id.toString(),
                          'reportId': report.caseId,
                        },
                      );
                    } else {
                      context.pushNamed(
                        'reportDetail',
                        pathParameters: {'id': report.id.toString()},
                        extra: {'filterType': ft, 'report': report},
                      );
                    }
                  },
                  actionButton: _buildExtraActions(report, context),
                );
              },
            ),
          );
        },
      )),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.folder_open_rounded, size: 48, color: Colors.grey[300]),
        const SizedBox(height: 12),
        const Text(
          'No records found',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );

  Widget _buildError(Object error) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 36),
          const SizedBox(height: 12),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref
                .read(reportProvider.notifier)
                .loadReports(type: widget.filterType, refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF8C300),
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  Future<void> _handleAccept(PotholeModel report) async {
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      final ft = widget.filterType;

      if (ft == 'pending_je' ||
          ft == 'pending_ae' ||
          ft == 'assigned_je' ||
          ft == 'assigned_ae') {
        await repo.acceptCaseJeAe(report.id, _fieldEngineerRole(ft));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: _kGreen,
            content: Text('Case Accepted ✓'),
          ),
        );
        ref
            .read(reportProvider.notifier)
            .loadReports(type: widget.filterType, refresh: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _handleReject(PotholeModel report) async {
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      final reasons = await repo.getRejectReasons();

      if (!mounted) return;
      if (reasons.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry, no reject reason is available')),
        );
        return;
      }

      final result =
          await showModalBottomSheet<({int reasonId, String? otherReason})>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            builder: (ctx) => _RejectReasonSheet(reasons: reasons),
          );

      if (result == null) return;

      final ft = widget.filterType;
      if (ft == 'pending_je' ||
          ft == 'pending_ae' ||
          ft == 'assigned_je' ||
          ft == 'assigned_ae') {
        await repo.rejectCaseJeAe(
          caseId: report.id,
          userType: _fieldEngineerRole(ft),
          rejectMasterIds: [result.reasonId],
          otherReason: result.otherReason,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Report rejected successfully'),
          ),
        );
        ref
            .read(reportProvider.notifier)
            .loadReports(type: widget.filterType, refresh: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  String _fieldEngineerRole(String filterType) {
    if (filterType.endsWith('_ae')) return 'ae';
    if (filterType.endsWith('_je')) return 'je';
    return ref.read(currentUserProvider)?.userType.toLowerCase() ?? 'je';
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
        userType: _fieldEngineerRole(widget.filterType),
        remark: result.remark,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: _kGreen,
            content: Text('Report assigned successfully'),
          ),
        );
        ref
            .read(reportProvider.notifier)
            .loadReports(type: widget.filterType, refresh: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget? _buildExtraActions(PotholeModel report, BuildContext context) {
    final ft = widget.filterType;
    final isReview = ft == 'review_aee' || ft == 'review_ee' || ft == 'pending_se';
    final isPendingJeAe = {
      'pending_je',
      'pending_ae',
      'assigned_je',
      'assigned_ae',
    }.contains(ft);
    final isSentToVendor =
        report.pendingAt?.toLowerCase() == 'vendor' ||
        report.vendorUserId != null ||
        report.vendorName != null;
    final isRequested =
        report.status.toLowerCase() == 'requested' && !isSentToVendor;
    final hasOfficerReport = report.officerReports?.isNotEmpty ?? false;
    final hasOnlyBefore =
        hasOfficerReport &&
        report.officerReports!.first.status?.toLowerCase() == 'saved';
    final showVendorActions =
        isPendingJeAe &&
        !isRequested &&
        !isSentToVendor &&
        !report.vendorAccConfirmed;
    final showInspectionAction =
        isPendingJeAe &&
        !isRequested &&
        report.vendorAccConfirmed &&
        !hasOnlyBefore;
    final showContinueAction =
        isPendingJeAe &&
        !isRequested &&
        report.vendorAccConfirmed &&
        hasOnlyBefore;
    final canAcceptPendingJeAe = isPendingJeAe && isRequested;
    final isFinal = ft.contains('submit_final') || ft == 'submit_update_vendor';
    final isVendorArrival = ft == 'assigned_vendor' || ft == 'pending_vendor';
    final isVendorRepair = ft == 'reassigned_vendor';
    final isVendorFinal = isVendorRepair || ft == 'submit_update_vendor';

    final actions = <Widget>[];

    if (isReview) {
      actions.add(const SizedBox(height: 10));
      actions.add(_btn('Take Action', Icons.flash_on_rounded, Colors.orange, () {
        if (ft == 'review_aee') {
          context.pushNamed(
            'takeActionAee',
            extra: {
              'caseId': report.id.toString(),
              'reportId': report.caseId,
              'fromFragment': 'review_aee',
            },
          );
        } else if (ft == 'pending_se') {
          context.pushNamed(
            'takeActionSe',
            extra: {
              'caseId': report.id.toString(),
              'reportId': report.caseId,
            },
          );
        } else {
          context.pushNamed(
            'takeActionEe',
            extra: {
              'caseId': report.id.toString(),
              'reportId': report.caseId,
            },
          );
        }
      }));
    }

    if (isVendorArrival) {
      actions.add(const SizedBox(height: 10));
      actions.add(_btn('Arrived at Location', Icons.location_on_rounded, _kGreen, () async {
        final refreshed = await context.pushNamed<bool>(
          'vendorFix',
          extra: {
            'caseId': report.id.toString(),
            'reportId': report.caseId,
            'alreadyArrived': false,
            'report': report,
          },
        );
        if (refreshed == true) {
          ref.read(reportProvider.notifier).loadReports(type: widget.filterType, refresh: true);
        }
      }));
    }

    if (canAcceptPendingJeAe) {
      actions.add(const SizedBox(height: 10));
      actions.add(Row(
        children: [
          Expanded(
            child: _btn(
              'Accept',
              Icons.check_circle,
              _kGreen,
              () => _handleAccept(report),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _btn(
              'Reject',
              Icons.cancel,
              Colors.red,
              () => _handleReject(report),
              outlined: true,
            ),
          ),
        ],
      ));
    }

    if (showVendorActions) {
      actions.add(const SizedBox(height: 10));
      actions.add(Row(
        children: [
          Expanded(
            child: _btn(
              'Assign Vendor',
              Icons.engineering_rounded,
              _kGreen,
              () => _handleAssignVendor(report),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _btn(
              'Reject',
              Icons.cancel,
              Colors.red,
              () => _handleReject(report),
              outlined: true,
            ),
          ),
        ],
      ));
    }

    if (showInspectionAction) {
      actions.add(const SizedBox(height: 10));
      actions.add(_btn(
        'Conduct Inspection',
        Icons.assignment,
        Colors.orange,
        () => context.pushNamed(
          'fieldInspection',
          extra: {
            'caseId': report.id.toString(),
            'reportId': report.caseId,
          },
        ),
      ));
    }

    if (showContinueAction) {
      actions.add(const SizedBox(height: 10));
      actions.add(_btn(
        'Continue',
        Icons.play_arrow_rounded,
        Colors.orange,
        () => context.pushNamed(
          'fieldInspection',
          extra: {
            'caseId': report.id.toString(),
            'reportId': report.caseId,
          },
        ),
      ));
    }

    if (isFinal || isVendorFinal) {
      actions.add(const SizedBox(height: 10));
      actions.add(_btn(isVendorRepair ? 'Repair Completed' : 'Submit Final', Icons.upload_file, _kGreen, () async {
        if (ft.contains('vendor')) {
          final refreshed = await context.pushNamed<bool>(
            'vendorFix',
            extra: {
              'caseId': report.id.toString(),
              'reportId': report.caseId,
              'alreadyArrived': true,
              'repairOnly': isVendorRepair,
              'report': report,
            },
          );
          if (refreshed == true) {
            ref.read(reportProvider.notifier).loadReports(type: widget.filterType, refresh: true);
          }
        } else {
          context.pushNamed(
            'submitFinalReport',
            extra: {
              'caseId': report.id.toString(),
              'reportId': report.caseId,
            },
          );
        }
      }));
    }

    if (actions.isEmpty) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions,
    );
  }

  Widget _btn(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool outlined = false,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      decoration: BoxDecoration(
        color: outlined ? Colors.white : color,
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(6), // Matched corner radius
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: outlined ? color : Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: outlined ? color : Colors.white,
              fontFamily: 'inter_semibold',
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

class _AssignVendorSheet extends StatefulWidget {
  final List<UserModel> vendors;

  const _AssignVendorSheet({required this.vendors});

  @override
  State<_AssignVendorSheet> createState() => _AssignVendorSheetState();
}

class _AssignVendorSheetState extends State<_AssignVendorSheet> {
  final _remarkController = TextEditingController();
  UserModel? _selectedVendor;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assign Vendor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.vendors.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final vendor = widget.vendors[index];
                  final selected = _selectedVendor == vendor;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => setState(() => _selectedVendor = vendor),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected ? _kGreen : Colors.grey,
                    ),
                    title: Text(
                      vendor.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      vendor.divisionName ?? 'Division unavailable',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _remarkController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Remark is required',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedVendor == null
                        ? null
                        : () {
                            final remark = _remarkController.text.trim();
                            if (remark.isEmpty) return;
                            Navigator.pop(context, (
                              vendor: _selectedVendor!,
                              remark: remark,
                            ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8C300),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Assign'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RejectReasonSheet extends StatefulWidget {
  final List<Map<String, dynamic>> reasons;

  const _RejectReasonSheet({required this.reasons});

  @override
  State<_RejectReasonSheet> createState() => _RejectReasonSheetState();
}

class _RejectReasonSheetState extends State<_RejectReasonSheet> {
  final _otherController = TextEditingController();
  Map<String, dynamic>? _selectedReason;

  bool get _needsOtherReason {
    final reason = _selectedReason?['reason']?.toString().toLowerCase() ?? '';
    return reason.contains('other');
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reject Case',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.reasons.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final reason = widget.reasons[index];
                  final selected = _selectedReason == reason;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => setState(() => _selectedReason = reason),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected ? Colors.red : Colors.grey,
                    ),
                    title: Text(
                      reason['reason']?.toString() ?? 'Reason unavailable',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_needsOtherReason) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _otherController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Other Reason is required',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason == null
                        ? null
                        : () {
                            final otherReason = _otherController.text.trim();
                            if (_needsOtherReason && otherReason.isEmpty) {
                              return;
                            }
                            Navigator.pop(context, (
                              reasonId: (_selectedReason!['id'] as num).toInt(),
                              otherReason: _needsOtherReason
                                  ? otherReason
                                  : null,
                            ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



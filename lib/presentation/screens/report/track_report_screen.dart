import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/utils/date_formatter.dart';

class TrackReportScreen extends ConsumerWidget {
  final String caseId;

  const TrackReportScreen({
    super.key,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proceedingsAsync = ref.watch(caseProceedingsProvider(caseId));
    final potholeAsync = ref.watch(caseDetailProvider(caseId));

    const kBg = Color(0xFFF5F7FA);
    const kBorder = Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text(
          'Complaint Tracking #$caseId',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: kBorder, height: 1),
        ),
      ),
      body: SafeArea(
        child: proceedingsAsync.when(
          data: (proceedings) {
            final pothole = potholeAsync.valueOrNull;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Accountability & Stage Tracker Header
                _AccountabilitySummaryHeader(
                  caseId: caseId,
                  pothole: pothole,
                  proceedings: proceedings,
                ),
                const SizedBox(height: 16),

                const Text(
                  '100% PROCEEDINGS TIMELINE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),

                if (proceedings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No tracking records found.',
                        style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                else
                  ...proceedings.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == proceedings.length - 1;
                    return _TimelineItem(item: item, isLast: isLast);
                  }),
              ],
            );
          },
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, stack) => Center(
            child: ErrorStateWidget(
              message: 'Failed to load tracking data',
              onRetry: () => ref.refresh(caseProceedingsProvider(caseId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountabilitySummaryHeader extends ConsumerWidget {
  final String caseId;
  final PotholeModel? pothole;
  final List<CaseProceedingModel> proceedings;

  const _AccountabilitySummaryHeader({
    required this.caseId,
    required this.pothole,
    required this.proceedings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const kGreen = Color(0xFF3D9A7E);
    const kDarkOrange = Color(0xFFD97706);
    const kRed = Color(0xFFDC2626);

    final createdDate = pothole?.reportDate ?? pothole?.createdAt ?? (proceedings.isNotEmpty ? proceedings.first.createdAt : null);
    final daysOpen = AppDateFormatters.pendingDays(createdDate);

    final status = pothole?.status?.toLowerCase() ?? 'pending';
    final vendorName = pothole?.vendorName ?? 'DLP Contractor';

    // Determine current stage index (0 to 4)
    int currentStage = 0;
    if (status == 'completed' || pothole?.isCompleted == true) {
      currentStage = 4;
    } else if (pothole?.checkIfSendToVendor == true || status == 'inspected' || pothole?.vendorName != null) {
      currentStage = 3;
    } else if (pothole?.assignedToName != null || status == 'assigned') {
      currentStage = 1;
    }

    String pendingResponsible = 'Pending JE/AEE Field Inspection';
    if (currentStage == 3) {
      pendingResponsible = 'Pending DLP Contractor ($vendorName)';
    } else if (currentStage == 4) {
      pendingResponsible = 'Resolved & Verified';
    }

    final isDelayed = daysOpen >= 7 && currentStage < 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isDelayed ? kRed.withOpacity(0.4) : const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Complaint Stage Header & SLA Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: isDelayed ? kRed : (currentStage == 4 ? kGreen : kDarkOrange),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STAGE ${currentStage + 1} OF 5',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isDelayed ? kRed : (currentStage == 4 ? kGreen : kDarkOrange),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: isDelayed ? kRed.withOpacity(0.1) : Colors.grey[100],
                child: Text(
                  daysOpen > 0 ? '$daysOpen Days Open' : 'Reported Today',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDelayed ? kRed : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stage Progression Visualizer
          Row(
            children: List.generate(5, (index) {
              final isPassed = index <= currentStage;
              final isCurrent = index == currentStage;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                  color: isCurrent
                      ? (isDelayed ? kRed : kGreen)
                      : (isPassed ? kGreen : Colors.grey[200]),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Current Responsibility Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: isDelayed ? const Color(0xFFFEF2F2) : const Color(0xFFF9FAFB),
            child: Row(
              children: [
                Icon(
                  isDelayed ? Icons.warning_amber_rounded : Icons.account_circle_outlined,
                  size: 18,
                  color: isDelayed ? kRed : Colors.black87,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT ACCOUNTABILITY',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pendingResponsible,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isDelayed ? kRed : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DLP Formal Reminder Trigger for Officers if delayed & pending contractor
          if (currentStage == 3 && isDelayed) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final sendReminder = ref.read(sendContractorReminderProvider);
                  final success = await sendReminder(
                    caseId: caseId,
                    vendorName: vendorName,
                    officerName: 'Junior Engineer',
                    remarks: 'FORMAL NOTICE: Contractor $vendorName has exceeded repair SLA by $daysOpen days. Immediate action requested.',
                  );
                  if (success) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Formal Reminder & Notice issued to $vendorName!'),
                        backgroundColor: kGreen,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                icon: const Icon(Icons.notifications_active_outlined, size: 16),
                label: const Text(
                  'SEND FORMAL REMINDER TO CONTRACTOR',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final CaseProceedingModel item;
  final bool isLast;

  const _TimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateFormatters.formatIndianDateTime(item.createdAt);
    const kGreen = Color(0xFF3D9A7E);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 10, height: 10,
                color: kGreen,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: kGreen.withOpacity(0.2)),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.userDesignation == null || item.userDesignation == 'null'
                            ? '${item.task} (${item.userName})'
                            : '${item.task} • ${item.userDesignation}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700], fontWeight: FontWeight.w700, letterSpacing: 0.3),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: kGreen, width: 2.5)),
                  ),
                  child: Text(
                    (item.remarks == null || item.remarks == 'null' || item.remarks!.isEmpty)
                        ? 'System generated entry'
                        : item.remarks!,
                    style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, size: 40, color: Colors.red),
        const SizedBox(height: 16),
        Text(message, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF8C300), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          child: const Text('RETRY'),
        ),
      ],
    );
  }
}

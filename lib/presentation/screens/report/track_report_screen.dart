import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/models.dart';
import '../../../data/providers/providers.dart';
import '../../../core/widgets/widgets.dart';

class TrackReportScreen extends ConsumerWidget {
  final String caseId;

  const TrackReportScreen({
    super.key,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proceedingsAsync = ref.watch(caseProceedingsProvider(caseId));
    const kBg = Color(0xFFF5F7FA);
    const kBorder = Color(0xFFEEEEEE);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Report Timeline', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
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
      body: SafeArea(child: proceedingsAsync.when(
        data: (proceedings) {
          if (proceedings.isEmpty) {
            return const Center(child: Text('No tracking records found.', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: proceedings.length,
            itemBuilder: (context, index) {
              final item = proceedings[index];
              final isLast = index == proceedings.length - 1;
              return _TimelineItem(item: item, isLast: isLast);
            },
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: ErrorStateWidget(
            message: 'Failed to load tracking data',
            onRetry: () => ref.refresh(caseProceedingsProvider(caseId)),
          ),
        ),
      )),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final CaseProceedingModel item;
  final bool isLast;

  const _TimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(item.createdAt);
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
          const SizedBox(width: 20),
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
                              : item.task,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                   ],
                ),
                const SizedBox(height: 2),
                Text(dateStr.toUpperCase(), style: TextStyle(fontSize: 9, color: Colors.grey[600], fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: kGreen, width: 2)),
                  ),
                  child: Text(
                    (item.remarks == null || item.remarks == 'null' || item.remarks!.isEmpty)
                        ? 'System generated entry'
                        : item.remarks!,
                    style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                ),
                const SizedBox(height: 32),
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

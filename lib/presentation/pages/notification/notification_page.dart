import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/providers/notification_provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/utils/date_formatter.dart';


const _green = Color(0xFF3D9A7E);

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});
  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notification',
          style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 10,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationProvider.notifier).loadNotifications(refresh: true),
            child: const Text('Refresh', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SafeArea(child: notificationState.when(
        data: (notifications) {
          if (notifications.isEmpty) return _buildEmpty();
          final grouped = _group(notifications);
          return RefreshIndicator(
            color: const Color(0xFF3D9A7E),
            onRefresh: () => ref.read(notificationProvider.notifier).loadNotifications(refresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: grouped.length,
              itemBuilder: (_, i) {
                final entry = grouped.entries.elementAt(i);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 14, fontFamily: 'inter_medium', color: Colors.black),
                      ),
                    ),
                    ...entry.value.map((n) => _buildItem(n)),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 36),
              const SizedBox(height: 8),
              Text('$e', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(notificationProvider.notifier).loadNotifications(refresh: true),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF8C300), foregroundColor: Colors.white),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  // ── Group by date ─────────────────────────────────────────────────────────
  Map<String, List<NotificationModel>> _group(List<NotificationModel> items) {
    final Map<String, List<NotificationModel>> out = {};
    for (final n in items) {
      final key = _dateHeader(n.createdAt);
      out.putIfAbsent(key, () => []).add(n);
    }
    return out;
  }

  String _dateHeader(DateTime? d) {
    if (d == null) return 'Earlier';
    final today = DateTime.now();
    final dd = DateTime(d.year, d.month, d.day);
    if (dd == DateTime(today.year, today.month, today.day)) return 'Today';
    if (dd == DateTime(today.year, today.month, today.day).subtract(const Duration(days: 1))) return 'Yesterday';
    return AppDateFormatters.formatIndianDate(d);
  }


  Widget _buildItem(NotificationModel n) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _onTap(n),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9), // grey5
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/frame_1258.png', width: 38, height: 38, fit: BoxFit.fill, errorBuilder: (_, __, ___) => const Icon(Icons.notifications, size: 38)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: const TextStyle(
                              fontFamily: 'inter_medium',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          _timeAgo(n.createdAt),
                          style: const TextStyle(
                            fontFamily: 'inter_medium',
                            fontSize: 12,
                            color: Color(0xFF666768), // grey2
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      n.body,
                      style: const TextStyle(
                        fontFamily: 'inter', // regular inter
                        fontSize: 12,
                        color: Colors.black,
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
  }

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/notification.png', width: 150, height: 150, fit: BoxFit.fill),
        const SizedBox(height: 10),
        const Text('No notifications yet', style: TextStyle(fontFamily: 'inter_semibold', fontSize: 16, color: Colors.black)),
      ],
    ),
  );

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return AppDateFormatters.formatIndianDate(dt);
  }


  void _onTap(NotificationModel n) {
    final type = n.notificationType;
    final role = ref.read(currentUserProvider)?.userType.toLowerCase();

    void toList(String title, String ft) =>
      context.pushNamed('reportList', extra: {'title': title, 'filterType': ft});

    if (type == 'reassign') {
      if (role == 'aee') {
        context.pushNamed('assignToFieldEngineers', extra: {'initialTab': 1});
      } else {
        role == 'vendor' ? toList('Pending', 'pending_$role') : toList('Re-Assigned', 'reassigned_$role');
      }
    } else if (type == 'assign') {
      if (role == 'aee') {
        context.pushNamed('assignToFieldEngineers', extra: {'initialTab': 0});
      } else {
        toList('Pending Cases', 'pending_$role');
      }
    } else if (type == 'submitted') {
      if (role == 'aee') {
        context.pushNamed('reviewInspectionsAee');
      } else if (role == 'ee' || role == 'se') {
        toList('Pending Reviews', 'review_$role');
      }
    } else if (type == 'fix_confirmation') {
      if (role == 'vendor') {
        toList('Submit Final Update', 'submit_update_vendor');
      }
    } else if (type == 'vendor_arrived' || type == 'final_fix_confirmed') {
      if (role == 'aee') {
        context.pushNamed('selfInspectionAee');
      } else if (role == 'ae' || role == 'je') {
        toList('Assigned Cases', 'assigned_$role');
      } else if (role == 'vendor') {
        toList('In-Progress', 'submit_update_vendor');
      }
    } else if (type == 'completed') {
      if (role == 'aee') {
        context.pushNamed('myReportsAee', extra: {'initialTab': 'completed'});
      } else {
        toList('Completed', 'completed_$role');
      }
    } else if (type == 'rejected') {
      if (role == 'aee') {
        context.pushNamed('myReportsAee', extra: {'initialTab': 'rejected'});
      } else {
        toList('Rejected', 'rejected_$role');
      }
    } else {
      if (role == 'aee') {
        context.pushNamed('myReportsAee', extra: {'initialTab': 'assigned'});
      } else {
        toList('Assigned Cases', 'assigned_$role');
      }
    }
  }
}

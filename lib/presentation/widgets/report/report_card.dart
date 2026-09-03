import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/pothole_model.dart';
import '../../../core/utils/date_formatter.dart';


class ReportCard extends StatelessWidget {
  final PotholeModel report;
  final VoidCallback onTap;
  final Widget? actionButton;
  final String dateLabel;

  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    this.actionButton,
    this.dateLabel = 'Reported on',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Outer padding matching xml 8dp
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Report ID and Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text(
                          'Report ID: ',
                          style: TextStyle(fontFamily: 'inter_medium', fontSize: 14, color: Color(0xFF666768)),
                        ),
                        Expanded(
                          child: Text(
                            report.caseId,
                            style: const TextStyle(fontFamily: 'inter_semibold', fontSize: 14, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(report.status),
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Text(
                      _getDisplayStatus(report.status),
                      style: const TextStyle(fontFamily: 'inter_medium', fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/weui_location_filled.png', width: 16, height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.location_on, size: 16, color: Colors.black)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      report.location ?? report.roadName ?? 'Location unavailable',
                      style: const TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              
              // Date
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/mdi_calendar_outline.png', width: 16, height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.calendar_today, size: 16, color: Colors.grey)),
                  const SizedBox(width: 5),
                  Text(dateLabel, style: const TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Color(0xFF666768))),
                  Expanded(
                    child: Text(
                      _formatDate(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontFamily: 'inter_semibold', fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              
              // Assigned To (if applicable)
              if (report.assignedToName != null || report.assignedTo != null) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/map_travel_agency.png', width: 16, height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 16, color: Colors.grey)),
                    const SizedBox(width: 5),
                    const Text('Assigned to:', style: TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Color(0xFF666768))),
                    Expanded(
                      child: Text(
                        _getAssignedToText(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontFamily: 'inter_semibold', fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
              
              // Action Buttons
              const SizedBox(height: 25),
              InkWell(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFF8C300), width: 1),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontFamily: 'inter_semibold', fontSize: 14, color: Color(0xFFF8C300)),
                  ),
                ),
              ),
              if (actionButton != null) ...[
                const SizedBox(height: 10),
                actionButton!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate() {
    final targetDate = report.reportDate ?? report.createdAt;
    if (targetDate == null) return '---';
    final dateStr = AppDateFormatters.formatIndianDate(targetDate);
    final days = AppDateFormatters.pendingDays(targetDate);
    if (days > 0) {
      return '$dateStr ($days d ago)';
    }
    return dateStr;
  }


  String _getAssignedToText() {
    if (report.assignedToName != null) return report.assignedToName!;
    if (report.assignedTo != null) {
      if (report.assignedTo is String) return report.assignedTo as String;
      if (report.assignedTo is Map) {
        final name = report.assignedTo['name'];
        final designation = report.assignedTo['designation'];
        if (name != null) return designation != null ? '$name ($designation)' : name;
      }
    }
    return 'Not Assigned';
  }

  String _getDisplayStatus(String status) {
    final s = status.toLowerCase();
    if (s == 'assigned' || s == 'requested' || s == 'pending') return 'REQUESTED';
    if (s == 'accepted' || s == 'in_progress') return 'IN PROGRESS';
    return status.toUpperCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'requested':
        return const Color(0xFF8E8E93);
      case 'assigned':
        return const Color(0xFF007AFF);
      case 'inspected':
        return const Color(0xFFFF9500);
      case 'completed':
      case 'closed':
      case 'approved':
      case 'satisfied':
      case 'resolved':
        return const Color(0xFF3D9A7E);
      case 'rejected':
        return const Color(0xFFFF3B30);
      case 'reassigned':
        return const Color(0xFF5856D6);
      default:
        return Colors.black54;
    }
  }
}

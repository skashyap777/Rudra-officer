import 'package:intl/intl.dart';

/// Centralized Date Formatter for Indian Date Standard (dd-MM-yy)
class AppDateFormatters {
  AppDateFormatters._();

  static final DateFormat _indianDateOnly = DateFormat('dd-MM-yy');
  static final DateFormat _indianDateTime = DateFormat('dd-MM-yy, hh:mm a');

  /// Formats date as dd-MM-yy (e.g., 03-09-26)
  static String formatIndianDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return _indianDateOnly.format(dt.toLocal());
  }

  /// Formats date and time as dd-MM-yy, hh:mm a (e.g., 03-09-26, 03:45 PM)
  static String formatIndianDateTime(DateTime? dt) {
    if (dt == null) return 'N/A';
    return _indianDateTime.format(dt.toLocal());
  }

  /// Helper to parse ISO string or object to formatted date
  static String formatDynamic(dynamic value, {bool includeTime = true}) {
    if (value == null) return 'N/A';
    if (value is DateTime) {
      return includeTime ? formatIndianDateTime(value) : formatIndianDate(value);
    }
    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    return includeTime ? formatIndianDateTime(parsed) : formatIndianDate(parsed);
  }

  /// Returns human readable elapsed days string (e.g., "18 days ago" or "Reported 18d ago")
  static String daysAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt.toLocal());
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        final mins = diff.inMinutes;
        return mins <= 1 ? 'Just now' : '$mins mins ago';
      }
      return '${diff.inHours} hrs ago';
    }
    return '${diff.inDays} days ago';
  }

  /// Returns total days pending integer from given date
  static int pendingDays(DateTime? dt) {
    if (dt == null) return 0;
    return DateTime.now().difference(dt.toLocal()).inDays;
  }
}

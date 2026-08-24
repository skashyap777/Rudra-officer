import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

String _parseString(dynamic value) => value?.toString() ?? '';
String? _parseNullableString(dynamic value) => value?.toString();

/// Notification Model - For FCM and local notifications
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: 'title', fromJson: _parseString) @Default('') String title,
    @JsonKey(name: 'message', fromJson: _parseString) @Default('') String body,
    @JsonKey(name: 'type', fromJson: _parseString) @Default('') String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'case_no', fromJson: _parseNullableString) String? caseId,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    required int id,
    @JsonKey(name: 'user_id') int? userId,
    Map<String, dynamic>? data,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  String get notificationType {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('re-assign') || titleLower.contains('reassigned')) return 'reassign';
    if (titleLower.contains('assign')) return 'assign';
    if (titleLower.contains('submitted')) return 'submitted';
    if (titleLower.contains('completed')) return 'completed';
    if (titleLower.contains('rejected')) return 'rejected';
    if (titleLower.contains('fix confirmation')) return 'fix_confirmation';
    if (titleLower.contains('vendor arrived')) return 'vendor_arrived';
    if (titleLower.contains('final fix confirmed')) return 'final_fix_confirmed';
    return type;
  }

  bool get isAssign => type == 'assign';
  bool get isReassign => type == 'reassign';
  bool get isCompleted => type == 'completed';
  bool get isRejected => type == 'rejected';
  bool get isSubmitted => type == 'submitted';
  bool get isVendorPending => type == 'pending_vendor';
}

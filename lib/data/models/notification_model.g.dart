// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  title: json['title'] == null ? '' : _parseString(json['title']),
  body: json['message'] == null ? '' : _parseString(json['message']),
  type: json['type'] == null ? '' : _parseString(json['type']),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  caseId: _parseNullableString(json['case_no']),
  isRead: json['is_read'] as bool? ?? false,
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  data: json['data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'message': instance.body,
  'type': instance.type,
  'created_at': instance.createdAt?.toIso8601String(),
  'case_no': instance.caseId,
  'is_read': instance.isRead,
  'id': instance.id,
  'user_id': instance.userId,
  'data': instance.data,
};

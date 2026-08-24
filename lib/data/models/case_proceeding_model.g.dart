// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_proceeding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaseProceedingModelImpl _$$CaseProceedingModelImplFromJson(
  Map<String, dynamic> json,
) => _$CaseProceedingModelImpl(
  task: json['task'] as String,
  userName: json['user_name'] as String,
  userDesignation: json['user_designation'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$$CaseProceedingModelImplToJson(
  _$CaseProceedingModelImpl instance,
) => <String, dynamic>{
  'task': instance.task,
  'user_name': instance.userName,
  'user_designation': instance.userDesignation,
  'created_at': instance.createdAt.toIso8601String(),
  'remarks': instance.remarks,
};

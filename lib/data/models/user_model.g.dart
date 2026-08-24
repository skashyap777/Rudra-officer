// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      userType: json['user_type'] as String,
      designation: json['designation'] as String,
      profilePhotoLink: json['profile_photo_link'] as String?,
      address: json['address'] as String?,
      divisionName: json['division_name'] as String?,
      divisionId: (json['division_id'] as num?)?.toInt(),
      subDivisionName: json['sub_division_name'] as String?,
      subDivisionId: (json['sub_division_id'] as num?)?.toInt(),
      circleName: json['circle_name'] as String?,
      circleId: (json['circle_id'] as num?)?.toInt(),
      firstTimeLogin: json['first_time_login'] as bool? ?? false,
      token: json['token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'mobile': instance.mobile,
      'user_type': instance.userType,
      'designation': instance.designation,
      'profile_photo_link': instance.profilePhotoLink,
      'address': instance.address,
      'division_name': instance.divisionName,
      'division_id': instance.divisionId,
      'sub_division_name': instance.subDivisionName,
      'sub_division_id': instance.subDivisionId,
      'circle_name': instance.circleName,
      'circle_id': instance.circleId,
      'first_time_login': instance.firstTimeLogin,
      'token': instance.token,
      'refresh_token': instance.refreshToken,
    };

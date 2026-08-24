// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_map_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityMapPointImpl _$$ActivityMapPointImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityMapPointImpl(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  roadName: json['road_name'] as String?,
  divisionName: json['division_name'] as String?,
);

Map<String, dynamic> _$$ActivityMapPointImplToJson(
  _$ActivityMapPointImpl instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
  'road_name': instance.roadName,
  'division_name': instance.divisionName,
};

_$ActivityMapDataImpl _$$ActivityMapDataImplFromJson(
  Map<String, dynamic> json,
) => _$ActivityMapDataImpl(
  inProgress:
      (json['inProgress'] as List<dynamic>?)
          ?.map((e) => ActivityMapPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  rejected:
      (json['rejected'] as List<dynamic>?)
          ?.map((e) => ActivityMapPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  completed:
      (json['completed'] as List<dynamic>?)
          ?.map((e) => ActivityMapPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ActivityMapDataImplToJson(
  _$ActivityMapDataImpl instance,
) => <String, dynamic>{
  'inProgress': instance.inProgress,
  'rejected': instance.rejected,
  'completed': instance.completed,
};

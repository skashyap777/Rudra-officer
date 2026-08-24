import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_map_model.freezed.dart';
part 'activity_map_model.g.dart';

@freezed
class ActivityMapPoint with _$ActivityMapPoint {
  const factory ActivityMapPoint({
    required double lat,
    required double lng,
    @JsonKey(name: 'road_name') String? roadName,
    @JsonKey(name: 'division_name') String? divisionName,
  }) = _ActivityMapPoint;

  factory ActivityMapPoint.fromJson(Map<String, dynamic> json) =>
      _$ActivityMapPointFromJson(json);
}

@freezed
class ActivityMapData with _$ActivityMapData {
  const factory ActivityMapData({
    @Default([]) List<ActivityMapPoint> inProgress,
    @Default([]) List<ActivityMapPoint> rejected,
    @Default([]) List<ActivityMapPoint> completed,
  }) = _ActivityMapData;

  factory ActivityMapData.fromJson(Map<String, dynamic> json) =>
      _$ActivityMapDataFromJson(json);
}

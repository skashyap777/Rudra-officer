// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_map_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityMapPoint _$ActivityMapPointFromJson(Map<String, dynamic> json) {
  return _ActivityMapPoint.fromJson(json);
}

/// @nodoc
mixin _$ActivityMapPoint {
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'road_name')
  String? get roadName => throw _privateConstructorUsedError;
  @JsonKey(name: 'division_name')
  String? get divisionName => throw _privateConstructorUsedError;

  /// Serializes this ActivityMapPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityMapPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityMapPointCopyWith<ActivityMapPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityMapPointCopyWith<$Res> {
  factory $ActivityMapPointCopyWith(
    ActivityMapPoint value,
    $Res Function(ActivityMapPoint) then,
  ) = _$ActivityMapPointCopyWithImpl<$Res, ActivityMapPoint>;
  @useResult
  $Res call({
    double lat,
    double lng,
    @JsonKey(name: 'road_name') String? roadName,
    @JsonKey(name: 'division_name') String? divisionName,
  });
}

/// @nodoc
class _$ActivityMapPointCopyWithImpl<$Res, $Val extends ActivityMapPoint>
    implements $ActivityMapPointCopyWith<$Res> {
  _$ActivityMapPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityMapPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? roadName = freezed,
    Object? divisionName = freezed,
  }) {
    return _then(
      _value.copyWith(
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            roadName: freezed == roadName
                ? _value.roadName
                : roadName // ignore: cast_nullable_to_non_nullable
                      as String?,
            divisionName: freezed == divisionName
                ? _value.divisionName
                : divisionName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityMapPointImplCopyWith<$Res>
    implements $ActivityMapPointCopyWith<$Res> {
  factory _$$ActivityMapPointImplCopyWith(
    _$ActivityMapPointImpl value,
    $Res Function(_$ActivityMapPointImpl) then,
  ) = __$$ActivityMapPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double lat,
    double lng,
    @JsonKey(name: 'road_name') String? roadName,
    @JsonKey(name: 'division_name') String? divisionName,
  });
}

/// @nodoc
class __$$ActivityMapPointImplCopyWithImpl<$Res>
    extends _$ActivityMapPointCopyWithImpl<$Res, _$ActivityMapPointImpl>
    implements _$$ActivityMapPointImplCopyWith<$Res> {
  __$$ActivityMapPointImplCopyWithImpl(
    _$ActivityMapPointImpl _value,
    $Res Function(_$ActivityMapPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityMapPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? lng = null,
    Object? roadName = freezed,
    Object? divisionName = freezed,
  }) {
    return _then(
      _$ActivityMapPointImpl(
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        roadName: freezed == roadName
            ? _value.roadName
            : roadName // ignore: cast_nullable_to_non_nullable
                  as String?,
        divisionName: freezed == divisionName
            ? _value.divisionName
            : divisionName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityMapPointImpl implements _ActivityMapPoint {
  const _$ActivityMapPointImpl({
    required this.lat,
    required this.lng,
    @JsonKey(name: 'road_name') this.roadName,
    @JsonKey(name: 'division_name') this.divisionName,
  });

  factory _$ActivityMapPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityMapPointImplFromJson(json);

  @override
  final double lat;
  @override
  final double lng;
  @override
  @JsonKey(name: 'road_name')
  final String? roadName;
  @override
  @JsonKey(name: 'division_name')
  final String? divisionName;

  @override
  String toString() {
    return 'ActivityMapPoint(lat: $lat, lng: $lng, roadName: $roadName, divisionName: $divisionName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityMapPointImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.roadName, roadName) ||
                other.roadName == roadName) &&
            (identical(other.divisionName, divisionName) ||
                other.divisionName == divisionName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lat, lng, roadName, divisionName);

  /// Create a copy of ActivityMapPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityMapPointImplCopyWith<_$ActivityMapPointImpl> get copyWith =>
      __$$ActivityMapPointImplCopyWithImpl<_$ActivityMapPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityMapPointImplToJson(this);
  }
}

abstract class _ActivityMapPoint implements ActivityMapPoint {
  const factory _ActivityMapPoint({
    required final double lat,
    required final double lng,
    @JsonKey(name: 'road_name') final String? roadName,
    @JsonKey(name: 'division_name') final String? divisionName,
  }) = _$ActivityMapPointImpl;

  factory _ActivityMapPoint.fromJson(Map<String, dynamic> json) =
      _$ActivityMapPointImpl.fromJson;

  @override
  double get lat;
  @override
  double get lng;
  @override
  @JsonKey(name: 'road_name')
  String? get roadName;
  @override
  @JsonKey(name: 'division_name')
  String? get divisionName;

  /// Create a copy of ActivityMapPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityMapPointImplCopyWith<_$ActivityMapPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityMapData _$ActivityMapDataFromJson(Map<String, dynamic> json) {
  return _ActivityMapData.fromJson(json);
}

/// @nodoc
mixin _$ActivityMapData {
  List<ActivityMapPoint> get inProgress => throw _privateConstructorUsedError;
  List<ActivityMapPoint> get rejected => throw _privateConstructorUsedError;
  List<ActivityMapPoint> get completed => throw _privateConstructorUsedError;

  /// Serializes this ActivityMapData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityMapData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityMapDataCopyWith<ActivityMapData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityMapDataCopyWith<$Res> {
  factory $ActivityMapDataCopyWith(
    ActivityMapData value,
    $Res Function(ActivityMapData) then,
  ) = _$ActivityMapDataCopyWithImpl<$Res, ActivityMapData>;
  @useResult
  $Res call({
    List<ActivityMapPoint> inProgress,
    List<ActivityMapPoint> rejected,
    List<ActivityMapPoint> completed,
  });
}

/// @nodoc
class _$ActivityMapDataCopyWithImpl<$Res, $Val extends ActivityMapData>
    implements $ActivityMapDataCopyWith<$Res> {
  _$ActivityMapDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityMapData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inProgress = null,
    Object? rejected = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            inProgress: null == inProgress
                ? _value.inProgress
                : inProgress // ignore: cast_nullable_to_non_nullable
                      as List<ActivityMapPoint>,
            rejected: null == rejected
                ? _value.rejected
                : rejected // ignore: cast_nullable_to_non_nullable
                      as List<ActivityMapPoint>,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as List<ActivityMapPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityMapDataImplCopyWith<$Res>
    implements $ActivityMapDataCopyWith<$Res> {
  factory _$$ActivityMapDataImplCopyWith(
    _$ActivityMapDataImpl value,
    $Res Function(_$ActivityMapDataImpl) then,
  ) = __$$ActivityMapDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ActivityMapPoint> inProgress,
    List<ActivityMapPoint> rejected,
    List<ActivityMapPoint> completed,
  });
}

/// @nodoc
class __$$ActivityMapDataImplCopyWithImpl<$Res>
    extends _$ActivityMapDataCopyWithImpl<$Res, _$ActivityMapDataImpl>
    implements _$$ActivityMapDataImplCopyWith<$Res> {
  __$$ActivityMapDataImplCopyWithImpl(
    _$ActivityMapDataImpl _value,
    $Res Function(_$ActivityMapDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityMapData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inProgress = null,
    Object? rejected = null,
    Object? completed = null,
  }) {
    return _then(
      _$ActivityMapDataImpl(
        inProgress: null == inProgress
            ? _value._inProgress
            : inProgress // ignore: cast_nullable_to_non_nullable
                  as List<ActivityMapPoint>,
        rejected: null == rejected
            ? _value._rejected
            : rejected // ignore: cast_nullable_to_non_nullable
                  as List<ActivityMapPoint>,
        completed: null == completed
            ? _value._completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as List<ActivityMapPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityMapDataImpl implements _ActivityMapData {
  const _$ActivityMapDataImpl({
    final List<ActivityMapPoint> inProgress = const [],
    final List<ActivityMapPoint> rejected = const [],
    final List<ActivityMapPoint> completed = const [],
  }) : _inProgress = inProgress,
       _rejected = rejected,
       _completed = completed;

  factory _$ActivityMapDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityMapDataImplFromJson(json);

  final List<ActivityMapPoint> _inProgress;
  @override
  @JsonKey()
  List<ActivityMapPoint> get inProgress {
    if (_inProgress is EqualUnmodifiableListView) return _inProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inProgress);
  }

  final List<ActivityMapPoint> _rejected;
  @override
  @JsonKey()
  List<ActivityMapPoint> get rejected {
    if (_rejected is EqualUnmodifiableListView) return _rejected;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejected);
  }

  final List<ActivityMapPoint> _completed;
  @override
  @JsonKey()
  List<ActivityMapPoint> get completed {
    if (_completed is EqualUnmodifiableListView) return _completed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completed);
  }

  @override
  String toString() {
    return 'ActivityMapData(inProgress: $inProgress, rejected: $rejected, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityMapDataImpl &&
            const DeepCollectionEquality().equals(
              other._inProgress,
              _inProgress,
            ) &&
            const DeepCollectionEquality().equals(other._rejected, _rejected) &&
            const DeepCollectionEquality().equals(
              other._completed,
              _completed,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_inProgress),
    const DeepCollectionEquality().hash(_rejected),
    const DeepCollectionEquality().hash(_completed),
  );

  /// Create a copy of ActivityMapData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityMapDataImplCopyWith<_$ActivityMapDataImpl> get copyWith =>
      __$$ActivityMapDataImplCopyWithImpl<_$ActivityMapDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityMapDataImplToJson(this);
  }
}

abstract class _ActivityMapData implements ActivityMapData {
  const factory _ActivityMapData({
    final List<ActivityMapPoint> inProgress,
    final List<ActivityMapPoint> rejected,
    final List<ActivityMapPoint> completed,
  }) = _$ActivityMapDataImpl;

  factory _ActivityMapData.fromJson(Map<String, dynamic> json) =
      _$ActivityMapDataImpl.fromJson;

  @override
  List<ActivityMapPoint> get inProgress;
  @override
  List<ActivityMapPoint> get rejected;
  @override
  List<ActivityMapPoint> get completed;

  /// Create a copy of ActivityMapData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityMapDataImplCopyWith<_$ActivityMapDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

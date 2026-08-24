// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  @JsonKey(name: 'title', fromJson: _parseString)
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'message', fromJson: _parseString)
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'type', fromJson: _parseString)
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'case_no', fromJson: _parseNullableString)
  String? get caseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
    NotificationModel value,
    $Res Function(NotificationModel) then,
  ) = _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'title', fromJson: _parseString) String title,
    @JsonKey(name: 'message', fromJson: _parseString) String body,
    @JsonKey(name: 'type', fromJson: _parseString) String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'case_no', fromJson: _parseNullableString) String? caseId,
    @JsonKey(name: 'is_read') bool isRead,
    int id,
    @JsonKey(name: 'user_id') int? userId,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? caseId = freezed,
    Object? isRead = null,
    Object? id = null,
    Object? userId = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            caseId: freezed == caseId
                ? _value.caseId
                : caseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(
    _$NotificationModelImpl value,
    $Res Function(_$NotificationModelImpl) then,
  ) = __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'title', fromJson: _parseString) String title,
    @JsonKey(name: 'message', fromJson: _parseString) String body,
    @JsonKey(name: 'type', fromJson: _parseString) String type,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'case_no', fromJson: _parseNullableString) String? caseId,
    @JsonKey(name: 'is_read') bool isRead,
    int id,
    @JsonKey(name: 'user_id') int? userId,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(
    _$NotificationModelImpl _value,
    $Res Function(_$NotificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? createdAt = freezed,
    Object? caseId = freezed,
    Object? isRead = null,
    Object? id = null,
    Object? userId = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$NotificationModelImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        caseId: freezed == caseId
            ? _value.caseId
            : caseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl({
    @JsonKey(name: 'title', fromJson: _parseString) this.title = '',
    @JsonKey(name: 'message', fromJson: _parseString) this.body = '',
    @JsonKey(name: 'type', fromJson: _parseString) this.type = '',
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'case_no', fromJson: _parseNullableString) this.caseId,
    @JsonKey(name: 'is_read') this.isRead = false,
    required this.id,
    @JsonKey(name: 'user_id') this.userId,
    final Map<String, dynamic>? data,
  }) : _data = data,
       super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  @JsonKey(name: 'title', fromJson: _parseString)
  final String title;
  @override
  @JsonKey(name: 'message', fromJson: _parseString)
  final String body;
  @override
  @JsonKey(name: 'type', fromJson: _parseString)
  final String type;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'case_no', fromJson: _parseNullableString)
  final String? caseId;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NotificationModel(title: $title, body: $body, type: $type, createdAt: $createdAt, caseId: $caseId, isRead: $isRead, id: $id, userId: $userId, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    body,
    type,
    createdAt,
    caseId,
    isRead,
    id,
    userId,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(this);
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel({
    @JsonKey(name: 'title', fromJson: _parseString) final String title,
    @JsonKey(name: 'message', fromJson: _parseString) final String body,
    @JsonKey(name: 'type', fromJson: _parseString) final String type,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'case_no', fromJson: _parseNullableString)
    final String? caseId,
    @JsonKey(name: 'is_read') final bool isRead,
    required final int id,
    @JsonKey(name: 'user_id') final int? userId,
    final Map<String, dynamic>? data,
  }) = _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  @JsonKey(name: 'title', fromJson: _parseString)
  String get title;
  @override
  @JsonKey(name: 'message', fromJson: _parseString)
  String get body;
  @override
  @JsonKey(name: 'type', fromJson: _parseString)
  String get type;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'case_no', fromJson: _parseNullableString)
  String? get caseId;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
